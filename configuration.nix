# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  imports =
    [
      ./hardware-configuration.nix
      inputs.noctalia.nixosModules.default
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" ];
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:alt_shift_toggle"; # Переключение по Alt+Shift (можно заменить на grp:win_space_toggle)
  };
  console = {
     font = "Lat2-Terminus16";
     useXkbConfig = true; # use xkb.options in tty.
  };


  users.users.artem = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    packages = with pkgs; [
      firefox
      chromium
      git
      tree-sitter
      telegram-desktop
    ];
  };
  
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.system}.default
    nvtop
    nano
    wget
    curl
    btop
    git
    ghostty
    wl-clipboard
    fuzzel
    waybar
    zsh
    neovim
    appimage-run
    gcc
    cargo
    rustc
    go
    nodejs
  ];

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Важно для работы 32-битных приложений (игры и т.д.)
    pulse.enable = true;      # Эмуляция PulseAudio
    # Если вы используете WirePlumber (по умолчанию в новых версиях):
    wireplumber.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  services.openssh.enable = true;
  services.resolved.enable = true;
  programs.niri.enable = true;
  programs.zsh.enable = true;
  programs.xwayland.enable = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  users.defaultUserShell = pkgs.zsh;
  
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  system.stateVersion = "26.05"; # Did you read the comment?
}

