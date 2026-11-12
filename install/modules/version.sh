#!/usr/bin/env bash

MODULE_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
if [ -z "$AXSHELL_DIR" ]; then
    if [ -d "$(dirname "$(dirname "$MODULE_DIR")")/src" ]; then
        export AXSHELL_DIR="$(dirname "$(dirname "$MODULE_DIR")")/src"
    fi
fi

if [ -n "$AXSHELL_DIR" ] && [ -f "$AXSHELL_DIR/scripts/caching.sh" ]; then
    source "$AXSHELL_DIR/scripts/caching.sh"
fi

STATE_DIR="${QS_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/axshell}"
VERSION_FILE="$STATE_DIR/version"
DEFAULT_FALLBACK_VERSION="2.0.0"

get_saved_preference() {
    local key="$1"
    local fallback="$2"
    local value=""
    if [ -f "$VERSION_FILE" ]; then
        value=$(awk -F= -v k="$key" '$1 == k {gsub(/"/, "", $2); print $2}' "$VERSION_FILE")
    fi
    case "$value" in
        true|false) echo "$value" ;;
        *) echo "$fallback" ;;
    esac
}

get_installed_version() {
    local ver=""
    if [ -f "$VERSION_FILE" ]; then
        ver=$(awk -F= '/^AXSHELL_VERSION=/{gsub(/"/, "", $2); print $2}' "$VERSION_FILE")
    fi
    if [ -z "$ver" ] && [ -n "$AXSHELL_VERSION" ]; then
        ver="$AXSHELL_VERSION"
    fi
    if [ -z "$ver" ]; then
        if [ -n "$AXSHELL_DIR" ] && [ -f "$AXSHELL_DIR/version.txt" ]; then
            ver=$(cat "$AXSHELL_DIR/version.txt" 2>/dev/null | xargs)
        elif [ -n "$AXSHELL_DIR" ] && [ -f "$(dirname "$AXSHELL_DIR")/version.txt" ]; then
            ver=$(cat "$(dirname "$AXSHELL_DIR")/version.txt" 2>/dev/null | xargs)
        elif [ -n "$REPO_ROOT" ] && [ -f "$REPO_ROOT/version.txt" ]; then
            ver=$(cat "$REPO_ROOT/version.txt" 2>/dev/null | xargs)
        fi
    fi
    if [ -z "$ver" ]; then
        ver="$DEFAULT_FALLBACK_VERSION"
    fi
    echo "$ver"
}

get_installed_commit() {
    if [ -f "$VERSION_FILE" ]; then
        awk -F= '/^AXSHELL_COMMIT=/{gsub(/"/, "", $2); print $2}' "$VERSION_FILE"
    fi
}

get_target_version() {
    local repo_root="$1"
    local repo_slug="${2:-"${REPO_SLUG:-"mora1ss/axshell"}"}"
    local target_ver=""

    if [ -f "$repo_root/version.txt" ]; then
        target_ver=$(cat "$repo_root/version.txt" 2>/dev/null | xargs)
    fi

    if [[ -z "$target_ver" || "$target_ver" == "null" ]]; then
        if command -v curl &>/dev/null; then
            target_ver=$(curl -s "https://raw.githubusercontent.com/${repo_slug}/HEAD/version.txt" 2>/dev/null | xargs)
        fi
    fi

    if [[ -z "$target_ver" || "$target_ver" == "null" ]]; then
        target_ver="$DEFAULT_FALLBACK_VERSION"
    fi

    echo "$target_ver"
}

get_target_commit() {
    local repo_root="$1"
    local repo_slug="${2:-"${REPO_SLUG:-"mora1ss/axshell"}"}"
    local target_commit=""

    if [ -d "$repo_root/.git" ] && command -v git &>/dev/null; then
        target_commit=$(git -C "$repo_root" rev-parse --short HEAD 2>/dev/null || true)
    fi

    if [[ -z "$target_commit" || "$target_commit" == "null" ]]; then
        if command -v curl &>/dev/null && command -v jq &>/dev/null; then
            target_commit=$(curl -s "https://api.github.com/repos/${repo_slug}/commits/HEAD" 2>/dev/null | jq -r '.sha[:7] // empty')
        fi
    fi

    if [[ -z "$target_commit" || "$target_commit" == "null" ]]; then
        target_commit="unknown"
    fi

    echo "$target_commit"
}

write_version_state() {
    local version="${1:-"$DEFAULT_FALLBACK_VERSION"}"
    local commit="${2:-"unknown"}"
    local compositors="$3"
    local opt_sddm="${4:-true}"
    local sddm_wayland="${5:-false}"
    local full_wallpapers="${6:-true}"

    if [[ -z "$commit" || "$commit" == "null" ]]; then
        commit="unknown"
    fi

    mkdir -p "$STATE_DIR"
    local tmp_file="${VERSION_FILE}.tmp.$$"
    cat <<EOF > "$tmp_file"
AXSHELL_VERSION="$version"
AXSHELL_COMMIT="$commit"
SELECTED_COMPOSITORS="$compositors"
OPT_SDDM="$opt_sddm"
SDDM_WAYLAND="$sddm_wayland"
INSTALL_FULL_WALLPAPERS="$full_wallpapers"
EOF
    mv -f "$tmp_file" "$VERSION_FILE"
}
