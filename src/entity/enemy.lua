enemies = {}
brains = {
    { -- 1) Walk left enemy
        "HED", 0.25, 0.5, 0
    },
    { -- 2) Launch enemy
        "HED", 0.25, 0.5, 0,
        "WAIT", 30, 0, 0,
        "FOLPY", 0.5, 0, 9999,
        "HED", 0.25, 2, 0
    }
}

function add_walk_enemy(health, shoot_delay, hw, hh)
    add(enemies, {
        x=128,
        y=108,
        health=health,
        shoot_delay=shoot_delay,
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
        last_shoot_frame=0,
        flash_frames=0
    })
end

function add_launch_enemy(health, shoot_delay, hw, hh)
    add(enemies, {
        x=128,
        y=-10,
        health=health,
        shoot_delay=shoot_delay,
        hw=hw, --hitbox width
        hh=hh, --hitbox height
        spd=1,
        ang=0,
        sx=0,
        sy=0,
        ani={9},
        anis=10,
        age=0,
        brain = 2, -- index of brain to use
        bri = 1, -- index of brain instruction to use
        wait = 0, -- wait counter for brain instructions
        cmd = nil, -- current command being executed
        cmd_arg1 = 0, -- command args cached
        cmd_arg2 = 0,
        last_shoot_frame=0,
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
        elseif e.wait > 0 then
            e.wait -= 1
        else
            do_brain(e, 0)
        end

        -- Move Enemy
        e.sx = sin(e.ang) * e.spd
        e.sy = cos(e.ang) * e.spd

        e.x += e.sx
        e.y += e.sy

        -- Update anim
        e.age+=1


        --[[
        -- Shooting
        if T - e.last_shoot_frame > e.shoot_delay then
            e.last_shoot_frame = T
            add_enemy_bullet(e.x, e.y + 8,
            -1.4, -0.6, 3, 3)
        end
        --]]

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

function execute_cmd(e, cmd, arg1, arg2)
    if cmd == "HED" then
        e.ang = arg1
        e.spd = arg2
        return true
    elseif cmd == "FOLPY" then
        e.spd = arg1
        if p_y < e.y then
            e.ang = 0.5 -- Move up
        else
            e.ang = 0 -- Move down
        end
        
        -- Self-interrupt: if player is within 3 units, stop
        if abs(p_y - e.y) < 3 then
            return false  -- Interrupt, move to next command
        end
        return true  -- Continue executing
    end
    return true
end

function do_brain(e, depth)
    if depth > 100 then
        print("Infinite loop detected in enemy brain!")
        return
    end

    local myBrain = brains[e.brain]
    if e.bri < #myBrain then
        local cmd = myBrain[e.bri]
        local arg1 = myBrain[e.bri + 1]
        local arg2 = myBrain[e.bri + 2]
        local duration = myBrain[e.bri + 3] or 0

        -- Cache command for repeated execution
        e.cmd = cmd
        e.cmd_arg1 = arg1
        e.cmd_arg2 = arg2

        if cmd == "WAIT" then
            -- WAIT instruction: set wait time
            e.wait = arg1
        elseif duration > 0 then
            e.wait = duration
        end

        e.bri += 4 -- Move to the next 4-element instruction

        if e.wait == 0 then
            depth = depth + 1
            execute_cmd(e, cmd, arg1, arg2)
            do_brain(e, depth) -- Immediately process the next instruction if not waiting
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

        -- draw hitbox for debugging
        if debug then
            rect(e.x-e.hw/2, e.y-e.hh/2, e.x+e.hw/2, e.y+e.hh/2, 7)
            pset(e.x, e.y, 8)
        end
    end
end