-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation

CreateConVar("ttt_spectator_mode", "0", FCVAR_ARCHIVE)
CreateConVar("ttt_mute_team_check", "0")

CreateClientConVar("ttt_avoid_detective", "0", true, true)

RayHUDTTT.Help = RayHUDTTT.Help or {}
RayHUDTTT.Help.Buttons = {}

function RayHUDTTT.Help:Show()
	RayHUDTTT.SettingsMainPanel = vgui.Create("RayUI:MainPanel")
	RayHUDTTT.SettingsMainPanel:SetSize(700 * RayUI.Scale, 500 * RayUI.Scale)
	RayHUDTTT.SettingsMainPanel:CreateSidebar(RayHUDTTT.Help.Buttons)
	RayHUDTTT.SettingsMainPanel:SetTitle(GetTranslation("help_title"))
	RayHUDTTT.SettingsMainPanel:Center()
	RayHUDTTT.SettingsMainPanel:MakePopup()
end

local function ShowTTTHelp(ply, cmd, args)
	if IsValid(RayHUDTTT.SettingsMainPanel) then
		RayHUDTTT.SettingsMainPanel:Close()
	else
		RayHUDTTT.Help:Show()
	end
end

timer.Simple(1, function()
	concommand.Add("ttt_helpscreen", ShowTTTHelp)
end)

-- Some spectator mode bookkeeping

local function SpectateCallback(cv, old, new)
   local num = tonumber(new)
   if num and (num == 0 or num == 1) then
      RunConsoleCommand("ttt_spectate", num)
   end
end
cvars.AddChangeCallback("ttt_spectator_mode", SpectateCallback)

local function MuteTeamCallback(cv, old, new)
   local num = tonumber(new)
   if num and (num == 0 or num == 1) then
      RunConsoleCommand("ttt_mute_team", num)
   end
end
cvars.AddChangeCallback("ttt_mute_team_check", MuteTeamCallback)

--- Tutorial
local imgpath = "vgui/ttt/help/tut0%d"
local tutorial_pages = 6
function RayHUDTTT.Help:CreateTutorial(parent)
	local w, h = parent:GetSize()

	local TutorialBG = vgui.Create("DPanel", parent)
	TutorialBG:Dock(FILL)
	TutorialBG.Paint = function(self, w, h)
		draw.RoundedBox(RayUI.Rounding, 0, 0, w, h, RayUI.Colors.DarkGray3)
	end

	local tut = vgui.Create("DImage", TutorialBG)
	tut:StretchToParent(15 * RayUI.Scale, 15 * RayUI.Scale, 15 * RayUI.Scale, 15 * RayUI.Scale)
	tut:SetVerticalScrollbarEnabled(false)
	tut:SetImage(Format(imgpath, 1))
	tut:SetWide(1056 * RayUI.Scale)
	tut:SetTall((1056/2 + 30) * RayUI.Scale)

	tut.current = 1
	
	local barpanel = vgui.Create("DPanel", TutorialBG)
	barpanel:Dock(BOTTOM)
	barpanel:SetTall(40 * RayUI.Scale)
	barpanel:DockMargin(10 * RayUI.Scale, 0, 12 * RayUI.Scale, 0)
	barpanel.Paint = function(self, w, h) end
	
	local bnext = vgui.Create("DButton", barpanel)
	bnext:SetWide(100 * RayUI.Scale)
	bnext:Dock(RIGHT)
	bnext:DockMargin(0, 0, 0, 10 * RayUI.Scale)
	bnext:SetFont("RayUI:Smallest")
	bnext.DoClick = function()
		if tut.current < tutorial_pages then
			tut.current = tut.current + 1
			tut:SetImage(Format(imgpath, tut.current))
		end
	end
	bnext:FormatRayButton(GetTranslation("next"), RayUI.Colors.Gray, RayUI.Colors.DarkGray2)

	local bprev = vgui.Create("DButton", barpanel)
	bprev:SetWide(100 * RayUI.Scale)
	bprev:Dock(LEFT)
	bprev:DockMargin(0, 0, 0, 10 * RayUI.Scale)
	bprev:SetFont("RayUI:Smallest")
	bprev.DoClick = function()
		if tut.current > 1 then
			tut.current = tut.current - 1
			tut:SetImage(Format(imgpath, tut.current))
		end
	end
	bprev:FormatRayButton(GetTranslation("prev"), RayUI.Colors.Gray, RayUI.Colors.DarkGray2)
	
	local bar = vgui.Create("DPanel", barpanel)
	bar:Dock(TOP)
	bar:DockMargin(80 * RayUI.Scale, 3 * RayUI.Scale, 80 * RayUI.Scale, 0)
	bar:SetTall(26 * RayUI.Scale)
	bar.Paint = function(self, w, h)
		draw.RoundedBox( 5, 0, 0, w, h, RayUI.Colors.LightGreen ) -- Background
		draw.RoundedBox( 5, 0, 0, w * (tut.current/tutorial_pages), h, RayUI.Colors.Green ) -- Fill
		
		surface.SetFont("RayUI:Small")
		draw.SimpleText( tut.current.." / "..tutorial_pages, "RayUI:Small", (w - select(1, surface.GetTextSize( tut.current.." / "..tutorial_pages )))/2, (h - select(2, surface.GetTextSize( tut.current.." / "..tutorial_pages )))/2, color_white )
	end
end

function RayHUDTTT.Help.CreateSettings(text, icon, functions, noscroll)
	local SettingsName = {text = text, icon = icon, callback = function(parent) functions(parent) end, noscroll = noscroll}
	table.insert(RayHUDTTT.Help.Buttons, SettingsName)
end

function RayHUDTTT.Help.CreateCategory(parent, name, tall, functions)
	local CategoryLabel = vgui.Create("DButton", parent)
	CategoryLabel:SetFont("RayUI:Small3")
	CategoryLabel:SetTextColor( RayUI.Colors.White )
	CategoryLabel:SetText( name )
	CategoryLabel:SetTall(30 * RayUI.Scale)
	CategoryLabel:Dock(TOP)
	CategoryLabel:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, 0)
	CategoryLabel.Paint = function( s, w, h )
		draw.RoundedBox(5, 0, 0, w, h, RayUI.Colors.Blue)
	end
	
	local SettingPanel = vgui.Create("DPanel", parent)
	SettingPanel:Dock(TOP)
	SettingPanel:SetTall(tall)
	SettingPanel:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, 0)
	SettingPanel:SetPaintBackground(false)
	
	CategoryLabel.DoClick = function()
		if SettingPanel:GetTall() == math.Round(tall) then
			SettingPanel:SizeTo( SettingPanel:GetWide(), 0, 0.2, 0 )
		else
			SettingPanel:SizeTo( SettingPanel:GetWide(), tall, 0.2, 0 )
		end
	end
	
	functions(SettingPanel)
end

RayHUDTTT.Help.CreateSettings(GetTranslation("help_settings"), RayUI.Icons.Help, function(parent)
	RayHUDTTT.Help:CreateTutorial(parent)
end, true)

RayHUDTTT.Help.CreateSettings(GetTranslation("help_settings"), RayUI.Icons.Cog, function(parent)
	RayHUDTTT.Help.CreateCategory(parent, GetTranslation("set_title_gui"), 680 * RayUI.Scale, function(parent)
		RayUI:MakeCheckbox(parent, "ttt_tips_enable", GetTranslation("set_tips"))
		
		RayUI:MakeSlider(parent, "ttt_startpopup_duration", GetTranslation("set_startpopup"), 0, 60, 0)
		RayUI:MakeSlider(parent, "ttt_ironsights_crosshair_opacity", GetTranslation("set_cross_opacity"), 0, 1, 1)
		RayUI:MakeSlider(parent, "ttt_crosshair_brightness", GetTranslation("set_cross_brightness"), 0, 1, 1)
		RayUI:MakeSlider(parent, "ttt_crosshair_size", GetTranslation("set_cross_size"), 0.1, 3, 1)

		RayUI:MakeCheckbox(parent, "ttt_disable_crosshair", GetTranslation("set_cross_disable"))
		RayUI:MakeCheckbox(parent, "ttt_minimal_targetid", GetTranslation("set_minimal_id"))
		RayUI:MakeCheckbox(parent, "ttt_ironsights_lowered", GetTranslation("set_lowsights"))
		RayUI:MakeCheckbox(parent, "ttt_weaponswitcher_fast", GetTranslation("set_fastsw"))
		RayUI:MakeCheckbox(parent, "ttt_weaponswitcher_displayfast", GetTranslation("set_fastsw_menu"))
		RayUI:MakeCheckbox(parent, "ttt_weaponswitcher_stay", GetTranslation("set_wswitch"))
		RayUI:MakeCheckbox(parent, "ttt_cl_soundcues", GetTranslation("set_cues"))
	end)
	
	RayHUDTTT.Help.CreateCategory(parent, GetTranslation("set_title_play"), 176 * RayUI.Scale, function(parent)
		RayUI:MakeCheckbox(parent, "ttt_avoid_detective", GetTranslation("set_avoid_det"))
		RayUI:MakeCheckbox(parent, "ttt_spectator_mode", GetTranslation("set_specmode"))
		RayUI:MakeCheckbox(parent, "ttt_mute_team_check", GetTranslation("set_mute"))
	end)
	
	RayHUDTTT.Help.CreateCategory(parent, GetTranslation("set_title_lang"), 56 * RayUI.Scale, function(parent)
		local dlang = RayUI:MakeComboBox(parent, "Language")
		dlang:SetConVar("ttt_language")
		dlang:AddChoice("Server default", "auto")
		for _, lang in pairs(LANG.GetLanguages()) do
			dlang:AddChoice(string.Capitalize(lang), lang)
		end
		dlang.OnSelect = function(idx, val, data)
			RunConsoleCommand("ttt_language", data)
		end
		dlang.Think = dlang.ConVarStringThink
	end)
end)