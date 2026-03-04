# env.nu

# ── PATH ──────────────────────────────────────────────────────────────────────
$env.PATH = ($env.PATH | split row (char esep) | prepend [
    ($env.HOME | path join ".local/bin")
] | uniq)

# ── Editor / Browser ─────────────────────────────────────────────────────────
$env.EDITOR = "nva"
$env.VISUAL = "nva"
$env.BROWSER = "vivaldi-stable"

# ── Theming ───────────────────────────────────────────────────────────────────
$env.QT_QPA_PLATFORMTHEME = "qt5ct"
$env.GTK_THEME = "adw-gtk3-dark"

# ── Man pages через bat ───────────────────────────────────────────────────────
$env.MANROFFOPT = "-c"
$env.MANPAGER = "sh -c 'col -bx | bat -l man -p'"

# ── Starship ──────────────────────────────────────────────────────────────────
$env.STARSHIP_SHELL = "nu"
mkdir ($env.HOME | path join ".cache/starship")
starship init nu | save -f ($env.HOME | path join ".cache/starship/init.nu")

# ── Carapace ──────────────────────────────────────────────────────────────────
mkdir ($env.HOME | path join ".cache/carapace")
carapace _carapace nushell | save -f ($env.HOME | path join ".cache/carapace/init.nu")
