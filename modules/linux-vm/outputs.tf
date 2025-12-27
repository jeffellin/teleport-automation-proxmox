output "vm_id" {
  description = "Proxmox VM ID"
  value       = proxmox_virtual_environment_vm.linux_vm.vm_id
}

output "vm_name" {
  description = "Name of the VM"
  value       = proxmox_virtual_environment_vm.linux_vm.name
}

output "vm_ip" {
  description = "IP address of the VM"
  value       = var.vm_ip
}

output "vm_username" {
  description = "Username for SSH access"
  value       = var.username
}

output "ssh_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh -i /path/to/private-key ${var.username}@${var.vm_ip}"
}

output "teleport_enabled" {
  description = "Whether Teleport is enabled"
  value       = var.enable_teleport
}

output "teleport_node_name" {
  description = "Teleport node name"
  value       = var.enable_teleport ? (var.teleport_node_name != "" ? var.teleport_node_name : var.vm_name) : null
}
