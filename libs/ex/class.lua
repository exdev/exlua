-- ======================================================================================
-- File         : class.lua
-- Author       : Wu Jie 
-- Last Change  : 02/10/2011 | 22:39:08 PM | Thursday,February
-- Description  : 
-- ======================================================================================

--/////////////////////////////////////////////////////////////////////////////
-- require and module
--/////////////////////////////////////////////////////////////////////////////

local getmetatable = getmetatable
local setmetatable = setmetatable
local require = require
local print = print
local assert = assert
local rawget = rawget
local rawset = rawset
local type = type
local pairs = pairs

module ("ex.class")

--/////////////////////////////////////////////////////////////////////////////
-- functions defines
--/////////////////////////////////////////////////////////////////////////////

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function deepcopy(_obj)
    local lookup_table = {}
    local function _copy(_obj)
        if type(_obj) ~= "table" then
            return _obj
        elseif lookup_table[_obj] then
            return lookup_table[_obj]
        end
        local new_table = {}
        lookup_table[_obj] = new_table
        for index, value in pairs(_obj) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(_obj))
    end
    return _copy(_obj)
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function isclass (_class)
    local mt = getmetatable(_class)
    if mt == class_meta then return true end
    return false
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function member_readonly ( _t, _k, _v )
    assert( false, "keys are readonly" )
end

function member_readonly_get ( _t, _k )
    print( "get value " .. _k )
    return rawget(_t,_k)
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function class_newindex ( _t, _k, _v )
    -- NOTE: the _t can only be object instance, 
    --       we can garantee this, case if it is a class, 
    --       it never use class_index as __index method. 
    --       it use class_meta.__index

    if _t.__readonly ~= nil and _t.__readonly then
        assert ( false, "the table is readonly" )
        return
    end

    -- check if the metatable have the key
    local mt = getmetatable(_t) 
    assert( mt, "can't find the metatable of _t" )
    v = rawget(mt,_k)
    if v ~= nil then 
        if type(v) ~= type(_v) then
            assert( false, "can't set the key ".._k..", the type is not the same" )
            return
        end
        rawset(_t,_k,_v)
        return
    end

    -- check if the super have the key
    local super = rawget(mt,"__super")
    while super ~= nil do
        -- get key from super's metatable
        v = rawget(super,_k)

        --
        if v ~= nil then 
            if type(v) ~= type(_v) then
                assert( false, "can't set the key ".._k..", the type is not the same" )
                return
            end
            rawset(_t,_k,_v)
            return
        end

        -- get super's super from super's metatable
        super = rawget(super,"__super")
    end

    -- 
    assert( false, "can't find the key " .. _k )
    return
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function class_index ( _t, _k )
    -- NOTE: the _t can only be object instance, 
    --       we can garantee this, case if it is a class, 
    --       it never use class_index as __index method. 
    --       it use class_meta.__index

    -- speical case
    if _k == "super" then
        local mt = getmetatable(_t) 
        assert( mt, "can't find the metatable of _t" )
        -- NOTE: in class_newindex, it will check if table have __readonly, and prevent setting things.
        return setmetatable( { __readonly = true }, rawget(mt,"__super") )
    end

    -- check if the metatable have the key
    local mt = getmetatable(_t) 
    assert( mt, "can't find the metatable of _t" )
    v = rawget(mt,_k)
    if v ~= nil then 
        local vv = v
        if type(vv) == "table" and isclass(vv) == false then
            vv = deepcopy(v)
        end
        rawset(_t,_k,vv)
        return vv
    end

    -- check if the super have the key
    local super = rawget(mt,"__super")
    while super ~= nil do
        -- get key from super's metatable
        v = rawget(super,_k)

        --
        if v ~= nil then 
            local vv = v
            if type(vv) == "table" and isclass(vv) == false then
                vv = deepcopy(v)
            end
            rawset(_t,_k,vv)
            return vv
        end

        -- get super's super from super's metatable
        super = rawget(super,"__super")
    end

    -- return
    return nil
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function class_new ( _self, ... )
    local table = ...
    return setmetatable( table or {}, _self )
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

class_meta = {
    __call = class_new,
}

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function class(...)
    local base,super = ...
    if super == nil then
        rawset(base, "__super", nil)
    else
        assert( isclass(super), "super is not a class" )
        rawset(base, "__super", super)
    end

    base.__index = class_index
    base.__newindex = class_newindex
    return setmetatable(base,class_meta)
end

--/////////////////////////////////////////////////////////////////////////////
-- unit tests
--/////////////////////////////////////////////////////////////////////////////

local do_unit_test = false
if do_unit_test == false then
    return
end

-- ======================================================== 
-- 
-- ======================================================== 

-- foo = class {
--     a = 2.0,
--     _b = 20.0, -- _b = 20.0, -- private equals to ex.hide|ex.no_serialize
--     c = "hello", -- ex.prop( "hello", ex.readonly ),
--     d = {1,2,3,4}, -- ex.prop( {1,2,3,4}, ex.shared ), -- or s_d ??? __d ???
--     e = 10, -- ex.prop( 10, ex.hide ),
--     f = 20, -- ex.prop( 20, ex.hide|ex.no_serialize ), -- equals to _b
-- }

-- foo -> bar -> foobar

foo = class {
    m_normal = 2.0,
    m_string = "hello",
    m_array = { "one", "two", "three", "four" },
    m_table = {
        a = "i'm a",
        b = "i'm b",
    },
    m_test_func = function( self ) 
        print ( "i'm test function" )
    end
}
bar = class ({
    -- override foo
    m_normal = 10.0,
    -- 
    m_normal2 = 2.0,
    m_string2 = "world",
    m_array2 = { 1, 2, 3, 4 },
    m_table2 = {
        a2 = "i'm a2",
        b2 = "i'm b2",
    },
    m_test_func2 = function( self ) 
        print ( "i'm test function 2" )
    end
}, foo)
foobar = class ({
    -- override foo
    m_normal = 100.0,
    m_array = { "five" },

    -- override bar
    m_string2 = "hello world",
    m_table2 = {
        a2 = "i'm a2 in foobar",
        b2 = "i'm b2 in foobar",
        c2 = "i'm c2 in foobar",
    },
    m_test_func2 = function( self ) 
        print ( "i'm test function 2 in foobar" )
    end,

    -- 
    m_test_func3 = function( self ) 
        print ( "i'm test function 3" )
    end
}, bar)

-- ======================================================== 
-- 
-- ======================================================== 

foo_obj = foo {
    m_normal = 1.0,
}
foo_obj.m_array = { "foo" }

bar_obj = bar {
    m_normal = 10.0,
}
print( bar_obj.super.m_array[2] )
print( bar_obj.m_array[2] )

foobar_obj = foobar {
    m_normal = 100.0,
}
print( foobar_obj.m_array[1] )


dbg = require("ex.debug")
print ( dbg.print_table(foo,"foo") )
-- print ( dbg.print_table(foo_obj,"foo_obj") )

-- print ( dbg.print_table(bar,"bar") )
-- print ( dbg.print_table(bar_obj,"bar_obj") )

foobar_obj.m_test_func2( foobar_obj )
foobar_obj.super.m_test_func2( foobar_obj )
print ( dbg.print_table(foobar,"foobar") )
-- foobar_obj.super.m_normal = "hahahahahahaha"
-- bar.m_normal = "hohohohoho"
-- foo.m_normal = "hehehehehe"
print ( dbg.print_table(foobar,"foobar") )
-- print ( dbg.print_table(bar_obj.super,"bar_super") )
print ( dbg.print_table(foobar_obj,"foobar_obj") )
