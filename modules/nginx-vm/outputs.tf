output "vm_id" {
  description = "Proxmox VM ID"
  value       = proxmox_virtual_environment_vm.nginx_vm.vm_id
}

output "vm_name" {
  description = "VM name"
  value       = proxmox_virtual_environment_vm.nginx_vm.name
}

output "vm_ip" {
  description = "VM IP address (DHCP-assigned)"
  value       = try(proxmox_virtual_environment_vm.nginx_vm.ipv4_addresses[1][0], "IP not yet available")
}

output "vm_username" {
  description = "SSH username"
  value       = var.username
}

output "ssh_command" {
  description = "SSH connection command"
  value       = "ssh ${var.username}@${try(proxmox_virtual_environment_vm.nginx_vm.ipv4_addresses[1][0], "<IP_ADDRESS>")}"
}

output "nginx_url" {
  description = "Nginx service URL"
  value       = "http://${try(proxmox_virtual_environment_vm.nginx_vm.ipv4_addresses[1][0], "<IP_ADDRESS>")}"
}
