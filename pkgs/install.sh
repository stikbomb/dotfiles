#!/usr/bin/env bash
# Устанавливает пакеты из pkgs/common.txt и pkgs/<machine>.txt
# Использование: ./pkgs/install.sh [desktop|laptop]
#   Если аргумент не передан — читает machine из chezmoi

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Определяем тип машины
if [[ -n "$1" ]]; then
    MACHINE="$1"
else
    MACHINE=$(chezmoi data | python3 -c "import sys,json; print(json.load(sys.stdin)['machine'])" 2>/dev/null || echo "")
fi

if [[ -z "$MACHINE" ]]; then
    echo "Не удалось определить тип машины. Передай аргумент: ./install.sh desktop|laptop"
    exit 1
fi

echo "Машина: $MACHINE"

# Собираем список пакетов (игнорируем пустые строки и комментарии)
PKGLIST=$(grep -hv '^\s*#\|^\s*$' \
    "$SCRIPT_DIR/common.txt" \
    "$SCRIPT_DIR/${MACHINE}.txt" 2>/dev/null)

echo "Устанавливаем пакеты..."
echo "$PKGLIST" | paru -S --needed --noconfirm -
