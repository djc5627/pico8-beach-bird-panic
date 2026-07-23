x_scroll = 0
x_scroll_speed = 0.33

function init_level_spawner()
    level_objs = {}
    next_palm_spawn_frame = T
    next_cloud_spawn_frame = T
end

function add_palm_tree()
    add(level_objs, {
        x = 144,
        y = 59,
        spi = 7
    })
end

function add_cloud()
    add(level_objs, {
        x = 144,
        y = rndrange(10,45),
        spi = 8
    })
end

function update_level_spawner()
    if T >= next_palm_spawn_frame then
        add_palm_tree()
        next_palm_spawn_frame = T + rndrange(120, 150)
    end
    if T >= next_cloud_spawn_frame then
        add_cloud()
        next_cloud_spawn_frame = T + rndrange(60, 120)
    end

    for p in all(level_objs) do
        p.x -= x_scroll_speed
        if p.x < -48 then
            del(level_objs, p)
        end
    end

    x_scroll -= x_scroll_speed
end

function draw_level_spawner()
    -- Sand ground
    fillp_local(0b1011111010111111, x_scroll, 0)
    rectfill(0, 115, 127, 128, 154)

    fillp_local(0b1111001111111111, x_scroll, 0)
    rectfill(0, 115, 127, 117, 169)
    fillp()

    for p in all(level_objs) do
        draw_sprite(p.spi, p.x, p.y)
    end
end

-- Method to scroll fillp patterns horizontally and vertically
function fillp_local(p,x,y)
  x &= 3
  local p16 = p&0xffff
  local mask, p32 = split"30583,13107,4369"[x] or -1, p16+(p16>>>16) >>< y*4+x
  fillp(p32&mask  |  p32<<>4 & 0xffff-mask  |  p-p16)
end