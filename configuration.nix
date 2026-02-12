# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/hardware/default.nix
    ./modules/services/default.nix
    ./modules/userland/dandy.nix
  ];

  steam.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    zlib
    libgcc
    icu
    fontconfig
    freetype

    # X11 session / IPC (THIS fixes libICE.so.6)
    xorg.libICE
    xorg.libSM
    
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXi
    xorg.libXext
  ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";
  # time.timeZone = "Africa/Lagos";

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



  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "dandy";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (
    with pkgs;
    [
      wget
      git
      zip
      wl-clipboard

      # C++
      gcc
      usbutils
      # jetbrains.clion

      # Python
      # python310
      vscode
      godot

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
      kitty
      kdePackages.dolphin

      #System utilities
      networkmanagerapplet

      # Dev tooling
      nushell
      zellij
      bat
      direnv

      # Leisure
      mpv
      teams-for-linux
      vesktop
      # steam
      protontricks
      # itch
      qbittorrent

      # images
      gimp
      qimgv
      obs-studio
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

      zotero
      ncspot # music
      # kdePackages.xwaylandvideobridge
      unzip


      # IOS connect
      idescriptor
      # libimobiledevice
      # ifuse # optional, to mount using 'ifuse'



      ## System Diagnostic tools
      # chntpw
      # hydra-check
      # vdpauinfo
      ntfs3g
    ]
  )

  ;
 
  environment.variables = rec {
    GRIMBLAST_EDITOR = "/run/current-system/sw/bin/swappy -f";
    EDITOR = "/run/current-system/sw/bin/hx";
    SUDO_EDITOR = "/run/current-system/sw/bin/hx";
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

   # Enable the OpenSSH daemon.
   services.openssh.enable = true;
  
  networking.firewall = {
  enable = false;

  allowedTCPPortRanges = [
    { from = 30000; to = 60000; }
  ];
  allowedUDPPortRanges = [
    { from = 30000; to = 60000; }
  ];
  };

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
