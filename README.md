# terraform-linux-vm

A Terraform module for provisioning Linux VMs on Proxmox with customizable CPU, memory, disk, and networking.

## Overview

This module provides a reusable way to create Ubuntu Linux virtual machines on Proxmox. It includes cloud-init configuration for initial setup and supports multiple VMs with different resource allocations.

## Key Features

- **Reusable Module**: Use the `linux-vm` module to provision multiple VMs with different configurations
- **Customizable Resources**: Easily adjust CPU cores, memory, disk size
- **SSH Access**: Configure SSH keys for secure access
- **Cloud-init**: Automatic package installation and system configuration
- **Network Configuration**: Static IP assignment with gateway configuration

## Module Usage

### As a GitHub Module

To use this module from GitHub in your Terraform code:

```hcl
module "my_vm" {
  source = "github.com/your-org/terraform-linux-vm//modules/linux-vm"

  vm_name        = "my-server"
  vm_id          = 100
  vm_ip          = "192.168.1.10"
  ssh_public_key = var.ssh_public_key
  gateway_ip     = "192.168.1.1"

  proxmox_endpoint  = var.proxmox_host
  proxmox_username  = var.proxmox_username
  proxmox_password  = var.proxmox_password
  proxmox_node      = "pve"

  vm_password = var.vm_password
}
```

### Local Module Usage

For local development, use a relative path:

```hcl
module "my_vm" {
  source = "./modules/linux-vm"
  # ... variables ...
}
```

## Requirements

- **Terraform**: >= 1.0
- **Proxmox**: 7.0+ with API enabled
- **Provider**: `bpg/proxmox` >= 0.40.0
- **Template VM**: A Ubuntu cloud-init enabled template (default VM ID: 9000)

## Quick Start

### 1. Create terraform.tfvars

Copy and customize the example:

```bash
cp examples/terraform.tfvars.example terraform.tfvars
```

Update with your values:

```hcl
proxmox_host     = "https://your-proxmox:8006/api2/json"
proxmox_username = "root@pam"
proxmox_password = "your-password"

ssh_public_key = "ssh-ed25519 AAAA... your-public-key"
vm_password    = "your-vm-password"
```

### 2. Run Terraform

```bash
terraform init
terraform plan
terraform apply
```

## Module Variables

### Required

- `vm_name` - Name of the VM
- `vm_id` - Proxmox VM ID (must be unique)
- `vm_ip` - IP address (e.g., 192.168.1.10)
- `ssh_public_key` - Your SSH public key
- `gateway_ip` - Network gateway IP
- `proxmox_endpoint` - Proxmox API endpoint
- `proxmox_username` - Proxmox username
- `proxmox_password` - Proxmox password

### Optional (with defaults)

- `proxmox_node` - Proxmox node name (default: "pve")
- `cpu_cores` - CPU cores (default: 2)
- `memory_mb` - Memory in MB (default: 4096)
- `disk_size` - Disk size in GB (default: 50)
- `username` - VM username (default: "ubuntu")
- `vm_password` - VM password
- `network_bridge` - Network bridge (default: "vmbr0")
- `template_id` - Template VM ID (default: 9000)
- `storage_pool` - Storage pool name (default: "SSD_2TB_1")
- `snippets_storage` - Snippets storage (default: "local")

## Outputs

- `vm_id` - Proxmox VM ID
- `vm_name` - VM name
- `vm_ip` - VM IP address
- `vm_username` - SSH username
- `ssh_command` - SSH connection command

## Examples

### Create Multiple VMs

See `examples/multiple-vms.tf` for creating a complete infrastructure with web, database, and monitoring servers.

### Access Your VM

After provisioning, connect via SSH:

```bash
ssh -i /path/to/private-key ubuntu@192.168.1.10
```

## File Structure

```
.
├── README.md                          # This file
├── main.tf                           # Root configuration using the module
├── variables.tf                      # Root variables
├── outputs.tf                        # Root outputs
├── modules/
│   └── linux-vm/                     # Reusable VM module
│       ├── main.tf                   # VM resource definitions
│       ├── variables.tf              # Module variables
│       ├── outputs.tf                # Module outputs
│       ├── cloud-init.yaml.tftpl     # Cloud-init template
│       └── README.md                 # Module documentation
└── examples/
    ├── multiple-vms.tf               # Example: multiple VMs
    ├── variables.tf                  # Example variables
    ├── outputs.tf                    # Example outputs
    └── terraform.tfvars.example      # Configuration template
```

## Cloud-init Features

The module automatically configures:

- Hostname and FQDN
- SSH key-based authentication
- Package updates and basic utilities (git, curl, wget, vim, htop)
- QEMU Guest Agent for better VM management
- Network tools and configuration

## Notes

- VM IDs must be unique in your Proxmox cluster
- Default template VM should have cloud-init pre-configured
- SSH public key is required for initial access
- All VMs use /24 subnet mask (configurable if needed)

## License

[Your License Here]

## Support

For issues, questions, or contributions, please open an issue or pull request on GitHub.
