-- util
ATTN_SPAN_EMPTY_FUNCTION = function() end

-- dimensions
AS_X = 12
AS_SHOWN_Y = 2
AS_HIDDEN_Y = -20
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
    -- as.position_tween = nil
    -- as.attention_tween = nil

    as.update = _attention_span_update
    as.draw = _attention_span_draw
    as.show = _attention_span_show
    as.activate = _attention_span_activate
    as.set_attention = _attention_span_set_attention

    return as
end

function _attention_span_update(self)
    if self.position_tween then 
        self.position_tween:update() 
    end
    if self.attention_tween then
        self.attention = self.attention_tween:update() * 100
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
end

function _attention_span_show(self, callback)
    self.show_callback = callback
    self.position_tween = make_translation_tween({
        target = self,
        duration = seconds_to_frames(AS_SHOW_DUR),
        callback = callback,
        start_y = self.y,
        end_y = AS_SHOWN_Y,
        start_x = self.x
    })
end

function _attention_span_activate(self)
    self.attention_tween = make_simple_tween({
        duration = seconds_to_frames(0.75),
        easing = EASING_FUNCTIONS.EASE_OUT_BOUNCE,
        callback = function() 
            self.attention_tween = nil
        end
    })
end

function _attention_span_set_attention(self, amount)
    self.attention = amount
    self.attention = self.attention >= 0 and self.attention or 0
end