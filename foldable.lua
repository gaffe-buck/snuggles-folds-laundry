FOLDABLE_SCREEN_HEIGHT = 56
FOLDABLE_START_X = 36
FOLDABLE_START_Y = -64
FOLDABLE_END_Y = 36

FOLDABLE_LEFT_SCREEN_X_OFFSET = 0
FOLDABLE_LEFT_SCREEN_Y_OFFSET = 0
FOLDABLE_LEFT_SCREEN_WIDTH = 21
FOLDABLE_LEFT_SPRITE_X_OFFSET = 0
FOLDABLE_LEFT_SPRITE_Y_OFFSET = 0
FOLDABLE_LEFT_SPRITE_WIDTH = 3
FOLDABLE_LEFT_SPRITE_HEIGHT = 8

FOLDABLE_TOP_SCREEN_X_OFFSET = 21
FOLDABLE_TOP_SCREEN_Y_OFFSET = 0
FOLDABLE_TOP_SCREEN_WIDTH = 21
FOLDABLE_TOP_SCREEN_HEIGHT = 21
FOLDABLE_TOP_SPRITE_X_OFFSET = 3
FOLDABLE_TOP_SPRITE_Y_OFFSET = 0
FOLDABLE_TOP_SPRITE_WIDTH = 3
FOLDABLE_TOP_SPRITE_HEIGHT = 3

FOLDABLE_RIGHT_SCREEN_X_OFFSET = 42
FOLDABLE_RIGHT_SCREEN_Y_OFFSET = 0
FOLDABLE_RIGHT_SCREEN_WIDTH = 14
FOLDABLE_RIGHT_SPRITE_X_OFFSET = 6
FOLDABLE_RIGHT_SPRITE_Y_OFFSET = 0
FOLDABLE_RIGHT_SPRITE_WIDTH = 2
FOLDABLE_RIGHT_SPRITE_HEIGHT = 8

FOLDABLE_BOTTOM_SCREEN_X_OFFSET = 21
FOLDABLE_BOTTOM_SCREEN_Y_OFFSET = 42
FOLDABLE_BOTTOM_SCREEN_WIDTH = 21
FOLDABLE_BOTTOM_SCREEN_HEIGHT = 14
FOLDABLE_BOTTOM_SPRITE_X_OFFSET = 3
FOLDABLE_BOTTOM_SPRITE_Y_OFFSET = 6
FOLDABLE_BOTTOM_SPRITE_WIDTH = 3
FOLDABLE_BOTTOM_SPRITE_HEIGHT = 2

FOLDABLE_CENTER_SCREEN_X_OFFSET = 21
FOLDABLE_CENTER_SCREEN_Y_OFFSET = 21
FOLDABLE_CENTER_SCREEN_WIDTH = 21
FOLDABLE_CENTER_SCREEN_HEIGHT = 21
FOLDABLE_CENTER_SPRITE_X_OFFSET = 3
FOLDABLE_CENTER_SPRITE_Y_OFFSET = 3
FOLDABLE_CENTER_SPRITE_WIDTH = 3
FOLDABLE_CENTER_SPRITE_HEIGHT = 3

FOLDABLE_LOGO_X_OFFSET = 21
FOLDABLE_LOGO_Y_OFFSET = 23

FOLDABLE_SIDE_LEFT = "LEFT"
FOLDABLE_SIDE_RIGHT = "RIGHT"
FOLDABLE_SIDE_TOP = "TOP"
FOLDABLE_SIDE_BOTTOM = "BOTTOM"
FOLDABLE_SIDE_CENTER = "CENTER"

function make_foldable(article)
    local foldable = {}
    foldable.update = _foldable_update
    foldable.draw = _foldable_draw
    foldable.show = _foldable_show
    foldable.hide = _foldable_hide
    foldable.fold = _foldable_fold

    foldable.article = article
    foldable.x = FOLDABLE_START_X
    foldable.y = FOLDABLE_START_Y
    foldable.unfolded = {
        FOLDABLE_SIDE_LEFT,
        FOLDABLE_SIDE_RIGHT,
        FOLDABLE_SIDE_TOP,
        FOLDABLE_SIDE_BOTTOM
    }
    foldable.folds = {
        [FOLDABLE_SIDE_LEFT] = 0,
        [FOLDABLE_SIDE_RIGHT] = 0,
        [FOLDABLE_SIDE_TOP] = 0,
        [FOLDABLE_SIDE_BOTTOM] = 0,
        [FOLDABLE_SIDE_CENTER] = 0
    }
    foldable.translation_tween = nil
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

function _foldable_fold(foldable)
    if #foldable.unfolded < 1 then return end
    local fold_tween = {}
    fold_tween.side = foldable.unfolded[1]
    fold_tween.tween = make_simple_tween({
        duration = seconds_to_frames(0.12),
        easing = EASING_FUNCTIONS.EASE_OUT_IN_QUAD,
        callback = function() del(foldable.fold_tweens, fold_tween) end
    })
    fold_tween.update = function(self)
        local progress = self.tween:update()
        foldable.folds[self.side] = progress

        return progress
    end
    del(foldable.unfolded, foldable.unfolded[1])
    add(foldable.fold_tweens, fold_tween)
end

function _foldable_show(foldable)
    local tween_config = {
        target = foldable,
        duration = seconds_to_frames(0.5),
        easing = EASING_FUNCTIONS.EASE_OUT_BOUNCE,
        start_y = FOLDABLE_START_Y,
        end_y = FOLDABLE_END_Y,
        -- callback!
    }

    foldable.translation_tween = make_translation_tween(tween_config)
end

function _foldable_hide(foldable)
    local tween_config = {
        target = foldable,
        duration = seconds_to_frames(0.25),
        easing = EASING_FUNCTIONS.EASE_IN_OVERSHOOT,
        start_y = FOLDABLE_END_Y,
        end_y = FOLDABLE_START_Y,
        -- callback!
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
            foldable.x + FOLDABLE_LOGO_X_OFFSET,
            foldable.y + FOLDABLE_LOGO_Y_OFFSET, 
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
    if side == FOLDABLE_SIDE_LEFT then
        return FOLDABLE_LEFT_SPRITE_X_OFFSET
    elseif side == FOLDABLE_SIDE_RIGHT then
        return FOLDABLE_RIGHT_SPRITE_X_OFFSET
    elseif side == FOLDABLE_SIDE_TOP then
        return FOLDABLE_TOP_SPRITE_X_OFFSET
    elseif side == FOLDABLE_SIDE_BOTTOM then
        return FOLDABLE_BOTTOM_SPRITE_X_OFFSET
    elseif side == FOLDABLE_SIDE_CENTER then
        return FOLDABLE_CENTER_SPRITE_X_OFFSET
    end
end

function _foldable_get_sprite_y_offset(side)
    if side == FOLDABLE_SIDE_LEFT then
        return FOLDABLE_LEFT_SPRITE_Y_OFFSET
    elseif side == FOLDABLE_SIDE_RIGHT then
        return FOLDABLE_RIGHT_SPRITE_Y_OFFSET
    elseif side == FOLDABLE_SIDE_TOP then
        return FOLDABLE_TOP_SPRITE_Y_OFFSET
    elseif side == FOLDABLE_SIDE_BOTTOM then
        return FOLDABLE_BOTTOM_SPRITE_Y_OFFSET
    elseif side == FOLDABLE_SIDE_CENTER then
        return FOLDABLE_CENTER_SPRITE_Y_OFFSET
    end
end

function _foldable_get_sprite_width(side)
    if side == FOLDABLE_SIDE_LEFT then
        return FOLDABLE_LEFT_SPRITE_WIDTH
    elseif side == FOLDABLE_SIDE_RIGHT then
        return FOLDABLE_RIGHT_SPRITE_WIDTH
    elseif side == FOLDABLE_SIDE_TOP then
        return FOLDABLE_TOP_SPRITE_WIDTH
    elseif side == FOLDABLE_SIDE_BOTTOM then
        return FOLDABLE_BOTTOM_SPRITE_WIDTH
    elseif side == FOLDABLE_SIDE_CENTER then
        return FOLDABLE_CENTER_SPRITE_WIDTH
    end
end

function _foldable_get_sprite_height(side)
    if side == FOLDABLE_SIDE_LEFT then
        return FOLDABLE_LEFT_SPRITE_HEIGHT
    elseif side == FOLDABLE_SIDE_RIGHT then
        return FOLDABLE_RIGHT_SPRITE_HEIGHT
    elseif side == FOLDABLE_SIDE_TOP then
        return FOLDABLE_TOP_SPRITE_HEIGHT
    elseif side == FOLDABLE_SIDE_BOTTOM then
        return FOLDABLE_BOTTOM_SPRITE_HEIGHT
    elseif side == FOLDABLE_SIDE_CENTER then
        return FOLDABLE_CENTER_SPRITE_HEIGHT
    end
end

function _foldable_get_screen_x_offset(side, folded)
    if side == FOLDABLE_SIDE_LEFT then
        return ceil(_tween_calc(FOLDABLE_LEFT_SCREEN_X_OFFSET, FOLDABLE_CENTER_SCREEN_X_OFFSET, folded))
    elseif side == FOLDABLE_SIDE_RIGHT then
        return FOLDABLE_RIGHT_SCREEN_X_OFFSET
    elseif side == FOLDABLE_SIDE_TOP then
        return FOLDABLE_TOP_SCREEN_X_OFFSET
    elseif side == FOLDABLE_SIDE_BOTTOM then
        return FOLDABLE_BOTTOM_SCREEN_X_OFFSET
    elseif side == FOLDABLE_SIDE_CENTER then
        return FOLDABLE_CENTER_SCREEN_X_OFFSET
    end
end

function _foldable_get_screen_y_offset(side, folded)
    if side == FOLDABLE_SIDE_LEFT then
        return FOLDABLE_LEFT_SCREEN_Y_OFFSET
    elseif side == FOLDABLE_SIDE_RIGHT then
        return FOLDABLE_RIGHT_SCREEN_Y_OFFSET
    elseif side == FOLDABLE_SIDE_TOP then
        return ceil(_tween_calc(FOLDABLE_TOP_SCREEN_Y_OFFSET, FOLDABLE_CENTER_SCREEN_Y_OFFSET, folded))
    elseif side == FOLDABLE_SIDE_BOTTOM then
        return FOLDABLE_BOTTOM_SCREEN_Y_OFFSET
    elseif side == FOLDABLE_SIDE_CENTER then
        return FOLDABLE_CENTER_SCREEN_Y_OFFSET
    end
end

function _foldable_get_screen_width(side, folded)
    if side == FOLDABLE_SIDE_LEFT then
        return FOLDABLE_LEFT_SCREEN_WIDTH * (1 - folded)
    elseif side == FOLDABLE_SIDE_RIGHT then
        return FOLDABLE_RIGHT_SCREEN_WIDTH * (1 - folded)
    elseif side == FOLDABLE_SIDE_TOP then
        return FOLDABLE_TOP_SCREEN_WIDTH
    elseif side == FOLDABLE_SIDE_BOTTOM then
        return FOLDABLE_BOTTOM_SCREEN_WIDTH
    elseif side == FOLDABLE_SIDE_CENTER then
        return FOLDABLE_CENTER_SCREEN_WIDTH
    end
end

function _foldable_get_screen_height(side, folded)
    if side == FOLDABLE_SIDE_LEFT then
        return FOLDABLE_SCREEN_HEIGHT
    elseif side == FOLDABLE_SIDE_RIGHT then
        return FOLDABLE_SCREEN_HEIGHT
    elseif side == FOLDABLE_SIDE_TOP then
        return FOLDABLE_TOP_SCREEN_HEIGHT * (1 - folded)
    elseif side == FOLDABLE_SIDE_BOTTOM then
        return FOLDABLE_BOTTOM_SCREEN_HEIGHT  * (1 - folded)
    elseif side == FOLDABLE_SIDE_CENTER then
        return FOLDABLE_CENTER_SCREEN_HEIGHT
    end
end