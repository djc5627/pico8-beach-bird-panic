game_state = "playing"
debug = false
T=0     --global frame counter
function _init()
    init_player()
    init_enemy_spawner()
    score = 0
    parts={}
    poke(0x5f5c, -1) -- Disables btnp auto-repeat globally
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
    update_enemy_spawner()
    update_enemies()
    update_particles()
end

function _draw()
    cls()
    -- background
    rectfill(0, 0, 127, 127, 12)
    rectfill(0, 110, 127, 127, 9)
    rectfill(0, 110, 127, 112, 10)

    ----- Draw Sprites
    -- Set blue as transparent
    palt(0, false)
    palt(1, true)

    if game_state == "playing" then
        draw_player()
    end
    draw_bullets(player_bullets)
    draw_bullets(enemy_bullets)
    draw_enemies()

    -- Set black as transparent
    palt(0, true)
    palt(1, false)

    draw_particles()

    print("score: "..score, 8, 4, 7)

    if game_state == "game_over" then
        print("\^o05agame over", 45, 40, 7)
        print("\^o05apress o/x to restart", 25, 50, 7)
        return
    end
end