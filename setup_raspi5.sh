#!/bin/bash

# Zuerst das Skript ausführbar machen: chmod +x setup_pi.sh.
# Dann mit sudo ./setup_pi.sh ausführen.

# Logfile für Fehler anlegen
logfile="install_log.txt"
echo "Installation Log - $(date)" >$logfile

# Update und Upgrade
sudo apt update
sudo apt -y upgrade >>$logfile 2>&1

# Funktion zum Prüfen und Installieren von Paketen
install_package() {
	package=$1
	if ! dpkg -s $package >/dev/null 2>&1; then
		echo "Installing $package..."
		sudo apt install -y $package >>$logfile 2>&1
		if [ $? -ne 0 ]; then
			echo "Error installing $package. See $logfile for details."
		fi
	else
		echo "$package is already installed."
	fi
}

# zsh installieren
install_package zsh
chsh -s /bin/zsh >>$logfile 2>&1

oh-my-zsh installieren
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "Installing oh-my-zsh..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >>$logfile 2>&1
	if [ $? -ne 0 ]; then
		echo "Error installing oh-my-zsh. See $logfile for details."
	fi
else
	echo "oh-my-zsh is already installed."
fi

# Starship installieren
sudo curl -sS https://starship.rs/install.sh | sh >>$logfile 2>&1
echo "eval "$(starship init zsh)"" >>$HOME/.zshrc

# snapd für neovim installieren
install_package snapd
pip install pynvim --break-system-packages >>$logfile 2>&1

# LazyVim installieren
echo "Installing LazyVim"
# curl -sLf https://spacevim.org/install.sh | bash >> $logfile 2>&1
git clone https://github.com/LazyVim/starter ~/.config/nvim

# Skriptverzeichnis erstellen
echo "Making directories for scripts and notebooks..."
mkdir $HOME/scripts
mkdir $HOME/notebooks

# Nerd Fonts installieren
if [ ! -d "/usr/share/fonts/truetype/FiraCode" ]; then
	echo "Installing FiraCode from Nerd Fonts..."
	sudo mkdir /usr/share/fonts/truetype/FiraCode
	curl -fLo "$HOME/Downloads" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
	sudo unzip /home/ramon/Downloads/FiraCode.zip -d /usr/share/fonts/truetype/FiraCode/ >>$logfile 2>&1
	if [ $? -ne 0 ]; then
		echo "Error installing FiraCode from Nerd Fonts. See $logfile for details."
	fi
	sudo fc-cache -fv >>$logfile 2>&1
else
	echo "FiraCode from Nerd Fonts are already installed."
fi

if [ ! -d "/usr/share/fonts/truetype/SauceCodePro" ]; then
	echo "Installing SauceCodePro from Nerd Fonts..."
	sudo mkdir /usr/share/fonts/truetype/SauceCodePro
	curl -fLo "$HOME/Downloads" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/SourceCodePro.zip
	sudo unzip /home/ramon/Downloads/SourceCodePro.zip -d /usr/share/fonts/truetype/SauceCodePro/ >>$logfile 2>&1
	if [ $? -ne 0 ]; then
		echo "Error installing SauceCodePro from Nerd Fonts. See $logfile for details."
	fi
	sudo fc-cache -fv >>$logfile 2>&1
else
	echo "SauceCodePro from Nerd Fonts are already installed."
fi

# Wallpaper kopieren
if [ -f "/media/ramon/HERMES/background03.png" ]; then
	echo "Copying wallpaper..."
	sudo cp /media/ramon/HERMES/background03.png /usr/share/rpd-wallpaper/
else
	echo "Wallpaper file not found."
fi

# Python-Pakete installieren
install_package python3-setuptools
install_package python3-pillow
install_package python3-scipy
install_package python3-notebook
install_package python3-geopy
install_package python3-geopandas
pip install jupyterlab --break-system-packages >>$logfile 2>&1
pip install nbclassic --break-system-packages >>$logfile 2>&1
pip install altair --break-system-packages >>$logfile 2>&1

# Platzhalter für weitere Installationen
# install_package paketname

install_package nodejs
install_package npm

# Screenfetch installieren
install_package screenfetch

if [ -f "$HOME/.zshrc" ]; then
	echo "Setting up Screenfetch..."
	echo "screenfetch" >>$HOME/.zshrc
else
	echo "Could'nt add screenfetch to .zshrc)"
fi

# Github-Cli installieren
echo "Installing Github-Cli"
sudo mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
sudo apt update
install_package gh

# Nützliche Werkzeuge
install_package mc
install_package btop
install_package bat
ln -s /usr/bin/batcat ~/.local/bin/bat >>$logfile 2>&1
install_package ripgrep

install_package exa
install_package fzf
install_package fd-find

# Zellij
echo "Installing Zellij"
install_package rust
cargo install --locked zellij >>$logfile 2>&1

# mkdir $HOME/.config/zellij
# zellij setup --dump-config >$HOME/.config/zellij/config.kdl >>$logfile 2>&1

# Konfigurationsdateien verwalten
echo "Setting up the dotfiles..."
git config --global user.email "ramon.voges@gmail.com"
git config --global user.name "Ramon Voges"
# alias raspi="/usr/bin/git --git-dir=$HOME/.raspi/ --work-tree=$HOME"
# raspi config --local status.showUntrackedFiles no
git clone --bare https://github.com/ramonvoges/raspi.git $HOME/.raspi >>$logfile 2>&1
function raspi {
	/usr/bin/git --git-dir=$HOME/.raspi/ --work-tree=$HOME $@
}
mkdir -p .config-backup >>$logfile 2>&1
raspi checkout
if [ $? = 0 ]; then
	echo "Checked out config."
else
	echo "Backing up pre-existing dot files."
	raspi checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{} >>$logfile 2>&1
fi
raspi checkout >>$logfile 2>&1
raspi config status.showUntrackedFiles no

echo "Installation completed."
