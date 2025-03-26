{ config, pkgs, lib, ... }:

{
  # Enable thermald for better thermal management
  services.thermald.enable = true;

  boot.kernelParams = [
    "intel_pstate=passive"
    "pcie_aspm=force"
    "usbcore.autosuspend=1"
    "acpi_osi=Linux"
    "acpi_backlight=vendor"
    "mem_sleep_default=deep"
    "intel_idle.max_cstate=9"  # Check highest C-state for your CPU
    "rcu_nocbs=0-7"  # Change 0-7 based on `nproc` output
    "nmi_watchdog=0"
    "i915.enable_fbc=1"
    "i915.enable_psr=1"
    "i915.enable_rc6=3"  # 3 is max documented value
  ];

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;  # Saves power by default

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

  # Enable TLP for better battery life
  services.tlp.enable = true;

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
