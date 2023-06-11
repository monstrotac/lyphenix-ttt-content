player_manager.AddValidModel( "Gyakushinn Miko", "models/pacagma/houkai_impact_3rd/gyakushinn_miko/gyakushinn_miko_player.mdl" );
player_manager.AddValidHands( "Gyakushinn Miko", "models/pacagma/houkai_impact_3rd/gyakushinn_miko/gyakushinn_miko_arms.mdl", 0, "00000000" )

local Category = "Houkai Impact 3rd"

local NPC = { 	Name = "Gyakushinn Miko - Friendly", 
				Class = "npc_citizen",
				Model = "models/pacagma/houkai_impact_3rd/gyakushinn_miko/gyakushinn_miko_npc.mdl",
				Health = "100",
				KeyValues = { citizentype = 4 },
				Category = Category	}

list.Set( "NPC", "npc_gyakushinn_miko_f", NPC )

local Category = "Houkai Impact 3rd"

local NPC = { 	Name = "Gyakushinn Miko - Hostile", 
				Class = "npc_combine_s",
				Model = "models/pacagma/houkai_impact_3rd/gyakushinn_miko/gyakushinn_miko_npc.mdl",
				Squadname = "Enemies",
				Numgrenades = "3",
				Health = "100",
				Category = Category	}

list.Set( "NPC", "npc_gyakushinn_miko_h", NPC )

