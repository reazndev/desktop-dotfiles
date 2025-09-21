function gadd --description 'Add a git remote, defaults to "origin"'
    if test (count $argv) -lt 1
        echo "Error: You must provide a repository URL."
        echo "Usage: gadd <repository-url>"
        echo "Example: gadd git@github.com:username/repo.git"
        return 1
    end
    set repo_url $argv[1]
    set remote_name $argv[2]
    git remote add $remote_name $repo_url
end
