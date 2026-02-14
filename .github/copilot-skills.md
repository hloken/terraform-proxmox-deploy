# Project Skills - Terraform Proxmox Deployment

## Project Overview
This project automates the deployment of Talos Linux virtual machines on Proxmox VE using Terraform. It manages infrastructure as code for a Kubernetes cluster.

## Technology Stack
- **Infrastructure**: Proxmox Virtual Environment
- **IaC Tool**: Open-Tofu (using bpg/proxmox provider)
- **OS**: Talos Linux
- **Target**: Kubernetes cluster setup

## Project Structure
```
├── cluster.tf              # Cluster-level resources and configurations
├── files.tf                # File downloads and management (OS images)
├── main.tf                 # Provider configuration
├── providers.tf            # Provider declarations
├── variables.tf            # Variable definitions
├── virtual_machines.tf     # VM resource definitions
└── terraform.tfstate       # State files (not in version control)
```

## Coding Conventions

### File Organization
- **files.tf**: Download and manage installation images and snippets
- **virtual_machines.tf**: Define individual VM resources
- **variables.tf**: All input variables with descriptions
- **cluster.tf**: Cluster-wide resources and configurations

### Naming Patterns
- VM resources: `proxmox_virtual_environment_vm.<name>`
- File resources: `proxmox_virtual_environment_download_file.<name>`
- Naming convention: `talos_<role>_<number>` (e.g., `talos_cp_01` for control plane)
- Tags: Always include `["terraform"]` for managed resources

### VM Configuration Standards
- **CPU Type**: `x86-64-v2-AES`
- **Network Bridge**: `vmbr0`
- **Storage**: `local` datastore
- **OS Type**: `l26` (Linux Kernel 2.6 - 5.X)
- **Agent**: Enabled (`enabled = true`)
- **Boot**: Auto-start on host boot (`on_boot = true`)

### Talos Linux Specifics
- Version managed via locals in files.tf
- Images downloaded from factory.talos.dev
- NoCloud format for cloud-init
- Raw disk format with gzip compression

### Network Configuration
- IPv4: Static assignment via variables
- IPv6: DHCP
- Gateway: Defined via `default_gateway` variable
- IP format: CIDR notation (e.g., `192.168.1.10/24`)

## Common Patterns

### Adding a New VM
1. Define VM resource in `virtual_machines.tf`
2. Add IP address variable in `variables.tf`
3. Reference downloaded image: `proxmox_virtual_environment_download_file.talos_nocloud_image.id`
4. Configure initialization block with network settings

### Variable References
- IP addresses: `var.<vm_name>_ip_addr`
- Gateway: `var.default_gateway`
- Proxmox endpoint: `var.proxmox_endpoint`
- API token: `var.proxmox_api_token`

### Resource Dependencies
- VMs depend on downloaded images (implicit via `file_id`)
- Use `depends_on` for explicit dependencies when needed

## Best Practices
1. Always use variables for environment-specific values (IPs, endpoints)
2. Include descriptive tags on all resources
3. Use consistent naming for control plane (`cp`) and worker nodes
4. Keep Talos version centralized in locals
5. Enable VM agent for better management
6. Use raw disk format for Talos images
7. Configure both IPv4 (static) and IPv6 (DHCP)

## Terraform Workflow
```bash
terraform init      # Initialize providers
terraform plan      # Preview changes
terraform apply     # Apply changes
terraform destroy   # Tear down infrastructure
```

## Node Naming Convention
- **Control Plane**: `talos-cp-<number>` (e.g., `talos-cp-01`)
- **Worker Nodes**: `talos-worker-<number>` (e.g., `talos-worker-01`)
- **Resource Names**: Use underscores in Terraform: `talos_cp_01`

## Provider Configuration
- Provider: `bpg/proxmox`
- Authentication: API token-based
- SSH: Uses SSH agent for file operations
- TLS verification: Disabled (`insecure = true`) - adjust for production

## Common Operations

### Scaling the Cluster
- Add new VM resource block in `virtual_machines.tf`
- Define IP address variable
- Apply changes with `terraform apply`

### Updating Talos Version
- Modify version in `locals.talos.version` in `files.tf`
- Existing VMs won't be affected (image is already deployed)
- New VMs will use the updated version

### Modifying VM Resources
- Update CPU cores, memory, or disk size in VM resource
- Run `terraform apply` to update the VM
- Some changes may require VM recreation
