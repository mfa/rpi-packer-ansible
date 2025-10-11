source "cross" "raspios" {
  file_checksum_type    = "sha256"
  file_checksum_url     = "https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2025-10-02/2025-10-01-raspios-trixie-armhf-lite.img.xz.sha256"
  file_target_extension = "xz"
  file_unarchive_cmd = [
      "xz",
      "--decompress",
      "$ARCHIVE_PATH"
  ]
  file_urls             = ["https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2025-10-02/2025-10-01-raspios-trixie-armhf-lite.img.xz"]
  image_build_method    = "reuse"
  image_chroot_env      = ["PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"]
  image_partitions {
    filesystem   = "vfat"
    mountpoint   = "/boot"
    name         = "boot"
    size         = "256M"
    start_sector = "8192"
    type         = "c"
  }
  image_partitions {
    filesystem   = "ext4"
    mountpoint   = "/"
    name         = "root"
    size         = "0"
    start_sector = "532480"
    type         = "83"
  }
  image_path                   = "raspios-arm.img"
  image_size                   = "4G"
  image_type                   = "dos"
  qemu_binary_destination_path = "/usr/bin/qemu-arm-static"
  qemu_binary_source_path      = "/usr/bin/qemu-arm-static"
}

build {
  sources = ["source.cross.raspios"]

  provisioner "shell" {
      inline = [
        "apt-get update && apt-get install -y python3-pip python3-passlib ansible-core --no-install-recommends",
        "ansible-galaxy collection install ansible.posix",
        "mkdir -p /tmp/ansible"
      ]
    }

  provisioner "file" {
      source = "./ansible/.vault_pass.txt"
      destination = "/tmp/ansible/.vault_pass.txt"
    }

  provisioner "ansible-local" {
      playbook_file = "./ansible/playbooks/all_pi_playbook.yaml"
      playbook_dir = "./ansible/playbooks"
      extra_arguments = [
        "-vvv",
        "--vault-password-file",
        "/tmp/ansible/.vault_pass.txt",
        "--extra-vars",
        "hostname=${var.hostname}"
      ]
      staging_directory = "/tmp/ansible"
    }

  provisioner "shell" {
      inline = [
        "apt-get remove -y ansible-core python3-pip",
        "apt-get autoremove -y",
        "rm -rf /tmp/ansible /root/.cache /var/cache/apt"
      ]
    }
}
