<!-- 翻譯自 README.md @ docs/readme-template-v2。只翻 "For AI agents" 以上的章節，英文版更新時一起改。 -->

<div align="center">

<h1>ditto</h1>

<p><strong>Claude Code 的 statusline：每次刷新就翻面的像素百變怪，旁邊是用量數字。</strong></p>

[![Claude Code](https://img.shields.io/badge/Claude%20Code-statusline-d97757?style=flat-square)](https://docs.anthropic.com/en/docs/claude-code/statusline)
[![Shell](https://img.shields.io/badge/bash-jq-4EAA25?style=flat-square&logo=gnubash&logoColor=white)](statusline.sh)
[![License](https://img.shields.io/github/license/zyx1121/ditto?style=flat-square)](LICENSE)

[English](README.md) | **繁體中文** | [简体中文](README.zh-CN.md)

</div>

```
        ▄▄  ▄▀▀▄        ▄▄  ▄▀▀▄
      ▄▀▀█▀▀██▀▀█▀▀▄  ▄▀▀█▀▀██▀▀█▀▀▄
     ▄▀███▀███▀▀████ ▄▀███▀███▀▀████
     █████▀▀▀▀███▀█  █████▀▀▀▀███▀█
    ███▀▀▀█████████████▀▀▀██████████
    ██████████████▀▀██████████████▀▀
     ▀▀▀▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀▀▀
OPUS 5.5         CTX 42%  5H 61%  7D 12%
```

Claude Code 預設的 statusline 只有一行純文字。ditto 加上一隻原地翻面的百變怪，並替 3 個數字上色，讓你知道 session 何時會用完。看一眼顏色，比讀 3 個百分比快。上面是 44 欄的真實輸出，顏色已移除。

## 功能

- **每次刷新翻面**：16 × 7 格的半格字元圖，不損失任何像素。
- **顯示用量**：左邊是模型，右邊是 context、5 小時與 7 天用量。
- **依程度上色**：用百變怪的淡紫色票。數值 75% 起變黃，90% 起變紅，只有該數值變色。
- **填滿寬度**：每多 16 欄就多一隻百變怪。
- **單一檔案**：`statusline.sh`，只呼叫一次 `jq`。沒有素材，也沒有設定檔。

## 快速開始

對 Claude Code 說：「install the ditto statusline from this repo」。或自己安裝：

```sh
git clone https://github.com/zyx1121/ditto.git ~/.claude/ditto
```

在 `~/.claude/settings.json` 既有的鍵旁邊加上 `statusLine`：

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/ditto/statusline.sh"
  }
}
```

開新的 Claude Code session，百變怪就會出現在輸入框下方。

## 使用方式

**tmux 模式**：把狀態列放到 tmux 的 status bar。在 `~/.claude/settings.json` 的 `env` 區塊設定 `DITTO_TMUX=1`。ditto 就只印圖，並把狀態列寫進視窗選項 `@cc_line`：

```tmux
set -g status-right '#{?@cc_line,#{@cc_line},%H:%M}'
```

要在 session 結束時清掉狀態列，加一個 `SessionEnd` hook 執行 `tmux set -wu -t "$TMUX_PANE" @cc_line`。

**移除**：刪掉 `statusLine` 鍵，再執行 `rm -rf ~/.claude/ditto ~/.claude/.ditto_flip`。

## 運作方式

- 原圖是 16 × 14 像素。上下相疊的兩個像素合成一個半格字元(`▀`、`▄` 或 `█`)，前景與背景分別是兩個像素的精確顏色。
- 正面與鏡像兩張圖都以 `printf '%b'` 字串寫在腳本裡。1 byte 的 `~/.claude/.ditto_flip` 決定每次刷新用哪一張。
- 寬度來自 Claude Code 設定的 `$COLUMNS`。

## 限制

- 需要 `bash`、`jq` 與支援 truecolor 的終端機。
- 只有 Claude Code 在 statusline JSON 裡送出用量時，才會顯示用量數字。

## 其他

給 AI agent 的結構化資訊與開發說明在[英文版](README.md#for-ai-agents)。

## 授權

[MIT](LICENSE)
