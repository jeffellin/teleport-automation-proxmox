# Example: Using the linux-vm module to create multiple VMs
# This shows how to reuse the module with different configurations

terraform {
  required_version = ">= 1.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.40.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_host
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = true
}

# Create a web server VM
module "web_server" {
  source = "../modules/linux-vm"

  vm_name        = "web-server"
  vm_id          = 200
  vm_ip          = "192.168.1.10"
  ssh_public_key = var.ssh_public_key
  gateway_ip     = "192.168.1.1"

  # Override defaults for this VM
  cpu_cores   = 4
  memory_mb   = 8192
  disk_size   = 100

  # Proxmox configuration
  proxmox_endpoint  = var.proxmox_host
  proxmox_username  = var.proxmox_username
  proxmox_password  = var.proxmox_password
  proxmox_node      = var.proxmox_node

  vm_password = var.vm_password
  username    = var.username
}

# Create a database server VM
module "database_server" {
  source = "../modules/linux-vm"

  vm_name        = "database-server"
  vm_id          = 201
  vm_ip          = "192.168.1.11"
  ssh_public_key = var.ssh_public_key
  gateway_ip     = "192.168.1.1"

  # Override defaults for this VM (more memory for DB)
  cpu_cores   = 8
  memory_mb   = 16384
  disk_size   = 200

  # Proxmox configuration
  proxmox_endpoint  = var.proxmox_host
  proxmox_username  = var.proxmox_username
  proxmox_password  = var.proxmox_password
  proxmox_node      = var.proxmox_node

  vm_password = var.vm_password
  username    = var.username
}

# Create a utility/monitoring server VM
module "monitoring_server" {
  source = "../modules/linux-vm"

  vm_name        = "monitoring-server"
  vm_id          = 202
  vm_ip          = "192.168.1.12"
  ssh_public_key = var.ssh_public_key
  gateway_ip     = "192.168.1.1"

  # Default configuration is fine for monitoring
  cpu_cores = 2
  memory_mb = 4096
  disk_size = 50

  # Proxmox configuration
  proxmox_endpoint  = var.proxmox_host
  proxmox_username  = var.proxmox_username
  proxmox_password  = var.proxmox_password
  proxmox_node      = var.proxmox_node

  vm_password = var.vm_password
  username    = var.username
}
