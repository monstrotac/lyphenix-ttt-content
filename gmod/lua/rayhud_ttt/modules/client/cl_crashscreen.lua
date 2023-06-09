-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

RunConsoleCommand("cl_timeout", 100)

local BackgroundCol = Color(34, 34, 34, 250)

local Background = vgui.Create("DPanel")
Background:SetSize(ScrW(), ScrH())
Background:SetAlpha(0)
Background:SetVisible(false)
Background.Paint = function( self, w, h )
	RayUI:DrawBlur(self)
	draw.RoundedBox(0, 0, 0, w, h, BackgroundCol)
end

local CrashTall = 625 * RayUI.Scale
local SepWide = 2 * RayUI.Scale

local SepPosX = (Background:GetWide() - 600 * RayUI.Scale)
local SepPosY = Background:GetTall() / 2 - CrashTall / 2

local RightWide = ScrW() - SepPosX - SepWide
local LeftWide = ScrW() - RightWide - SepWide

local IconSize = 180 * RayUI.Scale

local Separator = vgui.Create("DPanel", Background)
Separator:SetSize(SepWide, 0)
Separator:SetPos(SepPosX, SepPosY)
Separator.Paint = function( s, w, h )
	draw.RoundedBox(0, 0, 0, w, h, RayUI.Colors.White)
end

local LeftPanel = vgui.Create("DPanel", Background)
LeftPanel:SetSize(LeftWide, CrashTall)
LeftPanel:SetPos(0, SepPosY)
LeftPanel.Paint = function( s, w, h )
end

local InnerLeftPanel = vgui.Create("DPanel", LeftPanel)
InnerLeftPanel:SetSize(LeftWide, CrashTall)
InnerLeftPanel:SetPos(LeftWide, 0)
InnerLeftPanel.Paint = function( s, w, h )
	surface.SetMaterial( RayUI.Icons.ConnectionLost )
	surface.SetDrawColor( RayUI.Colors.White )
	surface.DrawTexturedRect(LeftWide / 2 - IconSize / 2, 100 * RayUI.Scale, IconSize, IconSize)

	draw.SimpleText(RayUI.GetPhrase("hud", "connection_lost"), "RayUI:Largest7", w / 2, 250 * RayUI.Scale, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText(RayUI.GetPhrase("hud", "lost_connection"), "RayUI:Largest6", w / 2, 380 * RayUI.Scale, RayUI.Colors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	draw.SimpleText(RayUI.GetPhrase("hud", "reconnected"), "RayUI:Largest6", w / 2, 420 * RayUI.Scale, RayUI.Colors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

local ButW = 250 * RayUI.Scale
local ButH = 80 * RayUI.Scale

local RightPanel = vgui.Create("DPanel", Background)
RightPanel:SetSize(0, CrashTall)
RightPanel:SetPos( SepPosX + SepWide, SepPosY)
RightPanel:SetPaintBackground( false )

local Buttons = {
	{
		Name = "Reconnect",
		func = function() return RunConsoleCommand("retry") end
	},
	{
		Name = "Leave",
		func = function() return RunConsoleCommand("disconnect") end
	},
}

for i = 1, #Buttons do
	local but = Buttons[i]
	if i == 2 then ButtonColor = RayUI.Colors.HP end

	local Button = vgui.Create("DButton", RightPanel)
	Button:SetSize(ButW, ButH)
	Button:SetPos(RightWide / 2 - ButW / 2, RightPanel:GetTall() / 2 - ButH / 2 + (ButH + 20) * i - (ButH - 20) * #Buttons)
	Button.DoClick = function()
		but.func()
	end
	Button:FormatRayButton(but.Name, RayUI.Colors.Gray2, i == 1 and RayUI.Colors.Green or RayUI.Colors.HP)
	Button:SetFont("RayUI:Largest6")
end
-- 76561198121455451
local lastPing = os.time()
RayHUDTTT.Disconnected = false

net.Receive("RayHUDTTT:UpdateConnectonStatus", function()
	lastPing = os.time()

	if Background:IsVisible() and IsValid(Background) and RayHUDTTT.Disconnected == false then
		InnerLeftPanel:MoveTo(LeftWide, 0, 0.6)
		RightPanel:SizeTo(0, CrashTall, 0., 0, -1, function()
			Separator:SizeTo(SepWide, 0, 0.6)
			Background:AlphaTo(0, 0.6, 0, function()
				Background:SetVisible(false)
				gui.EnableScreenClicker(false)
			end)
		end)
	end
	RayHUDTTT.Disconnected = false
end)

local nextCheck = 0
hook.Add("Think", "RayHUDTTT:CheckConnectonStatus", function()
	if !RayUI.Configuration.GetConfig( "CrashScreenTTT" ) then return end

	if nextCheck <= CurTime() then
		nextCheck = CurTime() + 2

		if os.time() - lastPing > 5 and RayHUDTTT.Disconnected == false then
			RayHUDTTT.Disconnected = true

			Background:SetVisible(true)
			Background:AlphaTo(255, 0.6, 0)
			Separator:SizeTo(SepWide, CrashTall, 0.6, 0, -1, function()
				InnerLeftPanel:MoveTo(0, 0, 1)
				RightPanel:SizeTo(RightWide, CrashTall, 1)

				gui.EnableScreenClicker(true)
			end)
		end
	end
end)