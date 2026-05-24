{ inputs, pkgs, ... }: {
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.system}.default
  ];
}

