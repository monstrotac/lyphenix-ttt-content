local icol = Color( 255, 255, 255, 255 ) 
if CLIENT then

	killicon.Add(  "m9k_acr",		"vgui/hud/m9k_acr", icol  )
	killicon.Add(  "m9k_ak47",		"vgui/hud/m9k_ak47", icol  )
	killicon.Add(  "m9k_ak74",		"vgui/hud/m9k_ak74", icol  )
	killicon.Add(  "m9k_auga3",		"vgui/hud/m9k_auga3", icol  )
	killicon.Add(  "m9k_fal",		"vgui/hud/m9k_fal", icol )
	killicon.Add(  "m9k_famas",		"vgui/hud/m9k_famas", icol  )
	killicon.Add(  "m9k_f2000",		"vgui/hud/m9k_f2000", icol )
	killicon.Add(  "m9k_g3a3",		"vgui/hud/m9k_g3a3", icol )
	killicon.Add(  "m9k_g36", 		"vgui/hud/m9k_g36", icol )
	killicon.Add(  "m9k_l85", 		"vgui/hud/m9k_l85", icol )
	killicon.Add(  "m9k_m4a1", 		"vgui/hud/m9k_m4a1", icol )
	killicon.Add(  "m9k_m14sp", 	"vgui/hud/m9k_m14sp", icol )
	killicon.Add(  "m9k_m16a4_acog", "vgui/hud/m9k_m16a4_acog", icol )
	killicon.Add(  "m9k_m416", 		"vgui/hud/m9k_m416", icol )
	killicon.Add(  "m9k_scar", 		"vgui/hud/m9k_scar", icol )
	killicon.Add(  "m9k_val", 		"vgui/hud/m9k_val", icol )
	killicon.Add(  "m9k_vikhr", 	"vgui/hud/m9k_vikhr", icol )
	killicon.Add(  "m9k_winchester73", "vgui/hud/m9k_winchester73", icol  )
	killicon.Add(  "m9k_tar21", 	"vgui/hud/m9k_tar21", icol )
	killicon.Add(  "m9k_amd65", 	"vgui/hud/m9k_amd65", icol )
	killicon.Add(  "m9k_an94", 		"vgui/hud/m9k_an94", icol )

end

if GetConVar("M9KWeaponStrip") == nil then
	CreateConVar("M9KWeaponStrip", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Allow empty weapon stripping? 1 for true, 0 for false")
	print("Weapon Strip con var created")
end
	
if GetConVar("M9KDisablePenetration") == nil then
	CreateConVar("M9KDisablePenetration", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Disable Penetration and Ricochets? 1 for true, 0 for false")
	print("Penetration/ricochet con var created")
end
	
if GetConVar("M9KDynamicRecoil") == nil then
	CreateConVar("M9KDynamicRecoil", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Use Aim-modifying recoil? 1 for true, 0 for false")
	print("Recoil con var created")
end
	
if GetConVar("M9KUniqueSlots") == nil then
	CreateConVar("M9KUniqueSlots", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Give M9K Weapons unique slots? 1 for true, 2 for false. A map change may be required.")
	print("Unique Slots con var created")
end
	
if GetConVar("M9KDisableHolster") == nil then
	CreateConVar("M9KDisableHolster", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Disable my totally worthless and broken holster system? Won't hurt my feelings any. 1 for true, 2 for false. A map change may be required.")
	print("Holster Disable con var created")
end
	
if GetConVar("M9KAmmoDetonation") == nil then
	CreateConVar("M9KAmmoDetonation", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Enable detonatable M9K Ammo crates? 1 for true, 0 for false.")
	print("Ammo crate detonation con var created")
end

if GetConVar("DebugM9K") == nil then
	CreateConVar("DebugM9K", "0", { FCVAR_REPLICATED, FCVAR_ARCHIVE }, "Debugging for some m9k stuff, turning it on won't change much.")
end
	
if !game.SinglePlayer() then

	if CLIENT then
		if GetConVar("M9KGasEffect") == nil then
			CreateClientConVar("M9KGasEffect", "1", true, true)
			print("Client-side Gas Effect Con Var created")
		end
	end

else
	if GetConVar("M9KGasEffect") == nil then
		CreateConVar("M9KGasEffect", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Use gas effect when shooting? 1 for true, 0 for false")
		print("Gas effect con var created")
	end
end

//AN-94
sound.Add({
	name = 			"an94.single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/an94/galil-1.wav"
})
sound.Add({
	name = 			"an94.double",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/an94/doubletap.wav"
})

sound.Add({
	name = 			"Weapon_an-94.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/an94/clipout.mp3"
})

sound.Add({
	name = 			"Weapon_an-94.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/an94/clipin.mp3"
})

sound.Add({
	name = 			"Weapon_an-94.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/an94/boltpull.mp3"
})

sound.Add({
	name = 			"Weapon_an-94.Draw",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/an94/draw.mp3"
})

//AMD 65
sound.Add({
	name = 			"amd65.single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/amd65/amd-1.wav"
})

sound.Add({
	name = 			"amd65.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/amd65/clipout.mp3"
})

sound.Add({
	name = 			"amd65.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/amd65/magin2.mp3"
})

sound.Add({
	name = 			"amd65.BoltPull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/amd65/boltpull.mp3"
})

sound.Add({
	name = 			"amd65.BoltBack",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/amd65/boltrelease.mp3"
})

//tavor
sound.Add({
	name = 			"Wep_imitavor.single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/tavor/famas-1.wav"
})

sound.Add({
	name = 			"Wep_imitavor.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tavor/famas_clipout.mp3"
})

sound.Add({
	name = 			"Wep_imitavor.Clipout1",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tavor/famas_clipout1.mp3"
})

sound.Add({
	name = 			"Wep_imitavor.Tap",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tavor/famas_tap.mp3"
})

sound.Add({
	name = 			"Wep_imitavor.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tavor/famas_clipin.mp3"
})

sound.Add({
	name = 			"Wep_imitavor.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tavor/famas_boltpull.mp3"
})

sound.Add({
	name = 			"Wep_imitavor.Boltrelease",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tavor/famas_boltrelease.mp3"
})

sound.Add({
	name = 			"Wep_imitavor.Cloth",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tavor/famas_cloth.mp3"
})

//f2000
sound.Add({
	name = 			"Weapon_F2000.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = {"weapons/fokku_tc_f2000/shot-1.wav",
			"weapons/fokku_tc_f2000/shot-2.wav",
			"weapons/fokku_tc_f2000/shot-3.wav",
			"weapons/fokku_tc_f2000/shot-4.wav"}	
})

sound.Add({
	name = 			"f2000.playerbreathing",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_f2000/playerbreathing.mp3"	
})

sound.Add({
	name = 			"f2000.lightcloth",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_f2000/cloth2.mp3"	
})

sound.Add({
	name = 			"f2000.heavycloth",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_f2000/cloth.mp3"	
})

sound.Add({
	name = 			"f2000.magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_f2000/clipout.mp3"	
})

sound.Add({
	name = 			"f2000.magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_f2000/clipin.mp3"	
})

sound.Add({
	name = 			"f2000.boltback",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound ={"weapons/fokku_tc_f2000/chargeback.mp3",
			"weapons/fokku_tc_f2000/chargeback1.mp3"}	
})

sound.Add({
	name = 			"f2000.boltforward",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = {"weapons/fokku_tc_f2000/chargefor.mp3",
			"weapons/fokku_tc_f2000/chargefor1.mp3"}	
})

//ak-47
sound.Add({
	name = 			"47ak.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = "weapons/AYKAYFORTY/ak47-1.wav"
})

sound.Add({
	name = 			"47ak.Bolt",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/AYKAYFORTY/bolt.mp3" 
})

sound.Add({
	name = 			"47ak.magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/AYKAYFORTY/magin.mp3" 
})

sound.Add({
	name = 			"47ak.magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/AYKAYFORTY/magout.mp3" 
})

//m14
sound.Add({
	name = 			"Weapon_M14SP.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_m14/sg550-1.wav"
})

sound.Add({
	name = 			"Weapon_M14SP.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_m14/sg550_clipout.mp3"
})

sound.Add({
	name = 			"Weapon_M14SP.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_m14/sg550_clipin.mp3"
})

sound.Add({
	name = 			"Weapon_M14SP.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_m14/sg550_boltpull.mp3"
})

sound.Add({
	name = 			"Weapon_M14.Deploy",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_m14/sg550_deploy.mp3"
})

//g36
sound.Add({
	name =				"G36.single",
	channel =			CHAN_USER_BASE+10,
	volume =			1.0,
	sound =				"weapons/G36/m4a1_unsil-1.wav"
})

sound.Add({
	name =	"G36.Boltback",
	channel		= CHAN_ITEM,
	volume		= 1,
	sound			= "weapons/G36/Boltback.mp3"
})

sound.Add({
	name =	"G36.BoltPull",
	channel		= CHAN_ITEM,
	volume		= 1,
	sound			= "weapons/G36/BoltPull.mp3"
})

sound.Add({
	name =	"G36.Cloth",
	channel		= CHAN_ITEM,
	volume		= 1,
	sound			= "weapons/G36/Cloth.mp3"
})

sound.Add({
	name =	"G36.PocketRussle",
	channel		= CHAN_ITEM,
	volume		= 1,
	sound			= "weapons/G36/PocketRussle.mp3"
})

sound.Add({
	name =	"G36.MagOut",
	channel		= CHAN_ITEM,
	volume		= 1,
	sound			= "weapons/G36/MagOut.mp3"
})

sound.Add({
	name =	"G36.MagFiddle",
	channel		= CHAN_ITEM,
	volume		= 1,
	sound			= "weapons/G36/MagFiddle.mp3"
})

sound.Add({
	name =	"G36.MagSlap",
	channel		= CHAN_ITEM,
	volume		= 1,
	sound			= "weapons/G36/MagSlap.mp3"
})

sound.Add({
	name =	"G36.PlaceSilencer",
	channel 		= CHAN_ITEM,
	volume 		= 1,
	sound		= "weapons/G36/PlaceSilencer.mp3"
})

sound.Add({
	name =	"G36.TightenSilencer",
	channel		= CHAN_ITEM,
	volume		= 1,
	sound			= "weapons/G36/TightenSilencer.mp3"
})

sound.Add({
	name =	"G36.SpinSilencer",
	channel		= CHAN_ITEM,
	volume		= 1,
	sound			= "weapons/G36/SpinSilencer.mp3"
})

sound.Add({
	name =	"G36.Safety",
	channel		= CHAN_ITEM,
	volume		= 1,
	sound			= "weapons/G36/Safety.mp3"
})

//winchester 1873
sound.Add({
	name = 			"Weapon_73.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/winchester73/w73-1.wav"	
})

sound.Add({
	name = 			"Weapon_73.Pump",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/winchester73/w73pump.mp3"
})

sound.Add({
	name = 			"Weapon_73.Insertshell",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/winchester73/w73insertshell.mp3"
})

//l85
sound.Add({
	name = 			"Weapon_l85.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/L85A2/aug-1.wav"
})

sound.Add({
	name = 			"Weapon_l85.magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/L85A2/magin.mp3"
})

sound.Add({
	name = 			"Weapon_l85.magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/L85A2/magout.mp3"
})

sound.Add({
	name = 			"Weapon_l85.boltslap",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/L85A2/boltslap.mp3"
})

sound.Add({
	name = 			"Weapon_l85.boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/L85A2/boltpull.mp3"
})

sound.Add({
	name = 			"Weapon_l85.cloth",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/L85A2/cloth.mp3"
})

sound.Add({
	name = 			"Weapon_l85.Tap",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/L85A2/tap.mp3"
})	

//aug a3
sound.Add({
	name = 			"aug_a3.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = {"weapons/auga3/aug-1.wav",
			"weapons/auga3/aug-2.wav"}
})

sound.Add({
	name = 			"Weap_auga3.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/auga3/clipout.mp3"
})

sound.Add({
	name = 			"Weap_auga3.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/auga3/clipin.mp3"
})

sound.Add({
	name = 			"Weap_auga3.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/auga3/boltpull.mp3"
})

sound.Add({
	name = 			"Weap_auga3.boltslap",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/auga3/boltslap.mp3"
})

//famas
sound.Add({
	name = 			"Weapon_FAMTC.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = {"weapons/fokku_tc_famas/shot-1.wav", 
 			"weapons/fokku_tc_famas/shot-2.wav" }
})

sound.Add({
	name = 			"Weapon_FAMTC.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_famas/famas_clipout.mp3" 
})

sound.Add({
	name = 			"Weapon_FAMTC.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_famas/famas_clipin.mp3" 
})

sound.Add({
	name = 			"Weapon_FAMTC.forearm",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_famas/famas_forearm.mp3" 
})

//Val
sound.Add({
	name = 			"Dmgfok_vally.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/dmg_val/galil-1.wav"
})

sound.Add({
	name = 			"Dmgfok_vally.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_val/galil_clipout.mp3"
})

sound.Add({
	name = 			"Dmgfok_vally.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_val/galil_clipin.mp3"
})

sound.Add({
	name = 			"Dmgfok_vally.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_val/galil_Boltpull.mp3"
})

sound.Add({
	name = 			"Dmgfok_vally.Draw",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_val/draw.mp3"
})

//vikhr
sound.Add({
	name = 			"Dmgfok_vikhr.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/dmg_vikhr/galil-1.wav"
})

sound.Add({
	name = 			"Dmgfok_vikhr.Silenced",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_vikhr/galil-sil.mp3"
})

sound.Add({
	name = 			"Dmgfok_vikhr.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_vikhr/galil_clipout.mp3"
})

sound.Add({
	name = 			"Dmgfok_vikhr.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_vikhr/galil_clipin.mp3"
})

sound.Add({
	name = 			"Dmgfok_vikhr.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_vikhr/galil_Boltpull.mp3"
})

sound.Add({
	name = 			"Dmgfok_vikhr.Draw",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_vikhr/draw.mp3"
})

//magpul masada ACR
sound.Add({
	name = 			"Masada.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			")weapons/masadamagpul/masada_unsil.wav"	
})

sound.Add({
	name = 			"Masada.Cloth1",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/masadamagpul/cloth1.mp3"
})

sound.Add({
	name = 			"Masada.Cloth2",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/masadamagpul/cloth2.mp3"
})

sound.Add({
	name = 			"Masada.Magin1",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/masadamagpul/magin1.mp3"	
})

sound.Add({
	name = 			"Masada.Magin2",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/masadamagpul/magin2.mp3"
})

sound.Add({
	name = 			"Masada.Foley",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/masadamagpul/foley.mp3"
})

sound.Add({
	name = 			"Masada.Magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/masadamagpul/magout.mp3"
})

sound.Add({
	name = 			"Masada.Magslap",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/masadamagpul/magslap.mp3"
})

sound.Add({
	name = 			"Masada.Safety",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/masadamagpul/safety.mp3"
})

sound.Add({
	name = 			"Masada.Chargerback",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/masadamagpul/chargerback.mp3"	
})

sound.Add({
	name = 			"Masada.Boltrelease",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/masadamagpul/boltrelease.mp3"	
})

sound.Add({
	name = 			"Masada.Placesilencer",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/masadamagpul/placesilencer.mp3"
})

sound.Add({
	name = 			"Masada.Removesilencer",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/masadamagpul/removesilencer.mp3"	
})

//m4a1
sound.Add({
	name = 			"Dmgfok_M4A1.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/dmg_m4a1/m4a1_unsil-1.wav"
})

sound.Add({
	name = 			"Dmgfok_M4A1.Silencer_Off",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_m4a1/m4a1_silencer_off.mp3"
})

sound.Add({
	name = 			"Dmgfok_M4A1.Silencer_On",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_m4a1/m4a1_silencer_on.mp3"
})

sound.Add({
	name = 			"Dmgfok_M4A1.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_m4a1/m4a1_clipout.mp3"
})

sound.Add({
	name = 			"Dmgfok_M4A1.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_m4a1/m4a1_clipin.mp3"
})

sound.Add({
	name = 			"Dmgfok_M4A1.Boltrelease",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_m4a1/m4a1_boltrelease.mp3"
})

sound.Add({
	name = 			"Dmgfok_M4A1.Boltrelease2",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_m4a1/m4a1_boltrelease_silenced.mp3"
})

sound.Add({
	name = 			"Dmgfok_M4A1.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_m4a1/m4a1_boltpull.mp3"
})

//m16a4
sound.Add({
	name = 			"Dmgfok_M16A4.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			")weapons/dmg_m16a4/shoot.wav"
})

sound.Add({
	name = 			"Dmgfok_M16A4.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_m16a4/magout.mp3"
})

sound.Add({
	name = 			"Dmgfok_M16A4.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_m16a4/magin.mp3"
})

sound.Add({
	name = 			"Dmgfok_M16A4.Boltrelease",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_m16a4/boltrelease.mp3"
})

sound.Add({
	name = 			"Dmgfok_M16A4.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_m16a4/boltpull.mp3"
})

-- Congratulations, you have found a secret message! Bob says hi, and hopes you are having fun with this addon.

//ak47
sound.Add({
	name = 			"Tactic_AK47.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_ak47/ak47-1.wav"
})

sound.Add({
	name = 			"Tactic_AK47.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_ak47/ak47_clipout.mp3"
})

sound.Add({
	name = 			"Tactic_AK47.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_ak47/ak47_clipin.mp3"
})

sound.Add({
	name = 			"Tactic_AK47.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_ak47/ak47_boltpull.mp3"
})

//SCAR
sound.Add({
	name = 			"Wep_fnscarh.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			{"weapons/fnscarh/aug-1.wav",
						"weapons/fnscarh/aug-2.wav",
						"weapons/fnscarh/aug-3.wav"}
})

sound.Add({
	name = 			"Wep_fnscar.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fnscarh/aug_boltpull.mp3"
})

sound.Add({
	name = 			"Wep_fnscar.Boltslap",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fnscarh/aug_boltslap.mp3"
})

sound.Add({
	name = 			"Wep_fnscar.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fnscarh/aug_clipout.mp3"
})

sound.Add({
	name = 			"Wep_fnscar.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fnscarh/aug_clipin.mp3"
})

//fn fal
sound.Add({
	name = 			"fnfal.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = "weapons/fn_fal/galil-1.wav"
})

sound.Add({
	name = 			"Weapon_fnfal.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fn_fal/galil_clipout.mp3" 
})

sound.Add({
	name = 			"Weapon_fnfal.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fn_fal/galil_clipin.mp3" 
})

sound.Add({
	name = 			"Weapon_fnfal.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fn_fal/galil_boltpull.mp3" 
})

//hk 416
sound.Add({
	name = 			"hk416weapon.SilencedSingle",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = "weapons/twinkie_hk416/m4a1-1.wav"
})

sound.Add({
	name = 			"hk416weapon.UnsilSingle",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = "weapons/twinkie_hk416/m4a1_unsil-1.wav"
})

sound.Add({
	name = 			"hk416weapon.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/twinkie_hk416/m4a1_clipout.mp3"	
})

sound.Add({
	name = 			"hk416weapon.Magtap",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/twinkie_hk416/m4a1_tap.mp3"	
})

sound.Add({
	name = 			"hk416weapon.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/twinkie_hk416/m4a1_clipin.mp3"	
})

sound.Add({
	name = 			"hk416weapon.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/twinkie_hk416/m4a1_boltpull.mp3"	
})

sound.Add({
	name = 			"hk416weapon.Boltrelease",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/twinkie_hk416/m4a1_boltrelease.mp3"	
})

sound.Add({
	name = 			"hk416weapon.Deploy",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/twinkie_hk416/m4a1_deploy.mp3"	
})

sound.Add({
	name = 			"hk416weapon.Silencer_On",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/twinkie_hk416/m4a1_silencer_on.mp3"	
})

sound.Add({
	name = 			"hk416weapon.Silencer_Off",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/twinkie_hk416/m4a1_silencer_off.mp3"	
})

//G3
sound.Add({
	name = 			"hk_g3_weapon.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = "weapons/hk_g3/galil-1.wav"
})

sound.Add({
	name = 			"hk_g3_weapon.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hk_g3/galil_clipout.mp3"	
})

sound.Add({
	name = 			"hk_g3_weapon.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hk_g3/galil_clipin.mp3"	
})

sound.Add({
	name = 			"hk_g3_weapon.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hk_g3/boltpull.mp3"	
})

sound.Add({
	name = 			"hk_g3_weapon.Boltforward",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hk_g3/boltforward.mp3"	
})

sound.Add({
	name = 			"hk_g3_weapon.cloth",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hk_g3/Cloth.mp3"	
})

sound.Add({
	name = 			"hk_g3_weapon.draw",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hk_g3/draw.mp3"	
})

--because it's inevitable that things will break
--[[ if SERVER then

	-- if GetConVar("M9KWeaponStrip") == nil then
		-- CreateConVar("M9KWeaponStrip", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Allow empty weapon stripping? 1 for true, 0 for false")
		-- print("Weapon Strip con var created")
	-- end
	
	-- util.AddNetworkString("StripSynch")
	-- function StripperChangeCallback(cvar, previous, new) --giggity
		-- net.Start("StripSynch")
		-- net.WriteBit(new)
		-- net.Broadcast()
	-- end
	-- cvars.AddChangeCallback("M9KWeaponStrip", StripperChangeCallback)
	
	-- if GetConVar("M9KGasEffect") == nil then
		-- CreateConVar("M9KGasEffect", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Use gas effect when shooting? 1 for true, 0 for false")
		-- print("Gas effect con var created")
	-- end
	
	-- util.AddNetworkString("GasSynch")
	-- function GasSynchCallback(cvar, previous, new)
		-- net.Start("GasSynch")
		-- net.WriteBit(new)
		-- net.Broadcast()
	-- end
	-- cvars.AddChangeCallback("M9KGasEffect", GasSynchCallback)
	
	-- if GetConVar("M9KDisablePenetration") == nil then
		-- CreateConVar("M9KDisablePenetration", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Disable Penetration and Ricochets? 1 for true, 0 for false")
		-- print("Penetration/ricochet con var created")
	-- end
	
	-- util.AddNetworkString("PenetrationSynch")
	-- function PenetrationChangeCallback(cvar, previous, new)
		-- net.Start("PenetrationSynch")
		-- net.WriteBit(new)
		-- net.Broadcast()
	-- end
	-- cvars.AddChangeCallback("M9KDisablePenetration", PenetrationChangeCallback)
	
	-- if GetConVar("M9KDynamicRecoil") == nil then
		-- CreateConVar("M9KDynamicRecoil", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Use Aim-modifying recoil? 1 for true, 0 for false")
		-- print("Recoil con var created")
	-- end
	
	-- util.AddNetworkString("RecoilSynch")
	-- function RecoilChangeCallback(cvar, previous, new)
		-- net.Start("RecoilSynch")
		-- net.WriteBit(new)
		-- net.Broadcast()
	-- end
	-- cvars.AddChangeCallback("M9KDynamicRecoil", RecoilChangeCallback)
	
	-- if GetConVar("M9KUniqueSlots") == nil then
		-- CreateConVar("M9KUniqueSlots", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Give M9K Weapons unique slots? 1 for true, 2 for false. A map change may be required.")
		-- print("Unique Slots con var created")
	-- end
	
	-- util.AddNetworkString("SlotSynch")
	-- function SlotChangeCallback(cvar, previous, new)
		-- net.Start("SlotSynch")
		-- net.WriteBit(new)
		-- net.Broadcast()
	-- end
	-- cvars.AddChangeCallback("M9KUniqueSlots", SlotChangeCallback)
	
	-- if GetConVar("M9KDisableHolster") == nil then
		-- CreateConVar("M9KDisableHolster", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Disable my totally worthless and broken holster system? Won't hurt my feelings any. 1 for true, 2 for false. A map change may be required.")
		-- print("Holster Disable con var created")
	-- end
	
	-- util.AddNetworkString("HolsterSynch")
	-- function HolsterChangeCallback(cvar, previous, new)
		-- net.Start("HolsterSynch")
		-- net.WriteBit(new)
		-- net.Broadcast()
	-- end
	-- cvars.AddChangeCallback("M9KDisableHolster", HolsterChangeCallback)
	
	-- if GetConVar("M9KAmmoDetonation") == nil then
		-- CreateConVar("M9KAmmoDetonation", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Enable detonatable M9K Ammo crates? 1 for true, 0 for false.")
		-- print("Ammo crate detonation con var created")
	-- end
	
	-- util.AddNetworkString("AmmoSynch")
	-- function AmmoChangeCallback(cvar, previous, new)
		-- net.Start("AmmoSynch")
		-- net.WriteBit(new)
		-- net.Broadcast()
	-- end
	-- cvars.AddChangeCallback("M9KAmmoDetonation", AmmoChangeCallback)
	
-- end

-- if CLIENT then

	-- if GetConVar("M9KWeaponStrip") == nil then
		-- CreateClientConVar("M9KWeaponStrip", "1", true, true)
		-- print("client-side Weapon Strip Con Var created")
	-- end
	
	-- if GetConVar("M9KGasEffect") == nil then
		-- CreateClientConVar("M9KGasEffect", "1", true, true)
		-- print("client-side Gas Effect Con Var created")
	-- end
	
	-- if GetConVar("M9KDisablePenetration") == nil then
		-- CreateClientConVar("M9KDisablePenetration", "0", true, true )
		-- print("client-side Penetration/Ricochet Con Var created")
	-- end
	
	-- if GetConVar("M9KDynamicRecoil") == nil then
		-- CreateClientConVar("M9KDynamicRecoil", "1", true, true)
		-- print("client-side Recoil con var created")
	-- end
	
	-- if GetConVar("M9KUniqueSlots") == nil then
		-- CreateClientConVar("M9KUniqueSlots", "0", true, true)
		-- print("Client-side Unique Slots con var created")
	-- end
	
	-- if GetConVar("M9KDisableHolster") == nil then
		-- CreateClientConVar("M9KDisableHolster", "0", true, true)
		-- print("Client-side Disable Holster con var created")
	-- end
	
	
	-- if GetConVar("M9KAmmoDetonation") == nil then
		-- CreateClientConVar("M9KAmmoDetonation", "1", true, true)
		-- print("Client-side ammo detonation con var created")
	-- end

-- end

-- net.Receive("StripSynch", 
-- function(new)
	-- if CLIENT and not game.SinglePlayer() then
	-- RunConsoleCommand("M9KWeaponStrip", tostring(new))
	-- print("Weapon stripping have been synchronized with server.")
	-- end
-- end)

-- net.Receive("GasSynch", 
-- function(new)
	-- if CLIENT and not game.SinglePlayer() then
	-- RunConsoleCommand("M9KGasEffect", tostring(new))
	-- print("Gas Effect has been synchronized with server.")
	-- end
-- end)

-- net.Receive("PenetrationSynch", 
-- function(new)
	-- if CLIENT and not game.SinglePlayer() then
	-- RunConsoleCommand("M9kDisablePenetration", tostring(new))
	-- print("Penetration and Ricochets have been synchronized with server.")
	-- end
-- end)

-- net.Receive("RecoilSynch", 
-- function(new)
	-- if CLIENT and not game.SinglePlayer() then
	-- RunConsoleCommand("M9KDynamicRecoil", tostring(new))
	-- print("Dynamic Recoil been synchronized with server.")
	-- end
-- end)

-- net.Receive("SlotSynch", 
-- function(new)
	-- if CLIENT and not game.SinglePlayer() then
	-- RunConsoleCommand("M9KUniqueSlots", tostring(new))
	-- print("Unique Slots have been synchronized with server. A map change may be required.")
	-- end
-- end)

-- net.Receive("HolsterSynch", 
-- function(new)
	-- if CLIENT and not game.SinglePlayer() then
	-- RunConsoleCommand("M9KDisableHolster", tostring(new))
	-- print("Holster Disabling have been synchronized with server. A map change may be required.")
	-- end
-- end)

-- net.Receive("AmmoSynch", 
-- function(new)
	-- if CLIENT and not game.SinglePlayer() then
	-- RunConsoleCommand("M9KAmmoDetonation", tostring(new))
	-- print("Ammo crate detonation has been synchronized with server.")
	-- end
-- end) ]]