# dotfiles

Managed with [chezmoi](https://chezmoi.io). CachyOS + [niri](https://github.com/YaLTeR/niri).

## Быстрый старт на новой машине

```sh
pacman -S chezmoi
chezmoi init --apply git@github.com:stikbomb/dotfiles.git
```

При `init` chezmoi спросит тип машины: `desktop` или `laptop`. Ответ записывается в `~/.config/chezmoi/chezmoi.toml` и используется в шаблонах.

## Структура

```
dot_config/
  niri/
    config.kdl          — главный конфиг, подключает модули через include
    cfg/
      autostart.kdl     — автозапуск приложений
      keybinds.kdl      — горячие клавиши
      input.kdl         — клавиатура, мышь, тачпад
      layout.kdl        — правила расположения окон
      rules.kdl         — window rules
      misc.kdl          — разное
      animation.kdl     — анимации
      display.kdl.tmpl  — мониторы (шаблон, разный для desktop/laptop)
  alacritty/
    alacritty.toml      — конфиг терминала (Nord тема)
  nushell/
    config.nu           — конфиг оболочки
    env.nu              — переменные окружения
```

## Шаблоны (machine-specific конфиги)

Файлы с расширением `.tmpl` генерируются chezmoi из шаблона при `apply`.
Тип машины определяется переменной `machine` в `~/.config/chezmoi/chezmoi.toml`.

### display.kdl

Конфигурация мониторов разная для каждой машины.

**desktop** — два LG ультрашироких, один над другим:
- HDMI-A-1: LG HDR WQHD 3440x1440 @ 85Hz — нижний (основной)
- HDMI-A-2: LG HDR WFHD 2560x1080 @ 60Hz — верхний, по центру (x=440, y=-1080)

**laptop** — заполнить после `niri msg outputs` на ноуте.

## Обновление конфигов

Редактировать файлы через chezmoi, чтобы изменения шли в репо:

```sh
chezmoi edit ~/.config/niri/cfg/keybinds.kdl   # открыть в редакторе
chezmoi apply                                    # применить изменения
chezmoi cd                                       # перейти в source dir
git add -A && git commit -m "..." && git push    # запушить
```

Или редактировать файлы напрямую, потом синхронизировать:

```sh
chezmoi re-add ~/.config/niri/cfg/keybinds.kdl  # подтянуть изменения в source
```

После изменений нири конфига перечитать его без перезапуска:

```sh
niri msg action load-config-file  # перечитать конфиг без перезапуска
```

## Синхронизация между машинами

```sh
chezmoi update   # git pull + apply
```

## Управление пакетами

Списки пакетов в `pkgs/`:
- `common.txt` — на всех машинах
- `laptop.txt` — только ноут
- `baseline.txt` — пакеты из базовой установки CachyOS (не редактировать руками)

**Поставить пакет и сразу добавить в tracking** (nushell):

```sh
pkg install foo bar          # → common.txt
pkg install tlp --laptop     # → laptop.txt
```

После этого закоммитить изменения в `pkgs/`.

**Проверить, не забыл ли чего-то задрекировать:**

```sh
pkg sync   # показывает установленные пакеты, которых нет ни в одном списке
```

**Установка всего на новой машине** (после `chezmoi init`):

```sh
./pkgs/install.sh   # читает тип машины из chezmoi автоматически
```

## Известные особенности

### MongoDB Compass — credential storage

На нон-GNOME сессии Compass не может найти keyring из-за особенности передачи
аргументов в Electron. Решение — враппер `~/.local/bin/mongodb-compass`
(уже в dotfiles), который передаёт флаг `--password-store=gnome-libsecret`
в правильной позиции.

На новой машине также нужно один раз создать Login keyring через seahorse
с **пустым паролем** (auto-unlock).

Подробно: [`docs/mongodb-compass-keyring.md`](docs/mongodb-compass-keyring.md)
