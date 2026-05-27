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

    extraConfig.pipewire."10-audio-buffer" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [ 48000 ];
        "default.clock.quantum" = 4096;
        "default.clock.min-quantum" = 4096;
        "default.clock.max-quantum" = 8192;
      };
    };
  };

  programs.niri.enable = true;
  programs.zsh.enable = true;
  programs.xwayland.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.sessionVariables = {
    GLFW_PLATFORM = "x11";
    NIXOS_OZONE_WL = "1";
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
}
