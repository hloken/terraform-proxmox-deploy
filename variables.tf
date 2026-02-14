variable "cluster_name" {
  type    = string
  default = "homelab"
}

variable "default_gateway" {
  type    = string
  default = "10.0.0.1"
}

variable "talos_cp_01_ip_addr" {
  type    = string
  default = "10.0.0.210"
}

variable "talos_worker_01_ip_addr" {
  type    = string
  default = "10.0.0.211"
}

variable "proxmox_endpoint" {
  type = string
  description = "Proxmox API endpoint URL"
}

variable "proxmox_api_token" {
  type = string
  description = "Proxmox API token (format: USER@REALM!TOKENID=SECRET)"
  sensitive = true
}

variable "proxmox_ssh_username" {
  type = string
  description = "SSH username for Proxmox host (usually 'root')"
  default = "root"
}