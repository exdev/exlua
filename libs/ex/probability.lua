-- ======================================================================================
-- File         : probability.lua
-- Author       : Wu Jie 
-- Last Change  : 02/09/2011 | 21:29:01 PM | Wednesday,February
-- Description  : 
-- ======================================================================================

--/////////////////////////////////////////////////////////////////////////////
--
--/////////////////////////////////////////////////////////////////////////////

local math = math
module(ex.probability)

--/////////////////////////////////////////////////////////////////////////////
--
--/////////////////////////////////////////////////////////////////////////////

-- ------------------------------------------------------------------ 
-- Desc: 
-- Usage: 
-- item = { "gold knife", "silver knife", "axe", "knife" }
-- gen_idx = cdf( {0.12, 0.3, 0.3, 0.9 } )
-- drop_item = item[gen_idx()]
-- ------------------------------------------------------------------ 

function gen_cdf( _weights )
    local sum = 0.0
    local cdf = {}

    for i=1,#_weights do 
        sum = sum + _weights[i] 
    end

    cdf[1] = _weights[1]/sum
    for i=2,#_weights-1 do
        cdf[i] = _weights[i]/sum
        cdf[i] = cdf[i] + cdf[i-1]
    end
    cdf[#_weights] = 1.0

    return function ()
        local y = math.random()
        for i=1,#cdf do
            if ( y < cdf[i] ) then 
                return i
            end
        end
        return -1
    end
end

