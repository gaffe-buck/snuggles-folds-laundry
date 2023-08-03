function _color_wipe_update(wipe)
    if not wipe.paused then
        if wipe.reverse then
            wipe.pct_complete = 1 - (t() - wipe.start_time) / wipe.duration
            if wipe.pct_complete < 0 then
                wipe.pct_complete = 0
                if wipe.out_callback then
                    wipe.out_callback()
                    wipe.out_callback = nil
                end
            end
        else
            wipe.pct_complete = (t() - wipe.start_time) / wipe.duration
            if wipe.pct_complete > 1 then
                wipe.pct_complete = 1
                if wipe.in_callback then
                    wipe.in_callback()
                    wipe.in_callback = nil
                end
            end
        end
    end
end

function _color_wipe_draw(wipe)
    if (wipe.pct_complete > 0) then
        local bar_h = flr(128 / wipe.bars)

        for i = 0, wipe.bars - 1 do
            local x1 = 0
            local x2 = 127 * wipe.pct_complete * (1 + (i * (1/wipe.bars)))
            local y2 = (i + 1) * bar_h
            if i == wipe.bars - 1 then y2 = 127 end
            if wipe.reverse then
                x1 = 127 - 127 * wipe.pct_complete * (1 + (i * (1/wipe.bars)))
                x2 = 127
            end

            rectfill(x1, i * bar_h, x2, y2, wipe.colors[i + 1]);
        end
    end
end

function _color_wipe_in(wipe, callback)
    wipe.in_callback = callback
    wipe.paused = false
    wipe.start_time = t()
    wipe.pct_complete = 0
    wipe.reverse = false
end

function _color_wipe_out(wipe, callback)
    wipe.out_callback = callback
    wipe.paused = false
    wipe.start_time = t()
    wipe.pct_complete = 1
    wipe.reverse = true
end

function make_color_wipe(config)
    local color_wipe = {}
    color_wipe.duration = config.duration or 1
    color_wipe.bars = config.bars or 1
    color_wipe.colors = config.colors or { 11 }
    color_wipe.start_time = nil
    color_wipe.pct_complete = 0
    color_wipe.paused = true
    color_wipe.update = _color_wipe_update
    color_wipe.draw = _color_wipe_draw
    color_wipe.wipe_in = _color_wipe_in
    color_wipe.wipe_out = _color_wipe_out

    return color_wipe
end