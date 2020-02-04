# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;


  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    alsa-firmware
    alsaUtils
    pulseaudio
    apulse
    clang
    thunderbolt
    bolt
    binutils
    inxi
    tlp
    wget
    vim
    neovim
    ncurses
    emacs
    gnome3.gdm
    gnome3.gnome-shell
    konsole
    fcitx
    fcitx-configtool
    fcitx-engines.rime
    librime
    firefox-devedition-bin
    ruby
    bundler
    bundix
    chromium
    libreoffice-fresh
    chrome-gnome-shell
    git
    file
    noto-fonts-cjk
    zsh
    fira
    fira-code
    fira-code-symbols
    wqy_microhei
    tmux
    htop
    (python2.withPackages(ps: with ps; [ pygtk pynvim ]))
    (python3.withPackages(ps: with ps; [ requests pynvim ]))
    gcc
    gnumake
    cmake
    lsof
    busybox
    nodejs
    yarn
    ghc
    haskellPackages.alex
    haskellPackages.happy
    haskellPackages.Agda
    cabal-install
    stack
    (all-hies.selection { selector = p: { inherit (p) ghc864 ghc844; }; })
    python27Packages.pip
    python37Packages.pip
    pkg-config
    gnome3.nautilus
    gnome3.nautilus-python
    wineFull
    winetricks
    unrar
    mount
    gparted
    parted
    ntfs3g
    cifs-utils
    udisks
    nix-index
    zlib
    tor
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.daemon.config = {
    enable-lfe-remixing = "yes";
    default-sample-channels = "4";
    default-channel-map = "front-left,front-right,rear-left,rear-right";
  };
  hardware.bluetooth.powerOnBoot = false;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  i18n.inputMethod.enabled = "fcitx";
  i18n.inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ rime chewing ];

  services.gnome3.chrome-gnome-shell.enable = true;
  services.tlp.enable = true;
  services.hardware.bolt.enable = true;
  services.udev.packages = [ pkgs.bolt ];

  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "git" ];
    ohMyZsh.theme = "cloud";
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  fonts.fonts = with pkgs; [ noto-fonts-cjk fira fira-code wqy_microhei ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vik = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}
