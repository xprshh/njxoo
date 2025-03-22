{ config, pkgs, ... }:

{
  # Installing the osu-lazer game
  environment.systemPackages = with pkgs; [
    osu-lazer-bin
  ];

  # Enable hardware graphics acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # This enables 32-bit graphics support for compatibility
  };

  # Enabling Gamescope, a tool for optimizing gaming
  programs.gamescope.enable = true;

  # Configuring the X server for video drivers and modesetting
  services.xserver.videoDrivers = ["modesetting"];

  services.xserver.deviceSection = ''
    Driver "modesetting"
    Option "TearFree" "true"  # Enables TearFree option to prevent screen tearing
  '';

  # Enable the xpadneo driver for Xbox One wireless controllers
  hardware.xpadneo.enable = true;

  # Configure the boot options
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
    extraModprobeConfig = ''
      options bluetooth disable_ertm=Y  # Disables Enhanced Re-Transmit Mode for Bluetooth
    '';
  };
}
