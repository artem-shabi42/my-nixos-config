{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
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
    bubblewrap
    nvtopPackages.full
  ];
}
