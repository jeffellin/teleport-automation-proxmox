# Nginx VM Module

This Terraform module creates a Proxmox VM with Nginx pre-installed and configured.

## Features

- Ubuntu-based VM
- Nginx web server installed directly (no Docker)
- Optional Teleport integration for secure app access
- Configurable resources (CPU, memory, disk, storage)
- SSH access with public key authentication
- Support for cluster SSH keys

## Usage

```hcl
module "nginx" {
  source = "../modules/nginx-vm"

  vm_name        = "nginx-server"
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
  disk_size = 20
  storage_pool = "SSD_2TB_1"

  # Optional: enable Teleport
  enable_teleport        = true
  teleport_proxy_address = "teleport.example.com"
  teleport_token         = "token-value"
}
```

## Variables

### Required
- `vm_name` - Name of the VM
- `ssh_public_key` - SSH public key for accessing the VM
- `proxmox_endpoint` - Proxmox API endpoint
- `proxmox_username` - Proxmox username
- `proxmox_password` - Proxmox password
- `vm_password` - Password for the VM user

### Optional
- `cpu_cores` - Number of CPU cores (default: 2)
- `memory_mb` - Memory in MB (default: 4096)
- `disk_size` - Disk size in GB (default: 30)
- `storage_pool` - Proxmox storage pool (default: SSD_2TB_1)
- `enable_teleport` - Enable Teleport integration (default: false)
- `teleport_proxy_address` - Teleport proxy address
- `teleport_token` - Teleport provision token

## Outputs

- `vm_id` - Proxmox VM ID
- `vm_name` - VM name
- `vm_ip` - VM IP address
- `vm_username` - SSH username
- `ssh_command` - SSH connection command
- `nginx_url` - Nginx service URL

## After Creation

1. SSH into the VM:
   ```bash
   ssh ubuntu@<vm_ip>
   ```

2. Nginx is running and accessible at `http://<vm_ip>`

3. Edit Nginx configuration:
   ```bash
   sudo vim /etc/nginx/sites-enabled/default
   sudo systemctl restart nginx
   ```

4. View Nginx logs:
   ```bash
   sudo tail -f /var/log/nginx/access.log
   ```
