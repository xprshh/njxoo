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

  # Install power-saving utilities
  environment.systemPackages = with pkgs; [
    powertop
    acpi
    pciutils
    ethtool
    wayland-utils
    lm_sensors
  ];
}
