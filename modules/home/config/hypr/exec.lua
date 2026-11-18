-- Autostart necessary processes (notifications daemons, status bars, etc.)
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Eve window-snapping daemon. Started explicitly because this session does
    -- not activate graphical-session.target (which the unit's WantedBy targets).
    -- Runs after the env import above so it inherits HYPRLAND_INSTANCE_SIGNATURE.
    hl.exec_cmd("systemctl --user start eve-window-snap")

    -- XWayland->Wayland clipboard bridge: Wine/EVE copies land only in the X11
    -- clipboard, so native-Wayland apps can't paste them. This daemon mirrors
    -- them across. Started explicitly for the same graphical-session.target
    -- reason as the line above.
    hl.exec_cmd("systemctl --user start clipboard-bridge")

    -- SwayNC notification daemon. Nothing else starts it: its packaged unit is
    -- WantedBy graphical-session.target, which never activates in this session.
    -- Without it notify-send (and any desktop notification) silently fails.
    hl.exec_cmd("swaync")

    -- Pin workspaces to monitors at startup
    -- (moveworkspacetomonitor-style `hyprctl dispatch` is gone with the Lua
    -- config; hl.timer would be nicer but a delayed eval keeps the old timing)
    hl.exec_cmd([[sleep 2 && hyprctl eval 'for _, ws in ipairs({ 2, 3, 10 }) do hl.dispatch(hl.dsp.workspace.move({ workspace = ws, monitor = "HDMI-A-1" })) end']])

    hl.exec_cmd("waybar")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprctl setcursor rose-pine-hyprcursor 24")
    hl.exec_cmd("discord --start-minimized")
    hl.exec_cmd("[workspace special:spotify silent] spotify")
    hl.exec_cmd("[workspace special:terminal silent] kitty")
    hl.exec_cmd("streamdeck -n")
end)
