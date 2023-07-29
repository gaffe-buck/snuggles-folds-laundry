LEVEL_BACKGROUND_COLOR = 15

function make_level(num_clothes, num_folds)
    local level = {}
    level.update = _level_update
    level.draw = _level_draw
    level.attention_span = make_attention_span()
    level.basket = make_basket()
    level.color_wipe = make_rainbow_wipe()

    level.color_wipe:wipe_out(make_level_wipe_out_callback(level))

    return level
end

function make_level_wipe_out_callback(level)
    local attention_span_show_callback = function()
        level.attention_span:activate()
    end

    return function()
        level.attention_span:show(attention_span_show_callback)
        level.basket:show()
    end
end

function _level_update(level)
    level.basket:update()
    level.attention_span:update()
    level.color_wipe:update()
end

function _level_draw(level)
    cls(LEVEL_BACKGROUND_COLOR)

    if level.basket then level.basket:draw() end
    level.attention_span:draw()
    level.color_wipe:draw()
end