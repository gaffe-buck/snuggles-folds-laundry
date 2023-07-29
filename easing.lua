EASING_FUNCTIONS = {
    LINEAR = function(t)
        return t
    end,

    --quadratics
    EASE_IN_QUAD = function(t)
        return t*t
    end,
    EASE_OUT_QUAD = function(t)
        t-=1
        return 1-t*t
    end,
    EASE_IN_OUT_QUAD = function(t)
        if(t<.5) then
            return t*t*2
        else
            t-=1
            return 1-t*t*2
        end
    end,
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
    EASE_OUT_QUART = function(t)
        t-=1
        return 1-t*t*t*t
    end,
    EASE_IN_OUT_QUART = function(t)
        if t<.5 then
            return 8*t*t*t*t
        else
            t-=1
            return (1-8*t*t*t*t)
        end
    end,
    EASE_OUT_IN_QUART = function(t)
        if t<.5 then
            t-=.5
            return .5-8*t*t*t*t
        else
            t-=.5
            return .5+8*t*t*t*t
        end
    end,

    --overshooting functions
    EASE_IN_OVERSHOOT = function(t)
        return 2.7*t*t*t-1.7*t*t
    end,
    EASE_OUT_OVERSHOOT = function(t)
        t-=1
        return 1+2.7*t*t*t+1.7*t*t
    end,
    EASE_IN_OUT_OVERSHOOT = function(t)
        if t<.5 then
            return (2.7*8*t*t*t-1.7*4*t*t)/2
        else
            t-=1
            return 1+(2.7*8*t*t*t+1.7*4*t*t)/2
        end
    end,
    EASE_OUT_IN_OVERSHOOT = function(t)
        if t<.5 then
            t-=.5
            return (2.7*8*t*t*t+1.7*4*t*t)/2+.5
        else
            t-=.5
            return (2.7*8*t*t*t-1.7*4*t*t)/2+.5
        end
    end,

    --elastics
    EASE_IN_ELASTIC = function(t)
        if(t==0) return 0
        return 2^(10*t-10)*cos(2*t-2)
    end,
    EASE_OUT_ELASTIC = function(t)
        if(t==1) return 1
        return 1-2^(-10*t)*cos(2*t)
    end,
    EASE_IN_OUT_ELASTED = function(t)
        if t<.5 then
            return 2^(10*2*t-10)*cos(2*2*t-2)/2
        else
            t-=.5
            return 1-2^(-10*2*t)*cos(2*2*t)/2
        end
    end,
    EASE_OUT_IN_ELASTIC = function(t)
        if t<.5 then
            return .5-2^(-10*2*t)*cos(2*2*t)/2
        else
            t-=.5
            return 2^(10*2*t-10)*cos(2*2*t-2)/2+.5
        end
    end,

    --bouncing
    EASE_IN_BOUNCE = function(t)
        t=1-t
        local n1=7.5625
        local d1=2.75
        
        if (t<1/d1) then
            return 1-n1*t*t;
        elseif(t<2/d1) then
            t-=1.5/d1
            return 1-n1*t*t-.75;
        elseif(t<2.5/d1) then
            t-=2.25/d1
            return 1-n1*t*t-.9375;
        else
            t-=2.625/d1
            return 1-n1*t*t-.984375;
        end
    end,
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