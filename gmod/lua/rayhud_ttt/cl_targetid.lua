-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

local GetPTranslation = LANG.GetParamTranslation
local GetRaw = LANG.GetRawTranslation

local key_params = {usekey = Key("+use", "USE"), walkkey = Key("+walk", "WALK")}

surface.CreateFont("TargetID", {font = "Caviar Dreams Bold", size = 18, extended = true})
surface.CreateFont("TargetIDSmall2", {font = "Caviar Dreams Bold", size = 14, extended = true})

local ClassHint = {
   prop_ragdoll = {
      name= "corpse",
      hint= "corpse_hint",

      fmt = function(ent, txt) return GetPTranslation(txt, key_params) end
   }
};

local healthcolors = {
	healthy = Color(170, 225, 100),
	hurt    = Color(170, 230, 10),
	wounded = Color(230, 215, 10),
	badwound= Color(255, 140, 0),
	death   = Color(205, 60, 40)
	};

function util.HealthToString(health, maxhealth)
	maxhealth = maxhealth or 100

	if health > maxhealth * 0.9 then
		return "hp_healthy", healthcolors.healthy
	elseif health > maxhealth * 0.7 then
		return "hp_hurt", healthcolors.hurt
	elseif health > maxhealth * 0.45 then
		return "hp_wounded", healthcolors.wounded
	elseif health > maxhealth * 0.2 then
		return "hp_badwnd", healthcolors.badwound
	else
		return "hp_death", healthcolors.death
	end
end
   
local healthcolors2 = {
	healthy = Color(130, 140, 60),
	hurt    = Color(130, 130, 0),
	wounded = Color(140, 140, 0),
	badwound= Color(185, 90, 0),
	death   = Color(100, 40, 20)
};

function util.HealthToString2(health, maxhealth)
	maxhealth = maxhealth or 100

	if health > maxhealth * 0.9 then
		return "hp_healthy", healthcolors2.healthy
	elseif health > maxhealth * 0.7 then
		return "hp_hurt", healthcolors2.hurt
	elseif health > maxhealth * 0.45 then
		return "hp_wounded", healthcolors2.wounded
	elseif health > maxhealth * 0.2 then
		return "hp_badwnd", healthcolors2.badwound
	else
		return "hp_death", healthcolors2.death
	end
end
-- 76561198121455451
local function DrawPropSpecLabels(ply)
   if (not ply:IsSpec()) and (GetRoundState() != ROUND_POST) then return end

   surface.SetFont("TargetID")

	local tgt = nil
	local scrpos = nil
	local text = nil
	local w = 0
	local _, healthcolor
	
	for _, ply in pairs(player.GetAll()) do
		if ply:IsSpec() then
			healthcolor = Color(220,200,0,120)

			tgt = ply:GetObserverTarget()

			if IsValid(tgt) and tgt:GetNWEntity("spec_owner", nil) == ply then

				scrpos = tgt:GetPos():ToScreen()
			else
				scrpos = nil
			end
		else
			_, healthcolor = util.HealthToString(ply:Health(), ply:GetMaxHealth())
			scrpos = ply:EyePos()
			scrpos.z = scrpos.z + 20

			scrpos = scrpos:ToScreen()
		end

		if scrpos and (not IsOffScreen(scrpos)) then
			text = ply:Nick()
			w, _ = surface.GetTextSize(text)

			draw.SimpleText( text, "TargetIDSmall2", scrpos.x - w / 2 + 1, scrpos.y + 1, COLOR_BLACK )
			draw.SimpleText( text, "TargetIDSmall2", scrpos.x - w / 2, scrpos.y, healthcolor )
		end
	end
end

local minimalist = CreateConVar("ttt_minimal_targetid", "0", FCVAR_ARCHIVE)

local magnifier_mat = Material("icon16/magnifier.png")
local ring_tex = surface.GetTextureID("effects/select_ring")

local rag_color = Color(200,200,200,255)

local GetLang = LANG.GetUnsafeLanguageTable

local MAX_TRACE_LENGTH = math.sqrt(3) * 2 * 16384

local SmoothHealth = 0














hook.Add("HUDDrawTargetID", "RayHUDTTT:DrawTargetID", function()
	GAMEMODE.HUDDrawTargetID = nil
	local ply = LocalPlayer()

	local L = GetLang()

	if hook.Call( "HUDShouldDraw", GAMEMODE, "TTTPropSpec" ) then
		DrawPropSpecLabels(ply)
	end

	local startpos = ply:EyePos()
	local endpos = ply:GetAimVector()
	endpos:Mul(MAX_TRACE_LENGTH)
	endpos:Add(startpos)

	local trace = util.TraceLine({
		start = startpos,
		endpos = endpos,
		mask = MASK_SHOT,
		filter = ply:GetObserverMode() == OBS_MODE_IN_EYE and {ply, ply:GetObserverTarget()} or ply
	})
	local ent = trace.Entity
	if (not IsValid(ent)) or ent.NoTarget then return end

	-- some bools for caching what kind of ent we are looking at
	local target_traitor = false
	local target_detective = false
	local target_corpse = false

	local text = nil
	local color = RayUI.Colors.White2

	-- if a vehicle, we identify the driver instead
	if IsValid(ent:GetNWEntity("ttt_driver", nil)) then
		ent = ent:GetNWEntity("ttt_driver", nil)

		if ent == ply then return end
	end

	local cls = ent:GetClass()
	local minimal = minimalist:GetBool()
	local hint = (not minimal) and (ent.TargetIDHint or ClassHint[cls])

	if ent:IsPlayer() then
		if ent:GetNWBool("disguised", false) then
			ply.last_id = nil

			if ply:IsTraitor() or ply:IsSpec() then
				text = ent:Nick() .. L.target_disg
			else
				return
			end

			color = COLOR_RED
		else
			text = ent:Nick()
			ply.last_id = ent
		end

		local _ -- Stop global clutter

		-- in minimalist targetID, colour nick with health level
		if minimal and ent.sb_tag and ent.sb_tag.txt != nil then
			_, color = ent.sb_tag.txt, ent.sb_tag.color
		end

		if ply:IsTraitor() and GetRoundState() == ROUND_ACTIVE then
			target_traitor = ent:IsTraitor()
		end

		target_detective = GetRoundState() > ROUND_PREP and ent:IsDetective() or false
	elseif cls == "prop_ragdoll" then
		if CORPSE.GetPlayerNick(ent, false) == false then return end

		target_corpse = true

		if CORPSE.GetFound(ent, false) or not DetectiveMode() then
			text = CORPSE.GetPlayerNick(ent, "A Terrorist")
		else
			text  = L.target_unid
			color = COLOR_YELLOW
		end
	elseif not hint then
		return
	end

	local x_orig = ScrW() / 2
	local x = x_orig
	local y = ScrH() / 2

	local w, h = 0,0

	if target_traitor or target_detective then
		surface.SetTexture(ring_tex)

		if target_traitor then
			surface.SetDrawColor(255, 0, 0, 200)
		else
			surface.SetDrawColor(0, 0, 255, 220)
		end
		surface.DrawTexturedRect(x-24, y-24, 48, 48)
	end

	y = y + 30 * RayUI.Scale
	local font = "RayUI:Medium"
	surface.SetFont( font )

	-- Draw main title, ie. nickname
	if text then

		w, h = surface.GetTextSize( text )
		x = x - w / 2

		local PanelW = 20 * RayUI.Scale
		local PanelH = 4 * RayUI.Scale

		draw.RoundedBox(14, x - PanelW / 2, y - PanelH / 2 + 1, w + PanelW, h + PanelH, RayUI.Colors.DarkGray2 )
		
		draw.SimpleText( text, "RayUI:Medium", x + 1, y + 1, COLOR_BLACK )
		draw.SimpleText( text, "RayUI:Medium", x, y, color )

		SmoothHealth = Lerp(5 * FrameTime(), SmoothHealth, ent:Health())
		local hl = math.Clamp(SmoothHealth, 1, ent:GetMaxHealth()) / ent:GetMaxHealth()
		local clr = rag_color
		text, clr = util.HealthToString(ent:Health(), ent:GetMaxHealth())
		text2, clr2 = util.HealthToString2(ent:Health(), ent:GetMaxHealth())

		local HealthW = 70 * RayUI.Scale
	
		local xHP = (ScrW() / 2) - HealthW / 2
		local yHP = 28 * RayUI.Scale
--		
		if ent:IsPlayer() and ent:Health() > 0 then
			draw.RoundedBox( 5, xHP - 1 * RayUI.Scale, y + yHP - 1 * RayUI.Scale, HealthW + 2 * RayUI.Scale, 10 * RayUI.Scale + 1 * RayUI.Scale, Color(0, 0, 0) )

			draw.RoundedBox( 5, xHP, y + yHP, HealthW, 9 * RayUI.Scale, clr2 ) -- Background
			draw.RoundedBox( 5, xHP, y + yHP, HealthW * hl, 9 * RayUI.Scale, clr ) -- Fill
		end

		if !ent:IsPlayer() and ent.search_result and ply:IsDetective() then
			surface.SetMaterial(magnifier_mat)
			surface.SetDrawColor(200, 200, 255, 255)
			surface.DrawTexturedRect(x + w + 14 * RayUI.Scale, y + 6 * RayUI.Scale, 16 * RayUI.Scale, 16 * RayUI.Scale)
		end




	end

	-- Minimalist target ID only draws a health-coloured nickname, no hints, no karma, no tag
	if minimal then return end

	local clr = rag_color
	if ent:IsPlayer() then
		text, clr = util.HealthToString(ent:Health(), ent:GetMaxHealth())
		text = L[text]
	elseif hint then
		text = GetRaw(hint.name) or hint.name
	else
		return
	end
	font = "RayUI:Small"
	surface.SetFont( font )

	w, h = surface.GetTextSize( text )
	x = (x_orig - w / 2) - 2

	if !ent:IsPlayer() then
		draw.SimpleText( text, font, x + 1, y + 26 * RayUI.Scale, COLOR_BLACK )
		draw.SimpleText( text, font, x, y + 25 * RayUI.Scale, clr )
	end




   -- Draw second subtitle: karma
   if ent:IsPlayer() and KARMA.IsEnabled() then
      text, clr = util.KarmaToString(ent:GetBaseKarma())

      text = L[text]

      w, h = surface.GetTextSize( text )
      y = y + h + 20 * RayUI.Scale
      x = x_orig - w / 2

      draw.SimpleText( text, font, x + 1, y + 1, COLOR_BLACK )
      draw.SimpleText( text, font, x, y, clr )
   end







	if hint and hint.hint then
		if not hint.fmt then
			text = GetRaw(hint.hint) or hint.hint
		else
			text = hint.fmt(ent, hint.hint)
		end

		w, h = surface.GetTextSize(text)
		x = x_orig - w / 2
		y = y + h + 26 * RayUI.Scale
		draw.SimpleText( text, font, x + 1, y + 1, COLOR_BLACK )
		draw.SimpleText( text, font, x, y, COLOR_LGRAY )
	end







	text = nil
	
	y = y + h + 0 * RayUI.Scale

	if target_traitor then
		text = L.target_traitor
		clr = COLOR_RED
	elseif target_detective then
		text = L.target_detective
		clr = COLOR_BLUE
	elseif ent.sb_tag and ent.sb_tag.txt != nil then
		text = L[ ent.sb_tag.txt ]
		clr = ent.sb_tag.color
	elseif target_corpse and ply:IsActiveTraitor() and CORPSE.GetCredits(ent, 0) > 0 then
		text = L.target_credits
		clr = COLOR_YELLOW
	end

	if text then
		w, h = surface.GetTextSize( text )
		x = x_orig - w / 2

		draw.SimpleText( text, font, x + 1, y + 1, COLOR_BLACK )
		draw.SimpleText( text, font, x, y, clr )
	end
end)