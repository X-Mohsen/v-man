#!/bin/bash

arg=$1

if [ "$arg" == "list" ]; then
  disks=$(ls disks)

  for disk in $disks; do
    disk_name_no_suffix=$(basename "$disk" .qcow2)
    echo "$disk_name_no_suffix"
  done
  exit 0
fi


sudo qemu-system-x86_64 \
  -enable-kvm \
  -m 4096 \
  -smp 2 \
  -cpu host \
  -drive file="./disks/$arg.qcow2",format=qcow2 \
  -boot order=c \
  -net nic \
  -net bridge,br=br0