
PATH=/run/current-system/sw/bin:$PATH

# Configuration variables (multiple MAC addresses separated by |)
HOME_MAC="94:83:c4:b0:bb:08"
WG_INTERFACE="wg0"
NETWORK_PREFIXES="enp|eth|wlp|wlan"  # Prefixes for network interfaces

# Get current router MAC address (default gateway)
echo "Getting MAC"
CURRENT_MAC=$(ip route | grep default | awk '{print $3}' | xargs -I {} arp -n {} | awk '/ether/ {print $3}')

echo "Getting Network Active"
# Check if at least one network interface with the desired prefixes is active
NETWORK_ACTIVE=$(ip link show | grep -E "state UP" | grep -E "$NETWORK_PREFIXES" | wc -l)

# Main logic for enabling/disabling
if [ "$NETWORK_ACTIVE" -eq 0 ]; then
    echo "No active network connection. WireGuard will not be activated."
else
    if echo "$CURRENT_MAC" | grep -Eq "$HOME_MAC"; then
        echo "Home network detected, disabling wireguard interface"
        wg-quick down $WG_INTERFACE
    else
        echo "Non-Home network detected, enabling wireguard interface"
        wg-quick up $WG_INTERFACE
    fi
fi
