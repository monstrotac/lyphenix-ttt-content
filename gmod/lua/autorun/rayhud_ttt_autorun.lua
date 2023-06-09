-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

RayHUDTTT = RayHUDTTT or {}

local function LoadClient(path)
	if SERVER then
		AddCSLuaFile( path )
	else
		include( path )
	end
end

local function LoadServer(path)
	if SERVER then
		include( path )
		AddCSLuaFile( path )
	end
end

local function LoadShared(path)
	LoadClient(path)
	LoadServer(path)
end

local function Load()
	// RayHUD TTT
	include( "rh_config.lua" )
	AddCSLuaFile( "rh_config.lua" )

	LoadShared("rayhud_ttt/shared/sh_setup.lua")

	for _, file in ipairs(file.Find( "rayhud_ttt/*.lua", "LUA" )) do
		LoadClient( "rayhud_ttt/" .. file )
	end

	for _, file in ipairs(file.Find( "rayhud_ttt/modules/client/*.lua", "LUA" )) do
		LoadClient( "rayhud_ttt/modules/client/" .. file )
	end

	for _, file in ipairs(file.Find( "rayhud_ttt/modules/server/*.lua", "LUA" )) do
		LoadServer( "rayhud_ttt/modules/server/" .. file )
	end
end

hook.Add("RayUIReady", "RayHUDTTT:Load", function()
	Load()
end)

if GAMEMODE then
	Load()
end

hook.Add( "OnScreenSizeChanged", "RayHUDTTT:Reload", function()
	Load()
end)


local hud = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true
}

hook.Add( "HUDShouldDraw", "HideDefaultTTTHUD", function( name )
	if hud[name] then return false end
end)