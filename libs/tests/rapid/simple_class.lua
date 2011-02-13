-- ======================================================================================
-- File         : simple_class.lua
-- Author       : Wu Jie 
-- Last Change  : 02/13/2011 | 23:37:46 PM | Sunday,February
-- Description  : 
-- ======================================================================================

local print = print
require("ex.class")
module( "tests.rapid.simple_class", ex.class.class )

local foobar = "foobar"
m_member = "hello world"

function say ( self ) 
    print "hi"
end

function say2 ( self ) 
    print (self.m_member)
end

