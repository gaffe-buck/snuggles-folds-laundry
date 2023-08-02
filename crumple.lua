function make_crumple(basket, color, callback)
    local crumple = {}
    crumple.update = _crumple_update
    crumple.draw = _crumple_draw
    crumple.pop = _crumple_pop
    crumple.load_callback = callback
    
    crumple.basket = basket
    crumple.color = color
    crumple.y = 0
    crumple.base_x = #basket.crumples > 0 and 3 + (#basket.crumples * 4) % 26 or 3
    crumple.base_y = #basket.crumples > 0 and -(#basket.crumples) * 0.75 + rnd({0, 1, 2}) * rnd({-1, 1}) or 0
    crumple.x = crumple.base_x
    crumple.y = -8
    crumple.tween = make_translation_tween({
        target = crumple,
        duration = seconds_to_frames(0.1),
        start_x = basket.x + crumple.base_x,
        start_y = -8,
        end_y = basket.y + crumple.base_y,
        easing = EASING_FUNCTIONS.EASE_IN_QUART,
        callback = function()
            crumple.tween = nil
            crumple.load_callback()
        end
    })

    return crumple
end

function _crumple_pop(crumple, callback)
    crumple.tween = make_translation_tween({
        target = crumple,
        duration = seconds_to_frames(0.25),
        start_x = crumple.x,
        start_y = crumple.y,
        end_y = -8,
        easing = EASING_FUNCTIONS.EASE_OUT_QUART,
        callback = function()
            crumple.tween = nil
            callback()
        end
    })
end

function _crumple_update(crumple)
    if crumple.tween then
        crumple.tween:update()
    else
        crumple.x = crumple.basket.x + crumple.base_x
        crumple.y = crumple.basket.y + crumple.base_y
    end
end

function _crumple_draw(crumple)
    for i in all({{x=1, y=0},{x=-1, y=0},{x=0, y=1},{x=0, y=-1}}) do
        circfill(crumple.x + i.x, crumple.y + i.y, 4, 5)
    end
    circfill(crumple.x, crumple.y, 4, crumple.color)
end