{
  description = "Мой первый флейк с Noctalia и Hiddify";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, noctalia, ... }@inputs: {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix

        ({ config, pkgs, ... }: {
          nixpkgs.config.allowUnfree = true;

          environment.systemPackages = with pkgs; [
          ];
        })
      ];
    };
  };
}
