#!/usr/bin/env bash
set -Cexuo pipefail

[ "$(id -u)" -eq 0 ] || { echo "must be root; run: sudo -i" >&2; exit 1; }
[ -f flake.nix ] || { echo "flake.nix not found in $PWD" >&2; exit 1; }

./scripts/disko_clobber_machine.sh

nixos-generate-config --flake --no-filesystems --root /mnt
mv --update=none-fail /mnt/etc/nixos /mnt/etc/nixos.init

git -C /mnt/etc clone https://github.com/orthonormalremy/nixos.git

cmp --silent ./main_disk_device <(./scripts/main_disk_device.sh) || exit 1 # paranoid sanity check
cp ./main_disk_device /mnt/etc/nixos/main_disk_device
cp /mnt/etc/nixos.init/configuration.nix /mnt/etc/nixos/configuration.init.nix
cp /mnt/etc/nixos.init/hardware-configuration.nix /mnt/etc/nixos/hardware-configuration.nix
echo "nixos-vm" > /mnt/etc/nixos/hostname

nix --experimental-features "nix-command flakes" flake lock "path:/mnt/etc/nixos"
nixos-install --no-root-password --flake "path:/mnt/etc/nixos#$(cat /mnt/etc/nixos/hostname)"
nixos-enter --root /mnt -c 'passwd rdahlke'

echo "rebooting (^c to bail within 3s):"
sleep 3
reboot
