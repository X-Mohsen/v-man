#!/bin/bash

arg="$1"
arg2="$2"

# If user wants to list available VM disk names
if [ "$arg" == "list" ]; then
  for disk in disks/*.qcow2; do
    basename "$disk" .qcow2
  done
  exit 0
fi

disk_path="./disks/$arg.qcow2"

# Check if the disk file exists
if [ ! -f "$disk_path" ]; then
  echo "Disk '$disk_path' does not exist!"
  exit 1
fi

# Base QEMU command
QEMU_CMD="sudo qemu-system-x86_64 \
  -enable-kvm \
  -m 4096 \
  -smp 2 \
  -cpu host \
  -drive file=\"$disk_path\",format=qcow2 \
  -boot order=c \
  -net nic \
  -net bridge,br=br0"

# Add daemonize flags if requested
if [ "$arg2" == "--daemon" ] || [ "$arg2" == "-d" ]; then
  mkdir -p "daemons"
  QEMU_CMD="$QEMU_CMD -pidfile ./daemons/$arg.pid -daemonize -display none"
fi

# Execute the command
eval "$QEMU_CMD"
