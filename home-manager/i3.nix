{ config, lib, pkgs, ... }:

let mod = "Mod4";
in {
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;

      defaultWorkspace = "workspace number 1";

      keybindings = lib.mkOptionDefault {
        "${mod}+p" = "exec ${pkgs.dmenu}/bin/dmenu_run";
        "${mod}+x" =
          "exec sh -c '${pkgs.maim}/bin/maim -s | xclip -selection clipboard -t image/png'";
        "${mod}+Shift+x" =
          "exec sh -c '${pkgs.i3lock}/bin/i3lock -c 222222 & sleep 5 && xset dpms force of'";

        # Focus
        "${mod}+j" = "focus left";
        "${mod}+k" = "focus down";
        "${mod}+l" = "focus up";
        "${mod}+semicolon" = "focus right";

        # Move
        "${mod}+Shift+j" = "move left";
        "${mod}+Shift+k" = "move down";
        "${mod}+Shift+l" = "move up";
        "${mod}+Shift+semicolon" = "move right";

        "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";
        "${mod}+Shift+Return" = "exec ${pkgs.brave}/bin/brave";

        "XF86AudioRaiseVolume" =
          "exec --no-startup-id wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" =
          "exec --no-startup-id wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" =
          "exec --no-startup-id wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute" =
          "exec --no-startup-id wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      };
      startup = [{
        command =
          "${pkgs.feh}/bin/feh --bg-fill ~/wallpaper-CS2420.jpg wallpaper-AW3420.jpg";
        always = true;
        notification = false;
      }];

      bars = [{
        colors.background = "#282828";
        colors.focusedWorkspace = {
          border = "#ebdbb2";
          background = "#458588";
          text = "#ebdbb2";
        };
        fonts = {
          names = [ "PowerlineSymbols" ];
          size = 9.1;
        };
        position = "top";
        statusCommand =
          "${pkgs.i3status-rust}/bin/i3status-rs ${./i3status-rust.toml}";
      }];
    };
    extraConfig = ''
      default_border pixel 0
      default_floating_border pixel 0
      gaps inner 3
      gaps outer 1'';
  };
}
