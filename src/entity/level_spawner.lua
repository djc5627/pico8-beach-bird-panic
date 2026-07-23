x_scroll_speed = 0.25
x_scroll_accum = 0

function init_level_spawner()
    level_objs = {}
    next_palm_spawn_frame = T
    next_cloud_spawn_frame = T
    x_scroll = 0
    x_scroll_accum = 0
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
        next_palm_spawn_frame = T + rndrange(150, 250)
    end
    if T >= next_cloud_spawn_frame then
        add_cloud()
        next_cloud_spawn_frame = T + rndrange(60, 120)
    end

    x_scroll_accum += x_scroll_speed

    -- Move all objects in unison
    local scroll_step = flr(x_scroll_accum)
    if scroll_step <= 0 then
        return
    end

    x_scroll_accum -= scroll_step
    x_scroll -= scroll_step
    for p in all(level_objs) do
        p.x -= scroll_step
        if p.x < -48 then
            del(level_objs, p)
        end
    end
end

function draw_level_spawner()
    local ground_x = x_scroll % 128
    local ground_x2 = ground_x - 128

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