hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 1,
        col = {
            active_border   = { colors = { "rgb(8aadf4)", "rgb(24273A)", "rgb(24273A)", "rgb(8aadf4)" }, angle = 45 },
            inactive_border = { colors = { "rgb(24273A)", "rgb(24273A)", "rgb(24273A)", "rgb(24273A)" }, angle = 45 },
        },
        layout = "dwindle",
        allow_tearing = false,
        resize_on_border = true,
        extend_border_grab_area = 15,
    },

    decoration = {
        rounding = 10,
        blur = {
            enabled = true,
            size    = 2,
            passes  = 2,
            xray    = false,
        },
        shadow = {
            enabled      = true,
            range        = 15,
            render_power = 2,
            color        = 0x991a1a1a,
        },
    },

    animations = { enabled = true },

    dwindle = { preserve_split = true },

    misc = {
        force_default_wallpaper = 0,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms  = true,
    },

    debug = { vfr = true },

    cursor = { inactive_timeout = 3 },
})

hl.curve("overshot",  { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("smoothOut", { type = "bezier", points = { { 0.36, 0 },   { 0.66, -0.56 } } })
hl.curve("smoothIn",  { type = "bezier", points = { { 0.25, 1 },   { 0.5, 1 } } })

hl.animation({ leaf = "windows",     enabled = true, speed = 5,  bezier = "overshot",  style = "slide" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 4,  bezier = "smoothOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4,  bezier = "default" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 10, bezier = "smoothIn" })
hl.animation({ leaf = "fadeDim",     enabled = true, speed = 10, bezier = "smoothIn" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })
