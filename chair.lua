function make_chair()
    local chair = {}
    chair.x = 64-32
    chair.y = -66
    chair.end_y = 49
    chair.tween = nil
    chair.update = function(self)
        if chair.tween then chair.tween:update() end
    end
    chair.draw = function()
        sspr(
            0,32,
            32,32,
            chair.x, chair.y,
            64,64
        )
    end
    chair.drop = function(self)
        chair.tween = make_translation_tween({
            target = chair,
            duration = seconds_to_frames(2),
            easing = EASING_FUNCTIONS.EASE_OUT_BOUNCE,
            start_x = chair.x,
            start_y = chair.y,
            end_y = chair.end_y,
            callback = function()
                self.tween = nil
            end
        })
    end

    return chair
end