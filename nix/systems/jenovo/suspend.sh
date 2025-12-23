# https://github.com/bneils/yoga-slim-7i-aura-suspend

# Only tested for:
# Lenovo Yoga Slim 7i Aura Edition
# KDE Plasma (Wayland) in OpenSUSE Tumbleweed

# Disable suspend, hibernate, and lock behavior in Plasma's settings.
# Modify globals in listen-suspend then run install.sh to create the systemd service.
# If you configured the script to enter hibernation, then allocate a swap paging file.


PATH="/run/current-system/sw/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin"

BATTERY_STATUS_PATH="/sys/class/power_supply/BAT0/status"
KBD_BRIGHTNESS_FILE="/sys/class/leds/platform::kbd_backlight/brightness"
SLEEPING=0
WIFI_ENABLED=
BT_ENABLED=
KB_BACKLIGHT=
STANDBY_DRAIN_START=-1
EXTEND_TIMER_FILE="/dev/shm/extend-timer-4865"

# the amount of time to wait in idle before entering hibernation
# set this to zero (0) to disable this entirely.
HIBERNATE_TIMER_MINS=2880
# set SWAP_WHEN_HIBERNATE to 1, to enable/disable swap before/after hibernation
SWAP_WHEN_HIBERNATE=0
# If SWAP_WHEN_HIBERNATE=1, then SWAP_DEV is used.
SWAP_DEV=""

# Since this script doesn't modify the filesystem (afaik), the -e option is omitted.
# This is because there are some quite crucial commands that return harmless error codes,
# that would otherwise cause this script to exit
# It's also used in a lot of my functions to avoid the use of subshells, which don't affect the parent environment
set -uo pipefail

if [ "$EUID" -eq 0 ]; then
	echo "You shouldn't run this as root." >&2
	exit 1
fi

# Writes to stderr when program isn't available and exits
# Writes to /dev/null when program is available
{ which rfkill && which brightnessctl && which loginctl && which niri || exit 1; } >/dev/null

if [ ! -f "$KBD_BRIGHTNESS_FILE" ] ; then
	echo Could not find the keyboard brightness file.
	exit 1
fi

echo_if_debug() {
	[ "${DEBUG:-0}" -eq 1 ] && echo "$1"
	return 0
}

# check_timer() : output "1" if the timer needs to be extended, output "0" otherwise
# the function that calls check_timer() must save its output since the internal file
# it checks is consumed immediately.
check_timer() {
	if [ -f "$EXTEND_TIMER_FILE" ]; then
		rm "$EXTEND_TIMER_FILE"
		echo 1
	else
		echo 0
	fi
}

_is_radio_blocked() {
	if rfkill list "$1" | grep -q "Soft blocked: no"; then
		echo "enabled"
	else
		echo "disabled"
	fi
}

_KBD_BRIGHTNESS=
_set_backlight() {
	# brightnessctl is needed to change the backlight w/o root
	declare -g _KBD_BRIGHTNESS
	_KBD_BRIGHTNESS="$1"
	brightnessctl s "$1" -d "platform::kbd_backlight" >/dev/null
}

save_backlight() {
	brightnessctl -s -d "platform::kbd_backlight" >/dev/null
}

restore_backlight() {
	brightnessctl -r -d "platform::kbd_backlight" >/dev/null
}

_get_backlight() {
	declare -g "_KBD_BRIGHTNESS"
	# Sometimes works, sometimes doesn't.
	# Guaranteed to just output `0` after the first read, so cache it instead
	# Now let's hope it doesn't output `0` on the first read...
	if [ "$_KBD_BRIGHTNESS" == "" ]; then
		out=$(brightnessctl g -d platform::kbd_backlight)
		declare -g _KBD_BRIGHTNESS
		_KBD_BRIGHTNESS="$out"
	fi
	echo "$_KBD_BRIGHTNESS"
}

is_discharging() {
	status=$(cat "$BATTERY_STATUS_PATH")
	[ "$status" = "Discharging" ]
}

update_standby_drain_start() {
	declare -g STANDBY_DRAIN_START

	if [ "${1:-}" = "start" ]; then
		echo_if_debug "update_standby_drain_start: if start"
		# This branch is the same as the second one EXCEPT it overwrites
		# the amount of time elapsed. If we ran this branch all the time, the variable would be useless.
		if is_discharging
		then STANDBY_DRAIN_START="$SECONDS"
		else STANDBY_DRAIN_START=-1
		fi
	else
		echo_if_debug "update_standby_drain_start: else"
		# This second piece of code is run during the hibernation sleep loop.
		# It is meant to update the drain status AFTER sleep has been entered.
		# However, it won't overwrite a positive value if already discharging, therefore keeping score.
		if ! is_discharging
		then STANDBY_DRAIN_START=-1
		elif [ "$STANDBY_DRAIN_START" -eq -1 ]
		then STANDBY_DRAIN_START="$SECONDS"
		fi
	fi
}

_suspend() {
	# Check if already in custom sleep state
	if [ "$SLEEPING" -eq 1 ]; then
		return 0
	fi

	echo_if_debug "Entered sleep"

	declare -g SLEEPING
	declare -g KB_BACKLIGHT
	declare -g WIFI_ENABLED
	declare -g BT_ENABLED
	declare -g STANDBY_DRAIN_START

	update_standby_drain_start start

	SLEEPING=1
	#KB_BACKLIGHT=$(_get_backlight)
	save_backlight
	WIFI_ENABLED=$(_is_radio_blocked wifi)
	BT_ENABLED=$(_is_radio_blocked bluetooth)

	echo_if_debug "Read kb backlight: $KB_BACKLIGHT"

	rfkill block wifi
	rfkill block bluetooth
	_set_backlight 0
  niri msg output eDP-1 off
	loginctl lock-session
}

unblock_if_blocked_prev() {
	if [ "$1" == "enabled" ]; then
		rfkill unblock "$2"
	fi
}

_wake() {
	declare -g SLEEPING
	declare -g WIFI_ENABLED
	declare -g BT_ENABLED
	declare -g KB_BACKLIGHT

	if [ "$SLEEPING" -eq 0 ]; then
		return 0
	fi

	SLEEPING=0

	echo_if_debug "Entered wake"

  niri msg output eDP-1 on

	unblock_if_blocked_prev "$WIFI_ENABLED" "wifi"
	unblock_if_blocked_prev "$BT_ENABLED" "bluetooth"

	restore_backlight
	# Restore keyboard backlight
	#if [ ! "$KB_BACKLIGHT" = "" ]; then
	#	_set_backlight "$KB_BACKLIGHT"

	#	echo_if_debug "Read backlight as $(_get_backlight)"
	#	brightnessctl s "$1" -d "platform::kbd_backlight" >/dev/null
	#fi
}

# can_hibernate() : returns whether the computer has been in standby for long enough to hibernate
# params: none
# returns: an exit status of 0 if it can hibernate or 1 if it shouldn't hibernate
can_hibernate() {
	declare -g SLEEPING
	declare -g HIBERNATE_TIMER_MINS
	declare -g STANDBY_DRAIN_START
	if [ "$SLEEPING" -ne 1 ] || [ "$HIBERNATE_TIMER_MINS" -eq 0 ] || [ "$STANDBY_DRAIN_START" -eq -1 ] ; then
		return 1
	fi
	
	elapsed_mins=$(("($SECONDS - $STANDBY_DRAIN_START) / 60"))
	[ "$elapsed_mins" -ge "$HIBERNATE_TIMER_MINS" ]
	status=$?
	return $status
}

block_on_sysclock() {
	# https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html
	# SECONDS - "The number of seconds at shell invocation and the current time
	# are always determined by querying the system clock at one-second resolution"
	block_time="$1"
	start="$SECONDS"
	while true; do
		diff="$((SECONDS-start))"
		if [ "$diff" -ge "$block_time" ]; then
			break
		fi
		sleep 0.5
	done
}

# wait_hibernate() : put the computer to hibernation if can_hibernate() says so, and updates drain variable.
# params: none
# returns: none
wait_hibernate() {
	declare -g STANDBY_DRAIN_START
	declare -g SLEEPING

	if [ "$SLEEPING" -eq 1 ] ; then
		echo_if_debug "wait_hibernate: time=$SECONDS, DRAIN_START=$STANDBY_DRAIN_START"
		update_standby_drain_start
	fi

	if [ "$(check_timer)" -eq 1 ] && [ "$STANDBY_DRAIN_START" -ne -1 ]; then
		echo_if_debug "Extending standby."
		STANDBY_DRAIN_START=$(("$STANDBY_DRAIN_START+60"))
	fi

	if can_hibernate
	then
		echo_if_debug "Entering hibernation."
		if [ "$SWAP_WHEN_HIBERNATE" -eq 1 ] ; then
			echo_if_debug "Enabling swap."
			swapon "$SWAP_DEV"
		fi
		# systemctl(1): "It will not wait for the hibernate/thaw cycle to complete."
		# Unfortunately, the --wait option does not work with hibernate.
		systemctl hibernate
		status=$?
		if [ "$status" -ne 0 ]; then
			echo_if_debug "Hibernation failed. Check your swap file."
		fi

		# Expectation is that there are at least X seconds from the point that a computer
		# queues hibernation to when it resumes from hibernation, but that hibernate takes less time
		# to shutdown. This relies on the system clock rather than the monotonic clock used in sleep.
		block_on_sysclock 15

		echo_if_debug "Left hibernation at time=$SECONDS."
		if [ "$SWAP_WHEN_HIBERNATE" -eq 1 ] ; then
			echo_if_debug "Disabling swap."
			if ! swapoff "$SWAP_DEV"; then
				echo_if_debug "Swapoff failed. Retrying."
				sleep 1
				if ! swapoff "$SWAP_DEV"; then
					echo_if_debug "Swapoff failed. Abort."
				fi
			fi
		fi
		_wake
	fi
}

timer() {
	while true; do
		echo "TICK"
		sleep 10
	done
}

listen_for_events() {
	dbus-monitor --system "type='signal',path=/org/freedesktop/UPower" 2>&1 | grep --line-buffered -A1 LidIsClosed
}


# Begin listening for lid events
{
	listen_for_events &
	timer &
	wait
} | while read -r line
do
    case "$line" in
        *"boolean true"*) _suspend;;
        *"boolean false"*) _wake;;
        *"TICK"*) wait_hibernate;;
    esac
done
