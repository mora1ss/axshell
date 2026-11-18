.pragma library

// Quickshell's DesktopEntry.execute() ignores the Terminal flag of a desktop entry, so console
// applications (btop, htop, nvim, ...) start without a terminal and never show up. Entries that
// ask for a terminal are wrapped in the configured terminal command instead, the same way a
// "> command" runs in the launcher. Null means the entry needs no terminal.

function argvFor(entry, terminalCommand) {
    if (!entry || !entry.runInTerminal) return null;
    var prefix = String(terminalCommand || "").trim();
    if (prefix === "") prefix = "kitty -e";
    var argv = prefix.split(/\s+/);
    var command = (entry.command && entry.command.length > 0) ? entry.command : [entry.execString];
    for (var i = 0; i < command.length; i++) argv.push(command[i]);
    return argv;
}
