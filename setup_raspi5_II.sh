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

echo "Installing LazyVim"
git clone https://github.com/LazyVim/starter ~/.config/nvim >>$logfile 2>&1

sudo snap install alacritty --classic >>$logfile 2>&1

# Tmux and TMP
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm >>$logfile 2>&1

# Zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh >>$logfile 2>&1
echo "eval '$(zoxide init --cmd cd zsh)'" >>~/.zshrc
