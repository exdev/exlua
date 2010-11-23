-- ======================================================================================
-- File         : oo_test.lua
-- Author       : Wu Jie 
-- Last Change  : 11/23/2010 | 11:04:46 AM | Tuesday,November
-- Description  : 
-- ======================================================================================

--/////////////////////////////////////////////////////////////////////////////
-- requires
--/////////////////////////////////////////////////////////////////////////////

oo = require("loop.base")

--/////////////////////////////////////////////////////////////////////////////
--
--/////////////////////////////////////////////////////////////////////////////

local FooBar = nil
local obj_a = nil

-- ------------------------------------------------------------------ 
-- Desc: loop method 
-- ------------------------------------------------------------------ 

function FooBar_tostring(self)
    return self.x .. "," .. self.y .. "," .. self.z
end
FooBar = oo.class({x = 1, y = 2, z = 3, __tostring = FooBar_tostring})

obj_a = FooBar{ x = 10 }
print("oo method obj_a = " .. tostring(obj_a)) 

-- ------------------------------------------------------------------ 
-- Desc: my method 
-- ------------------------------------------------------------------ 

FooBar = { x = 1, y = 2, z = 3, __tostring = FooBar_tostring }
FooBar.__index = FooBar -- important!!!
-- FooBar = setmetatable ( FooBar, {} ) -- not necessary

obj_a = { x = 10 }
obj_a = setmetatable ( obj_a, FooBar )
print("my method obj_a = " .. tostring(obj_a)) 

