---
sidebar_position: 2
title: App theming
sidebar_label: App theming
slug: /configure/app-theming
---

# App theming

AxShell can recolor other apps with the same palette as the shell, whether it comes from the wallpaper (Matugen) or from a preset. Open **Settings → Theme → App theming**. The page lists the apps that are currently themed. Add another one from **Add app**, or remove one with the delete button on its tile.

**Add app** only offers apps that are installed. Nothing is installed for you, and an app that is switched on but not installed is skipped.

On by default: **Kitty**, **Cava**, **GTK** and **Qt**. Everything else is opt-in.

## How it works

Every time the colors change, AxShell renders each enabled app's template with [matugen](https://github.com/InioX/matugen) into a separate theme file, such as `~/.config/kitty/themes/axshell.conf`. It then adds a single include line to the app's own config so the app loads that file.

Your config files are never overwritten. The lines AxShell adds are wrapped in markers:

```
# >>> axshell theme >>>
include themes/axshell.conf
# <<< axshell theme <<<
```

If one of your existing lines would override the theme (for example another `theme =` line), it is commented out as `# axshell-disabled: ...`.

When you switch an app off, AxShell removes its block, restores the lines it commented out, deletes the generated theme file and puts back any setting values it changed. A config file it had to create is removed again if nothing else was added to it.

When a config can't be edited safely, for example because it is a read-only file managed by Home Manager or its structure is unusual, nothing is changed. A warning button appears on the app's tile. Click it to see what went wrong and the exact line to add yourself, with buttons to copy it and to open the folder.

Apps are only reloaded when their colors actually changed. A broken template only affects its own app, never the shell or other apps.

## Built-in apps

| App | Theme file | Config change |
| :--- | :--- | :--- |
| GTK 3 / 4 | `~/.config/gtk-{3,4}.0/axshell.css` | `@import` at the top of `gtk.css`; sets `color-scheme` and, if [adw-gtk3](https://github.com/lassekongo83/adw-gtk3) is installed, `gtk-theme` |
| Qt | `~/.config/qt{5,6}ct/colors/axshell.conf` | `color_scheme_path` and `custom_palette` in `qt5ct.conf` / `qt6ct.conf`. Needs qt6ct (or qt5ct) and `QT_QPA_PLATFORMTHEME=qt6ct` |
| KDE apps | `~/.local/share/color-schemes/AxShell.colors` | Color groups and `ColorScheme` in `kdeglobals` |
| Kitty | `~/.config/kitty/themes/axshell.conf` | `include` in `kitty.conf` |
| Alacritty | `~/.config/alacritty/themes/axshell.toml` | `import` under `[general]` |
| Foot | `~/.config/foot/themes/axshell` | `include=` in `foot.ini` |
| Ghostty | `~/.config/ghostty/themes/axshell` | `theme = axshell` |
| WezTerm | `~/.config/wezterm/colors/axshell.toml` | `config.color_scheme` before `return config` |
| Konsole | `~/.local/share/konsole/AxShell.colorscheme` | None, pick it in your profile |
| Rio | `~/.config/rio/themes/axshell.toml` | `theme = "axshell"` |
| Helix | `~/.config/helix/themes/axshell.toml` | `theme = "axshell"` |
| VS Code (also VSCodium, Code - OSS, Cursor) | `~/.cache/axshell/apps/vscode.json` | Colors, token colors and the matching default theme in `User/settings.json`. Only plain JSON is edited: a file with comments gets a warning instead |
| Emacs | `axshell-theme.el` in `~/.config/emacs`, `~/.emacs.d` or `~/.config/doom/themes` | None, run `M-x load-theme axshell` |
| Obsidian | `.obsidian/snippets/axshell.css` in every vault | Adds the snippet to `enabledCssSnippets` in the vault's `appearance.json` |
| Neovim | `~/.config/nvim/colors/axshell.lua` | None, run `:colorscheme axshell` |
| Vim | `~/.vim/colors/axshell.vim` | None, run `:colorscheme axshell` |
| Kakoune | `~/.config/kak/colors/axshell.kak` | `colorscheme axshell` in `kakrc` |
| Micro | `~/.config/micro/colorschemes/axshell.micro` | None, run `> set colorscheme axshell` |
| Sublime Text | `~/.config/sublime-text/Packages/User/AxShell.sublime-color-scheme` | None, pick it in the color scheme selector |
| Btop | `~/.config/btop/themes/axshell.theme` | `color_theme` in `btop.conf` |
| Cava | `~/.config/cava/themes/axshell` | `theme` under `[color]` |
| Fastfetch | `~/.config/fastfetch/axshell.jsonc` | None, run `fastfetch -c axshell` |
| Fish | `~/.config/fish/conf.d/axshell.fish` | None, loaded by new shells |
| Bat | `~/.config/bat/themes/axshell.tmTheme` | `--theme="axshell"` in `bat/config`; runs `bat cache --build` |
| Yazi | `~/.config/yazi/flavors/axshell.yazi/` | `dark` and `light` under `[flavor]` in `theme.toml` |
| Lazygit | `~/.cache/axshell/apps/lazygit.yml` | A `gui.theme` block in `config.yml`. If it already has a `gui:` section, a warning shows the block to add |
| Starship | `~/.cache/axshell/apps/starship.toml` | `palette = "axshell"` and a `[palettes.axshell]` table in `starship.toml` |
| fzf | `~/.config/fzf/axshell.sh` (and a Fish `conf.d` snippet) | Sources the snippet from `~/.bashrc` and `~/.zshrc` if they exist |
| lsd | `~/.config/lsd/axshell.yaml` | `color.theme` in `config.yaml` |
| Superfile | `~/.config/superfile/theme/axshell.toml` | `theme` in `config.toml` |
| Glow | `~/.config/glow/axshell.json` | `style` in `glow.yml` |
| Atuin | `~/.config/atuin/themes/axshell.toml` | `name` under `[theme]` in `config.toml` |
| k9s | `~/.config/k9s/skins/axshell.yaml` | None, set `skin: axshell` in your k9s config |
| Claude Code | `~/.claude/themes/axshell.json` | None, pick it with `/theme` |
| tmux | `~/.config/tmux/axshell.conf` | `source-file` in `tmux.conf` |
| Zellij | `~/.config/zellij/themes/axshell.kdl` | `theme "axshell"` |
| Zathura | `~/.config/zathura/axshell` | `include axshell` |
| Fuzzel | `~/.config/fuzzel/axshell.ini` | `include=` in `fuzzel.ini` |
| Rofi | `~/.local/share/rofi/themes/axshell.rasi` | `@theme "axshell"` |
| Wofi | `~/.config/wofi/axshell.css` | `@import` at the top of `style.css` |
| Vicinae | `~/.local/share/vicinae/themes/axshell.toml` | None, pick it in the settings |
| Firefox (userChrome; also LibreWolf, Floorp) | `chrome/axshell.css` in every profile | `@import` in `chrome/userChrome.css` and the `toolkit.legacyUserProfileCustomizations.stylesheets` pref in `user.js` |
| Zen Browser | `chrome/axshell.css` in every profile | Same as Firefox |
| Halloy | `~/.config/halloy/themes/axshell.toml` | `theme` in `config.toml` |
| aerc | `~/.config/aerc/stylesets/axshell` | `styleset-name` under `[ui]` in `aerc.conf` |
| spotify-player | A `[[themes]]` entry in `theme.toml` | `theme` in `app.toml` |

Compositor borders are never themed. They stay in your compositor config.

## Customizing a built-in app

Press the edit button on an app's tile. Its files are copied to `${XDG_CONFIG_HOME:-~/.config}/axshell/matugen/apps/<app>/` and the folder opens. The folder button at the top of the page opens the parent folder.

- The template files use matugen syntax, such as `{{colors.primary.default.hex}}`, `{{colors.surface.default.hex_stripped}}` or `{{mode}}`. They are rendered again on every color change.
- `app.json` describes where the theme file goes and which line is added to the app's config. It usually doesn't need changes.
- The reset button restores the built-in version. Your copy is kept in `~/.local/state/axshell/matugen/backup/`.

Only built-in apps can be customized this way. Folders with other names are ignored.

## Command line

```sh
axshell info theme apps
axshell set theme app <id> [on|off|toggle]
```
