-- ======================================================================================
-- File         : simple_test.lua
-- Author       : Wu Jie 
-- Last Change  : 09/12/2010 | 08:04:58 AM | Sunday,September
-- Description  : 
-- ======================================================================================

require("tests.rapid.simple_class")
require("ex.debug")

print ("--------------- start test ----------------")

obj = tests.rapid.simple_class()
obj:say()
obj:say2()
ex.debug.print_table( obj, "obj" )
