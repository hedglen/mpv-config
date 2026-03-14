-- ab-loop-manager.lua
-- Separate bindings for A point, B point, and reset (unlike built-in ab-loop
-- which cycles through all three with one key)

local function mark_a()
    local pos = mp.get_property_number("time-pos")
    if not pos then return end
    mp.set_property("ab-loop-a", pos)
    mp.osd_message(string.format("A-B: A = %.2fs", pos))
end

local function mark_b()
    local pos = mp.get_property_number("time-pos")
    if not pos then return end
    mp.set_property("ab-loop-b", pos)
    mp.osd_message(string.format("A-B: B = %.2fs", pos))
end

local function reset_loop()
    mp.set_property("ab-loop-a", "no")
    mp.set_property("ab-loop-b", "no")
    mp.osd_message("A-B: Loop cleared")
end

mp.add_key_binding(nil, "mark-a", mark_a)
mp.add_key_binding(nil, "mark-b", mark_b)
mp.add_key_binding(nil, "reset", reset_loop)
