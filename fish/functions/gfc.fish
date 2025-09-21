function gfc --description 'git fetch and check for changes'
    git fetch
    git log --oneline HEAD..@{u}
end
