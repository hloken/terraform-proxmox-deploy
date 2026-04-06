provider "proxmox" {
    endpoint = var.proxmox_endpoint
    api_token = var.proxmox_api_token
    insecure = true
    ssh {
        agent = true
        username = var.proxmox_ssh_username
    }
}

provider "proxmox" {
    alias    = "halnuc2"
    endpoint = var.proxmox_endpoint_halnuc2
    api_token = var.proxmox_api_token
    insecure = true
    ssh {
        agent = true
        username = var.proxmox_ssh_username
    }
}