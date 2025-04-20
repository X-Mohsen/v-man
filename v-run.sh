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
  pid_file_path="./daemons/$arg.pid"

  QEMU_CMD+=" -pidfile \"$pid_file_path\" -daemonize -display none"
  # Modifying ownership and permission for reading in v-kill.sh
  QEMU_CMD+=" && sudo chown $USER:$USER \"$pid_file_path\""
  QEMU_CMD+=" && chmod 644 \"$pid_file_path\""
fi


# Execute the command
eval "$QEMU_CMD"
