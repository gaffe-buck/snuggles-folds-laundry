EASING_FUNCTIONS = {
    LINEAR = function(t)
        return t
    end,
    --quadratics
    EASE_OUT_IN_QUAD = function(t)
        if t<.5 then
            t-=.5
            return .5-t*t*2
        else
            t-=.5
            return .5+t*t*2
        end
    end,
    --quartics
    EASE_IN_QUART = function(t)
        return t*t*t*t
    end,
    --overshooting functions
    EASE_IN_OVERSHOOT = function(t)
        return 2.7*t*t*t-1.7*t*t
    end,
    --elastics
    EASE_OUT_ELASTIC = function(t)
        if(t==1) return 1
        return 1-2^(-10*t)*cos(2*t)
    end,
    --bouncing
    EASE_OUT_BOUNCE = function(t)
        local n1=7.5625
        local d1=2.75
        
        if (t<1/d1) then
            return n1*t*t;
        elseif(t<2/d1) then
            t-=1.5/d1
            return n1*t*t+.75;
        elseif(t<2.5/d1) then
            t-=2.25/d1
            return n1*t*t+.9375;
        else
            t-=2.625/d1
            return n1*t*t+.984375;
        end
    end
}