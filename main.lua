function _init()
    g_scene = make_laundry_test_scene() --make_level(3, 1) --make_title_scene()
end

function _update60()
    g_scene:update()
end

function _draw()
    g_scene:draw()
end