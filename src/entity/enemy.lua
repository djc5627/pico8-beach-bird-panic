enemies = {}

function add_enemy(x, y, health, shoot_delay, hw, hh)
    add(enemies, {
        x=x,
        y=y,
        health=health,
        shoot_delay=shoot_delay,
        hw=hw, --hitbox width
        hh=hh, --hitbox height
        ani={3,5},
        anis=10,
        age=0,
        last_shoot_frame=0,
        flash_frames=0
    })
end

function update_enemies()
    for e in all(enemies) do
        -- Update anim
        e.age+=1

        --[[
        -- Shooting
        if T - e.last_shoot_frame > e.shoot_delay then
            e.last_shoot_frame = T
            _add_enemy_bullet(e.x, e.y + 8, 0, 1, 3, 3)
        end
        --]]

        -- Move left
        e.x -= .5

        -- Collisions
        for b in all(player_bullets) do
            local collided = false
            collided = hit(
                b.x - b.hw/2,
                b.y - b.hh/2,
                b.hw,
                b.hh,
                e.x-e.hw/2,
                e.y-e.hh/2,
                e.hw,
                e.hh,
                b.x - b.hw/2 + b.spdx,
                b.y - b.hh/2 + b.spdy
            )
            if collided then
                del(player_bullets, b)
                e.health -= 1
                e.flash_frames = 6
                sfx(1)
            end
        end

        if e.flash_frames > 0 then
            e.flash_frames -= 1
        end

        -- Death
        if e.health <= 0 then
            del(enemies, e)
            score = score + 1
            sfx(2)
        end

        -- Delete offscreen left
        if e.x < -20 then
            del(enemies, e)
        end
    end
end

function draw_enemies()
    for e in all(enemies) do
        -- Enable flash frames
        if e.flash_frames > 0 then
            for i=1,15 do
                pal(i, 8)
            end
        end

        draw_sprite_anim(e)

        -- Undo flash frames for next drawn items
        if e.flash_frames > 0 then
            pal()
        end

        -- draw hitbox for debugging
        if debug then
            rect(e.x-e.hw/2, e.y-e.hh/2, e.x+e.hw/2, e.y+e.hh/2, 7)
            pset(e.x, e.y, 8)
        end
    end
end