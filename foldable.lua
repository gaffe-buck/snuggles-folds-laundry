FL_SCN_H = 56
FL_START_X = 36
FL_START_Y = -64
FL_END_Y = 36

FL_LT_SCN_X_OS = 0
FL_LT_SCN_Y_OS = 0
FL_LT_SCN_W = 21
FL_LT_SPR_X_OS = 0
FL_LT_SPR_Y_OS = 0
FL_LT_SPR_W = 3
FL_LT_SPR_H = 8

FL_T_SCN_X_OS = 21
FL_T_SCN_Y_OS = 0
FL_T_SCN_W = 21
FL_T_SCN_H = 21
FL_T_SPR_X_OS = 3
FL_T_SPR_Y_OS = 0
FL_T_SPR_W = 3
FL_T_SPR_H = 3

FL_RT_SCN_X_OS,  
FL_RT_SCN_Y_OS,
FL_RT_SCN_W,
FL_RT_SPR_X_OS,
FL_RT_SPR_Y_OS,
FL_RT_SPR_W,
FL_RT_SPR_H =
42, 0, 14, 6, 0, 2, 8

FL_B_SCN_X_OS,FL_B_SCN_Y_OS,
FL_B_SCN_W,
FL_B_SCN_H,
FL_B_SPR_X_OS,
FL_B_SPR_Y_OS,
FL_B_SPR_W,
FL_B_SPR_H
= 21, 42, 21, 14, 3, 6, 3, 2

FL_CENTER_SCN_X_OS, 
FL_CENTER_SCN_Y_OS, 
FL_CENTER_SCN_W, 
FL_CENTER_SCN_H, 
FL_CENTER_SPR_X_OS, 
FL_CENTER_SPR_Y_OS, 
FL_CENTER_SPR_W, 
FL_CENTER_SPR_H
= 21, 21, 21, 21, 3, 3, 3, 3

FL_LOGO_X_OS, FL_LOGO_Y_OS 
= 21, 23

FL_SIDE_LT,
FL_SIDE_RT,
FL_SIDE_T, 
FL_SIDE_B, 
FL_SIDE_CENTER = 
"LT", "RT", "T", "B", "CENTER"

FL_RANDOMIZER = LAUNDRY.make_randomizer()

function make_foldable()
    local article = FL_RANDOMIZER:get_random_article()
    local foldable = {}
    foldable.update, 
    foldable.draw,   
    foldable.show,   
    foldable.hide,   
    foldable.fold 
    =
    _foldable_update,
    _foldable_draw,
    _foldable_show,
    _foldable_hide,
    _foldable_fold

    foldable.article = article
    foldable.x = FL_START_X
    foldable.y = FL_START_Y
    foldable.unfolded = {
        FL_SIDE_LT,
        FL_SIDE_RT,
        FL_SIDE_T,
        FL_SIDE_B
    }
    foldable.folds = {
        [FL_SIDE_LT] = 0,
        [FL_SIDE_RT] = 0,
        [FL_SIDE_T] = 0,
        [FL_SIDE_B] = 0,
        [FL_SIDE_CENTER] = 0
    }
    -- foldable.translation_tween = nil
    foldable.fold_tweens = {}

    return foldable
end

function _foldable_update(foldable)
    if foldable.translation_tween then
        local alive = foldable.translation_tween:update()
        if not alive then foldable.translation_tween = nil end
    end
    if #foldable.fold_tweens > 0 then
        foldable.fold_tweens[1]:update()
    end
end

function _foldable_fold(foldable, callback)
    if #foldable.unfolded < 1 then return end
    local fold_tween = {}
    fold_tween.side = foldable.unfolded[1]
    fold_tween.tween = make_simple_tween({
        duration = seconds_to_frames(0.12),
        easing = EASING_FUNCTIONS.EASE_OUT_IN_QUAD,
        callback = function()
            if callback then callback() end
            del(foldable.fold_tweens, fold_tween) 
        end
    })
    fold_tween.update = function(self)
        local progress = self.tween:update()
        foldable.folds[self.side] = progress

        return progress
    end
    del(foldable.unfolded, foldable.unfolded[1])
    add(foldable.fold_tweens, fold_tween)
end

function _foldable_show(foldable, callback)
    local tween_config = {
        target = foldable,
        duration = seconds_to_frames(0.5),
        easing = EASING_FUNCTIONS.EASE_OUT_BOUNCE,
        start_y = FL_START_Y,
        end_y = FL_END_Y,
        callback = callback
    }

    foldable.translation_tween = make_translation_tween(tween_config)
end

function _foldable_hide(foldable, callback)
    local tween_config = {
        target = foldable,
        duration = seconds_to_frames(0.25),
        easing = EASING_FUNCTIONS.EASE_IN_OVERSHOOT,
        start_y = FL_END_Y,
        end_y = FL_START_Y,
        callback = callback
    }

    foldable.translation_tween = make_translation_tween(tween_config)
end

function _foldable_draw(foldable)
    _foldable_draw_outline(foldable)
    _foldable_draw_article(foldable)
end

function _foldable_draw_article(foldable)
    _set_article_palette(foldable.article)
    for side, folded in pairs(foldable.folds) do
        if folded == 1 then goto article_draw_continue end
        sspr(foldable.article.sprite.x + _foldable_get_sprite_x_offset(side), 
            foldable.article.sprite.y + _foldable_get_sprite_y_offset(side), 
            _foldable_get_sprite_width(side), 
            _foldable_get_sprite_height(side), 
            foldable.x + _foldable_get_screen_x_offset(side, folded),
            foldable.y + _foldable_get_screen_y_offset(side, folded), 
            _foldable_get_screen_width(side, folded),
            _foldable_get_screen_height(side, folded))
        ::article_draw_continue::
    end

    pal()
    if foldable.article.logo then
        sspr(foldable.article.logo.x, 
            foldable.article.logo.y,
            8, 8,
            foldable.x + FL_LOGO_X_OS,
            foldable.y + FL_LOGO_Y_OS, 
            16, 16)
    end
end

function _foldable_draw_outline(foldable)
    local outline_color = foldable.article.colors[1].color == LAUNDRY.COLORS.WHITE 
        and foldable.article.colors[2].color 
        or foldable.article.colors[1].color
    pal_all(outline_color)
    for i in all({{x = 1, y = 0},{x = -1, y = 0},{x = 0, y = 1},{x = 0, y = -1}}) do
        for side, folded in pairs(foldable.folds) do
            if folded == 1 then goto article_outline_continue end
            sspr(foldable.article.sprite.x + _foldable_get_sprite_x_offset(side), 
                foldable.article.sprite.y + _foldable_get_sprite_y_offset(side), 
                _foldable_get_sprite_width(side), 
                _foldable_get_sprite_height(side), 
                foldable.x + _foldable_get_screen_x_offset(side, folded) + i.x,
                foldable.y + _foldable_get_screen_y_offset(side, folded) + i.y, 
                _foldable_get_screen_width(side, folded),
                _foldable_get_screen_height(side, folded))
            ::article_outline_continue::
        end  
    end
    pal()
end

function _set_article_palette(article)
    pal()
    local pal_config = {}
    for color in all(article.colors) do
        pal_config[color.default] = color.color
    end
    pal(pal_config)
end

function _foldable_get_sprite_x_offset(side)
    if side == FL_SIDE_LT then
        return FL_LT_SPR_X_OS
    elseif side == FL_SIDE_RT then
        return FL_RT_SPR_X_OS
    elseif side == FL_SIDE_T then
        return FL_T_SPR_X_OS
    elseif side == FL_SIDE_B then
        return FL_B_SPR_X_OS
    elseif side == FL_SIDE_CENTER then
        return FL_CENTER_SPR_X_OS
    end
end

function _foldable_get_sprite_y_offset(side)
    if side == FL_SIDE_LT then
        return FL_LT_SPR_Y_OS
    elseif side == FL_SIDE_RT then
        return FL_RT_SPR_Y_OS
    elseif side == FL_SIDE_T then
        return FL_T_SPR_Y_OS
    elseif side == FL_SIDE_B then
        return FL_B_SPR_Y_OS
    elseif side == FL_SIDE_CENTER then
        return FL_CENTER_SPR_Y_OS
    end
end

function _foldable_get_sprite_width(side)
    if side == FL_SIDE_LT then
        return FL_LT_SPR_W
    elseif side == FL_SIDE_RT then
        return FL_RT_SPR_W
    elseif side == FL_SIDE_T then
        return FL_T_SPR_W
    elseif side == FL_SIDE_B then
        return FL_B_SPR_W
    elseif side == FL_SIDE_CENTER then
        return FL_CENTER_SPR_W
    end
end

function _foldable_get_sprite_height(side)
    if side == FL_SIDE_LT then
        return FL_LT_SPR_H
    elseif side == FL_SIDE_RT then
        return FL_RT_SPR_H
    elseif side == FL_SIDE_T then
        return FL_T_SPR_H
    elseif side == FL_SIDE_B then
        return FL_B_SPR_H
    elseif side == FL_SIDE_CENTER then
        return FL_CENTER_SPR_H
    end
end

function _foldable_get_screen_x_offset(side, folded)
    if side == FL_SIDE_LT then
        return ceil(_tween_calc(FL_LT_SCN_X_OS, FL_CENTER_SCN_X_OS, folded))
    elseif side == FL_SIDE_RT then
        return FL_RT_SCN_X_OS
    elseif side == FL_SIDE_T then
        return FL_T_SCN_X_OS
    elseif side == FL_SIDE_B then
        return FL_B_SCN_X_OS
    elseif side == FL_SIDE_CENTER then
        return FL_CENTER_SCN_X_OS
    end
end

function _foldable_get_screen_y_offset(side, folded)
    if side == FL_SIDE_LT then
        return FL_LT_SCN_Y_OS
    elseif side == FL_SIDE_RT then
        return FL_RT_SCN_Y_OS
    elseif side == FL_SIDE_T then
        return ceil(_tween_calc(FL_T_SCN_Y_OS, FL_CENTER_SCN_Y_OS, folded))
    elseif side == FL_SIDE_B then
        return FL_B_SCN_Y_OS
    elseif side == FL_SIDE_CENTER then
        return FL_CENTER_SCN_Y_OS
    end
end

function _foldable_get_screen_width(s, f)
    local m = (1 - f)
    return (s == FL_SIDE_LT and FL_LT_SCN_W * m)
        or (s == FL_SIDE_RT and FL_RT_SCN_W * (1 - f))
        or (s == FL_SIDE_T and FL_T_SCN_W)
        or (s == FL_SIDE_B and FL_B_SCN_W)
        or FL_CENTER_SCN_W
end

function _foldable_get_screen_height(side, folded)
    if side == FL_SIDE_LT then
        return FL_SCN_H
    elseif side == FL_SIDE_RT then
        return FL_SCN_H
    elseif side == FL_SIDE_T then
        return FL_T_SCN_H * (1 - folded)
    elseif side == FL_SIDE_B then
        return FL_B_SCN_H  * (1 - folded)
    elseif side == FL_SIDE_CENTER then
        return FL_CENTER_SCN_H
    end
end