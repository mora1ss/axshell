---
sidebar_position: 1
title: AxShell client
sidebar_label: AxShell client
slug: /cli/client
---

# AxShell client

`axshell` is the command-line client for the desktop shell.

## Overview

| Command | Purpose |
| --- | --- |
| `msg` | Open, close or toggle panels and switch workspaces. |
| `settings` | Open the settings window, optionally on a given tab. |
| `launch` | Run standalone components such as the setup wizard or the layout editors. |
| `config` | Read and write raw settings. |
| `info` | Print the current state of a setting. |
| `set` | Change a setting. |
| `trigger` | Run a one-off action. |
| `ipc` | Send raw IPC calls to the running shell. |
| `kill`, `restart` | Stop or restart the daemon. |
| [Script shortcuts](#script-shortcuts) | Wrappers around the bundled scripts, such as `lock`, `volume` or `reboot`. |

## Options

- `-v, --verbose`: Enable verbose logging output.
- `-V, --version`: Print installed version and exit.
- `-h, --help`: Show usage help and exit.

## Commands

### `msg`

Dispatches layout, workspace, and overlay actions to the shell:

- `axshell msg workspace <number>`: Switch to workspace `<number>`.
- `axshell msg workspace <number> move`: Move active window to workspace `<number>`.
- `axshell msg <number>`: Shorthand to switch to workspace `<number>`.
- `axshell msg <number> move`: Shorthand to move active window to workspace `<number>`.
- `axshell msg open <target> [subtarget]`: Open a panel or activate a subtab.
- `axshell msg toggle <target> [subtarget]`: Toggle panel visibility.
- `axshell msg close`: Close any open overlay.
- `axshell msg notifications clear`: Clear all notifications.
- `axshell msg network airplane`: Toggle airplane mode (WiFi and Bluetooth).
- `axshell msg bar autohide`: Toggle bar autohide live.

#### Targets

- `launcher`: Application search and launcher overlay.
- `clipboard` (alias: `clip`): Clipboard history manager.
- `network`: Network manager popup.
  - `network wifi`: Open directly on WiFi tab.
  - `network ethernet`: Open directly on Ethernet tab.
- `volume`: Audio mixer and device picker.
- `settings`: Settings panel or window (same as [`axshell settings`](#settings)).
  - `settings keybinds`: Open shortcut cheat sheet tab.
  - `settings appearance`: Open appearance and styling tab.
  - `guide` is a deprecated alias for `settings` and prints a warning.
- `calendar`: Calendar, clock, and schedule panel.
- `music`: Media player controls and track artwork.
- `wallpaper`: Wallpaper picker and live preview.
- `notifications`: Notification history center.
- `system`: System resource monitor and power controls.

### `settings`

Opens the settings as a panel inside the shell, like other popups.

- `axshell settings`: Open the settings.
- `axshell settings <tab> [subtab]`: Open directly on a tab, for example `axshell settings theme`.
- `axshell settings toggle [tab]`: Close the settings if they are open, otherwise open them.
- `axshell settings close`: Close the settings.

### `launch`

Runs standalone interface components in runner mode:

- `axshell launch start [args...]`: Launch first-time setup and onboarding wizard.

### `ipc`

Sends raw IPC calls directly to the running shell:

- `axshell ipc call <target> <method> [args...]`: Forward call to target object.
  - `ipc call main handleCommand <cmd> <target> <arg>`: Dispatch generic UI command.
  - `ipc call main forceReload`: Force reload shell components.
  - `ipc call main clearNotifications`: Purge all notification popups and history.
  - `ipc call lock activate`: Trigger lock screen immediately.
  - `ipc call screenshotOverlay toggle [args...]`: Toggle interactive screenshot overlay.
  - `ipc call floating toggle`: Open the quick actions panel on the last used tab, or close it if it is open on any screen. Bind it to a key in your compositor, e.g. Hyprland: `hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("axshell ipc call floating toggle"))`.
  - `ipc call floating open` / `close`: Open the panel on the screen under the cursor, or close it on every screen. Opened this way, it stays until closed, Escape is pressed, or the pointer enters and leaves it.

### `kill`

Stops the daemon and terminates all background shell workers (`serpantinum-core screentime track`, `quickshell`, `axshelld`).

### `restart`

Stops the daemon and starts it again.

## Settings and state

### `config`

Reads and writes `settings.json`. Keys use dots to reach nested values and changes apply live:

- `axshell config get <key> [fallback]`: Print a setting.
- `axshell config set <key> <value>`: Set a setting. Values are parsed as JSON and fall back to plain strings.
- `axshell config dump`: Print the whole settings file.
- `axshell config path`: Print the settings file path.
- `axshell config edit`: Open the settings file in `$VISUAL` or `$EDITOR`.

### `info`

Prints the current state of a group as JSON. Add a key to print just that value, for example `axshell info dock autohide`. Lists print one item per line:

- `axshell info notifications [dnd]`: Do not disturb.
- `axshell info idle [key]`: Idle system state: whether idle is active, caffeine and its seconds remaining (`0` when it has no time limit), app and media inhibitors, and each action's timeout and status.
- `axshell info dock [enabled|autohide]`: Dock visibility and autohide.
- `axshell info sfx [mute]`: Interface sound effects muted.
- `axshell info theme [preset|matugen|apps|presets]`: Active preset, wallpaper-derived colors, apps that follow the palette and bundled presets.
- `axshell info lang [current|available]`: Active language code and available codes.
- `axshell info wallpaper [screen]`: Current wallpaper path.
- `axshell info monitors [--json]`: Active outputs, with width, height and refresh rate as JSON.
- `axshell info updates [--json]`: Installed version compared with the latest release.

### `set`

Changes a setting. Switches take `on`, `off` or `toggle` and default to `toggle`:

- `axshell set notifications dnd [on|off|toggle]`
- `axshell set idle caffeine [on|off|toggle]`
- `axshell set dock enabled [on|off|toggle]`
- `axshell set dock autohide [on|off|toggle]`
- `axshell set sfx mute [on|off|toggle]`
- `axshell set theme matugen [on|off|toggle]`
- `axshell set theme preset <name>`: Apply a bundled preset and turn Matugen off.
- `axshell set theme app <id> [on|off|toggle]`: Recolor an app with the shell palette. See [App theming](../configure/AppTheming.md).
- `axshell set lang <code>`
- `axshell set wallpaper <path|random|next|prev|play|pause|clear> [screen]`: `screen` is a monitor name and defaults to `all`. A path may also take a transition after the screen.

### `trigger`

Runs a one-off action:

- `axshell trigger idle <dim|dpms|lock|suspend>`: Run an idle action now.
- `axshell trigger notifications clear`: Clear all notifications.
- `axshell trigger firstlaunch <trigger|reset>`: Run or reset the first launch setup.
- `axshell trigger theme reload`: Reload colors.
- `axshell trigger theme generate <image> [mode] [scheme]`: Generate colors from an image.

## Script shortcuts

### `screenshot`

Captures screen images, records video, or decodes QR codes:

- `axshell screenshot`: Open interactive selection and recording overlay.
- `axshell screenshot --full`: Capture focused monitor immediately.
- `axshell screenshot --edit`: Open screenshot in Satty image editor.
- `axshell screenshot --record`: Toggle screen video recording (start or stop).
- `axshell screenshot --scan-qr`: Scan selected region for QR codes.
- `axshell screenshot --geometry <X,Y WxH>`: Set capture crop region.
- `axshell screenshot --monitor <name>`: Set target monitor output.
- `axshell screenshot --backend <gpu-screen-recorder|wf-recorder>`: Set recording backend.
- `axshell screenshot --desk-vol <0.0-1.0>`: Set desktop audio volume multiplier.
- `axshell screenshot --desk-mute <true|false>`: Mute desktop audio in recording.
- `axshell screenshot --mic-vol <0.0-1.0>`: Set microphone audio volume multiplier.
- `axshell screenshot --mic-mute <true|false>`: Mute microphone audio in recording.
- `axshell screenshot --mic-dev <name>`: Set microphone input device name.

### `volume`

Controls audio sink and source levels via WirePlumber:

- `axshell volume raise`: Increase output volume by 5%.
- `axshell volume lower`: Decrease output volume by 5%.
- `axshell volume mute-toggle`: Toggle output mute.
- `axshell volume mic-toggle`: Toggle microphone mute.
- `axshell volume mic-raise`: Increase microphone volume by 5%.
- `axshell volume mic-lower`: Decrease microphone volume by 5%.

### `brightness`

Controls display backlight and external monitor brightness:

- `axshell brightness get`: Print current brightness percentage (default).
- `axshell brightness set <0-100>`: Set brightness to percentage.
- `axshell brightness raise`: Increase brightness by 5%.
- `axshell brightness lower`: Decrease brightness by 5%.
- `axshell brightness backend`: Print active backend (`backlight`, `ddc`, or `none`).
- `axshell brightness watch`: Watch backlight changes with inotify.

### `weather`

Queries weather data and manages forecast cache:

- `axshell weather --current-temp`: Print current temperature.
- `axshell weather --current-icon`: Print current weather icon glyph.
- `axshell weather --current-hex`: Print current weather condition accent hex.
- `axshell weather --temp`: Print today forecasted maximum temperature.
- `axshell weather --icon`: Print today forecast icon glyph.
- `axshell weather --hex`: Print today forecast accent hex.
- `axshell weather --json`: Print complete structured forecast JSON.
- `axshell weather --getdata`: Force fresh fetch from Open-Meteo API.
- `axshell weather --nav next`: Advance 5-day forecast view to next day.
- `axshell weather --nav prev`: Move 5-day forecast view to previous day.
- `axshell weather --view-listener`: Stream active forecast view index.
- `axshell weather --unit <metric|imperial|standard>`: Set temperature unit profile.
- `axshell weather --location '<json>'`: Pass custom coordinates JSON.
- `axshell weather --verbose` (`-v`): Print verbose debug output.

### `location`

Retrieves and updates geographic coordinates:

- `axshell location`: Print cached or retrieved location JSON.
- `axshell location --refresh` (`-r`): Force fresh lookup from IP geolocation providers.
- `axshell location --verbose` (`-v`): Print debug diagnostics to stderr.

### `location_manual`

Sets geographic coordinates manually:

- `axshell location_manual <latitude> <longitude>`: Set coordinates, reverse-geocode city and country, resolve timezone, and save to settings.

### `gamma`

Controls color temperature and the day/night schedule through [serpantinum-gamma](https://github.com/ilyamiro/serpantinum-gamma), which it starts when needed. AxShell stops it on exit, and the compositor then restores normal colors.

- `axshell gamma set <temperature> [output] [mode] [latitude] [longitude]`: Set temperature (1000-10000K) manually (`mode=manual`), or use it as the night temperature of the solar schedule (`mode=auto`). Without coordinates, or with `0 0`, the schedule fades to night at 19:00 and to day at 06:30. Without an output, every output is changed.
- `axshell gamma reset [output]`: Reset color temperature to 6500K daylight neutral and turn the schedule off.
- `axshell gamma status [output]`: Print status (`running` or `stopped`).
- `axshell gamma start`: Start serpantinum-gamma if it is not running.
- `axshell gamma stop`: Stop serpantinum-gamma.
- `axshell gamma --verbose` (`-v`): Print verbose output with current Kelvin, brightness and schedule state.

### `lock`

Activates lock screen:

- `axshell lock`: Trigger lock screen interface immediately.

### `redactor`

Opens the desktop widget layout editor in the running shell:

- `axshell redactor`: Open the editor.
- `axshell redactor <monitor> [widget]`: Open the editor on a monitor, optionally with a widget selected.

### `lock-redactor`

Opens the lock screen layout editor in the running shell:

- `axshell lock-redactor`: Close the editor if it is open, otherwise open it.
- `axshell lock-redactor open [monitor]`: Open the editor, optionally on a given monitor.
- `axshell lock-redactor close`: Close the editor.

### `reload`

Reloads shell:

- `axshell reload`: Force reload QuickShell desktop elements without restarting the daemon.

### `exit`

Terminates desktop session:

- `axshell exit`: Cleanly terminate graphical session and exit active compositor.

### `suspend`, `hibernate`, `reboot`, `poweroff`

- `axshell suspend`: Lock the screen and suspend the system.
- `axshell hibernate`: Hibernate the system.
- `axshell reboot`: Reboot the system.
- `axshell poweroff`: Power off the system.

## Keybinding examples

Panels and workspaces go through `msg`, everything else through `set`, `trigger` or the script shortcuts:

```
axshell msg toggle launcher
axshell msg toggle clipboard
axshell msg toggle calendar
axshell set notifications dnd toggle
axshell set wallpaper random
axshell set idle caffeine toggle
axshell trigger notifications clear
axshell volume raise
axshell screenshot --full
```
