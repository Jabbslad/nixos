{ config, pkgs, ... }:
let unstable = import <nixos-unstable> { };
in {
  imports = [ ./zsh.nix ./i3.nix ];
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

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
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    curl
    wget
    brave
    lxappearance
    papirus-icon-theme
    networkmanagerapplet
    _1password
    _1password-gui
    unzip
    signal-desktop
    feh
    libsecret
    inotify-tools

    transmission-gtk
    ripgrep

    font-awesome
    jetbrains-mono
    powerline-fonts
    powerline-symbols
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })

    gcc

    #erlang_26

    #vulkan-loader # needed for Zed

    zoom-us

    discord

    unstable.zig
    unstable.rustup

    unstable.zed-editor
    unstable.nixd
    nixfmt-classic
    imhex
    openssl
    pkg-config

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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jabbslad/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
    BROWSER = "/home/jabbslad/.nix-profile/bin/brave";
    #LD_LIBRARY_PATH= "${pkgs.vulkan-loader}/lib";
    #LIBRARY_PATH= "${pkgs.vulkan-loader}/lib";
    SSH_ASKPASS = "";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

  home.sessionPath = [ "$HOME/.cargo/bin" "$HOME/.bin" ];

  programs.git = {
    enable = true;
    userName = "Jabbslad";
    userEmail = "jabbslad@gmail.com";
    extraConfig = {
      credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        ForwardAgent yes
        IdentitiesOnly yes
    '';
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    shellAliases = { zed = "zeditor"; };

    initExtra = ''
      bindkey '^R' history-incremental-search-backward
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.neovim.enable = true;
  programs.kitty = {
    enable = true;
    theme = "Gruvbox Dark";
    font = { name = "Jetbrains Mono"; };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
    };
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
}
