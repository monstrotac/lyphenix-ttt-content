-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

util.AddNetworkString("RayHUDTTT:UpdateConnectonStatus")

timer.Create("RayHUDTTT:CrashScreenUpdater", 2, 0, function()
	net.Start("RayHUDTTT:UpdateConnectonStatus")
	net.Broadcast()
end)