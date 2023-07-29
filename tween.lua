function make_translation_tween(config)
    local tween = {}
    assert(config.target, "no object to tween")
    assert(config.target.x, "object has no x prop")
    assert(config.target.y, "object has no y prop")
    assert(config.duration, "no duration specified")

    assert(config.duration > 1)

    tween.target = config.target
    tween.delay = config.delay or 0
    tween.duration = config.duration
    tween.start_x = config.start_x
    tween.start_y = config.start_y
    tween.end_x = config.end_x or config.start_x
    tween.end_y = config.end_y or config.start_y
    tween.easing = config.easing or EASING_FUNCTIONS.LINEAR
    tween.callback = config.callback
    
    tween.frames = 0
    tween.called_back = false

    tween.update = _tween_update
    
    return tween
end

function _tween_update(tween)
    if tween.frames > tween.delay + tween.duration then 
        if tween.callback and not tween.called_back then 
            tween.callback()
            tween.called_back = true
        end
        return false 
    end

    local absolute_progress = _tween_get_progress(tween)
    local eased_progress = tween.easing(absolute_progress)

    if tween.start_x then
        tween.target.x = _tween_calc(tween.start_x, tween.end_x, eased_progress)
    end
    if tween.start_y then
        tween.target.y = _tween_calc(tween.start_y, tween.end_y, eased_progress)
    end

    tween.frames += 1
    return true
end

function _tween_get_progress(tween)
    if tween.frames <= tween.delay then return 0 end
    if tween.frames > tween.delay + tween.duration then return 1 end

    local current = tween.frames - tween.delay
    local difference = tween.duration - current
    local progress = 1 - (difference / tween.duration)

    return progress
end

function _tween_calc(start, finish, progress)
    local difference = finish - start
    local completed = difference * progress
    
    return start + completed
end