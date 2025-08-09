function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting

end

starship init fish | source
if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
end

alias pamcan pacman
alias ls 'eza --icons'
alias clear "printf '\033[2J\033[3J\033[1;1H'"
alias q 'qs -c ii'
alias downloads 'cd ~/Downloads'
alias desktop 'cd ~/Desktop'
alias documents 'cd ~/Documents'
alias pictures 'cd ~/Pictures'
alias videos 'cd ~/Videos'
alias music 'cd ~/Music'
alias config 'cd ~/.config'
alias projects 'cd /mnt/shared/projects'


alias gits 'git remote set-url origin git@github.com:reazndev/'

alias s 'sudo'
alias scratch 'cd ~/Scratch'

alias pac 'sudo pacman -S'
alias clock 'tty-clock -s -c'
alias lsg 'ls | grep '


# function fish_prompt
#   set_color cyan; echo (pwd)
#   set_color green; echo '> '
# end


source ~/.config/fish/auto-Hypr.fish
# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/reazn/.lmstudio/bin
# End of LM Studio CLI section

