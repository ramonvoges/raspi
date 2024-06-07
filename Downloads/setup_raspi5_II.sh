#!/bin/bash

# Zuerst das Skript ausführbar machen: chmod +x setup_pi.sh.
# Dann mit sudo ./setup_pi.sh ausführen.

# Logfile für Fehler anlegen
logfile="install_log_II.txt"
echo "Installation Log - $(date)" >$logfile

sudo snap install core >>$logfile 2>&1

# Nvim und Config
sudo snap install nvim --classic >>$logfile 2>&1
pip install pynvim --break-system-packages >>$logfile 2>&1
# LazyVim installieren

# LazyVim
echo "Installing LazyVim"
git clone https://github.com/LazyVim/starter ~/.config/nvim >>$logfile 2>&1

# Terminal emulator
sudo snap install alacritty --classic >>$logfile 2>&1

# LazyGit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_arm64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit.tar.gz
rm -r lazygit

# Tmux and TMP
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm >>$logfile 2>&1

# Zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh >>$logfile 2>&1
echo "eval '$(zoxide init --cmd cd zsh)'" >>~/.zshrc

# Installing Docker
curl -sSL https://get.docker.com | sh >>$logfile 2>&1
sudo usermod -aG docker $USER
newgrp docker
echo "Docker läuft als voll privilegierter Daemon. Der nicht-root Zugriff für Nutzer ist eingerichtet."
