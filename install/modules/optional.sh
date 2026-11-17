#!/usr/bin/env bash

# Optional extras selected in the installer UI. Package installation happens with
# the other packages; user config files are written after the shell is deployed.

: "${OPT_FASTFETCH:=false}"
: "${OPT_STARSHIP:=false}"
: "${OPT_BRAVE:=false}"

OPTIONAL_PRESET_ROOT_FALLBACK="/usr/share/axshell/config/optional"

optional_preset_root() {
    local candidates=()
    [ -n "${PROJECT_ROOT:-}" ] && candidates+=("$PROJECT_ROOT/config/optional")
    [ -n "${AXSHELL_DIR:-}" ] && candidates+=("$AXSHELL_DIR/config/optional" "$AXSHELL_DIR/../config/optional")
    candidates+=("$OPTIONAL_PRESET_ROOT_FALLBACK")

    local candidate
    for candidate in "${candidates[@]}"; do
        if [ -d "$candidate" ]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done
    return 1
}

optional_preset_dir() {
    local name="$1" root
    root="$(optional_preset_root 2>/dev/null || true)"
    [ -n "$root" ] || return 1
    [ -d "$root/$name" ] || return 1
    printf '%s\n' "$root/$name"
}

optional_backup_target() {
    local target="$1" stamp dest
    [ -e "$target" ] || return 1

    stamp="$(date +%Y%m%d_%H%M%S)"
    if [ -d "$target" ]; then
        dest="$(dirname "$target")/$(basename "$target")_backup/backup_$stamp"
        mkdir -p "$dest" || return 1
        cp -a "$target/." "$dest/" || return 1
    else
        dest="$target.bak.$stamp"
        cp -a "$target" "$dest" || return 1
    fi

    printf '%s\n' "$dest"
}

optional_configure_fastfetch() {
    local src dest backup
    src="$(optional_preset_dir fastfetch 2>/dev/null || true)"

    if [ -z "$src" ] || [ ! -f "$src/config.jsonc" ]; then
        echo -e "\e[33m[ WARN ]\e[0m $(t "installer.optional.preset_missing" "name=Fastfetch")"
        return 0
    fi

    dest="${XDG_CONFIG_HOME:-$HOME/.config}/fastfetch"
    backup=""
    if [ -e "$dest" ] && ! cmp -s "$src/config.jsonc" "$dest/config.jsonc"; then
        backup="$(optional_backup_target "$dest" 2>/dev/null || true)"
    fi

    mkdir -p "$dest/imgs"
    install -m 0644 "$src/config.jsonc" "$dest/config.jsonc" || return 0
    if [ -d "$src/imgs" ]; then
        cp -a "$src/imgs/." "$dest/imgs/" 2>/dev/null || true
    fi

    # The preset hardcodes ~/.config/fastfetch for its logo. Point it at the
    # real destination when XDG_CONFIG_HOME moves the config elsewhere.
    local conf_home="${XDG_CONFIG_HOME:-$HOME/.config}"
    conf_home="${conf_home%/}"
    if [ -n "$HOME" ] && [ "$conf_home" != "$HOME/.config" ]; then
        local tmp_cfg="$dest/.config.jsonc.tmp.$$"
        if awk -v old='$HOME/.config/fastfetch' -v new="$dest" '{
                while ((i = index($0, old)) > 0)
                    $0 = substr($0, 1, i - 1) new substr($0, i + length(old))
                print
            }' "$dest/config.jsonc" > "$tmp_cfg" 2>/dev/null; then
            chmod 0644 "$tmp_cfg" 2>/dev/null || true
            mv -f "$tmp_cfg" "$dest/config.jsonc" 2>/dev/null || rm -f "$tmp_cfg"
        else
            rm -f "$tmp_cfg"
        fi
    fi

    if [ -n "$backup" ]; then
        echo -e "\e[36m[ INFO ]\e[0m $(t "installer.optional.config_backup" "name=Fastfetch" "path=$backup")"
    fi
    echo -e "\e[32m[ OK ] $(t "installer.optional.config_applied" "name=Fastfetch")\e[0m"
}

optional_add_starship_block() {
    local file="$1" line="$2"
    local begin="# >>> axshell starship >>>"
    local end="# <<< axshell starship <<<"

    mkdir -p "$(dirname "$file")" 2>/dev/null || true
    if [ ! -f "$file" ]; then
        : > "$file" 2>/dev/null || return 1
    fi

    if grep -qF "$begin" "$file" 2>/dev/null; then
        return 0
    fi

    if [ -s "$file" ] && [ -n "$(tail -c 1 "$file" 2>/dev/null)" ]; then
        printf '\n' >> "$file" || return 1
    fi

    {
        printf '\n%s\n' "$begin"
        printf '%s\n' "$line"
        printf '%s\n' "$end"
    } >> "$file" 2>/dev/null || return 1
}

optional_enable_starship_shells() {
    local conf_home="${XDG_CONFIG_HOME:-$HOME/.config}"
    local login_shell
    login_shell="$(basename "${SHELL:-}" 2>/dev/null || true)"

    if [ -d "$conf_home/fish" ] || [ "$login_shell" = "fish" ]; then
        if optional_add_starship_block "$conf_home/fish/config.fish" 'starship init fish | source'; then
            echo -e "\e[32m[ OK ] $(t "installer.optional.shell_enabled" "shell=fish")\e[0m"
        fi
    fi

    if [ -f "$HOME/.zshrc" ] || [ "$login_shell" = "zsh" ]; then
        if optional_add_starship_block "$HOME/.zshrc" 'eval "$(starship init zsh)"'; then
            echo -e "\e[32m[ OK ] $(t "installer.optional.shell_enabled" "shell=zsh")\e[0m"
        fi
    fi

    if [ -f "$HOME/.bashrc" ] || [ "$login_shell" = "bash" ]; then
        if optional_add_starship_block "$HOME/.bashrc" 'eval "$(starship init bash)"'; then
            echo -e "\e[32m[ OK ] $(t "installer.optional.shell_enabled" "shell=bash")\e[0m"
        fi
    fi
}

optional_configure_starship() {
    local src dest backup
    src="$(optional_preset_dir starship 2>/dev/null || true)"

    if [ -z "$src" ] || [ ! -f "$src/starship.toml" ]; then
        echo -e "\e[33m[ WARN ]\e[0m $(t "installer.optional.preset_missing" "name=Starship")"
        return 0
    fi

    dest="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
    backup=""
    if [ -f "$dest" ] && ! cmp -s "$src/starship.toml" "$dest"; then
        backup="$(optional_backup_target "$dest" 2>/dev/null || true)"
    fi

    mkdir -p "$(dirname "$dest")"
    install -m 0644 "$src/starship.toml" "$dest" || return 0

    if [ -n "$backup" ]; then
        echo -e "\e[36m[ INFO ]\e[0m $(t "installer.optional.config_backup" "name=Starship" "path=$backup")"
    fi
    echo -e "\e[32m[ OK ] $(t "installer.optional.config_applied" "name=Starship")\e[0m"

    # A broken `starship init` line would error on every shell start, so only
    # touch the shell configs when the binary is really there.
    if command -v starship >/dev/null 2>&1; then
        optional_enable_starship_shells
    fi
}

optional_install_brave_dnf_repo() {
    local repo_url="https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo"

    if sudo dnf -q repolist 2>/dev/null | grep -qi "brave"; then
        return 0
    fi

    if command -v dnf5 >/dev/null 2>&1; then
        if sudo dnf config-manager addrepo --from-repofile="$repo_url" >/dev/null 2>&1; then
            return 0
        fi
    fi

    if sudo dnf config-manager --add-repo "$repo_url" >/dev/null 2>&1; then
        return 0
    fi

    if command -v dnf5 >/dev/null 2>&1; then
        sudo dnf install -y dnf5-plugins >/dev/null 2>&1 || true
    else
        sudo dnf install -y dnf-plugins-core >/dev/null 2>&1 || true
    fi
    sudo dnf config-manager --add-repo "$repo_url" >/dev/null 2>&1
}

optional_install_brave() {
    local safe_jobs="$1" pkg
    case "$PM_NAME" in
        pacman|void) pkg="brave-bin" ;;
        dnf) pkg="brave-browser" ;;
        *) pkg="brave" ;;
    esac

    if pm_is_installed "$pkg" 2>/dev/null; then
        return 0
    fi

    if [ "$PM_NAME" = "pacman" ] \
        && ! command -v yay >/dev/null 2>&1 \
        && ! command -v paru >/dev/null 2>&1; then
        echo -e "\e[33m[ WARN ]\e[0m $(t "installer.optional.aur_helper_missing")"
        FAILED_PKGS+=("$pkg")
        return 0
    fi

    if [ "$PM_NAME" = "dnf" ]; then
        optional_install_brave_dnf_repo || true
    fi

    if pm_install_pkg "$pkg" "$safe_jobs"; then
        echo -e "\e[32m[ OK ] $(t "installer.deps.install_ok" "pkg=$pkg")\e[0m"
    else
        echo -e "\e[31m[ FAILED ] $(t "installer.deps.install_failed" "pkg=$pkg")\e[0m"
        FAILED_PKGS+=("$pkg")
    fi
}

install_optional_packages() {
    if [ "$OPT_FASTFETCH" != true ] && [ "$OPT_STARSHIP" != true ] && [ "$OPT_BRAVE" != true ]; then
        return 0
    fi

    echo -e "\n\e[36m[ INFO ]\e[0m $(t "installer.optional.installing")"

    local SAFE_JOBS=$(( $(nproc) / 2 ))
    [[ $SAFE_JOBS -lt 1 ]] && SAFE_JOBS=1
    [[ $SAFE_JOBS -gt 4 ]] && SAFE_JOBS=4

    local pkgs=() pkg
    if [ "$OPT_FASTFETCH" = true ] && ! pm_is_installed fastfetch 2>/dev/null; then
        pkgs+=("fastfetch")
    fi
    if [ "$OPT_STARSHIP" = true ] && ! pm_is_installed starship 2>/dev/null; then
        pkgs+=("starship")
    fi

    for pkg in "${pkgs[@]}"; do
        if pm_install_pkg "$pkg" "$SAFE_JOBS"; then
            echo -e "\e[32m[ OK ] $(t "installer.deps.install_ok" "pkg=$pkg")\e[0m"
        else
            echo -e "\e[31m[ FAILED ] $(t "installer.deps.install_failed" "pkg=$pkg")\e[0m"
            FAILED_PKGS+=("$pkg")
        fi
    done

    if [ "$OPT_BRAVE" = true ]; then
        optional_install_brave "$SAFE_JOBS"
    fi
}

configure_optional_presets() {
    if [ "$OPT_FASTFETCH" = true ]; then
        optional_configure_fastfetch
    fi
    if [ "$OPT_STARSHIP" = true ]; then
        optional_configure_starship
    fi
}
