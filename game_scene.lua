LEVEL_BACKGROUND_COLOR = 15

function make_level(num_foldables, difficulty)
    local level = {}

    level.foldables = _level_make_foldables(level, num_foldables)

    level.update = _level_update
    level.draw = _level_draw
    level.attention_span = make_attention_span()
    level.basket = make_basket()
    level.color_wipe = make_rainbow_wipe()

    level.color_wipe:wipe_out(_level_wipe_out_callback(level))

    return level
end


function _level_make_foldables(level, num_foldables)
    local foldables = {}
    
    for i = 1, num_foldables do
        add(foldables, make_foldable()) 
    end
    
    return foldables
end

function _level_wipe_out_callback(level)
    local then_attention_span_activate = function()
        level.attention_span:activate()
    end
    
    return function()
        level.attention_span:show(then_attention_span_activate)
        level.basket:show(_level_then_load_basket(level))
    end
end

function _level_then_load_basket(level)
    local crumple_colors = {}
    for foldable in all(level.foldables) do
        local color = foldable.article.colors[1].color == LAUNDRY.COLORS.WHITE 
        and foldable.article.colors[2].color 
        or foldable.article.colors[1].color
        add(crumple_colors, color)
    end
    function then_skootch_basket()
        level.basket:skootch(function() printh("skootched!") end)
    end
    return function()
        level.basket:load(crumple_colors, then_skootch_basket)
    end
end

function _level_update(level)
    -- debug!
    if btnp(❎) then
        level.basket:pop(function() printh("popped!") end)
    end

    level.basket:update()
    level.attention_span:update()
    level.color_wipe:update()
end

function _level_draw(level)
    _level_draw_background()

    if level.basket then level.basket:draw() end
    level.attention_span:draw()
    level.color_wipe:draw()
end

function _level_draw_background()
    cls(15)
    circfill(64, 64, 48, 7)
    fillp(FILLP_LOOSE_CHECKER)
    circfill(64, 64, 48, 15)
    fillp()
end