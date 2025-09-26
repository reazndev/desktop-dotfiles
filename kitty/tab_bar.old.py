import os
from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer, get_options
from kitty.utils import color_as_int
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    TabAccessor,
    as_rgb,
    draw_attributed_string,
)

# Config / constants
try:
    opts = get_options()
    icon_fg = as_rgb(color_as_int(opts.color16))
    icon_bg = as_rgb(color_as_int(opts.color8))
except Exception:
    opts = None
    icon_fg = 0xFFFFFF
    icon_bg = 0x000000

SEPARATOR_SYMBOL, SOFT_SEPARATOR_SYMBOL = ("", "")
RIGHT_MARGIN = 1
REFRESH_TIME = 1
ICON = "  "
DEFAULT_BAR_HEX = ["#ff5555", "#ffb86c", "#f1fa8c", "#8be9fd", "#bd93f9"]

try:
    BAR_COLORS = [as_rgb(color_as_int(h)) for h in DEFAULT_BAR_HEX]
except Exception:
    BAR_COLORS = [0] * len(DEFAULT_BAR_HEX)

timer_id = None
right_status_length = -1


def _draw_icon(screen: Screen, tab: TabBarData) -> int:
    """Draw the terminal icon on the left with active/inactive color."""
    fg = as_rgb(int(tab.active_fg)) if tab.is_active else as_rgb(int(tab.inactive_fg))
    bg = as_rgb(int(tab.active_bg)) if tab.is_active else as_rgb(int(tab.inactive_bg))
    old_fg, old_bg = screen.cursor.fg, screen.cursor.bg
    screen.cursor.fg = fg
    screen.cursor.bg = bg
    screen.draw(ICON)
    screen.cursor.fg, screen.cursor.bg = old_fg, old_bg
    return screen.cursor.x


def _draw_left_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    index: int,
    extra_data: ExtraData,
) -> int:
    """Draw tab content: folder/app name + separators, with proper colors."""
    tab_accessor = TabAccessor(tab.tab_id)

    # Determine folder or application
    exe_name = tab_accessor.active_oldest_exe or "?"
    if exe_name.lower() == "fish":
        cwd = tab_accessor.active_oldest_wd or "?"
        if cwd.startswith(os.path.expanduser("~")):
            cwd = "~" + cwd[len(os.path.expanduser("~")):]
        last_component = os.path.basename(cwd.rstrip("/"))
        display_name = last_component if last_component else cwd
    else:
        display_name = exe_name
    if len(display_name) > 30:
        display_name = display_name[:30] + "…"

    # Colors
    fg = as_rgb(int(draw_data.active_fg)) if tab.is_active else as_rgb(int(draw_data.inactive_fg))
    bg = as_rgb(int(draw_data.active_bg)) if tab.is_active else as_rgb(int(draw_data.inactive_bg))
    screen.cursor.fg = fg
    screen.cursor.bg = bg

    # Draw the folder/app cell
    screen.draw(f"  {display_name} ")

    # Separator
    next_tab_bg = as_rgb(draw_data.tab_bg(extra_data.next_tab)) if extra_data.next_tab else as_rgb(int(draw_data.default_bg))
    needs_soft_separator = next_tab_bg == bg

    if not needs_soft_separator:
        screen.draw(" ")
        screen.cursor.fg = bg
        screen.cursor.bg = next_tab_bg
        screen.draw(SEPARATOR_SYMBOL)
    else:
        prev_fg = screen.cursor.fg
        screen.draw(" " + SOFT_SEPARATOR_SYMBOL)
        screen.cursor.fg = prev_fg

    return screen.cursor.x


def _draw_right_status(screen: Screen, is_last: bool) -> int:
    """Draw right-side color bars."""
    if not is_last:
        return 0
    screen.cursor.x = screen.columns - RIGHT_MARGIN - len(BAR_COLORS)
    for color in BAR_COLORS:
        prev_fg, prev_bg = screen.cursor.fg, screen.cursor.bg
        screen.cursor.bg = color
        screen.draw(" ")
        screen.cursor.fg, screen.cursor.bg = prev_fg, prev_bg
    return screen.cursor.x


def _redraw_tab_bar(_):
    tm = get_boss().active_tab_manager
    if tm is not None:
        tm.mark_tab_bar_dirty()


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
    global timer_id
    global right_status_length
    if timer_id is None:
        timer_id = add_timer(_redraw_tab_bar, REFRESH_TIME, True)

    # Draw left icon
    _draw_icon(screen, tab)

    # Draw tab content (folder or app) with separators
    _draw_left_status(draw_data, screen, tab, index, extra_data)

    # Draw right-side bars if last tab
    _draw_right_status(screen, is_last)

    return screen.cursor.x
