-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation

local function IdlePopup()
	local w, h = 380 * RayUI.Scale, 280 * RayUI.Scale

	local AFKPanel = vgui.Create("RayUI:MainPanel")
	AFKPanel:SetSize(w, h)
	AFKPanel:Center()
	AFKPanel:MakePopup()

	local idle_limit = GetGlobalInt("ttt_idle_limit", 300) or 300

	local inner = vgui.Create("DPanel", AFKPanel)
	inner:StretchToParent(10 * RayUI.Scale, 60 * RayUI.Scale, 10 * RayUI.Scale, 60 * RayUI.Scale)
	inner.Paint = function(self, w, h)
		draw.RoundedBox(RayUI.Rounding - 4, 0, 0, w, h, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 20))
	end

	local text = vgui.Create("DLabel", inner)
	text:SetWrap(true)
	text:SetFont("RayUI:Small")
	text:SetText(GetPTranslation("idle_popup", {num = idle_limit, helpkey = Key("gm_showhelp", "F1")}))
	text:StretchToParent(10 * RayUI.Scale, 0 * RayUI.Scale, 10 * RayUI.Scale, 5 * RayUI.Scale)

	local ButtonsPanel = vgui.Create("DPanel", AFKPanel)
	ButtonsPanel:Dock(BOTTOM)
	ButtonsPanel:SetTall(40 * RayUI.Scale)
	ButtonsPanel:DockMargin(10 * RayUI.Scale, 0, 10 * RayUI.Scale, 10 * RayUI.Scale)
	ButtonsPanel.Paint = function(self, w, h) end

	local bw, bh = 130 * RayUI.Scale, 35 * RayUI.Scale

	local cancel = vgui.Create("DButton", ButtonsPanel)
	cancel:SetTextColor(RayUI.Colors.White)
	cancel:SetFont("RayUI:Small2")
	cancel:Dock(LEFT)
	cancel:SetWide(120 * RayUI.Scale)
	cancel.DoClick = function(self)
		AFKPanel:Remove()
	end
	cancel:FormatRayButton(GetTranslation("idle_popup_close"), RayUI.Colors.DarkGray3, RayUI.Colors.Red)

	local disable = vgui.Create("DButton", ButtonsPanel)
	disable:SetFont("RayUI:Small")
	disable:SetTextColor(RayUI.Colors.White)
	disable:Dock(RIGHT)
	disable:SetWide(220 * RayUI.Scale)
	disable.DoClick = function(self)
		RunConsoleCommand("ttt_spectator_mode", "0")
		AFKPanel:Remove()
	end
	disable:FormatRayButton(GetTranslation("idle_popup_off"), RayUI.Colors.DarkGray3, RayUI.Colors.Green)

	AFKPanel:MakePopup()
end
concommand.Add("ttt_cl_idlepopup", IdlePopup)