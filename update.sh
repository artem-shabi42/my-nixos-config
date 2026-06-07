#!/usr/bin/env bash
set -euo pipefail

flake_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
flake_ref="path:$flake_dir#nixos"
started_at="$(date +%s)"

if [[ -t 1 ]]; then
  bold="$(tput bold)"
  dim="$(tput dim)"
  green="$(tput setaf 2)"
  blue="$(tput setaf 4)"
  red="$(tput setaf 1)"
  reset="$(tput sgr0)"
else
  bold=""
  dim=""
  green=""
  blue=""
  red=""
  reset=""
fi

current_step=0
total_steps=4

print_header() {
  printf "%s\n" "${bold}NixOS update${reset}"
  printf "%s\n\n" "${dim}flake: $flake_dir${reset}"
}

print_step() {
  current_step=$((current_step + 1))
  printf "%s[%d/%d]%s %s%s%s\n" \
    "$blue" "$current_step" "$total_steps" "$reset" "$bold" "$1" "$reset"
}

run() {
  print_step "$1"
  shift
  printf "%s$ %s%s\n" "$dim" "$*" "$reset"
  "$@"
  printf "%sok%s\n\n" "$green" "$reset"
}

finish() {
  local status=$?
  local finished_at elapsed

  finished_at="$(date +%s)"
  elapsed=$((finished_at - started_at))

  if [[ $status -eq 0 ]]; then
    printf "%sUpdate complete%s in %ss\n" "$green" "$reset" "$elapsed"
  else
    printf "%sUpdate failed%s at step %d/%d after %ss\n" \
      "$red" "$reset" "$current_step" "$total_steps" "$elapsed" >&2
  fi

  exit "$status"
}

trap finish EXIT

print_header

run "Update flake inputs" nix flake update --flake "$flake_dir"
run "Check flake" nix flake check "$flake_dir"
run "Dry build system" nixos-rebuild dry-build --flake "$flake_ref"
run "Activate system" sudo nixos-rebuild switch --flake "$flake_dir#nixos"
