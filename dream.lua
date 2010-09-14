-- ======================================================================================
-- File         : dream.lua
-- Author       : Wu Jie 
-- Last Change  : 09/14/2010 | 14:07:01 PM | Tuesday,September
-- Description  : 
-- ======================================================================================

-- this script use function closure explain the idea in Inception.
-- you can image a closure as dream, the variable surround the closure is the environment in the dream.

--/////////////////////////////////////////////////////////////////////////////
-- dreams
--/////////////////////////////////////////////////////////////////////////////

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function dream ( _time_span, _peoples )
    -- if we don't have enough people, we can't go deeper.
    if #_peoples <= 1 then return function() end end

    -- the first people will become host, people who become host can't go to next level.
    local time_span = _time_span * 10.0; 
    local host = table.remove( _peoples, 1 )
    host.ready = true

    -- now in dream closure.
    return function()
        -- fall asleep.
        host.wakeup = false
        local dream_world = nil

        -- DEBUG { 
        local people_names = ""
        for i=1,#_peoples do
            people_names = people_names .. _peoples[i].name .. ","
        end
        print( "{" .. people_names .. "} enter host " .. host.name .. "'s dream " )
        -- } DEBUG end 

        -- sleeping
        while not host.wakeup do
            -- print ( host.name .. " is dreaming..." )
            -- now we can create an nested dream world (first level dream is nest in real world)
            if not dream_world and host.ready then
                dream_world = coroutine.create( dream( time_span, _peoples ) )
            end
            if dream_world then coroutine.resume( dream_world ) end

            -- simulate dream world time span
            local t = os.clock()
            local tt = os.clock()
            while (os.clock() - t) < time_span do 
                if os.clock() - tt > 0.05 then
                    print ( host.name .. " is dreaming..." )
                    tt = os.clock()
                end
            end
            coroutine.yield()

            -- TODO: add your kick situation for this host so that he can wakeup.
        end
    end
end

--/////////////////////////////////////////////////////////////////////////////
-- the real world
--/////////////////////////////////////////////////////////////////////////////

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

human = {}
function human:new ( name ) 
    o = {}
    o.name = name
    o.wakeup = true
    o.ready = false
    return o
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

local cobb = human:new("cobb")
local mal = human:new("mal")
local landy = human:new("landy")

local level_1 = nil
while true do
    if not level_1 then
        level_1 = coroutine.create( dream ( 0.01, {cobb, mal, landy} ) )
    end
    coroutine.resume(level_1)
end
