{ ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/desktop.nix
    ../../modules/fonts.nix
    ../../modules/networking.nix
    ../../modules/noctalia.nix
    ../../modules/nvidia.nix
    ../../modules/packages.nix
    ../../modules/stoat.nix
    ../../modules/direnv.nix
    ../../modules/opencode.nix
    ../../modules/steam.nix
    ../../users/artem/nixos.nix
  ];

  system.stateVersion = "26.05"; # Did you read the comment?
}
