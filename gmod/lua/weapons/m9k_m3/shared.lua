-- Variables that are used on both client and server
SWEP.Gun = ("m9k_m3") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "M9K Shotguns"
SWEP.Author				= "iron angles and models hexed and converted to gmod my Mr Fokkusu"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.Icon = "turtleicons/m31.vmt"
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Benelli M3"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 3			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "shotgun"	-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.Primary.Delay = 0.9

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= true
SWEP.ViewModel				= "models/weapons/v_benelli_m3_s90.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_benelli_m3.mdl"	-- Weapon world model
SWEP.Base 				= "weapon_tttbase"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.AutoSpawnable      = true

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_SHOTGUN

SWEP.Primary.Sound			= Sound("BenelliM3.Single")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 70		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize		= 8			-- Size of a clip
SWEP.Primary.DefaultClip		= 8	-- Default number of bullets in a clip
SWEP.Primary.ClipMax               = 24
SWEP.Primary.KickUp				= 0.8			-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.5		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.3	-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "buckshot"
SWEP.AmmoEnt = "item_box_buckshot_ttt"	-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 60		-- How much you 'zoom' in. Less is more! 

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.ShellTime			= .45

SWEP.Primary.NumShots	= 8		-- How many bullets to shoot per trigger pull, AKA pellets
SWEP.Primary.Damage		= 11	-- Base damage per bullet
SWEP.Primary.Spread		= .0326	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .0326	-- Ironsight accuracy, should be the same for shotguns
-- Because irons don't magically give you less pellet spread!

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(2.279, -1.007, 1.302)
SWEP.IronSightsAng = Vector(0.47, -0.024, 0)
SWEP.SightsPos = Vector(2.279, -1.007, 1.302)
SWEP.SightsAng = Vector(0.47, -0.024, 0)
SWEP.RunSightsPos = Vector(-7.639, -7.796, 0.865)
SWEP.RunSightsAng = Vector(-17.362, -69.724, 0)

SWEP.reloadtimer = 0

function SWEP:SetupDataTables()
   self:DTVar("Bool", 0, "reloading")

   return self.BaseClass.SetupDataTables(self)
end

function SWEP:Reload()
   self:SetIronsights( false )
   
   --if self.Weapon:GetNetworkedBool( "reloading", false ) then return end
   if self.dt.reloading then return end

   if not IsFirstTimePredicted() then return end
   
   if self.Weapon:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 then
      
      if self:StartReload() then
         return
      end
   end

end

function SWEP:StartReload()
   --if self.Weapon:GetNWBool( "reloading", false ) then
   if self.dt.reloading then
      return false
   end

   if not IsFirstTimePredicted() then return false end

   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   
   local ply = self.Owner
   
   if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then 
      return false
   end

   local wep = self.Weapon
   
   if wep:Clip1() >= self.Primary.ClipSize then 
      return false 
   end

   wep:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

   self.reloadtimer =  CurTime() + wep:SequenceDuration()

   --wep:SetNWBool("reloading", true)
   self.dt.reloading = true

   return true
end

function SWEP:PerformReload()
   local ply = self.Owner
   
   -- prevent normal shooting in between reloads
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then return end

   local wep = self.Weapon

   if wep:Clip1() >= self.Primary.ClipSize then return end

   self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
   self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )

   wep:SendWeaponAnim(ACT_VM_RELOAD)

   self.reloadtimer = CurTime() + wep:SequenceDuration()
end

function SWEP:FinishReload()
   self.dt.reloading = false
   self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
   
   self.reloadtimer = CurTime() + self.Weapon:SequenceDuration()
end

function SWEP:CanPrimaryAttack()
   if self.Weapon:Clip1() <= 0 then
      self:EmitSound( "Weapon_Shotgun.Empty" )
      self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
      return false
   end
   return true
end

function SWEP:Think()
   if self.dt.reloading and IsFirstTimePredicted() then
      if self.Owner:KeyDown(IN_ATTACK) then
         self:FinishReload()
         return
      end
      
      if self.reloadtimer <= CurTime() then

         if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
            self:FinishReload()
         elseif self.Weapon:Clip1() < self.Primary.ClipSize then
            self:PerformReload()
         else
            self:FinishReload()
         end
         return            
      end
   end
end

function SWEP:Deploy()
   self.dt.reloading = false
   self.reloadtimer = 0
   return self.BaseClass.Deploy(self)
end

-- The shotgun's headshot damage multiplier is based on distance. The closer it
-- is, the more damage it does. This reinforces the shotgun's role as short
-- range weapon by reducing effectiveness at mid-range, where one could score
-- lucky headshots relatively easily due to the spread.
function SWEP:GetHeadshotMultiplier(victim, dmginfo)
   local att = dmginfo:GetAttacker()
   if not IsValid(att) then return 3 end

   local dist = victim:GetPos():Distance(att:GetPos())
   local d = math.max(0, dist - 140)
   
   -- decay from 3.1 to 1 slowly as distance increases
   return 1 + math.max(0, (2.1 - 0.002 * (d ^ 1.25)))
end
