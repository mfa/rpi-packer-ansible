# Raspberry PI image building using Packer, QEMU and Ansible

using https://github.com/michalfita/packer-plugin-cross

## create one raspberry image

currently only arm7 is working; arm64 needs fixing

```
sh run.sh zero4
```

`zero23` (Zero 2 W) uses DietPi 32-bit (ARMv7, Trixie) instead of raspios.
Wifi goes through wpa_supplicant (`dietpi-wifi.txt`), hostname/password/timezone are set in `/boot/dietpi.txt` and applied by DietPi on first boot.
The image is written to `dietpi-arm.img`.

## write to sdcard

(replace /dev/sdX with your device)

```
sudo dd bs=4M if=raspios-arm.img of=/dev/sdX conv=fsync status=progress
```
