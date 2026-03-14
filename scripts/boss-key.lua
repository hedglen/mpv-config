-- boss-key.lua
-- Pause playback and minimize the window instantly

local function boss_key()
    mp.set_property("pause", "yes")
    mp.set_property("window-minimized", "yes")
end

mp.add_forced_key_binding("F22", "boss-key", boss_key)
mp.register_script_message("boss-key", boss_key)
