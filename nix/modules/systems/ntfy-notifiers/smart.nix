# smart-check.nix
#
# Example configuration:
#
# services.ntfyNotify.smart = {
#
#   # Enable SMART monitoring.
#   enable = true;
#
#   # ntfy server to send notifications to.
#   ntfyServer = "https://ntfy.sh";
#
#   # ntfy topic to publish notifications to.
#   ntfyTopic = "smart-alerts";
#
#   # Optional ntfy Authorization header.
#   ntfyAuthHeader = null;
#
#   # How often to run the SMART check.
#   # Uses a systemd OnCalendar expression.
#   onCalendar = "*-*-* 00/6:00:00";
#
# };
#
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.sysMods.ntfyNotify.smart;

  smartCheckScript = pkgs.writeShellApplication {
    name = "smart-check";

    runtimeInputs = with pkgs; [
      smartmontools
      util-linux
      gawk
      gnused
      coreutils
      curl
      jq
      findutils
    ];

    text = ''
      set -uo pipefail

      NTFY_SERVER="${cfg.ntfyServer}"
      NTFY_TOPIC="${cfg.ntfyTopic}"
      STATE_DIR="/var/lib/smart-ntfy-check"

      ${optionalString (cfg.ntfyAuthHeader != null)
        ''NTFY_AUTH_ARGS=(-H "Authorization: ${cfg.ntfyAuthHeader}")''}

      ${optionalString (cfg.ntfyAuthHeader == null)
        ''NTFY_AUTH_ARGS=()''}

      mkdir -p "$STATE_DIR"

      # -----------------------------------------------------------------------
      # Helpers
      # -----------------------------------------------------------------------

      send_notification() {
          local title="$1"
          local priority="$2"
          local tags="$3"
          local message="$4"

          curl -sS \
              -H "Title: $title" \
              -H "Priority: $priority" \
              -H "Tags: $tags" \
              -H "Markdown: yes" \
              --data-binary "$message" \
              "''${NTFY_AUTH_ARGS[@]}" \
              "$NTFY_SERVER/$NTFY_TOPIC" > /dev/null
      }

      state_file_for() {
          local id="$1"

          printf '%s/%s.state\n' "$STATE_DIR" \
              "$(printf '%s' "$id" | sed 's/[^A-Za-z0-9_.-]/_/g')"
      }

      # Find a stable /dev/disk/by-id identifier for a device.
      #
      # Prefer WWN/EUI identifiers, then ATA/SCSI/NVMe identifiers.
      canonical_by_id() {
          local dev="$1"
          local candidate
          local resolved

          for prefix in \
              "wwn-" \
              "nvme-eui." \
              "ata-" \
              "scsi-" \
              "nvme-"
          do
              while IFS= read -r candidate; do
                  [ -L "$candidate" ] || continue

                  resolved=$(readlink -f "$candidate" 2>/dev/null || true)

                  if [ "$resolved" = "$dev" ]; then
                      basename "$candidate"
                      return 0
                  fi
              done < <(
                  find /dev/disk/by-id \
                      -maxdepth 1 \
                      -type l \
                      -name "$prefix*" \
                      -print 2>/dev/null |
                  sort
              )
          done

          return 1
      }

      # Find the filesystem label belonging to the physical disk.
      #
      # The label is normally attached to a partition rather than the disk
      # itself, so inspect the disk and its children.
      get_drive_label() {
          local dev="$1"
          local name
          local label

          while IFS= read -r name; do
              [ -n "$name" ] || continue

              label=$(lsblk -dnro LABEL "$name" 2>/dev/null || true)

              if [ -n "$label" ]; then
                  printf '%s\n' "$label"
                  return 0
              fi
          done < <(
              lsblk -nrpo NAME "$dev" 2>/dev/null
          )

          printf '%s\n' "No label"
      }

      # -----------------------------------------------------------------------
      # ATA SMART attributes
      # -----------------------------------------------------------------------

      collect_ata() {
          local json="$1"
          local result='{}'
          local id
          local name
          local value

          for id in 5 187 188 197 198; do
              value=$(jq -r \
                  --argjson id "$id" \
                  '.ata_smart_attributes.table[]?
                   | select(.id == $id)
                   | .raw.value // 0' \
                  <<< "$json" 2>/dev/null |
                  head -n1)

              [ -n "$value" ] || value=0

              name=$(jq -r \
                  --argjson id "$id" \
                  '.ata_smart_attributes.table[]?
                   | select(.id == $id)
                   | .name // empty' \
                  <<< "$json" 2>/dev/null |
                  head -n1)

              case "$id" in
                  5)
                      [ -n "$name" ] || name="Reallocated Sector Count"
                      ;;
                  187)
                      [ -n "$name" ] || name="Reported Uncorrectable Errors"
                      ;;
                  188)
                      [ -n "$name" ] || name="Command Timeout"
                      ;;
                  197)
                      [ -n "$name" ] || name="Current Pending Sector Count"
                      ;;
                  198)
                      [ -n "$name" ] || name="Offline Uncorrectable"
                      ;;
              esac

              result=$(jq \
                  --arg key "$id" \
                  --arg name "$name" \
                  --argjson value "$value" \
                  '.[$key] = {
                      name: $name,
                      value: $value,
                      bad: ($value > 0)
                  }' \
                  <<< "$result")
          done

          # Include any additional ATA attributes which SMART itself reports
          # as currently failing.
          while IFS=$'\t' read -r id name value; do
              [ -n "$id" ] || continue

              case "$id" in
                  5|187|188|197|198)
                      continue
                      ;;
              esac

              result=$(jq \
                  --arg key "$id" \
                  --arg name "$name" \
                  --argjson value "$value" \
                  '.[$key] = {
                      name: $name,
                      value: $value,
                      bad: true
                  }' \
                  <<< "$result")
          done < <(
              jq -r '
                  .ata_smart_attributes.table[]?
                  | select(
                      (.when_failed // "-") != "-"
                      and
                      (.when_failed // "") != ""
                  )
                  | [
                      (.id | tostring),
                      (.name // "Unknown"),
                      (.raw.value // 0 | tostring)
                    ]
                  | @tsv
              ' <<< "$json" 2>/dev/null
          )

          printf '%s\n' "$result"
      }

      # -----------------------------------------------------------------------
      # NVMe SMART health
      # -----------------------------------------------------------------------

      collect_nvme() {
          local json="$1"
          local log
          local critical_warning
          local media_errors
          local spare
          local spare_threshold
          local percentage_used
          local error_entries
          local result='{}'

          log=$(jq \
              '.nvme_smart_health_information_log // {}' \
              <<< "$json")

          critical_warning=$(jq -r \
              '.critical_warning // 0' \
              <<< "$log")

          media_errors=$(jq -r \
              '.media_errors // 0' \
              <<< "$log")

          spare=$(jq -r \
              '.available_spare // 0' \
              <<< "$log")

          spare_threshold=$(jq -r \
              '.available_spare_threshold // 0' \
              <<< "$log")

          percentage_used=$(jq -r \
              '.percentage_used // 0' \
              <<< "$log")

          error_entries=$(jq -r \
              '.num_err_log_entries // 0' \
              <<< "$log")

          result=$(jq \
              --argjson value "$critical_warning" \
              '.["critical_warning"] = {
                  name: "Critical Warning",
                  value: $value,
                  bad: ($value != 0)
              }' \
              <<< "$result")

          result=$(jq \
              --argjson value "$media_errors" \
              '.["media_errors"] = {
                  name: "Media/Data Integrity Errors",
                  value: $value,
                  bad: ($value > 0)
              }' \
              <<< "$result")

          result=$(jq \
              --argjson value "$spare" \
              --argjson threshold "$spare_threshold" \
              '.["available_spare"] = {
                  name: "Available Spare",
                  value: $value,
                  threshold: $threshold,
                  bad: ($value <= $threshold)
              }' \
              <<< "$result")

          result=$(jq \
              --argjson value "$percentage_used" \
              '.["percentage_used"] = {
                  name: "Percentage Used",
                  value: $value,
                  informational: true
              }' \
              <<< "$result")

          result=$(jq \
              --argjson value "$error_entries" \
              '.["error_log_entries"] = {
                  name: "Error Information Log Entries",
                  value: $value,
                  informational: true
              }' \
              <<< "$result")

          printf '%s\n' "$result"
      }

      # -----------------------------------------------------------------------
      # Markdown formatting
      # -----------------------------------------------------------------------

      format_ata_metrics() {
          local metrics="$1"
          local previous="$2"

          local id
          local name
          local value
          local old
          local delta

          for id in 5 187 188 197 198; do
              name=$(jq -r \
                  --arg id "$id" \
                  '.[$id].name // "Unknown"' \
                  <<< "$metrics")

              value=$(jq -r \
                  --arg id "$id" \
                  '.[$id].value // 0' \
                  <<< "$metrics")

              old=""

              if [ -n "$previous" ]; then
                  old=$(jq -r \
                      --arg id "$id" \
                      '.[$id].value // empty' \
                      <<< "$previous")
              fi

              if [ -n "$old" ] && [ "$value" -gt "$old" ]; then
                  delta=$((value - old))

                  printf '%s\n' \
                      "* **ID $id — $name:** $old → $value (+$delta)"

              elif [ -n "$old" ] && [ "$value" -lt "$old" ]; then
                  delta=$((old - value))

                  printf '%s\n' \
                      "* **ID $id — $name:** $old → $value (-$delta)"

              else
                  printf '%s\n' \
                      "* **ID $id — $name:** $value"
              fi
          done

          # Additional ATA attributes currently reported as failing.
          while IFS=$'\t' read -r id name value; do
              [ -n "$id" ] || continue

              printf '%s\n' \
                  "* **ID $id — $name:** $value"

          done < <(
              jq -r '
                  to_entries[]
                  | select(
                      .key != "5"
                      and .key != "187"
                      and .key != "188"
                      and .key != "197"
                      and .key != "198"
                  )
                  | [
                      .key,
                      .value.name,
                      (.value.value | tostring)
                    ]
                  | @tsv
              ' <<< "$metrics"
          )
      }

      format_nvme_metrics() {
          local metrics="$1"
          local previous="$2"

          local key
          local name
          local value
          local old
          local delta
          local threshold

          for key in \
              critical_warning \
              available_spare \
              percentage_used \
              media_errors \
              error_log_entries
          do
              name=$(jq -r \
                  --arg key "$key" \
                  '.[$key].name // "Unknown"' \
                  <<< "$metrics")

              value=$(jq -r \
                  --arg key "$key" \
                  '.[$key].value // 0' \
                  <<< "$metrics")

              old=""

              if [ -n "$previous" ]; then
                  old=$(jq -r \
                      --arg key "$key" \
                      '.[$key].value // empty' \
                      <<< "$previous")
              fi

              if [ "$key" = "available_spare" ]; then
                  threshold=$(jq -r \
                      '.available_spare.threshold // 0' \
                      <<< "$metrics")

                  if [ -n "$old" ] && [ "$value" -lt "$old" ]; then
                      delta=$((old - value))

                      printf '%s\n' \
                          "* **$name:** $old%% → $value%% (-$delta), threshold: $threshold%%"
                  else
                      printf '%s\n' \
                          "* **$name:** $value%%, threshold: $threshold%%"
                  fi

              elif [ -n "$old" ] && [ "$value" -gt "$old" ]; then
                  delta=$((value - old))

                  printf '%s\n' \
                      "* **$name:** $old → $value (+$delta)"

              elif [ -n "$old" ] && [ "$value" -lt "$old" ]; then
                  delta=$((old - value))

                  printf '%s\n' \
                      "* **$name:** $old → $value (-$delta)"

              else
                  printf '%s\n' \
                      "* **$name:** $value"
              fi
          done
      }

      # -----------------------------------------------------------------------
      # Discover physical drives
      # -----------------------------------------------------------------------

      mapfile -t drives < <(
          lsblk -dnpbo NAME,TYPE,SIZE |
          awk '$2=="disk" && $3+0>0 {print $1}'
      )

      if [ ''${#drives[@]} -eq 0 ]; then
          echo "No drives found." >&2
          exit 1
      fi

      # Each drive contributes one section to the final notification.
      declare -a drive_reports=()

      urgent=false
      any_issue=false
      any_resolved=false
      successful_scans=0

      # -----------------------------------------------------------------------
      # Scan every drive
      # -----------------------------------------------------------------------

      for dev in "''${drives[@]}"; do

          drive_id=$(canonical_by_id "$dev" || true)

          if [ -z "$drive_id" ]; then
              echo "Skipping $dev: no /dev/disk/by-id identity found." >&2
              continue
          fi

          state_file=$(state_file_for "$drive_id")

          smart_json=$(smartctl -x -j "$dev" 2>/dev/null || true)

          if ! jq empty <<< "$smart_json" >/dev/null 2>&1; then
              echo "Unable to read SMART data from $dev." >&2
              continue
          fi

          successful_scans=$((successful_scans + 1))

          model=$(jq -r \
              '.model_name // .device.model_name // "Unknown device"' \
              <<< "$smart_json")

          serial=$(jq -r \
              '.serial_number // "Unknown"' \
              <<< "$smart_json")

          protocol=$(jq -r \
              '.device.protocol // "Unknown"' \
              <<< "$smart_json")

          device_type=$(jq -r \
              '.device.type // ""' \
              <<< "$smart_json")

          label=$(get_drive_label "$dev")

          if [ "$device_type" = "nvme" ] || [ "$protocol" = "NVMe" ]; then
              drive_kind="NVMe SSD"
              metrics=$(collect_nvme "$smart_json")
              metric_type="nvme"
          else
              rotation_rate=$(jq -r \
                  '.rotation_rate // 0' \
                  <<< "$smart_json")

              if [ "$rotation_rate" = "0" ]; then
                  drive_kind="SATA SSD"
              else
                  drive_kind="HDD"
              fi

              metrics=$(collect_ata "$smart_json")
              metric_type="ata"
          fi

          smart_passed=$(jq -r \
              '.smart_status.passed // true' \
              <<< "$smart_json")

          # -------------------------------------------------------------------
          # Current issue state
          # -------------------------------------------------------------------

          has_issue=false

          while IFS= read -r bad; do
              if [ "$bad" = "true" ]; then
                  has_issue=true
                  break
              fi
          done < <(
              jq -r \
                  'to_entries[] | .value.bad // false' \
                  <<< "$metrics"
          )

          if [ "$smart_passed" != "true" ]; then
              has_issue=true
          fi

          # -------------------------------------------------------------------
          # Previous state
          # -------------------------------------------------------------------

          previous_metrics="{}"
          previous_issue=false

          if [ -f "$state_file" ]; then
              previous_metrics=$(jq -c \
                  '.metrics // {}' \
                  "$state_file" 2>/dev/null || echo '{}')

              previous_issue=$(jq -r \
                  '.has_issue // false' \
                  "$state_file" 2>/dev/null || echo false)
          fi

          # -------------------------------------------------------------------
          # Determine whether an existing failure has worsened
          # -------------------------------------------------------------------

          increased=false

          if [ "$metric_type" = "ata" ]; then

              for id in 5 187 188 197 198; do
                  current=$(jq -r \
                      --arg id "$id" \
                      '.[$id].value // 0' \
                      <<< "$metrics")

                  previous=$(jq -r \
                      --arg id "$id" \
                      '.[$id].value // 0' \
                      <<< "$previous_metrics")

                  if [ "$current" -gt "$previous" ]; then
                      increased=true
                  fi
              done

          else

              # Critical Warning increasing is worse.
              current=$(jq -r \
                  '.critical_warning.value // 0' \
                  <<< "$metrics")

              previous=$(jq -r \
                  '.critical_warning.value // 0' \
                  <<< "$previous_metrics")

              if [ "$current" -gt "$previous" ]; then
                  increased=true
              fi

              # Media/data integrity errors increasing is worse.
              current=$(jq -r \
                  '.media_errors.value // 0' \
                  <<< "$metrics")

              previous=$(jq -r \
                  '.media_errors.value // 0' \
                  <<< "$previous_metrics")

              if [ "$current" -gt "$previous" ]; then
                  increased=true
              fi

              # Available spare decreasing is worse.
              current=$(jq -r \
                  '.available_spare.value // 100' \
                  <<< "$metrics")

              previous=$(jq -r \
                  '.available_spare.value // 100' \
                  <<< "$previous_metrics")

              if [ "$current" -lt "$previous" ]; then
                  increased=true
              fi
          fi

          # -------------------------------------------------------------------
          # Determine overall notification severity
          # -------------------------------------------------------------------

          if [ "$has_issue" = "true" ]; then
              any_issue=true

              if [ "$previous_issue" = "false" ]; then
                  urgent=true
              elif [ "$increased" = "true" ]; then
                  urgent=true
              fi

          elif [ "$previous_issue" = "true" ]; then
              any_resolved=true
          fi

          # -------------------------------------------------------------------
          # Build Markdown for this drive
          # -------------------------------------------------------------------

          report="### "

          if [ "$has_issue" = "true" ]; then
              report+="🚨 "
          else
              report+="✅ "
          fi

          report+="$dev"

          if [ "$label" != "No label" ]; then
              report+=" — **$label**"
          fi

          report+=$'\n\n'

          report+="| Property | Value |"
          report+=$'\n'
          report+="| --- | --- |"
          report+=$'\n'

          report+="| Device | \`$dev\` |"
          report+=$'\n'

          report+="| Label | **$label** |"
          report+=$'\n'

          report+="| Persistent ID | \`$drive_id\` |"
          report+=$'\n'

          report+="| Model | $model |"
          report+=$'\n'

          report+="| Serial | \`$serial\` |"
          report+=$'\n'

          report+="| Type | $drive_kind |"
          report+=$'\n'

          report+="| SMART Health | "

          if [ "$smart_passed" = "true" ]; then
              report+="PASSED"
          else
              report+="**FAILED**"
          fi

          report+=" |"
          report+=$'\n\n'

          if [ "$metric_type" = "ata" ]; then
              report+="**SMART Attributes**"
              report+=$'\n\n'

              report+="$(format_ata_metrics "$metrics" "$previous_metrics")"

          else
              report+="**NVMe Health**"
              report+=$'\n\n'

              report+="$(format_nvme_metrics "$metrics" "$previous_metrics")"
          fi

          if [ "$previous_issue" = "true" ] && [ "$has_issue" = "false" ]; then

              report+=$'\n\n'
              report+="> ✅ **Resolved:** all monitored failure indicators are healthy again."

          elif [ "$has_issue" = "true" ]; then

              report+=$'\n\n'
              report+="> ⚠️ **Issue detected:** one or more monitored health indicators are outside the healthy range."

              if [ "$increased" = "true" ]; then
                  report+=$'\n'
                  report+=">"
                  report+=$'\n'
                  report+="> 🚨 **At least one failure indicator has increased since the previous check.**"
              fi
          fi

          drive_reports+=("$report")

          # -------------------------------------------------------------------
          # Save state
          # -------------------------------------------------------------------

          tmp_state="''${state_file}.tmp"

          jq -n \
              --arg id "$drive_id" \
              --arg device "$dev" \
              --arg model "$model" \
              --arg serial "$serial" \
              --arg kind "$drive_kind" \
              --argjson issue "$has_issue" \
              --argjson metrics "$metrics" \
              '{
                  drive_id: $id,
                  device: $device,
                  model: $model,
                  serial: $serial,
                  kind: $kind,
                  has_issue: $issue,
                  metrics: $metrics
              }' > "$tmp_state"

          mv -f "$tmp_state" "$state_file"

      done

      # -----------------------------------------------------------------------
      # Build ONE notification containing every drive
      # -----------------------------------------------------------------------

      if [ "$urgent" = "true" ]; then
          title="🚨 SMART health alert"
          priority="urgent"
          tags="rotating_light"

      elif [ "$any_issue" = "true" ]; then
          title="SMART health report — issues present"
          priority="default"
          tags="warning"

      elif [ "$any_resolved" = "true" ]; then
          title="SMART health report — issue resolved"
          priority="default"
          tags="white_check_mark"

      else
          title="SMART health report"
          priority="default"
          tags="white_check_mark"
      fi

      message="# $title"
      message+=$'\n\n'

      message+="**Drives scanned:** $successful_scans"
      message+=$'\n\n'

      for report in "''${drive_reports[@]}"; do
          message+="$report"
          message+=$'\n\n'
          message+="---"
          message+=$'\n\n'
      done

      send_notification "$title" "$priority" "$tags" "$message"

      echo "$title"
      echo "Drives scanned: $successful_scans"
    '';
  };

in
{
  options.sysMods.ntfyNotify.smart = {
    enable = mkEnableOption
      "periodic SMART health monitoring with ntfy notifications";

    ntfyServer = mkOption {
      type = types.str;
      default = "https://ntfy.sh";
      description = "ntfy server base URL.";
    };

    ntfyTopic = mkOption {
      type = types.str;
      example = "my-smart-alerts";
      description = "ntfy topic to publish notifications to.";
    };

    ntfyAuthHeader = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "Bearer tk_xxxxxxxxxxxx";
      description = ''
        Optional Authorization header for ntfy.
        For example: "Bearer <token>" or "Basic <base64>".
      '';
    };

    onCalendar = mkOption {
      type = types.str;
      default = "*-*-* 00/6:00:00";
      description = ''
        systemd OnCalendar expression.
        Default: every 6 hours at 00:00, 06:00, 12:00, and 18:00.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.smart-ntfy-check = {
      description = "SMART health check with ntfy notification";

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${smartCheckScript}/bin/smart-check";
        User = "root";
        StateDirectory = "smart-ntfy-check";
      };
    };

    systemd.timers.smart-ntfy-check = {
      description = "Run SMART health check";

      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnCalendar = cfg.onCalendar;
        Persistent = true;
        RandomizedDelaySec = "5m";
      };
    };
  };
}
