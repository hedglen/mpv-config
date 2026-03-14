-- save-geometry.lua
-- Saves window size and position on quit, restores on next launch.

local mp = require 'mp'

local geo_file = mp.command_native({"expand-path", "~~home/window-geometry.txt"})

-- Restore saved geometry at startup (before any file loads)
local f = io.open(geo_file, "r")
if f then
    local geo = f:read("*l")
    f:close()
    if geo and geo ~= "" then
        mp.set_property("geometry", geo)
    end
end

mp.register_event("shutdown", function()
    local w = mp.get_property_number("osd-width")
    local h = mp.get_property_number("osd-height")
    if not w or not h or w <= 0 or h <= 0 then return end

    -- Try to get window position (available in newer mpv builds)
    local x = mp.get_property_number("window-pos-x")
    local y = mp.get_property_number("window-pos-y")

    local geo
    if x and y then
        geo = string.format("%dx%d+%d+%d", math.floor(w), math.floor(h), math.floor(x), math.floor(y))
    else
        geo = string.format("%dx%d", math.floor(w), math.floor(h))
    end

    local out = io.open(geo_file, "w")
    if out then
        out:write(geo)
        out:close()
    end
end)
