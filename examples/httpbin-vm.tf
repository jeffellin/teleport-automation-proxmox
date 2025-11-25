# Example: Using the httpbin-vm module to create a HTTPBin server
# This example shows how to deploy HTTPBin with and without Teleport
# Note: Provider and terraform blocks are defined in multiple-vms.tf

# Create a basic HTTPBin VM without Teleport
module "httpbin_basic" {
  source = "../modules/httpbin-vm"

  vm_name        = "httpbin-basic"
  vm_id          = 207
  ssh_public_key = var.ssh_public_key

  # Proxmox configuration
  proxmox_endpoint = var.proxmox_host
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  proxmox_node     = var.proxmox_node

  vm_password = var.vm_password
  username    = var.username

  # Optional: customize resources
  cpu_cores = 2
  memory_mb = 4096
  disk_size = 30
  storage_pool = "SSD_2TB_1"

  # Network
  vm_ip     = "192.168.1.207"
  gateway_ip = "192.168.1.1"

  enable_teleport        = true
  teleport_proxy_address = var.teleport_proxy_address
  teleport_token         = teleport_provision_token.httpbin_app.metadata.name
}

# Create an HTTPBin VM with Teleport integration
# Uncomment and configure if you have Teleport set up
# Make sure to set teleport_proxy_address in terraform.tfvars
# and configure the Teleport provider with TELEPORT_ADDR and TELEPORT_IDENTITY_FILE_PATH
#
# module "httpbin_with_teleport" {
#   source = "../modules/httpbin-vm"
#
#   vm_name        = "httpbin-teleport"
#   ssh_public_key = var.ssh_public_key
#
#   # Proxmox configuration
#   proxmox_endpoint = var.proxmox_host
#   proxmox_username = var.proxmox_username
#   proxmox_password = var.proxmox_password
#   proxmox_node     = var.proxmox_node
#
#   vm_password = var.vm_password
#   username    = var.username
#
#   # Optional: customize resources
#   storage_pool = "SSD_TB_1"
#
#   # Teleport configuration
#   enable_teleport        = true
#   teleport_proxy_address = var.teleport_proxy_address
#   teleport_token         = teleport_provision_token.httpbin_app.metadata.name
# }
