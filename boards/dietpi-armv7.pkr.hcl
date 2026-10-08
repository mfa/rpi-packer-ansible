source "cross" "dietpi" {
  file_checksum_type    = "sha256"
  file_checksum_url     = "https://dietpi.com/downloads/images/DietPi_RPi2-ARMv7-Trixie.img.xz.sha256"
  file_target_extension = "xz"
  file_unarchive_cmd = [
      "xz",
      "--decompress",
      "$ARCHIVE_PATH"
  ]
  file_urls             = ["https://dietpi.com/downloads/images/DietPi_RPi2-ARMv7-Trixie.img.xz"]
  image_build_method    = "resize"
  image_chroot_env      = ["PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"]
  image_partitions {
    filesystem   = "vfat"
    mountpoint   = "/boot"
    name         = "boot"
    size         = "128M"
    start_sector = "2048"
    type         = "c"
  }
  image_partitions {
    filesystem   = "ext4"
    mountpoint   = "/"
    name         = "root"
    size         = "0"
    start_sector = "264192"
    type         = "83"
  }
  image_path                   = "dietpi-arm.img"
  image_size                   = "2G"
  image_type                   = "dos"
  qemu_binary_destination_path = "/usr/bin/qemu-arm-static"
  qemu_binary_source_path      = "/usr/bin/qemu-arm-static"
}

build {
  sources = ["source.cross.dietpi"]

  provisioner "shell" {
      inline = [
        # /tmp is a tmpfs at runtime; in the image it is not writable for apt's _apt user
        "chmod 1777 /tmp",
        "apt-get update && apt-get install -y ansible-core --no-install-recommends",
        "ansible-galaxy collection install ansible.posix",
        "mkdir -p /tmp/ansible"
      ]
    }

  provisioner "file" {
      source = "./ansible/.vault_pass.txt"
      destination = "/tmp/ansible/.vault_pass.txt"
    }

  provisioner "ansible-local" {
      playbook_file = "./ansible/playbooks/dietpi_playbook.yaml"
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
        "apt-get remove -y ansible-core",
        "apt-get autoremove -y",
        "apt-get clean",
        "rm -rf /tmp/ansible /root/.cache /root/.ansible"
      ]
    }
}
