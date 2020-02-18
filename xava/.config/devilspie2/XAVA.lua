#!/usr/bin/env lua
OFFSET = 3;  -- for hiding XAVA's empty bars
LAPTOP_WIDTH = 1920;  -- for shifting to the second monitor
PANEL_HEIGHT = 48;  -- to avoid XAVA overlapping with Xfce's panel

if (get_window_class() == "XAVA") then
    set_window_type("_NET_WM_WINDOW_TYPE_DOCK")

    local screen_width, screen_height = get_screen_geometry()
    local _, _, win_width, win_height = get_window_geometry()
    local x_pos = (screen_width - win_width) // 2
    local y_pos = screen_height - PANEL_HEIGHT - win_height + OFFSET

    if (get_window_name() == "XAVA") then -- for the laptop's screen
        set_window_position(x_pos, y_pos)
    elseif (get_window_name() == "XAVA1") then -- for the second monitor
        set_window_position(LAPTOP_WIDTH + x_pos, y_pos)
    end
end
