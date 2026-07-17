debug = false
function _init()
    _init_player()
end

function _update60()
    _update_player()
end

function _draw()
    cls()
    rectfill(0, 0, 127, 127, 12)
    rectfill(0, 110, 127, 127, 9)
    rectfill(0, 110, 127, 112, 10)
    _draw_player()
end