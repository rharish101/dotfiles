-- SPDX-FileCopyrightText: 2022 Harish Rajagopal <harish.rajagopals@gmail.com>
--
-- SPDX-License-Identifier: MIT

-- ----------------------------------------
-- General
-- ----------------------------------------

-- The main modifier for compositor actions
local MAIN_MOD <const> = "SUPER + "

-- Close/kill the focused window.
hl.bind(MAIN_MOD .. "Q", hl.dsp.window.close())
hl.bind(MAIN_MOD .. "SHIFT + Q", hl.dsp.window.kill())

-- Reload the configuration file.
hl.bind(MAIN_MOD .. "SHIFT + C", hl.dsp.exec_cmd("hyprctl reload config-only"))

-- Reload all renderer resources and outputs.
hl.bind(MAIN_MOD .. "SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

-- Exit Hyprland (logs you out of your Wayland session).
hl.bind(MAIN_MOD .. "SHIFT + E", hl.dsp.exec_cmd("hyprshutdown"))
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("hyprshutdown"))

-- ----------------------------------------
-- Applications
-- ----------------------------------------

-- App-specific mod
local APP_MOD <const> = "CTRL + ALT + SUPER + "

-- Brightness adjustments
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("ddcutil setvcp 10 + 5"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("ddcutil setvcp 10 - 5"), { repeating = true })

-- Audio adjustments
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

-- General-purpose apps
hl.bind(APP_MOD .. "D", hl.dsp.exec_cmd("papers"))
hl.bind(APP_MOD .. "E", hl.dsp.exec_cmd("exo-open --launch FileManager"))
hl.bind(APP_MOD .. "M", hl.dsp.exec_cmd("exo-open --launch MailReader"))
hl.bind(APP_MOD .. "T", hl.dsp.exec_cmd("exo-open --launch TerminalEmulator"))
hl.bind(APP_MOD .. "B", hl.dsp.exec_cmd("exo-open --launch WebBrowser"))
hl.bind(APP_MOD .. "P", hl.dsp.exec_cmd("firefox --private-window"))
hl.bind(APP_MOD .. "R", hl.dsp.exec_cmd("lollypop"))

-- Desktop utils
hl.bind(APP_MOD .. "L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(MAIN_MOD .. "P", hl.dsp.exec_cmd("monique"))
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("pkill wofi || wofi"), { release = true }) -- Explicitly use SUPER, in case MAIN_MOD is changed
hl.bind("Print", hl.dsp.exec_cmd("flameshot screen"))
hl.bind("CTRL + Print", function()
	local picturesDir = os.getenv("XDG_PICTURES_DIR") or os.getenv("HOME") .. "/Pictures"
	hl.dispatch(hl.dsp.exec_cmd("flameshot screen --path " .. picturesDir .. "/Screenshots"))
end)
hl.bind(MAIN_MOD .. "Print", hl.dsp.exec_cmd("flameshot gui"))
hl.bind(MAIN_MOD .. "V", hl.dsp.exec_cmd("cursor-clip"))

-- ----------------------------------------
-- Layouts
-- ----------------------------------------

local hy3 = hl.plugin.hy3

-- Enter fullscreen mode for the focused container.
hl.bind(MAIN_MOD .. "F", hl.dsp.window.fullscreen())

-- Toggle focused window into a group a.k.a. "tabbed mode".
hl.bind(MAIN_MOD .. "W", hy3.make_group("tab", { toggle = true }))

-- Toggle the window split direction.
hl.bind(MAIN_MOD .. "E", hy3.change_group("opposite"))

-- ----------------------------------------
-- Focus
-- ----------------------------------------

-- Change focus (within tiled/floating only; exclude tab windows).
hl.bind(MAIN_MOD .. "H", hy3.move_focus("l", { visible = true }))
hl.bind(MAIN_MOD .. "J", hy3.move_focus("d", { visible = true }))
hl.bind(MAIN_MOD .. "K", hy3.move_focus("u", { visible = true }))
hl.bind(MAIN_MOD .. "L", hy3.move_focus("r", { visible = true }))

-- Change focus within tabs.
hl.bind(MAIN_MOD .. "CTRL + H", hy3.focus_tab({ direction = "l" }))
hl.bind(MAIN_MOD .. "CTRL + L", hy3.focus_tab({ direction = "r" }))

-- Move focused window.
hl.bind(MAIN_MOD .. "SHIFT + H", hy3.move_window("l"))
hl.bind(MAIN_MOD .. "SHIFT + J", hy3.move_window("d"))
hl.bind(MAIN_MOD .. "SHIFT + K", hy3.move_window("u"))
hl.bind(MAIN_MOD .. "SHIFT + L", hy3.move_window("r"))

-- Change focus between tiling / floating windows.
hl.bind(MAIN_MOD .. "space", hy3.toggle_focus_layer())

-- ----------------------------------------
-- Floating
-- ----------------------------------------

-- Toggle floating/tiling for the focused window.
hl.bind(MAIN_MOD .. "SHIFT + space", hl.dsp.window.float())

-- Move floating windows with the mouse.
hl.bind(MAIN_MOD .. "mouse:272", hl.dsp.window.drag(), { mouse = true })

-- ----------------------------------------
-- Resizing
-- ----------------------------------------

-- Go to the "resize" mode.
hl.bind(MAIN_MOD .. "R", function()
	local tgtSubmap = hl.get_current_submap() == "resize" and "reset" or "resize"
	hl.dispatch(hl.dsp.submap(tgtSubmap))
end, { submap_universal = true })

hl.define_submap("resize", function()
	-- Shrink/grow the window’s width/height
	hl.bind("H", hl.dsp.window.resize({ x = -10, y = 0 }), { repeating = true })
	hl.bind("J", hl.dsp.window.resize({ x = 0, y = 10 }), { repeating = true })
	hl.bind("K", hl.dsp.window.resize({ x = 0, y = -10 }), { repeating = true })
	hl.bind("L", hl.dsp.window.resize({ x = 10, y = 0 }), { repeating = true })

	-- Go back to the global ("reset") submap
	hl.bind("Escape", hl.dsp.submap("reset"))
	hl.bind("Return", hl.dsp.submap("reset"))

	-- Resize with the mouse's left click
	hl.bind("mouse:272", hl.dsp.window.resize(), { mouse = true })
end)

-- ----------------------------------------
-- Workspaces
-- ----------------------------------------

-- Switch to a workspace.
hl.bind(MAIN_MOD .. "1", hl.dsp.focus({ workspace = "1" }))
hl.bind(MAIN_MOD .. "2", hl.dsp.focus({ workspace = "2" }))
hl.bind(MAIN_MOD .. "3", hl.dsp.focus({ workspace = "3" }))
hl.bind(MAIN_MOD .. "4", hl.dsp.focus({ workspace = "4" }))
hl.bind(MAIN_MOD .. "5", hl.dsp.focus({ workspace = "5" }))
hl.bind(MAIN_MOD .. "6", hl.dsp.focus({ workspace = "6" }))
hl.bind(MAIN_MOD .. "7", hl.dsp.focus({ workspace = "7" }))
hl.bind(MAIN_MOD .. "8", hl.dsp.focus({ workspace = "8" }))
hl.bind(MAIN_MOD .. "9", hl.dsp.focus({ workspace = "9" }))
hl.bind(MAIN_MOD .. "0", hl.dsp.focus({ workspace = "10" }))

-- Move the focused window to a workspace.
hl.bind(MAIN_MOD .. "SHIFT + 1", hy3.move_to_workspace("1"))
hl.bind(MAIN_MOD .. "SHIFT + 2", hy3.move_to_workspace("2"))
hl.bind(MAIN_MOD .. "SHIFT + 3", hy3.move_to_workspace("3"))
hl.bind(MAIN_MOD .. "SHIFT + 4", hy3.move_to_workspace("4"))
hl.bind(MAIN_MOD .. "SHIFT + 5", hy3.move_to_workspace("5"))
hl.bind(MAIN_MOD .. "SHIFT + 6", hy3.move_to_workspace("6"))
hl.bind(MAIN_MOD .. "SHIFT + 7", hy3.move_to_workspace("7"))
hl.bind(MAIN_MOD .. "SHIFT + 8", hy3.move_to_workspace("8"))
hl.bind(MAIN_MOD .. "SHIFT + 9", hy3.move_to_workspace("9"))
hl.bind(MAIN_MOD .. "SHIFT + 0", hy3.move_to_workspace("10"))

-- Move the focused window to the scratchpad (a hidden workspace).
hl.bind(MAIN_MOD .. "SHIFT + minus", hy3.move_to_workspace("special:scratchpad"))

-- Display all scratchpad windows.
hl.bind(MAIN_MOD .. "minus", hl.dsp.workspace.toggle_special("scratchpad"))

-- Show workspace overview.
hl.bind(MAIN_MOD .. "O", function()
	hl.plugin.hyprexpo.expo("toggle")
end)
