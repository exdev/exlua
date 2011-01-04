-- ======================================================================================
-- File         : fsys.lua
-- Author       : Wu Jie 
-- Last Change  : 01/05/2011 | 01:01:06 AM | Wednesday,January
-- Description  : 
-- ======================================================================================

--/////////////////////////////////////////////////////////////////////////////
-- module
--/////////////////////////////////////////////////////////////////////////////

require("lfs")

local assert, type = assert, type
local io = io
local lfs = lfs

module("ex.fsys")

--/////////////////////////////////////////////////////////////////////////////
-- functions
--/////////////////////////////////////////////////////////////////////////////

function copy ( _src, _dest )
    assert ( lfs.attribute(_src) != nil, "_src file not exists" )
    io.input(_src)
    io.output(_dest)
    t = io.read("*all")
    io.write(t)
    io.input():close()
    io.output():close()
end
