# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/hardware/nvidia.nix
    ./modules/services/sound/default.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # boot.kernelPatches = [
  #   {
  #     name = "amdgpu-ignore-ctx-privileges";
  #     patch = pkgs.fetchpatch {
  #       name = "cap_sys_nice_begone.patch";
  #       url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
  #       hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
  #     };
  #   }
  # ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  # time.timeZone = "Europe/London";
  time.timeZone = "Africa/Lagos";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # system.autoUpgrade = {
  #   enable = true;
  #   flake = inputs.self.outPath;
  #   flags = [
  #     "--update-input"
  #     "nixpkgs"
  #     "-L"
  #   ];
  #   dates = "09:00";
  #   randomizedDelaySec = "45min";
  # };
  # program.nix-ld.enable = true;
  #programs.nix-ld.libraries = with pkgs; [

  #];

  systemd.user.services.plasma-dolphin = {
    unitConfig = {
      Description = "Dolphin file manager";
      PartOf = [ "graphical-session.target" ];
    };
    path = [ "/run/current-system/sw" ];
    environment = {
      # don't add this if you are not wayland
      QT_QPA_PLATFORM = "wayland";
    };
    serviceConfig = {
      Type = "dbus";
      BusName = "org.freedesktop.FileManager1";
      ExecStart = "${pkgs.kdePackages.dolphin}/bin/dolphin";
    };
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Enable alvr
  # programs.alvr.enable = true;
  # programs.alvr.openFirewall = true;

  programs.xwayland.enable = true;

  # Bluetooth manager
  services.blueman.enable = true;

  # Handles desktop interactions
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dandy = {
    isNormalUser = true;
    description = "Joseph Aghoghovbia";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      firefox
      vivaldi
      tor-browser
      google-chrome
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "dandy";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # nixpkgs-unstable.config.allowUnfree = true;
  nvidia.enable = true;
  noisetorch.enable = true;
  hardware.opentabletdriver.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (
    with pkgs;
    [
      wget
      git
      zip

      # C++
      gcc
      usbutils
      # jetbrains.clion

      # Python
      # python310
      vscode

      # Java
      jdk21_headless
      # jetbrains.idea-ultimate

      # Editors
      vim
      helix
      # lsp's
      nil
      nixfmt-rfc-style

      # dunst #notification service
      # libnotify
      kitty
      rofi-wayland
      kdePackages.dolphin
      hyprpanel
      hyprland-qtutils

      #System utilities
      networkmanagerapplet
      pavucontrol
      blueman

      # Dev tooling
      nushell
      zellij
      bat
      direnv

      # Leisure
      mpv
      teams-for-linux
      vesktop
      steam
      itch
      # alvr
      qbittorrent

      # images
      gimp
      qimgv
      grimblast # screenshots
      swappy


      # Blender
      blender

      # video/image codecs
      ffmpeg_7-full
      libva
      libva-utils

      # Image manipulation
      rerun

      obsidian
      zotero
      # Rust
      lldb
      rustc
      cargo
      rustfmt

      cargo-modules
      clippy
      rust-analyzer
      # ncspot # music
      kdePackages.xwaylandvideobridge
      hyprland
      xdg-desktop-portal-hyprland
      unzip

      ## System Diagnostic tools
      # chntpw
      # hydra-check
      # vdpauinfo
      ntfs3g
    ]
  )

  ;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
  fonts.fontDir.enable = true;

  # Enabling hyprland on Nixos
  environment.sessionVariables = {
    # If cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    GSK_RENDERER = "ngl";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };

  environment.variables = rec {
    GRIMBLAST_EDITOR = "/run/current-system/sw/bin/swappy -f";

  };

  # services.xserver.videoDrivers = ["nvidia"];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
