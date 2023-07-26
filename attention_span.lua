-- util
ATTN_SPAN_EMPTY_FUNCTION = function() end

-- dimensions
ATTENTION_SPAN_X = 12
ATTENTION_SPAN_SHOWN_Y = 117
ATTENTION_SPAN_HIDDEN_Y = 128
ATTENTION_SPAN_BAR_MAX_WIDTH = 100
ATTENTION_SPAN_BAR_X_OFFSET = 1
ATTENTION_SPAN_BAR_Y_OFFSET = 6
ATTENTION_SPAN_BAR_HEIGHT = 2
ATTENTION_SPAN_BOX_HEIGHT = 9
ATTENTION_SPAN_BOX_WIDTH = 102

-- colors
ATTENTION_SPAN_BAR_COLOR = 8
ATTENTION_SPAN_EMPTY_BAR_COLOR = 13
ATTENTION_SPAN_BACKGROUND_COLOR = 6
ATTENTION_SPAN_TEXT_COLOR = 7

-- timing
ATTENTION_SPAN_SHOW_DURATION = 0.5
ATTENTION_SPAN_FILL_DURATION = 0.75

-- physics
ATTENTION_SPAN_DEAD_PIP_INITIAL_Y_VELOCITY = -1.5
ATTENTION_SPAN_DEAD_PIP_GRAVITY = 0.1

function _attention_span_update(self)
    if not self.hidden then
        local subtractor = t() > self.show_time and self.show_time or t()
        local difference = self.show_time - subtractor
        local completion = difference / ATTENTION_SPAN_SHOW_DURATION
        local complete_offset = ATTENTION_SPAN_HIDDEN_Y - ATTENTION_SPAN_SHOWN_Y
        self.y = ATTENTION_SPAN_SHOWN_Y + (complete_offset * completion)
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
    local bar_x = self.x + ATTENTION_SPAN_BAR_X_OFFSET
    local bar_y = self.y + ATTENTION_SPAN_BAR_Y_OFFSET
    rectfill(self.x, self.y, self.x + ATTENTION_SPAN_BOX_WIDTH, self.y + ATTENTION_SPAN_BOX_HEIGHT, ATTENTION_SPAN_BACKGROUND_COLOR)
    rectfill(self.x - 1, self.y + 1, self.x + ATTENTION_SPAN_BOX_WIDTH + 1, self.y + ATTENTION_SPAN_BOX_HEIGHT - 1, ATTENTION_SPAN_BACKGROUND_COLOR)
    fillp(▒)
    rectfill(bar_x, bar_y, bar_x + ATTENTION_SPAN_BAR_MAX_WIDTH, bar_y + ATTENTION_SPAN_BAR_HEIGHT, ATTENTION_SPAN_EMPTY_BAR_COLOR)
    fillp()
    if self.attention > 0 then
        rectfill(bar_x, bar_y, bar_x + self.attention, bar_y + ATTENTION_SPAN_BAR_HEIGHT, ATTENTION_SPAN_BAR_COLOR)
    end
    print("ATTENTION SPAN", self.x + 1, self.y, ATTENTION_SPAN_TEXT_COLOR)

    for dead_pip in all(self.dead_pips) do
        dead_pip:draw(self)
    end
end

function _attention_span_show(self, callback)
    self.show_callback = callback
    self.hidden = false
    self.show_time = t() + ATTENTION_SPAN_SHOW_DURATION
end

function _attention_span_activate(self)
    local delay = ATTENTION_SPAN_FILL_DURATION / 100
    for i = 1, 100 do
        add(self.pips, make_pip(1, delay * (i - 1)))
    end
end

function _attention_span_add_attention(self, amount)
    self.attention += amount
    if self.attention > 100 then self.attention = 100 end
    if self.attention < 0 then self.attention = 0 end
end

function _attention_span_remove_attention(self, amount)
    local old_attention = self.attention
    self.attention -= amount
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

function make_attention_span()
 local new_attention_span = {}

 new_attention_span.hidden = true
 new_attention_span.x = ATTENTION_SPAN_X
 new_attention_span.y = ATTENTION_SPAN_HIDDEN_Y
 new_attention_span.attention = 0

 new_attention_span.pips = {}
 new_attention_span.dead_pips = {}

 new_attention_span.update = _attention_span_update
 new_attention_span.draw = _attention_span_draw
 new_attention_span.show = _attention_span_show
 new_attention_span.activate = _attention_span_activate
 new_attention_span.add_attention = _attention_span_add_attention
 new_attention_span.remove_attention = _attention_span_remove_attention

 return new_attention_span
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
    self.velocity_y += ATTENTION_SPAN_DEAD_PIP_GRAVITY
    if self.y < 128 then
        return true
    else
        return false
    end
end

function _dead_pip_draw(self)
    line(self.x, self.y, self.x, self.y + ATTENTION_SPAN_BAR_HEIGHT, ATTENTION_SPAN_BAR_COLOR)
end

function make_dead_pip(attention_span, x)
    local new_dead_pip = {}

    new_dead_pip.velocity_y = ATTENTION_SPAN_DEAD_PIP_INITIAL_Y_VELOCITY
    new_dead_pip.x = attention_span.x + x + ATTENTION_SPAN_BAR_X_OFFSET
    new_dead_pip.y = attention_span.y + ATTENTION_SPAN_BAR_Y_OFFSET
    new_dead_pip.update = _dead_pip_update
    new_dead_pip.draw = _dead_pip_draw

    return new_dead_pip
end