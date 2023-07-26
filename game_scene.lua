game_scene = {
    init = function ()
        attention_span = make_attention_span()
        local wipe_out_callback = function()
            attention_span:show(attention_span.activate)
        end
        color_wipe:wipe_out(wipe_out_callback)
    end,
    
    update = function(self)
        attention_span:update()
        color_wipe:update()
    end,

    draw = function()
        cls(7)

        fancy_text({
            text = "game scene!",
            text_colors = { 8 },
            background_color = 7,
            bubble_depth = 2,
            x = 18,
            y = 8,
            outline_color = 0,
            letter_width = 9,
            big = true
        })

        attention_span:draw()
        color_wipe:draw()
    end
}