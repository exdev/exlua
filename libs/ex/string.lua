-- ======================================================================================
-- File         : string.lua
-- Author       : Wu Jie 
-- Last Change  : 01/05/2011 | 10:08:16 AM | Wednesday,January
-- Description  : 
-- ======================================================================================

--/////////////////////////////////////////////////////////////////////////////
-- module
--/////////////////////////////////////////////////////////////////////////////

local assert, type = assert, type
local string = string
local table = table

module("ex.string")

--/////////////////////////////////////////////////////////////////////////////
-- functions
--/////////////////////////////////////////////////////////////////////////////

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function lines (_str)
    local t = {}
    local function helper(line) table.insert(t, line) return "" end
    helper((_str:gsub("(.-)\r?\n", helper)))
    return t
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function split_words (_str)
    local t = {}
    local function helper(word) table.insert(t, word) return "" end
    if not _str:gsub("%w+", helper):find"%S" then return t end
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function split (_str, _pat)
    local t = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. _pat
    local last_end = 1
    local s, e, cap = _str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t,cap)
        end
        last_end = e+1
        s, e, cap = _str:find(fpat, last_end)
    end
    if last_end <= #_str then
        cap = _str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function split_path (_str)
    return split(_str,'[\\/]+')
end
