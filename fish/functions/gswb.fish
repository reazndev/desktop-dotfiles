function gswb --description 'git switch -c: create and switch to a new branch'
    git switch -c $argv[1] $argv[2..-1]
end
