DRS_START_X = -32
DRS_END_X = 0
DRS_Y = 64 + 16
THG_X = 9
THG_START_Y = -8
THG_END_Y = 96

function make_dresser()
    local dresser = {}

    dresser.draw = _dresser_draw
    dresser.update = _dresser_update
    dresser.show = _dresser_show
    dresser.put_away = _dresser_put_away
    -- dresser.tween = nil
    -- dresser.folded_tween = nil
    
    dresser.x = DRS_START_X
    dresser.y = DRS_Y

    dresser.folded_thing = { 
        x = THG_X,
        y = THG_START_Y,
        width = 14,
        height = 3,
        color = 0
    }
    return dresser
end

function _dresser_put_away(dresser, color)
    dresser.folded_thing.color = color
    dresser.folded_tween = make_translation_tween({
        target = dresser.folded_thing,
        duration = seconds_to_frames(1),
        start_x = THG_X,
        start_y = THG_START_Y,
        end_y = THG_END_Y,
        easing = EASING_FUNCTIONS.EASE_IN_QUART
    })
end

function _dresser_show(dresser)
    local tween_config = {
        target = dresser,
        duration = seconds_to_frames(0.75),
        start_x = DRS_START_X,
        end_x = DRS_END_X,
        start_y = DRS_Y,
        easing = EASING_FUNCTIONS.EASE_OUT_ELASTIC
    }
    dresser.tween = make_translation_tween(tween_config)
end

function _dresser_update(dresser)
    if dresser.tween then
        dresser.tween:update()
    end
    if dresser.folded_tween then
        dresser.folded_tween:update()
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
    for i in all({{x=1, y=0},{x=-1, y=0},{x=0, y=1},{x=0, y=-1}}) do
        rectfill(
            dresser.folded_thing.x + i.x,
            dresser.folded_thing.y + i.y,
            dresser.folded_thing.x + i.x + dresser.folded_thing.width,
            dresser.folded_thing.y + i.y + dresser.folded_thing.height,
            5
        )
    end
    rectfill(
        dresser.folded_thing.x,
        dresser.folded_thing.y,
        dresser.folded_thing.x + dresser.folded_thing.width,
        dresser.folded_thing.y + dresser.folded_thing.height,
        dresser.folded_thing.color
    )

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
