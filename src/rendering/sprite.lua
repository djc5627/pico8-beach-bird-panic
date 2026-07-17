-- Keeps track of Sprite table and offers
-- methods to interpret sprites

--[[
sprites = {
    {spritex, spritey, width, height, mirrorx, offsetx, offsety},
    ...
}
--]]

sprites = {
    {0, 0, 17, 23, false, 7, 8}, -- 1) Player wings down
    {17, 0, 23, 13, false, 11, 8}, -- 2) Player wings up
    {0, 26, 13, 13, false, 7, 6}, -- 3) Person
    {17, 16, 5, 8, false, 2, 5} -- 4) Player Poop
}

function _draw_sprite(index, x, y)
    local sprite = sprites[index]

    sspr(
        sprite[1],
        sprite[2],
        sprite[3],
        sprite[4],
        x - sprite[6],
        y - sprite[7],
        sprite[3],
        sprite[4],
        false,
        false
    )

    -- mirrorx
    if sprite[5] then
        sspr(
                sprite[1],
                sprite[2],
                sprite[3],
                sprite[4],
                x  - sprite[6] + sprite[3],
                y - sprite[7],
                sprite[3],
                sprite[4],
                true,
                false
            )
    end
end

-- Wrapper to draw sprite that is animated
function _draw_sprite_anim(obj)
    _draw_sprite(cyc(obj.age, obj.anis, obj.ani), obj.x, obj.y)
end