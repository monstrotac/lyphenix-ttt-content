-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

RayUI.Configuration.AddConfig( "TTTOffsetX", {
	Title = "offset_x",
	TypeEnum = RAYUI_CONFIG_NUMBER,
	Default = 12,
	minNum = 0,
	maxNum = 200,
	SettingsOf = 3,
} )

RayUI.Configuration.AddConfig( "TTTOffsetY", {
	Title = "offset_y",
	TypeEnum = RAYUI_CONFIG_NUMBER,
	Default = 12,
	minNum = 0,
	maxNum = 200,
	SettingsOf = 3,
} )

RayUI.Configuration.AddConfig( "CrashScreenTTT", {
	Title = "crash_menu",
	TypeEnum = RAYUI_CONFIG_BOOL,
	Default = true,
	SettingsOf = 3,
} )

RayUI.Configuration.AddConfig( "DrowningIndicator", {
	Title = "drowning_indicator",
	TypeEnum = RAYUI_CONFIG_BOOL,
	Default = true,
	SettingsOf = 3,
} )

RayUI.Configuration.AddConfig( "CreditsOnWepSwitch", {
	Title = "credits_wepswitch",
	TypeEnum = RAYUI_CONFIG_BOOL,
	Default = true,
	SettingsOf = 3,
} )

RayUI.Configuration.AddConfig( "CustomItemsIcon", {
	Title = "custom_icon",
	TypeEnum = RAYUI_CONFIG_BOOL,
	Default = false,
	SettingsOf = 3,
} )

RayUI.Configuration.AddConfig( "ShopColumns", {
	Title = "shop_columns",
	TypeEnum = RAYUI_CONFIG_NUMBER,
	Default = 8,
	minNum = 2,
	maxNum = 12,
	SettingsOf = 3,
} )

RayUI.Configuration.AddConfig( "ShopRows", {
	Title = "shop_rows",
	TypeEnum = RAYUI_CONFIG_NUMBER,
	Default = 4,
	minNum = 2,
	maxNum = 12,
	SettingsOf = 3,
} )

if SERVER then
	RayUI.Configuration.LoadConfig()
	include("raylibs/cl_settings.lua")
end