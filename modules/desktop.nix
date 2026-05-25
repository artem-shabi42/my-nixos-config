{ pkgs, ... }:

{
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:alt_shift_toggle";
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  programs.niri.enable = true;
  programs.zsh.enable = true;
  programs.xwayland.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
}
