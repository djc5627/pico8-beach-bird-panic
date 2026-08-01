enemies = {}
brains = {
    { -- 1) Walk left enemy
        "HED", 0.5, 0.5, 0,
        "LOS", 0.35, .005, -1,
        "HED", 0, 0, 0,
        "WAIT", 30, 0, 0,
        "SHOOT", 0.35, 1, 0,
        "WAIT", 60, 0, 0,
    },
    { -- 2) Launch enemy
        "FOLPY", 0.5, 0, -1,
        "ANIM", 2, 1, 0,
        "HED", 0.5, 2, -1
    },
    { -- 3) Parachute enemy
        "HED", 0.65, 0.5, 0,
        "LOS", 0.5, .005, -1,
        "SHOOT", 0.5, 1, 0,
        "WAIT", 60, 0, 0,
    }
}

function add_walk_enemy(health, hw, hh)
    add(enemies, {
        x=128,
        y=108,
        health=health,
        hw=hw, --hitbox width
        hh=hh, --hitbox height
        spd=1,
        ang=0,
        sx=0,
        sy=0,
        ani={3,5},
        anis=10,
        age=0,
        brain = 1, -- index of brain to use
        bri = 1, -- index of brain instruction to use
        wait = 0, -- wait counter for brain instructions
        cmd = nil, -- current command being executed
        cmd_arg1 = 0, -- command args cached
        cmd_arg2 = 0,
        flash_frames=0
    })
end

function add_parachute_enemy(health, hw, hh)
    add(enemies, {
        x=128,
        y=10,
        health=health,
        hw=hw, --hitbox width
        hh=hh, --hitbox height
        spd=1,
        ang=0,
        sx=0,
        sy=0,
        ani={11},
        anis=10,
        age=0,
        brain = 3, -- index of brain to use
        bri = 1, -- index of brain instruction to use
        wait = 0, -- wait counter for brain instructions
        cmd = nil, -- current command being executed
        cmd_arg1 = 0, -- command args cached
        cmd_arg2 = 0,
        flash_frames=0
    })
end

function add_launch_enemy(health, hw, hh)
    add(enemies, {
        x=116,
        y=-10,
        health=health,
        hw=hw, --hitbox width
        hh=hh, --hitbox height
        spd=1,
        ang=0,
        sx=0,
        sy=0,
        ani={9,10},
        anis=0,
        age=0,
        brain = 2, -- index of brain to use
        bri = 1, -- index of brain instruction to use
        wait = 0, -- wait counter for brain instructions
        cmd = nil, -- current command being executed
        cmd_arg1 = 0, -- command args cached
        cmd_arg2 = 0,
        flash_frames=0
    })
end

function update_enemies()
    for e in all(enemies) do
        -- Execute current command every frame
        local should_continue = execute_cmd(e, e.cmd, e.cmd_arg1, e.cmd_arg2)

        -- If command returns false (self-interrupt), force next instruction
        if should_continue == false then
            e.wait = 0
        end

        if e.wait > 0 then
            e.wait -= 1
        else
            do_brain(e, 0)
        end

        -- Move Enemy
        e.sx = cos(e.ang) * e.spd
        e.sy = sin(e.ang) * e.spd

        e.x += e.sx
        e.y += e.sy

        -- Update anim
        e.age+=1

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
            explode(e.x, e.y)
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
            toggle_sprite_transparency(true)
        end


        if debug then
            -- draw hitbox for debugging
            rect(e.x-e.hw/2, e.y-e.hh/2, e.x+e.hw/2, e.y+e.hh/2, 7)
            pset(e.x, e.y, 8)

            -- draw current command over enemy
            if e.cmd then
                print(e.cmd, e.x-4, e.y-12, 7)

                if e.cmd == "LOS" then
                    local dx = p_x - e.x
                    local dy = p_y - e.y
                    local angle_to_player = atan2(dx, dy)
                    line(e.x, e.y, e.x + cos(angle_to_player) * 20, e.y + sin(angle_to_player) * 20, 8)
                    line(e.x, e.y, e.x + cos(e.cmd_arg1) * 20, e.y + sin(e.cmd_arg1) * 20, 11)
                    -- Print angle to player below enemy
                    local within_range = abs(angle_to_player - e.cmd_arg1) < e.cmd_arg2
                    print(""..(within_range and "true" or "false"), e.x-4, e.y-20, 7)
                end

                -- if cmd is WAIT, print wait time below enemy
                if e.cmd == "WAIT" then
                    print(""..e.wait, e.x-4, e.y-20, 7)
                end
            end
        end
    end
end