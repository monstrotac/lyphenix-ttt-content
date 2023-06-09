-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

local FILENAME = "rayhud_ttt_binds.txt"
local TTT_RADIO = {}
local GUI = {}
local client = LocalPlayer()
local GetTranslation = LANG.GetTranslation

TTT_RADIO.Commands = {
    {
        id = 1,
        label = "quick_yes"
    },
    {
        id = 2,
        label = "quick_no"
    },
    {
        id = 3,
        label = "quick_help"
    },
    {
        id = 4,
        label = "quick_imwith"
    },
    {
        id = 5,
        label = "quick_see"
    },
    {
        id = 6,
        label = "quick_suspect"
    },
    {
        id = 7,
        label = "quick_traitor"
    },
    {
        id = 8,
        label = "quick_inno"
    },
    {
        id = 9,
        label = "quick_check"
    },
    {
        id = 10,
        label = RayUI.GetPhrase("rayhudttt", "quickcommands_list"),
        tip = RayUI.GetPhrase("rayhudttt", "shortcut_to_all")
    },
    {
        id = 11,
        label = RayUI.GetPhrase("rayhudttt", "enable_disguiser"),
        tip = RayUI.GetPhrase("rayhudttt", "disguiser_tooltip")
    },
    {
        id = 12,
        label = RayUI.GetPhrase("rayhudttt", "open_dmglogs")
    },
    {
        id = 13,
        label = RayUI.GetPhrase("rayhudttt", "recently_weapon")
    }   
}

TTT_RADIO.Storage = {
    ["Data"] = {
        {
            id = 1,
            type = "ttt_radio",
            cmd = "yes",
            key = KEY_NONE
        },
        {
            id = 2,
            type = "ttt_radio",
            cmd = "no",
            key = KEY_NONE
        },
        {
            id = 3,
            type = "ttt_radio",
            cmd = "help",
            key = KEY_NONE
        },
        {
            id = 4,
            type = "ttt_radio",
            cmd = "imwith",
            key = KEY_NONE
        },
        {
            id = 5,
            type = "ttt_radio",
            cmd = "see",
            key = KEY_NONE
        },
        {
            id = 6,
            type = "ttt_radio",
            cmd = "suspect",
            key = KEY_NONE
        },
        {
            id = 7,
            type = "ttt_radio",
            cmd = "traitor",
            key = KEY_NONE
        },
        {
            id = 8,
            type = "ttt_radio",
            cmd = "innocent",
            key = KEY_NONE
        },
        {
            id = 9,
            type = "ttt_radio",
            cmd = "check",
            key = KEY_NONE
        },
        {
            id = 10,
            type = "ttt_radio",
            cmd = "quickchat",
            key = KEY_NONE
        },
        {
            id = 11,
            type = "ttt_toggle_disguise",
            cmd = "",
            key = KEY_NONE
        },
        {
            id = 12,
            type = "damagelog",
            cmd = "",
            key = KEY_NONE
        },
        {
            id = 13,
            type = "lastinv",
            cmd = "",
            key = KEY_NONE
        }
    }
}

RayHUDTTT.Help.CreateSettings(RayUI.GetPhrase("rayhudttt", "binds"), RayUI.Icons.Binds, function(parent)
	RayHUDTTT.Help.CreateCategory(parent, RayUI.GetPhrase("rayhudttt", "binds"), 740 * RayUI.Scale, function(parent)
		for _, v in pairs(TTT_RADIO.Commands) do
			GUI:Row(v.id, v.label, v.tip, parent)
		end
	end)
end)

function GUI:Row(id, label, tip, parent)
    local Main = vgui.Create("DPanel", parent)
	Main:Dock(TOP)
    Main:DockMargin(12 * RayUI.Scale, 6 * RayUI.Scale, 12 * RayUI.Scale, 0)
	Main:SetTall(50 * RayUI.Scale)
	Main.Paint = function( s, w, h )
		draw.RoundedBox(8, 0, 0, w, h, Color(RayUI.Colors.DarkGray6.r, RayUI.Colors.DarkGray6.g, RayUI.Colors.DarkGray6.b, RayUI.Opacity + 20))
	end

    if (string.match(label, "quick_") ~= nil) then
        label = GetTranslation(label)
    end

    label = string.gsub(label, "{player}", client:Nick())
    label = string.Capitalize(label)

	local Label = vgui.Create("DLabel", Main)
	Label:SetText(label)
	Label:SetFont("RayUI:Small")
	Label:SetColor(RayUI.Colors.White)
	Label:SizeToContents()
	Label:SetPos( 32 * RayUI.Scale, (48 * RayUI.Scale) / 2 - Label:GetTall() / 2 )

	local DeleteButton = vgui.Create("DButton", Main)
	DeleteButton:SetWide(30 * RayUI.Scale)
	DeleteButton:Dock(RIGHT)
    DeleteButton:DockMargin(0, 10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale)
    DeleteButton:FormatRayButton("", RayUI.Colors.DarkGray3, RayUI.Colors.Red)
	local ButOldPaint = DeleteButton.Paint		
	DeleteButton.Paint = function( self, w, h )
		ButOldPaint( self, w, h )
			
		surface.SetDrawColor( color_white )
		surface.SetMaterial(RayUI.Icons.Close)
		surface.DrawTexturedRect(8 * RayUI.Scale, 8 * RayUI.Scale, 16 * RayUI.Scale, 16 * RayUI.Scale)
	end
    DeleteButton:SetEnabled(false)

    local keybind = TTT_RADIO:Keybind("GET", id) or KEY_NONE

    local DBinder = vgui.Create("DBinder", Main)
	DBinder:SetWide(80 * RayUI.Scale)
	DBinder:Dock(RIGHT)
    DBinder:DockMargin(0, 10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale)

	DBinder:SetTextColor(RayUI.Colors.White)
    DBinder:FormatRayButton("", RayUI.Colors.Gray, RayUI.Colors.Gray2, 5)
	DBinder:SetFont("RayUI:Small")

    function DBinder:UpdateText()
        local str = input.GetKeyName(self:GetSelectedNumber())
        if ( !str ) then str = "NONE" end

        str = language.GetPhrase( str )
        self:SetText(str:upper())
    end
    DBinder:SetValue(keybind)

    function DBinder:OnChange(num)
        TTT_RADIO:Keybind("SETWRITE", id, num)
    end

    function DeleteButton:DoClick()
        DBinder:SetValue(KEY_NONE)
        DBinder:SetSelected(KEY_NONE)
    end

    function DeleteButton:Think()
        if DBinder:GetSelectedNumber() == 0 then
            self:SetEnabled(false)

            if not DBinder.Trapping then
                DBinder:SetText("Set Key")
            end
        else
            self:SetEnabled(true)
        end
    end
end

function TTT_RADIO:Keybind(type, id, key)
    for _, v in ipairs(TTT_RADIO.Storage["Data"]) do
        if (v.id == id) then
            if (type == "GET") then
                return tonumber(v.key)
            elseif (type == "SETWRITE") then
                v.key = key
                TTT_RADIO:Write()
            elseif (type == "SET") then
                v.key = key
                v.p = false
            end
        end
    end
end

function TTT_RADIO:Write()
    local JSON = util.TableToJSON(self.Storage)
    file.Write(FILENAME, JSON)
end

function TTT_RADIO:Read()
    if (not file.Exists(FILENAME, "DATA") or file.Size(FILENAME, "DATA") == 0) then
        self:Write()
    else
        local raw = file.Read(FILENAME, "DATA")
        raw = util.JSONToTable(raw)

        for _, v in pairs(raw["Data"]) do
            self:Keybind("SET", v.id, v.key)
        end
    end
end

hook.Add("PlayerButtonDown", "RayUI:BindListener", function(pl, k)
    if not (IsFirstTimePredicted()) then return end
    if not (gui.MouseX() == 0 and gui.MouseY() == 0) then return end
    local binds = TTT_RADIO.Storage["Data"]

    for i = 1, #binds do
        if (binds[i].key and binds[i].key == k) then
            if (binds[i].cmd == "quickchat") then
                RADIO:ShowRadioCommands(not RADIO.Show)
            else
                RunConsoleCommand(binds[i].type, binds[i].cmd)
            end
        end
    end
end)

TTT_RADIO:Read()