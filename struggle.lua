ARROW_UP_Y = -16
ARROW_DOWN_Y = 24

function make_struggle(penalty_fn)
    local struggle = {}
    struggle.new = _struggle_new
    struggle.update = _struggle_update
    struggle.draw = _struggle_draw
    struggle.num_arrows = 0
    struggle.arrows = {}
    -- struggle.success_callback = nil
    struggle.penalty_fn = penalty_fn
    struggle.successes = 0

    struggle.active = false

    return struggle
end

function _struggle_new(struggle, num_arrows, callback)
    struggle.num_arrows = num_arrows
    struggle.successes = 0
    struggle.arrows = {}
    struggle.success_callback = callback
    local width = 14 * num_arrows
    local base_x = 64 - width/2 + 4

    for a = 1, num_arrows do
        local x = base_x + ((a - 1) * 14)
        add(struggle.arrows, make_arrow(a, x, rnd({"⬅️", "⬆️", "➡️", "⬇️"})))
    end
end

function _struggle_update(struggle, btn_press)
    local pressed_arrow = nil
    for arrow in all(struggle.arrows) do
        if not pressed_arrow and arrow.dir == btn_press and not arrow.pressed then
            pressed_arrow = arrow
            pressed_arrow:press()
        end
        arrow:update()
        if arrow.pressed and not arrow.tween then del(struggle.arrows, arrow) end
    end
    if btn_press and not pressed_arrow then
        sfx(SFX.ARROW_FAIL)
        struggle.penalty_fn()
    end

    local success_fraction = (struggle.num_arrows - #struggle.arrows) / struggle.num_arrows
    local new_successes = flr(success_fraction * 4)
    local difference = new_successes - struggle.successes
    struggle.successes = new_successes
    for i = 1, difference do
        if struggle.success_callback then struggle.success_callback() end
    end
end

function _struggle_draw(struggle)
    for arrow in all(struggle.arrows) do
        arrow:draw()
    end
end

function make_arrow(index, x, dir)
    local arrow = {}
    arrow.update = _arrow_update
    arrow.draw = _arrow_draw
    arrow.press = _arrow_press
    
    arrow.pressed = false
    arrow.dir = dir
    arrow.x = x
    arrow.y = ARROW_UP_Y
    arrow.tween = make_translation_tween({
        target = arrow,
        delay = flr(seconds_to_frames((index -1) * 0.033)),
        duration = flr(seconds_to_frames(0.066)),
        start_x = arrow.x,
        start_y = ARROW_UP_Y,
        end_y = ARROW_DOWN_Y,
        callback = function() 
            sfx(SFX.NEW_ARROW)
            arrow.tween = nil 
        end
    })

    return arrow
end

function _arrow_press(arrow)
    sfx(SFX.ARROW_SUCCESS)
    arrow.pressed = true
    arrow.tween = make_translation_tween({
        target = arrow,
        duration = flr(seconds_to_frames(0.066)),
        start_x = arrow.x,
        start_y = arrow.y,
        end_y = ARROW_UP_Y,
        callback = function() 
            arrow.tween = nil 
        end
    })
end

function _arrow_update(arrow)
    if arrow.tween then arrow.tween:update() end
end

function _arrow_draw(arrow)
    fancy_text({
        text = arrow.dir.." ",
        text_colors = {7},
        bubble_depth = 1,
        background_color = 14,
        x = arrow.x,
        y = arrow.y
    }) 
end