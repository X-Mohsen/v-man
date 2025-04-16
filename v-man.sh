#!/bin/bash

vm_name=$1
disk_size=${2:-"20G"}
username=${3:-"ubuntu"}
password=${4:-"ubuntu"}
password_hash=$(mkpasswd --method=SHA-512 "$password")

# Check if vm_name argument is missing
if [ -z "$vm_name" ]; then
    echo "VM name is not provided. Exiting..."
    exit 1
fi

# Check if a directory exists with the same name as the argument
if [ -d "/$vm_name" ]; then
    echo "Error: A directory named '$vm_name' already exists. Exiting..."
    exit 1
else
    echo "Creating directory '/$vm_name'..."
    mkdir "./$vm_name" || { echo "Failed to create directory. Exiting..."; exit 1; }
fi

cd $vm_name

disk_name="disk-$vm_name.qcow2"
qemu-img create -f qcow2 $disk_name $disk_size

mkdir "./seed"


cat <<EOF > "./seed/user-data"
#cloud-config
autoinstall:
  version: 1
  identity:
    hostname: $vm_name
    username: $username
    password: $password_hash
  ssh:
    install-server: true
    allow-pw: true
  storage:
    layout:
      name: lvm
    bootloader: grub-pc
  locale: en_US
  keyboard:
    layout: us
  apt:
    geoip: true
  interactive-sections: []
  packages:
    - vim
    - git
  network:
    version: 2
    ethernets:
      enp5s0:
        dhcp4: true
        dhcp6: false
        optional: true
  late-commands:
    - curtin in-target --target=/target -- shutdown -h now
EOF


cat <<EOF > "./seed/meta-data"
instance-id: $vm_name
local-hostname: ubuntu
EOF

echo "Creating iso file based on default seed data..."
cloud-localds seed.iso seed/user-data seed/meta-data


read -p "Do you want to proceed with the installation? [y/N]: " choice

if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
  echo "Running the VM with pre-seeded installation..."
else
  echo "Installation aborted; You can run it later."
  exit 1
fi


sudo mount -o loop ../ubuntu-24.04.2-live-server-amd64.iso /mnt/virtual-man

cp /mnt/virtual-man/casper/vmlinuz kernel
cp /mnt/virtual-man/casper/initrd initrd.img

sudo umount /mnt/virtual-man

qemu-system-x86_64 \
  -enable-kvm \
  -m 4096 \
  -smp 2 \
  -cpu host \
  -kernel kernel \
  -initrd initrd.img \
  -cdrom ../ubuntu-24.04.2-live-server-amd64.iso \
  -drive file="$disk_name",format=qcow2 \
  -drive file=seed.iso,format=raw \
  -boot order=cdn \
  -net nic \
  -net user \
  -append "autoinstall ds=nocloud"