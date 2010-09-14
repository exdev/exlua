-- ======================================================================================
-- File         : basic.lua
-- Author       : Wu Jie 
-- Last Change  : 09/14/2010 | 10:25:28 AM | Tuesday,September
-- Description  : 
-- ======================================================================================

--/////////////////////////////////////////////////////////////////////////////
-- module
--/////////////////////////////////////////////////////////////////////////////

require("lxp.dom")
require("ex.debug")

local print,assert,tostring = print,assert,tostring
local os,io,lxp,string,coroutine = os,io,lxp,string,coroutine

module ("basic")

--/////////////////////////////////////////////////////////////////////////////
-- convertors
--/////////////////////////////////////////////////////////////////////////////

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function simple_set ( _name )
    return function ( _table, value )
        _table[_name] = value
    end
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function list_set ( _name, _index )
    return function ( _table, value )
        _table[_name] = _table[_name] or {}
        _table[_name][_index] = value
    end
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function list_set2 ( _name, _i, _j )
    return function ( _table, value )
        _table[_name] = _table[_name] or {}
        local l = _table[_name]
        l[_i] = l[_i] or {}
        l[_i][_j] = value
    end
end

--/////////////////////////////////////////////////////////////////////////////
-- process
--/////////////////////////////////////////////////////////////////////////////

function export ( _src_file, _dest_dir, _xml_header, _convertorList )
    -- load xml file
    print("start load ".._src_file.."...")
    local f = assert( io.open("./".._src_file, "r") )
    local t = f:read("*all")
    f:close()
    local dom = lxp.dom.parse(t)
    
    -- create directory for parse
    print("create directory ".._dest_dir)
    os.execute("mkdir ".._dest_dir)

    -- for each Mappings, process it.
    local progress = #dom
    for el_idx = 1,#dom do
        co = coroutine.create( function ()
            local data = {} 
            local attrs = dom[el_idx].attr
            for attr_idx = 1,#attrs do
                -- get attribute name and value one by one.
                local attr_name = attrs[attr_idx]
                local attr_value = string.gsub(attrs[attr_name]," ","") -- stripe white-space

                -- check if we use convertor for new attribute name.
                local convertor = _convertorList[attr_name]
                if convertor then
                    convertor( data, attr_value )
                end
            end

            -- extract data process
            if data["m_version"] == nil then data["m_version"] = 0 end
            if data["m_ID"] == nil then data["m_ID"] = -1 end
            if data["m_tag"] == nil then data["m_tag"] = "unknown" end

            -- save to file
            local filename = "./".._dest_dir.."/"..tostring(data.m_ID)..".xml"
            local root = lxp.dom.new_element()
            root.tag = "Root"
            root[1] = lxp.dom.build(_xml_header,data)
            local txt = lxp.dom.toxml(root)
            local file = assert( io.open(filename, "wb") )
            file:write(txt)
            file:close()
            print("[".. string.format("%.2f",el_idx/progress * 100.0) .."%] file "..filename.." saved")
        end )
        coroutine.resume(co)
    end
end
