p_hw = 8 -- hitbox width
p_hh = 8 -- hitbox height
p_ani = {1,2}
p_anis = 10
p_age = 0

function _init_player()
    p_x = 30
    p_y = 30
end

function _update_player()
    -- Update anim
    p_age+=1
end

function _draw_player()
    _draw_sprite(cyc(p_age, p_anis, p_ani), p_x, p_y)
    --print("health: "..p_health, 8, 12, 7)
    if debug then
        rect(p_x-p_hw/2, p_y-p_hh/2, p_x+p_hw/2, p_y+p_hh/2, 7)
        pset(p_x, p_y, 8)
    end
end