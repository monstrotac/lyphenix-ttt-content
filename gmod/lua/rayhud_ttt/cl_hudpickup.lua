-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

local TryTranslation = LANG.TryTranslation

hook.Add("HUDWeaponPickedUp", "RayHUDTTT:WepPickup", function(wep)
	if not (IsValid(wep) and IsValid(LocalPlayer())) or (not LocalPlayer():Alive()) then return end
	GAMEMODE.HUDWeaponPickedUp = nil

	local name = TryTranslation(wep.GetPrintName and wep:GetPrintName() or wep:GetClass() or "Unknown Weapon Name")

	local pickup = {}
	pickup.time      = CurTime()
	pickup.name      = string.upper(name)
	pickup.holdtime  = 5
	pickup.font      = "RayUI:Medium"
	pickup.fadein    = 0.04
	pickup.fadeout   = 0.3
	pickup.icon      = RayUI.Icons.Pistol

	local role = LocalPlayer().GetRole and LocalPlayer():GetRole() or ROLE_INNOCENT
	pickup.color = RayUI:GetPlayerCol()

	pickup.upper = true

	surface.SetFont( pickup.font )
	local w, h = surface.GetTextSize( pickup.name )
	pickup.height = h
	pickup.width = w

	if (GAMEMODE.PickupHistoryLast >= pickup.time) then
		pickup.time = GAMEMODE.PickupHistoryLast + 0.05
	end

	table.insert( GAMEMODE.PickupHistory, pickup )
	GAMEMODE.PickupHistoryLast = pickup.time
end)

hook.Add("HUDItemPickedUp", "RayHUDTTT:ItemPickup", function(itemname)
	if not (IsValid(LocalPlayer()) and LocalPlayer():Alive()) then return end
	GAMEMODE.HUDItemPickedUp = nil

	local pickup = {}
	pickup.time = CurTime()
	pickup.name = "#"..itemname
	pickup.holdtime = 5
	pickup.font      = "RayUI:Medium"
	pickup.fadein    = 0.04
	pickup.fadeout   = 0.3
	pickup.color     = RayUI.Colors.Green
	pickup.icon      = RayUI.Icons.Cube

	pickup.upper = false

	surface.SetFont( pickup.font )
	local w, h = surface.GetTextSize( pickup.name )
	pickup.height = h
	pickup.width  = w

	if GAMEMODE.PickupHistoryLast >= pickup.time then
		pickup.time = GAMEMODE.PickupHistoryLast + 0.05
	end

	table.insert( GAMEMODE.PickupHistory, pickup )
	GAMEMODE.PickupHistoryLast = pickup.time
end)

hook.Add("HUDAmmoPickedUp", "RayHUDTTT:AmmoPickup", function(itemname, amount)
	if not (IsValid(LocalPlayer()) and LocalPlayer():Alive()) then return end
	GAMEMODE.HUDWeaponPickedUp = nil

	local itemname_trans = TryTranslation(string.lower("ammo_" .. itemname))

	if GAMEMODE.PickupHistory then

		local localized_name = string.upper(itemname_trans)
		for k, v in pairs( GAMEMODE.PickupHistory ) do
			if v.name == localized_name then
				v.time = CurTime() - v.fadein
				return
			end
		end
	end

	local pickup = {}
	pickup.time      = CurTime()
	pickup.name      = string.upper(itemname_trans)
	pickup.holdtime  = 5
	pickup.font      = "RayUI:Medium"
	pickup.fadein    = 0.04
	pickup.fadeout   = 0.3
	pickup.color     = RayUI.Colors.Orange
	pickup.amount    = 0
	pickup.icon      = RayUI.Icons.Ammo
 -- 76561198121455451
	surface.SetFont( pickup.font )
	local w, h = surface.GetTextSize( pickup.name )
	pickup.height = h
	pickup.width  = w

	local w, h = surface.GetTextSize( pickup.amount )
	pickup.xwidth = w
	pickup.width = pickup.width + w + 16 * RayUI.Scale

	if (GAMEMODE.PickupHistoryLast >= pickup.time) then
		pickup.time = GAMEMODE.PickupHistoryLast + 0.05
	end

	table.insert( GAMEMODE.PickupHistory, pickup )
	GAMEMODE.PickupHistoryLast = pickup.time
end)

hook.Add("HUDDrawPickupHistory", "RayHUDTTT:PickupHistory", function()
	if (not GAMEMODE.PickupHistory) then return end
	GAMEMODE.HUDDrawPickupHistory = nil

	local x, y = ScrW() - GAMEMODE.PickupHistoryWide - RayHUDTTT.OffsetX, GAMEMODE.PickupHistoryTop
	local tall = 0
	local wide = 0

	for k, v in pairs( GAMEMODE.PickupHistory ) do

		if v.time < CurTime() then

			if (v.y == nil) then v.y = y end

			v.y = (v.y * 5 + y) / 6

			local delta = (v.time + v.holdtime) - CurTime()
			delta = delta / v.holdtime

			local alpha = 255

			if delta > (1 - v.fadein) then
				alpha = math.Clamp( (1.0 - delta) * (255/v.fadein), 0, 255 )
			elseif delta < v.fadeout then
				alpha = math.Clamp( delta * (255/v.fadeout), 0, 255 )
			end

			v.x = x + GAMEMODE.PickupHistoryWide - (GAMEMODE.PickupHistoryWide * (alpha / 255))

			local rx = math.Round(v.x - 8 * RayUI.Scale)
			local ry = math.Round(v.y - 3 * RayUI.Scale)
			local rw = math.Round(GAMEMODE.PickupHistoryWide + 12 * RayUI.Scale)
			local rh = math.Round(v.height + 9 * RayUI.Scale)

			RayUI:DrawBlur2(rx, ry, rw, rh)

			draw.RoundedBoxEx( RayUI.Rounding, rx - rh, ry, rh, rh, Color(v.color.r, v.color.g, v.color.b, alpha), true, false, true, false )
			draw.RoundedBoxEx( RayUI.Rounding, rx, ry, rw, rh, Color(66, 66, 66, RayUI.Opacity * (alpha/255)), false, true, false, true )
			
			-- Burger Menu
			surface.SetMaterial( v.icon )
			surface.SetDrawColor( Color(255, 255, 255, alpha) )
			surface.DrawTexturedRect(rx - 24 * RayUI.Scale, ry + 4 * RayUI.Scale, 22 * RayUI.Scale, 22 * RayUI.Scale) 
		
			draw.SimpleText( v.name, v.font, v.x + 3 * RayUI.Scale, v.y, Color( 255, 255, 255, alpha ) )

			if v.amount then
				draw.SimpleText( v.amount, v.font, v.x + GAMEMODE.PickupHistoryWide - 20 * RayUI.Scale, v.y, Color( 255, 255, 255, alpha ), TEXT_ALIGN_RIGHT )
			end

			y = y + (v.height + 16 * RayUI.Scale)
			tall = tall + v.height + 18 * RayUI.Scale
			wide = math.Max( wide, v.width + v.height + 24 * RayUI.Scale )

			if alpha == 0 then GAMEMODE.PickupHistory[k] = nil end
		end
		
	end

	GAMEMODE.PickupHistoryTop = (GAMEMODE.PickupHistoryTop * 5 + ( ScrH() * 0.75 - tall ) / 2 ) / 6
	GAMEMODE.PickupHistoryWide = (GAMEMODE.PickupHistoryWide * 5 + wide) / 6
end)
