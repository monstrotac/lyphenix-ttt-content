-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

local T = LANG.GetTranslation
local PT = LANG.GetParamTranslation

function CLSCORE:FillDList(dlst)
	for k, e in pairs(self.Events) do

		local etxt = self:TextForEvent(e)
		local eicon, ttip = self:IconForEvent(e)
		local etime = self:TimeForEvent(e)

		if etxt then
			if eicon then
				local mat = eicon
				eicon = vgui.Create("DPanel")
				eicon:SetTooltip(ttip)

				eicon.Paint = function(self, w, h)
					surface.SetMaterial( mat )
					surface.SetDrawColor( RayUI.Colors.White )
					surface.DrawTexturedRect((w - 20 * RayUI.Scale) / 2, (h - 20 * RayUI.Scale) / 2, 20 * RayUI.Scale, 20 * RayUI.Scale)
				end
			end

			local list = dlst:AddLine(etime, eicon, etxt)
			list:FormatListLine(1, 1)
			list:FormatListLine(3, 3)
		end
	end
end

function CLSCORE:BuildEventLogPanel(dpanel) -- 76561198121455451
	local margin = 10

	local dlist = vgui.Create("DListView", dpanel)
	dlist:Dock(FILL)
	dlist:DockMargin(1 * RayUI.Scale, 1 * RayUI.Scale, 1 * RayUI.Scale, 0)
	dlist:SetSortable(true)
	dlist:SetMultiSelect(false)
	dlist.Paint = function(slf, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(RayUI.Colors.DarkGray6.r, RayUI.Colors.DarkGray6.g, RayUI.Colors.DarkGray6.b, RayUI.Opacity + 20))
	end
	dlist:CustomScrollBar()

	local TimeColumn = dlist:AddColumn(T("col_time"))
	local IconColumn = dlist:AddColumn("")
	local EventColumn = dlist:AddColumn(T("col_event"))
   
	for k, v in pairs({TimeColumn, IconColumn, EventColumn}) do
		v.Header.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, RayUI.Colors.DarkGray3)

			if k != 3 then
				surface.SetDrawColor( RayUI.Colors.DarkGray4 )
				surface.DrawRect( w - 1, 0, 1, h)
			end
		end

		v.Header:SetFont("RayUI:Small")
		v.Header:SetTextColor(color_white)
		v.Header:SetContentAlignment(5)
	end
   
	IconColumn:SetFixedWidth(40 * math.Round(RayUI.Scale, 1))
	TimeColumn:SetFixedWidth(70 * math.Round(RayUI.Scale, 1))

	dlist:SetHeaderHeight( 34 * math.Round(RayUI.Scale, 2) )
	dlist:SetDataHeight( 30 * math.Round(RayUI.Scale, 2) )

	self:FillDList(dlist)
end

function CLSCORE:BuildScorePanel(dpanel)
	local margin = 10
	local w, h = dpanel:GetSize()

	local dlist = vgui.Create("DListView", dpanel)
	dlist:Dock(FILL)
	dlist:DockMargin(1 * RayUI.Scale, 1 * RayUI.Scale, 1 * RayUI.Scale, 0)
	dlist:SetSortable(true)
	dlist:SetMultiSelect(false)
	dlist.Paint = function(slf, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(RayUI.Colors.DarkGray6.r, RayUI.Colors.DarkGray6.g, RayUI.Colors.DarkGray6.b, RayUI.Opacity + 20))
	end
	dlist:CustomScrollBar()

	local colnames = {"", "col_player", "col_role", "col_kills1", "col_kills2", "col_points", "col_team", "col_total"}
	local colList = {}
	for k, name in pairs(colnames) do
		if name == "" then
			local c = dlist:AddColumn("")
			c:SetFixedWidth(45 * math.Round(RayUI.Scale, 1))
			colList[#colList+1] = c
		else
			local c = dlist:AddColumn(T(name))
			colList[#colList+1] = c

		--	c:SetFixedWidth(105 * math.Round(RayUI.Scale))
		end
	end
	
	for k, v in pairs(colList) do
		v.Header.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, RayUI.Colors.DarkGray3)

			if k != #colList then
				surface.SetDrawColor( RayUI.Colors.DarkGray4 )
				surface.DrawRect( w - 1, 0, 1, h)
			end
		end

		v.Header:SetFont("RayUI:Small")
		v.Header:SetTextColor(color_white)
		v.Header:SetContentAlignment(5)
	end

	dlist:SetHeaderHeight( 34 * math.Round(RayUI.Scale, 2) )
	dlist:SetDataHeight( 30 * math.Round(RayUI.Scale, 2) )

	-- the type of win condition triggered is relevant for team bonus
	local wintype = WIN_NONE
	for i=#self.Events, 1, -1 do
		local e = self.Events[i]
		if e.id == EVENT_FINISH then
			wintype = e.win
			break
		end
	end
 
	local scores = self.Scores
	local nicks = self.Players
	local bonus = ScoreTeamBonus(scores, wintype)

	local skull_icon = Material("HUD/killicons/default")

	for id, s in pairs(scores) do
		if id != -1 then
			local was_traitor = s.was_traitor
			local role = was_traitor and T("traitor") or (s.was_detective and T("detective") or T("innocent"))

			local skull = ""
			if s.deaths > 0 then
				skull = vgui.Create("DPanel", dlist)
				skull:SetTooltip("Dead")
				skull.Paint = function(self, w, h)
					draw.RoundedBox(0, 0, 0, w - 2, h, Color(150, 50, 50))

					surface.SetMaterial( skull_icon )
					surface.SetDrawColor( RayUI.Colors.White )
					surface.DrawTexturedRect((w - 26 * RayUI.Scale) / 2, (h - 26 * RayUI.Scale) / 2, 26 * RayUI.Scale, 26 * RayUI.Scale)
				end
			end

			local points_own   = KillsToPoints(s, was_traitor)
			local points_team  = (was_traitor and bonus.traitors or bonus.innos)
			local points_total = points_own + points_team

			local l = dlist:AddLine(skull, nicks[id], role, s.innos, s.traitors, points_own, points_team, points_total)
			l:FormatListLine(2, 8)


			local surv_col = l.Columns[1]
			if surv_col then
				surv_col.Value = type(surv_col.Value) == "Panel" and "1" or "0"
			end
		end
	end

	dlist:SortByColumn(6)
end

function CLSCORE:AddAward(y, pw, award, dpanel)
	local nick = award.nick
	local text = award.text
	local title = string.upper(award.title)

	local titlelbl = vgui.Create("DLabel", dpanel)
	titlelbl:SetText(title)
	titlelbl:SetFont("RayUI:Small")
	titlelbl:SizeToContents()
	local tiw, tih = titlelbl:GetSize()

	local nicklbl = vgui.Create("DLabel", dpanel)
	nicklbl:SetText(nick)
	nicklbl:SetTextColor(RayUI.Colors.White)
	nicklbl:SetFont("RayUI.Normal:Smallest")
	nicklbl:SizeToContents()
	local nw, nh = nicklbl:GetSize()

	local txtlbl = vgui.Create("DLabel", dpanel)
	txtlbl:SetText(text)
	txtlbl:SetFont("RayUI.Normal:Smallest")
	txtlbl:SizeToContents()
	local tw, th = txtlbl:GetSize()

	titlelbl:SetPos((pw - tiw) / 2, y)
	y = y + tih + 2

	local fw = nw + tw + 5
	local fx = ((pw - fw) / 2)
	nicklbl:SetPos(fx, y)
	txtlbl:SetPos(fx + nw + 5, y)

	y = y + nh

	return y
end

-- double check that we have no nils
local function ValidAward(a)
   return a and a.nick and a.text and a.title and a.priority
end

local wintitle = {
   [WIN_TRAITOR] = {txt = "hilite_win_traitors", c = RayUI.Colors.Traitor},
   [WIN_INNOCENT] = {txt = "hilite_win_innocent", c = RayUI.Colors.Innocent}
}

function CLSCORE:BuildHilitePanel(dpanel)
	local w, h = dpanel:GetSize()

	local title = RayHUDTTT.WinType[WIN_INNOCENT] and RayHUDTTT.WinType[WIN_INNOCENT] or wintitle[WIN_INNOCENT]
	local endtime = self.StartTime
	for i=#self.Events, 1, -1 do
		local e = self.Events[i]
		if e.id == EVENT_FINISH then
			endtime = e.t

			-- when win is due to timeout, innocents win
			local wintype = e.win
			if wintype == WIN_TIMELIMIT then wintype = WIN_INNOCENT end

			title = RayHUDTTT.WinType[wintype] and RayHUDTTT.WinType[wintype] or wintitle[wintype]
			break
		end
	end

	local roundtime = endtime - self.StartTime

	local numply = table.Count(self.Players)
	local numtr = table.Count(self.TraitorIDs)

	local plytxt = PT(numtr == 1 and "hilite_players2" or "hilite_players1", {numplayers = numply, numtraitors = numtr})
	local timetxt = PT("hilite_duration", {time= util.SimpleTime(roundtime, "%02i:%02i")})

	local WinColor = RayUI.Colors.Innocent
	
	local Inner = vgui.Create("DPanel", dpanel)
	Inner:Dock(FILL)
	Inner:DockMargin(0, 0, 0, 40 * RayUI.Scale)
	Inner:SetDrawBackground(false)

	local bg = vgui.Create("DPanel", Inner)
	bg:Dock(TOP)
	bg:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale)
	bg:SetTall(110 * RayUI.Scale)
	bg.Paint = function(self, w, h)

		if RayHUDTTT.CustomRoles and RayHUDTTT.CustomRoles[title.c] and RayHUDTTT.CustomRoles[title.c] then
			WinColor = RayHUDTTT.CustomRoles[title.c]
		elseif IsColor(title.c) then
			WinColor = title.c
		else
			if title.c == ROLE_INNOCENT then
				WinColor = RayUI.Colors.Innocent
			elseif title.c == ROLE_TRAITOR then
				WinColor = RayUI.Colors.Traitor
			end
		end

		draw.RoundedBox(RayUI.Rounding, 0, 0, w, h - 20 * RayUI.Scale, WinColor)

		surface.SetFont( "RayUI:Largest3" )
		draw.SimpleText( T(title.txt), "RayUI:Largest3", (w - select(1, surface.GetTextSize(T(title.txt))))/2, ((h - 20 * RayUI.Scale) - select(2, surface.GetTextSize(T(title.txt)))) / 2, RayUI.Colors.White )
		
		surface.SetFont( "RayUI:Small" )
		draw.SimpleText( plytxt, "RayUI:Small", 5 * RayUI.Scale, 90 * RayUI.Scale, RayUI.Colors.White )
		draw.SimpleText( timetxt, "RayUI:Small", (w - select(1, surface.GetTextSize(timetxt))) - 5 * RayUI.Scale, 90 * RayUI.Scale, RayUI.Colors.White )
	end

   -- Awards
	local wa = math.Round(w * 0.9)

	local awardp = vgui.Create("DPanel", Inner)
	awardp:Dock(FILL)
	awardp:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale)
	awardp:SetPaintBackground(false)

	math.randomseed(self.StartTime + endtime)

	local award_choices = {}
	for k, afn in pairs(AWARDS) do
		local a = afn(self.Events, self.Scores, self.Players, self.TraitorIDs, self.DetectiveIDs)
		if ValidAward(a) then
			table.insert(award_choices, a)
		end
	end

	local num_choices = table.Count(award_choices)
	local max_awards = 5

	table.SortByMember(award_choices, "priority")

	timer.Simple(0.2, function()
		for i = 1, max_awards do
			local a = award_choices[i]
			if a then
				self:AddAward((i - 1) * 60 * RayUI.Scale, awardp:GetWide(), a, awardp)
			end
		end
	end)
end

function CLSCORE:ShowPanel()
	local margin = 10 * RayUI.Scale

	local w, h = 700 * RayUI.Scale, 500 * RayUI.Scale

	local MainPanel = vgui.Create("RayUI:MainPanel")
	MainPanel:SetSize(w, h)
	MainPanel:SetTitle(T("report_title"))
	MainPanel:Center()

	local Main = vgui.Create("DPanel", MainPanel)
	Main:SetDrawBackground(false)
	Main:Dock(FILL)

	self.Panel = MainPanel

	local BottomMargin = 50 * RayUI.Scale

	-- Main tab
	local dtabhilite = vgui.Create("DPanel", Main)
	dtabhilite:Dock(FILL)
	dtabhilite:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, BottomMargin)
	dtabhilite.Paint = function( s, w, h )
		draw.RoundedBox(4, 0, 0, w, h, Color(RayUI.Colors.DarkGray6.r, RayUI.Colors.DarkGray6.g, RayUI.Colors.DarkGray6.b, RayUI.Opacity + 20))
	end
	self:BuildHilitePanel(dtabhilite)

	-- Event tab
	local dtabevents = vgui.Create("DPanel", Main)
	dtabevents:Dock(FILL)
	dtabevents:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, BottomMargin)
	dtabevents:SetPaintBackground(false)
	dtabevents:SetAlpha(0)
	self:BuildEventLogPanel(dtabevents)
		
	-- Score tab
	local dtabscores = vgui.Create("DPanel", Main)
	dtabscores:Dock(FILL)
	dtabscores:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, BottomMargin)
	dtabscores:SetPaintBackground(false)
	dtabscores:SetAlpha(0)
	self:BuildScorePanel(dtabscores)

	dtabhilite:MoveToFront()

	local bw, bh = 100 * RayUI.Scale, 30 * RayUI.Scale

	local MainCloseBut = vgui.Create("DButton", MainPanel)
	MainCloseBut:SetSize(bw, bh)
	MainCloseBut:SetPos(w - bw - margin, h - bh - margin / 2 - 5 * RayUI.Scale)
	MainCloseBut:SetFont("RayUI:Smallest")
	MainCloseBut.DoClick = function()
		MainPanel:ToggleVisible()
	end
	MainCloseBut:FormatRayButton(T("close"), RayUI.Colors.DarkGray6, RayUI.Colors.Red)

	local SaveLogBut = vgui.Create("DButton", MainPanel)
	SaveLogBut:SetSize(bw, bh)
	SaveLogBut:SetPos(w - bw * 2 - margin * 2, h - bh - margin / 2 - 5 * RayUI.Scale)
	SaveLogBut:SetFont("RayUI:Smallest")
	SaveLogBut.DoClick = function()
		SaveLogBut:Remove()
		SaveLogBut:SetConsoleCommand("ttt_save_events")
	end
	SaveLogBut:FormatRayButton(T("report_save"), RayUI.Colors.DarkGray6, RayUI.Colors.Blue)

	MainPanel:MakePopup()
	MainPanel:SetKeyboardInputEnabled(false)
	
	RayHUDTTT.ScorePanel = {
		{text = T("report_tab_hilite"), icon = RayUI.Icons.Summary,
			callback = function()
				dtabhilite:MoveToFront()
				dtabhilite:AlphaTo(255, 0.4)
				dtabevents:AlphaTo(0, 0.4)
				dtabscores:AlphaTo(0, 0.4)
			end,
			nopopup = true
		},
		{text = T("report_tab_events"), icon = RayUI.Icons.Warning,
			callback = function()
				dtabevents:MoveToFront()
				dtabevents:AlphaTo(255, 0.4)
				dtabhilite:AlphaTo(0, 0.4)
				dtabscores:AlphaTo(0, 0.4)
			end,
			nopopup = true
		},
		{text = T("report_tab_scores"), icon = RayUI.Icons.Score,
			callback = function()
				dtabscores:MoveToFront()
				dtabscores:AlphaTo(255, 0.4)
				dtabhilite:AlphaTo(0, 0.4)
				dtabevents:AlphaTo(0, 0.4)
			end,
			nopopup = true
		},
	}

	MainPanel:CreateSidebar(RayHUDTTT.ScorePanel)
	MainPanel:MakePopup()
end

function CLSCORE:Toggle()
	if IsValid(self.Panel) then
		self.Panel:ToggleVisible()
	end
end

function CLSCORE:Reset()
   self.Events = {}
   self.TraitorIDs = {}
   self.DetectiveIDs = {}
   self.Scores = {}
   self.Players = {}
   self.RoundStarted = 0

   self:ClearPanel()
end

function CLSCORE:Init(events)
   local starttime = 0
   local traitors, detectives
   local scores, nicks = {}, {}

   local game, selected, spawn = false, false, false
   for i = 1, #events do
      local e = events[i]

		if e.id == EVENT_GAME then
			if e.state == ROUND_ACTIVE then
				starttime = e.t

				if selected and spawn then
					break
				end

				game = true
			end
		elseif e.id == EVENT_SELECTED then
			traitors = e.traitor_ids
			detectives = e.detective_ids

			if game and spawn then
				break
			end

			selected = true
		elseif e.id == EVENT_SPAWN then
			scores[e.sid] = ScoreInit()
			nicks[e.sid] = e.ni

			if game and selected then
				break
			end

			spawn = true
		end
	end

   if traitors == nil then traitors = {} end
   if detectives == nil then detectives = {} end

   scores = ScoreEventLog(events, scores, traitors, detectives)

   self.Players = nicks
   self.Scores = scores
   self.TraitorIDs = traitors
   self.DetectiveIDs = detectives
   self.StartTime = starttime
   self.Events = events
end

-- VGUI Things

local meta = FindMetaTable "Panel"

function meta:FormatListLine(colStart, colEnd)
	for k = colStart, colEnd do 
		self.Columns[k]:SetFont("RayUI.Normal:Smallest")
		self.Columns[k]:SetColor(color_white)
		self.Columns[k]:SetContentAlignment(5)
	end
	
	self.Paint = function(slf, w, h)

		local lineCol = RayUI.Colors.DarkGray6

		if slf.Hovered then
			lineCol =RayUI.Colors.Gray3
		elseif slf.m_bAlt then
			lineCol = RayUI.Colors.DarkGray2
		end

		surface.SetDrawColor(lineCol)
		surface.DrawRect(0, 0, w, h)
		return true
	end
end