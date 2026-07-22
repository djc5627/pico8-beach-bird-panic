game_state = "playing"
debug = false
T=0     --global frame counter
function _init()
    init_player()
    init_enemy_spawner()
    score = 0
    parts={}
end

function _update60()
    T += 1
    if game_state == "playing" then
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

end