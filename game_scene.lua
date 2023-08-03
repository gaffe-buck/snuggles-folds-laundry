LEVEL_BACKGROUND_COLOR = 15

-- max 9 arrows
LEVEL_DAYS = {
    { 
        num_foldables = 1, 
        num_arrows = 2,
        time_limit_seconds = 30
    }
}

function make_level(day)
    local level = {}
    level.update = _level_update
    level.draw = _level_draw

    level.day = day or 1
    level.stage = LEVEL_DAYS[level.day]
    level.status = "dryer's done!"
    level.foldables = _level_make_foldables(level, level.stage.num_foldables)
    level.struggle = make_struggle()

    level.attention_span = make_attention_span()
    level.basket = make_basket()
    level.dresser = make_dresser()
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
    
    function load_basket()
        level.basket:load(crumple_colors, then_skootch_basket_and_dresser)
    end
    function then_skootch_basket_and_dresser()
        level.dresser:show() 
        level.basket:skootch(then_basket_pop)
    end
    function then_basket_pop()
        level.status = "fold! fold! fold!"
        level.active_foldable = level.foldables[#level.foldables]
        level.basket:pop(then_show_foldable)
    end
    function then_show_foldable()
        level.active_foldable:show(then_show_arrows)
    end
    function then_show_arrows()
        level.struggle:new(level.stage.num_arrows, function() printh("struggle is emptied") end)
    end

    return load_basket
end

function _level_update(level)
    local arrow_press = nil
    if btnp(⬅️) then
        arrow_press = "⬅️"
    elseif btnp(➡️) then
        arrow_press = "➡️"
    elseif btnp(⬆️) then
        arrow_press = "⬆️"
    elseif btnp(⬇️) then
        arrow_press = "⬇️"
    end

    if level.active_foldable then level.active_foldable:update() end
    level.struggle:update(arrow_press)
    level.basket:update()
    level.dresser:update()
    level.attention_span:update()
    level.color_wipe:update()
end

function _level_draw(level)
    _level_draw_background()
    _level_draw_status(level)

    level.struggle:draw()

    if level.basket then level.basket:draw() end
    level.dresser:draw()

    if level.active_foldable then level.active_foldable:draw() end

    level.attention_span:draw()
    level.color_wipe:draw()
end

function _level_draw_status(level)
    fancy_text({
        text = "day " .. level.day .. ": " .. level.status,
        text_colors = {7},
        outline_color = 5,
        x = 2,
        y = 2,
    })
end

function _level_draw_background()
    cls(15)
    circfill(64, 64, 48, 7)
    fillp(FILLP_LOOSE_CHECKER)
    circfill(64, 64, 48, 15)
    fillp()
end