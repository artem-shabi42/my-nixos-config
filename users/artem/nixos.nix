{ pkgs, ... }:

{
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
}
