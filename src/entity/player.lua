p_hw = 8 -- hitbox width
p_hh = 8 -- hitbox height
p_ani = {1,2}
p_anis = 10 -- Overridden in move logic
p_age = 0
p_speed = 1.4
p_current_speed_x = 0
p_current_speed_y = 0
p_last_dir = 0
p_shoot_delay = 10
p_last_shoot_frame = 0

function init_player()
    p_x = 30
    p_y = 30
    p_last_dir = 0
end

function update_player()
    move_player()
    shoot()
    -- Update anim
    p_age+=1
end

function draw_player()
    draw_sprite(cyc(p_age, p_anis, p_ani), p_x, p_y)
    --print("health: "..p_health, 8, 12, 7)
    if debug then
        rect(p_x-p_hw/2, p_y-p_hh/2, p_x+p_hw/2, p_y+p_hh/2, 7)
        pset(p_x, p_y, 8)
    end
end

function move_player()
    -- Bitwise & to strip out the o/x inputs
    local dir = butarr[btn()&0b1111]

    if p_last_dir!=dir and dir>=5 then
        --Anti-cobblestone on diagonals
        p_x = flr(p_x) + 0.5
        p_y = flr(p_y) + 0.5
    end

    if dir > 0 then
        p_current_speed_x = dirx[dir]*p_speed
        p_current_speed_y = diry[dir]*p_speed
        p_x += p_current_speed_x
        p_y += p_current_speed_y
    end

    -- Up input
    if dir == 3 or dir == 5 or dir == 6 then
       p_anis = 5
    -- Down input
    elseif dir == 4 or dir == 7 or dir == 8 then
        p_anis = .1
        p_age = 0
    else
        p_anis = 10
    end

end

function shoot()
    -- Only shoot if delay has passed since the last shot
    if btn(4) and T - p_last_shoot_frame >= p_shoot_delay then
        add_player_bullet( p_x, p_y + 4, p_current_speed_x, p_current_speed_y, 4, 8)
        p_last_shoot_frame = T
        sfx(0)
     end
end