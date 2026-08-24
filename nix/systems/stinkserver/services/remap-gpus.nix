{...}: {
  # Devices (like card0, card1, renderd128, etc) can swap places upon reboot
  # The best way to handle this would be to 
  services.udev.extraRules = ''
    SUBSYSTEM=="drm", SYMLINK=="dri/by-path/pci-0000:07:00.0-render", SYMLINK+="dri/intel-A380-render"
    SUBSYSTEM=="drm", SYMLINK=="dri/by-path/pci-0000:07:00.0-card", SYMLINK+="dri/intel-A380-card"
    SUBSYSTEM=="drm", SYMLINK=="dri/by-path/pci-0000:09:00.0-render", SYMLINK+="dri/nvidia-3090-render"
    SUBSYSTEM=="drm", SYMLINK=="dri/by-path/pci-0000:09:00.0-card", SYMLINK+="dri/nvidia-3090-card"
  '';
}
