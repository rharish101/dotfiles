-- SPDX-FileCopyrightText: 2022 Harish Rajagopal <harish.rajagopals@gmail.com>
--
-- SPDX-License-Identifier: MIT

return {
	"aa-notify -p -s 1 -w 60 -f /var/log/audit/audit.log", -- AppArmor notifications on denials
	"corectrl --minimize-systray",
	"kdeconnectd",
	"kdeconnect-indicator",
	"system-config-printer-applet", -- Printer status
	"systemctl --user start xfce4-notifyd.service",
	"hyprctl setcursor Breeze_Light 24", -- Set the cursor theme.
	"Thunar --daemon",
	"cursor-clip --daemon", -- Clipboard manager
	"ashell", -- Status bar + tray
	"hyprpm reload", -- Enable Hyprland plugins.
	"wpaperd -d", -- Wallpaper daemon for random wallpapers
	"systemctl --user start hyprland-session.target",
}
