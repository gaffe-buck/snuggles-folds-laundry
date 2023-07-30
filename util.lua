FILLP_CHECKER = ▒
FILLP_LOOSE_CHECKER = ░
FILLP_HEARTS = ♥
FILLP_BIRDS = ˇ
FILLP_ZIG = ∧
FILLP_HORIZ = ▤
FILLP_VERT = ▥

function seconds_to_frames(seconds)
    return flr(seconds * 60)
end

function shallow_table_copy(t)
    local new_t = {}
    for k, v in pairs(t) do
        new_t[k] = v
    end

    return new_t
end

function pal_all(color)
    pal({
        [1] = color,
        [2] = color,
        [3] = color,
        [4] = color,
        [5] = color,
        [6] = color,
        [7] = color,
        [8] = color,
        [9] = color,
        [10] = color,
        [11] = color,
        [12] = color,
        [13] = color,
        [14] = color,
        [15] = color,
    }) 
end