-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation
local SafeTranslate = LANG.TryTranslation

local OnlyFav = CreateClientConVar( "rayhud_ttt_favorite", "0", true, false )
local Columns = RayUI.Configuration.GetConfig( "ShopColumns" )
local Rows = RayUI.Configuration.GetConfig( "ShopRows" )

local function CreateFavTable()
	if !(sql.TableExists("rayhud_ttt_fav")) then
    query = "CREATE TABLE rayhud_ttt_fav (guid TEXT, role TEXT, weapon_id TEXT)"
		result = sql.Query(query)
	end
end

local function AddFavorite(guid, role, weapon_id)
  query = "INSERT INTO rayhud_ttt_fav VALUES('" .. guid .. "','" .. role .. "','" .. weapon_id .. "')"
  result = sql.Query(query)
end

local function RemoveFavorite(guid, role, weapon_id)
  query = "DELETE FROM rayhud_ttt_fav WHERE guid = '" .. guid .. "' AND role = '" .. role .. "' AND weapon_id = '" .. weapon_id .. "'"
  result = sql.Query(query)
end

local function GetFavorites(guid, role)
  query = "SELECT weapon_id FROM rayhud_ttt_fav WHERE guid = '" .. guid .. "' AND role = '" .. role .. "'"
  result = sql.Query(query)
  return result
end

local function IsFavorite(favorites, weapon_id)
	for _, value in pairs(favorites) do
		local dbid = value["weapon_id"]
		if (dbid == tostring(weapon_id)) then
			return true
		end
	end
	return false
end

local Equipment = nil
function GetEquipmentForRole(role)
	if not Equipment then
		local tbl = table.Copy(EquipmentItems)
		
		for k, v in pairs(weapons.GetList()) do
			if v and v.CanBuy then
				local data = v.EquipMenuData or {}
				local base = {
					id       = WEPS.GetClass(v),
					name     = v.PrintName or "Unnamed",
					limited  = v.LimitedStock,
					kind     = v.Kind or WEAPON_NONE,
					slot     = (v.Slot or 0) + 1,
					material = v.Icon or "vgui/ttt/icon_id",
					type     = "Type not specified",
					model    = "models/weapons/w_bugbait.mdl",
					desc     = "No description specified."
				};

				if data.modelicon then
					base.material = nil
				end

				table.Merge(base, data)				
				for _, r in pairs(v.CanBuy) do
					table.insert(tbl[r], base)
				end
			end
		end

		-- mark custom items
		for r, is in pairs(tbl) do
			for _, i in pairs(is) do
				if i and i.id then
					i.custom = not table.HasValue(DefaultEquipment[r], i.id)
				end
			end
		end

		Equipment = tbl
	end

	return Equipment and Equipment[role] or {}
end

local function ItemIsWeapon(item) return not tonumber(item.id) end
local function CanCarryWeapon(item) return LocalPlayer():CanCarryType(item.kind) end

local color_bad = RayUI.Colors.Red
local color_good = RayUI.Colors.Green

local Margin = 10 * RayUI.Scale

-- Creates tabel of labels showing the status of ordering prerequisites
local function PreqLabels(parent, x, y)
	local tbl = {}

	tbl.credits = vgui.Create("DLabel", parent)
	tbl.credits:SetTooltip(GetTranslation("equip_help_cost"))
	tbl.credits:Dock(TOP)
	tbl.credits:DockMargin(Margin, Margin, 0, 0)
	tbl.credits.Check = function(s, sel)
		local credits = LocalPlayer():GetCredits()
		return credits > 0, GetPTranslation("equip_cost", {num = credits})
	end

	tbl.owned = vgui.Create("DLabel", parent)
	tbl.owned:SetTooltip(GetTranslation("equip_help_carry"))
	tbl.owned:Dock(TOP)
	tbl.owned:DockMargin(Margin, Margin, 0, 0)
	tbl.owned.Check = function(s, sel)
		if ItemIsWeapon(sel) and (not CanCarryWeapon(sel)) then
			return false, GetPTranslation("equip_carry_slot", {slot = sel.slot})
		elseif (not ItemIsWeapon(sel)) and LocalPlayer():HasEquipmentItem(sel.id) then
			return false, GetTranslation("equip_carry_own")
		else
			return true, GetTranslation("equip_carry")
		end
	end

	tbl.bought = vgui.Create("DLabel", parent)
	tbl.bought:SetTooltip(GetTranslation("equip_help_stock"))
	tbl.bought:Dock(TOP)
	tbl.bought:DockMargin(Margin, Margin, 0, 0)
	tbl.bought.Check = function(s, sel)
		if sel.limited and LocalPlayer():HasBought(tostring(sel.id)) then
			return false, GetTranslation("equip_stock_deny")
		else
			return true, GetTranslation("equip_stock_ok")
		end
	end

	for k, pnl in pairs(tbl) do
		pnl:SetFont("RayUI:Small")
	end

	return function(selected)
	local allow = true
		for k, pnl in pairs(tbl) do
			local result, text = pnl:Check(selected)
			pnl:SetTextColor(result and color_good or color_bad)
			pnl:SetText(text)
			pnl:SizeToContents()

			allow = allow and result
		end
		return allow
	end
end

-- quick, very basic override of DPanelSelect
local PANEL = {}

local function DrawSelectedEquipment(pnl)
   surface.SetDrawColor(60, 240, 60)
   surface.DrawOutlinedRect(0, 0, pnl:GetWide(), pnl:GetTall())
end

function PANEL:OnActivePanelChanged( pnlOld, pnlNew )
	-- For override
end

function PANEL:SelectPanel( pnl )
	self:OnActivePanelChanged( self.SelectedPanel, pnl )

	if ( self.SelectedPanel ) then
		self.SelectedPanel.PaintOver = nil
		self.SelectedPanel = nil
	end

	-- Run all the convars, if it has any..
	if ( pnl.tblConVars ) then
		for k, v in pairs( pnl.tblConVars ) do RunConsoleCommand( k, v ) end
	end

	self.SelectedPanel = pnl

	if pnl then
		pnl.PaintOver = DrawSelectedEquipment
	end
end
vgui.Register("EquipSelect", PANEL, "DIconLayout")

local color_darkened = Color(255,255,255, 80)

color_slot = {
	[ROLE_INNOCENT] = RayUI.Colors.Innocent,
	[ROLE_TRAITOR]   = RayUI.Colors.Traitor,
	[ROLE_DETECTIVE] = RayUI.Colors.Detective
};

local fieldstbl = {"name", "type", "desc"}

function WEPS.IsEquipment(wep)
   return wep.Kind and wep.Kind >= WEAPON_EQUIP
end

RayHUDTTT.EquipPanel = {}

local eqframe
local function TraitorMenuPopup()
	if IsValid(eqframe) then eqframe:Remove() return end

	local ply = LocalPlayer()
	if not IsValid(ply) or not ply:IsActiveSpecial() then
		return
	end
	
	local credits = ply:GetCredits()
	local can_order = credits > 0

	local w, h = (88 + 70 * Columns) * RayUI.Scale, (256 + 69 * Rows) * RayUI.Scale

	local ShopPanel = vgui.Create("RayUI:MainPanel")
	ShopPanel:SetSize(w, h)
	ShopPanel:SetTitle(GetTranslation("equip_title"))
	ShopPanel:Center()
	ShopPanel:CreateSidebar()

	local UpperPanel = vgui.Create( "DPanel", ShopPanel )
	UpperPanel:Dock(TOP)
	UpperPanel:DockMargin(Margin, Margin, Margin, Margin)
	UpperPanel:SetTall((4 + 69 * Rows) * RayUI.Scale)
	UpperPanel.Paint = function( s, w, h )
		draw.RoundedBox( RayUI.Rounding - 6, 0, 0, w, h, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 20) )
	end

	local ItemsScroll = vgui.Create( "DScrollPanel", UpperPanel )
	ItemsScroll:Dock(FILL)
	ItemsScroll:SetDrawBackground(false)
	ItemsScroll:CustomScrollBar()
	ItemsScroll:GetVBar():SetWide(16 * RayUI.Scale)

	local DescPanel = vgui.Create( "DPanel", ShopPanel )
	DescPanel:Dock(FILL)
	DescPanel:DockMargin(Margin, 0, Margin, Margin)
	DescPanel.Paint = function( s, w, h )
		draw.RoundedBox( RayUI.Rounding - 6, 0, 0, w, h, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 20) )
	end
	
	-- Transfer Panel
	local TransferPanel = vgui.Create("DPanel", UpperPanel)
	TransferPanel:Dock(LEFT)
	TransferPanel:SetWide(0)
	TransferPanel.Paint = function( s, w, h )
		draw.RoundedBox( 5, 0, 0, w, h, RayUI.Colors.DarkGray3 )
	end
	
	local selected_sid = nil
	
	local TransferTo = RayUI:MakeComboBox(TransferPanel, "Transfer to:")

	local TransferBut = vgui.Create("DButton", TransferPanel)
	TransferBut:Dock(TOP)
	TransferBut:DockMargin(12 * RayUI.Scale, 6 * RayUI.Scale, 12 * RayUI.Scale, 0)
	TransferBut:SetEnabled(false)
	TransferBut:SetTall(30 * RayUI.Scale)
	TransferBut:FormatRayButton(GetTranslation("xfer_send"), RayUI.Colors.Gray, RayUI.Colors.Green3)

	TransferTo.OnSelect = function(s, idx, val, data)
		if data then
			selected_sid = data
			TransferBut:SetEnabled(true)
		end
	end

	local r = LocalPlayer():GetRole()
	for _, p in pairs(player.GetAll()) do
		if IsValid(p) and p:IsActiveRole(r) and p != LocalPlayer() then
			TransferTo:AddChoice(p:Nick(), p:SteamID())
		end
	end

	if TransferTo:GetOptionText(1) then TransferTo:ChooseOptionID(1) end

	TransferBut.DoClick = function(s)
		if selected_sid then
			RunConsoleCommand("ttt_transfer_credits", selected_sid, "1")
		end
	end
	TransferBut.Think = function(s)
		if LocalPlayer():GetCredits() < 1 then
			s:SetEnabled(false)
		end
	end
	
	-- Transfer Panel
	local RadarPanel = vgui.Create("DPanel", UpperPanel)
	RadarPanel:Dock(LEFT)
	RadarPanel:DockMargin(0, 0, 0, 0)
	RadarPanel:SetWide(0)
	RadarPanel.Paint = function( s, w, h )
		draw.RoundedBox( 5, 0, 0, w, h, RayUI.Colors.DarkGray6 )
	end
	
	local owned = LocalPlayer():HasEquipmentItem(EQUIP_RADAR)
	
	local dscan = vgui.Create("DButton", RadarPanel)
	dscan:Dock(TOP)
	dscan:DockMargin(Margin, Margin, Margin, Margin)
	dscan:SetTall(25 * RayUI.Scale)
	dscan:SetEnabled(false)
	dscan.DoClick = function(self)
		self:SetEnabled(false)
		RunConsoleCommand("ttt_radar_scan")
	end
	dscan:FormatRayButton(GetTranslation("radar_scan"), RayUI.Colors.Gray, RayUI.Colors.Green)

	RadarPanel.Think = function(s)
		if RADAR.enable or not owned then
			dscan:SetEnabled(false)
		else
			dscan:SetEnabled(true)
		end
	end

	local RadarCheckBox = RayUI:MakeCheckbox(RadarPanel, nil, "Auto rescan every "..RADAR.duration.." seconds.")
	RadarCheckBox:SetValue(RADAR.repeating)
	RadarCheckBox.OnChange = function(s, val)
		RADAR.repeating = val
	end

	-- Radio Panel
	local sound_names = {
	   scream   ="radio_button_scream",
	   explosion="radio_button_expl",
	   pistol   ="radio_button_pistol",
	   m16      ="radio_button_m16",
	   deagle   ="radio_button_deagle",
	   mac10    ="radio_button_mac10",
	   shotgun  ="radio_button_shotgun",
	   rifle    ="radio_button_rifle",
	   huge     ="radio_button_huge",
	   beeps    ="radio_button_c4",
	   burning  ="radio_button_burn",
	   footsteps="radio_button_steps"
	};

	local smatrix = {
	   {"scream", "burning", "explosion"},
	   {"footsteps", "pistol", "shotgun"},
	   {"mac10", "deagle", "m16"},
	   {"rifle", "huge", "beeps"}
	};

	local function PlayRadioSound(snd)
		local r = LocalPlayer().radio
		if IsValid(r) then
			RunConsoleCommand("ttt_radio_play", tostring(r:EntIndex()), snd)
		end
	end
	
	local function ButtonClickPlay(s) PlayRadioSound(s.snd) end

	local function CreateSoundBoard(parent)
		local b = vgui.Create("DPanel", parent)
		b:Dock(LEFT)
		b:DockMargin(20 * RayUI.Scale, 0, 20* RayUI.Scale, 0)
		b:SetWide(340 * RayUI.Scale)
		b:SetDrawBackground(false)
		
		local bw, bh = 100 * RayUI.Scale, 30 * RayUI.Scale
		local m = 8 * RayUI.Scale
		local x, y = 0, 0
		
		for ri, row in ipairs(smatrix) do
			local rj = ri - 1 -- easier for computing x,y
			for rk, snd in ipairs(row) do
				local rl = rk - 1
				y = (rj * m) + (rj * bh)
				x = (rl * m) + (rl * bw)

				local but = vgui.Create("DButton", b)
				but:SetPos(x, y)
				but:SetSize(bw, bh)
				but:SetFont("RayUI.Normal:Smallest")
				but.snd = snd
				but.DoClick = ButtonClickPlay
				but:FormatRayButton(LANG.GetTranslation(sound_names[snd]), RayUI.Colors.Gray, RayUI.Colors.DarkGray3)
			end
		end

	   return b
	end
	
	local RadioPanel = vgui.Create("DPanel", UpperPanel)
	RadioPanel:Dock(LEFT)
	RadioPanel:SetWide(0)
	RadioPanel.Paint = function( s, w, h )
		draw.RoundedBox( 5, 0, 0, w, h, RayUI.Colors.DarkGray6 )
	end

	local RadioLabel = RayUI:MakeLabel(LANG.GetTranslation("radio_help"), "RayUI.Normal:Smallest2", color_white, RadioPanel)
	RadioLabel:Dock(TOP)
	RadioLabel:DockMargin(Margin, Margin, Margin, Margin)

	if IsValid(LocalPlayer().radio) then
		CreateSoundBoard(RadioPanel)
	elseif LocalPlayer():HasWeapon("weapon_ttt_radio") then
		RadioLabel:SetText(LANG.GetTranslation("radio_notplaced"))
	end

	local CreditPanel = vgui.Create( "DPanel", ShopPanel )
	CreditPanel:Dock(RIGHT)
	CreditPanel:SetWide(260 * RayUI.Scale)
	CreditPanel:DockMargin(0, 0, Margin, Margin)
	CreditPanel.Paint = function( s, w, h )
		draw.RoundedBox( RayUI.Rounding - 6, 0, 0, w, h, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 20) )
	end
	
	local owned_ids = {}
	for _, wep in pairs(ply:GetWeapons()) do
		if IsValid(wep) and wep:IsEquipment() then
			table.insert(owned_ids, wep:GetClass())
		end
	end

	if #owned_ids == 0 then
		owned_ids = nil
	end

	--- Construct icon listing
	local dlist = vgui.Create("EquipSelect", ItemsScroll)
	dlist:Dock(FILL)
	dlist:DockMargin(Margin / 2, Margin / 2, Margin / 2, 0)
	dlist:SetSpaceX( 6 * RayUI.Scale )
	dlist:SetSpaceY( 6 * RayUI.Scale  )
	
	local items = GetEquipmentForRole(ply:GetRole())
	
	-- sorting stuff
	local ItemsTable = {}
	local ItemsTableFav = {}

	local favorites = GetFavorites(ply:SteamID(), ply:GetRole())
	
	for k, item in pairs(items) do
		local ic = nil

		-- Create icon panel
		if item.material then
		--	ic = dlist:Add("LayeredIcon")
			ic = vgui.Create("LayeredIcon", UpperPanel)
			ic:SetIconSize(64 * RayUI.Scale)
			
			if item.custom and RayUI.Configuration.GetConfig( "CustomItemsIcon" ) then
				-- Custom marker icon
				local marker = vgui.Create("DImage")
				marker:SetImage("vgui/ttt/custom_marker")
				marker.PerformLayout = function(s)
					s:AlignBottom(2)
					s:AlignRight(2)
					s:SetSize(16 * RayUI.Scale, 16 * RayUI.Scale)
				end
				marker:SetTooltip(GetTranslation("equip_custom"))

				ic:AddLayer(marker)
				ic:EnableMousePassthrough(marker)
			end

			-- Favorites marker icon
			ic.favorite = false
			if favorites then
				if IsFavorite(favorites, item.id) then
					ic.favorite = true		
					local star = vgui.Create("DImage")
					star:SetImage("icon16/star.png")
					star.PerformLayout = function(s)
						s:AlignTop(2)
						s:AlignRight(2)
						s:SetSize(12 * RayUI.Scale, 12 * RayUI.Scale)
					end
					star:SetTooltip("Favorite")
					ic:AddLayer(star)
					ic:EnableMousePassthrough(star)
				end
			end

			-- Slot marker icon
			if ItemIsWeapon(item) then
				local slot = vgui.Create("SimpleIconLabelled")
				slot:SetIcon("vgui/ttt/slotcap")
				slot:SetIconColor((RayHUDTTT.CustomRoles[ply:GetRole()] and RayHUDTTT.CustomRoles[ply:GetRole()]) or color_slot[ply:GetRole()] or COLOR_GREY)
				slot:SetIconSize(18 * RayUI.Scale)
				slot:SetIconText(item.slot)
				slot:SetIconProperties(COLOR_WHITE, "RayUI.Normal:Smallest", {opacity=220, offset=1}, {9 * RayUI.Scale, 8 * RayUI.Scale})

				ic:AddLayer(slot)
				ic:EnableMousePassthrough(slot)
			end
			
			if OnlyFav:GetBool() and favorites then
				if !ic.favorite then
					ic:Remove()
				end
			else
				OnlyFav:SetBool( false )
			end

			ic:SetIcon(item.material)
		elseif item.model then
			ic = vgui.Create("SpawnIcon", dlist)
			ic:SetModel(item.model)
		else
			ErrorNoHalt("Equipment item does not have model or material specified: " .. tostring(item) .. "\n")
		end

		ic.item = item

		local tip = SafeTranslate(item.name) .. " (" .. SafeTranslate(item.type) .. ")"
		ic:SetTooltip(tip)

		if ((not can_order) or
			table.HasValue(owned_ids, item.id) or
			(tonumber(item.id) and ply:HasEquipmentItem(tonumber(item.id))) or
			(ItemIsWeapon(item) and (not CanCarryWeapon(item))) or
			(item.limited and ply:HasBought(tostring(item.id)))) then
			
			ic:SetIconColor(color_darkened)
		end
		
		if ic.favorite then
			ItemsTableFav[k] = ic
		else
			ItemsTable[k] = ic
		end


		ic.DoClick = function()
			dlist:SelectPanel(ic)
		end
	end

	-- add favorites first
	for _, panel in pairs(ItemsTableFav) do
		dlist:Add(panel)
	end

	for _, panel in pairs(ItemsTable) do
		dlist:Add(panel)
	end

	local dfields = {}
	for _, k in pairs({"name", "type", "desc"}) do
		dfields[k] = vgui.Create("DLabel", DescPanel)
		dfields[k]:Dock(TOP)
		dfields[k]:DockMargin(Margin, Margin, 0, 0)
		dfields[k]:SetTooltip(GetTranslation("equip_spec_" .. k))
	end

	dfields.name:SetFont("RayUI:Large2")

	dfields.type:SetFont("RayUI:Smallest")
	dfields.type:MoveBelow(dfields.name)

	dfields.desc:SetFont("RayUI.Normal:Smallest")
	dfields.desc:SetContentAlignment(7)
	dfields.desc:MoveBelow(dfields.type)
	dfields.desc:SetWrap(true)

	-- Favorite button
	local FavBut = vgui.Create("DButton", CreditPanel)
	FavBut:Dock(BOTTOM)
	FavBut:DockMargin(Margin, Margin, Margin, Margin)
	FavBut:SetTall(34 * RayUI.Scale)
	FavBut:SetFont("RayUI:Smallest")
	FavBut.DoClick = function()
		local role = ply:GetRole()
		local plyid = ply:SteamID()
		local pnl = dlist.SelectedPanel
		if not pnl or not pnl.item then return end
		local choice = pnl.item
		local weapon = choice.id
		CreateFavTable()
		if pnl.favorite then
			RemoveFavorite(plyid, role, weapon)
		else
			AddFavorite(plyid, role, weapon)
		end
		ShopPanel:Remove()
		TraitorMenuPopup()
	end
	FavBut:FormatRayButton("Favorite", RayUI.Colors.Gray, RayUI.Colors.Blue)

	-- Buy button
	local BuyBut = vgui.Create("DButton", CreditPanel)
	BuyBut:Dock(BOTTOM)
	BuyBut:DockMargin(Margin, Margin, Margin, 0)
	BuyBut:SetTall(34 * RayUI.Scale)
	BuyBut:SetFont("RayUI:Smallest")
	BuyBut.DoClick = function()
		local pnl = dlist.SelectedPanel
		if not pnl or not pnl.item then return end
		local choice = pnl.item
		RunConsoleCommand("ttt_order_equipment", choice.id)
		ShopPanel:Remove()
	end
	BuyBut:FormatRayButton("Buy!", RayUI.Colors.Gray, RayUI.Colors.Green3)
	
	local update_preqs = PreqLabels(CreditPanel, Margin, Margin)

	dlist.OnActivePanelChanged = function(self, _, new)
		for k,v in pairs(new.item) do
			if dfields[k] then
				dfields[k]:SetText(SafeTranslate(v))
				dfields[k]:SizeToContents()
			end
		end
 		-- 76561198121455451
		can_order = update_preqs(new.item)

		if ply:IsActiveSpecial() then
			BuyBut:SetEnabled(can_order)
		end

		if favorites and IsFavorite(favorites, new.item.id) then
			FavBut:SetText("Un-Favorite")
		else
			FavBut:SetText("Favorite")
		end
	end	

	dlist:SelectPanel((dlist:GetChildren()[1]))

	RayHUDTTT.EquipPanel = {
		{text = "Favorites", icon = RayUI.Icons.Star,
			callback = function()
				if favorites then

					if OnlyFav:GetBool() then
						OnlyFav:SetBool( false )
					else
						OnlyFav:SetBool( true )
					end

					ShopPanel:Close()
					TraitorMenuPopup()
				end
			end,
			nopopup = true
		},

		{text = GetTranslation("xfer_name"), icon = RayUI.Icons.Transfer,
			callback = function()
				if TransferPanel:GetWide() == 0 then
					TransferPanel:SizeTo(350 * RayUI.Scale, TransferPanel:GetTall(), 0.2)
					if RadioPanel:GetWide() != 0 then
						RadioPanel:SizeTo(0, RadioPanel:GetTall(), 0.2)
					end
					if RadarPanel:GetWide() != 0 then
						RadarPanel:SizeTo(0, RadarPanel:GetTall(), 0.2)
					end
				else
					TransferPanel:SizeTo(0, TransferPanel:GetTall(), 0.2)
				end
			end,
			nopopup = true
		},

		{text = GetTranslation("radar_name"), icon = RayUI.Icons.Radar,
			callback = function()
				if RadarPanel:GetWide() == 0 then
					RadarPanel:SizeTo(300 * RayUI.Scale, RadarPanel:GetTall(), 0.2)
					if RadioPanel:GetWide() != 0 then
						RadioPanel:SizeTo(0, RadioPanel:GetTall(), 0.2)
					end
					if TransferPanel:GetWide() != 0 then
						TransferPanel:SizeTo(0, TransferPanel:GetTall(), 0.2)
					end
				else
					RadarPanel:SizeTo(0, RadarPanel:GetTall(), 0.2)
				end
			end,
			ShouldShow = function()
				return LocalPlayer():HasEquipmentItem(EQUIP_RADAR)
			end,
			nopopup = true
		},

		{text = GetTranslation("disg_name"), icon = RayUI.Icons.Gesture,
			callback = function()
				if !LocalPlayer():GetNWBool("disguised") then
					RunConsoleCommand("ttt_set_disguise", "1")
				end
				if LocalPlayer():GetNWBool("disguised") then
					RunConsoleCommand("ttt_set_disguise", "0")
				end
			end,
			ShouldShow = function()
				return LocalPlayer():HasEquipmentItem(EQUIP_DISGUISE)
			end,
			nopopup = true
		},

		{text = GetTranslation("radio_name"), icon = RayUI.Icons.Radio,
			callback = function()
				if RadioPanel:GetWide() == 0 then
					RadioPanel:SizeTo(350 * RayUI.Scale, RadioPanel:GetTall(), 0.2)
					if TransferPanel:GetWide() != 0 then
						TransferPanel:SizeTo(0, TransferPanel:GetTall(), 0.2)
					end
					if RadarPanel:GetWide() != 0 then
						RadarPanel:SizeTo(0, RadarPanel:GetTall(), 0.2)
					end
				else
					RadioPanel:SizeTo(0, RadioPanel:GetTall(), 0.2)
				end
			end,
			ShouldShow = function()
				return IsValid(LocalPlayer().radio) or LocalPlayer():HasWeapon("weapon_ttt_radio")
			end,
			nopopup = true
		},
	}

	ShopPanel:CreateSidebar(RayHUDTTT.EquipPanel)
	ShopPanel:MakePopup()
	ShopPanel:SetKeyboardInputEnabled(false)
	
	eqframe = ShopPanel
end
concommand.Add("ttt_cl_traitorpopup", TraitorMenuPopup)

local function ForceCloseTraitorMenu(ply, cmd, args)
	if IsValid(eqframe) then
		eqframe:Remove()
	end
end
concommand.Add("ttt_cl_traitorpopup_close", ForceCloseTraitorMenu)

hook.Add("OnContextMenuOpen", "RayHUDTTT:OnContextMenuOpen", function()
	GAMEMODE.OnContextMenuOpen = nil
	local r = GetRoundState()

	if RayHUDTTT.UseCustomRoles == "TownOfTerror" then
		if LocalPlayer():GetInfected() then
			if r == ROUND_POST or r == ROUND_PREP then
				CLSCORE:Reopen()
				return
			end
			RunConsoleCommand("ttt_cl_infectedpopup")
		
		elseif LocalPlayer():GetWitchDR() then

			if r == ROUND_POST or r == ROUND_PREP then
				CLSCORE:Reopen()
				return
			end
			RunConsoleCommand("ttt_cl_witchdrpopup")
		
		elseif LocalPlayer():GetEngineer() then
			if r == ROUND_POST or r == ROUND_PREP then
				CLSCORE:Reopen()
				return
			end

			net.Start( "EngineerUIcommand" )
			net.WriteEntity( LocalPlayer() )
			net.SendToServer()
		else
			if r == ROUND_ACTIVE and !GetEquipmentForRole(LocalPlayer():GetRole()) then
				return
			elseif r == ROUND_POST or r == ROUND_PREP then
				CLSCORE:Toggle()
				return
			end

			TraitorMenuPopup()
		end		
	else
		if r == ROUND_ACTIVE and !GetEquipmentForRole(LocalPlayer():GetRole()) then
			return
		elseif r == ROUND_POST or r == ROUND_PREP then
			CLSCORE:Toggle()
			return
		end

		TraitorMenuPopup()
	end

end)

local function ReceiveEquipment()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	ply.equipment_items = net.ReadUInt(16)
end
net.Receive("TTT_Equipment", ReceiveEquipment)

local function ReceiveCredits()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	ply.equipment_credits = net.ReadUInt(8)
end
net.Receive("TTT_Credits", ReceiveCredits)

local r = 0
local function ReceiveBought()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	ply.bought = {}
	local num = net.ReadUInt(8)
	for i=1,num do
		local s = net.ReadString()
		if s != "" then
			table.insert(ply.bought, s)
		end
	end

	if num != #ply.bought and r < 10 then
		RunConsoleCommand("ttt_resend_bought")
		r = r + 1
	else
		r = 0
	end
end
net.Receive("TTT_Bought", ReceiveBought)

local function ReceiveBoughtItem()
	local is_item = net.ReadBit() == 1
	local id = is_item and net.ReadUInt(16) or net.ReadString()

	hook.Run("TTTBoughtItem", is_item, id)
end
net.Receive("TTT_BoughtItem", ReceiveBoughtItem)

-- VGUI Things

local PANEL = {}

AccessorFunc( PANEL, "m_iIconSize", "IconSize" )

function PANEL:Init()
	self.Icon = vgui.Create( "DImage", self )
	self.Icon:SetMouseInputEnabled( false )
	self.Icon:SetKeyboardInputEnabled( false )

	self.animPress = Derma_Anim( "Press", self, self.PressedAnim )

	self:SetIconSize(64)
end

function PANEL:OnMousePressed( mcode )
	if mcode == MOUSE_LEFT then
		self:DoClick()
		self.animPress:Start(0.1)
	end
end

function PANEL:OnMouseReleased()
end

function PANEL:DoClick()
end

function PANEL:OpenMenu()
end

function PANEL:ApplySchemeSettings()
end

function PANEL:OnCursorEntered()
	self.PaintOverOld = self.PaintOver
	self.PaintOver = self.PaintOverHovered
end

function PANEL:OnCursorExited()
	if self.PaintOver == self.PaintOverHovered then
		self.PaintOver = self.PaintOverOld
	end
end

function PANEL:PaintOverHovered()
	if self.animPress:Active() then return end

	surface.SetDrawColor(255, 120, 0)
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
end

function PANEL:PerformLayout()
	if self.animPress:Active() then return end
	self:SetSize( self.m_iIconSize, self.m_iIconSize )
	self.Icon:StretchToParent( 0, 0, 0, 0 )
end

function PANEL:SetIcon( icon )
	self.Icon:SetImage(icon)
end

function PANEL:GetIcon()
	return self.Icon:GetImage()
end

function PANEL:SetIconColor(clr)
	self.Icon:SetImageColor(clr)
end

function PANEL:Think()
	self.animPress:Run()
end

function PANEL:PressedAnim( anim, delta, data )

	if anim.Started then
		return
	end

	if anim.Finished then
		self.Icon:StretchToParent( 0, 0, 0, 0 )
		return
	end

	local border = math.sin( delta * math.pi ) * (self.m_iIconSize * 0.05 )
	self.Icon:StretchToParent( border, border, border, border )

end

vgui.Register( "SimpleIcon", PANEL, "Panel" )

---

local PANEL = {}

function PANEL:Init()
	self.Layers = {}
end

-- Add a panel to this icon. Most recent addition will be the top layer.
function PANEL:AddLayer(pnl)
	if not IsValid(pnl) then return end

	pnl:SetParent(self)

	pnl:SetMouseInputEnabled(false)
	pnl:SetKeyboardInputEnabled(false)

	table.insert(self.Layers, pnl)
end

function PANEL:PerformLayout()
	if self.animPress:Active() then return end
	self:SetSize( self.m_iIconSize, self.m_iIconSize )
	self.Icon:StretchToParent( 0, 0, 0, 0 )

	for _, p in ipairs(self.Layers) do
		p:SetPos(0, 0)
		p:InvalidateLayout()
	end
end

function PANEL:EnableMousePassthrough(pnl)
	for _, p in pairs(self.Layers) do
		if p == pnl then
			p.OnMousePressed  = function(s, mc) s:GetParent():OnMousePressed(mc) end
			p.OnCursorEntered = function(s) s:GetParent():OnCursorEntered() end
			p.OnCursorExited  = function(s) s:GetParent():OnCursorExited() end

			p:SetMouseInputEnabled(true)
		end
	end
end

vgui.Register("LayeredIcon", PANEL, "SimpleIcon")

-- Avatar icon
local PANEL = {}

function PANEL:Init()
	self.imgAvatar = vgui.Create( "AvatarImage", self )
	self.imgAvatar:SetMouseInputEnabled( false )
	self.imgAvatar:SetKeyboardInputEnabled( false )
	self.imgAvatar.PerformLayout = function(s) s:Center() end

	self:SetAvatarSize(32)

	self:AddLayer(self.imgAvatar)

	--return self.BaseClass.Init(self)
end

function PANEL:SetAvatarSize(s)
	self.imgAvatar:SetSize(s, s)
end

function PANEL:SetPlayer(ply)
	self.imgAvatar:SetPlayer(ply)
end

vgui.Register( "SimpleIconAvatar", PANEL, "LayeredIcon" )


--- Labelled icon

local PANEL = {}

AccessorFunc(PANEL, "IconText", "IconText")
AccessorFunc(PANEL, "IconTextColor", "IconTextColor")
AccessorFunc(PANEL, "IconFont", "IconFont")
AccessorFunc(PANEL, "IconTextShadow", "IconTextShadow")
AccessorFunc(PANEL, "IconTextPos", "IconTextPos")

function PANEL:Init()
	self:SetIconText("")
	self:SetIconTextColor(RayUI.Colors.Orange)
	self:SetIconFont("RayUI:Small2")
	self:SetIconTextShadow({opacity=255, offset=2})
	self:SetIconTextPos({32 * RayUI.Scale, 32 * RayUI.Scale})

	self.FakeLabel = vgui.Create("Panel", self)
	self.FakeLabel.PerformLayout = function(s) s:StretchToParent(0,0,0,0) end

	self:AddLayer(self.FakeLabel)

	return self.BaseClass.Init(self)
end

function PANEL:PerformLayout()
	self:SetLabelText(self:GetIconText(), self:GetIconTextColor(), self:GetIconFont(), self:GetIconTextPos())

	return self.BaseClass.PerformLayout(self)
end

function PANEL:SetIconProperties(color, font, shadow, pos)
	self:SetIconTextColor( color  or self:GetIconTextColor())
	self:SetIconFont(      font   or self:GetIconFont())
	self:SetIconTextShadow(shadow or self:GetIconShadow())
	self:SetIconTextPos(   pos or self:GetIconTextPos())
end

function PANEL:SetLabelText(text, color, font, pos)
	if self.FakeLabel then
		local spec = {pos=pos, color=color, text=text, font=font, xalign=TEXT_ALIGN_CENTER, yalign=TEXT_ALIGN_CENTER}

		local shadow = self:GetIconTextShadow()
		local opacity = shadow and shadow.opacity or 0
		local offset = shadow and shadow.offset or 0

		local drawfn = shadow and draw.TextShadow or draw.Text

		self.FakeLabel.Paint = function()
			drawfn(spec, offset, opacity)
		end
	end
end

vgui.Register("SimpleIconLabelled", PANEL, "LayeredIcon")