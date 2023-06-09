-- RayHUD TTT Owner: 76561198121455426
-- RayHUD TTT Version: 3.1.2.1

local EnableIndicator = RayUI.Configuration.GetConfig( "DrowningIndicator" )

local SmoothDrown = 0
local drowning

local function GetDrowning()
	if LocalPlayer():WaterLevel() == 3 then
		if not drowning then
			drowning = CurTime() + 8
		end
	else
		drowning = nil
	end
end

local function GetAirlevel()
	if drowning then
		return math.Clamp((drowning - CurTime()) / 8, 0, 8)
	else
		return nil
	end
end			

hook.Add("HUDPaint", "RayHUDTTT:DrowningInit", function()
	GetDrowning()
	local air_level = GetAirlevel()

	local width = 370 * RayUI.Scale
	local height = 90 * RayUI.Scale
	local x = 10 * RayUI.Scale
	local y = select(2, RayHUDTTT:GetHUDPos()) - height - x

	if !EnableIndicator then return end

	if drowning and !LocalPlayer():IsSpec() then
		SmoothDrown = Lerp(5 * FrameTime(), SmoothDrown, air_level)

		RayUI:DrawBlur2(x, y, width, height)
		RayUI:DrawMaterialBox(RayUI.GetPhrase("rayhudttt", "air_level"), x, y, width, height)
		RayUI:CreateBar(x + 44 * RayUI.Scale, y + 60 * RayUI.Scale, 300 * RayUI.Scale, 11, RayUI.Colors.LightArmor, RayUI.Colors.Armor, SmoothDrown, "", RayUI.Icons.Bubble)
	end
end)