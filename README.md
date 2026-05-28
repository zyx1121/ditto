```
██████╗ ██╗████████╗████████╗ ██████╗ 
██╔══██╗██║╚══██╔══╝╚══██╔══╝██╔═══██╗
██║  ██║██║   ██║      ██║   ██║   ██║
██║  ██║██║   ██║      ██║   ██║   ██║
██████╔╝██║   ██║      ██║   ╚██████╔╝
╚═════╝ ╚═╝   ╚═╝      ╚═╝    ╚═════╝ 
```

# ditto

Rainbow-Ditto pixel-art statusline for [Claude Code](https://claude.com/claude-code). Each refresh rotates the color ring one hue step — 6 tiles per cycle.

## Install

Tell Claude Code: **"install the ditto statusline from this repo"**. Or do it manually:

```bash
git clone https://github.com/zyx1121/ditto.git ~/.claude/ditto
chmod +x ~/.claude/ditto/statusline.sh
```

Then merge into `~/.claude/settings.json` (don't replace the file — add the `statusLine` key alongside existing keys):

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/ditto/statusline.sh"
  }
}
```

Start a new Claude Code session.

Requires `jq` and a 256-color terminal. Terminal width ≥ 32 cols for one Ditto; 192+ cols fills the full 6-color rainbow.

## How it works

`ditto.ans` is a 16×14 pre-rendered sprite — 3KB of ANSI escape codes, plus an `\x1b[49m` prefix on every transparent cell so leading whitespace survives Claude Code's per-line strip. One-time render at build, zero CPU at runtime.

`statusline.sh` tiles the sprite `N = terminal_width / 32` times. For each tile it picks a position on a 6-step hue ring (purple → red-pink → red-orange → orange-yellow → yellow-green → cyan-green) and rewrites the body / highlight color codes via bash builtin `${var//pattern/repl}` — no subprocess, microsecond cost.

A 1-byte file `~/.claude/.ditto_offset` advances by 1 on every refresh. That's the marquee.

## Customize

Edit `statusline.sh`:

| What | Where |
|------|-------|
| Reverse direction | `(OFFSET + 1)` → `(OFFSET + NCOL - 1)` |
| Faster rotation | `+ 1` → `+ 2` (skip a hue per refresh) |
| Different palette | `COLORS_M` / `COLORS_H` arrays (xterm 256-color codes) |
| Ditto only, no status text | delete the status-text section + final `printf "%b" "$status"` |
| Status text only, no Ditto | delete the `# --- Ditto mascot ---` block |

## Uninstall

Remove the `statusLine` key from `~/.claude/settings.json`, then:

```bash
rm -rf ~/.claude/ditto ~/.claude/.ditto_offset
```

## Notes for Claude Code automated install

When asked to install this repo, the agent should:

1. Clone to `~/.claude/ditto/` (or any stable path; the script self-locates via `BASH_SOURCE`).
2. Read `~/.claude/settings.json` first. If a `statusLine` key already exists, confirm with the user before overwriting; otherwise merge the `statusLine` key alongside existing settings — do not replace the whole file.
3. Tell the user to start a new Claude Code session for the statusLine to take effect.

## License

MIT
