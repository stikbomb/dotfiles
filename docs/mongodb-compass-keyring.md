# MongoDB Compass: credential storage на нон-GNOME Wayland сессии

## Проблема

При запуске MongoDB Compass 1.49 на CachyOS + niri появляется ошибка:

> Compass cannot access credential storage. You can still connect, but please
> note that passwords will not be saved.

Подключаться можно, но пароли не сохраняются между сессиями.

## Диагностика

### 1. Проверка secret service

```sh
dbus-send --session --print-reply --dest=org.freedesktop.DBus \
  /org/freedesktop/DBus org.freedesktop.DBus.ListNames | grep secret
# → org.freedesktop.secrets  ✓ — сервис зарегистрирован
```

### 2. Проверка gnome-keyring-daemon

```sh
systemctl --user status gnome-keyring-daemon.service
# → active (running)  ✓
```

### 3. Проверка libsecret

```sh
secret-tool store --label='test' service test username test <<< "pass"
secret-tool lookup service test username test
# → pass  ✓ — libsecret работает
```

Все компоненты работают, но Compass всё равно не видит credential storage.

### 4. Анализ запуска Compass

```sh
cat $(which mongodb-compass)
# → #!/bin/sh
# → NODE_ENV=production exec electron37 '/usr/lib/mongodb-compass/app.asar' "$@"
```

Compass — это Electron 37 приложение. Electron поддерживает флаг
`--password-store=gnome-libsecret` для явного указания бэкенда хранилища.

### 5. Попытка передать флаг через .desktop файл

```ini
Exec=mongodb-compass --password-store=gnome-libsecret %U
```

**Результат:** ошибка при старте —
`Unknown option "passwordStore" (while validating preferences from: Command line)`

Compass валидирует все аргументы командной строки до того как Electron их
обрабатывает. Флаг `--password-store` — это Electron-уровневый флаг, не Compass,
поэтому Compass его отклоняет.

### 6. Корень проблемы

Скрипт `/usr/bin/mongodb-compass` передаёт все аргументы `"$@"` ПОСЛЕ пути к
`app.asar`. Electron обрабатывает флаги только ДО пути к приложению — всё что
после считается аргументами самого приложения и попадает в валидацию Compass.

```sh
# Так НЕ работает (флаг после app.asar — достаётся Compass):
electron37 '/usr/lib/mongodb-compass/app.asar' --password-store=gnome-libsecret

# Так работает (флаг до app.asar — достаётся Electron):
electron37 --password-store=gnome-libsecret '/usr/lib/mongodb-compass/app.asar'
```

## Решение

Создать враппер `~/.local/bin/mongodb-compass` который перехватывает вызов
(`~/.local/bin` стоит первым в `$PATH`) и передаёт флаг в правильной позиции:

```sh
#!/bin/sh
NODE_ENV=production exec electron37 --password-store=gnome-libsecret '/usr/lib/mongodb-compass/app.asar'
```

Файл отслеживается в dotfiles: `dot_local/bin/executable_mongodb-compass`.

## Дополнительно: создание Login keyring

На свежей нон-GNOME системе keyring коллекция по умолчанию не существует.
Нужно создать её один раз через seahorse:

```sh
pkg install seahorse gnome-keyring
seahorse  # File → New → Password Keyring → имя "Login" → пустой пароль
```

Пустой пароль = автоматический разлок без запроса при каждом старте.
PAM-интеграция для SDDM уже настроена в `/etc/pam.d/sddm`.
