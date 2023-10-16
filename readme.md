# Raspberry PI image building using Packer, QEMU and Ansible

using https://github.com/mkaczanowski/packer-builder-arm

## create one raspberry image

This needs a json file in `boards`.

```
sh run.sh zero4
```

## write to sdcard

(replace /dev/sdX with your device)

```
sudo dd bs=4M if=raspios-arm.img of=/dev/sdX conv=fsync
```
