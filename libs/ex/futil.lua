-- ======================================================================================
-- File         : futil.lua
-- Author       : Wu Jie 
-- Last Change  : 01/05/2011 | 01:12:38 AM | Wednesday,January
-- Description  : 
-- ======================================================================================

--/////////////////////////////////////////////////////////////////////////////
-- module
--/////////////////////////////////////////////////////////////////////////////

require("lfs")

local assert, type = assert, type
local io = io
local string = string
local lfs = lfs

module("ex.futil")

--/////////////////////////////////////////////////////////////////////////////
-- functions
--/////////////////////////////////////////////////////////////////////////////

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

local copyfile = function ( _src, _dest )
    local destAttr = lfs.attributes(_dest)
    local dest = _dest
    if destAttr and destAttr.mode == "directory" then
        -- get file name
        local r_src = string.reverse(_src)
        local i = r_src:find("/")
        local fname = _src
        if i ~= nil then
            fname = _src:sub( #_src-i+2 )
        end
        dest = _dest .. "/" .. fname
    end

    io.input(_src)
    io.output(dest)
    t = io.read("*all")
    io.write(t)
    io.input():close()
    io.output():close()
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

local copydir = function ( _src, _dest )
    -- TODO:
    -- assert ( lfs.attributes(_src) ~= nil, "_src file not exists" )
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function cp ( _src, _dest )
    srcAttr = lfs.attributes(_src)
    assert ( srcAttr and srcAttr.mode == "file" , "_src file does not exists" )
    copyfile( _src, _dest )
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function cpdir ( _src, _dest )
    srcAttr = lfs.attributes(_src)
    assert ( srcAttr and srcAttr.mode == "directory" , "_src directory does not exists" )
    copydir( _src, _dest )
end
