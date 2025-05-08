# Proxmox PostgreSQL Bootstrap

## Overview

This project automates the deployment of PostgreSQL databases on virtual machines managed by Proxmox using Terraform and Ansible.

## Features

- Automated provisioning of virtual machines in Proxmox using Terraform.
- Configuration management using Ansible.
- Secure key management for accessing virtual machines.
- Customizable cloud configuration for virtual machines.
- Deploy the PostgreSQL Database with connection pooler PgBouncer.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) installed for configuration management.
- Access to a Proxmox environment.
- SSH keys for secure access to virtual machines.

## Installation

1. Clone the repository:
   ```bash
   git clone git@github.com:yuki-nemurenai/proxmox-postgresql-bootstrap.git
   cd proxmox-postgresql-bootstrap
   ```

2. Configure your Proxmox credentials, the virtual machine specifications and PostgreSQL parameters in `secret.tfvars`.

3. Configure the Pgbouncer template and PostgreSQL parameters, if necessary.

4. Initialize Terraform:
   ```bash
   terraform init
   ```

5. Apply the Terraform configuration to provision the virtual machines:
   ```bash
   terraform apply -var-file secret.tfvars
   ```

## Usage

- Create and modify `secret.tfvars` to define and customize your Proxmox credentials, the virtual machine specifications and PostgreSQL parameters.
- Update Ansible playbooks and templates in the `ansible/` directory to change the PostgreSQL configuration.
- 

## secret.tfvars reference

```hcl
proxmox_virtual_environment = {
    endpoint = "https://pve-01:8006/"
    api_token = "your-proxmox-api-token"
    ssh_user = "your-ssh-user"
    ssh_password = "your-ssh-password"
}
virtual_machine = {
    name = "test-01"
    user = "vm-user"
    cpu = 2
    cpu_type = "x86-64-v2-AES"
    memory = 4096
    disk_size = 50
    target_datastore = "pve-02_zfs_pool"
    target_node = "pve-02"
    ip_address = "10.0.7.25/27"
    gateway = "10.0.7.30"
    cloud_init_datastore = "pve_nfs_datastore"
    dns_servers = [ "1.1.1.1", "1.0.0.1" ]
    domain = "your-domain"
    ssh_authorized_key = "your-ssh-public-key"
}
postgresql = {
    version = "17"
    db_user = "your-postgresql-pgbouncer-user"
    db_password = "your-strong-db-password"
    db_name = "your-db-name"
}
```

## License

[MIT](LICENSE)
