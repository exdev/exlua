-- ======================================================================================
-- File         : ease.lua
-- Author       : Wu Jie 
-- Last Change  : 11/02/2010 | 17:08:24 PM | Tuesday,November
-- Description  : 
-- ======================================================================================

--/////////////////////////////////////////////////////////////////////////////
--
--/////////////////////////////////////////////////////////////////////////////

local assert, type = assert, type
local math = math

module("ex.ease")

--/////////////////////////////////////////////////////////////////////////////
-- functions
--/////////////////////////////////////////////////////////////////////////////

-- ------------------------------------------------------------------ 
-- quad
--  Easing equation function for a quadratic (_t^2)
--  param _t: Current time (in frames or seconds).
--  return: The correct value.
-- ------------------------------------------------------------------ 

function quad_in (_t) return _t^2 end
function quad_out (_t) return -_t * (_t - 2) end
function quad_inout (_t) 
    _t = _t * 2
    if ( _t < 1 ) then 
        return _t^2/2
    else
        _t = _t - 1
        return -0.5 * (_t*(_t-2) - 1)
    end
end
function quad_outin (_t) 
    if (_t < 0.5) then return quad_out(_t*2)/2 end
    return quad_in(2*_t-1)/2 + 0.5
end

-- ------------------------------------------------------------------ 
-- cubic 
--  Easing equation function for a cubic (_t^3)
--  param _t: Current time (in frames or seconds).
--  return: The correct value.
-- ------------------------------------------------------------------ 

function cubic_in (_t) return _t^3 end
function cubic_out (_t) _t -= 1; return _t^3 + 1 end 
function cubic_inout (_t) 
    _t = _t * 2
    if (_t < 1) then
        return _t^3 / 2
    else
        _t = _t - 2
        return (_t^3 + 2)/2
    end
end 
function cubic_outin (_t) 
    if ( _t < 0.5 ) then return cubic_out(2*_t)/2 end
    return cubic_in(2*_t-1)/2 + 0.5
end

-- ------------------------------------------------------------------ 
-- quart 
--  Purpose: 
--  Easing equation function for a quartic (_t^4)
--  param _t: Current time (in frames or seconds).
--  return: The correct value.
-- ------------------------------------------------------------------ 

function quart_in (_t) return _t^4 end
function quart_out (_t) _t = _t - 1; return -(_t^4 - 1) end
function quart_inout (_t) 
    _t = _t * 2
    if (_t < 1) then 
        return _t^4 * 0.5
    else
        _t = _t - 2
        return (_t^4 - 2)/-2
    end
end
function quart_outin (_t) 
    if (_t < 0.5) then return quart_out(2*_t)/2 end
    return quart_in(2*_t-1)/2 + 0.5
end

-- ------------------------------------------------------------------ 
-- quint
--  Easing equation function for a quintic (_t^5)
--  param _t: Current time (in frames or seconds).
--  return: The correct value.
-- ------------------------------------------------------------------ 

function quint_in (_t) return _t^5 end
function quint_out (_t) _t = _t - 1; return _t^5 + 1 end
function quint_inout (_t)
    _t = _t * 2
    if (_t < 1) then 
        return _t^5 / 2
    else
        _t = _t - 2
        return (_t^5 + 2)/2
    end
end
function quint_outin (_t)
    if (_t < 0.5) then return quint_out (2*_t)/2 end
    return quint_in(2*_t - 1)/2 + 0.5
end

-- ------------------------------------------------------------------ 
-- sine
--  Easing equation function for a sinusoidal (sin(_t))
--  param _t: Current time (in frames or seconds).
--  return: The correct value.
-- ------------------------------------------------------------------ 

function sine_in (_t) return (_t == 1) ? 1 : -math.cos(_t * math.pi/2) + 1 end
function sine_out (_t) return math.sin(_t * math.pi/2) end
function sine_inout (_t) (math.cos( math.pi.2 * _t ) - 1)/-2 end
function sine_outin (_t) 
    if (_t < 0.5) then return sine_out (2*_t)/2 end
    return sine_in(2*_t - 1)/2 + 0.5
end
