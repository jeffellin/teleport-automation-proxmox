# Example: Using the nginx-vm module to create an Nginx server
# This example shows how to deploy Nginx with Teleport integration

# Create an Nginx VM with Teleport
module "nginx_server" {
  source = "../modules/nginx-vm"

  vm_name        = "nginx-server"
  vm_id          = 208
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
  memory_mb = 2048
  disk_size = 30
  storage_pool = "SSD_2TB_1"

  # Network
  vm_ip     = "192.168.1.208"
  gateway_ip = "192.168.1.1"

  enable_teleport        = true
  teleport_proxy_address = var.teleport_proxy_address
  teleport_token         = teleport_provision_token.nginx_app.metadata.name
}

# Create a provision token for nginx app service
resource "teleport_provision_token" "nginx_app" {
  version = "v2"

  metadata = {
    name = "nginx-app-token"
    labels = {
      env     = "dev"
      service = "nginx"
    }
  }

  spec = {
    roles = ["App","Node"]

    # Token expires in 1 hour (3600 seconds)
    # Adjust as needed
    join_method = "token"
  }

  # Ignore system-managed labels added by Teleport provider
  lifecycle {
    ignore_changes = [metadata]
  }
}
