{ pkgs, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "electron-38.8.4"
  ];

  environment.systemPackages = with pkgs; [
    stoat-desktop
  ];
}
