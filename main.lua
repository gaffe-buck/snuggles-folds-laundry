function _init()
    g_scene = make_level(10, 2) --make_title_scene()
end

function _update60()
    g_scene:update()
end

function _draw()
    g_scene:draw()
end