debug = false
T=0     --global frame counter
function _init()
    init_player()
end

function _update60()
    T += 1
    update_player()
    update_bullets(player_bullets)
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

    draw_player()
    draw_bullets(player_bullets)

    _draw_sprite(3, 50, 102)

    -- Set black as transparent
    palt(0, true)
    palt(1, false)
end