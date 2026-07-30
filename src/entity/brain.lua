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
    elseif cmd == "LOS" then
        -- Line of Sight: if player is at certain angle interrupt
        local dx = p_x - e.x
        local dy = p_y - e.y
        local angle_to_player = atan2(dx, dy)
        if abs(angle_to_player - arg1) < arg2 then
            return false  -- Interrupt, move to next command
        end
        return true
    elseif cmd == "SHOOT" then
        -- Shoot bullet towards angle with given speed
        local spdx = cos(arg1) * arg2
        local spdy = sin(arg1) * arg2
        add_enemy_bullet(e.x, e.y, spdx, spdy, 3, 3)
    end
end


function do_brain(e, depth)
    if depth > 100 then
        print("Infinite loop detected in enemy brain!")
        return
    end

    local my_brain = brains[e.brain]
    if e.bri < #my_brain then
        local cmd = my_brain[e.bri]
        local arg1 = my_brain[e.bri + 1]
        local arg2 = my_brain[e.bri + 2]
        local duration = my_brain[e.bri + 3] or 0

        -- Cache command for repeated execution
        e.cmd = cmd
        e.cmd_arg1 = arg1
        e.cmd_arg2 = arg2

        if cmd == "WAIT" then
            -- WAIT instruction: set wait time
            e.wait = arg1
        elseif duration == -1 then
            -- Infinite duration: do not set wait time, keep executing
            e.wait = 32767
        elseif duration > 0 then
            e.wait = duration
        end

        e.bri += 4 -- Move to the next 4-element instruction

        if e.wait == 0 then
            depth = depth + 1
            execute_cmd(e, cmd, arg1, arg2)
            do_brain(e, depth) -- Immediately process the next instruction if not waiting
        end
    else
        -- If we've reached the end of the brain, loop back to the start
        e.bri = 1
    end
end