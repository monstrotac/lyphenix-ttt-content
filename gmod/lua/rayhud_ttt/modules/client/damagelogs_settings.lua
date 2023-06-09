-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

if !Damagelog then return end

RayHUDTTT.Help.CreateSettings(RayUI.GetPhrase("rayhudttt", "dmglogs_settings"), RayUI.Icons.Crosshair, function(parent)

	RayHUDTTT.Help.CreateCategory(parent, TTTLogTranslate(GetDMGLogLang, "Generalsettings"), 400 * RayUI.Scale, function(parent)
		RayUI:MakeCheckbox(parent, "ttt_dmglogs_updatenotifications", TTTLogTranslate(GetDMGLogLang, "UpdateNotifications"))
		RayUI:MakeCheckbox(parent, "ttt_dmglogs_rdmpopups", TTTLogTranslate(GetDMGLogLang, "RDMuponRDM"))
		RayUI:MakeCheckbox(parent, "ttt_dmglogs_currentround", TTTLogTranslate(GetDMGLogLang, "CurrentRoundLogs"))
		RayUI:MakeCheckbox(parent, "ttt_dmglogs_showpending", TTTLogTranslate(GetDMGLogLang, "ShowPendingReports"))
		RayUI:MakeCheckbox(parent, "ttt_dmglogs_enablesound", TTTLogTranslate(GetDMGLogLang, "EnableSound"))
		RayUI:MakeCheckbox(parent, "ttt_dmglogs_enablesoundoutside", TTTLogTranslate(GetDMGLogLang, "OutsideNotification"))

		local dmgLang = RayUI:MakeComboBox(parent, "Language")

		for k in pairs(DamagelogLang) do
			dmgLang:AddChoice(string.upper(string.sub(k, 1, 1)) .. string.sub(k, 2, 100))
		end

		if Damagelog.ForcedLanguage == "" then
			dmgLang:SetDisabled(false)
			dmgLang:ChooseOption(string.upper(string.sub(GetConVar("ttt_dmglogs_language"):GetString(), 1, 1)) .. string.sub(GetConVar("ttt_dmglogs_language"):GetString(), 2, 100))
		else
			dmgLang:SetDisabled(true)
			dmgLang:SetTooltip(TTTLogTranslate(GetDMGLogLang, "ForcedLanguage"))
			dmgLang:ChooseOption(string.upper(string.sub(Damagelog.ForcedLanguage, 1, 1)) .. string.sub(Damagelog.ForcedLanguage, 2, 100))
		end

		dmgLang.OnSelect = function(panel, index, value, data, Damagelog)
			local currentLanguage = GetConVar("ttt_dmglogs_language"):GetString()
			local newLang = string.lower(value)

			if currentLanguage == newLang then
				return
			end

			RunConsoleCommand("ttt_dmglogs_language", newLang)
		end
	end)
			
	RayHUDTTT.Help.CreateCategory(parent, TTTLogTranslate(GetDMGLogLang, "Colors"), 340 * RayUI.Scale, function(parent)

		local colorChoice = RayUI:MakeComboBox(parent, "Color for:")

		for k in pairs(Damagelog.colors) do
			colorChoice:AddChoice(TTTLogTranslate(GetDMGLogLang, k), k)
		end

		colorChoice:ChooseOptionID(1)

		local colorMixer = RayUI:MakeColorPanel(parent, "Set color:")
		local found = false

		colorChoice.OnSelect = function(panel, index, value, data)
			colorMixer:SetColor(Damagelog.colors[data].Custom)
			selectedcolor = data
		end

		for k, v in pairs(Damagelog.colors) do
			if !found then
				colorMixer:SetColor(v.Custom)
				selectedcolor = k
				found = true
				break
			end
		end

		local saveColor = vgui.Create("DButton", parent)
		saveColor:Dock(TOP)
		saveColor:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, 0)
		saveColor:SetTall(30 * RayUI.Scale)
		saveColor.DoClick = function()
			local c = colorMixer:GetColor()
			Damagelog.colors[selectedcolor].Custom = c
			Damagelog:SaveColors()
		end
		saveColor:FormatRayButton(TTTLogTranslate(GetDMGLogLang, "Save"), RayUI.Colors.Gray, RayUI.Colors.Green)

		local defaultcolor = vgui.Create("DButton", parent)
		defaultcolor:Dock(TOP)
		defaultcolor:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, 0)
		defaultcolor:SetTall(30 * RayUI.Scale)
		defaultcolor.DoClick = function()
			local c = Damagelog.colors[selectedcolor].Default
			colorMixer:SetColor(c)
			Damagelog.colors[selectedcolor].Custom = c
			Damagelog:SaveColors()
		end
		defaultcolor:FormatRayButton(TTTLogTranslate(GetDMGLogLang, "SetDefault"), RayUI.Colors.Gray, RayUI.Colors.Blue)
	end)
end)