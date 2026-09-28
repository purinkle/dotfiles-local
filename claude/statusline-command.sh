#!/usr/bin/env bash

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
ctx_size=1000000  # fixed 1M token budget (per request), independent of model context window
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Format a token count as a human-readable string (k or M)
format_tokens() {
    local n=$1
    if [ "$n" -ge 1000000 ]; then
        awk "BEGIN {printf \"%.1fM\", $n / 1000000}"
    elif [ "$n" -ge 1000 ]; then
        awk "BEGIN {printf \"%dk\", int($n / 1000)}"
    else
        printf "%d" "$n"
    fi
}

tokens_fmt=$(format_tokens "$total_input")
ctx_fmt="1M"

# ANSI colors
AMBER='\033[38;5;214m'
RED='\033[31m'
RESET='\033[0m'

# Choose highlight color based on token threshold
color=""
if [ "$total_input" -ge 700000 ]; then
    color="$RED"
elif [ "$total_input" -ge 500000 ]; then
    color="$AMBER"
fi

# Percentage suffix (omitted until first API response)
pct_part=""
if [ -n "$used_pct" ]; then
    pct_part=$(printf " (%.0f%%)" "$used_pct")
fi

# Emit the status line
if [ -n "$color" ]; then
    printf "%s | ${color}%s / %s${RESET}%s" "$model" "$tokens_fmt" "$ctx_fmt" "$pct_part"
else
    printf "%s | %s / %s%s" "$model" "$tokens_fmt" "$ctx_fmt" "$pct_part"
fi
