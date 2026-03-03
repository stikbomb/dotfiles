# config.nu

# ── Package management ────────────────────────────────────────────────────────

# Установить пакеты через paru и добавить в dotfiles tracking
# Использование:
#   pkg install foo bar        — поставить и добавить в common.txt
#   pkg install foo --laptop   — поставить и добавить в laptop.txt
#   pkg sync                   — показать нетрекнутые пакеты
def pkg [
    action: string         # install | sync
    ...packages: string    # пакеты (для install)
    --laptop               # добавить в laptop.txt вместо common.txt
] {
    let dotfiles = ($env.HOME | path join ".local/share/chezmoi/pkgs")

    match $action {
        "install" => {
            if ($packages | is-empty) { error make {msg: "Укажи пакеты"} }
            paru -S ...$packages
            let target = if $laptop { "laptop.txt" } else { "common.txt" }
            let target_path = ($dotfiles | path join $target)
            for pkg in $packages {
                let already = (open $target_path | lines | any { |l| $l == $pkg })
                if not $already {
                    $"\n($pkg)" | save --append $target_path
                    print $"✓ ($pkg) → ($target)"
                } else {
                    print $"($pkg) уже есть в ($target)"
                }
            }
        }
        "sync" => {
            bash ($dotfiles | path join "sync.sh")
        }
        _ => {
            error make {msg: $"Неизвестное действие: ($action). Используй install или sync"}
        }
    }
}
