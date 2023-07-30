TEST_COOLDOWN = 1

function make_laundry_test_scene()
    local scene = {}
    scene.update = _test_update
    scene.draw = _test_draw
    scene.randomizer = LAUNDRY.make_randomizer()
    scene.foldables = {}
    scene.cooldown = t() + TEST_COOLDOWN
    local article = scene.randomizer:get_random_article()
    local foldable = make_foldable(article)
    add(scene.foldables, foldable)

    return scene
end

function _test_update(scene)
    if btnp(❎) then
        local article = scene.randomizer:get_random_article()
        local foldable = make_foldable(article)
        scene.foldables = { foldable }
    end

    -- if t() > scene.cooldown then
    --     _test_create_clothes(scene)
    -- end
    if #scene.foldables > 0 then
        for foldable in all(scene.foldables) do
            foldable:update()
        end
    end
end

function _test_draw(scene)
    cls(15)
    if #scene.foldables > 0 then
        for foldable in all(scene.foldables) do
            foldable:draw()
        end
    end
end