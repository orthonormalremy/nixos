#!/usr/bin/env bash
set -Cexuo pipefail

[ "$(id -u)" -eq 0 ] || { echo "must be root; run: sudo -i" >&2; exit 1; }
[ -f flake.nix ] || { echo "flake.nix not found in $PWD" >&2; exit 1; }

./scripts/disko_clobber_machine.sh

nixos-generate-config --no-filesystems --root /mnt
mv --update=none-fail /mnt/etc/nixos /mnt/etc/nixos.init

git -C /mnt/etc clone https://github.com/orthonormalremy/nixos.git
cp /mnt/etc/nixos.init/configuration.nix /mnt/etc/nixos/configuration.init.nix
echo "nixos-vm" > /mnt/etc/nixos/hostname
./scripts/main_disk_device.sh > /mnt/etc/nixos/main_disk_device
cmp --silent ./main_disk_device /mnt/etc/nixos/main_disk_device || exit 1
