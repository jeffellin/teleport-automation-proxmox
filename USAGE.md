# Using the Linux VM Module from GitHub

This guide shows how to use the `terraform-linux-vm` module as a GitHub module source in your own Terraform configurations.

## Prerequisites

1. Your GitHub repository must be public (or you have access with SSH keys)
2. Proxmox setup with cloud-init template VM
3. Terraform >= 1.0 installed

## Method 1: Direct GitHub Module Reference

Create a file in your project (e.g., `main.tf`):

```hcl
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

module "my_web_server" {
  source = "github.com/your-username/terraform-linux-vm//modules/linux-vm"
  # or with version tag: "github.com/your-username/terraform-linux-vm//modules/linux-vm?ref=v1.0.0"

  vm_name        = "web-server"
  vm_id          = 200
  vm_ip          = "192.168.1.10"
  ssh_public_key = var.ssh_public_key
  gateway_ip     = var.gateway_ip

  proxmox_endpoint  = var.proxmox_host
  proxmox_username  = var.proxmox_username
  proxmox_password  = var.proxmox_password
  proxmox_node      = var.proxmox_node

  cpu_cores   = 4
  memory_mb   = 8192
  disk_size   = 100
  vm_password = var.vm_password
  username    = "ubuntu"
}
```

## Method 2: Using Git Tags for Versioning

First, tag a release in GitHub:

```bash
git tag v1.0.0
git push origin v1.0.0
```

Then use the tag in your module source:

```hcl
module "my_vm" {
  source = "github.com/your-username/terraform-linux-vm//modules/linux-vm?ref=v1.0.0"
  # ... variables ...
}
```

## Method 3: SSH Git URL (for private repositories)

If your repository is private, use SSH:

```hcl
module "my_vm" {
  source = "git@github.com:your-username/terraform-linux-vm.git//modules/linux-vm"
  # ... variables ...
}
```

Configure SSH credentials in your CI/CD environment if needed.

## Complete Example Configuration

### variables.tf

```hcl
variable "proxmox_host" {
  description = "Proxmox API endpoint"
  type        = string
}

variable "proxmox_username" {
  description = "Proxmox username"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
  default     = "pve"
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
}

variable "gateway_ip" {
  description = "Network gateway IP"
  type        = string
}

variable "vm_password" {
  description = "VM password"
  type        = string
  sensitive   = true
}
```

### outputs.tf

```hcl
output "vm_details" {
  description = "VM details"
  value = {
    vm_id       = module.my_vm.vm_id
    vm_ip       = module.my_vm.vm_ip
    ssh_command = module.my_vm.ssh_command
  }
}
```

### terraform.tfvars

```hcl
proxmox_host     = "https://proxmox.example.com:8006/api2/json"
proxmox_username = "root@pam"
proxmox_password = "your-password"
ssh_public_key   = "ssh-ed25519 AAAA... your-key"
gateway_ip       = "192.168.1.1"
vm_password      = "secure-password"
```

## Workflow

1. Initialize Terraform (downloads module from GitHub):
   ```bash
   terraform init
   ```

2. Review the plan:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

## Updating the Module

To update to a new version of the module:

1. Update the `ref` in your module source (if using tags)
2. Run `terraform init` to download the latest version
3. Review changes with `terraform plan`
4. Apply changes with `terraform apply`

## Troubleshooting

### Module not found
- Ensure the repository is public or you have SSH access configured
- Check the repository URL is correct
- Verify the module path `//modules/linux-vm` is correct

### Authentication issues with private repos
- Set up SSH keys: `ssh-keygen -t ed25519`
- Add public key to GitHub
- Test SSH connection: `ssh -T git@github.com`

### Version conflicts
- Use `terraform version` to check your Terraform version (>= 1.0 required)
- Use `terraform providers` to verify provider versions

## Best Practices

1. **Pin versions**: Always use `?ref=v1.0.0` to pin specific versions
2. **Semantic versioning**: Use semantic versioning for tags (v1.0.0, v1.1.0, etc.)
3. **CHANGELOG**: Maintain a CHANGELOG.md documenting changes
4. **Testing**: Test module changes in isolation before releasing
5. **Documentation**: Keep README and examples up to date

## Example: Multi-Environment Setup

```hcl
# dev.tf
module "dev_server" {
  source = "github.com/your-username/terraform-linux-vm//modules/linux-vm?ref=v1.0.0"

  vm_name  = "dev-server"
  vm_id    = 100
  vm_ip    = "192.168.1.100"
  cpu_cores = 2
  memory_mb = 4096
  # ... other vars ...
}

# prod.tf
module "prod_web" {
  source = "github.com/your-username/terraform-linux-vm//modules/linux-vm?ref=v1.0.0"

  vm_name  = "prod-web"
  vm_id    = 200
  vm_ip    = "192.168.1.200"
  cpu_cores = 4
  memory_mb = 8192
  # ... other vars ...
}

module "prod_db" {
  source = "github.com/your-username/terraform-linux-vm//modules/linux-vm?ref=v1.0.0"

  vm_name  = "prod-db"
  vm_id    = 201
  vm_ip    = "192.168.1.201"
  cpu_cores = 8
  memory_mb = 16384
  # ... other vars ...
}
```

## Next Steps

1. Push this code to your GitHub repository
2. Create a release tag (e.g., `v1.0.0`)
3. Use the module in other Terraform projects
4. Keep the module updated as you make improvements
