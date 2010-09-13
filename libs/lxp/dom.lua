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
local assert, type, print, pairs, tostring = assert, type, print, pairs, tostring
local string = string
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
    local newelement = new_element()
    newelement.tag = tag
    newelement.attr = attr
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

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

local function insert_node ( _dom, _k, _v )
    local attr = _dom.attr
    local key = tostring(_k)
    local value = tostring(_v)

    if type(_v) == "number" or type(_v) == "string" then
        tinsert( attr, key )
        attr[key] = value
    elseif type(_v) == "table" then
        local node = new_element()
        node.tag = key
        tinsert( _dom, node )

        -- we assume the table and array are seprate
        if #_v == 0 then
            for k,v in pairs(_v) do
                insert_node( _dom[#_dom], k, v )
            end
        else
            for i=1,#_v do
                insert_node( _dom[#_dom], "idx_"..(i-1), _v[i] )
            end
        end
    else
        error( "cannot add node " .. _k )
    end
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

local function write_node(_node,_lv)
    local lv = _lv or 0
    text = ""
    text = text .. string.rep("    ",lv) .. "<" .. _node.tag
    local attrs = _node.attr
    for i=1,#attrs do
        local key = attrs[i]
        text = text .. " " .. key .. "=\"" .. tostring(attrs[key]) .. "\""
    end

    -- if we don't have any contents and don't have any element nodes.
    if (_node.content == "") and (#_node == 0) then
        text = text .. "/>\n"
        return text
    end

    -- put node content 
    if _node.content then
        text = text .. ">" .. _node.content
    end

    -- put child nodes
    for i=1,#_node do
        local child_node = _node[i]
        if i == 1 then text = text .. "\n" end
        text = text .. write_node(child_node,lv+1)
    end

    -- put end tag
    if #_node > 0 then text = text .. string.rep("    ",lv) end
    text = text .. "</" .. _node.tag .. ">\n"
    return text
end

--/////////////////////////////////////////////////////////////////////////////
-- exported function
--/////////////////////////////////////////////////////////////////////////////

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function parse (o)
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

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function new_element ()
    return {tag = "", attr = {}, content = ""}
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function build (_name,_o)
    assert ( type(_o) == "table", "_o[type="..type(_o).."] is not a table" )
    local dom = new_element()
    dom.tag = _name
    for k,v in pairs(_o) do
        insert_node( dom, k, v )
    end
    return dom
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function toxml (_dom)
    local text =  "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
    return text .. write_node(_dom)
end
