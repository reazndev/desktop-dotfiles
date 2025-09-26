function backupfish
    set BACKUP_MOUNT ~/Nextcloud
    set TODAY (date "+%Y-%m-%d")
    set BACKUP_DEST $BACKUP_MOUNT/backup/$TODAY

    mkdir -p $BACKUP_DEST

    set INCLUDE_FOLDERS ~/Public ~/Desktop ~/Pictures ~/Videos ~/Projects ~/.ssh ~/.cert

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
        .git \
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
        Nextcloud \
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
        Scratch \
        venv \
        Music \
        .local/share/Trash \
        .local/share/recently-used.xbel

    for folder in $INCLUDE_FOLDERS
        if test -e $folder
            echo "Backing up $folder ..."
            rsync -azv --progress --partial \
                (for ex in $EXCLUDE_FOLDERS; echo "--exclude=$ex"; end) \
                $folder $BACKUP_DEST/
        end
    end

    echo "Backup complete: $BACKUP_DEST"
end
