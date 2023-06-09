-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

local function DrawTarget(tgt, size, offset, no_shrink)
   local scrpos = tgt.pos:ToScreen() -- sweet
   local sz = (IsOffScreen(scrpos) and (not no_shrink)) and size/2 or size

   scrpos.x = math.Clamp(scrpos.x, sz, ScrW() - sz)
   scrpos.y = math.Clamp(scrpos.y, sz, ScrH() - sz)
   
   if IsOffScreen(scrpos) then return end

   surface.DrawTexturedRect(scrpos.x - sz, scrpos.y - sz, sz * 2, sz * 2)

   if sz == size then
      local text = math.ceil(LocalPlayer():GetPos():Distance(tgt.pos))
      local w, h = surface.GetTextSize(text)

      surface.SetTextPos(scrpos.x - w/2, scrpos.y + (offset * sz) - h/2)
      surface.DrawText(text)

      if tgt.t then
         text = util.SimpleTime(tgt.t - CurTime(), "%02i:%02i")
         w, h = surface.GetTextSize(text)

         surface.SetTextPos(scrpos.x - w / 2, scrpos.y + sz / 2)
         surface.DrawText(text)
      elseif tgt.nick then
         text = tgt.nick
         w, h = surface.GetTextSize(text)

         surface.SetTextPos(scrpos.x - w / 2, scrpos.y + sz / 2)
         surface.DrawText(text)
      end
   end
end

local indicator   = surface.GetTextureID("effects/select_ring")
local c4warn      = surface.GetTextureID("vgui/ttt/icon_c4warn")
local sample_scan = surface.GetTextureID("vgui/ttt/sample_scan")
local det_beacon  = surface.GetTextureID("vgui/ttt/det_beacon")

local near_cursor_dist = 180

function RADAR:Draw(client)
	if not client then return end

	surface.SetFont("RayUI:Largest2")

	-- C4 warnings
	if self.bombs_count != 0 and client:IsActiveTraitor() then
		surface.SetTexture(c4warn)
		surface.SetTextColor(200, 55, 55, 220)
		surface.SetDrawColor(255, 255, 255, 200)

		for k, bomb in pairs(self.bombs) do
			DrawTarget(bomb, 24, 0, true)
		end
	end

	-- Corpse calls
	if client:IsActiveDetective() and #self.called_corpses then
		surface.SetTexture(det_beacon)
		surface.SetTextColor(255, 255, 255, 240)
		surface.SetDrawColor(255, 255, 255, 230)

		for k, corpse in pairs(self.called_corpses) do
			DrawTarget(corpse, 16, 0.5)
		end
	end

	-- Samples
	if self.samples_count != 0 then
		surface.SetTexture(sample_scan)
		surface.SetTextColor(200, 50, 50, 255)
		surface.SetDrawColor(255, 255, 255, 240)

		for k, sample in pairs(self.samples) do
			DrawTarget(sample, 16, 0.5, true)
		end
	end

	-- Player radar
	if (not self.enable) or (not client:IsActiveSpecial()) then return end

	surface.SetTexture(indicator)

	local remaining = math.max(0, RADAR.endtime - CurTime())
	local alpha_base = 50 + 180 * (remaining / RADAR.duration)

	local mpos = Vector(ScrW() / 2, ScrH() / 2, 0)

	local role, alpha, scrpos, md
	for k, tgt in pairs(RADAR.targets) do
		alpha = alpha_base

		scrpos = tgt.pos:ToScreen()
		if not scrpos.visible then
			continue
		end
		md = mpos:Distance(Vector(scrpos.x, scrpos.y, 0))
		if md < near_cursor_dist then
			alpha = math.Clamp(alpha * (md / near_cursor_dist), 40, 230)
		end

		role = tgt.role or ROLE_INNOCENT
		if role == ROLE_TRAITOR then
			surface.SetDrawColor(255, 0, 0, alpha)
			surface.SetTextColor(255, 0, 0, alpha)
		elseif role == ROLE_DETECTIVE then
			surface.SetDrawColor(0, 0, 255, alpha)
			surface.SetTextColor(0, 0, 255, alpha)
		elseif role == 3 then -- decoys
			surface.SetDrawColor(150, 150, 150, alpha)
			surface.SetTextColor(150, 150, 150, alpha)
		else
			surface.SetDrawColor(0, 255, 0, alpha)
			surface.SetTextColor(0, 255, 0, alpha)
		end

		DrawTarget(tgt, 24, 0)
	end

	-- Time until next scan
      
	local width = 370 * RayUI.Scale
	local height = 41 * RayUI.Scale
	local x = RayHUDTTT.OffsetX
	local y = select(2, RayHUDTTT:GetHUDPos()) - height - 10 * RayUI.Scale

	if LocalPlayer():WaterLevel() == 3 and RayUI.Configuration.GetConfig( "DrowningIndicator" ) then
		y = select(2, RayHUDTTT:GetHUDPos()) - height - x - 100 * RayUI.Scale
	end

	RayUI:DrawBlur2(x, y, width, height)

	draw.RoundedBox(RayUI.Rounding, x, y, width, height, Color(RayUI.Colors.Gray.r, RayUI.Colors.Gray.g, RayUI.Colors.Gray.b, RayUI.Opacity)) -- Panel
	draw.RoundedBoxEx(RayUI.Rounding, x, y, 46 * RayUI.Scale, height, RayUI:GetPlayerCol(), true, false, true, false) -- ColorIcon

 	-- Burger Menu
 	surface.SetMaterial( RayUI.Icons.Menu )
 	surface.SetDrawColor( RayUI.Colors.White )
 	surface.DrawTexturedRect(x + 8 * RayUI.Scale, y + 4 * RayUI.Scale, 34 * RayUI.Scale, 34 * RayUI.Scale) 

	local text = util.SimpleTime(remaining, "%02i:%02i")

	draw.SimpleText( "Radar: " .. text, "RayUI:Largest2", x + 56 * RayUI.Scale, y + 2 * RayUI.Scale, color_white )
	draw.SimpleText( "|  Targets: "..#RADAR.targets, "RayUI:Largest2", x + select(1, surface.GetTextSize( "Radar: 00:00  " )) + 56 * RayUI.Scale, y + 2 * RayUI.Scale, color_white )
end