function init_level_spawner()
    palms = {}
    next_palm_spawn_frame = T + palm_spawn_delay()
end

function palm_spawn_delay()
    -- triangular distribution feels less mechanical than uniform intervals
    return 120 + flr(rnd(150) + rnd(150))
end

function add_palm_tree()
    add(palms, {
        x = 144,
        y = 54,
        spd = .25
    })
end

function update_level_spawner()
    if T >= next_palm_spawn_frame then
        add_palm_tree()
        next_palm_spawn_frame = T + palm_spawn_delay()
    end

    for p in all(palms) do
        p.x -= p.spd
        if p.x < -48 then
            del(palms, p)
        end
    end
end

function draw_level_spawner()
    for p in all(palms) do
        draw_sprite(7, p.x, p.y)
    end
end