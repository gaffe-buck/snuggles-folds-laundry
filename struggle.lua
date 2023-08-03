ARROW_UP_Y = -16
ARROW_DOWN_Y = 24
ARROWS = {"⬅️", "⬆️", "➡️", "⬇️"}

function make_struggle()
    local struggle = {}
    struggle.new = _struggle_new
    struggle.update = _struggle_update
    struggle.draw = _struggle_draw
    struggle.arrows = {}
    struggle.empty_callback = nil

    struggle.active = false

    return struggle
end

function _struggle_new(struggle, num_arrows, callback)
    struggle.arrows = {}
    struggle.empty_callback = callback
    local width = 14 * num_arrows
    local base_x = 64 - width/2 + 4

    for a = 1, num_arrows do
        local x = base_x + ((a - 1) * 14)
        add(struggle.arrows, make_arrow(a, x, rnd(ARROWS)))
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
        printh("penalty!! "..#struggle.arrows)
    end
    if #struggle.arrows == 0 and struggle.empty_callback then
        struggle.empty_callback()
        struggle.empty_callback = nil
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
        callback = function() arrow.tween = nil end
    })

    return arrow
end

function _arrow_press(arrow)
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