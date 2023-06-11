--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
player_manager.AddValidModel("Bear", "models/sterling/brown_bear.mdl")
list.Set("PlayerOptionsModel", "Bear", "models/sterling/brown_bear.mdl")

player_manager.AddValidModel("Bear_Big", "models/sterling/brown_bear.mdl")
list.Set("PlayerOptionsModel", "Bear_Big", "models/sterling/brown_bear.mdl")

local Foz = Foz or {}

local ply = FindMetaTable("Entity")

ply.NewModel = ply.NewModel or ply.SetModel

--[[---------------------------------------------------------
	Name: Main
-----------------------------------------------------------]]
function ply:SetModel(model)
  ply.NewModel(self, model)

  if self:IsPlayer() then
    hook.Run("Foz:ModelChanged", self, model)
  end
end

function Foz.ModelChanged(ply, model)
  local name = ply:GetInfo("cl_playermodel")

  if name == "Bear" then
    ply:SetModelScale(1)
    ply:ResetHull()

    ply:SetViewOffset(Vector(0, 0, 44))
    ply:SetViewOffsetDucked(Vector(0, 0, 28))
  elseif name == "Bear_Big" then
    local scale = 1.2
    ply:SetModelScale(1 * scale)
    ply:ResetHull()

    ply:SetViewOffset(Vector(0, 0, 54))
    ply:SetViewOffsetDucked(Vector(0, 0, 28))
  else
    ply:SetModelScale(1)
    ply:ResetHull()
    ply:SetViewOffset(Vector(0, 0, 64))
    ply:SetViewOffsetDucked(Vector(0, 0, 28))
  end
end

hook.Add("Foz:ModelChanged", "Foz.ModelChanged", Foz.ModelChanged)
