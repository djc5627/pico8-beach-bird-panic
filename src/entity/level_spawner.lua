x_scroll = 0
x_scroll_speed = 0.33

function init_level_spawner()
    palms = {}
    next_palm_spawn_frame = T + palm_spawn_delay()
end

function palm_spawn_delay()
    -- TODO Simplify this
    -- triangular distribution feels less mechanical than uniform intervals
    return 120 + flr(rnd(150) + rnd(150))
end

function add_palm_tree()
    add(palms, {
        x = 144,
        y = 54,
    })
end

function update_level_spawner()
    if T >= next_palm_spawn_frame then
        add_palm_tree()
        next_palm_spawn_frame = T + palm_spawn_delay()
    end

    for p in all(palms) do
        p.x -= x_scroll_speed
        if p.x < -48 then
            del(palms, p)
        end
    end

    x_scroll -= x_scroll_speed
end

function draw_level_spawner()
    -- Sand ground
    fillp_local(0b1011111010111111, x_scroll, 0)
    rectfill(0, 110, 127, 127, 154)

    fillp_local(0b1001111111111111, x_scroll, 0)
    rectfill(0, 110, 127, 112, 169)
    fillp()

    for p in all(palms) do
        draw_sprite(7, p.x, p.y)
    end
end

-- Method to scroll fillp patterns horizontally and vertically
function fillp_local(p,x,y)
  x &= 3
  local p16 = p&0xffff
  local mask, p32 = split"30583,13107,4369"[x] or -1, p16+(p16>>>16) >>< y*4+x
  fillp(p32&mask  |  p32<<>4 & 0xffff-mask  |  p-p16)
end