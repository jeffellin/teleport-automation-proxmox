#!/bin/bash

set -euo pipefail

# Script to run terraform apply with SSH public key from 1Password

# Check if 1Password CLI is installed
if ! command -v op &> /dev/null; then
    echo "Error: 1Password CLI (op) is not installed or not in PATH"
    exit 1
fi

# Check if user is signed in to 1Password
if ! op whoami &> /dev/null; then
    echo "Error: Not signed in to 1Password. Please run 'op signin' first"
    exit 1
fi

# Retrieve SSH public key from 1Password
echo "Retrieving SSH public key from 1Password..."
echo "Attempting: op read 'op://Private/cloudimg/public key'"
SSH_PUBLIC_KEY=$(op read "op://Private/cloudimg/public key" 2>&1) && success=true || success=false



if [ -z "$SSH_PUBLIC_KEY" ]; then
    echo "Error: Could not retrieve SSH public key from 1Password vault"
    echo "Please ensure the key exists at one of these locations:"
    echo "  - op://cloudimg/ssh_public_key/public key"
    echo "  - op://cloudimg/ssh/public key"
    echo ""
    echo "Debug info: $SSH_PUBLIC_KEY"
    exit 1
fi

echo "Successfully retrieved SSH public key"

# Run terraform apply with the SSH public key
echo "Running terraform apply..."
terraform apply \
    -var="ssh_public_key=$SSH_PUBLIC_KEY" \
    "$@"

echo "Terraform apply completed successfully!"
