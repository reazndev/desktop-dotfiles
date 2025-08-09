#!/bin/bash

# Define app-to-workspace assignments
declare -A fixed_apps=(
  ["Spotify"]=5
  ["discord"]=5
  ["vesktop"]=5
  ["element"]=5
  ["ZapZap"]=5
  ["firefox"]=2
  ["brave-browser"]=2
  ["zen-browser"]=2
  ["zen"]=2
  ["zen-browser-bin"]=2
  ["RustRover"]=1
  ["jetbrains-rider"]=1
  ["code"]=1
  ["VSCodium"]=1
  ["Cursor"]=1
)

# Workspaces to fill dynamically (unknown apps)cmat
fallback_workspaces=(3 4 6 7 8 9)
declare -A fallback_counts
for ws in "${fallback_workspaces[@]}"; do
  fallback_counts[$ws]=0
done

# Get all clients (windows)
hyprctl clients -j | jq -c '.[]' | while read -r window; do
  address=$(echo "$window" | jq -r '.address')
  class=$(echo "$window" | jq -r '.class')

  if [[ -n "${fixed_apps[$class]}" ]]; then
    workspace="${fixed_apps[$class]}"
    hyprctl dispatch movetoworkspace "$workspace,address:$address"

    # Apply layout hints for workspace 5 apps
    if [[ "$workspace" -eq 5 ]]; then
      if [[ "$class" == "spotify" ]]; then
        hyprctl dispatch layoutmsg splitleft,address:$address
      elif [[ "$class" =~ ^(discord|vesktop|element|zapzap)$ ]]; then
        hyprctl dispatch layoutmsg splitright,address:$address
      fi
    fi

  else
    # Assign unknown apps to fallback workspaces
    for ws in "${fallback_workspaces[@]}"; do
      if [[ ${fallback_counts[$ws]} -lt 2 ]]; then
        hyprctl dispatch movetoworkspace "$ws,address:$address"
        fallback_counts[$ws]=$((fallback_counts[$ws] + 1))
        break
      fi
    done
  fi
done
