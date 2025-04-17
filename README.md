# V-man

This bash script automates the creation and installation of an Ubuntu virtual machine using **cloud-init autoinstall**, `qemu`, and `cloud-localds`.

## 📦 Features

- Generates a virtual disk with specified size
- Prepares cloud-init `user-data` & `meta-data` files
- Mounts ISO to extract the kernel and initrd files required for automated installation.
- Boots the VM with autoinstall configuration

---

> ⚠️ **Note**:  
> This script is designed specifically for **Ubuntu Live Server ISOs** and tested with:
>
> - **Host OS**: Ubuntu 24.04.2  
> - **ISO**: Ubuntu Live Server 24.04.2  
>
> Other distributions or desktop ISOs may not work correctly with this autoinstall setup.

---

## 🚀 Usage

```bash
chmod +x v-man.sh
./v-man.sh <vm_name> <iso_path> [disk_size] [username] [password]
```

### Arguments

| Argument    | Description                      | Default  |
|-------------|----------------------------------|----------|
| `vm_name`   | Name of the VM (also folder name)| *required* |
| `iso_path`  | Path of ISO file                 | *required* |
| `disk_size` | Virtual disk size (e.g. `30G`)   | `20G`    |
| `username`  | Login username                   | `ubuntu` |
| `password`  | Login password                   | `ubuntu` |

### Example

```bash
./v-man.sh test-vm ubuntu-live-server.iso 25G john mysecretpass
```

---

### 2. **Run VM with `v-run.sh`:**

Once the VM is created, you can use `v-run.sh` to either list available disks or start a VM.

```bash
chmod +x v-run.sh
./v-run.sh <vm_name>   # To run a VM
./v-run.sh list        # To list all VM disks (without .qcow2 suffix)
```

#### Example to List Disks

```bash
./v-run.sh list
```

#### Example to Run a VM

```bash
./v-run.sh test-vm
```

This will boot the VM with the disk named `test-vm.qcow2` from the `disks/` folder.

---
