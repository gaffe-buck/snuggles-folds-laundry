DRESSER_START_X = -32
DRESSER_END_X = 0
DRESSER_Y = 64 + 16

function make_dresser()
    local dresser = {}

    dresser.draw = _dresser_draw
    dresser.update = _dresser_update
    dresser.show = _dresser_show
    dresser.tween = nil

    dresser.x = DRESSER_START_X
    dresser.y = DRESSER_Y

    return dresser
end

function _dresser_show(dresser)
    local tween_config = {
        target = dresser,
        duration = seconds_to_frames(0.75),
        start_x = DRESSER_START_X,
        end_x = DRESSER_END_X,
        start_y = DRESSER_Y,
        easing = EASING_FUNCTIONS.EASE_OUT_ELASTIC
    }
    dresser.tween = make_translation_tween(tween_config)
end

function _dresser_update(dresser)
    if dresser.tween then
        dresser.tween:update()
    end
end

function _dresser_draw(dresser)
    for i in all({{x=1, y=0},{x=-1, y=0},{x=0, y=1},{x=0, y=-1}}) do
        pal_all(5)
        sspr( 
            88, 16, 
            8, 16,
            dresser.x + i.x, dresser.y + i.y,
            16, 32,
            true)
        sspr( 
            88, 16, 
            8, 16,
            dresser.x + 16 + i.x, dresser.y + i.y,
            16, 32,
            false)
    end
    pal()
    sspr( 
        88, 16, 
        8, 16,
        dresser.x, dresser.y,
        16, 32,
        true)
    sspr( 
        88, 16, 
        8, 16,
        dresser.x + 16, dresser.y,
        16, 32,
        false)

    -- draw folded thing here

    sspr( 
        88, 22, 
        8, 14,
        dresser.x, dresser.y + 12,
        16, 32-4,
        true)
    sspr( 
        88, 22, 
        8, 14,
        dresser.x + 16, dresser.y + 12,
        16, 32-4)
end
