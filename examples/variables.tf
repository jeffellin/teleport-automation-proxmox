# Proxmox Provider Configuration
variable "proxmox_host" {
  description = "Proxmox host URL (e.g., https://your-proxmox-host:8006/api2/json)"
  type        = string
}

variable "proxmox_username" {
  description = "Proxmox username (e.g., root@pam)"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Proxmox node name where the VMs will be created"
  type        = string
  default     = "pve"
}

# Common VM Configuration
variable "ssh_public_key" {
  description = "SSH public key for accessing the VMs"
  type        = string
}

variable "vm_password" {
  description = "Password for the user on the VMs"
  type        = string
  sensitive   = true
}

variable "username" {
  description = "Username for the VMs (default: ubuntu)"
  type        = string
  default     = "ubuntu"
}
