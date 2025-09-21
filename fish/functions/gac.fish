function gac --description 'git add -A and git commit with message'
    git add -A
    if test (count $argv) -eq 0
        git commit
    else
        set msg (string join " " $argv)
        git commit -m "$msg"
    end
end
