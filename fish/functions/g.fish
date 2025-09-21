function g --description 'Main git command / status; or "g help" for list of custom functions'
    if test (count $argv) -gt 0; and contains -- $argv[1] help --help -h
        echo "Custom Git Command Shortcuts:"
        echo ----------------------------------------
        echo "# --- Status ---"
        echo "g          - git status"
        echo ""
        echo "# --- Committing ---"
        echo "ga          - git add ."
        echo "gac         - git add . and git commit"
        echo ""
        echo "# --- Pushing ---"
        echo "gpub     - Push current branch to a specific remote branch (e.g., 'main', 'dev')"
        echo ""
        echo "# --- Branching ---"
        echo "gbl        - lists all branches"
        echo "gsw        - git switch to a branch"
        echo "gswb       - Create and switch to a new branch"
        echo ""
        echo "# --- Fetching ---"
        echo "gfc        - Fetch and show commits that can be pulled"
        echo ""
        echo "# --- Remotes ---"
        echo "gadd       - Add a git remote (defaults to 'origin')"
        echo ""
        echo "# --- Web ---"
        echo "gweb       - Opens the current repo in the web"
        echo ""
        echo ----------------------------------------
        echo "Run 'g' by itself for a standard git status."
        return 0
    end
    git status $argv
end
