BASKET_SHOW_START_X = 64-16
BASKET_SHOW_END_X = 128-34
BASKET_SHOW_START_Y = 0-18
BASKET_SHOW_END_Y = 128-32 
BASKET_SHOW_SKOOTCH_Y = 128-32

function make_basket()
    local basket = {}
    basket.update = _basket_update
    basket.draw = _basket_draw
    basket.show = _basket_show
    basket.skootch = _basket_skootch
    basket.load = _basket_load
    basket.pop = _basket_pop

    basket.x = BASKET_SHOW_START_X
    basket.y = BASKET_SHOW_START_Y
    basket.tweens = {}
    basket.crumples = {}
    
    return basket
end

function _basket_pop(basket, callback)
    if #basket.crumples > 0 then
        function _then_die_and_callback()
            basket.crumples[#basket.crumples] = nil
            callback()
        end
        basket.crumples[#basket.crumples]:pop(_then_die_and_callback)
    end
end

function _basket_load(basket, crumples, callback)
    function r_make_crumples(r_crumples)
        local this_crumple = crumples[1]
        del(r_crumples, this_crumple) 
        local this_callback = #r_crumples > 0
            and function() r_make_crumples(r_crumples) end
            or callback
        local new_crumple = make_crumple(basket, this_crumple, this_callback)
        add(basket.crumples, new_crumple)
    end

    r_make_crumples(crumples)
end

function _basket_show(basket, callback)
    local tween_config = {
        target = basket,
        duration = seconds_to_frames(1),
        easing = EASING_FUNCTIONS.EASE_OUT_BOUNCE,
        start_y = BASKET_SHOW_START_Y,
        end_y = BASKET_SHOW_END_Y,
        callback = callback
    }

    add(basket.tweens, make_translation_tween(tween_config))
end

function _basket_skootch(basket, callback)
    local tween_config = {
        target = basket,
        duration = seconds_to_frames(0.5),
        easing = EASING_FUNCTIONS.LINEAR,
        start_x = BASKET_SHOW_START_X,
        end_x = BASKET_SHOW_END_X,
        start_y = BASKET_SHOW_END_Y,
        end_y = BASKET_SHOW_SKOOTCH_Y,
        callback = callback
    }

    add(basket.tweens, make_translation_tween(tween_config))
end

function _basket_update(basket)
    _basket_update_tweens(basket)

    for crumple in all(basket.crumples) do
        crumple:update()
    end
end

function _basket_update_tweens(basket)
    local dead_tweens = {}
    for tween in all(basket.tweens) do
        local alive = tween:update()
        if not alive then add(dead_tweens, tween) end
    end
    for dead_tween in all(dead_tweens) do
        del(basket.tweens, dead_tween)
    end
end

function _basket_draw(basket)
    for i = #basket.crumples, 1, -1 do
        basket.crumples[i]:draw()
    end

    for i in all({{x=1, y=0},{x=-1, y=0},{x=0, y=1},{x=0, y=-1}}) do
        pal_all(5)
        sspr( 
            88, 8, 
            8, 8,
            basket.x + i.x, basket.y + i.y,
            16, 16,
            true)
        sspr( 
            88, 8, 
            8, 8,
            basket.x + 16 + i.x, basket.y + i.y,
            16, 16,
            false)
    end
    pal(0)
    sspr( 
        88, 8, 
        8, 8,
        basket.x, basket.y,
        16, 16,
        true)
    sspr( 
        88, 8, 
        8, 8,
        basket.x + 16, basket.y,
        16, 16,
        false)
    fancy_text({
        text = tostr(#basket.crumples),
        text_colors = {7},
        outline_color = 5,
        x = basket.x,
        y = basket.y + 10,
    })
end