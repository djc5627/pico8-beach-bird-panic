function init_enemy_spawner()
    e_spawn_rate = 2 -- seconds between spawns
    last_enemy_spawn_time = time()
    max_enemies = 10
    enemies = {}
    enemy_bullets = {}
end

function update_enemy_spawner()
    -- Check if it's time to spawn a new enemy
    if #enemies < max_enemies and
        time() - last_enemy_spawn_time >= e_spawn_rate then

        -- Randomly spawn enemy
        local enemy_type_count = 3
        local randd = flr(rndrange(1, enemy_type_count+1))
        if randd == 1 then
            add_walk_enemy(
                3,
                7,
                7
            )
        elseif randd == 2 then
            add_launch_enemy(
                3,
                7,
                7
            )
        else
            add_parachute_enemy(
                3,
                7,
                7
            )
        end
        last_enemy_spawn_time = time()
    end
end