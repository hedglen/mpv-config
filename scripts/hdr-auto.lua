-- hdr-auto.lua
-- Automatically enables Windows HDR for HDR content (HDR10/HLG),
-- disables it for SDR content, and always restores on exit.
--
-- REQUIREMENT: hdrswitch.exe in your mpv config directory.
-- (Uses HdrSwitcher by Vaiz: https://github.com/Vaiz/HdrSwitcher/releases)

local hdrswitch = mp.command_native({"expand-path", "~~/hdrswitch.exe"})
local hdr_active = false

-- Transfer functions that indicate HDR content
local HDR_TRANSFERS = { pq = true, hlg = true }

-- Verify hdrswitch.exe exists
local function hdrswitch_available()
    local f = io.open(hdrswitch, "r")
    if f then f:close(); return true end
    return false
end

local function apply_mpv_settings(hdr)
    if hdr then
        -- HDR passthrough: let mpv read the video's own color metadata
        mp.set_property("target-colorspace-hint", "yes")
        mp.set_property("hdr-compute-peak", "yes")
    else
        -- SDR mode: restore config defaults
        mp.set_property("target-colorspace-hint", "no")
        mp.set_property("hdr-compute-peak", "no")
    end
end

local function set_hdr(enable)
    if enable == hdr_active then return end

    if not hdrswitch_available() then
        mp.osd_message("HDR-Auto: hdrswitch.exe not found in config dir", 4)
        return
    end

    -- Pause during the display mode transition (avoids visual glitch)
    local was_paused = mp.get_property_bool("pause")
    mp.set_property_bool("pause", true)

    mp.commandv("run", hdrswitch, enable and "enable" or "disable")
    apply_mpv_settings(enable)
    hdr_active = enable

    -- Resume after display settles (~1.5s for most monitors to switch modes)
    mp.add_timeout(1.5, function()
        if not was_paused then
            mp.set_property_bool("pause", false)
        end
        mp.osd_message(enable and "HDR: On (HDR content detected)" or "HDR: Off (SDR content)", 2)
    end)
end

local function detect_and_switch()
    -- video-params reflects the actual stream metadata, regardless of our forced bt.709 overrides
    local gamma    = mp.get_property("video-params/gamma") or ""
    local primaries = mp.get_property("video-params/primaries") or ""
    local needs_hdr = HDR_TRANSFERS[gamma] ~= nil or primaries == "bt.2020"
    set_hdr(needs_hdr)
end

local function manual_toggle()
    set_hdr(not hdr_active)
end

mp.register_event("file-loaded", detect_and_switch)

-- Always restore HDR to off when mpv closes
mp.register_event("shutdown", function()
    if hdr_active and hdrswitch_available() then
        mp.commandv("run", hdrswitch, "disable")
    end
end)

mp.add_key_binding(nil, "toggle-hdr", manual_toggle)
