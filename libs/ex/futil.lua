-- ======================================================================================
-- File         : futil.lua
-- Author       : Wu Jie 
-- Last Change  : 01/05/2011 | 01:12:38 AM | Wednesday,January
-- Description  : 
-- ======================================================================================

--/////////////////////////////////////////////////////////////////////////////
-- module
--/////////////////////////////////////////////////////////////////////////////

require("lfs")
require("ex.string")

local assert, type = assert, type
local io = io
local os = os
local string = string
local ex_string = ex.string
local lfs = lfs

module("ex.futil")

--/////////////////////////////////////////////////////////////////////////////
-- functions
--/////////////////////////////////////////////////////////////////////////////

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

local function copyfile ( _src, _dest )
    local destAttr = lfs.attributes(_dest)
    local dest = _dest
    if destAttr and destAttr.mode == "directory" then
        -- get file name
        local r_src = string.reverse(_src)
        local i = r_src:find("/")
        local fname = _src
        if i ~= nil then
            fname = _src:sub( #_src-i+2 )
        end
        dest = _dest .. "/" .. fname
    end

    -- DISABLE { 
    -- fin = io.open(_src,"rb")
    -- fout = io.open(dest,"wb")

    -- data = fin:read("*all")
    -- data = string.gsub(data, "\r\n", "\n")
    -- fout:write(data)

    -- assert(fout:close())
    -- assert(fin:close())
    -- } DISABLE end 

    -- TODO: find a way cross-platform { 
    fout = io.open(dest,"wb")
    assert(fout:close())
    win_src = string.gsub(_src, "/", "\\")
    win_dest = string.gsub(dest, "/", "\\")
    os.execute( "xcopy " .. win_src .. " " .. win_dest .. " /Y /Q" )
    -- } TODO end 
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

local function copydir ( _src, _dest )
    -- DISABLE { 
    -- for file in lfs.dir(_src) do
    --     if file ~= "." and file ~= ".." then
    --         local fullpath = _src..'/'..file
    --         local attr = lfs.attributes(fullpath)

    --         if attr.mode == "directory" then
    --             copydir(fullpath,_dest)
    --         else
    --             copyfile(fullpath,_dest)
    --         end
    --     end
    -- end
    -- } DISABLE end 

    -- TODO: find a way cross-platform { 
    win_src = string.gsub(_src, "/", "\\")
    win_dest = string.gsub(_dest, "/", "\\")
    os.execute( "xcopy " .. win_src .. " " .. win_dest .. " /Y /E /Q" )
    -- } TODO end 
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function mkdirs (_path)
    local dirNames = ex_string.split_path(_path)
    local path = "" 

    for i=1,#dirNames do  
        if i == 1 then path = dirNames[i]
        else path = path .. "/" .. dirNames[i] 
        end

        local dirAttr = lfs.attributes(path)
        if dirAttr == nil or dirAttr.mode ~= "directory" then
            lfs.mkdir(path)
        end
    end
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function rmdirs (_path)
    -- TODO: find a way cross-platform { 
    win_path = string.gsub(_path, "/", "\\")
    os.execute("rmdir "..win_path.." /S /Q")
    -- } TODO end 
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function cp ( _src, _dest )
    srcAttr = lfs.attributes(_src)
    assert ( srcAttr and srcAttr.mode == "file" , "_src file does not exists: " .. _src )
    copyfile( _src, _dest )
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function cpdir ( _src, _dest )
    srcAttr = lfs.attributes(_src)
    assert ( srcAttr and srcAttr.mode == "directory" , "_src directory does not exists: " .. _src )
    destAttr = lfs.attributes(_dest)
    if destAttr == nil or destAttr.mode ~= "directory" then
        mkdirs(_dest)
    end
    copydir( _src, _dest )
end

-- ------------------------------------------------------------------ 
-- Desc: 
-- ------------------------------------------------------------------ 

function mv ( _src, _dest )
    -- TODO: find a way cross-platform { 
    win_src = string.gsub(_src, "/", "\\")
    win_dest = string.gsub(_dest, "/", "\\")
    os.execute("move /Y "..win_src.." "..win_dest)
    -- } TODO end 
end
