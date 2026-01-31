SHELL = /bin/bash
.PHONY: check
check: ## Run code quality tools.
	@echo "🚀 Checking lock file consistency with 'pyproject.toml'"
	@uv lock --locked
	@echo "🚀 Linting code: Running pre-commit"
	@uv run pre-commit run -a


# Ansible Commands
## Infrastructure
.PHONY: infra
infra:
	@echo "🚀 Making all infrastructure related resources"
	@ansible-playbook -K ./playbooks/initialize/all_infrastructure.yml
	@echo "🚀 Finished making all infrastructure related resources"

.PHONY: misc_infra
misc_infra:
	@echo "🚀 Making all misc infrastructure"
	@ansible-playbook -K ./playbooks/initialize/infrastructure/misc.yml
	@echo "🚀 Finished making all misc infrastructure related resources"

.PHONY: database
database:
	@echo "🚀 Making all database"
	@ansible-playbook -K ./playbooks/initialize/infrastructure/database.yml


## Public Services
.PHONY: public_services
public_services:
	@echo "🚀 Set Public Services"
	@ansible-playbook -K ./playbooks/initialize/public_services.yml

## K8
.PHONY: k8
k8:
	@echo "🚀 Configuring k8 nodes"
	@ansible-playbook -K ./playbooks/initialize/all_k8.yml

## Set Policies
.PHONY: set_policies
set_policies:
	@echo "🚀 Set Node Policies"
	@ansible-playbook -K ./playbooks/debian_policy.yml

## Set Policies
.PHONY: proxmox
proxmox:
	@echo "🚀 Configure Type 1 Hypervisor OS"
	@ansible-playbook -K ./playbooks/initialize/proxmox.yml

# Terraform Commands

## Network
### Cloudflare
.PHONY: cloudflare_zone_management
cloudflare_zone_management:
	@echo "🚀 Create Cloudflare Zone Management"
	@pushd "System Provision/Terraform/cloudflare/zone-management" && terraform apply || popd

.PHONY: cloudflare_zero_trust
cloudflare_zero_trust:
	@echo "🚀 Create Cloudflare Zero Trust"
	@pushd "System Provision/Terraform/cloudflare/zero-trust" && terraform apply || popd

### Router
.PHONY: router
router:
	@echo "🚀 Set Router config"
	@pushd "System Provision/Terraform/router" && terraform apply || popd

## AWS
### Storage
.PHONY: aws_storage
aws_storage:
	@echo "🚀 Make AWS Backup Storage"
	@pushd "System Provision/Terraform/aws/backup-storage" && terraform apply || popd

## VMs
.PHONY: vms
vms:
	@echo "🚀 Make VMs in Proxmox"
	@pushd "System Provision/Terraform/proxmox" && terraform apply || popd


.PHONY: homelab
homelab:
	@echo "🚀 Create Entire Homelab"
	@echo "#### Auxiliary Entities ####"
	@make cloudflare_zero_trust
	@make router
	@make aws_storage
	@echo "#### OS Entities ####"
	@echo "Proxmox OS initialize"
	@ansible-playbook -K ./playbooks/initialize/proxmox.yml
	@make vms
	@echo "VM OS initialize"
	@ansible-playbook -K ./playbooks/init_home_lab.ansible.yml
