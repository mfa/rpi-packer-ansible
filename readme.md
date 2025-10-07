# Raspberry PI image building using Packer, QEMU and Ansible

using https://github.com/michalfita/packer-plugin-cross

## create one raspberry image

currently only arm7 is working; arm64 needs fixing

```
sh run.sh zero4
```

## write to sdcard

(replace /dev/sdX with your device)

```
sudo dd bs=4M if=raspios-arm.img of=/dev/sdX conv=fsync
```
