function dus
    du -h --max-depth=1 . 2>/dev/null | sort -hr
end
