# env.nu

# ── PATH ──────────────────────────────────────────────────────────────────────
$env.PATH = ($env.PATH | split row (char esep) | prepend [
    ($env.HOME | path join ".local/bin")
] | uniq)

# ── Editor ────────────────────────────────────────────────────────────────────
$env.EDITOR = "nva"
$env.VISUAL = "nva"

# ── Man pages через bat ───────────────────────────────────────────────────────
$env.MANROFFOPT = "-c"
$env.MANPAGER = "sh -c 'col -bx | bat -l man -p'"

# ── Starship ──────────────────────────────────────────────────────────────────
$env.STARSHIP_SHELL = "nu"
mkdir ($env.HOME | path join ".cache/starship")
starship init nu | save -f ($env.HOME | path join ".cache/starship/init.nu")
