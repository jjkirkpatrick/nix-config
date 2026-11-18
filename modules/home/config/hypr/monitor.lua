-- Primary monitor (Samsung C49G9): 5120x1440 at bottom, positioned at (0, 1080)
-- Matched by description so port changes (DP-1/DP-3/etc) don't break the layout.
hl.monitor({ output = "desc:Samsung Electric Company LC49G95T", mode = "5120x1440@120.00", position = "0x1080", scale = 1 })

-- Secondary monitor (HDMI-A-1): Stacked above the Samsung, centered horizontally
-- Horizontal center: (5120 - 1920) / 2 = 1600
-- Vertical position: 0 (top)
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "1600x0", scale = 1 })

-- Workspace-Monitor assignments for consistent placement
-- Primary monitor (Samsung)
hl.workspace_rule({ workspace = "1", monitor = "desc:Samsung Electric Company LC49G95T", default = true })
hl.workspace_rule({ workspace = "4", monitor = "desc:Samsung Electric Company LC49G95T" })
hl.workspace_rule({ workspace = "5", monitor = "desc:Samsung Electric Company LC49G95T" })

-- Secondary monitor (HDMI-A-1)
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "3", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-1" })

hl.config({
    xwayland = { force_zero_scaling = true },
})
