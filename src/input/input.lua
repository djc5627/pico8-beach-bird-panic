----- btn() values for given inputs
-- Note: Must bitwise &001111 to remove the x/o button bits
-- 0 - stop
-- 1 - left
-- 2 - right
-- 3 - l+r = stop
-- 4 - up
-- 5 - diag L/U
-- 6 - diag R/U
-- 7 - l+u+r = up
-- 8 - down
-- 9 - diag L/D
-- 10 - diag R/D
-- 11 - l+d+r = d
-- 12 - u+d = stop
-- 13 - l+u+d = left
-- 14 - r+u+d = r
-- 15 - l+u+r+d = stop

----- Output of our conversion
-- 0 - no buttons pressed
-- 1 - left
-- 2 - right
-- 3 - up
-- 4 - down

-- 5 - left/up
-- 6 - right/up
-- 7 - right/down
-- 8 - left/down

butarr={1,2,0,3,5,6,3,4,8,7,4,0,1,2,0}
butarr[0]=0
dirx={-1,1,0,0,-0.75,0.75,0.75,-0.75}
diry={0,0,-1,1,-0.75,-0.75,0.75,0.75}


--[[
-- Helper to get move input and strip o/x input
function get_move_input()
    -- Bitwise & to strip out the o/x inputs
    local dir = butarr[btn()&0b1111]
    return dir
end

function is_diagonal_input()
    dir = get_move_input()
    return dir >= 5
end
--]]