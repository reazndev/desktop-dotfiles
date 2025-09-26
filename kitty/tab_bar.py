import os
from kitty.boss import get_boss
from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    TabAccessor,
    as_rgb,
)

def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    # Use the specific tab being drawn
    tab_accessor = TabAccessor(tab.tab_id)

    old_fg = screen.cursor.fg
    old_bg = screen.cursor.bg

    # Draw left indicator
    if tab.is_active:
        screen.cursor.fg = as_rgb(int(draw_data.active_bg))
        screen.cursor.bg = as_rgb(int(draw_data.inactive_bg))
    elif extra_data.prev_tab is None or extra_data.prev_tab.tab_id != tab.tab_id:
        screen.cursor.bg = as_rgb(int(draw_data.inactive_bg))
        screen.cursor.fg = as_rgb(int(0x626880))

    # Determine what to show: cwd for fish, else application ID
    display_name = "?"
    exe_name = tab_accessor.active_oldest_exe or "?"
    if exe_name.lower() == "fish":
        cwd = tab_accessor.active_oldest_wd or "?"
        if cwd and isinstance(cwd, str):
            home = os.path.expanduser("~")
            if cwd.startswith(home):
                cwd = "~" + cwd[len(home):]
            last_component = os.path.basename(cwd.rstrip("/"))
            display_name = last_component if last_component else cwd
    else:
        display_name = exe_name

    # Truncate if too long
    if len(display_name) > 30:
        display_name = display_name[:30] + "…"

    # Draw the cell
    bg_color = as_rgb(int(draw_data.active_bg)) if tab.is_active else as_rgb(0x232634)
    screen.cursor.fg = as_rgb(0x8CAAEE)
    screen.cursor.bg = bg_color
    screen.draw(f"  {display_name} ")

    # Right-side active indicator
    if tab.is_active:
        screen.cursor.fg = as_rgb(int(draw_data.active_bg))
        screen.cursor.bg = as_rgb(int(draw_data.inactive_bg))

    # Reset cursor colors
    screen.cursor.fg = old_fg
    screen.cursor.bg = old_bg
