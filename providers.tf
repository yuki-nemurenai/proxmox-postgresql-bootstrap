terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.75.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.1.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.5.2"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.4"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_virtual_environment.endpoint
  api_token = var.proxmox_virtual_environment.api_token
  ssh {
    agent = true
    username = var.proxmox_virtual_environment.ssh_user
    password = var.proxmox_virtual_environment.ssh_password
  }
}