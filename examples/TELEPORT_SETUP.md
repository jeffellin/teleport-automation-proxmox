# Teleport Integration Setup

This guide explains how to set up Teleport integration with the HTTPBin VM.

## Prerequisites

1. A running Teleport cluster
2. Teleport CLI (`tsh`) installed locally
3. Admin access to your Teleport cluster

## Setup Steps

### 1. Generate a Teleport Identity File

First, log in to your Teleport cluster and generate an identity file for Terraform:

```bash
# Log in to Teleport
tsh login --proxy=your-teleport-proxy.com

# Generate an identity file for Terraform
tsh bot --output=identity.pem --user=terraform-bot --ttl=8h
```

Alternatively, if you have a bot user set up:

```bash
tctl auth sign --user=terraform-bot --out=identity.pem --ttl=8h
```

### 2. Provide the Teleport Provider Environment

If you have `tsh` and `tctl` available (Teleport 15+), the simplest workflow is:

```bash
tsh login --proxy=your-teleport-proxy.com
eval "$(tctl terraform env --identity=/path/to/identity.pem)"
```

The `tctl terraform env` command prints the `TELEPORT_ADDR` and `TELEPORT_IDENTITY_FILE` variables that the Terraform provider reads, so you do not need to export them manually.

If you are running in an environment without `tctl terraform env`, set the environment variables explicitly:

```bash
export TELEPORT_ADDR="your-teleport-proxy.com:443"
export TELEPORT_IDENTITY_FILE_PATH="/path/to/identity.pem"
```

### 3. Configure terraform.tfvars

Add the Teleport configuration to your `terraform.tfvars`:

```hcl
# Teleport Configuration
teleport_proxy_address = "your-teleport-proxy.com"
teleport_version       = "17.0.0"
```

### 4. Uncomment the Teleport Module

In `httpbin-vm.tf`, uncomment the `httpbin_with_teleport` module:

```hcl
module "httpbin_with_teleport" {
  source = "../modules/httpbin-vm"

  vm_name        = "httpbin-teleport"
  ssh_public_key = var.ssh_public_key

  # Proxmox configuration
  proxmox_endpoint = var.proxmox_host
  proxmox_username = var.proxmox_username
  proxmox_password = var.proxmox_password
  proxmox_node     = var.proxmox_node

  vm_password = var.vm_password
  username    = var.username

  # Teleport configuration
  enable_teleport        = true
  teleport_proxy_address = var.teleport_proxy_address
  teleport_version       = var.teleport_version
  teleport_token         = teleport_provision_token.httpbin_app.metadata.name
}
```

### 5. Initialize and Apply

```bash
terraform init
terraform plan
terraform apply
```

## What Gets Created

1. **Teleport Provision Token** (`teleport_provision_token.httpbin_app`): A token that allows the VM to join the Teleport cluster
2. **Teleport App Resource** (`teleport_app.httpbin`): Registers the HTTPBin application in Teleport
3. **VM with Teleport Agent**: The VM will automatically install and configure the Teleport agent using the provision token

## Accessing HTTPBin via Teleport

Once deployed, you can access HTTPBin through Teleport:

```bash
# List available apps
tsh apps ls

# Log in to the HTTPBin app
tsh apps login httpbin-basic

# Access the app (will open in browser or provide a local proxy)
tsh apps config httpbin-basic
```

## Troubleshooting

### Check Teleport agent status on the VM

```bash
ssh ubuntu@<vm-ip>
sudo systemctl status teleport
sudo journalctl -u teleport -f
```

### Verify the token

```bash
# On your local machine
tctl tokens ls
```

### Check Teleport logs during cloud-init

```bash
ssh ubuntu@<vm-ip>
sudo cat /var/log/cloud-init-output.log | grep -A 20 teleport
```

## Token Expiration

The provision token is created without an expiration by default. If you need to regenerate:

```bash
terraform taint teleport_provision_token.httpbin_app
terraform apply
```

## References

- [Teleport Terraform Provider Documentation](https://goteleport.com/docs/management/dynamic-resources/terraform-provider/)
- [Teleport Application Access](https://goteleport.com/docs/application-access/getting-started/)
- [Example from tenaciousdlg](https://github.com/tenaciousdlg/teleport_terraform/blob/main/environments/dev/main.tf)
