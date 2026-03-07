# config.nu

# ── Scripts ───────────────────────────────────────────────────────────────────
source ~/.config/nushell/scripts/curl.nu

# ── Starship prompt ───────────────────────────────────────────────────────────
use ~/.cache/starship/init.nu

# ── Carapace completions ──────────────────────────────────────────────────────
source ~/.cache/carapace/init.nu

# ── Настройки ─────────────────────────────────────────────────────────────────
$env.config.show_banner = false
$env.config.history.max_size = 100_000
$env.config.history.sync_on_enter = true
$env.config.history.file_format = "sqlite"
$env.config.completions.algorithm = "fuzzy"
$env.config.edit_mode = "vi"

# ── Алиасы ───────────────────────────────────────────────────────────────────
alias ll = ls -la
alias la = ls -a
alias cat = bat
alias grep = rg
alias top = btop
alias cm = chezmoi
alias v = nvim
alias n = nva
alias va = overlay use .venv/bin/activate.nu

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
