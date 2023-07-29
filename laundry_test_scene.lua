function make_laundry_test_scene()
    local scene = {}
    scene.update = _test_update
    scene.draw = _test_draw
    scene.randomizer = LAUNDRY.make_randomizer()
    scene.things = {}
    add(scene.things, scene.randomizer:get_random_article())

    return scene
end

function _test_update(scene)
    if btnp(❎) then
        add(scene.things, scene.randomizer:get_random_article())
        if #scene.things > 6 then scene.things = { scene.things[#scene.things] } end
    end
end

function _test_draw(scene)
    cls(15)
    local y = 4
    for thing in all(scene.things) do
        local x = 4
        spr(thing.sprite.id, x, y)
        x += 12
        if thing.logo then
            spr(thing.logo.id, x, y)
            x += 12
        end
        for color in all(thing.colors) do
            rectfill(x, y, x + 8, y + 8, color.color)
            x += 12
        end
        y += 12
    end

    _test_draw_big(scene.things[#scene.things])

end

function _test_draw_big(thing)
    local pal_config = {}
    for color in all(thing.colors) do
        pal_config[color.default] = color.color
    end
    pal(pal_config)

    sspr(thing.sprite.x, thing.sprite.y, 
        8, 8, 
        70, 48, 
        56, 56)
    pal()

    if thing.logo then
        sspr(thing.logo.x, thing.logo.y,
            8, 8, 
            70 + 16 + 4, 48 + 18 + 6, 
            16, 16)
    end
end