function make_rainbow_wipe()
    local wipe = make_color_wipe({
        bars = 7,
        duration = 0.6,
        colors = { 8, 9, 10, 11, 12, 1, 2 }
    })

    return wipe
end