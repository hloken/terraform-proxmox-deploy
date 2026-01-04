terraform {
  required_providers {
    proxmox = {
        source = "bpg/proxmox"
        version = "0.91.0"
    }    
  }
}

provider "proxmox" {
  virtual environment {
    endpoint = var.proxmox_endpoint
    username = var.proxmox_username
    password = var.proxmox_password
    # insecure = true
  }
}