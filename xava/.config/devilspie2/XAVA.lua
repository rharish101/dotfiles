#!/usr/bin/env lua
if (get_window_class() == "XAVA") then
    set_window_type("_NET_WM_WINDOW_TYPE_DOCK");
    if (get_window_name() == "XAVA") then
        set_window_position(333, 940);
    elseif (get_window_name() == "XAVA1") then
        --set_window_position(2221, 735); --for 1280x1024
        set_window_position(1920 + 333, 940); --for 1920x1080
    end
end
