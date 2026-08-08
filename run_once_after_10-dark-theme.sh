#!/usr/bin/env bash
# Тёмная тема на уровне dconf/portal.
#
# Это состояние dconf, а не файл, поэтому дотфайлами оно не покрывается.
# color-scheme читают xdg-desktop-portal (default=gnome), libadwaita/GTK4
# и Electron/Chromium — без него они остаются светлыми, даже когда
# gtk-application-prefer-dark-theme=true в settings.ini.
set -euo pipefail

command -v gsettings >/dev/null || exit 0

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
