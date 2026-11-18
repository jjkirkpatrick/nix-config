-- prevent apps from maximizing themselves
hl.window_rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })

-- floating windows
local floatClasses = {
    "Viewnior", "mpv", "zenity", "org.gnome.FileRoller", "org.pulseaudio.pavucontrol",
    "file_progress", "confirm", "dialog", "download", "notification", "error", "confirmreset",
}
for _, cls in ipairs(floatClasses) do
    hl.window_rule({ name = "float-" .. cls, match = { class = "^(" .. cls .. ")$" }, float = true })
end

local floatTitles = {
    "Volume Control", "Picture-in-Picture", "Open File", "File Upload",
    "branchdialog", "Confirm to replace files", "File Operation Progress",
}
for _, title in ipairs(floatTitles) do
    hl.window_rule({ name = "float-title-" .. title, match = { title = "^(" .. title .. ")$" }, float = true })
end

-- calendar popup (gsimplecal) — float, position below cursor, no animation
hl.window_rule({
    name = "gsimplecal",
    match = { class = "^(gsimplecal)$" },
    float = true,
    move = "cursor -100 5",
    no_anim = true,
})

-- logout window
hl.window_rule({ name = "wlogout", match = { class = "^(wlogout)$" }, fullscreen = true, float = true })

-- floating with pins
hl.window_rule({ name = "pip-pin", match = { title = "^(Picture-in-Picture)$" }, float = true, pin = true })
hl.window_rule({ name = "steam-friends", match = { class = "^(steam)$", title = "^(Friends List)$" }, float = true })
hl.window_rule({ name = "spotify-float", match = { class = "^(spotify)$" }, float = true })

-- positioning and sizing
hl.window_rule({ name = "volume-control-size", match = { title = "^(Volume Control)$" }, size = "700 450", move = "40 55%" })
hl.window_rule({ name = "zenity-size", match = { class = "^(zenity)$" }, size = "850 500" })

-- fully opaque windows
local opaqueTargets = {
    { field = "title", pattern = "^(Picture-in-Picture)$" },
    { field = "title", pattern = "^(.*mpv.*)$" },
    { field = "class", pattern = "^(evince)$" },
    { field = "class", pattern = "^(discord)$" },
    { field = "class", pattern = "^(spotify)$" },
    { field = "class", pattern = "^(vlc)$" },
}
for _, t in ipairs(opaqueTargets) do
    hl.window_rule({
        name = "opaque-" .. t.pattern,
        match = { [t.field] = t.pattern },
        opacity = "1.0 override 1.0 override",
    })
end

-- workspace assignments
hl.window_rule({ name = "discord-workspace", match = { class = "^(discord)$" },       workspace = "2 silent" })
hl.window_rule({ name = "evince-workspace",  match = { class = "^(evince)$" },        workspace = "3" })

-- xwaylandvideobridge (screen sharing helper — keep invisible and non-interfering)
hl.window_rule({
    name = "xwaylandvideobridge",
    match = { class = "^(xwaylandvideobridge)$" },
    opacity = "0.0 override",
    animation = "false",
    rounding = 0,
})

-- Exiled Exchange 2 overlay — disable Hyprland blur so the transparent
-- click-through overlay renders correctly (the app itself is forced onto
-- XWayland in its Nix wrapper to restore click-through). See EE2 issue #794.
hl.window_rule({ name = "ee2-no-blur", match = { title = "^(Exiled Exchange 2)$" }, no_blur = true })

-- chromium context menu fixes (empty class/title = context menus)
hl.window_rule({ name = "chromium-context-menu", match = { class = "^()$", title = "^()$" }, opaque = true })

-- single window optimizations (no border/rounding when only one tiled window)
hl.workspace_rule({ workspace = "w[t1]",  gaps_out = 0, gaps_in = 0, no_border = true, no_rounding = true })
hl.workspace_rule({ workspace = "w[tg1]", gaps_out = 0, gaps_in = 0, no_border = true, no_rounding = true })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0, no_border = true, no_rounding = true })
