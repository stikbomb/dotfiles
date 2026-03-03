#!/usr/bin/env bash
# Показывает пакеты которые установлены, но не трекаются в dotfiles.
# Использование:
#   ./sync.sh             — показать нетрекнутые пакеты
#   ./sync.sh --add foo   — добавить пакет в common.txt

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BASELINE="$SCRIPT_DIR/baseline.txt"
COMMON="$SCRIPT_DIR/common.txt"
LAPTOP="$SCRIPT_DIR/laptop.txt"

# Все трекнутые + baseline пакеты
KNOWN=$(sort -u "$BASELINE" \
    <(grep -hv '^\s*#\|^\s*$' "$COMMON" "$LAPTOP" 2>/dev/null))

# Нетрекнутые = установленные - known
UNTRACKED=$(comm -23 \
    <(pacman -Qqen | sort) \
    <(echo "$KNOWN" | sort))

if [[ "$1" == "--add" ]]; then
    shift
    for pkg in "$@"; do
        if grep -qx "$pkg" "$COMMON" 2>/dev/null; then
            echo "$pkg уже есть в common.txt"
        else
            echo "$pkg" >> "$COMMON"
            echo "Добавлен $pkg → common.txt"
        fi
    done
    exit 0
fi

if [[ -z "$UNTRACKED" ]]; then
    echo "Всё отслеживается, ничего нового."
else
    echo "Нетрекнутые пакеты (не в baseline и не в списках):"
    echo ""
    echo "$UNTRACKED"
    echo ""
    echo "Добавить в common.txt: ./sync.sh --add <pkg> [<pkg> ...]"
fi
