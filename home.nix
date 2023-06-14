{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jabbslad";
  home.homeDirectory = "/home/jabbslad";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    _1password-gui

    brave
    git
    kitty
    ncdu # disk space usage analyzer
    neovim

    rustup
    font-awesome
    nerdfonts
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jabbslad/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "1password"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.zsh.enable = true;
  programs.zsh.historySubstringSearch.enable = true;
  programs.zsh.envExtra = "set -o emacs";

  programs.starship = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Jamie Atkinson";
    userEmail = "jabbslad@gmail.com";
    signing.key = null;
    signing.signByDefault = true;
  };

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      modifier = "Mod4";
      # window.border = 0;
      window.titlebar = false;
      keybindings = let modifier = config.xsession.windowManager.i3.config.modifier; in lib.mkOptionDefault {
        "${modifier}+Return" = "exec kitty";
        "${modifier}+Shift+Return" = "exec brave";
        "${modifier}+0" = "workspace number 0";
        "${modifier}+Shift+0" = "move container to workspace number 0";
      };
      bars = [
        {
          position = "top";
          trayPadding = 0;
          extraConfig = "height 16";
          fonts = {
            names = [ "Iosevka Nerd Font Mono" "Font Awesome 6 Free" ];
            size = 10.0;
          };
          #font = "pango:DejaVu Sans Mono, Font Awesome 6 Free 10";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml";
        }
      ];
    };
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      top = {
        settings = {
          theme =  {
            theme = "gruvbox-dark";
          };
          icons = {
            icons = "awesome6";
          };
        };
        blocks = [
         {
            block = "pomodoro";
            notify_cmd = "i3-nagbar -m '{msg}'";
            blocking_cmd = true;
         }
         {
           block = "cpu";
           interval = 10;
           format = " $icon $utilization ";
         }
         {
           block = "memory";
           format = " $icon $mem_used_percents.eng(w:1) ";
           interval = 10;
         }
         {
          block = "time";
          interval = 10;
          format = " $timestamp.datetime(f:'%a %d/%m %R') ";
         }
         {
          block = "battery";
          format = " $icon $percentage ";
         }
         {
          block = "net";
          format = " $icon {$ssid|Wired} ";
         }
       ];
      };
    };
  };
}
