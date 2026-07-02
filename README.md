```
██████╗ ██╗████████╗████████╗ ██████╗ 
██╔══██╗██║╚══██╔══╝╚══██╔══╝██╔═══██╗
██║  ██║██║   ██║      ██║   ██║   ██║
██║  ██║██║   ██║      ██║   ██║   ██║
██████╔╝██║   ██║      ██║   ╚██████╔╝
╚═════╝ ╚═╝   ╚═╝      ╚═╝    ╚═════╝ 
```

# ditto

Minimal single-file statusline for [Claude Code](https://claude.com/claude-code):
a Ditto pixel-art mascot that flips horizontally every refresh, plus one status
row — model name on the left, context / 5-hour / 7-day usage on the right.

## Install

Tell Claude Code: **"install the ditto statusline from this repo"**. Or do it manually:

```bash
git clone https://github.com/zyx1121/ditto.git ~/.claude/ditto
chmod +x ~/.claude/ditto/statusline.sh
```

Then merge into `~/.claude/settings.json` (don't replace the file — add the
`statusLine` key alongside existing keys):

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/ditto/statusline.sh"
  }
}
```

Start a new Claude Code session.

Requires `jq` and a 256-color terminal. Terminal width comes from `$COLUMNS`
(Claude Code sets it). Width ≥ 20 cols shows one Ditto; every extra 16 cols
adds another.

## How it works

Everything lives in `statusline.sh` — no assets, no config.

The original 16×14 full-block sprite is pre-folded at build time: each pair of
vertically-stacked pixels becomes one half-block glyph (`▀`/`▄`/`█`) whose
foreground/background carry the two pixels' exact colors — no averaging, no
pixel loss — so one terminal cell is one pixel-column and the aspect ratio
stays correct (16×7 cells per Ditto). Both frames (normal + mirrored) are
embedded as `printf '%b'` strings; each refresh flips between them via a
1-byte state file `~/.claude/.ditto_flip`.

The status row reads Claude Code's statusline JSON from stdin (one `jq` call):
model display name on the left; context-window, 5-hour and 7-day usage
percentages on the right, colored green / yellow / red at 50% / 80%.

## Uninstall

Remove the `statusLine` key from `~/.claude/settings.json`, then:

```bash
rm -rf ~/.claude/ditto ~/.claude/.ditto_flip
```

## Notes for Claude Code automated install

When asked to install this repo, the agent should:

1. Clone to `~/.claude/ditto/` (or any stable path; the script is self-contained).
2. Read `~/.claude/settings.json` first. If a `statusLine` key already exists,
   confirm with the user before overwriting; otherwise merge the `statusLine`
   key alongside existing settings — do not replace the whole file.
3. Tell the user to start a new Claude Code session for the statusLine to take effect.

## License

MIT
