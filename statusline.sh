#!/usr/bin/env bash
# ditto — Rainbow-Ditto pixel-art statusline for Claude Code
# https://github.com/zyx1121/ditto

input=$(cat)

# Self-locate so ditto.ans is found wherever this repo lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DITTO="${SCRIPT_DIR}/ditto.ans"

# --- ANSI helpers ---
RESET='\033[0m'; BOLD='\033[1m'; DIM='\033[2m'
BLUE='\033[0;34m'; MAGENTA='\033[0;35m'; CYAN='\033[0;36m'
GREEN='\033[1;32m'; YELLOW='\033[1;33m'; RED='\033[1;31m'

pct_color() {
    local p=$1
    if [ "$p" -ge 80 ]; then printf '%b' "$RED"
    elif [ "$p" -ge 50 ]; then printf '%b' "$YELLOW"
    else printf '%b' "$GREEN"; fi
}

# --- Parse Claude Code JSON ---
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // .workspace.current_dir // .cwd // empty')
model_name=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

git_branch=""
if [ -n "$project_dir" ] && [ -d "$project_dir/.git" ]; then
    git_branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$project_dir" symbolic-ref --short HEAD 2>/dev/null \
        || GIT_OPTIONAL_LOCKS=0 git -C "$project_dir" rev-parse --short HEAD 2>/dev/null)
fi

# --- Build status text ---
parts=()
if [ -n "$project_dir" ]; then
    short_dir=${project_dir/#$HOME/~}
    if [ -n "$git_branch" ]; then
        parts+=("$(printf "${BOLD}${BLUE}%s${RESET} ${MAGENTA}(%s)${RESET}" "$short_dir" "$git_branch")")
    else
        parts+=("$(printf "${BOLD}${BLUE}%s${RESET}" "$short_dir")")
    fi
fi
[ -n "$model_name" ] && parts+=("$(printf "${CYAN}%s${RESET}" "$model_name")")
if [ -n "$used_pct" ]; then
    ctx_int=$(printf '%.0f' "$used_pct")
    col=$(pct_color "$ctx_int")
    parts+=("$(printf "ctx:${col}%d%%${RESET}" "$ctx_int")")
fi

SEP="${DIM} | ${RESET}"
status=""
for p in "${parts[@]}"; do
    [ -z "$status" ] && status="$p" || status="${status}${SEP}${p}"
done

# --- Ditto mascot rainbow row (rotates one hue step per refresh) ---
if [ -f "$DITTO" ]; then
    COLS=${COLUMNS:-$(tput cols 2>/dev/null || echo 80)}
    N=$((COLS / 32))   # each Ditto = 16 px × 2 chars = 32 chars wide
    [ "$N" -lt 1 ] && N=1
    # 6-step hue ring (purple → red-pink → red-orange → orange-yellow → yellow-green → cyan-green)
    COLORS_M=(182 168 173 221 191 79)
    COLORS_H=(225 211 216 228 192 122)
    NCOL=${#COLORS_M[@]}
    OFFSET_FILE="${HOME}/.claude/.ditto_offset"
    OFFSET=$(cat "$OFFSET_FILE" 2>/dev/null); OFFSET=${OFFSET:-0}
    echo $(( (OFFSET + 1) % NCOL )) > "$OFFSET_FILE" 2>/dev/null
    LINES=()
    while IFS= read -r ln; do LINES+=("$ln"); done < "$DITTO"
    for ln in "${LINES[@]}"; do
        for ((i=0; i<N; i++)); do
            ci=$(( (i * NCOL / N + OFFSET) % NCOL ))
            m=${COLORS_M[$ci]}; h=${COLORS_H[$ci]}
            s="${ln//38;5;182m/38;5;${m}m}"
            s="${s//38;5;189m/38;5;${h}m}"
            printf '%s' "$s"
        done
        printf '\n'
    done
fi

printf "%b" "$status"
