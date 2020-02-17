#!/usr/bin/bash
# This tells xfce4-session to first start xfsettings and then move on to compiz.
# This solves the following problems:
# 1. Unthemed logout menu
# 2. Unthemed panel background at startup
# 3. Slow startup of Xfce
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client0_Command -a -s xfsettingsd
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client1_Command -a -s compiz
