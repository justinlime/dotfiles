{ pkgs, lib, username, self, ... }:
let
  script = pkgs.writeShellScriptBin "yoga-speakers" ''
    # Some distros don't have i2c-dev module loaded by default, so we load it manually
    modprobe i2c-dev

    clear
    # Function to find the correct I2C bus (third DesignWare adapter)
    find_i2c_bus() {
        local adapter_description="Synopsys DesignWare I2C adapter"
        local dw_count=$(i2cdetect -l | grep -c "$adapter_description")
        if [ "$dw_count" -lt 3 ]; then
            echo "Error: Less than 3 DesignWare I2C adapters found." >&2
            return 1
        fi
        local bus_number=$(i2cdetect -l | grep "$adapter_description" | awk '{print $1}' | sed 's/i2c-//' | sed -n '3p')
        echo "$bus_number"
    }
    i2c_bus=$(find_i2c_bus)
    if [ -z "$i2c_bus" ]; then
        echo "Error: Could not find the third DesignWare I2C bus for the audio IC."
        exit 1
    fi
    echo "Using I2C bus: $i2c_bus"
    i2c_addr=(0x3f 0x38)

    count=0
    for value in "''\${i2c_addr[@]}"; do
        val=$((count % 2))
        i2cset -f -y "$i2c_bus" "$value" 0x00 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x7f 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x01 0x01
        i2cset -f -y "$i2c_bus" "$value" 0x0e 0xc4
        i2cset -f -y "$i2c_bus" "$value" 0x0f 0x40
        i2cset -f -y "$i2c_bus" "$value" 0x5c 0xd9
        i2cset -f -y "$i2c_bus" "$value" 0x60 0x10
        if [ $val -eq 0 ]; then
            i2cset -f -y "$i2c_bus" "$value" 0x0a 0x1e
        else
            i2cset -f -y "$i2c_bus" "$value" 0x0a 0x2e
        fi
        i2cset -f -y "$i2c_bus" "$value" 0x0d 0x01
        i2cset -f -y "$i2c_bus" "$value" 0x16 0x40
        i2cset -f -y "$i2c_bus" "$value" 0x00 0x01
        i2cset -f -y "$i2c_bus" "$value" 0x17 0xc8
        i2cset -f -y "$i2c_bus" "$value" 0x00 0x04
        i2cset -f -y "$i2c_bus" "$value" 0x30 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x31 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x32 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x33 0x01

        i2cset -f -y "$i2c_bus" "$value" 0x00 0x08
        i2cset -f -y "$i2c_bus" "$value" 0x18 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x19 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x1a 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x1b 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x28 0x40
        i2cset -f -y "$i2c_bus" "$value" 0x29 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x2a 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x2b 0x00

        i2cset -f -y "$i2c_bus" "$value" 0x00 0x0a
        i2cset -f -y "$i2c_bus" "$value" 0x48 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x49 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x4a 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x4b 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x58 0x40
        i2cset -f -y "$i2c_bus" "$value" 0x59 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x5a 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x5b 0x00

        i2cset -f -y "$i2c_bus" "$value" 0x00 0x00
        i2cset -f -y "$i2c_bus" "$value" 0x02 0x00
        count=$((count + 1))
    done
  '';
in
{
  environment.systemPackages = [
    pkgs.i2c-tools
    pkgs.easyeffects
    script
  ];
  systemd.services.yoga-speakers = {
    description = "Fix the speakers on my yoga";
    path = [ script ];
    environment = lib.mkForce { PATH = "/run/wrappers/bin:/root/.local/bin:/root/.nix-profile/bin:/nix/profile/bin:/root/.local/state/nix/profile/bin:/etc/profiles/per-user/root/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"; };
    serviceConfig = {
      User = "root";  
      Type = "oneshot";
      ExecStart = "${script}/bin/yoga-speakers";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
