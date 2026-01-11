.PHONY: check
check: ## Run code quality tools.
	@echo "🚀 Checking lock file consistency with 'pyproject.toml'"
	@uv lock --locked
	@echo "🚀 Linting code: Running pre-commit"
	@uv run pre-commit run -a


# Ansible Commands
## Infrastructure
.PHONY: infra
infra: ## Run code quality tools.
	@echo "🚀 Making all infrastructure related resources"
	@ansible-playbook -K ./playbooks/initialize/all_infrastructure.yml
	@echo "🚀 Finished making all infrastructure related resources"

.PHONY: misc_infra
misc_infra: ## Run code quality tools.
	@echo "🚀 Making all misc infrastructure"
	@ansible-playbook -K ./playbooks/initialize/infrastructure/misc.yml
	@echo "🚀 Finished making all misc infrastructure related resources"
