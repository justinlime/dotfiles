#!/run/current-system/sw/bin/bash

# Debugging
exec 19>/home/justinlime/Desktop/startlogfile
BASH_XTRACEFD=19
set -x

# Load variables we defined
source "/var/lib/libvirt/hooks/kvm.conf"

# Stop display manager
systemctl stop display-manager.service

killall gdm-wayland-session

# Unbind VTconsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# Unbind EFI Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# Avoid race condition
sleep 5

# Unload AMD kernel modules
modprobe -r amdgpu

# Detach GPU devices from host
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO

# Load vfio module
modprobe vfio
modprobe vfio-pci
modprobe vfio_iommu_type1 
