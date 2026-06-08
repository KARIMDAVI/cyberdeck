#!/usr/bin/env bash

set -euo pipefail

log() {
  printf '[opi5b-postinstall] %s\n' "$*"
}

fail() {
  printf '[opi5b-postinstall] ERROR: %s\n' "$*" >&2
  exit 1
}

if [[ "${EUID}" -ne 0 ]]; then
  fail "run this script with sudo"
fi

target_user="${SUDO_USER:-}"
if [[ -z "${target_user}" || "${target_user}" == "root" ]]; then
  fail "run this as your normal user with sudo, for example: sudo ./opi5b_postinstall.sh"
fi

if ! id "${target_user}" >/dev/null 2>&1; then
  fail "user ${target_user} does not exist"
fi

export DEBIAN_FRONTEND=noninteractive

packages=(
  ca-certificates
  curl
  evtest
  git
  htop
  i2c-tools
  jq
  libinput-tools
  openssh-server
  python3-dev
  python3-pil
  python3-pip
  tmux
  ufw
  wget
)

install_missing_packages() {
  local missing=()
  local pkg

  for pkg in "${packages[@]}"; do
    if ! dpkg -s "${pkg}" >/dev/null 2>&1; then
      missing+=("${pkg}")
    fi
  done

  if [[ "${#missing[@]}" -eq 0 ]]; then
    log "base packages already installed"
    return
  fi

  log "installing packages: ${missing[*]}"
  apt-get install -y "${missing[@]}"
}

configure_i2c() {
  log "ensuring i2c-dev loads at boot"
  install -d /etc/modules-load.d
  printf 'i2c-dev\n' > /etc/modules-load.d/cyberdeck.conf
  modprobe i2c-dev || true

  if getent group i2c >/dev/null 2>&1; then
    usermod -aG i2c "${target_user}"
  fi
}

configure_firewall() {
  log "configuring ufw"
  ufw default deny incoming
  ufw default allow outgoing
  ufw allow OpenSSH
  ufw --force enable
}

configure_ssh() {
  local user_home authorized_keys ssh_dropin

  user_home="$(getent passwd "${target_user}" | cut -d: -f6)"
  authorized_keys="${user_home}/.ssh/authorized_keys"
  ssh_dropin="/etc/ssh/sshd_config.d/99-cyberdeck-hardening.conf"

  if [[ ! -s "${authorized_keys}" ]]; then
    log "skipping ssh hardening because ${authorized_keys} is missing or empty"
    return
  fi

  log "applying ssh hardening"
  install -d /etc/ssh/sshd_config.d
  cat > "${ssh_dropin}" <<'EOF'
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
PubkeyAuthentication yes
EOF

  sshd -t
  systemctl enable ssh
  systemctl reload ssh
}

main() {
  log "updating apt metadata"
  apt-get update

  log "upgrading installed packages"
  apt-get upgrade -y

  install_missing_packages
  configure_i2c
  configure_firewall
  configure_ssh

  log "complete"
  log "log out and back in if you want new group membership to apply for ${target_user}"
}

main "$@"
