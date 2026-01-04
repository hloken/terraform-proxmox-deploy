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
  default = "10.1.1.10"
}

variable "talos_worker_01_ip_addr" {
  type    = string
  default = "10.1.1.11"
}

variable "proxmox_endpoint" {
  type = string
  description = "Proxmox API endpoint URL"
}

variable "proxmox_username" {
  type = string
  description = "Proxmox username"
}

variable "proxmox_password" {
  type = string
  description = "Proxmox password"
  sensitive = true
}