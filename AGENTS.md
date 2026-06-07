# Repository Guidelines

## Project Structure & Module Organization

This repository is a flake-based personal NixOS configuration. `flake.nix` is the entry point and defines the `nixos` system for `x86_64-linux`. Host-specific configuration lives in `hosts/nixos/`, including `configuration.nix` and the tracked `hardware-configuration.nix`. Reusable system modules live in `modules/` and are imported from the host configuration. User configuration is split under `users/artem/`: `nixos.nix` for the NixOS user account and `home.nix` for Home Manager packages, files, and session settings.

## Build, Test, and Development Commands

- `nix flake check /etc/nixos`: evaluate flake outputs and catch basic errors.
- `nixos-rebuild dry-build --flake path:/etc/nixos#nixos`: build the system closure without activating it.
- `sudo nixos-rebuild switch --flake /etc/nixos#nixos`: build and activate the system on this machine.
- `nix flake update /etc/nixos`: update `flake.lock`; review lockfile changes before rebuilding.
- `nix fmt /etc/nixos`: format files if a formatter is available in the environment.

## Coding Style & Naming Conventions

Use standard Nix formatting: two-space indentation, semicolons after assignments, and one option group per logical block. Prefer small focused modules in `modules/<topic>.nix`, named with lowercase kebab-case such as `networking.nix` or `minecraft-cursor.nix`. Keep host-only details in `hosts/nixos/`; avoid hard-coding user settings there when Home Manager is the better scope. Add comments only for non-obvious decisions, especially around hardware, boot, or compatibility settings.

## Testing Guidelines

There is no separate unit test suite. Treat Nix evaluation and dry builds as the required checks before committing system changes. Run `nix flake check /etc/nixos` for evaluation coverage, then `nixos-rebuild dry-build --flake path:/etc/nixos#nixos` for integration confidence. For risky changes to boot, disks, graphics, or networking, prefer a dry build first and keep the previous generation available for rollback.

## Commit & Pull Request Guidelines

Recent history uses short imperative or descriptive subjects, for example `add stoat` and `fix disks`. Keep commit messages concise but meaningful; avoid placeholder subjects like `.` or `t`. Pull requests or review notes should describe what changed, mention whether `flake.lock` was updated, and include the exact validation commands run. For UI, desktop, or hardware changes, include any manual checks performed after `nixos-rebuild switch`.

## Security & Configuration Tips

Do not commit secrets, private keys, tokens, or machine-local credentials. Keep filesystem labels in `hardware-configuration.nix` aligned with the README notes, currently `nixos` and `NIXBOOT`. Be careful when changing `system.stateVersion` or `home.stateVersion`; only update them after reading the relevant NixOS or Home Manager release notes.
