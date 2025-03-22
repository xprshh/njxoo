{ inputs, config, pkgs, ... }: {
  home.packages = with pkgs; [ xwayland xwayland-satellite-unstable ];

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable.override { src = inputs.niri-source; };
    settings = {
      input.focus-follows-mouse.enable = true;
      #input.touchpad.natural-scroll = false;

      outputs = {
        "eDP-1" = {
          position = {
            x = 0;
            y = 0;
          };
          scale = 1.3333333333333333;
          background-color = "#1e1e1e";
        };

        "HDMI-A-1" = {
          position = {
            x = 1602;
            y = 0;
          };
          scale = 1.0;
          background-color = "#1e1e1e";
        };
      };

      layout = {
        gaps = 24;

        center-focused-column = "never";
        always-center-single-column = true;

        default-column-width.proportion = 0.5;

        focus-ring.enable = false;

        border = {
          enable = true;

          width = 1;

          #active.color = "rgba(255, 255, 255, 0.07)";
          active.color = "#2c2c2c";
          inactive.color = "#242424";
        };

        insert-hint = {
          enable = true;

          display.color = "rgba(213, 97, 153, 0.25)";
        };
      };

      spawn-at-startup = [
        { command = [ "sh" "-c" "$HOME/scripts/reload-shell" ]; }
        { command = [ "fragments" ]; }
        { command = [ "ags" ]; }
        { command = [ "xwayland-satellite" "-hidpi" ]; }
        { command = [ "systemctl" "--user" "restart" "swayidle" ]; }
      ];

      environment = {
        "DISPLAY" = ":0";
        "NIXOS_OZONE_WL" = "1";
        "GDK_BACKEND" = "wayland";
        "QT_QPA_PLATFORM" = "wayland";
        "SDL_VIDEODRIVER" =
          "x11"; # a bunch of games don't really work on wayland
        "GTK_IM_MODULE" = "fcitx";
        "QT_IM_MODULE" = "fcitx";
      };

      cursor = with config.gtk.cursorTheme; {
        theme = name;
        size = size;
      };

      prefer-no-csd = true;

      hotkey-overlay.skip-at-startup = true;

      # i'll configure at some point, but for now I'm too lazy
      animations = { };

      window-rules = [
        {
          geometry-corner-radius = let radius = 10.0;
          in {
            top-left = radius;
            top-right = radius;
            bottom-left = radius;
            bottom-right = radius;
          };
          clip-to-geometry = true;
        }
        {
          matches = [{ app-id = "vesktop"; }];
          block-out-from = "screencast";
        }
        {
          matches = [{ app-id = "orca"; }];
          max-width = 576;
          max-height = 352;
        }
      ];

      binds = with config.lib.niri.actions; {
        "Mod+Return".action = spawn "footclient";
        "Mod+Shift+C".action = close-window;
        "Mod+Shift+Q".action = quit;

        "Mod+R".action = spawn [ "astal" "-t" "launcher" ];

        "Mod+Shift+R".action = spawn [ "sh" "-c" "$HOME/scripts/reload-shell" ];

        # Floating toggle
        "Mod+Space".action = toggle-window-floating;

        # Fullscreen toggle
        "Mod+F".action = fullscreen-window;

        # Volume control
        "XF86AudioMute" = {
          allow-when-locked = true;
          action = spawn [ "wpctl" "set-mute" "@DEFAULT_SINK@" "toggle" ];
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action =
            spawn [ "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_SINK@" "2.5%-" ];
        };
        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action =
            spawn [ "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_SINK@" "2.5%+" ];
        };

        # Microphone toggle
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action = spawn [ "wpctl" "set-mute" "@DEFAULT_SOURCE@" "toggle" ];
        };

        # Brightness control
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action = spawn [ "brightnessctl" "set" "2.5%-" ];
        };
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action = spawn [ "brightnessctl" "set" "2.5%+" ];
        };

        # Media controls
        "XF86AudioPlay" = {
          allow-when-locked = true;
          action = spawn [ "playerctl" "play-pause" ];
        };
        "XF86AudioPrev" = {
          allow-when-locked = true;
          action = spawn [ "playerctl" "previous" ];
        };
        "XF86AudioNext" = {
          allow-when-locked = true;
          action = spawn [ "playerctl" "next" ];
        };

        # Screenshot
        "Print".action = screenshot-screen;
        "Mod+Print".action = screenshot-window;
        "Mod+Shift+Print".action = screenshot;

        # Move focus
        "Mod+Left".action = focus-column-or-monitor-left;
        "Mod+Right".action = focus-column-or-monitor-right;
        "Mod+Up".action = focus-window-up;
        "Mod+Down".action = focus-window-down;

        "Mod+Home".action = focus-column-first;
        "Mod+End".action = focus-column-last;

        # Move windows
        "Mod+Shift+Left".action = move-column-left-or-to-monitor-left;
        "Mod+Shift+Right".action = move-column-right-or-to-monitor-right;
        "Mod+Shift+Up".action = move-window-up;
        "Mod+Shift+Down".action = move-window-down;

        "Mod+Shift+Home".action = move-column-to-first;
        "Mod+Shift+End".action = move-column-to-last;

        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;

        # Resize windows
        "Alt+Left".action = set-column-width "-10";
        "Alt+Right".action = set-column-width "+10";
        "Alt+Up".action = set-window-height "-10";
        "Alt+Down".action = set-window-height "+10";

        # Switch workspace
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;
        "Mod+0".action = focus-workspace 10;

        # Move column to workspace
        "Mod+Shift+1".action = move-column-to-workspace 1;
        "Mod+Shift+2".action = move-column-to-workspace 2;
        "Mod+Shift+3".action = move-column-to-workspace 3;
        "Mod+Shift+4".action = move-column-to-workspace 4;
        "Mod+Shift+5".action = move-column-to-workspace 5;
        "Mod+Shift+6".action = move-column-to-workspace 6;
        "Mod+Shift+7".action = move-column-to-workspace 7;
        "Mod+Shift+8".action = move-column-to-workspace 8;
        "Mod+Shift+9".action = move-column-to-workspace 9;
        "Mod+Shift+0".action = move-column-to-workspace 10;
      };
    };
  };
}
