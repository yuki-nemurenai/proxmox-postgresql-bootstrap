resource "proxmox_virtual_environment_file" "this" {
  content_type = "snippets"
  datastore_id = var.cloud_image.target_datastore
  node_name    = var.cloud_image.target_node

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: "${var.prefix}-${var.virtual_machine.name}"
    packages:
      - qemu-guest-agent
    runcmd:
      - systemctl enable qemu-guest-agent --now
    package_upgrade: true
    package_reboot_if_required: true
    users:
      - name: ${var.virtual_machine.user}
        groups: sudo
        shell: /bin/bash
        ssh-authorized-keys:
          - ${var.virtual_machine.ssh_authorized_key}
        sudo: ALL=(ALL) NOPASSWD:ALL
      - name: ansible
        groups: sudo
        shell: /bin/bash
        ssh-authorized-keys:
          - ${tls_private_key.this[0].public_key_openssh}
        sudo: ALL=(ALL) NOPASSWD:ALL
    timezone: Asia/Tomsk
    EOF

    file_name = "cloud-config.yaml"
  }
}