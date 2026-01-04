# terraform-proxmox-deploy
Terraform IaC for setting up Linux for hosting containers on ProxMox host

# Environment variables
* TF_VAR_proxmox_api_token - ProxMox root API key, uncheck Privilege Separation
* TF_VAR_proxmox_endpoint - ProxMox endpoint

Simplest is to create a local .envrc-file, i.e.

```
export TF_VAR_proxmox_api_token=root@pam!TOKEN_NAME=TOKEN_SECRET
export TF_VAR_proxmox_endpoint="https://10.0.0.¨1:8006" 
```