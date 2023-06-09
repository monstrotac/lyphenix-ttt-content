-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

local margin = 10 * RayUI.Scale

function WSWITCH:DrawBarBg(x, y, w, h, col)

	local role = LocalPlayer():GetRole() or ROLE_INNOCENT
   
	if GAMEMODE.round_state != ROUND_ACTIVE or (SpecDM and LocalPlayer():IsGhost()) then
		draw.RoundedBox( 6, x, y, w, h, col.noroundbg )	-- Panel
		draw.RoundedBox( 5, x + 5 * RayUI.Scale, y + 5 * RayUI.Scale, h - 10 * RayUI.Scale, h - 10 * RayUI.Scale, col.noroundtip )	-- Role Color
	else
		local c = col.bg
		draw.RoundedBox( 6, x, y, w, h, Color(c.r, c.g, c.b, RayUI.Opacity + 20) )	-- Panel
		
		draw.RoundedBox( 5, x + 5 * RayUI.Scale, y + 5 * RayUI.Scale, h - 10 * RayUI.Scale, h - 10 * RayUI.Scale, col.tip )	-- Role Color
	end
end

local TryTranslation = LANG.TryTranslation
function WSWITCH:DrawWeapon(x, y, c, wep)
	if not IsValid(wep) then return false end

	local name = TryTranslation(wep:GetPrintName() or wep.PrintName or "...")
	local cl1, am1 = wep:Clip1(), wep:Ammo1()
	local ammo = false

	if cl1 != -1 and am1 != false then
		ammo = Format("%02i + %02i", cl1, am1)
	end

	-- Slot
	local spec = {text=wep.Slot + 1, font="RayUI:Large", pos = {x + 20 * RayUI.Scale, y + 65 * RayUI.Scale}, yalign = TEXT_ALIGN_CENTER, color = c.text}
	draw.Text(spec)

	-- Name
	spec.text  = name
	spec.font  = "RayUI:Large"
	spec.pos[1] = x + 50 * RayUI.Scale
	draw.Text(spec)

	if ammo then
		local col = c.text

		if wep:Clip1() == 0 and wep:Ammo1() == 0 then
			col = c.text_empty
		end

		-- Ammo
		spec.text   = ammo
		spec.pos[1] = ScrW() - margin - 22 * RayUI.Scale 
		spec.xalign = TEXT_ALIGN_RIGHT
		spec.color  = col
		draw.Text(spec)
	end

	return true
end

function WSWITCH:Draw(client)
	if not self.Show then return end

	local col_active = {
		noroundtip = RayUI.Colors.DarkGray3,
		noroundbg = Color(87, 87, 87),
		
		tip = RayUI.Colors.DarkGray3,

		bg = RayUI:GetPlayerCol(),

		text_empty = Color(200, 20, 20, 255),
		text = RayUI.Colors.White,
	}

	local col_dark = {
		noroundtip = Color(87, 87, 87),
		noroundbg = RayUI.Colors.DarkGray3,
		
		tip = RayUI:GetPlayerCol(),

		bg = RayUI.Colors.DarkGray3,
		text_empty = Color(200, 20, 20, 100),
		text = Color(255, 255, 255, 100),
	}

	local weps = self.WeaponCache

	local LineH = 34 * RayUI.Scale
	local wh = table.Count(self.WeaponCache) * LineH

	local width = 400 * RayUI.Scale
	local height = (56 + (5 * table.Count(self.WeaponCache))) * RayUI.Scale + wh
	local x = ScrW() - width - RayHUDTTT.OffsetX
	local y = ScrH() - height - RayHUDTTT.OffsetY

	local text = ""
	
	if LocalPlayer():IsActiveSpecial() and RayUI.Configuration.GetConfig( "CreditsOnWepSwitch" ) then text = "Credits: " .. LocalPlayer():GetCredits() end

	if LocalPlayer():Alive() and !LocalPlayer():IsSpec() or (SpecDM and LocalPlayer():IsGhost()) then
		RayUI:DrawBlur2(x, y, width, height)
		RayUI:DrawMaterialBox(text, x, y, width, height)
	end

	local col = col_dark
	for k, wep in ipairs(weps) do
		if self.Selected == k then
			col = col_active
		else
			col = col_dark
		end

		self:DrawBarBg(x + margin, y + 51 * RayUI.Scale, width - 2 * margin, LineH, col)

		if not self:DrawWeapon(x, y, col, wep) then
			self:UpdateWeaponCache()
			return
		end

		y = y + (34 + 5) * RayUI.Scale
   end
end