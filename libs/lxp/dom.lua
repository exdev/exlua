-- ======================================================================================
-- File         : dom.lua
-- Author       : Wu Jie 
-- Last Change  : 09/10/2010 | 17:28:57 PM | Friday,September
-- Description  : 
-- ======================================================================================

--/////////////////////////////////////////////////////////////////////////////
-- require and module
--/////////////////////////////////////////////////////////////////////////////

require "lxp"

local tinsert, tremove, getn = table.insert, table.remove, table.getn
local assert, type, print = assert, type, print
local lxp = lxp

module ("lxp.dom")

--/////////////////////////////////////////////////////////////////////////////
-- local function
--/////////////////////////////////////////////////////////////////////////////

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

local function starttag (p, tag, attr)
    local stack = p:getcallbacks().stack
    local newelement = {tag = tag, attr = attr, content = ""}
    stack.cur_elemnt = newelement
    tinsert(stack, newelement)
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

local function endtag (p, tag)
    local stack = p:getcallbacks().stack
    local element = tremove(stack)
    assert(element.tag == tag)
    local level = getn(stack)
    tinsert(stack[level], element)
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

local function text (p, txt)
    local stack = p:getcallbacks().stack
    local cur_elemnt = stack.cur_elemnt
    cur_elemnt.content = cur_elemnt.content .. txt
end

--/////////////////////////////////////////////////////////////////////////////
-- exported function
--/////////////////////////////////////////////////////////////////////////////

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function  parse (o)
    local c = { 
        StartElement = starttag,
        EndElement = endtag,
        CharacterData = text,
        _nonstrict = true,
        stack = {{}, cur_element = {}} 
    }
    local p = lxp.new(c)
    local status, err
    if type(o) == "string" then
        status, err = p:parse(o)
        if not status then return nil, err end
    else
        for l in o do
            status, err = p:parse(l)
            if not status then return nil, err end
        end
    end
    status, err = p:parse()
    if not status then return nil, err end
    p:close()
    c.stack.cur_elemnt = nil
    return c.stack[1][1]
end

