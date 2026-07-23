game_state = "playing"
debug = false
T=0     --global frame counter
function _init()
    init_player()
    init_level_spawner()
    init_enemy_spawner()
    score = 0
    parts={}

    -- Disables btnp auto-repeat globally
    -- Did this so held button doesn't auto-restart
    -- the game when game over
    poke(0x5f5c, -1)
end

function _update60()
    T += 1

    if game_state == "game_over" then
        if btnp(4) or btnp(5) then
            game_state = "playing"
            _init()
        end
    else
        update_player()
    end
    update_bullets(player_bullets)
    update_bullets(enemy_bullets)
    update_level_spawner()
    update_enemy_spawner()
    update_enemies()
    update_particles()
end

function _draw()
    cls()

    -- background
    rectfill(0, 0, 127, 127, 12)

    ----- Draw Sprites
    toggle_sprite_transparency(true)

    draw_level_spawner()

    if game_state == "playing" then
        draw_player()
    end

    draw_bullets(player_bullets)
    draw_bullets(enemy_bullets)
    draw_enemies()

    toggle_sprite_transparency(false)

    draw_particles()

    print("score: "..score, 8, 4, 7)

    if game_state == "game_over" then
        print("\^o05agame over", 45, 40, 7)
        print("\^o05apress o/x to restart", 25, 50, 7)
        return
    end
end

function toggle_sprite_transparency(enable)
    if enable then
        -- Set blue as transparent
        palt(0, false)
        palt(1, true)
    else
        -- Set black as transparent
        palt(0, true)
        palt(1, false)
    end
end