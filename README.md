# V-man > Virtual Man

This bash script automates the creation and installation of an Ubuntu 24.04 virtual machine using **cloud-init autoinstall**, `qemu`, and `cloud-localds`.

## 📦 Features

- Automatically creates a directory for the VM
- Generates a virtual disk with specified size
- Prepares a cloud-init `user-data` file with:
  - Hostname, username, password
  - SSH server installation and password login
  - Package installation (`vim`, `git`)
- Mounts Ubuntu ISO to extract kernel and initrd
- Boots the VM with autoinstall configuration

---

## 🚀 Usage

```bash
chmod +x install-vm.sh
./v-man.sh <vm_name> [disk_size] [username] [password]
```

### Arguments

| Argument    | Description                      | Default  |
|-------------|----------------------------------|----------|
| `vm_name`   | Name of the VM (also folder name)| *required* |
| `disk_size` | Virtual disk size (e.g. `30G`)   | `20G`    |
| `username`  | Login username                   | `ubuntu` |
| `password`  | Login password                   | `ubuntu` |

### Example

```bash
./v-man.sh test-vm 25G john mysecretpass
```

---

### ✅ After the first install completes

To boot into the installed system:

```bash
qemu-system-x86_64 \
  -enable-kvm \
  -m 4096 \
  -smp 2 \
  -cpu host \
  -drive file="disk-<vm_name>.qcow2",format=qcow2 \
  -boot order=c \
  -net nic \
  -net user
```

Do **not** attach `-cdrom` or `seed.iso`.

---

## 📁 Folder Structure

After running the script, a folder named after the VM is created containing:

```
<vm_name>/
├── disk-<vm_name>.qcow2
├── seed.iso
├── kernel
├── initrd.img
└── seed/
    ├── user-data
    └── meta-data
```

---

## 🧹 Cleanup

To delete the VM:

```bash
rm -rf <vm_name>
```