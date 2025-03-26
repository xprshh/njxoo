{ config, pkgs, lib, ... }:

{
  # Enable thermald for better thermal management
  services.thermald.enable = true;

  # Enable periodic trimming for Ext4 SSD
  services.fstrim.enable = true;

  systemd.sleep.extraConfig = ''
    SuspendState=mem
    HibernateState=disk
  '';

  # Kernel optimizations
  boot.kernel.sysctl = {
    "vm.laptop_mode" = 10;
    "vm.dirty_writeback_centisecs" = 3000;
  };

  # Enable X11 server (if using Xorg)
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "intel" ];  # Remove if using Wayland


  # Install power-saving utilities
  environment.systemPackages = with pkgs; [
    powertop`
    acpi
    pciutils
    ethtool
    wayland-utils
    lm_sensors
  ];
}
