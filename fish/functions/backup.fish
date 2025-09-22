set BACKUP_MOUNT ~/nextcloud
set BACKUP_DEST $BACKUP_MOUNT/backup

# Make sure backup folder exists
mkdir -p $BACKUP_DEST

# List of folders to backup (absolute paths)
set INCLUDE_FOLDERS ~/Public ~/Desktop ~/Pictures ~/Videos ~/Projects ~/Music ~/.ssh ~/.cert

# List of folders/files to exclude (relative to home)
set EXCLUDE_FOLDERS \
    .cache \
    .ollama \
    RustRoverProjects \
    .lmstudio \
    .yarn \
    .vscode \
    .cargo \
    .zen \
    .npm \
    .lunarclient \
    .thunderbird \
    .mozilla \
    go \
    .bun \
    yay \
    .wakatime \
    .electron-gyp \
    .lc \
    .java \
    .dotnet \
    .expo \
    .gnupg \
    snap \
    .oh-my-zsh \
    .leetcode \
    .nv \
    .junie \
    .cherrystudio \
    .pki \
    .templateengine \
    Downloads \
    nextcloud \
    node_modules \
    target \
    build \
    dist \
    Debug \
    debug \
    out \
    __pycache__ \
    .next \
    .gradle \
    .idea \
    Scratch

# ------------------------------
# Run rsync for each include folder
# ------------------------------
for folder in $INCLUDE_FOLDERS
    if test -e $folder
        echo "Backing up $folder ..."
        rsync -azv --progress --partial \
            (for ex in $EXCLUDE_FOLDERS; echo "--exclude=$ex"; end) \
            $folder $BACKUP_DEST/
    end
end

echo "Backup complete."
