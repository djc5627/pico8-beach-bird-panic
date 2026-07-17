p_hw = 8 -- hitbox width
p_hh = 8 -- hitbox height
p_ani = {1,2}
p_anis = 10
p_age = 0
p_speed = 1.4
p_last_dir = 0

function _init_player()
    p_x = 30
    p_y = 30
    p_last_dir = 0
end

function _update_player()
    _move_player()
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

function _move_player()
    -- Bitwise & to strip out the o/x inputs
    local dir = butarr[btn()&0b1111]

    if p_last_dir!=dir and dir>=5 then
        --Anti-cobblestone on diagonals
        p_x = flr(p_x) + 0.5
        p_y = flr(p_y) + 0.5
    end

    if dir > 0 then
        p_x += dirx[dir]*p_speed
        p_y += diry[dir]*p_speed
    end
end