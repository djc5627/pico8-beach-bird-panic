player_bullets = {}

function add_player_bullet(x, y, spdx, spdy, hw, hh)
    add(player_bullets, {
        x=x,
        y=y,
        spdx=spdx,
        spdy=spdy,
        hw=hw, --hitbox width
        hh=hh, --hitbox height
        ani={4}, --sprite anim keys
        anis=1, --anim speed
        age=0 --Add random offset based on frame
    })
end

function update_bullets(table)
    for s in all(table) do
        s.x += s.spdx
        s.y += s.spdy

        -- Update anim
        s.age+=1

        if s.y<-16 or s.y > 136 then
            del(table,s)
        end
        -- todo delete in the x
    end
end

function draw_bullets(table)
    for b in all(table) do
        _draw_sprite_anim(b)
        if debug then
            pset(b.x, b.y, 8)
            rect(b.x-b.hw/2, b.y-b.hh/2, b.x+b.hw/2, b.y+b.hh/2, 7)
        end
    end
end