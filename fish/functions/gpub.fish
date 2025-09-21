function gpub --description 'git push your current branch to a specified branch (e.g., main, dev)'
    if test -z "$argv[1]"
        echo "Error: You must specify a target branch."
        echo "Usage: gpub <branch-name>"
        echo "Example: gpub main"
        echo "Example: gpub dev"
        return 1
    end
    set target_branch $argv[1]
    set current_branch (git branch --show-current)
    if not git ls-remote --heads origin | grep -q "refs/heads/$target_branch"
        echo "Error: Branch '$target_branch' does not exist on the remote 'origin'."
        echo "Available remote branches:"
        git ls-remote --heads origin | grep refs/heads/ | sed 's|refs/heads/||'
        return 1
    end
    echo "Pushing branch '$current_branch' to remote branch '$target_branch' on 'origin'..."
    git push origin $current_branch:$target_branch
end
