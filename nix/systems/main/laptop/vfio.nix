{ config, lib, pkgs, inputs, ... }:
{
	boot = { 
		kernelParams = [
			"amd_iommu=on"
			"iommu=pt"
			#"vfio-pci.ids=1002:73bf,1002:ab28"
		];
		initrd.kernelModules = [ "vfio_pci" "vfio_iommu_type1" "vfio_virqfd" "amdgpu" ];
		kernelModules = [ "kvm-amd" ];
	};
	virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };
	users.users.justinlime = {
		extraGroups = [ "libvirtd" "kvm" "input" ];
	};
	systemd.services.libvirtd = {
    path = let
             env = pkgs.buildEnv {
               name = "qemu-hook-env";
               paths = with pkgs; [
                 bash
                 libvirt
                 kmod
                 systemd
                 ripgrep
                 sd
               ];
             };
           in
           [ env ];

    preStart =
    ''
      mkdir -p /var/lib/libvirt/hooks
			mkdir -p /var/lib/libvirt/vgabios

      mkdir -p /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin
      mkdir -p /var/lib/libvirt/hooks/qemu.d/win10/release/end
			
			mkdir -p /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin
      mkdir -p /var/lib/libvirt/hooks/qemu.d/win11/release/end

      
      ln -sf ${inputs.self}/nix/lib/vfio_scripts/qemu /var/lib/libvirt/hooks/qemu
      ln -sf ${inputs.self}/nix/lib/vfio_scripts/kvm.conf /var/lib/libvirt/hooks/kvm.conf
			ln -sf ${inputs.self}/nix/lib/vfio_scripts/6800_vbios.rom /var/lib/libvirt/vgabios/4700u_vbios.rom
			
			ln -sf ${inputs.self}/nix/lib/vfio_scripts/laptop/start.sh /var/lib/libvirt/hooks/qemu.d/win11/prepare/begin/start.sh
      ln -sf ${inputs.self}/nix/lib/vfio_scripts/laptop/stop.sh /var/lib/libvirt/hooks/qemu.d/win11/release/end/stop.sh

			ln -sf ${inputs.self}/nix/lib/vfio_scripts/start.sh /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin/start.sh
      ln -sf ${inputs.self}/nix/lib/vfio_scripts/stop.sh /var/lib/libvirt/hooks/qemu.d/win10/release/end/stop.sh

    '';
  };
}
