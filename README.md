# Konfiguration meiner Raspberry Pi's

Ausgehend von https://www.atlassian.com/git/tutorials/dotfiles sind hier meine Dateien hinterlegt, um neue Raspberry Pi's einzurichten. Um die Standard-Programme und Bibliotheken zu installieren, dienen die Konfigurationsdateien in diesem Repo und das Setup-Skript `setup_raspi5.sh`.

Lade `setup_raspi5.sh` aus dem Repo und starte es mit `curl -Lks https://raw.githubusercontent.com/ramonvoges/raspi/master/setup_raspi5.sh | /bin/bash`.

Fehler werde in `install_log.txt` geschrieben.

## Funktionsweise

Git wird konfiguriert und das Repo nach `$HOME/.raspi` geklont. Der Alias `raspi` kann daraufhin genutzt werden, um mit dem Repo zu arbeiten, z.B. `raspi add ...`, `raspi commit -m "..."` oder `raspi push -u origin master`.

## Programme und Bibliotheken

- zsh
- Oh-my-Zshell
- Starship
- Snap
- LazyVim
