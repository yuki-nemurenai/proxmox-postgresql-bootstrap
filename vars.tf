variable "proxmox_virtual_environment" {
    description = "Proxmox Virtual Environment Credentials"
    type = object({
        endpoint   = string
        api_token  = string
        ssh_user   = string
        ssh_password = string
    })
    sensitive = true
}


variable "cloud_image" {
    description = "The cloud image to use for the virtual machine"
    type = object({
        url = string
        architecture = string
        distro_codename = string
        target_datastore = string
        target_node = string
    })
    default = {
        url = "https://cloud-images.ubuntu.com"
        architecture = "amd64"
        distro_codename = "noble"
        target_datastore = "leta_10raid_nfs"
        target_node = "odin"
    }
}

variable "virtual_machine" {
    description = "The virtual machine configuration"
    type = object({
        name = string
        user = string
        cpu = number
        cpu_type = string
        memory = number
        disk_size = number
        target_node = string
        target_datastore = string
        ip_address = string
        gateway = string
        cloud_init_datastore = string
        dns_servers = list(string)
        domain = string
        ssh_authorized_key = string
    })
}


variable "prefix" {
    description = "A prefix to provide for the cluster"
    type = string
    default = "postgresql"
}

variable "public_ssh_key_path" {
    description = "The path to the public SSH key"
    type = string
    default = ""
}

variable "postgresql" {
    description = "The PostgreSQL configuration"
    type = object({
        version = string
        db_user = string
        db_password = string
        db_name = string
    })
}





