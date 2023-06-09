-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

local BoostList = {
	{
		name = "show_fps",
		real_name = RayUI.GetPhrase("rayhudttt", "enable_fps"),
		commands = {
			cl_showfps = 1
		}
	},
	{
		name = "multicore_rendering",
		real_name = RayUI.GetPhrase("rayhudttt", "enable_multicore"),
		commands = {
			gmod_mcore_test = 1,
			mat_queue_mode = -1,
			cl_threaded_bone_setup = 1,
			cl_threaded_client_leaf_system = 1,
			r_queued_ropes = 1,
			r_threaded_renderables = 1,
			r_threaded_particles = 1,
			r_threaded_client_shadow_manager = 1,
			studio_queue_mode = 1
		}
	},
	{
		name = "hardware_acceleration",
		real_name = RayUI.GetPhrase("rayhudttt", "enable_hardware_acc"),
		commands = {
			r_fastzreject = -1
		}
	},
	{
		name = "shadows",
		real_name = RayUI.GetPhrase("rayhudttt", "disable_shadows"),
		commands = {
			mat_shadowstate = 0,
			r_shadowmaxrendered = 0,
			r_shadowrendertotexture = 0,
			r_shadows = 0,
			nb_shadow_dist = 0,
		}
	},
	{
		name = "disable_skybox",
		real_name = RayUI.GetPhrase("rayhudttt", "disable_skybox"),
		commands = {
			r_3dsky = 0,
		}
	},
	{
		name = "sprays",
		real_name = RayUI.GetPhrase("rayhudttt", "disable_sprays"),
		commands = {
			cl_playerspraydisable = 1,
			r_spray_lifetime = 0,
		}
	},
	{
		name = "gibs",
		real_name = RayUI.GetPhrase("rayhudttt", "disable_gibs"),
		help = RayUI.GetPhrase("rayhudttt", "disable_gibs_help"),
		commands = {
			cl_phys_props_enable = 0,
			cl_phys_props_max = 0,
			props_break_max_pieces = 0,
			r_propsmaxdist = 1,
			violence_agibs = 0,
			violence_hgibs = 0,
		}
	},
}

RayHUDTTT.Help.CreateSettings("FPS Booster", RayUI.Icons.Energy, function(parent)
	RayHUDTTT.Help.CreateCategory(parent, "FPS Booster", 400 * RayUI.Scale, function(parent)
		for _, boost in ipairs(BoostList) do
			local boost_help = boost.help and " - "..boost.help or ""

			local boost_check = RayUI:MakeCheckbox(parent, nil, boost.real_name..""..boost_help)

			local setting_on = cookie.GetNumber("FPS_Booster:" .. boost.name, 0) == 1
			boost_check:SetChecked(setting_on)
				
			if (setting_on) then
				for command, value in pairs(boost.commands) do
					RunConsoleCommand(command, value)
				end
			end
				
			function boost_check:OnChange(val)
				if val then
					cookie.Set("FPS_Booster:" .. boost.name, 1)
					for command, value in pairs(boost.commands) do
						RunConsoleCommand(command, value)
					end
				else
					cookie.Set("FPS_Booster:" .. boost.name, 0)
					for command, value in pairs(boost.commands) do
						local convar = GetConVar(command)
						if (convar) then
							local default = tonumber(convar:GetDefault())
							if (default) then
								RunConsoleCommand(command, default)
							end
						end
					end
				end
			end
		end
	end)
end)