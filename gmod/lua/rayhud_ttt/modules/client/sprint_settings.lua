-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

if not TTTSprint then return end

local KeySelected = ""
local KeySelected2 = ""
local ActivateKey = GetConVar( "ttt_sprint_activate_key" )
local DoubleTapTime = ""

RayHUDTTT.Help.CreateSettings("Sprint Settings", RayUI.Icons.Run, function(parent)

	RayHUDTTT.Help.CreateCategory(parent, "General Settings", 120 * RayUI.Scale, function(parent)
		RayUI:MakeCheckbox(parent, "ttt_fgaddons_textmessage", "Print chat message at the beginning of the round (TTT FG Addons)")
		RayUI:MakeSlider(parent, "ttt_sprint_crosshairdebugsize", "Crosshair debug size (0 = off)", 0, 3, 1)
	end)

	RayHUDTTT.Help.CreateCategory(parent, "Controls", 100 * RayUI.Scale, function(parent)

		local Activation = RayUI:MakeComboBox(parent, "Activation method:")
		
		local function SelectedKey()
			if ActivateKey:GetFloat() == 0 then
				KeySelected = "Use Key"
			elseif ActivateKey:GetFloat() == 1 then
				KeySelected = "Shift Key"
			elseif ActivateKey:GetFloat() == 2 then
				KeySelected = "Control Key"
			elseif ActivateKey:GetFloat() == 3 then
				KeySelected = "Custom Key"
			elseif ActivateKey:GetFloat() == 4 then
				KeySelected = "Double tap"
			else
				KeySelected = " "
			end
		end

		local function KeySettingExtra()
			if KeySelected == "Custom Key" then
				if IsValid(DoubleTapTime) then DoubleTapTime:Remove() end


		--		settings_sprint_tabII:TextEntry("Key Number:", "ttt_sprint_activate_key_custom")
	
		--		local Link = vgui.Create("DLabelURL")
		--		Link:SetText("Key Numbers: https://wiki.garrysmod.com/page/Enums/KEY")
		--		Link:SetURL("https://wiki.garrysmod.com/page/Enums/KEY")
	

				

			elseif KeySelected == "Double tap" then
		--		settings_sprint_tabII:NumSlider("Double tap time", "ttt_sprint_doubletaptime", 0.001, 1, 2)
				DoubleTapTime = RayUI:MakeSlider(parent, "ttt_sprint_doubletaptime", "Double tap time",  0.001, 1, 2)
			else
				if IsValid(DoubleTapTime) then DoubleTapTime:Remove() end
			end
		end


		local function AddComboBox()
			Activation:Clear()
			Activation:SetValue(KeySelected)
			Activation:AddChoice("Use Key")
			Activation:AddChoice("Shift Key")
			Activation:AddChoice("Control Key")
			Activation:AddChoice("Custom Key")
			Activation:AddChoice("Double tap")
		end

		function Activation:OnSelect(table_key_box, key, data_key_box)
			if key == "Use Key" then
				RunConsoleCommand("ttt_sprint_activate_key", "0")
			elseif key == "Shift Key" then
				RunConsoleCommand("ttt_sprint_activate_key", "1")
			elseif key == "Control Key" then
				RunConsoleCommand("ttt_sprint_activate_key", "2")
			elseif key == "Custom Key" then
				RunConsoleCommand("ttt_sprint_activate_key", "3")
			elseif key == "Double tap" then
				RunConsoleCommand("ttt_sprint_activate_key", "4")
			end

		--	settings_sprint_tabII:Clear()

			KeySelected = key

			AddComboBox()
			KeySettingExtra()
		end

		SelectedKey()
		AddComboBox()
		KeySettingExtra()
	end)
end)

hook.Remove("HUDPaint", "SprintHUD")