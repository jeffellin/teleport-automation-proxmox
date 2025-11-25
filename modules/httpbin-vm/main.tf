terraform {
  required_version = ">= 1.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.40.0"
    }
  }
}

resource "proxmox_virtual_environment_vm" "httpbin_vm" {
  name      = var.vm_name
  node_name = var.proxmox_node
  vm_id     = var.vm_id

  clone {
    vm_id = var.template_id
    full  = true
  }

  agent {
    enabled = true
    timeout = "5m"
  }

  started = true

  cpu {
    cores = var.cpu_cores
    type  = "host"
  }

  memory {
    dedicated = var.memory_mb
  }

  disk {
    datastore_id = var.storage_pool
    interface    = "scsi0"
    size         = var.disk_size
    file_format  = "raw"
  }

  network_device {
    bridge = var.network_bridge
  }

  initialization {
    user_account {
      username = var.username
      password = var.vm_password
      keys     = concat(
        [var.ssh_public_key],
        var.cluster_ssh_key_path != "" ? [file(var.cluster_ssh_key_path)] : []
      )
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_init.id
  }

  tags = ["linux", "terraform", "httpbin"]
}

resource "proxmox_virtual_environment_file" "cloud_init" {
  content_type = "snippets"
  datastore_id = var.snippets_storage
  node_name    = var.proxmox_node

  source_raw {
    data = templatefile("${path.module}/cloud-init.yaml.tftpl", {
      hostname                    = var.vm_name
      ssh_public_key              = var.ssh_public_key
      cluster_ssh_key             = var.cluster_ssh_key_path != "" ? file(var.cluster_ssh_key_path) : "# No cluster key"
      cluster_ssh_private_key     = var.cluster_ssh_private_key_path != "" ? file(var.cluster_ssh_private_key_path) : "# No cluster key"
      teleport_proxy_address      = var.teleport_proxy_address
      teleport_token              = var.teleport_token
      enable_teleport             = var.enable_teleport
    })

    file_name = "cloud-init-${var.vm_name}.yaml"
  }
}
