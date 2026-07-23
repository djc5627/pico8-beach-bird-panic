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
        add_enemy(
            128,
            103,
            3,
            180,
            7,
            7
        )
        last_enemy_spawn_time = time()
    end
end