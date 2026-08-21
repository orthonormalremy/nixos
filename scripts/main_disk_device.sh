#!/usr/bin/env bash
set -Ceuo pipefail

mapfile -t disks < <(lsblk -dn -o PATH,TYPE,RM | awk '$2=="disk" && $3==0 {print $1}')
(( ${#disks[@]} == 1 )) || { printf 'expected exactly one disk, found %d: %s\n' "${#disks[@]}" "${disks[*]}" >&2; exit 1; }
echo "${disks[0]}"
