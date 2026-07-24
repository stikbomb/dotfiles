#!/usr/bin/env bash
APP_ID="obsidian"
HIDDEN_WS=9
HIDDEN_FILE="/tmp/obsidian-hidden"
PREV_WIN_FILE="/tmp/obsidian-prev-win"

WINDOWS=$(niri msg -j windows 2>/dev/null)
WIN_ID=$(echo "$WINDOWS" | jq -r "[.[] | select(.app_id == \"$APP_ID\")][0].id // empty")

if [ -z "$WIN_ID" ]; then
    obsidian &
    exit 0
fi

IS_FOCUSED=$(echo "$WINDOWS" | jq -r "[.[] | select(.id == $WIN_ID)][0].is_focused")

if [ -f "$HIDDEN_FILE" ]; then
    WORKSPACES=$(niri msg -j workspaces 2>/dev/null)
    FOCUSED_WS_IDX=$(echo "$WORKSPACES" | jq -r "[.[] | select(.is_focused == true)][0].idx")
    PREV_WIN=$(echo "$WINDOWS" | jq -r "[.[] | select(.is_focused == true)][0].id // empty")
    rm -f "$HIDDEN_FILE"
    echo "$PREV_WIN" > "$PREV_WIN_FILE"
    niri msg action move-window-to-workspace --window-id "$WIN_ID" --focus false "$FOCUSED_WS_IDX"
    niri msg action focus-window --id "$WIN_ID"
elif [ "$IS_FOCUSED" = "true" ]; then
    PREV_WIN=$(cat "$PREV_WIN_FILE" 2>/dev/null)
    rm -f "$PREV_WIN_FILE"
    touch "$HIDDEN_FILE"
    niri msg action move-window-to-workspace --window-id "$WIN_ID" --focus false "$HIDDEN_WS"
    [ -n "$PREV_WIN" ] && niri msg action focus-window --id "$PREV_WIN"
else
    PREV_WIN=$(echo "$WINDOWS" | jq -r "[.[] | select(.is_focused == true)][0].id // empty")
    echo "$PREV_WIN" > "$PREV_WIN_FILE"
    niri msg action focus-window --id "$WIN_ID"
fi
