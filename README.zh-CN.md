<!-- 翻译自 README.md @ docs/readme-template-v2。只翻 "For AI agents" 以上的章节，英文版更新时一起改。 -->

<div align="center">

<h1>ditto</h1>

<p><strong>Claude Code 的 statusline：每次刷新就翻面的像素百变怪，旁边是用量数字。</strong></p>

[![Claude Code](https://img.shields.io/badge/Claude%20Code-statusline-d97757?style=flat-square)](https://docs.anthropic.com/en/docs/claude-code/statusline)
[![Shell](https://img.shields.io/badge/bash-jq-4EAA25?style=flat-square&logo=gnubash&logoColor=white)](statusline.sh)
[![License](https://img.shields.io/github/license/zyx1121/ditto?style=flat-square)](LICENSE)

[English](README.md) | [繁體中文](README.zh-TW.md) | **简体中文**

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

Claude Code 默认的 statusline 只有一行纯文本。ditto 加上一只原地翻面的百变怪，并给 3 个数字上色，让你知道 session 何时会用完。看一眼颜色，比读 3 个百分比快。上面是 44 列的真实输出，颜色已移除。

## 功能

- **每次刷新翻面**：16 × 7 格的半格字符图，不损失任何像素。
- **显示用量**：左边是模型，右边是 context、5 小时与 7 天用量。
- **按程度上色**：低于 50% 绿色，50% 起黄色，80% 起红色。
- **填满宽度**：每多 16 列就多一只百变怪。
- **单一文件**：`statusline.sh`，只调用一次 `jq`。没有素材，也没有配置文件。

## 快速开始

对 Claude Code 说：「install the ditto statusline from this repo」。或自己安装：

```sh
git clone https://github.com/zyx1121/ditto.git ~/.claude/ditto
```

在 `~/.claude/settings.json` 已有的键旁边加上 `statusLine`：

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/ditto/statusline.sh"
  }
}
```

开新的 Claude Code session，百变怪就会出现在输入框下方。

## 使用方式

**tmux 模式**：把状态行放到 tmux 的 status bar。在 `~/.claude/settings.json` 的 `env` 区块设置 `DITTO_TMUX=1`。ditto 就只打印图，并把状态行写进窗口选项 `@cc_line`：

```tmux
set -g status-right '#{?@cc_line,#{@cc_line},%H:%M}'
```

要在 session 结束时清掉状态行，加一个 `SessionEnd` hook 运行 `tmux set -wu -t "$TMUX_PANE" @cc_line`。

**卸载**：删掉 `statusLine` 键，再运行 `rm -rf ~/.claude/ditto ~/.claude/.ditto_flip`。

## 工作原理

- 原图是 16 × 14 像素。上下相叠的两个像素合成一个半格字符(`▀`、`▄` 或 `█`)，前景与背景分别是两个像素的精确颜色。
- 正面与镜像两张图都以 `printf '%b'` 字符串写在脚本里。1 byte 的 `~/.claude/.ditto_flip` 决定每次刷新用哪一张。
- 宽度来自 Claude Code 设置的 `$COLUMNS`。

## 限制

- 需要 `bash`、`jq` 与支持 truecolor 的终端。
- 只有 Claude Code 在 statusline JSON 里发送用量时，才会显示用量数字。

## 其他

给 AI agent 的结构化信息与开发说明在[英文版](README.md#for-ai-agents)。

## 许可证

[MIT](LICENSE)
