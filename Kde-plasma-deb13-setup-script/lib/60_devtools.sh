#!/usr/bin/env bash
set -euo pipefail

install_vscode() {
  pm_install_smart ca-certificates curl gnupg
  run_step_allow_fail "Create /etc/apt/keyrings" install -d -m 0755 /etc/apt/keyrings
  run_step_allow_fail "Add Microsoft key" bash -lc "curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg"
  run_step_allow_fail "chmod keyring" chmod 0644 /etc/apt/keyrings/microsoft.gpg
  run_step_allow_fail "Add vscode repo list" bash -lc "echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main' > /etc/apt/sources.list.d/vscode.list"
  run_step_allow_fail "apt-get update (vscode repo)" apt-get update
  pm_install_smart code
}

install_web_stack() {
  pm_install_smart nodejs npm
  pm_install_smart php php-cli php-fpm php-sqlite3 sqlite3
  pm_install_smart nginx redis-server postgresql-client
  pm_install_smart ripgrep fd-find
}

install_yocto_deps() {
  pm_install_smart \
    gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio \
    python3 python3-pip python3-pexpect python3-jinja2 \
    xz-utils debianutils iputils-ping pylint xterm bzip2 file locales \
    liblz4-tool gperf libxml2-utils xsltproc zstd lz4 \
    libsdl1.2-dev
  run_step_allow_fail "Enable en_US.UTF-8 locale (best effort)" bash -lc "sed -i 's/^# *\\(en_US.UTF-8 UTF-8\\)/\\1/' /etc/locale.gen || true"
  run_step_allow_fail "locale-gen" locale-gen
  run_step_allow_fail "update-locale" update-locale LANG=en_US.UTF-8
}

install_xilinx_deps() {
  pm_install_smart \
    gawk make gcc g++ bc bison flex texinfo diffstat chrpath socat cpio xz-utils zstd lz4 \
    debianutils iputils-ping python3 python3-pexpect python3-jinja2 python3-pip python3-venv \
    libssl-dev libtool automake autoconf \
    libncurses-dev zlib1g-dev \
    libglib2.0-0 libsm6 libice6 libxrender1 libxext6 libx11-6 libxtst6 libxi6 libxft2 libxss1 \
    libfontconfig1 libfreetype6 \
    perl tofrodos dos2unix gzip tar screen expect rsync kmod
  pm_install_smart libtinfo5 || true
}