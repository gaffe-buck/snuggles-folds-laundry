TEST_COOLDOWN = 1

function make_laundry_test_scene()
    local scene = {}
    scene.update = _test_update
    scene.draw = _test_draw
    scene.randomizer = LAUNDRY.make_randomizer()
    scene.foldables = {}
    scene.cooldown = t() + TEST_COOLDOWN

    local article = scene.randomizer:get_random_article()
    scene.foldable = make_foldable(article)
    
    return scene
end

function _test_update(scene)
    if btnp(❎) then
        local article = scene.randomizer:get_random_article()
        scene.foldable = make_foldable(article)
        scene.foldable:show()
    end
    if btnp(🅾️) then
        scene.foldable:hide()
    end
    if btnp(⬅️) then
        scene.foldable:fold(function() printh("did a fold!") end)
    end

    scene.foldable:update()
end

function _test_draw(scene)
    cls(15)
    circfill(64, 64, 48, 7)
    fillp(FILLP_LOOSE_CHECKER)
    circfill(64, 64, 48, 15)
    fillp()
    scene.foldable:draw()
end