<div align="center">

<h1>ditto</h1>

<p><strong>A Claude Code statusline: a pixel-art Ditto that flips on each refresh, beside your usage numbers.</strong></p>

[![Claude Code](https://img.shields.io/badge/Claude%20Code-statusline-d97757?style=flat-square)](https://docs.anthropic.com/en/docs/claude-code/statusline)
[![Shell](https://img.shields.io/badge/bash-jq-4EAA25?style=flat-square&logo=gnubash&logoColor=white)](statusline.sh)
[![License](https://img.shields.io/github/license/zyx1121/ditto?style=flat-square)](LICENSE)

**English** | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md)

</div>

```
        ▄▄  ▄▀▀▄        ▄▄  ▄▀▀▄
      ▄▀▀█▀▀██▀▀█▀▀▄  ▄▀▀█▀▀██▀▀█▀▀▄
     ▄▀███▀███▀▀████ ▄▀███▀███▀▀████
     █████▀▀▀▀███▀█  █████▀▀▀▀███▀█
    ███▀▀▀█████████████▀▀▀██████████
    ██████████████▀▀██████████████▀▀
     ▀▀▀▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀▀▀
Opus 5.5       ctx 42% · 5h 61% · 7d 12%
```

The default Claude Code statusline is one line of plain text. ditto adds a Ditto that flips in place and colors the 3 numbers that tell you when a session runs dry. A quick look at a color is faster than reading 3 percentages. The output above is real, at 44 columns, with the colors removed.

## Features

- **Flips on each refresh**: a 16 by 7 cell sprite made of half-block glyphs, with no lost pixels.
- **Shows usage**: the model on the left, and context, 5-hour and 7-day usage on the right.
- **Colors by level**: green below 50%, yellow from 50%, red from 80%.
- **Fills the width**: one more Ditto for every 16 extra columns.
- **One file**: `statusline.sh` with one `jq` call. No assets, no config.

## Quick start

Tell Claude Code: "install the ditto statusline from this repo". Or install it yourself:

```sh
git clone https://github.com/zyx1121/ditto.git ~/.claude/ditto
```

Add the `statusLine` key to `~/.claude/settings.json`, next to the keys that are there:

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/ditto/statusline.sh"
  }
}
```

Start a new Claude Code session. The Ditto appears under the prompt.

## Usage

**tmux mode**: put the status row in the tmux status bar. Set `DITTO_TMUX=1` in the `env` block of `~/.claude/settings.json`. ditto then prints only the sprite and writes the row to the window option `@cc_line`:

```tmux
set -g status-right '#{?@cc_line,#{@cc_line},%H:%M}'
```

To clear the row when a session ends, add a `SessionEnd` hook that runs `tmux set -wu -t "$TMUX_PANE" @cc_line`.

**Uninstall**: remove the `statusLine` key, then run `rm -rf ~/.claude/ditto ~/.claude/.ditto_flip`.

## How it works

- The original sprite is 16 by 14 pixels. Each pair of stacked pixels becomes one half-block glyph (`▀`, `▄` or `█`), with the foreground and background in the 2 exact colors.
- Both frames, normal and mirrored, are `printf '%b'` strings in the script. A 1-byte file, `~/.claude/.ditto_flip`, selects the frame for each refresh.
- `$COLUMNS` from Claude Code sets the width.

## Limits

- Needs `bash`, `jq` and a truecolor terminal.
- The usage numbers show only when Claude Code sends them in the statusline JSON.

## For AI agents

Facts for coding agents and LLM tools. The rules for changing the code are in [AGENTS.md](AGENTS.md).

- **Summary**: Bash statusline for Claude Code with a flipping pixel-art Ditto and color-coded context, 5-hour and 7-day usage.
- **Type**: cli
- **Interfaces**: reads the Claude Code statusline JSON on stdin. Writes ANSI text to stdout, or the tmux window option `@cc_line` when `DITTO_TMUX=1`.
- **Install**: clone to `~/.claude/ditto`, then merge `"statusLine": {"type": "command", "command": "bash ~/.claude/ditto/statusline.sh"}` into `~/.claude/settings.json`. Ask before you replace an existing `statusLine`.
- **Run**: Claude Code runs it on each refresh. Manual test: `echo '<json>' | COLUMNS=44 bash statusline.sh`
- **Verify**: the manual test prints 7 sprite rows and one status row
- **Config**: env `DITTO_TMUX=1`. State file `~/.claude/.ditto_flip`.
- **Secrets**: none
- **Limits**: needs `jq` and a truecolor terminal

## Development

```sh
echo '{"model":{"display_name":"Opus 5.5"},"context_window":{"used_percentage":42},"rate_limits":{"five_hour":{"used_percentage":61},"seven_day":{"used_percentage":12}}}' \
  | env -u DITTO_TMUX COLUMNS=44 bash statusline.sh
```

Unset `DITTO_TMUX` for this test. Otherwise the test writes to the `@cc_line` option of your tmux pane.

## License

[MIT](LICENSE)
