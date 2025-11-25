# Teleport Provider Configuration
# This file sets up the Teleport provider and creates a provision token
# that can be used by VMs to join the Teleport cluster

# Configure the Teleport provider
# Set TELEPORT_ADDR and TELEPORT_IDENTITY_FILE or TELEPORT_IDENTITY_FILE_PATH environment variables
provider "teleport" {
  # addr should be set via TELEPORT_ADDR environment variable
  # or explicitly: addr = "teleport.example.com:443"
  
  # Identity file should be set via TELEPORT_IDENTITY_FILE_PATH or TELEPORT_IDENTITY_FILE
  # or use certificate_path, key_path, and root_ca_path
}

# Create a provision token for app service
resource "teleport_provision_token" "httpbin_app" {
  version = "v2"

  metadata = {
    name = "httpbin-app-token"
    labels = {
      env     = "dev"
      service = "httpbin"
    }
  }

  spec = {
    roles = ["App"]

    # Token expires in 1 hour (3600 seconds)
    # Adjust as needed
    join_method = "token"
  }

  # Ignore system-managed labels added by Teleport provider
  lifecycle {
    ignore_changes = [metadata]
  }
}

# Create an app resource for HTTPBin
# Commented out - the app will be created by the userdata script
# Once the app is successfully created in Teleport, uncomment this and import it:
# terraform import teleport_app.httpbin httpbin
#
# resource "teleport_app" "httpbin" {
#   version = "v3"
#
#   metadata = {
#     name = "httpbin"
#     labels = {
#       env     = "dev"
#       service = "httpbin"
#     }
#   }
#
#   spec = {
#     uri = "http://httpbin"
#
#     # Optional: set public_addr if you want a specific subdomain
#     # public_addr = "httpbin-dev.teleport.example.com"
#   }
#
#   # Ignore system-managed labels added by Teleport provider
#   lifecycle {
#     ignore_changes = [metadata]
#   }
# }

# Output the token for use in cloud-init
output "teleport_app_token" {
  description = "Teleport provision token for app service"
  value       = teleport_provision_token.httpbin_app.metadata.name
  sensitive   = true
}
