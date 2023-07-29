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