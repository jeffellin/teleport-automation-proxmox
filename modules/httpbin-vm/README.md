# HTTPBin VM Module

A Terraform module for provisioning Linux VMs on Proxmox with HTTPBin service running in Docker, and optional Teleport integration.

## Overview

This module creates a Ubuntu VM that automatically installs Docker and runs the HTTPBin container. It's based on the AWS httpbin module from [tenaciousdlg/teleport_terraform](https://github.com/tenaciousdlg/teleport_terraform/tree/main/modules/app_httpbin) but adapted for Proxmox.

## Features

- **HTTPBin Service**: Automatically installs Docker and runs kennethreitz/httpbin container on port 80
- **DHCP Networking**: Automatically obtains IP address via DHCP
- **Optional Teleport Integration**: Can configure Teleport for secure access
- **Cloud-init Configuration**: Automated setup with package installation
- **Customizable Resources**: Adjust CPU, memory, and disk as needed
- **SSH Access**: Configure SSH keys for secure access

## Requirements

- **Terraform**: >= 1.0
- **Proxmox**: 7.0+ with API enabled
- **Provider**: `bpg/proxmox` >= 0.40.0
- **Template VM**: A Ubuntu cloud-init enabled template (default VM ID: 9000)

## Usage

### Basic HTTPBin VM (without Teleport)

```hcl
module "httpbin" {
  source = "./modules/httpbin-vm"

  vm_name        = "httpbin-server"
  vm_id          = 200
  ssh_public_key = var.ssh_public_key

  proxmox_endpoint = var.proxmox_host
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  proxmox_node     = "pve"

  vm_password = var.vm_password
}
```

### With Teleport Integration

```hcl
module "httpbin_with_teleport" {
  source = "./modules/httpbin-vm"

  vm_name        = "httpbin-server"
  vm_id          = 200
  ssh_public_key = var.ssh_public_key

  proxmox_endpoint = var.proxmox_host
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  proxmox_node     = "pve"

  vm_password = var.vm_password

  # Teleport configuration
  enable_teleport         = true
  teleport_proxy_address  = "teleport.example.com"
  teleport_version        = "14.0.0"
  teleport_token          = var.teleport_token
}
```

## Variables

### Required Variables

- `vm_name` - Name of the VM
- `vm_id` - Proxmox VM ID (must be unique)
- `ssh_public_key` - Your SSH public key
- `proxmox_endpoint` - Proxmox API endpoint
- `proxmox_username` - Proxmox username
- `proxmox_password` - Proxmox password
- `vm_password` - VM user password

### Optional Variables (with defaults)

- `proxmox_node` - Proxmox node name (default: "pve")
- `cpu_cores` - CPU cores (default: 2)
- `memory_mb` - Memory in MB (default: 4096)
- `disk_size` - Disk size in GB (default: 30)
- `username` - VM username (default: "ubuntu")
- `network_bridge` - Network bridge (default: "vmbr0")
- `template_id` - Template VM ID (default: 9000)
- `storage_pool` - Storage pool name (default: "SSD_2TB_1")
- `snippets_storage` - Snippets storage (default: "local")

### Teleport Variables

- `enable_teleport` - Enable Teleport integration (default: false)
- `teleport_proxy_address` - Teleport proxy address (no https://)
- `teleport_version` - Teleport version to install
- `teleport_token` - Teleport provision token (sensitive)

## Outputs

- `vm_id` - Proxmox VM ID
- `vm_name` - VM name
- `vm_ip` - VM IP address
- `vm_username` - SSH username
- `ssh_command` - SSH connection command
- `httpbin_url` - HTTPBin service URL

## What Gets Installed

The cloud-init configuration automatically installs:

- Docker and Docker Compose
- HTTPBin container (kennethreitz/httpbin) running on port 80
- Basic utilities (git, curl, wget, vim, htop, jq)
- QEMU Guest Agent
- Teleport (if enabled)

## Accessing HTTPBin

After the VM is provisioned:

1. SSH into the VM: `ssh ubuntu@<vm_ip>`
2. Access HTTPBin in your browser: `http://<vm_ip>`
3. Check Docker status: `docker ps`

## Notes

- VM IDs must be unique in your Proxmox cluster
- The HTTPBin container runs on port 80
- Default disk size is 30GB (sufficient for HTTPBin + Docker)
- Teleport integration is optional and disabled by default
- **DHCP**: The VM uses DHCP to obtain its IP address. The IP will be available in the outputs after the VM boots and the QEMU guest agent reports it

## License

[Your License Here]
