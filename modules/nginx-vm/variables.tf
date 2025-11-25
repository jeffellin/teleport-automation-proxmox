# Required variables
variable "vm_name" {
  description = "Name of the VM"
  type        = string
}

variable "vm_id" {
  description = "Proxmox VM ID (optional - will auto-assign if not specified)"
  type        = number
  default     = null
}


variable "ssh_public_key" {
  description = "SSH public key for accessing the VM"
  type        = string
}

# Proxmox Configuration
variable "proxmox_endpoint" {
  description = "Proxmox API endpoint (e.g., https://your-proxmox-host:8006/api2/json)"
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
  description = "Proxmox node name where the VM will be created"
  type        = string
  default     = "pve"
}

# Network Configuration

variable "network_bridge" {
  description = "Network bridge to use for VM"
  type        = string
  default     = "vmbr0"
}

variable "vm_ip" {
  description = "IP address to assign to the VM (CIDR prefix will be /24)"
  type        = string
}

variable "gateway_ip" {
  description = "Gateway IP address for the VM's network"
  type        = string
}

# VM Configuration
variable "cpu_cores" {
  description = "Number of CPU cores for the VM"
  type        = number
  default     = 2
}

variable "memory_mb" {
  description = "Memory in MB for the VM"
  type        = number
  default     = 4096
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 30
}

variable "username" {
  description = "Username for the VM (default: ubuntu)"
  type        = string
  default     = "ubuntu"
}

variable "vm_password" {
  description = "Password for the user on the VM"
  type        = string
  sensitive   = true
}

# Template Configuration
variable "template_id" {
  description = "VM ID of the Ubuntu cloud-init template to clone from"
  type        = number
  default     = 9000
}

# Storage Configuration
variable "storage_pool" {
  description = "Proxmox storage pool name"
  type        = string
  default     = "SSD_2TB_1"
}

variable "snippets_storage" {
  description = "Proxmox storage for snippets (must support snippets content type)"
  type        = string
  default     = "local"
}

# Cluster SSH Keys
variable "cluster_ssh_key_path" {
  description = "Path to the cluster SSH public key file"
  type        = string
  default     = ""
}

variable "cluster_ssh_private_key_path" {
  description = "Path to the cluster SSH private key file"
  type        = string
  default     = ""
}

# Teleport Configuration
variable "enable_teleport" {
  description = "Whether to enable Teleport configuration"
  type        = bool
  default     = false
}

variable "teleport_proxy_address" {
  description = "Teleport Proxy address (host only, no https://). Required if enable_teleport is true"
  type        = string
  default     = ""
}

variable "teleport_token" {
  description = "Teleport provision token. Required if enable_teleport is true"
  type        = string
  default     = ""
  sensitive   = true
}
