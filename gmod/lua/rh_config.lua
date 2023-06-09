if SERVER then return end     // don't touch this
RayHUDTTT.CustomRoles = {}    // don't touch this
RayHUDTTT.WinType = {}        // don't touch this







// Custom Roles Switch, available options:
   -- "TownOfTerror" - if you have Town of Terror on your server (https://steamcommunity.com/sharedfiles/filedetails/?id=1092556189)
   -- "CustomRoles" - if you have Custom Roles for TTT [NEWEST VERSION!] on your server (https://steamcommunity.com/sharedfiles/filedetails/?id=2421039084) -- THIS OPTION IS STILL BETA!
   -- false - if you have normal TTT server

RayHUDTTT.UseCustomRoles = false










// don't touch anything below unless you know what you're doing
// don't touch anything below unless you know what you're doing
// don't touch anything below unless you know what you're doing
// don't touch anything below unless you know what you're doing

if RayHUDTTT.UseCustomRoles == "TownOfTerror" then
   RayHUDTTT.CustomRoles = {
      [ROLE_SURVIVALIST] = Color(255, 127, 80, 255),
      [ROLE_JESTER] = Color(255, 105, 180, 200),
      [ROLE_RESURRECTOR] = Color(135, 206, 250, 200),
      [ROLE_SERIALKILLER] = Color(85, 26, 139, 255),
      [ROLE_INFECTED] = Color(29, 33, 13, 255),
      [ROLE_DEPUTY] = 	Color( 8, 109, 236, 255),
      [ROLE_ENGINEER] = Color( 120, 143, 74, 255),
      [ROLE_TRECRUIT] = Color( 170, 66, 78, 255),
      [ROLE_WITCHDR] = Color( 124, 57, 24, 255 )
   }
   
   RayHUDTTT.WinType = {
      [WIN_TRAITOR] = {txt = "hilite_win_traitors", c = ROLE_TRAITOR},
      [WIN_INNOCENT] = {txt = "hilite_win_innocent", c = ROLE_INNOCENT},
      [WIN_JESTER] = {txt = "hilite_win_Jester", c = ROLE_JESTER},
      [WIN_SERIALKILLER] = {txt = "hilite_win_serialkiller", c = ROLE_SERIALKILLER},
      [WIN_INFECTED] = {txt = "hilite_win_infected", c = ROLE_INFECTED},
      [WIN_WITCHDR] = {txt = "hilite_win_witchdr", c = ROLE_WITCHDR},
      [WIN_BEES] = {txt = "hilite_win_bees", c = Color(255, 204, 0)},
   }

elseif RayHUDTTT.UseCustomRoles == "CustomRoles" then

   RayHUDTTT.CustomRoles = ROLE_COLORS

   RayHUDTTT.WinType = {
      [WIN_INNOCENT] = { txt = "hilite_win_innocent", c = ROLE_INNOCENT },
      [WIN_TRAITOR] = { txt = "hilite_win_traitors", c = ROLE_COLORS[ROLE_TRAITOR] },
      [WIN_JESTER] = { txt = "hilite_win_jester", c = ROLE_JESTER },
      [WIN_CLOWN] = { txt = "hilite_win_clown", c = ROLE_JESTER },
      [WIN_KILLER] = { txt = "hilite_win_killer", c = ROLE_KILLER },
      [WIN_ZOMBIE] = { txt = "hilite_win_zombies", c = ROLE_ZOMBIE },
      [WIN_MONSTER] = { txt = "hilite_win_monster", c = ROLE_ZOMBIE }
   }

else
   return
end