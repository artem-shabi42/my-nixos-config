{ inputs, pkgs, ... }:

let
  minecraftCursorTheme = import ./minecraft-cursor.nix { inherit pkgs; };
in
{
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    minecraftCursorTheme
    nano
    wget
    curl
    btop
    git
    ghostty
    wl-clipboard
    xwayland-satellite
    xwayland-run
    gamescope
    fuzzel
    waybar
    zsh
    neovim
    appimage-run
    gcc
    gnumake
    cargo
    rustc
    go
    nodejs
    bubblewrap
    nvtopPackages.full
    kitty
    obs-studio
    obsidian
    mpv
    zip
    unzip
    (llama-cpp.override { cudaSupport = true; })
  ];

  programs.nix-ld.enable = true;
}
