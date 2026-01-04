# terraform-proxmox-deploy
Terraform IaC for setting up Linux for hosting containers on ProxMox host

# Environment variables
* proxmox_username - ProxMox username
* proxmox_password - ProxMox password
* proxmox_endpoint - ProxMox endpoint

Simplest is to create a local .envrc-file, i.e.

```
export proxmox_username=root@pam
export proxmox_password=very-secret-password    
export proxmox_endpoint="https://10.0.0.1:8006/"
```