#!/usr/bin/env bash
set -Cexuo pipefail

[ "$(id -u)" -eq 0 ] || { echo "must be root; run: sudo -i" >&2; exit 1; }
[ -f disko-config.nix ] || { echo "disko-config.nix not found in $PWD" >&2; exit 1; }

./scripts/main_disk_device.sh > main_disk_device
cat main_disk_device

nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./disko-config.nix
