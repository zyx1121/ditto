# ditto

Bash statusline for Claude Code: a pixel-art Ditto that flips on each refresh, and a status row with the model and usage. All code is in `statusline.sh`. Read [README.md](README.md) first.

## Rules

- Keep it one self-contained script with one `jq` call. No assets, no config files.
- The sprite frames are pre-rendered `printf '%b'` strings. Regenerate both frames together, so the mirror stays exact.
- When you install it for a user, read `~/.claude/settings.json` first. Merge the `statusLine` key and keep the other keys. Ask before you replace an existing `statusLine`. Then tell the user to start a new session.
- Repository documents and code comments are English. No em dashes.

## Verify

```sh
echo '{"model":{"display_name":"Opus 5.5"},"context_window":{"used_percentage":42},"rate_limits":{"five_hour":{"used_percentage":61},"seven_day":{"used_percentage":12}}}' \
  | env -u DITTO_TMUX -u TMUX_PANE HOME="$(mktemp -d)" COLUMNS=44 bash statusline.sh
```

Expect 7 sprite rows and one status row. Unset the tmux variables, or the test writes to the real tmux pane. The temporary `HOME` keeps the real flip state.
