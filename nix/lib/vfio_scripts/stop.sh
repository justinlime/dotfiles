#!/run/current-system/sw/bin/bash

# Debugging
exec 19>/home/justinlime/Desktop/stoplogfile
BASH_XTRACEFD=19
set -x

# Load variables we defined
source "/var/lib/libvirt/hooks/kvm.conf"


# Attach GPU devices from host
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO

# Unload vfio module
modprobe -r vfio-pci

# Load AMD kernel modules
modprobe amdgpu

# Bind EFI Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind

# Bind VTconsoles
echo 1 > /sys/class/vtconsole/vtcon0/bind
echo 1 > /sys/class/vtconsole/vtcon1/bind

# Start display manager
systemctl start display-manager.service
