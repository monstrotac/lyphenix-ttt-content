-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

local T = LANG.GetTranslation
local PT = LANG.GetParamTranslation

local is_dmg = util.BitSet

local dtt = { search_dmg_crush = DMG_CRUSH, search_dmg_bullet = DMG_BULLET, search_dmg_fall = DMG_FALL, 
search_dmg_boom = DMG_BLAST, search_dmg_club = DMG_CLUB, search_dmg_drown = DMG_DROWN, search_dmg_stab = DMG_SLASH, 
search_dmg_burn = DMG_BURN, search_dmg_tele = DMG_SONIC, search_dmg_car = DMG_VEHICLE }

local function DmgToText(d)
	for k, v in pairs(dtt) do
		if is_dmg(d, v) then
			return T(k)
		end
	end
	if is_dmg(d, DMG_DIRECT) then
		return T("search_dmg_burn")
	end
	return T("search_dmg_other")
end

local dtm = { bullet = DMG_BULLET, rock = DMG_CRUSH, splode = DMG_BLAST, fall = DMG_FALL, fire = DMG_BURN }

local function DmgToMat(d)
	for k, v in pairs(dtm) do
		if is_dmg(d, v) then
			return k
		end
	end
	if is_dmg(d, DMG_DIRECT) then
		return "fire"
	else
		return "skull"
	end
end

local function WeaponToIcon(d)
	local wep = util.WeaponForClass(d)
	return wep and wep.Icon or "vgui/ttt/icon_nades"
end

local TypeToMat = {
	nick="id",
	words="halp",
	eq_armor="armor",
	eq_radar="radar",
	eq_disg="disguise",
	role={[ROLE_TRAITOR]="traitor", [ROLE_DETECTIVE]="det", [ROLE_INNOCENT]="inno"},
	c4="code",
	dmg=DmgToMat,
	wep=WeaponToIcon,
	head="head",
	dtime="time",
	stime="wtester",
	lastid="lastid",
	kills="list"
}

-- Accessor for better fail handling
local function IconForInfoType(t, data)
	local base = "vgui/ttt/icon_"
	local mat = TypeToMat[t]

	if type(mat) == "table" then
		mat = mat[data]
	elseif type(mat) == "function" then
		mat = mat(data)
	end

	if not mat then
		mat = TypeToMat["nick"]
	end

	if t != "wep" then
		return base .. mat
	else
		return mat
	end
end


function PreprocSearch(raw)
	local search = {}
	for t, d in pairs(raw) do
		search[t] = {img=nil, text="", p=10}

		if t == "nick" then
			search[t].text = PT("search_nick", {player = d})
			search[t].p = 1
			search[t].nick = d
		elseif t == "role" then
			if d == ROLE_TRAITOR then
				search[t].text = T("search_role_t")
			elseif d == ROLE_DETECTIVE then
				search[t].text = T("search_role_d")
			else
				search[t].text = T("search_role_i")
			end

			search[t].p = 2
		elseif t == "words" then
			if d != "" then
				local final = string.match(d, "[\\.\\!\\?]$") != nil
				search[t].text = PT("search_words", {lastwords = d .. (final and "" or "--.")})
			end
		elseif t == "eq_armor" then
			if d then
				search[t].text = T("search_armor")
				search[t].p = 17
			end
		elseif t == "eq_disg" then
			if d then
				search[t].text = T("search_disg")
				search[t].p = 18
			end -- 76561198121455451
		elseif t == "eq_radar" then
			if d then
				search[t].text = T("search_radar")
				search[t].p = 19
			end
		elseif t == "c4" then
         if d > 0 then
            search[t].text= PT("search_c4", {num = d})
         end
      elseif t == "dmg" then
         search[t].text = DmgToText(d)
         search[t].p = 12
      elseif t == "wep" then
         local wep = util.WeaponForClass(d)
         local wname = wep and LANG.TryTranslation(wep.PrintName)

         if wname then
            search[t].text = PT("search_weapon", {weapon = wname})
         end
      elseif t == "head" then
         if d then
            search[t].text = T("search_head")
         end
         search[t].p = 15
      elseif t == "dtime" then
         if d != 0 then
            local ftime = util.SimpleTime(d, "%02i:%02i")
            search[t].text = PT("search_time", {time = ftime})

            search[t].text_icon = ftime

            search[t].p = 8
         end
      elseif t == "stime" then
         if d > 0 then
            local ftime = util.SimpleTime(d, "%02i:%02i")
            search[t].text = PT("search_dna", {time = ftime})

            search[t].text_icon = ftime
         end
      elseif t == "kills" then
         local num = table.Count(d)
         if num == 1 then
            local vic = Entity(d[1])
            local dc = d[1] == -1 -- disconnected
            if dc or (IsValid(vic) and vic:IsPlayer()) then
               search[t].text = PT("search_kills1", {player = (dc and "<Disconnected>" or vic:Nick())})
            end
         elseif num > 1 then
            local txt = T("search_kills2") .. "\n"

            local nicks = {}
            for k, idx in pairs(d) do
               local vic = Entity(idx)
               local dc = idx == -1
               if dc or (IsValid(vic) and vic:IsPlayer()) then
                  table.insert(nicks, (dc and "<Disconnected>" or vic:Nick()))
               end
            end

            local last = #nicks
            txt = txt .. table.concat(nicks, "\n", 1, last)
            search[t].text = txt
         end

         search[t].p = 30
      elseif t == "lastid" then
         if d and d.idx != -1 then
            local ent = Entity(d.idx)
            if IsValid(ent) and ent:IsPlayer() then
               search[t].text = PT("search_eyes", {player = ent:Nick()})

               search[t].ply = ent
            end
         end
      else
         -- Not matching a type, so don't display
         search[t] = nil
      end

      -- anything matching a type but not given a text should be removed
      if search[t] and search[t].text == "" then
         search[t] = nil
      end

      -- if there's still something here, we'll be showing it, so find an icon
      if search[t] then
         search[t].img = IconForInfoType(t, d)
      end
   end

	hook.Call("TTTBodySearchPopulate", nil, search, raw)

	return search
end


-- Returns a function meant to override OnActivePanelChanged, which modifies
-- dactive and dtext based on the search information that is associated with the
-- newly selected panel
local function SearchInfoController(search, dactive, dtext)
	return function(s, pold, pnew)
		local t = pnew.info_type
		local data = search[t]
		if not data then
			ErrorNoHalt("Search: data not found", t, data,"\n")
			return
		end

		dtext:SetText(data.text)
		dtext:SizeToContents()
		dactive:SetImage(data.img)
	end
end

local function ShowSearchScreen(search_raw)
	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	local Margin = 8 * RayUI.Scale

	local SearchPanel = vgui.Create("RayUI:MainPanel")
	SearchPanel:SetSize(440 * RayUI.Scale, 286 * RayUI.Scale)
	SearchPanel:SetTitle(T("search_title") .. " - " .. search_raw.nick or "???")
	SearchPanel:Center()
	SearchPanel:MakePopup()

	-- icon list wrapper
	local IconWrapper = vgui.Create("DPanel", SearchPanel)
	IconWrapper:Dock(TOP)
	IconWrapper:DockMargin(Margin, Margin, Margin, 0)
	IconWrapper:SetTall(74 * RayUI.Scale)
	IconWrapper.Paint = function( s, w, h )
		draw.RoundedBox( 5, 0, 0, w, h, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 20) )
	end
	
	-- desc wrapper
	local DescWrapper = vgui.Create("DPanel", SearchPanel)
	DescWrapper:Dock(TOP)
	DescWrapper:DockMargin(Margin, Margin, Margin, 0)
	DescWrapper:SetTall(90 * RayUI.Scale)
	DescWrapper.Paint = function( s, w, h )
		draw.RoundedBox( 5, 0, 0, w, h, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 20) )
	end

	-- buttons wrapper
	local ButonsWrapper = vgui.Create("DPanel", SearchPanel)
	ButonsWrapper:Dock(TOP)
	ButonsWrapper:DockMargin(Margin, Margin, Margin, 0)
	ButonsWrapper:SetTall(50 * RayUI.Scale)
	ButonsWrapper.Paint = function( s, w, h )
		draw.RoundedBox( 5, 0, 0, w, h, Color(RayUI.Colors.DarkGray3.r, RayUI.Colors.DarkGray3.g, RayUI.Colors.DarkGray3.b, RayUI.Opacity + 20) )
	end

	-- icon list
	local dlist = vgui.Create("DPanelSelect", IconWrapper)
	dlist:Dock(FILL)
	dlist:DockMargin(5 * RayUI.Scale, 5 * RayUI.Scale, 5 * RayUI.Scale, 5 * RayUI.Scale)
	dlist:EnableVerticalScrollbar(true)
	dlist:EnableHorizontal(true)

	if dlist.VBar then
		dlist.VBar:Remove()
		dlist.VBar = nil
	end

	-- description area
	local dscroll = vgui.Create("DHorizontalScroller", dlist)
	dscroll:Dock(FILL)
	dscroll:SetOverlap( -4 )
	
	local dactive = vgui.Create("DImage", DescWrapper)
	dactive:SetImage("vgui/ttt/icon_id")
	dactive:Dock(LEFT)
	dactive:DockMargin(4 * RayUI.Scale, 4 * RayUI.Scale, 4 * RayUI.Scale, 4 * RayUI.Scale)
	dactive:SetWide(78 * RayUI.Scale)

	local dtext = RayUI:MakeLabel("...", "RayUI.Normal:Smallest", RayUI.Colors.White, DescWrapper)
	dtext:Dock(TOP)
	dtext:DockMargin(4 * RayUI.Scale, 10 * RayUI.Scale, 0, 0)
	dtext:SetContentAlignment(7)
	dtext:SetWrap(true)

	-- buttons

	local ButtonW = 132 * RayUI.Scale

	local CallButton = vgui.Create("DButton", ButonsWrapper)
	CallButton:SetPos(Margin, Margin)
	CallButton:SetSize(ButtonW, ButonsWrapper:GetTall() - Margin * 2)
	CallButton:SetDisabled(ply:IsSpec() or table.HasValue(ply.called_corpses or {}, search_raw.eidx))
	CallButton.DoClick = function(self)
		ply.called_corpses = ply.called_corpses or {}
		table.insert(ply.called_corpses, search_raw.eidx)
		RunConsoleCommand("ttt_call_detective", search_raw.eidx)
		self:SetEnabled(false)
	end
	CallButton:FormatRayButton(T("search_call"), RayUI.Colors.Gray, RayUI.Colors.Blue)
		
	local id = search_raw.eidx + search_raw.dtime
	local ConfirmButton = vgui.Create("DButton", ButonsWrapper)
	ConfirmButton:SetPos(select(1, CallButton:GetPos()) + ButtonW + Margin, Margin)
	ConfirmButton:SetSize(ButtonW, ButonsWrapper:GetTall() - Margin * 2)
	ConfirmButton:SetDisabled(ply:IsSpec() or (not ply:KeyDownLast(IN_WALK)))
	ConfirmButton.DoClick = function(self)
		RunConsoleCommand("ttt_confirm_death", search_raw.eidx, id)
		self:SetEnabled(false)
	end
	ConfirmButton:FormatRayButton(T("search_confirm"), RayUI.Colors.Gray, RayUI.Colors.Green)

	local CloseButton = vgui.Create("DButton", ButonsWrapper)
	CloseButton:SetPos(select(1, ConfirmButton:GetPos()) + ButtonW + Margin, Margin)
	CloseButton:SetSize(ButtonW, ButonsWrapper:GetTall() - Margin * 2)
	CloseButton:FormatRayButton(T("close"), RayUI.Colors.Gray, RayUI.Colors.Red)
	CloseButton.DoClick = function(self)
		SearchPanel:Remove()
	end

	local search = PreprocSearch(search_raw)

	dlist.OnActivePanelChanged = SearchInfoController(search, dactive, dtext)

	local start_icon = nil
	for t, info in SortedPairsByMemberValue(search, "p") do
		local ic = nil

		-- Certain items need a special icon conveying additional information
		if t == "nick" then
			local avply = IsValid(search_raw.owner) and search_raw.owner or nil

			ic = vgui.Create("SimpleIconAvatar", dlist)
			ic:SetPlayer(avply)

			start_icon = ic
		elseif t == "lastid" then
			ic = vgui.Create("SimpleIconAvatar", dlist)
			ic:SetPlayer(info.ply)
			ic:SetAvatarSize(64 * RayUI.Scale)
		elseif info.text_icon then
			ic = vgui.Create("SimpleIconLabelled", dlist)
			ic:SetIconText(info.text_icon)
			ic:SetIconFont("RayUI:Medium")
		else
			ic = vgui.Create("SimpleIcon", dlist)
		end

		ic:SetIconSize(64 * RayUI.Scale)
		ic:SetIcon(info.img)

		ic.info_type = t

		dlist:AddPanel(ic)
		dscroll:AddPanel(ic)
	end

	dlist:SelectPanel(start_icon)

	SearchPanel:MakePopup()
end

local function StoreSearchResult(search)
	if search.owner then
		local ply = search.owner
		if (not ply.search_result) or ply.search_result.show then

			ply.search_result = search

			local rag = Entity(search.eidx)
			if IsValid(rag) then
				rag.search_result = search
			end
		end
	end
end

local function bitsRequired(num)
	local bits, max = 0, 1
	while max <= num do
		bits = bits + 1
		max = max + max
	end
	return bits
end

local search = {}
local function ReceiveRagdollSearch()
   search = {}

   -- Basic info
   search.eidx = net.ReadUInt(16)

   search.owner = Entity(net.ReadUInt(8))
   if not (IsValid(search.owner) and search.owner:IsPlayer() and (not search.owner:IsTerror())) then
      search.owner = nil
   end

   search.nick = net.ReadString()

   -- Equipment
   local eq = net.ReadUInt(16)

   -- All equipment pieces get their own icon
   search.eq_armor = util.BitSet(eq, EQUIP_ARMOR)
   search.eq_radar = util.BitSet(eq, EQUIP_RADAR)
   search.eq_disg = util.BitSet(eq, EQUIP_DISGUISE)

   -- Traitor things
   search.role = net.ReadUInt(2)
   search.c4 = net.ReadInt(bitsRequired(C4_WIRE_COUNT) + 1)

   -- Kill info
   search.dmg = net.ReadUInt(30)
   search.wep = net.ReadString()
   search.head = net.ReadBit() == 1
   search.dtime = net.ReadInt(16)
   search.stime = net.ReadInt(16)

   -- Players killed
   local num_kills = net.ReadUInt(8)
   if num_kills > 0 then
      search.kills = {}
      for i=1,num_kills do
         table.insert(search.kills, net.ReadUInt(8))
      end
   else
      search.kills = nil
   end

   search.lastid = {idx=net.ReadUInt(8)}

   -- should we show a menu for this result?
   search.finder = net.ReadUInt(8)

   search.show = (LocalPlayer():EntIndex() == search.finder)

   --
   -- last words
   --
   local words = net.ReadString()
   search.words = (words ~= "") and words or nil
   
   hook.Call("TTTBodySearchEquipment", nil, search, eq)

   if search.show then
      ShowSearchScreen(search)


	  print("gowno")
   end

   StoreSearchResult(search)

   search = nil
end
net.Receive("TTT_RagdollSearch", ReceiveRagdollSearch)