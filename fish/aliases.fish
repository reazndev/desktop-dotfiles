# Fish Shell Aliases
# ===================

# System commands
alias pamcan pacman
alias ls 'eza --icons'
alias clear "printf '\033[2J\033[3J\033[1;1H'"
alias s sudo

# Quick navigation
alias q 'qs -c ii'
alias downloads 'cd ~/Downloads'
alias desktop 'cd ~/Desktop'
alias documents 'cd ~/Documents'
alias pictures 'cd ~/Pictures'
alias videos 'cd ~/Videos'
alias music 'cd ~/Music'
alias config 'cd ~/.config'
alias projects 'cd /mnt/shared/projects'
alias scratch 'cd ~/Scratch'

# Package management
alias pac 'sudo pacman -S'

# Utilities
alias clock 'tty-clock -s -c'
alias lsg 'ls | grep '
alias ff 'fastfetch --config ~/.config/fastfetch/alt-config.jsonc'

# Git shortcuts (basic)
alias gha 'git add .'
alias gp 'git push'
