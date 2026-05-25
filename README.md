# My NixOS Configuration

Personal NixOS configuration using flakes and Home Manager as a NixOS module.

## Structure

```text
.
├── flake.nix
├── hosts/
│   └── nixos/
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── modules/
│   ├── boot.nix
│   ├── desktop.nix
│   ├── networking.nix
│   ├── noctalia.nix
│   ├── nvidia.nix
│   └── packages.nix
└── users/
    └── artem/
        ├── home.nix
        └── nixos.nix
```

`hardware-configuration.nix` is ignored because it contains machine-specific disk UUIDs and hardware details.

## Apply

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

## Check Without Applying

```bash
nixos-rebuild dry-build --flake path:/etc/nixos#nixos
```

## New Machine

Generate a host-specific hardware configuration:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/nixos/hardware-configuration.nix
```
