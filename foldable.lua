FOLDABLE_SCREEN_HEIGHT = 56

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

function make_foldable(article)
    local foldable = {}
    foldable.update = _foldable_update
    foldable.draw = _foldable_draw

    foldable.article = article
    foldable.x = 64 - (56/2)
    foldable.y = 64 - (56/2)

    return foldable
end

function _foldable_update(foldable)
    return
end

function _foldable_draw(foldable)
    circfill(64, 64, 48, 7)
    fillp(FILLP_LOOSE_CHECKER)
    circfill(64, 64, 48, 15)
    fillp()

    local outline_color = foldable.article.colors[1].color
    local outline_color = outline_color == LAUNDRY.COLORS.WHITE and foldable.article.colors[2].color or outline_color
    pal_all(outline_color)
    for i in all({{x = 1, y = 0},{x = -1, y = 0},{x = 0, y = 1},{x = 0, y = -1}}) do
        sspr(foldable.article.sprite.x + FOLDABLE_LEFT_SPRITE_X_OFFSET, 
            foldable.article.sprite.y + FOLDABLE_LEFT_SPRITE_Y_OFFSET, 
            FOLDABLE_LEFT_SPRITE_WIDTH, 
            FOLDABLE_LEFT_SPRITE_HEIGHT, 
            foldable.x + FOLDABLE_LEFT_SCREEN_X_OFFSET + i.x,
            foldable.y + FOLDABLE_LEFT_SCREEN_Y_OFFSET + i.y, 
            FOLDABLE_LEFT_SCREEN_WIDTH,
            FOLDABLE_SCREEN_HEIGHT)
        sspr(foldable.article.sprite.x + FOLDABLE_RIGHT_SPRITE_X_OFFSET, 
            foldable.article.sprite.y + FOLDABLE_RIGHT_SPRITE_Y_OFFSET, 
            FOLDABLE_RIGHT_SPRITE_WIDTH, 
            FOLDABLE_RIGHT_SPRITE_HEIGHT, 
            foldable.x + FOLDABLE_RIGHT_SCREEN_X_OFFSET + i.x,
            foldable.y + FOLDABLE_RIGHT_SCREEN_Y_OFFSET + i.y, 
            FOLDABLE_RIGHT_SCREEN_WIDTH,
            FOLDABLE_SCREEN_HEIGHT)
        sspr(foldable.article.sprite.x + FOLDABLE_TOP_SPRITE_X_OFFSET, 
            foldable.article.sprite.y + FOLDABLE_TOP_SPRITE_Y_OFFSET, 
            FOLDABLE_TOP_SPRITE_WIDTH, 
            FOLDABLE_TOP_SPRITE_HEIGHT, 
            foldable.x + FOLDABLE_TOP_SCREEN_X_OFFSET + i.x,
            foldable.y + FOLDABLE_TOP_SCREEN_Y_OFFSET + i.y, 
            FOLDABLE_TOP_SCREEN_WIDTH,
            FOLDABLE_TOP_SCREEN_HEIGHT)
        sspr(foldable.article.sprite.x + FOLDABLE_BOTTOM_SPRITE_X_OFFSET, 
            foldable.article.sprite.y + FOLDABLE_BOTTOM_SPRITE_Y_OFFSET, 
            FOLDABLE_BOTTOM_SPRITE_WIDTH, 
            FOLDABLE_BOTTOM_SPRITE_HEIGHT, 
            foldable.x + FOLDABLE_BOTTOM_SCREEN_X_OFFSET + i.x,
            foldable.y + FOLDABLE_BOTTOM_SCREEN_Y_OFFSET + i.y, 
            FOLDABLE_BOTTOM_SCREEN_WIDTH,
            FOLDABLE_BOTTOM_SCREEN_HEIGHT)
        sspr(foldable.article.sprite.x + FOLDABLE_CENTER_SPRITE_X_OFFSET, 
            foldable.article.sprite.y + FOLDABLE_CENTER_SPRITE_Y_OFFSET, 
            FOLDABLE_CENTER_SPRITE_WIDTH, 
            FOLDABLE_CENTER_SPRITE_HEIGHT, 
            foldable.x + FOLDABLE_CENTER_SCREEN_X_OFFSET + i.x,
            foldable.y + FOLDABLE_CENTER_SCREEN_Y_OFFSET + i.y, 
            FOLDABLE_CENTER_SCREEN_WIDTH,
            FOLDABLE_CENTER_SCREEN_HEIGHT)
    end

    _set_article_palette(foldable.article)
    sspr(foldable.article.sprite.x + FOLDABLE_LEFT_SPRITE_X_OFFSET, 
        foldable.article.sprite.y + FOLDABLE_LEFT_SPRITE_Y_OFFSET, 
        FOLDABLE_LEFT_SPRITE_WIDTH, 
        FOLDABLE_LEFT_SPRITE_HEIGHT, 
        foldable.x + FOLDABLE_LEFT_SCREEN_X_OFFSET,
        foldable.y + FOLDABLE_LEFT_SCREEN_Y_OFFSET, 
        FOLDABLE_LEFT_SCREEN_WIDTH,
        FOLDABLE_SCREEN_HEIGHT)
    sspr(foldable.article.sprite.x + FOLDABLE_TOP_SPRITE_X_OFFSET, 
        foldable.article.sprite.y + FOLDABLE_TOP_SPRITE_Y_OFFSET, 
        FOLDABLE_TOP_SPRITE_WIDTH, 
        FOLDABLE_TOP_SPRITE_HEIGHT, 
        foldable.x + FOLDABLE_TOP_SCREEN_X_OFFSET,
        foldable.y + FOLDABLE_TOP_SCREEN_Y_OFFSET, 
        FOLDABLE_TOP_SCREEN_WIDTH,
        FOLDABLE_TOP_SCREEN_HEIGHT)
    sspr(foldable.article.sprite.x + FOLDABLE_RIGHT_SPRITE_X_OFFSET, 
        foldable.article.sprite.y + FOLDABLE_RIGHT_SPRITE_Y_OFFSET, 
        FOLDABLE_RIGHT_SPRITE_WIDTH, 
        FOLDABLE_RIGHT_SPRITE_HEIGHT, 
        foldable.x + FOLDABLE_RIGHT_SCREEN_X_OFFSET,
        foldable.y + FOLDABLE_RIGHT_SCREEN_Y_OFFSET, 
        FOLDABLE_RIGHT_SCREEN_WIDTH,
        FOLDABLE_SCREEN_HEIGHT)
    sspr(foldable.article.sprite.x + FOLDABLE_BOTTOM_SPRITE_X_OFFSET, 
        foldable.article.sprite.y + FOLDABLE_BOTTOM_SPRITE_Y_OFFSET, 
        FOLDABLE_BOTTOM_SPRITE_WIDTH, 
        FOLDABLE_BOTTOM_SPRITE_HEIGHT, 
        foldable.x + FOLDABLE_BOTTOM_SCREEN_X_OFFSET,
        foldable.y + FOLDABLE_BOTTOM_SCREEN_Y_OFFSET, 
        FOLDABLE_BOTTOM_SCREEN_WIDTH,
        FOLDABLE_BOTTOM_SCREEN_HEIGHT)
    sspr(foldable.article.sprite.x + FOLDABLE_CENTER_SPRITE_X_OFFSET, 
        foldable.article.sprite.y + FOLDABLE_CENTER_SPRITE_Y_OFFSET, 
        FOLDABLE_CENTER_SPRITE_WIDTH, 
        FOLDABLE_CENTER_SPRITE_HEIGHT, 
        foldable.x + FOLDABLE_CENTER_SCREEN_X_OFFSET,
        foldable.y + FOLDABLE_CENTER_SCREEN_Y_OFFSET, 
        FOLDABLE_CENTER_SCREEN_WIDTH,
        FOLDABLE_CENTER_SCREEN_HEIGHT)

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

function _set_article_palette(article)
    pal()
    local pal_config = {}
    for color in all(article.colors) do
        pal_config[color.default] = color.color
    end
    pal(pal_config)
end