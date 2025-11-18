# Linux VM Module

A reusable Terraform module for provisioning Linux VMs on Proxmox with customizable resources.

## Usage

### Basic Example

```hcl
module "linux_vm" {
  source = "./modules/linux-vm"

  # Required variables
  vm_name        = "my-server"
  vm_id          = 100
  vm_ip          = "192.168.1.10"
  ssh_public_key = "ssh-ed25519 AAAA... your-public-key"

  # Proxmox configuration
  proxmox_endpoint  = "https://proxmox-host:8006/api2/json"
  proxmox_username  = "root@pam"
  proxmox_password  = var.proxmox_password
  proxmox_node      = "pve"

  # Network configuration
  gateway_ip = "192.168.1.1"

  # VM configuration (optional, defaults shown)
  cpu_cores    = 2
  memory_mb    = 4096
  disk_size    = 50

  # User configuration
  username    = "ubuntu"
  vm_password = var.vm_password
}
```

## Required Variables

| Name | Description | Type |
|------|-------------|------|
| `vm_name` | Name of the VM | string |
| `vm_id` | Proxmox VM ID | number |
| `vm_ip` | IP address to assign to the VM (CIDR prefix will be /24) | string |
| `ssh_public_key` | SSH public key for accessing the VM | string |
| `proxmox_endpoint` | Proxmox API endpoint | string |
| `proxmox_username` | Proxmox username | string |
| `proxmox_password` | Proxmox password | string |
| `gateway_ip` | Gateway IP address for the VM's network | string |

## Optional Variables

| Name | Description | Default |
|------|-------------|---------|
| `proxmox_node` | Proxmox node name | "pve" |
| `network_bridge` | Network bridge to use | "vmbr0" |
| `cpu_cores` | Number of CPU cores | 2 |
| `memory_mb` | Memory in MB | 4096 |
| `disk_size` | Disk size in GB | 50 |
| `username` | Username for the VM | "ubuntu" |
| `vm_password` | Password for the user | (required) |
| `template_id` | VM ID of the template to clone from | 9000 |
| `storage_pool` | Proxmox storage pool name | "SSD_2TB_1" |
| `snippets_storage` | Proxmox storage for snippets | "local" |
| `cluster_ssh_key_path` | Path to cluster SSH public key | "" |
| `cluster_ssh_private_key_path` | Path to cluster SSH private key | "" |

## Outputs

| Name | Description |
|------|-------------|
| `vm_id` | Proxmox VM ID |
| `vm_name` | Name of the VM |
| `vm_ip` | IP address of the VM |
| `vm_username` | Username for SSH access |
| `ssh_command` | SSH command to connect to the VM |

## Examples

### Multiple VM Example

See the `examples/multiple-vms.tf` file for a complete example showing how to create multiple VMs with different resource allocations.

### Quick Setup

1. Copy `examples/terraform.tfvars.example` to `examples/terraform.tfvars`
2. Fill in your Proxmox credentials and SSH key
3. Run:
   ```bash
   cd examples
   terraform init
   terraform plan
   terraform apply
   ```
