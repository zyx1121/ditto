```
██████╗ ██╗████████╗████████╗ ██████╗ 
██╔══██╗██║╚══██╔══╝╚══██╔══╝██╔═══██╗
██║  ██║██║   ██║      ██║   ██║   ██║
██║  ██║██║   ██║      ██║   ██║   ██║
██████╔╝██║   ██║      ██║   ╚██████╔╝
╚═════╝ ╚═╝   ╚═╝      ╚═╝    ╚═════╝ 
```

# ditto

> A Claude Code statusline where a pixel-art Ditto flips itself every refresh, right next to the usage numbers you actually came for.

`claude-code` · `statusline` · `shell` · `pixel-art`

[![Claude Code statusline](https://img.shields.io/badge/Claude%20Code-statusline-d97757)](https://github.com/zyx1121/ditto) &nbsp;[![License: MIT](https://img.shields.io/badge/license-MIT-blue)](#license)

```
    ▄▀▀▄  ▄▄        ▄▀▀▄  ▄▄    
  ▄▀▀█▀▀██▀▀█▀▀▄  ▄▀▀█▀▀██▀▀█▀▀▄
 ▄▀███▀███▀▀████ ▄▀███▀███▀▀████
 █████▀▀▀▀███▀█  █████▀▀▀▀███▀█ 
███▀▀▀█████████████▀▀▀██████████
██████████████▀▀██████████████▀▀
 ▀▀▀▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀▀▀  
Sonnet 5       ctx 42% · 5h 61% · 7d 12%
```

<sub>Real output of `statusline.sh` at 44 columns (two tiled Dittos): model on the left, ctx / 5h / 7d usage on the right, in full color on a real terminal.</sub>

The stock Claude Code statusline is one flat line of text; this one is a Ditto flipping in place every refresh, next to the numbers that actually matter before a session runs dry. It started as a joke sprite and stayed because a colored glance beats reading three percentages cold. Everything lives in a single script: no assets to fetch, no config to maintain.

## Install

Tell Claude Code: **"install the ditto statusline from this repo"**. Or do it manually:

```bash
git clone https://github.com/zyx1121/ditto.git ~/.claude/ditto
chmod +x ~/.claude/ditto/statusline.sh
```

Then merge into `~/.claude/settings.json` (add the `statusLine` key alongside existing keys, don't replace the file):

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/ditto/statusline.sh"
  }
}
```

Start a new Claude Code session. Requires `jq` and a 256-color terminal.

## What it gives you

- **Flips** a 16×7-cell Ditto sprite horizontally every refresh, using pre-folded half-block glyphs (no averaging, no pixel loss).
- **Reads** Claude Code's statusline JSON from stdin with a single `jq` call.
- **Shows** model name on the left, context-window / 5-hour / 7-day usage on the right.
- **Colors** each usage stat green, yellow or red at the 50% / 80% thresholds.
- **Tiles** extra Dittos across the width: one per each extra 16 columns of `$COLUMNS`.

## How it works

Everything lives in `statusline.sh`: no assets, no config. The original 16×14 full-block sprite is pre-folded at build time so each pair of vertically-stacked pixels becomes one half-block glyph (`▀`/`▄`/`█`) whose foreground/background carry the two pixels' exact colors. One terminal cell is one pixel column, so the aspect ratio stays correct at 16×7 cells per Ditto.

Both frames (normal and mirrored) are embedded as `printf '%b'` strings; each refresh flips between them via a 1-byte state file at `~/.claude/.ditto_flip`. Terminal width comes from `$COLUMNS` (Claude Code sets it): width ≥ 20 cols shows one Ditto, every extra 16 cols adds another.

## Uninstall

Remove the `statusLine` key from `~/.claude/settings.json`, then:

```bash
rm -rf ~/.claude/ditto ~/.claude/.ditto_flip
```

## Notes for Claude Code automated install

When asked to install this repo, the agent should:

1. Clone to `~/.claude/ditto/` (or any stable path; the script is self-contained).
2. Read `~/.claude/settings.json` first. If a `statusLine` key already exists, confirm with the user before overwriting; otherwise merge the `statusLine` key alongside existing settings, don't replace the whole file.
3. Tell the user to start a new Claude Code session for the statusLine to take effect.

## Contributing

Ground rules in [CONTRIBUTING.md](https://github.com/zyx1121/.github/blob/main/CONTRIBUTING.md).

## License

[MIT](LICENSE) · the one Pokemon that ships as a shell script
