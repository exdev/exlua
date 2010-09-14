-- ======================================================================================
-- File         : ActionExporter.lua
-- Author       : Wu Jie 
-- Last Change  : 09/10/2010 | 14:06:25 PM | Friday,September
-- Description  : 
-- ======================================================================================

--/////////////////////////////////////////////////////////////////////////////
-- require modules
--/////////////////////////////////////////////////////////////////////////////

require("basic")

--/////////////////////////////////////////////////////////////////////////////
-- convertor
--/////////////////////////////////////////////////////////////////////////////

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
    biaozhu             = basic.simple_set("m_tag"),
    id                  = basic.simple_set("m_ID"),
    actionid_left       = basic.simple_set("m_nActionLeft"),
    actionid_right      = basic.simple_set("m_nActionRight"),
    play_pace           = basic.simple_set("m_nPlaySpeed"),
    actionloop          = basic.simple_set("m_bActionLoop"),
    continuancetimer    = basic.simple_set("m_nMContinueTimer"),
    endtype             = basic.simple_set("m_eMEndType"),
    control             = basic.simple_set("m_bKeyOpen"),
    sms                 = basic.simple_set("m_nLockMagic"),
}
for i=0,6 do 
    for j=0,4 do 
        attrConvertList["ms_data"..i.."_"..j] = movekey_set("m_szMKey",j+1,i+1)
    end
end
for i=0,4 do attrConvertList["gesture_"..i] = basic.list_set("m_sznPose",i+1) end
for i=0,4 do attrConvertList["effect"..i] = basic.list_set("m_sznNEffect",i+1) end
for i=0,2 do attrConvertList["x_effext"..i] = basic.list_set("m_sznXEffect",i+1) end
for i=0,4 do attrConvertList["zhendong"..i] = basic.list_set("m_sznZhenDong",i+1) end
for i=0,2 do attrConvertList["fectearthef_left"..i] = basic.list_set("m_sznLeftHitGround",i+1) end
for i=0,2 do attrConvertList["fectearthef_right"..i] = basic.list_set("m_sznRightHitGround",i+1) end
for i=0,4 do attrConvertList["magic"..i] = basic.list_set("m_sznMagic",i+1) end
for i=0,4 do attrConvertList["mtlcolor"..i] = basic.list_set("m_sznMtlColor",i+1) end

--/////////////////////////////////////////////////////////////////////////////
-- process
--/////////////////////////////////////////////////////////////////////////////

basic.export ( "action.xml", "action", "CActionData", attrConvertList )
