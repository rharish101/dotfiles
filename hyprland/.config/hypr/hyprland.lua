-- SPDX-FileCopyrightText: 2022 Harish Rajagopal <harish.rajagopals@gmail.com>
--
-- SPDX-License-Identifier: MIT

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 0,
		layout = "hy3",
	},

	decoration = {
		rounding = 8,
		rounding_power = 4,
		dim_inactive = true,
		dim_strength = 0.3,
		shadow = { range = 10 },
		blur = { enabled = false },
	},

	input = {
		sensitivity = 0.2, -- For mouse cursor
		follow_mouse = 2, -- Focus mouse on other windows on hover but not the keyboard.
		float_switch_override_focus = 0,
		kb_options = "compose:menu", -- Use the menu button as the compose key.
		numlock_by_default = true, -- Enable numlock by default.
		touchpad = { natural_scroll = true },
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		vrr = 2,
	},

	render = { cm_auto_hdr = 2 }, -- Use EDID.

	cursor = { no_warps = true },

	plugin = {
		dynamic_cursors = { mode = "none" },
		hyprexpo = { workspace_method = "first 1", label_show = "hover+focus" },
		hy3 = {
			autotile = { enable = true },
			tabs = {
				height = 30,
				text_height = 12,
				border_width = 0,
				colors = {
					active = "rgba(464b51ff)",
					focused = "rgba(212326ff)",
					inactive = "rgba(212326ff)",
				},
			},
		},
	},
})

hl.monitor({
	output = "DP-2",
	mode = "preferred",
	bitdepth = 10,
	icc = os.getenv("HOME") .. "/Documents/Misc/rtings-icc-profile-asus-vg34vql1b.icm",
})

-- Set the cursor theme
hl.env("XCURSOR_THEME", "Breeze_Light")
hl.env("XCURSOR_SIZE", "24")

-- Startup scripts
local STARTUP_CMDS <const> = require("startup")
hl.on("hyprland.start", function()
	for _, cmd in ipairs(STARTUP_CMDS) do
		hl.exec_cmd(cmd)
	end
end)

-- Keybinds
require("keybinds")

-- ----------------------------------------
-- Animations
-- ----------------------------------------

-- Source: https://easings.net/#easeInOutCubic
hl.curve("default", { type = "bezier", points = { { 0.65, 0 }, { 0.35, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 2.5, bezier = "default" })
hl.animation({ leaf = "layers", enabled = true, speed = 1.5, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "default" })

-- ----------------------------------------
-- Window rules
-- ----------------------------------------

hl.window_rule({
	name = "Lollypop",
	match = { class = "lollypop" },
	float = true,
	center = true,
	size = { "monitor_w * 0.35", "monitor_h * 0.6" },
})

-- Notifications
hl.window_rule({
	name = "Notifications",
	match = { class = "xfce4-notifyd" },
	move = { "monitor_w - 200", "monitor_h - 100" },
	no_initial_focus = true,
})

-- Misc
hl.window_rule({ match = { class = "Matplotlib", float = true } })
hl.window_rule({ match = { title = "Password Required - Mozilla Thunderbird", float = true } })
