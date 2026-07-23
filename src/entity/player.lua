p_hw = 8 -- hitbox width
p_hh = 8 -- hitbox height
p_ani = {1,2}
p_anis = 10 -- Overridden in move logic
p_age = 0
p_speed = 1.4*framerate_mult
p_current_speed_x = 0
p_current_speed_y = 0
p_last_dir = 0
p_shoot_speed = 3*framerate_mult
p_shoot_delay = 10/framerate_mult
p_last_shoot_frame = 0
p_flash_frames = 0

function init_player()
    p_x = 30
    p_y = 30
    p_last_dir = 0
    p_health = 3
    player_bullets = {}
end

function update_player()
    move_player()
    shoot()
    handle_player_collisions()

    if p_flash_frames > 0 then
        p_flash_frames -= 1
    end

    if p_health <= 0 then
        death()
    end

    -- Update anim
    p_age+=1
end

function draw_player()
    -- Handle flash frames
    if p_flash_frames > 0 then
        for i=1,15 do
            pal(i, 8)
        end
    end

    draw_sprite(cyc(p_age, p_anis,
        p_ani), p_x, p_y)
    print("\^o05ahealth: "..p_health, 8, 12, 7)

     -- Undo flash frames for next drawn items
    if p_flash_frames > 0 then
        pal()
        toggle_sprite_transparency(true)
    end

    if debug then
        rect(p_x-p_hw/2, p_y-p_hh/2,
            p_x+p_hw/2, p_y+p_hh/2, 7)
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
        add_player_bullet( p_x, p_y + 4, p_shoot_speed, 0, 4, 8)
        p_last_shoot_frame = T
        sfx(0)
     end
end

function handle_player_collisions()
    for b in all(enemy_bullets) do
        local collided = false
        collided = hit(
            b.x - b.hw/2,
            b.y - b.hh/2,
            b.hw,
            b.hh,
            p_x-p_hw/2,
            p_y-p_hh/2,
            p_hw,
            p_hh,
            b.x - b.hw/2 + b.spdx,
            b.y - b.hh/2 + b.spdy
        )
        if collided then
            del(enemy_bullets, b)
            p_flash_frames = 6/framerate_mult
            p_health -= 1
            if p_health > 0 then
                freeze_frames = 12
                sfx(3)
            end
        end
    end
end

function death()
    explode(p_x, p_y)
    sfx(2)
    game_state = "game_over"
end