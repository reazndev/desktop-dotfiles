function web
    # Define your links here
    set links \
        GH "https://github.com/reandev" \
        ChatGPT "https://chatgpt.com" \
        Claude "https://claude.ai" \
        Gemini "https://gemini.google.com/" \
        Reddit "https://reddit.com" \
        Dajia "https://dajia.lol/reazn" \
        LastFM "https://www.last.fm/user/Syntiiix" \ 
        Reazn.tech "https://reazn.tech"

    set link_count (math (count $links) / 2)
    set selected 1

    # Hide cursor
    printf '\e[?25l'

    # Function to draw menu
    function draw_menu_display -S
        # Clear screen and move to top
        printf '\e[2J\e[H'

        echo links
        echo ----------------
        echo ""

        for i in (seq 1 $link_count)
            set name_idx (math $i \* 2 - 1)
            set name $links[$name_idx]

            if test $i -eq $selected
                printf "► \e[32m%s\e[0m\n" $name
            else
                printf "  %s\n" $name
            end
        end
    end

    # Initial draw
    draw_menu_display

    # Main loop
    while true
        # Read a single character without echoing
        read -s -n 1 key

        switch $key
            case j
                if test $selected -lt $link_count
                    set selected (math $selected + 1)
                end
                draw_menu_display

            case k
                if test $selected -gt 1
                    set selected (math $selected - 1)
                end
                draw_menu_display

            case '' l # Enter key or 'l'
                set url_idx (math $selected \* 2)
                set url $links[$url_idx]
                set name_idx (math $selected \* 2 - 1)
                set name $links[$name_idx]

                # Show cursor and clear screen
                printf '\e[?25h\e[2J\e[H'

                echo "Opening: $name"
                echo "URL: $url"

                # Open URL based on OS
                if command -v open >/dev/null 2>&1 # macOS
                    open $url
                else if command -v xdg-open >/dev/null 2>&1 # Linux
                    xdg-open $url
                else if command -v cmd.exe >/dev/null 2>&1 # Windows (WSL)
                    cmd.exe /c start $url
                else
                    echo "Could not detect how to open URLs on this system"
                    echo "Please open manually: $url"
                end

                echo ""
                echo "Press any key to return to menu, or 'q' to quit..."
                read -s -n 1 continue_key

                if test "$continue_key" = q
                    break
                end

                draw_menu_display

            case q
                break

            case '*'
                # Silently ignore other keys - no action needed
        end
    end

    # Clean up nested function
    functions -e draw_menu_display

    # Show cursor and clear screen on exit
    printf '\e[?25h\e[2J\e[H'
    echo "Goodbye!"
end
