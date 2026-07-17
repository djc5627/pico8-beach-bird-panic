-- Helper method to cycle animation
---@diagnostic disable: missing-type-argument
function cyc(age, anis, arr)
    local anis = anis or 1 -- default speed to 1 if not passed
    return arr[(age\anis-1) % #arr+1]
end