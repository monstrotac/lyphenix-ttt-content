-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

if !SpecDM then return end

PANEL = {}

function PANEL:SetWeapons(tbl)
	self.Weapons = {}

	for _, v in pairs(tbl) do
		self.Weapons[v] = SpecDM.Loadout_Icons[v] or "vgui/ttt/icon_nades"
	end

	self:AddWeapons()
end

function PANEL:GetNewValue()
	if self.CheckBox:GetChecked() then
		return "random"
	elseif self.Loadout.SelectedPanel then
		return self.Loadout.SelectedPanel.Value
	else
		return GetConVar(self.cvar):GetString()
	end
end

function PANEL:AddWeapons()
	for k, v in pairs(self.Weapons) do
		local icon = vgui.Create("SimpleIcon", self.Loadout)
		icon.Value = k

		icon:SetIconSize(64 * RayUI.Scale)

		if Material(v) and Material(v).IsError and not Material(v):IsError() then
			icon:SetIcon(v)
		else
			icon:SetIcon("vgui/ttt/icon_nades")
		end

		icon:SetTooltip(k)

		local old_func = icon.OnCursorEntered

		icon.OnCursorEntered = function(panel)
			if self.Moving then return end
			old_func(panel)
		end

		self.Loadout:Add(icon)

		icon.DoClick = function()
			self.Loadout:SelectPanel(icon)
		end

		if GetConVar(self.cvar):GetString() == k then
			self.Loadout:SelectPanel(icon)
		end
	end

	self.WeaponsCount = table.Count(self.Weapons)
	self.CheckBox:SetChecked(GetConVar(self.cvar):GetString() == "random")
end

function PANEL:Init()
	self.CheckBox = RayUI:MakeCheckbox(self, nil, "Random weapon")

	self.Panel = vgui.Create("DScrollPanel", self)
	self.Panel:Dock(TOP)
	self.Panel:SetTall(150 * RayUI.Scale)
	self.Panel:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, 0)
	self.Panel.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, RayUI.Colors.DarkGray6 )
	end

	self.Loadout = vgui.Create("EquipSelect", self.Panel)
	self.Loadout:Dock(FILL)
	self.Loadout:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, 0)
	self.Loadout:SetSpaceX(4 * RayUI.Scale)
	self.Loadout:SetSpaceY(4 * RayUI.Scale)

	self.Save = vgui.Create("DButton", self)
	self.Save:Dock(TOP)
	self.Save:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, 0)
	self.Save:SetTall(30 * RayUI.Scale)
	self.Save.DoClick = function()
		RunConsoleCommand(self.cvar, self:GetNewValue())
		SpecDM.UpdateLoadout()
	end
	self.Save:FormatRayButton("Save", RayUI.Colors.DarkGray6, RayUI.Colors.Green)
end
vgui.Register("RayHUDTTT:SpecDM_LoadoutPanel", PANEL, "Panel")

RayHUDTTT.Help.CreateSettings("SpecDM", RayUI.Icons.Ghost, function(parent)

		RayHUDTTT.Help.CreateCategory(parent, "Primary weapons", 260 * RayUI.Scale, function(parent)
			if SpecDM.LoadoutEnabled then
				local PrimaryLoadout = vgui.Create("RayHUDTTT:SpecDM_LoadoutPanel", parent)
				PrimaryLoadout.cvar = "ttt_specdm_primaryweapon"
				PrimaryLoadout:SetWeapons(SpecDM.Ghost_weapons.primary)
				PrimaryLoadout:Dock(TOP)
				PrimaryLoadout:SetTall(260 * RayUI.Scale)
			end
		end)

		RayHUDTTT.Help.CreateCategory(parent, "Secondary weapons", 260 * RayUI.Scale, function(parent)
			if SpecDM.LoadoutEnabled then
				local SecondaryLoadout = vgui.Create("RayHUDTTT:SpecDM_LoadoutPanel", parent)
				SecondaryLoadout.cvar = "ttt_specdm_secondaryweapon"
				SecondaryLoadout:SetWeapons(SpecDM.Ghost_weapons.secondary)
				SecondaryLoadout:Dock(TOP)
				SecondaryLoadout:SetTall(260 * RayUI.Scale)
			end
		end)

		RayHUDTTT.Help.CreateCategory(parent, "General settings", 290 * RayUI.Scale, function(parent)
		if not SpecDM.ForceDeathmatch then
			RayUI:MakeCheckbox(parent, "ttt_specdm_autoswitch", "Enable autoswitch")
		else
			RayUI:MakeCheckbox(parent, "ttt_specdm_forcedeathmatch", "Always go to deathmatch mode after dying")
		end

		RayUI:MakeCheckbox(parent, "ttt_specdm_quakesounds", "Enable Quake sounds + texts")
		RayUI:MakeCheckbox(parent, "ttt_specdm_showaliveplayers", "Show alive players")
		RayUI:MakeCheckbox(parent, "ttt_specdm_enablecoloreffect", "Enable the color effect")
		RayUI:MakeCheckbox(parent, "ttt_specdm_hitmarker", "Enable the hitmarker")
	end)
end)