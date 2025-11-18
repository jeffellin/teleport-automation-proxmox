output "web_server" {
  description = "Web server VM details"
  value = {
    vm_id       = module.web_server.vm_id
    vm_name     = module.web_server.vm_name
    vm_ip       = module.web_server.vm_ip
    ssh_command = module.web_server.ssh_command
  }
}

output "database_server" {
  description = "Database server VM details"
  value = {
    vm_id       = module.database_server.vm_id
    vm_name     = module.database_server.vm_name
    vm_ip       = module.database_server.vm_ip
    ssh_command = module.database_server.ssh_command
  }
}

output "monitoring_server" {
  description = "Monitoring server VM details"
  value = {
    vm_id       = module.monitoring_server.vm_id
    vm_name     = module.monitoring_server.vm_name
    vm_ip       = module.monitoring_server.vm_ip
    ssh_command = module.monitoring_server.ssh_command
  }
}
