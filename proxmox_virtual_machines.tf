resource "proxmox_virtual_environment_download_file" "this" {
  content_type            = "iso"
  datastore_id            = var.cloud_image.target_datastore
  node_name               = var.cloud_image.target_node
  url                     = "${var.cloud_image.url}/${var.cloud_image.distro_codename}/current/${var.cloud_image.distro_codename}-server-cloudimg-${var.cloud_image.architecture}.img"
  overwrite               = false
}

resource "proxmox_virtual_environment_vm" "this" {
  name        = "${var.prefix}-${var.virtual_machine.name}"
  description = "Managed by Terraform"
  tags        = ["terraform", "postgresql"]
  node_name   = var.virtual_machine.target_node
  stop_on_destroy = true
  machine       = "q35"
  scsi_hardware = "virtio-scsi-single"
  bios          = "seabios"

  cpu {
    cores = var.virtual_machine.cpu
    type = var.virtual_machine.cpu_type
  }

  memory {
    dedicated = var.virtual_machine.memory
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = var.virtual_machine.target_datastore
    file_id      = proxmox_virtual_environment_download_file.this.id
    file_format  = "raw"
    interface    = "scsi0"
    size         = var.virtual_machine.disk_size
  }


  operating_system {
    type = "l26"
  }

  initialization {
    datastore_id = var.virtual_machine.cloud_init_datastore
    dns {
      domain = var.virtual_machine.domain
      servers = var.virtual_machine.dns_servers
    }
    ip_config {
      ipv4 {
        address = var.virtual_machine.ip_address
        gateway = var.virtual_machine.gateway
      }
    }
    user_data_file_id = proxmox_virtual_environment_file.this.id
  }
}

resource "null_resource" "this" {
  depends_on = [proxmox_virtual_environment_vm.this]
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<-EOT
      ansible-playbook \
        -u ansible \
        -i ${split("/", proxmox_virtual_environment_vm.this.initialization[0].ip_config[0].ipv4[0].address)[0]}, \
        --private-key '${path.module}/keys/id_ed25519' \
        --extra-vars "DB_USER=${var.postgresql.db_user}" \
        --extra-vars "DB_PASSWORD=${var.postgresql.db_password}" \
        --extra-vars "DB_NAME=${var.postgresql.db_name}" \
        --extra-vars "POSTGRESQL_VERSION=${var.postgresql.version}" \
        --extra-vars "PGBOUNCER_LISTEN_ADDR=${split("/", proxmox_virtual_environment_vm.this.initialization[0].ip_config[0].ipv4[0].address)[0]}" \
        ansible/playbook.yaml
    EOT
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
      ANSIBLE_PYTHON_INTERPRETER = "/usr/bin/python3"
    }
  }
}