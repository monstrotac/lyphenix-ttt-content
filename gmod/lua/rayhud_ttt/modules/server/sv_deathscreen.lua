-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

util.AddNetworkString("RayDeathPanel_Net")

hook.Add("EntityTakeDamage", "RayHUDTTT:Deathpanel_DMG", function(ply, dmg)
	ply.DamageCount = ply.DamageCount or {NULL, 0, 0}
	if dmg:GetAttacker():IsPlayer() then
		if ply.DamageCount[1] == dmg:GetAttacker() then
			ply.DamageCount[2] = ply.DamageCount[2] + 1
			ply.DamageCount[3] = ply.DamageCount[3] + dmg:GetDamage()
		else
			ply.DamageCount[1] = dmg:GetAttacker()
			ply.DamageCount[2] = 1
			ply.DamageCount[3] = dmg:GetDamage()
		end
	else
		ply.DamageCount[1] = NULL
		ply.DamageCount[2] = 1
		ply.DamageCount[3] = dmg:GetDamage()
	end
end) 

hook.Add("DoPlayerDeath", "RayHUDTTT:Deathpanel_Death", function(victim, attacker, dmginfo)
	if GetRoundState() == ROUND_ACTIVE then
	
		if victim == attacker then
			victim.DamageCount = nil
		end

		net.Start("RayDeathPanel_Net")
			net.WriteEntity(attacker)
			if attacker:IsPlayer() then
				net.WriteInt(attacker:GetRole(), 8)
				net.WriteString(attacker:GetRoleStringRaw())
				if util.WeaponFromDamage(dmginfo) then
					net.WriteEntity(util.WeaponFromDamage(dmginfo))
				else
					net.WriteEntity(dmginfo:GetInflictor())
				end
			else
				net.WriteInt(-1, 8)
				net.WriteEntity(nil)
			end
			if victim.DamageCount then
				net.WriteInt(victim.DamageCount[2], 8)
				net.WriteInt(math.Round(victim.DamageCount[3]), 16)
			else
				net.WriteInt(-1, 8)
				net.WriteInt(-1, 16)
			end
		net.Send(victim)
		victim.DamageCount = nil
	end
end)