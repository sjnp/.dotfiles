local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = wezterm.config_builder()

-- Helper fn
function IsMacOS()
    local f = assert(io.popen('uname -a', 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if string.find(s, 'Darwin') then
        return true
    else
        return false
    end
end

-- Start up
wezterm.on('gui-startup', function(cmd)
    local _, _, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

config.term = 'wezterm'

-- Colors
config.color_scheme = 'tokyonight_night'

-- Font
config.font = wezterm.font 'MesloLGS NF'
config.font_size = 10.0

-- Window
if not IsMacOS() then
    config.window_decorations = 'NONE'
end
config.enable_tab_bar = false
config.enable_scroll_bar = false
config.window_padding = {
    left = 1,
    right = 0,
    top = 1,
    bottom = 1
}

return config
