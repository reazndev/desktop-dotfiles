function fish_prompt -d "Write out the prompt"
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive
    set fish_greeting
    # Enable case-insensitive tab completion
    set -g fish_complete_case_insensitive true
end

# Case-insensitive cd function
function cd --description 'Change directory with case-insensitive matching'
    if test (count $argv) -eq 0
        builtin cd
        return
    end

    set target $argv[1]

    # If the target exists as-is, use it directly
    if test -d "$target"
        builtin cd "$target" $argv[2..-1]
        return
    end

    # Handle relative paths - check in current directory
    if not string match -q "/*" "$target"
        # Look for case-insensitive matches in current directory
        for dir in */
            set dir_name (string replace -r '/$' '' "$dir")
            if test (string lower "$dir_name") = (string lower "$target")
                builtin cd "$dir_name" $argv[2..-1]
                return
            end
        end
    else
        # Handle absolute paths
        set parent (dirname "$target")
        set basename (basename "$target")

        if test -d "$parent"
            for dir in "$parent"/*/
                set dir_name (basename "$dir")
                if test (string lower "$dir_name") = (string lower "$basename")
                    builtin cd "$parent/$dir_name" $argv[2..-1]
                    return
                end
            end
        end
    end

    # If no match found, use original cd behavior (will show error)
    builtin cd "$target" $argv[2..-1]
end

# load starship
starship init fish | source
if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
end

# load aliases
source ~/.config/fish/aliases.fish
