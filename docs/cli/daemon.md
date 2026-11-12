---
sidebar_position: 2
title: AxShell daemon
sidebar_label: AxShell daemon
slug: /cli/daemon
---

# AxShell daemon

`axshelld` is the background service daemon for the desktop shell.

## Options

- `-v, --verbose`: Enable verbose logging output.
- `-V, --version`: Print installed version and exit.
- `-h, --help`: Show usage help and exit.

## Commands

### `start`

- `axshelld start`: Start the desktop shell and background services, including the [audio engine](/audio) (default command).

### `stop`

- `axshelld stop`: Stop the running daemon and all background shell processes (`serpantinum-core screentime track`, `quickshell`).

### `status`

- `axshelld status`: Check whether the daemon is currently running (exit code 0 if running, 1 if stopped).

## Autostart

Compositor autostart examples:

- Hyprland (`config/autostart.lua`): `hl.exec_cmd("axshelld start")`
- Niri (`config/autostart.kdl`): `spawn-at-startup "axshelld" "start"`
- Sway (`configDir/autostart`): `exec axshelld start`
- Mango (`config/autostart.conf`): `exec_once=axshelld start`
