local mainMod = "SUPER"

hl.config({ binds = { movefocus_cycles_fullscreen = true } })

-- application launchers
hl.bind(mainMod .. " + Return",         hl.dsp.exec_cmd("kitty"))
hl.bind("ALT + Return",                 hl.dsp.exec_cmd("[float; size 1111 700] kitty"))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("[fullscreen] kitty"))
hl.bind(mainMod .. " + B",              hl.dsp.exec_cmd("[workspace 1 silent] google-chrome-stable"))
hl.bind(mainMod .. " + S",              hl.dsp.exec_cmd("[workspace 2 silent] spotify"))
hl.bind(mainMod .. " + R",              hl.dsp.exec_cmd("pkill fuzzel || fuzzel"))
hl.bind("F4",                           hl.dsp.exec_cmd("pkill fuzzel || fuzzel"))
hl.bind(mainMod .. " + E",              hl.dsp.exec_cmd("nemo"))
hl.bind("ALT + E",                      hl.dsp.exec_cmd("[float; size 1111 700] nemo"))

hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("dev-layout"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("eve-session"))

-- window management
hl.bind(mainMod .. " + Q",         hl.dsp.window.close())
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + Space",     hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",         hl.dsp.window.pseudo())
hl.bind(mainMod .. " + X",         hl.dsp.layout("togglesplit")) -- dwindle only

-- system controls
hl.bind(mainMod .. " + Escape",         hl.dsp.exec_cmd("hyprlock"))
hl.bind("ALT + Escape",                 hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + Escape", hl.dsp.exec_cmd("wlogout"))
hl.bind("CTRL + SHIFT + Escape",        hl.dsp.exec_cmd("[workspace 9] kitty -e btop"))

-- utilities
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd([[hyprctl -j binds | jq -r '.[] | "\(if .modmask==64 then "SUPER" elif .modmask==65 then "SUPER+SHIFT" elif .modmask==68 then "SUPER+CTRL" elif .modmask==72 then "SUPER+ALT" elif .modmask==8 then "ALT" elif .modmask==5 then "CTRL+SHIFT" elif .modmask==12 then "ALT+CTRL" elif .modmask==0 then "     " else (.modmask|tostring) end) + \(.key)  →  \(.dispatcher) \(.arg)"' | fuzzel --dmenu --prompt="Keybinds: "]]))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("pkill waybar || waybar"))
hl.bind(mainMod .. " + N",         hl.dsp.exec_cmd("swaync-client -d"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(mainMod .. " + V",         hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))

-- applications
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("discord"))

-- special workspaces
hl.bind(mainMod .. " + SHIFT + S",     hl.dsp.workspace.toggle_special("spotify"))
hl.bind(mainMod .. " + grave",         hl.dsp.workspace.toggle_special("terminal"))
hl.bind(mainMod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = "special:terminal" }))

-- screenshots
hl.bind("Print",                       hl.dsp.exec_cmd("grim - | wl-copy"))
hl.bind(mainMod .. " + CTRL + Print",  hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))
hl.bind(mainMod .. " + Print",         hl.dsp.exec_cmd("grim ~/Pictures/screenshot-$(date +%Y%m%d_%H%M%S).png"))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | swappy -f -]]))
hl.bind(mainMod .. " + SHIFT + G",     hl.dsp.exec_cmd("record-gif"))

-- focus movement
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))

-- focus floating/tiled windows
hl.bind("CTRL + ALT + up",   hl.dsp.window.cycle_next({ floating = true }))
hl.bind("CTRL + ALT + down", hl.dsp.window.cycle_next({ tiled = true }))

-- workspace switching (mainMod + [0-9])
-- move active window to a workspace, silently (mainMod + SHIFT + [0-9])
-- (0.57 has no `silent` key; `follow = false` is the silent form)
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end
hl.bind(mainMod .. " + CTRL + c", hl.dsp.window.move({ workspace = "empty" }))

-- window movement (swap position by direction)
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))

-- window resizing (hold to repeat). `relative` defaults to false (absolute
-- size/position) in the Lua API, so it must be set for nudges.
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.resize({ x = -80, y = 0, relative = true }),   { repeating = true })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 80,  y = 0, relative = true }),   { repeating = true })
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.resize({ x = 0,   y = -80, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.resize({ x = 0,   y = 80, relative = true }),  { repeating = true })
hl.bind(mainMod .. " + CTRL + h", hl.dsp.window.resize({ x = -80, y = 0, relative = true }),   { repeating = true })
hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.resize({ x = 0,   y = 80, relative = true }),  { repeating = true })
hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.resize({ x = 0,   y = -80, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + l", hl.dsp.window.resize({ x = 80,  y = 0, relative = true }),   { repeating = true })

-- window positioning (hold to repeat)
hl.bind(mainMod .. " + ALT + left",  hl.dsp.window.move({ x = -80, y = 0, relative = true }),   { repeating = true })
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.move({ x = 80,  y = 0, relative = true }),   { repeating = true })
hl.bind(mainMod .. " + ALT + up",    hl.dsp.window.move({ x = 0,   y = -80, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + down",  hl.dsp.window.move({ x = 0,   y = 80, relative = true }),  { repeating = true })
hl.bind(mainMod .. " + ALT + h", hl.dsp.window.move({ x = -80, y = 0, relative = true }),  { repeating = true })
hl.bind(mainMod .. " + ALT + j", hl.dsp.window.move({ x = 0,   y = 80, relative = true }),  { repeating = true })
hl.bind(mainMod .. " + ALT + k", hl.dsp.window.move({ x = 0,   y = -80, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + l", hl.dsp.window.move({ x = 80,  y = 0, relative = true }),   { repeating = true })

-- media controls
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { repeating = true })

hl.bind(mainMod .. " + F7",  hl.dsp.exec_cmd("playerctl previous"))
hl.bind(mainMod .. " + F8",  hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind(mainMod .. " + F9",  hl.dsp.exec_cmd("playerctl next"))
hl.bind(mainMod .. " + F10", hl.dsp.exec_cmd("pamixer -t"))
hl.bind(mainMod .. " + F11", hl.dsp.exec_cmd("pamixer -d 5"), { repeating = true })
hl.bind(mainMod .. " + F12", hl.dsp.exec_cmd("pamixer -i 5"), { repeating = true })

-- mouse workspace switching
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e+1" }))

-- mouse bindings
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
