-- Keeps track of Sprite table and offers
-- methods to interpret sprites

--[[
sprites = {
    {spritex, spritey, width, height, mirrorx, offsetx, offsety},
    ...
}
--]]

sprites = {
    {0, 0, 8, 16, true, 8, 8}, -- 1) Player
    {8, 0, 4, 16, true, 4, 8}, -- 2) Player Bullet
    {0, 16, 8, 16, true, 8, 8}, -- 3) Enemy1
    {8, 16, 8, 16, true, 8, 8}, -- 4) Enemy2
    {16, 16, 8, 8, false, 4, 4}, -- 5) Enemy Bullet
    {12, 0, 3, 16, true, 3, 8}, -- 6) Player Bullet 2
    {15, 0, 2, 16, true, 2, 8}, -- 7) Player Bullet 3
    {17, 0, 6, 16, true, 6, 8}, -- 8) Muzzle flash 1
    {23, 0, 7, 16, true, 7, 8}, -- 8) Muzzle flash 2
    {30, 0, 8, 16, true, 8, 8}, -- 8) Muzzle flash 3
    {38, 0, 8, 16, true, 8, 8} -- 8) Muzzle flash 4
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