function gbl --description 'Show current branch, then plain lists of local and remote branches (no pager)'
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Not a git repository"
        return 1
    end

    set current (git branch --show-current 2>/dev/null)
    echo "Current: $current"
    echo
    echo "Local branches:"
    git --no-pager for-each-ref --format='%(refname:short)' refs/heads
    echo
    echo "Remote branches:"
    git --no-pager for-each-ref --format='%(refname:short)' refs/remotes
end
