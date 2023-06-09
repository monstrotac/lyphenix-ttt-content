-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

local GetLang = LANG.GetUnsafeLanguageTable
local TryTranslation = LANG.TryTranslation
local L = GetLang()

local function MakeRayHUDDP(ply, role, rolename, wep, hits, dmg)

	surface.SetFont("RayUI:Largest4")

	local TextNick = "-"
	local TextRole = rolename != "" and L[rolename] or "World"
	local RoleColor = Color(87, 87, 87)
	local TextWeapon = "-"

	if RayHUDTTT.CustomRoles and RayHUDTTT.CustomRoles[role] then
		RoleColor = RayHUDTTT.CustomRoles[role]
	else
		if role == ROLE_INNOCENT then
			RoleColor = RayUI.Colors.Innocent
		elseif role == ROLE_TRAITOR then
			RoleColor = RayUI.Colors.Traitor
		elseif role == ROLE_DETECTIVE then
			RoleColor = RayUI.Colors.Detective
		end
	end

	if ply:IsValid() and ply:IsPlayer() then
		TextNick = ply:Nick()
	end

	local NickWide = math.Clamp(select(1, surface.GetTextSize(TextNick)), 0, 300 * RayUI.Scale )
	local RoleWide = select(1, surface.GetTextSize(TextRole))
	local WepWide = 0
	
	if ply:IsValid() and ply != LocalPlayer() and wep and wep:IsWeapon() then
		TextWeapon = TryTranslation(wep.PrintName)		
	end

	WepWide = select(1, surface.GetTextSize(TextWeapon))

	local width = 165 * RayUI.Scale + (NickWide + 25 * RayUI.Scale) + (RoleWide + 25 * RayUI.Scale) + (WepWide + 25 * RayUI.Scale)
	local height = 190 * RayUI.Scale
	local x = ((ScrW()/2) - (width/2))
	local y = ScrH() - 350 * RayUI.Scale
	
	local DeathPanel = vgui.Create("DPanel")
	DeathPanel:SetPos(x, y)
	DeathPanel:SetSize(width, height)
	DeathPanel:SetVisible(true)
	DeathPanel.Paint = function(self, w, h)
		RayUI:DrawBlur(self)
		RayUI:DrawMaterialBox(RayUI.GetPhrase("rayhudttt", "you_died"), 0, 0, w, h, RoleColor)
	end
	DeathPanel:AlphaTo(0, 0.5, 6, function() DeathPanel:Remove() end)
	
	local Header = vgui.Create("DPanel", DeathPanel)
	Header:SetTall(42 * RayUI.Scale)
	Header:Dock(TOP)
	Header:SetDrawBackground(false)
	
	local Avatar = vgui.Create("RoundedAvatar", DeathPanel)
	Avatar:Dock(LEFT)
	Avatar:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 0, 10 * RayUI.Scale)
	Avatar:SetWide(120 * RayUI.Scale)
	Avatar:SetMaskSize((1500 * RayUI.Scale) / 2)
	
	if !ply:IsPlayer() or ply:IsBot() then
		Avatar:SetPlayer(nil)
	elseif ply:IsPlayer() and ply == LocalPlayer() then
		Avatar:SetPlayer(LocalPlayer())
	else
		Avatar:SetPlayer(ply)
	end

	local UpperPanel = vgui.Create("DPanel", DeathPanel)
	UpperPanel:SetTall(60 * RayUI.Scale)
	UpperPanel:Dock(TOP)
	UpperPanel:DockMargin(5 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, 0 * RayUI.Scale)
	UpperPanel:SetDrawBackground(false)
	
	local BottomPanel = vgui.Create("DPanel", DeathPanel)
	BottomPanel:SetTall(60 * RayUI.Scale)
	BottomPanel:Dock(TOP)
	BottomPanel:DockMargin(5 * RayUI.Scale, 0, 10 * RayUI.Scale, 10 * RayUI.Scale)
	BottomPanel:SetDrawBackground(false)

	local NickPanel = vgui.Create("DPanel", UpperPanel)
	NickPanel:SetWide( NickWide + 25 * RayUI.Scale )
	NickPanel:Dock(LEFT)
	NickPanel:DockMargin(5 * RayUI.Scale, 5 * RayUI.Scale, 0, 5 * RayUI.Scale)
	NickPanel.Paint = function(self, w, h)
		draw.RoundedBox(RayUI.Rounding, 0, 0, w, h, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 20))
	end
	
	local Nick = RayUI:MakeLabel(TextNick, "RayUI:Largest4", color_white, NickPanel)
	Nick:SetPos((NickPanel:GetWide() - NickWide) / 2, 5 * RayUI.Scale)
	Nick:SetWide(NickWide)

	local RolePanel = vgui.Create("DPanel", UpperPanel)
	RolePanel:SetWide( RoleWide + 25 * RayUI.Scale )
	RolePanel:Dock(LEFT)
	RolePanel:DockMargin(5 * RayUI.Scale, 5 * RayUI.Scale, 0, 5 * RayUI.Scale)
	RolePanel.Paint = function(self, w, h)
		draw.RoundedBox(RayUI.Rounding, 0, 0, w, h, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 20))
	end
	
	local Role = RayUI:MakeLabel(TextRole, "RayUI:Largest4", RoleColor, RolePanel)
	Role:SetPos((RolePanel:GetWide() - RoleWide) / 2, 5 * RayUI.Scale)
	Role:SizeToContents()

	local WepPanel = vgui.Create("DPanel", UpperPanel)
	WepPanel:SetWide( WepWide + 25 * RayUI.Scale )
	WepPanel:Dock(LEFT)
	WepPanel:DockMargin(5 * RayUI.Scale, 5 * RayUI.Scale, 0, 5 * RayUI.Scale)
	WepPanel.Paint = function(self, w, h)
		draw.RoundedBox(RayUI.Rounding, 0, 0, w, h, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 20))
	end

	local Weapon = RayUI:MakeLabel(TextWeapon, "RayUI:Largest4", RayUI.Colors.Orange, WepPanel)
	Weapon:SetPos((WepPanel:GetWide() - WepWide) / 2, 5 * RayUI.Scale)
	Weapon:SizeToContents()

	local HPPanel = vgui.Create("DPanel", BottomPanel)
	HPPanel:SetWide(NickPanel:GetWide() + RolePanel:GetWide() + 5 * RayUI.Scale)
	HPPanel:Dock(LEFT)
	HPPanel:DockMargin(5 * RayUI.Scale, 0, 0, 5 * RayUI.Scale)
	HPPanel.Paint = function(self, w, h)
		draw.RoundedBox(RayUI.Rounding, 0, 0, w, h, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 20))
		
		if ply != LocalPlayer() and ply:IsPlayer() then		
			local text = "HP: "..math.Clamp(ply:Health(), 0, ply:GetMaxHealth()).." / "..ply:GetMaxHealth()
			RayUI:CreateBar(40 * RayUI.Scale, 27 * RayUI.Scale, w - 56 * RayUI.Scale, 10, RayUI.Colors.LightHP, RayUI.Colors.HP, ply:Health() / ply:GetMaxHealth(), text, RayUI.Icons.Heart)
		else
			surface.SetFont("RayUI:Largest4")
			draw.SimpleText( "Suicide!", "RayUI:Largest4", (w - select(1, surface.GetTextSize("suicide!"))) / 2, 8 * RayUI.Scale ,  RayUI.Colors.White )
		end
	end

	local DMGPanel = vgui.Create("DPanel", BottomPanel)
	DMGPanel:SetWide(WepWide + 25 * RayUI.Scale)
	DMGPanel:Dock(LEFT)
	DMGPanel:DockMargin(5 * RayUI.Scale, 0, 0, 5 * RayUI.Scale)
	DMGPanel.Paint = function(self, w, h)
		draw.RoundedBox(RayUI.Rounding, 0, 0, w, h,Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 20))
		if ply != LocalPlayer() and wep and wep:IsWeapon() then

			surface.SetFont("RayUI:Medium")
			draw.SimpleText( hits.." Hits", "RayUI:Medium", w - 8 * RayUI.Scale - select(1, surface.GetTextSize(hits.." Hits")), 2 * RayUI.Scale, RayUI.Colors.Orange )
			draw.SimpleText( dmg.." Dmg", "RayUI:Medium", w - 8 * RayUI.Scale - select(1, surface.GetTextSize(dmg.." Dmg")), 26 * RayUI.Scale, RayUI.Colors.Orange )
		else
			surface.SetFont("RayUI:Largest4")
			draw.SimpleText( "-", "RayUI:Largest4",   (w - select(1, surface.GetTextSize("-"))) / 2, 8 * RayUI.Scale , RayUI.Colors.Orange )
		end
	end

	if ply:IsPlayer() then
		Msg("You were killed by " .. ply:Nick() .. ", he was " .. TextRole:upper() .. ".\n")
	else
		Msg("You were killed by the world.\n")
	end
end

net.Receive("RayDeathPanel_Net", function()
	if DeathPanel and DeathPanel:IsValid() then
		DeathPanel:Remove()
	end
	
	local player = net.ReadEntity()
	local role = net.ReadInt(8)
	local rolename = net.ReadString()
	local weapon = net.ReadEntity()
	local times = net.ReadInt(8)
	local dmg = net.ReadInt(16)

	MakeRayHUDDP(player, role, rolename, weapon, times, dmg) 
end)