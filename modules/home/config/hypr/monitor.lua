-- Single monitor (Samsung C49G9, 5120x1440). Matched by description so port
-- changes (DP-1/DP-3/etc) don't break it. Positioned at (0, 1080) for
-- historical reasons (an HDMI screen used to sit above it): the EVE window
-- layout in modules/home/eve-window-manager.nix uses global coordinates
-- relative to this offset, so move both together if you ever change it.
hl.monitor({ output = "desc:Samsung Electric Company LC49G95T", mode = "5120x1440@120.00", position = "0x1080", scale = 1 })

hl.config({
    xwayland = { force_zero_scaling = true },
})
