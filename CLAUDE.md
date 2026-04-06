# CLAUDE.md — Terraform Proxmox Deploy

This project deploys a Talos Linux Kubernetes cluster on Proxmox VE using OpenTofu and the `bpg/proxmox` provider.

## Commands

Use `tofu`, not `terraform`:

```bash
tofu init       # Initialize providers
tofu plan       # Preview changes
tofu apply      # Apply changes
tofu destroy    # Tear down infrastructure
```

## File Responsibilities

| File | Purpose |
|------|---------|
| `files.tf` | Image downloads (Talos nocloud image) |
| `virtual_machines.tf` | VM resource definitions |
| `variables.tf` | All input variables |
| `cluster.tf` | Talos machine config, bootstrap, health check, kubeconfig output |
| `providers.tf` | Provider declarations and version pins |
| `main.tf` | Provider configuration (credentials, endpoint) |

Do not put VM resources in `cluster.tf` or Talos config in `virtual_machines.tf`.

## Naming Conventions

- Terraform resource names use underscores: `talos_cp_01`, `talos_worker_01`
- VM hostnames use hyphens: `talos-cp-01`, `talos-worker-01`
- Role abbreviations: `cp` for control plane, `worker` for worker nodes
- IP address variables: `var.<resource_name>_ip_addr` (e.g., `var.talos_cp_01_ip_addr`)

## VM Configuration Standards

Every VM must have:
- `tags = ["terraform"]`
- `on_boot = true`
- `cpu.type = "x86-64-v2-AES"`
- `operating_system.type = "l26"`
- `disk.file_format = "raw"`, `disk.datastore_id = "local-lvm"`, `disk.interface = "virtio0"`
- `network_device.bridge = "vmbr0"`
- Static IPv4 (CIDR `/24`) + DHCP IPv6 in the `initialization` block

## Known Gotchas — Do Not "Fix" These

**`agent { enabled = false }`** — Talos Linux does not run the QEMU guest agent. Do not suggest enabling it.

**`tofu apply` takes a long time** — This is expected. The `talos_cluster_health` data source blocks until the cluster is fully bootstrapped. It is not hung; do not suggest timeouts or workarounds unless asked.

**`insecure = true` on the provider** — TLS verification is intentionally disabled for the homelab Proxmox instance. Do not flag this as a bug.

**`overwrite = false` on the image download** — Intentional. The Talos image is large; re-downloading it on every apply would be wasteful.

**Worker depends on control plane VM** — `talos_worker_01` has `depends_on = [proxmox_virtual_environment_vm.talos_cp_01]`. This is intentional sequencing, not a mistake.

## Best Practices

- Use variables for all environment-specific values (IPs, endpoints, credentials) — never hardcode them
- Tag all managed resources with `["terraform"]`
- Keep naming consistent: underscores in resource names, hyphens in VM hostnames
- Keep the Talos version centralized in `locals.talos.version` in `files.tf` — never inline it in resource blocks
- Always use raw disk format for Talos images
- Configure both IPv4 (static) and IPv6 (DHCP) in every VM's `initialization` block
- Do not enable the QEMU guest agent — Talos does not support it (see Gotchas)

## Adding a New VM

1. Add a resource block in `virtual_machines.tf` following the existing pattern
2. Add an IP variable in `variables.tf` with a sensible default
3. Add a `talos_machine_configuration` data source and `talos_machine_configuration_apply` resource in `cluster.tf`
4. Add the new node IP to `talos_cluster_health` control_plane_nodes or worker_nodes as appropriate

## Talos Version

Managed in a single local in `files.tf`:

```hcl
locals {
  talos = {
    version = "v1.12.0"
  }
}
```

Update this value to change the version for new VMs. Existing VMs are unaffected (image already deployed, `overwrite = false`).

## Sensitive Outputs

`talosconfig` and `kubeconfig` are marked `sensitive = true`. Retrieve them with:

```bash
tofu output -raw talosconfig
tofu output -raw kubeconfig
```

## Proxmox Node

The Proxmox node name is `halnuc`. All resources target this node. Authentication uses an API token (`proxmox_api_token`) plus SSH for file operations (`proxmox_ssh_username`, defaults to `root`).
