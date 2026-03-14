-- favorites.lua
-- F16 (btn 4)       → open favorites as playlist
-- Ctrl+F16 (btn 4)  → add current file to favorites

local fav_file = mp.command_native({"expand-path", "~~/favorites.txt"})

local function add_favorite()
    local path = mp.get_property("path")
    if not path then
        mp.osd_message("No file playing")
        return
    end

    -- Check for duplicate
    local f = io.open(fav_file, "r")
    if f then
        for line in f:lines() do
            if line == path then
                f:close()
                mp.osd_message("Already in favorites")
                return
            end
        end
        f:close()
    end

    -- Append
    f = io.open(fav_file, "a")
    if f then
        f:write(path .. "\n")
        f:close()
        mp.osd_message("Added to favorites: " .. (mp.get_property("filename") or path))
    else
        mp.osd_message("Error: could not write favorites file")
    end
end

local function open_favorites()
    local f = io.open(fav_file, "r")
    if not f then
        mp.osd_message("Favorites empty — Ctrl+F16 to add current file")
        return
    end
    f:close()
    mp.commandv("loadlist", fav_file, "replace")
    mp.osd_message("Loaded favorites")
end

mp.add_key_binding(nil, "favorites-open", open_favorites)
mp.add_key_binding(nil, "favorites-add", add_favorite)

mp.register_script_message("favorites-open", open_favorites)
mp.register_script_message("favorites-add", add_favorite)
