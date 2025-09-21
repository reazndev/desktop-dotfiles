function gweb --description 'Open current git repo remote (origin) in browser'
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "Not inside a git repository."
        return 1
    end

    set remote (git remote get-url origin 2>/dev/null)
    if test -z "$remote"
        echo "No remote named 'origin' found."
        return 1
    end

    if string match -rq '^git@' $remote
        set remote (string replace -r '^git@(.*):(.*)\.git$' 'https://\1/\2' $remote)
    else if string match -rq '\.git$' $remote
        set remote (string replace -r '\.git$' '' $remote)
    end

    echo "Opening $remote ..."
    xdg-open $remote >/dev/null 2>&1 &
end
