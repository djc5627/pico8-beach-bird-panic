player_bullets = {}
enemy_bullets = {}

function add_player_bullet(x, y, spdx, spdy, hw, hh)
    add(player_bullets, {
        x=x,
        y=y,
        spdx=spdx,
        spdy=spdy,
        rigidbody=true,
        hw=hw, --hitbox width
        hh=hh, --hitbox height
        ani={4}, --sprite anim keys
        anis=1, --anim speed
        age=0 --Add random offset based on frame
    })
end

function add_enemy_bullet(x, y, spdx, spdy, hw, hh)
    add(enemy_bullets, {
            x=x,
            y=y,
            spdx=spdx,
            spdy=spdy,
            rigidbody=false,
            hw=hw,
            hh=hh,
            ani={6},
            anis=1,
            age=0
        })
end

function update_bullets(table)
    for b in all(table) do
        move_bullet(b)

        -- Update anim
        b.age+=1*framerate_mult

        if b.y<-16 or b.y > 136 then
            del(table,b)
        end
        -- todo delete in the x
    end
end

function move_bullet(b)
    if b.rigidbody==false then
        b.x += b.spdx*framerate_mult
        b.y += b.spdy*framerate_mult
    else
        b.spdy += .05*framerate_mult -- gravity
        b.y += b.spdy*framerate_mult

        b.x += b.spdx*framerate_mult
    end
end

function draw_bullets(table)
    for b in all(table) do
        draw_sprite_anim(b)
        if debug then
            pset(b.x, b.y, 8)
            rect(b.x-b.hw/2, b.y-b.hh/2, b.x+b.hw/2, b.y+b.hh/2, 7)
        end
    end
end