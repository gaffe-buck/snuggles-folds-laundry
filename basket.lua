BASKET_SHOW_START_X = 64-16
BASKET_SHOW_START_Y = 128+16
BASKET_SHOW_END_Y = 128-40 

function make_basket()
    local basket = {}
    basket.update = _basket_update
    basket.draw = _basket_draw
    basket.show = _basket_show

    basket.x = BASKET_SHOW_START_X
    basket.y = BASKET_SHOW_START_Y
    basket.tweens = {}
    
    return basket
end

function _basket_show(basket)
    local tween_config = {
        target = basket,
        delay = seconds_to_frames(1),
        duration = seconds_to_frames(0.5),
        start_x = BASKET_SHOW_START_X,
        start_y = BASKET_SHOW_START_Y,
        end_y = BASKET_SHOW_END_Y
    }

    local tween = make_translation_tween(tween_config)

    add(basket.tweens, tween)
end

function _basket_update(basket)
    _basket_update_tweens(basket)
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
end