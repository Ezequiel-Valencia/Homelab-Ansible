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

.PHONY: homelab
homelab:
	@echo "🚀 Create Entire Homelab"
	@echo "Proxmox initialize"
	@ansible-playbook -K ./playbooks/initialize/proxmox.yml
	@echo "VM initialize"
	@ansible-playbook -K ./playbooks/init_home_lab.ansible.yml
