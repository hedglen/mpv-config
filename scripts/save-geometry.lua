-- save-geometry.lua
-- Persists window size/position across all files and instances.
-- Saves before each file loads, restores after (prevents auto-resize to video dims).

local mp = require 'mp'

local geo_file = mp.command_native({"expand-path", "~~home/window-geometry.txt"})

local function save_geo()
    local w = mp.get_property_number("osd-width")
    local h = mp.get_property_number("osd-height")
    if not w or not h or w <= 0 or h <= 0 then return end

    local x = mp.get_property_number("window-pos-x")
    local y = mp.get_property_number("window-pos-y")

    local geo
    if x and y then
        geo = string.format("%dx%d+%d+%d", math.floor(w), math.floor(h), math.floor(x), math.floor(y))
    else
        geo = string.format("%dx%d", math.floor(w), math.floor(h))
    end

    local out = io.open(geo_file, "w")
    if out then out:write(geo); out:close() end
end

local function restore_geo()
    local f = io.open(geo_file, "r")
    if not f then return end
    local geo = f:read("*l")
    f:close()
    if geo and geo ~= "" then
        mp.set_property("geometry", geo)
    end
end

-- Restore at startup
restore_geo()

-- Save current window state just before a new file loads
mp.register_event("start-file", save_geo)

-- Re-apply saved geometry after file loads (mpv may have auto-resized to video dims)
mp.register_event("file-loaded", restore_geo)

-- Save on quit
mp.register_event("shutdown", save_geo)
