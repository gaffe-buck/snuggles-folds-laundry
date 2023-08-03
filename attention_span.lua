-- util
ATTN_SPAN_EMPTY_FUNCTION = function() end

-- dimensions
AS_X = 12
AS_SHOWN_Y = 116
AS_HIDDEN_Y = 129
AS_BAR_MAX_W = 100
AS_BAR_X_OS = 1
AS_BAR_Y_OS = 6
AS_BAR_H = 2
AS_BOX_H = 9
AS_BOX_W = 102

-- colors
AS_BAR_CLR = 8
AS_EMPTY_BAR_CLR = 13
AS_BACKGROUND_CLR = 6
AS_TEXT_CLR = 5

-- timing
AS_SHOW_DUR = 0.5
AS_FILL_DUR = 0.75

-- physics
AS_DEAD_PIP_INIT_Y_V = -1.5
AS_DEAD_PIP_GRAV = 0.25

function make_attention_span()
    local as = {}

    as.hidden = true
    as.x = AS_X
    as.y = AS_HIDDEN_Y
    as.attention = 0

    as.pips = {}
    as.dead_pips = {}

    as.update = _attention_span_update
    as.draw = _attention_span_draw
    as.show = _attention_span_show
    as.activate = _attention_span_activate
    as.add_attention = _attention_span_add_attention
    as.set_attention = _attention_span_set_attention

    return as
end

function _attention_span_update(self)
    if not self.hidden then
        local subtractor = t() > self.show_time and self.show_time or t()
        local difference = self.show_time - subtractor
        local completion = difference / AS_SHOW_DUR
        local complete_offset = AS_HIDDEN_Y - AS_SHOWN_Y
        self.y = AS_SHOWN_Y + (complete_offset * completion)
        if completion == 0 then
            self:show_callback()
            self.show_callback = ATTN_SPAN_EMPTY_FUNCTION
        end
    end

    for pip in all(self.pips) do
        local alive = pip:update(self)
        if not alive then
            del(self.pips, pip)
        end
    end

    for dead_pip in all(self.dead_pips) do
        local alive = dead_pip:update(self)
        if not alive then
            del(self.dead_pips, dead_pip)
        end 
    end
end

function _attention_span_draw(self)
    local bar_x = self.x + AS_BAR_X_OS
    local bar_y = self.y + AS_BAR_Y_OS
    rectfill(self.x -1, self.y -1, self.x + AS_BOX_W + 1, self.y + AS_BOX_H + 1, AS_TEXT_CLR)
    rectfill(self.x -2, self.y, self.x + AS_BOX_W + 2, self.y + AS_BOX_H, AS_TEXT_CLR)

    rectfill(self.x, self.y, self.x + AS_BOX_W, self.y + AS_BOX_H, AS_BACKGROUND_CLR)
    rectfill(self.x - 1, self.y + 1, self.x + AS_BOX_W + 1, self.y + AS_BOX_H - 1, AS_BACKGROUND_CLR)
    fillp(▒)
    rectfill(bar_x, bar_y, bar_x + AS_BAR_MAX_W, bar_y + AS_BAR_H, AS_EMPTY_BAR_CLR)
    fillp()
    if self.attention > 0 then
        rectfill(bar_x, bar_y, bar_x + self.attention, bar_y + AS_BAR_H, AS_BAR_CLR)
    end
    print("ATTENTION SPAN", self.x + 1, self.y, AS_TEXT_CLR)

    for dead_pip in all(self.dead_pips) do
        dead_pip:draw(self)
    end
end

function _attention_span_show(self, callback)
    self.show_callback = callback
    self.hidden = false
    self.show_time = t() + AS_SHOW_DUR
end

function _attention_span_activate(self)
    local delay = AS_FILL_DUR / 100
    for i = 1, 100 do
        add(self.pips, make_pip(1, delay * (i - 1)))
    end
end

function _attention_span_add_attention(self, amount)
    self.attention += amount
    if self.attention > 100 then self.attention = 100 end
    if self.attention < 0 then self.attention = 0 end
end

function _attention_span_set_attention(self, amount)
    local old_attention = self.attention
    self.attention = amount
    self.attention = self.attention >= 0 and self.attention or 0
    local old_attention_int = flr(old_attention)
    local attention_int = flr(self.attention)
    if attention_int < old_attention_int then
        local dead_pip_count = old_attention_int - attention_int
        for i = 1, dead_pip_count do
            add(self.dead_pips, make_dead_pip(self, attention_int + i))
        end
    end
end

function _pip_update(self, attention_span)
    if t() > self.live_time then
        attention_span:add_attention(self.amount)
        return false
    else
        return true
    end
end

function make_pip(amount, delay)
    local new_pip = {}

    new_pip.live_time = t() + delay
    new_pip.amount = amount
    new_pip.update = _pip_update

    return new_pip
end

function _dead_pip_update(self)
    self.y += self.velocity_y
    self.velocity_y += AS_DEAD_PIP_GRAV
    if self.y < 128 then
        return true
    else
        return false
    end
end

function _dead_pip_draw(self)
    line(self.x, self.y, self.x, self.y + AS_BAR_H, AS_BAR_CLR)
end

function make_dead_pip(attention_span, x)
    local new_dead_pip = {}

    new_dead_pip.velocity_y = AS_DEAD_PIP_INIT_Y_V
    new_dead_pip.x = attention_span.x + x + AS_BAR_X_OS
    new_dead_pip.y = attention_span.y + AS_BAR_Y_OS
    new_dead_pip.update = _dead_pip_update
    new_dead_pip.draw = _dead_pip_draw

    return new_dead_pip
end