-- boss-key.lua
-- Pause playback and minimize the window instantly

local function boss_key()
    mp.set_property("pause", "yes")
    mp.set_property("window-minimized", "yes")
end

mp.add_key_binding(nil, "boss-key", boss_key)
