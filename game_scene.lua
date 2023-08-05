LEVEL_BACKGROUND_COLOR = 15

-- max 9 arrows
LEVEL_DAYS = {
    { 
        num_foldables = 5, 
        num_arrows = 1,
        time_limit_seconds = 30,
        penalty_seconds = 5
    },
    {
        num_foldables = 8,
        num_arrows = 2,
        time_limit_seconds = 30,
        penalty_seconds = 5
    },
    {
        num_foldables = 12,
        num_arrows = 3,
        time_limit_seconds = 60,
        penalty_seconds = 5
    },
    {
        num_foldables = 17,
        num_arrows = 3,
        time_limit_seconds = 60,
        penalty_seconds = 2
    },
    {
        num_foldables = 20,
        num_arrows = 4,
        time_limit_seconds = 90,
        penalty_seconds = 1
    },
    {
        num_foldables = 24,
        num_arrows = 4,
        time_limit_seconds = 90,
        penalty_seconds = 1
    },
    {
        num_foldables = 27,
        num_arrows = 5,
        time_limit_seconds = 90,
        penalty_seconds = 0.5
    }
}

function make_level(day)
    local level = {}
    level.update = _level_update
    level.draw = _level_draw

    level.day = day or 1
    level.stage = LEVEL_DAYS[level.day]
    level.status = "dryer's done!"
    level.ready = false
    level.winner = false
    level.loser = false
    level.start_time = 0
    level.end_time = 0
    -- level.active_foldable = nil
    
    level.foldables = _level_make_foldables(level, level.stage.num_foldables)
    level.struggles = 0
    level.struggle = make_struggle(function() level.end_time -= level.stage.penalty_seconds end)
    level.attention_span = make_attention_span()
    level.basket = make_basket()
    level.dresser = make_dresser()
    level.color_wipe = make_rainbow_wipe()
    level.chair = make_chair()

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
        level.basket:skootch(function()
            level.start_time = t()
            level.end_time = t() + level.stage.time_limit_seconds 
            level.ready = true 
        end)
    end

    return load_basket
end

function _level_update(level)
    local arrow_press = false
    if level.ready then
        if btnp(⬅️) then
            arrow_press = "⬅️"
        elseif btnp(➡️) then
            arrow_press = "➡️"
        elseif btnp(⬆️) then
            arrow_press = "⬆️"
        elseif btnp(⬇️) then
            arrow_press = "⬇️"
        end
    end
    if level.winner and btnp(❎) then
        function then_load_next_level()
            local big_winner = LEVEL_DAYS[level.day + 1] == nil
            if big_winner then
                g_scene = make_title_scene()
            else
                g_scene = make_level(level.day + 1)
            end
        end
        level.color_wipe:wipe_in(then_load_next_level)
    elseif level.loser and btnp(❎) then
        level.color_wipe:wipe_in(function() 
            g_scene = make_title_scene()
        end)
    end
    if level.ready and not level.winner then
        local attention = ((level.end_time - t()) / level.stage.time_limit_seconds * 100)
        level.attention_span:set_attention(attention)
        if attention <= 0 then
            level.chair:drop()
            if level.active_foldable then level.active_foldable:hide() end
            level.loser = true
            level.ready = false
            level.status = "got distracted..."
        end
    end

    if level.active_foldable then
        level.active_foldable:update()
    elseif level.ready then
        _level_next_foldable(level)
    end

    level.struggle:update(arrow_press)
    level.chair:update()
    level.basket:update()
    level.dresser:update()
    level.attention_span:update()
    level.color_wipe:update()
end

function _level_next_foldable(level)
    if #level.foldables == 0 and level.ready then
        level.status = "you did it <3"
        level.ready = false
        level.winner = true
        level.status = "all done for today!"
        return
    end

    function then_show_foldable()
        level.active_foldable:show(then_show_arrows)
    end
    function then_show_arrows()
        level.struggle:new(level.stage.num_arrows, _level_struggle_success(level))
    end

    level.status = "fold! fold! fold!"
    level.struggles = 0
    level.active_foldable = level.foldables[#level.foldables]
    level.foldables[#level.foldables] = nil
    level.basket:pop(then_show_foldable)
end

function _level_struggle_success(level)
    function then_new_struggle()
        level.struggle:new(level.stage.num_arrows, _level_struggle_success(level))
    end
    function then_hide_foldable()
        level.active_foldable:hide(then_clear_active_foldable)
    end
    function then_clear_active_foldable()
        local color = level.active_foldable.article.colors[1].color == LAUNDRY.COLORS.WHITE 
            and level.active_foldable.article.colors[2].color 
            or level.active_foldable.article.colors[1].color
        level.dresser:put_away(color)
        level.active_foldable = nil
    end
    return function()
        level.struggles += 1
        if level.struggles < 4 then
            level.active_foldable:fold()
        else
            level.status = "great job!"
            level.active_foldable:fold(then_hide_foldable)
        end
    end
end

function _level_draw(level)
    _level_draw_background()
    _level_draw_status(level)

    level.struggle:draw()

    if level.basket then level.basket:draw() end
    level.dresser:draw()

    if level.active_foldable then level.active_foldable:draw() end

    level.attention_span:draw()
    
    level.chair:draw()

    if level.winner then
        local big_winner = LEVEL_DAYS[level.day + 1] == nil
        local big_text = big_winner and "you win!" or "yippee!!"
        local small_text = big_winner and "all clothes folded" or "today's load completed"
        fancy_text({
            text = big_text,
            text_colors = { 3, 8, 9, 14, 11, 12 },
            background_color = 7,
            bubble_depth = 2,
            x = 18,
            y = 64 - 16,
            outline_color = 0,
            letter_width = 12,
            big = true
        })
        fancy_text({
            text = small_text,
            text_colors = { 0 },
            background_color = 7,
            x = 22,
            y = 64,
            bubble_depth = 1,
            wiggle = {
                amp = 1.75,
                speed = -0.75,
                offset = 0.125
            },
        })
        fancy_text({
            text = "press ❎ to continue",
            text_colors = { 0 },
            background_color = 7,
            x = 22 + 8,
            y = 64 + 9,
            bubble_depth = 1,
        })
    elseif level.loser then
        local y = 24
        fancy_text({
            text = "the chair wins this time",
            text_colors = { 0 },
            background_color = 7,
            x = 12,
            y = y,
            bubble_depth = 1,
            wiggle = {
                amp = 1.75,
                speed = -0.75,
                offset = 0.125
            },
        })
        fancy_text({
            text = "press ❎ to restart",
            text_colors = { 0 },
            background_color = 7,
            x = 22 + 8,
            y = y + 9,
            bubble_depth = 1,
        })
    end

    level.color_wipe:draw()
end

function _level_draw_status(level)
    fancy_text({
        text = "day " .. level.day .. ": " .. level.status,
        text_colors = {7},
        outline_color = 5,
        x = 2,
        y = 119,
    })
end

function _level_draw_background()
    cls(15)
    circfill(64, 64, 48, 7)
    fillp(FILLP_LOOSE_CHECKER)
    circfill(64, 64, 48, 15)
    fillp()
end