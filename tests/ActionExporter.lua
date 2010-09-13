-- ======================================================================================
-- File         : ActionExporter.lua
-- Author       : Wu Jie 
-- Last Change  : 09/10/2010 | 14:06:25 PM | Friday,September
-- Description  : 
-- ======================================================================================

--/////////////////////////////////////////////////////////////////////////////
-- require modules
--/////////////////////////////////////////////////////////////////////////////

require("lxp.dom")
require("ex.debug")

--/////////////////////////////////////////////////////////////////////////////
-- convertor
--/////////////////////////////////////////////////////////////////////////////

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

local function simple_set ( _name )
    return function ( _table, value )
        _table[_name] = value
    end
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

local function list_set ( _name, _index )
    return function ( _table, value )
        _table[_name] = _table[_name] or {}
        _table[_name][_index] = value
    end
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

local function list_set2 ( _name, _i, _j )
    return function ( _table, value )
        _table[_name] = _table[_name] or {}
        local l = _table[_name]
        l[_i] = l[_i] or {}
        l[_i][_j] = value
    end
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

local function movekey_set ( _name, _i, _j )
    return function ( _table, value )
        _table[_name] = _table[_name] or {}
        local l = _table[_name]
        l[_i] = l[_i] or {eType = _i-1, params = {}}
        l[_i].params[_j] = value
    end
end

--/////////////////////////////////////////////////////////////////////////////
-- set the attribute changes
--/////////////////////////////////////////////////////////////////////////////

local attrConvertList = {
    biaozhu             = simple_set("m_tag"),
    id                  = simple_set("m_ID"),
    actionid_left       = simple_set("m_nActionLeft"),
    actionid_right      = simple_set("m_nActionRight"),
    play_pace           = simple_set("m_nPlaySpeed"),
    actionloop          = simple_set("m_bActionLoop"),
    continuancetimer    = simple_set("m_nMContinueTimer"),
    endtype             = simple_set("m_eMEndType"),
    control             = simple_set("m_bKeyOpen"),
    sms                 = simple_set("m_nLockMagic"),
}
for i=0,6 do 
    for j=0,4 do 
        attrConvertList["ms_data"..i.."_"..j] = movekey_set("m_szMKey",j+1,i+1)
    end
end
for i=0,4 do attrConvertList["gesture_"..i] = list_set("m_sznPose",i+1) end
for i=0,4 do attrConvertList["effect"..i] = list_set("m_sznNEffect",i+1) end
for i=0,2 do attrConvertList["x_effect"..i] = list_set("m_sznNEffect",i+1) end
for i=0,4 do attrConvertList["zhendong"..i] = list_set("m_sznZhenDong",i+1) end
for i=0,2 do attrConvertList["fectearthef_left"..i] = list_set("m_sznLeftHitGround",i+1) end
for i=0,2 do attrConvertList["fectearthef_right"..i] = list_set("m_sznRightHitGround",i+1) end
for i=0,4 do attrConvertList["magic"..i] = list_set("m_sznMagic",i+1) end
for i=0,4 do attrConvertList["mtlcolor"..i] = list_set("m_sznMtlColor",i+1) end

--/////////////////////////////////////////////////////////////////////////////
-- process
--/////////////////////////////////////////////////////////////////////////////

local dest_dir = "action"
local src_file = "action.xml"
local xml_header = "CActionData"

-- load xml file
print("create directory "..dest_dir)
os.execute("mkdir "..dest_dir)
print("start load "..src_file.."...")
local f = assert( io.open("./"..src_file, "r") )
local t = f:read("*all")
f:close()
local dom = lxp.dom.parse(t)

-- for each Mappings, process it.
local progress = #dom
for el_idx = 1,#dom do
    local data = {} 
    local attrs = dom[el_idx].attr
    for attr_idx = 1,#attrs do
        -- get attribute name and value one by one.
        local attr_name = attrs[attr_idx]
        local attr_value = string.gsub(attrs[attr_name]," ","") -- stripe white-space

        -- check if we use convertor for new attribute name.
        local convertor = attrConvertList[attr_name]
        if convertor then
            convertor( data, attr_value )
        end
    end

    -- extract data process
    data["m_version"] = 0

    -- save to file
    local filename = "./"..dest_dir.."/"..tostring(data.m_ID)..".xml"
    local root = lxp.dom.new_element()
    root.tag = "Root"
    root[1] = lxp.dom.build(xml_header,data)
    local txt = lxp.dom.toxml(root)
    local file = assert( io.open(filename, "wb") )
    file:write(txt)
    file:close()
    print("[".. string.format("%.2f",el_idx/progress * 100.0) .."%] file "..filename.." saved")
end
