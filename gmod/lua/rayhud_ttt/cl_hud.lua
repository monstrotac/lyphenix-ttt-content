-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

local GetLang = LANG.GetUnsafeLanguageTable
local interp = string.Interp

local ply = LocalPlayer()

local MainWidth = 370 * RayUI.Scale
local height = 170 * RayUI.Scale

RayHUDTTT.OffsetX = RayUI.Configuration and isnumber(RayUI.Configuration.GetConfig( "TTTOffsetX" )) and RayUI.Configuration.GetConfig( "TTTOffsetX" ) * RayUI.Scale or 0
RayHUDTTT.OffsetY = RayUI.Configuration and isnumber(RayUI.Configuration.GetConfig( "TTTOffsetY" )) and RayUI.Configuration.GetConfig( "TTTOffsetY" ) * RayUI.Scale or 0

local x = RayHUDTTT.OffsetX
local y = ScrH() - height - RayHUDTTT.OffsetY

local TimePanelW = 160 * RayUI.Scale

local LeftPanel = 0

local SmoothHealth = 0
local SmoothAmmo = 0
local SmoothPunch = 0

local alpha1 = 255

local roundstate_string = {
	[ROUND_WAIT]   = "round_wait",
	[ROUND_PREP]   = "round_prep",
	[ROUND_ACTIVE] = "round_active",
	[ROUND_POST]   = "round_post"
}

local function GetAmmo(ply)
	local weap = ply:GetActiveWeapon()
	if not weap or not ply:Alive() then return -1 end

	local ammo_inv = weap:Ammo1() or 0
	local ammo_clip = weap:Clip1() or 0
	local ammo_max = weap.Primary.ClipSize or 0

	return ammo_clip, ammo_max, ammo_inv
end
 -- 76561198121455451
local HPText = "HP: "..LocalPlayer():Health().." / "..LocalPlayer():GetMaxHealth()
local StaminaText = "Stamina"

local function PunchPaint(ply)
	local L = GetLang()
	local punch = ply:GetNWFloat("specpunches", 0)
	SmoothPunch = Lerp(5 * FrameTime(), SmoothPunch, punch)

	local width, height = 260 * RayUI.Scale, 90 * RayUI.Scale
	local x = ScrW() / 2 - width / 2
	local y = 60 * RayUI.Scale
	local BarWidth = 190 * RayUI.Scale
	local BarX = ScrW() / 2 - BarWidth / 2 + 13 * RayUI.Scale

	draw.SimpleText(L.punch_help, "RayUI:Large", ScrW() / 2, 10 * RayUI.Scale, COLOR_WHITE, TEXT_ALIGN_CENTER)
	
	RayUI:DrawMaterialBox(L.punch_title, x, y, width, height, RayUI.Colors.Orange)
	RayUI:CreateBar(BarX, y + 58 * RayUI.Scale, BarWidth, 11, RayUI.Colors.LightOrange, RayUI.Colors.Orange, SmoothPunch, HPText, RayUI.Icons.Cube)

	local bonus = ply:GetNWInt("bonuspunches", 0)
	if bonus != 0 then
		local text
		if bonus < 0 then
			text = interp(L.punch_bonus, {num = bonus})
		else
			text = interp(L.punch_malus, {num = bonus})
		end
		draw.SimpleText(text, "RayUI:Large", ScrW() / 2, y + 100 * RayUI.Scale, COLOR_WHITE, TEXT_ALIGN_CENTER)
	end
end

function RayHUDTTT:GetHUDPos()
	return x, y
end

hook.Add("HUDPaint", "RayHUDTTT:HUDPaint", function()
	GAMEMODE.HUDPaint = nil

	local L = GetLang()
	local ply = LocalPlayer()
	
	local time_y = y + 32 
	local label
	
	RayUI:DrawBlur2(x, y, MainWidth, height)

	if SpecDM and ply:IsGhost() then
		label = "SpecDM"
	elseif GAMEMODE.round_state == ROUND_ACTIVE and !(ply:Team() == TEAM_SPEC and !(SpecDM and ply:IsGhost())) then
		label = L[ ply:GetRoleStringRaw() ]
	elseif ply:Team() == TEAM_SPEC and !(SpecDM and ply:IsGhost()) then
		label = L[ roundstate_string[GAMEMODE.round_state] ]
	else
		label = ""
	end

	if ply:HasEquipmentItem(EQUIP_ARMOR) or ply:HasEquipmentItem(EQUIP_DISGUISE) or ply:HasEquipmentItem(EQUIP_RADAR) then
		LeftPanel = Lerp( 10 * FrameTime(), LeftPanel, 46 * RayUI.Scale )
	else
		LeftPanel = Lerp( 10 * FrameTime(), LeftPanel, 0 )
	end

	RayUI:DrawMaterialBox(label, x, y, MainWidth, height)
	draw.RoundedBoxEx(RayUI.Rounding, x + LeftPanel, y + math.Round(41 * RayUI.Scale), TimePanelW, height - math.Round(41 * RayUI.Scale), Color(RayUI.Colors.DarkGray.r, RayUI.Colors.DarkGray.g, RayUI.Colors.DarkGray.b, (math.Round(alpha1) == 255 and RayUI.Opacity + 20 or alpha1)), false, false, true, false) -- Left Part
	draw.RoundedBoxEx(RayUI.Rounding, x, y + math.Round(41 * RayUI.Scale), LeftPanel, height - math.Round(41 * RayUI.Scale), Color(RayUI.Colors.DarkGray2.r, RayUI.Colors.DarkGray2.g, RayUI.Colors.DarkGray2.b, RayUI.Opacity + 20), false, false, true, false)

	-- Armor Icon
	if ply:HasEquipmentItem(EQUIP_ARMOR) then
		surface.SetMaterial( RayUI.Icons.Shield )
		surface.SetDrawColor( 250, 250, 250, alpha1 )
		surface.DrawTexturedRect(x + LeftPanel / 2 - (34 * RayUI.Scale) / 2, y + 48 * RayUI.Scale, 34 * RayUI.Scale, 34 * RayUI.Scale) 
	end
	
	-- Radar Icon
	if ply:HasEquipmentItem(EQUIP_RADAR) then
		surface.SetMaterial( RayUI.Icons.Radar )
		surface.SetDrawColor( 250, 250, 250, alpha1 )
		surface.DrawTexturedRect(x + LeftPanel / 2 - (34 * RayUI.Scale) / 2, y + 87 * RayUI.Scale, 34 * RayUI.Scale, 34 * RayUI.Scale) 
	end

	-- Disguiser Icon
	if ply:HasEquipmentItem(EQUIP_DISGUISE) then
		surface.SetMaterial( RayUI.Icons.Gesture )
		if ply:GetNWBool("disguised") then
			surface.SetDrawColor( 250, 250, 250, alpha1 )
		else
			surface.SetDrawColor( 66, 66, 66, alpha1 )
		end
		surface.DrawTexturedRect(x + LeftPanel / 2 - (34 * RayUI.Scale) / 2, y + 126 * RayUI.Scale, 34 * RayUI.Scale, 34 * RayUI.Scale) 
	end

	local BarW = 150 * RayUI.Scale


	local HealthY, AmmoY = y + 80 * RayUI.Scale, y + 126 * RayUI.Scale

	-- TTT Sprint (https://github.com/FreshGarry/TTT-Sprint)
	if TTTSprint then
		HealthY, AmmoY = y + 68 * RayUI.Scale, y + 140 * RayUI.Scale
		RayUI:CreateBar(x + BarW + 54 * RayUI.Scale + LeftPanel * 0.88, y + 105 * RayUI.Scale, 150 * RayUI.Scale - LeftPanel  * 0.70, 11, Color(255, 238, 88, alpha1), Color(255, 193, 7, alpha1), (TTTSprint.percent) / 100, StaminaText, RayUI.Icons.Run )
	end

	-- Health Bar
	SmoothHealth = Lerp(5 * FrameTime(), SmoothHealth, LocalPlayer():Health())
	local hl = math.Clamp(SmoothHealth, 1, LocalPlayer():GetMaxHealth()) / LocalPlayer():GetMaxHealth()
	
	local Var = math.Clamp(  math.abs( math.sin( CurTime() * 5 ) ), 0.75, 1 )
	local HPColor = Color( 198, 40, 40, alpha1 )
	if ply:Health() <= 20 then
		HPColor = Color( Var * 198, Var * 40, Var * 40, alpha1 )
	end
	RayUI:CreateBar(x + BarW + 54 * RayUI.Scale + LeftPanel * 0.88, HealthY, 150 * RayUI.Scale - LeftPanel * 0.7, 11, Color(229, 115, 115, alpha1), HPColor, hl, HPText, RayUI.Icons.Heart)

	-- Ammo Bar
	if ply:GetActiveWeapon().Primary then
		local ammo_clip, ammo_max, ammo_inv = GetAmmo(ply)
		
		if ammo_clip != -1 then
			SmoothAmmo = Lerp(5 * FrameTime(), SmoothAmmo, ammo_clip/ammo_max)
			AmmoText = "Ammo: "..ammo_clip.." / "..ammo_inv
			RayUI:CreateBar(x + BarW + 54 * RayUI.Scale + LeftPanel * 0.88, AmmoY, 150 * RayUI.Scale - LeftPanel  * 0.70, 11, Color(255, 183, 77, alpha1), Color(239, 108, 0, alpha1), SmoothAmmo, AmmoText, RayUI.Icons.Ammo )
		end
	end

	-- Draw round time
	local font = "HealthAmmo"
	local color = Color(250, 250, 250, alpha1)
	local round_state = GAMEMODE.round_state
	local endtime = GetGlobalFloat("ttt_round_end", 0) - CurTime()

	if HasteMode() and round_state == ROUND_ACTIVE then
		local hastetime = GetGlobalFloat("ttt_haste_end", 0) - CurTime()
		if hastetime < 0 then
			if (not ply:IsActiveTraitor()) or (math.ceil(CurTime()) % 7 <= 2) then
				text = L.overtime
			else
				text  = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
				color = COLOR_RED
			end
		else
			local t = hastetime
			if ply:IsActiveTraitor() and math.ceil(CurTime()) % 6 < 2 then
				t = endtime
				color = COLOR_RED
			end
			text = util.SimpleTime(math.max(0, t), "%02i:%02i")
		end
	else
		text = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
	end

	surface.SetFont( "RayUI:Largest" )
	draw.SimpleText(L[ roundstate_string[round_state] ], "RayUI:Largest", x + TimePanelW / 2 - select(1, surface.GetTextSize( L[ roundstate_string[round_state] ] )) / 2 + LeftPanel, y + 48 * RayUI.Scale, Color(250, 250, 250, alpha1))

	surface.SetMaterial( RayUI.Icons.Clock )
	surface.SetDrawColor( Color(250, 250, 250, alpha1) )
	surface.DrawTexturedRect(x + TimePanelW / 2 - (32 * RayUI.Scale) / 2 + LeftPanel, y + 90 * RayUI.Scale, 32 * RayUI.Scale, 32 * RayUI.Scale )

	surface.SetFont( "RayUI:Largest" )
	draw.SimpleText(text, "RayUI:Largest", x + TimePanelW / 2 - select(1, surface.GetTextSize( text )) / 2 + LeftPanel, y + 124 * RayUI.Scale, color)

	local alive = 0
	local not_found = 0
	local found = 0	

	for k, v in pairs( player.GetAll() ) do
		if v:Alive() and !v:IsSpec() then
			alive = alive + 1
		elseif !v:Alive() and !v:GetNWBool("body_found") then
			not_found = not_found + 1
		elseif !v:Alive() and v:GetNWBool("body_found") then
			found = found + 1
		end
	end
	
	surface.SetFont( "RayUI:Largest2" )
	local tw = 0
	
	if (SpecDM and !ply:IsGhost()) or !SpecDM then
		if ply:GetTraitor() then
			tw = select( 1, surface.GetTextSize( alive.." / "..alive + not_found + found ) )
			draw.SimpleText( alive.." / "..alive + not_found + found, "RayUI:Largest2", x + MainWidth - tw - 50 * RayUI.Scale, y + 4 * RayUI.Scale, Color(255, 255, 255, alpha1) )
		else
			tw = select( 1, surface.GetTextSize( alive + not_found.." / "..alive + not_found + found ) )
			draw.SimpleText( alive + not_found.." / "..alive + not_found + found, "RayUI:Largest2", x + MainWidth - tw - 50 * RayUI.Scale, y + 4 * RayUI.Scale, Color(255, 255, 255, alpha1) )
		end
	
		surface.SetMaterial( RayUI.Icons.User )
		surface.SetDrawColor( 250, 250, 250, alpha1 )
		surface.DrawTexturedRect(x + MainWidth - 40 * RayUI.Scale, y + 5 * RayUI.Scale, 32 * RayUI.Scale, 32 * RayUI.Scale )
	end

	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTSpecHUD" ) then
		if ply:Team() == TEAM_SPEC and !(SpecDM and ply:IsGhost()) then

			MainWidth = Lerp( 10 * FrameTime(), MainWidth, 210 * RayUI.Scale )
			height = Lerp( 4 * FrameTime(), height, 86 * RayUI.Scale )

			y = Lerp( 100 * FrameTime(), y, ScrH() - height - x )

			alpha1 = Lerp( 10 * FrameTime(), alpha1, 0 )
			HPText = ""
			StaminaText = ""

			local key_params = { usekey = Key("+use", "USE") }
	
			-- Time stuff
			local text = util.SimpleTime(math.max(0, GetGlobalFloat("ttt_round_end", 0) - CurTime()), "%02i:%02i")
			draw.SimpleText(text, "RayUI.Normal:Largest2", x + 48 * RayUI.Scale, y + 45 * RayUI.Scale, RayUI.Colors.White)

			-- Clock Icon
			surface.SetMaterial( RayUI.Icons.Clock )
			surface.SetDrawColor( RayUI.Colors.White )
			surface.DrawTexturedRect(x + 11 * RayUI.Scale, y + 50 * RayUI.Scale, 28 * RayUI.Scale, 28 * RayUI.Scale )

			local Target = ply:GetObserverTarget()
			if IsValid(Target) and Target:IsPlayer() then
				draw.SimpleText(Target:Nick(), "RayUI:Large", ScrW() / 2, 10 * RayUI.Scale, RayUI.Colors.White)
			elseif IsValid(Target) and Target:GetNWEntity("spec_owner", nil) == ply then
			  PunchPaint(ply)
			else
				draw.SimpleText(interp(L.spec_help, key_params), "RayUI:Large", ScrW() / 2, 10 * RayUI.Scale, RayUI.Colors.White, TEXT_ALIGN_CENTER)
			end
		else
			MainWidth = Lerp( 4 * FrameTime(), MainWidth, 370 * RayUI.Scale )
			height = Lerp( 4 * FrameTime(), height, 170 * RayUI.Scale )

			y = Lerp( 100 * FrameTime(), y, ScrH() - height - x )

			alpha1 = Lerp( 10 * FrameTime(), alpha1, 255 )

			HPText = "HP: "..LocalPlayer():Health().." / "..LocalPlayer():GetMaxHealth()
			StaminaText = "Stamina"
		end
	end

	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTTargetID" ) then
		hook.Call( "HUDDrawTargetID", GAMEMODE )
	end
   
	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTMStack" ) then
		MSTACK:Draw(ply)
	end

	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTRadar" ) then
		RADAR:Draw(ply)
	end
   
	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTTButton" ) then
		TBHUD:Draw(ply)
	end
   
	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTWSwitch" ) then
		WSWITCH:Draw(ply)
	end

	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTVoice" ) then
		VOICE.Draw(ply)
	end
	
	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTPickupHistory" ) then
		hook.Call( "HUDDrawPickupHistory", GAMEMODE )
	end
end)