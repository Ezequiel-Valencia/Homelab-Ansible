#!/usr/bin/env bash
# =============================================================================
# deploy_ssh_key.sh
# Deploys a public SSH key for the "test" user on a list of remote hosts.
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration – edit these or pass them as environment variables
# ---------------------------------------------------------------------------

# SSH user that already has access to the remote hosts (used to log in)
SSH_USER="${SSH_USER:-zeke}"

# SSH private key used to authenticate the deployment connection
SSH_KEY="${SSH_KEY:-$HOME/.ssh/homelab}"

# SSH port on the remote hosts
SSH_PORT="${SSH_PORT:-5320}"

# Target username whose authorized_keys we are updating
TARGET_USER="zeke"

# ---------------------------------------------------------------------------
# Colour helpers
# ---------------------------------------------------------------------------
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

info()    { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }

usage() {
  echo "Usage: $0 <public_key_path> <hosts_file>"
  echo ""
  echo "  public_key_path  Path to the .pub key to deploy (required)"
  echo "  hosts_file       File with one IP/hostname per line (required)"
  echo ""
  echo "Example: $0 ~/.ssh/id_rsa.pub hosts.txt"
}

# ---------------------------------------------------------------------------
# Pre-flight checks
# ---------------------------------------------------------------------------
if [[ $# -lt 2 ]]; then
  error "Missing required arguments."
  usage
  exit 1
fi

PUBLIC_KEY_PATH="$1"
HOSTS_FILE="$2"

if [[ ! -f "$PUBLIC_KEY_PATH" ]]; then
  error "Public key not found: $PUBLIC_KEY_PATH"
  exit 1
fi

if [[ ! -f "$HOSTS_FILE" ]]; then
  error "Hosts file not found: $HOSTS_FILE"
  exit 1
fi

PUBLIC_KEY="$(cat "$PUBLIC_KEY_PATH")"

# ---------------------------------------------------------------------------
# Confirmation step
# ---------------------------------------------------------------------------
echo ""
echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}  Deployment plan — please review${NC}"
echo -e "${YELLOW}========================================${NC}"

echo ""
echo -e "  ${GREEN}Target user:${NC}   $TARGET_USER"
echo -e "  ${GREEN}Connect as:${NC}    $SSH_USER"
echo -e "  ${GREEN}SSH port:${NC}      $SSH_PORT"

echo ""
echo -e "  ${GREEN}Public key:${NC}    $PUBLIC_KEY_PATH"
echo    "  ┌─────────────────────────────────────────────────"
echo    "  │  $PUBLIC_KEY"
echo    "  └─────────────────────────────────────────────────"

echo ""
echo -e "  ${GREEN}Target hosts:${NC}"
while IFS= read -r line || [[ -n "$line" ]]; do
  host="${line%%#*}"
  host="${host//[$'\t' ]}"
  [[ -z "$host" ]] && continue
  echo "    • $host"
done < "$HOSTS_FILE"

echo ""
echo -e "${YELLOW}========================================${NC}"
echo -e "This will add the above key to ${GREEN}~$TARGET_USER/.ssh/authorized_keys${NC}"
echo -e "on every host listed above."
echo -e "${YELLOW}========================================${NC}"
echo ""
read -r -p "Proceed with deployment? [y/N] " confirm
echo ""

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  warn "Aborted by user."
  exit 0
fi

# ---------------------------------------------------------------------------
# Common SSH / SCP flags (no host-key prompts; quiet; timeout)
# ---------------------------------------------------------------------------
SSH_OPTS=(
  -i "$SSH_KEY"
  -p "$SSH_PORT"
  -o StrictHostKeyChecking=no
  -o BatchMode=yes
  -o ConnectTimeout=10
  -o LogLevel=ERROR
)

# ---------------------------------------------------------------------------
# Deploy function – called once per host
# ---------------------------------------------------------------------------
deploy_key() {
  local host="$1"

  info "[$host] Connecting..."

  ssh "${SSH_OPTS[@]}" "${SSH_USER}@${host}" bash <<EOF
set -euo pipefail

TARGET_USER="${TARGET_USER}"
PUBLIC_KEY="${PUBLIC_KEY}"

# ── Ensure the user exists ────────────────────────────────────────────────
if ! id "\$TARGET_USER" &>/dev/null; then
  echo "[remote] User does not exist: \$TARGET_USER"
  exit 1
fi

# ── Set up .ssh directory ─────────────────────────────────────────────────
SSH_DIR="\$(eval echo ~\$TARGET_USER)/.ssh"
AUTH_KEYS="\$SSH_DIR/authorized_keys"

mkdir -p "\$SSH_DIR"
chmod 700 "\$SSH_DIR"
chown "\$TARGET_USER:\$TARGET_USER" "\$SSH_DIR"

# ── Append key only if not already present ────────────────────────────────
if grep -qF "\$PUBLIC_KEY" "\$AUTH_KEYS" 2>/dev/null; then
  echo "[remote] Key already present in authorized_keys - skipping."
else
  echo "\$PUBLIC_KEY" >> "\$AUTH_KEYS"
  echo "[remote] Key appended to authorized_keys."
fi

chmod 600 "\$AUTH_KEYS"
chown "\$TARGET_USER:\$TARGET_USER" "\$AUTH_KEYS"

echo "[remote] Done."
EOF
}

# ---------------------------------------------------------------------------
# Main loop – iterate over hosts file
# ---------------------------------------------------------------------------
SUCCESS=(); FAILED=()

while IFS= read -r line || [[ -n "$line" ]]; do
  # Strip comments and blank lines
  host="${line%%#*}"          # remove inline comments
  host="${host//[$'\t' ]}"    # strip whitespace
  [[ -z "$host" ]] && continue

  if deploy_key "$host"; then
    info "[$host] ✓ Success"
    SUCCESS+=("$host")
  else
    error "[$host] ✗ Failed"
    FAILED+=("$host")
  fi
  echo ""
done < "$HOSTS_FILE"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo "========================================"
echo "  Deployment summary"
echo "========================================"
echo -e "  ${GREEN}Succeeded${NC}: ${#SUCCESS[@]}"
for h in "${SUCCESS[@]}"; do echo "    ✓ $h"; done
echo -e "  ${RED}Failed${NC}:    ${#FAILED[@]}"
for h in "${FAILED[@]}"; do echo "    ✗ $h"; done
echo "========================================"

[[ ${#FAILED[@]} -eq 0 ]] && exit 0 || exit 1