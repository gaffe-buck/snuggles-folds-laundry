ARM_SPRITES_HORIZ = { 54, 55 }
ARM_SPRITES_VERT = { 21, 37 }
PAW_SPRITES = { 
    [FL_SIDE_LT] = { sprite = 56, arms = ARM_SPRITES_HORIZ, flip_x = false, x_offset = -8, y_offset = 0, flip_y = false },
    [FL_SIDE_RT] = { sprite = 56, arms = ARM_SPRITES_HORIZ, flip_x = false, x_offset = 8,  y_offset = 0, flip_y = false },
    [FL_SIDE_T] = { sprite = 5,  arms = ARM_SPRITES_VERT, flip_x = false, x_offset = 0,   y_offset = -8, flip_x = false, flip_y = false },
    [FL_SIDE_B] = { sprite = 5,  arms = ARM_SPRITES_VERT, flip_x = false, x_offset = 0,   y_offset = 8, flip_x = false, flip_y = false },
}
PAW_BITS = {}
for i = 1, 10 do
    add(PAW_BITS, rnd({1,2}))
end

function make_paw()
    local paw = {}
    paw.update = _paw_update
    paw.draw = _paw_draw
    paw.swipe = _paw_bat
    -- dir
    -- paw.tween
    -- x
    -- y
    -- colors
    return paw
end

function _paw_bat(paw, dir)
    paw.dir = dir
    paw.x =
        (dir == FL_SIDE_LT and -8) or 
        (dir == FL_SIDE_RT and 128) or
        56
    paw.y = 
        (dir == FL_SIDE_T and -8) or 
        (dir == FL_SIDE_B and 128) or
        56
    paw.tween = make_translation_tween({
        target = paw,
        duration = seconds_to_frames(0.075),
        --easing = EASING_FUNCTIONS.EASE_IN_OVERSHOOT,
        start_x = paw.x,
        start_y = paw.y,
        end_x = 56,
        end_y = 56,
        callback = function() paw.tween = nil end
    })
end

function _paw_update(paw)
    if paw.tween then
        paw.tween:update()
    end
end

function _paw_draw(paw)
    if paw.tween then
        printh("paw.dir "..paw.dir)
        local paw_sprite = PAW_SPRITES[paw.dir]
        spr(paw_sprite.sprite, paw.x, paw.y, 1, 1, paw_sprite.flip_x, paw_sprite.flip_y)
        for i, arm in ipairs(PAW_BITS) do
            spr(
                paw_sprite.arms[arm],
                paw.x + (paw_sprite.x_offset * i),
                paw.y + (paw_sprite.y_offset * i),
                1,
                1,
                paw_sprite.flipx,
                paw_sprite.flipy
            )
        end
    end
end