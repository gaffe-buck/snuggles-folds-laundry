title_scene = {
    init = function ()
        color_wipe = make_color_wipe({
            bars = 7,
            duration = 0.6,
            colors = { 8, 9, 10, 11, 12, 1, 2 }
        })
    end,
    
    update = function(self)
        color_wipe:update()

        if btnp(❎) and not self.x_pressed then
            self.x_pressed = true
            local function callback()
                self.x_pressed = false
                scene = game_scene
                scene:init()
            end
            color_wipe:wipe_in(callback)
        end
    end,

    draw = function()
        cls(12)      
        sspr(96, 0, 32, 32, 
            16, 32, 96, 96)

        fancy_text({
            text = "snuggles",
            text_colors = { 3, 8, 9, 14, 11, 12 },
            background_color = 7,
            bubble_depth = 2,
            x = 18,
            y = 8,
            outline_color = 0,
            letter_width = 12,
            big = true
        })
    
        fancy_text({
            text = "tries to fold laundry",
            text_colors = { 0 },
            background_color = 7,
            x = 22,
            y = 26,
            bubble_depth = 1,
            wiggle = {
                amp = 1.75,
                speed = -0.75,
                offset = 0.125
            },
        })
    
        fancy_text({
            text = "gaffe 2023 - press ❎ to start",
            x = 6,
            y = 128 - 7,
            text_colors = { 10 },
            outline_color = 0
        })

        color_wipe:draw()
    end
}