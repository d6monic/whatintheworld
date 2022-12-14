local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/KaiCuh/locks/main/d870997929af2a1483180013f688c771"))()
Aiming.TeamCheck(false)

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CurrentCamera = Workspace.CurrentCamera

--// Spoof the Current heat
local function ACThing()
    for I, V in pairs(getgc(true)) do
        if typeof(V) == "function" then
            local sc = getfenv(V).script
            if sc and sc.Name == "Camera" then
                for I2, V2 in pairs(getupvalues(V)) do
                    if type(V2) == "table" and rawget(V2, "DoThings") then
                        rawset(V2, "Break", true)
                        rawset(
                            V2,
                            "DoThings",
                            function()
                            end
                        )
                    end
                end
            end
        end
    end
end
ACThing()
game.Players.LocalPlayer.CharacterAdded:connect(ACThing)
        
local DaHoodSettings = {
    SilentAim = true,
    AimLock = false,
    Prediction = 0.14,
    AimLockKeybind = Enum.KeyCode.T,
    Resolver = true,
}
getgenv().DaHoodSettings = DaHoodSettings

function Aiming.Check()
    if not (Aiming.Enabled == true and Aiming.Selected ~= LocalPlayer and Aiming.SelectedPart ~= nil) then
        return false
    end

    local Character = Aiming.Character(Aiming.Selected)
    local KOd = Character:FindFirstChild"K.O".Value
    local Grabbed = Character:FindFirstChild("WELD_GRAB") ~= nil

    if (KOd or Grabbed) then
        return false
    end

    return true
end

local oldIndex = nil 
oldIndex = hookmetamethod(game, "__index", function(self, Index)
    if self == Mouse and not checkcaller() then 
        local SelectedPart = Aiming.SelectedPart
        if DaHoodSettings.SilentAim and Index == "Hit" or Index == "Target" then
            
            if SelectedPart then
                local Hit = SelectedPart.CFrame + (SelectedPart.Velocity * DaHoodSettings.Prediction)
                if Index == "Hit" then
                    return Hit
                elseif Index == "Target" then
                    return SelectedPart
                end
            end
        end
    end
    return oldIndex(self, Index)
end)

RunService:BindToRenderStep("AimLock", 0, function()
    if (DaHoodSettings.AimLock and Aiming.Check() and UserInputService:IsKeyDown(DaHoodSettings.AimLockKeybind)) then
        local SelectedPart = Aiming.SelectedPart

        local Hit = SelectedPart.CFrame + (SelectedPart.Velocity * DaHoodSettings.Prediction)

        CurrentCamera.CFrame = CFrame.lookAt(CurrentCamera.CFrame.Position, Hit.Position)
    end
end)

task.spawn(function()
    while task.wait() do
        if DaHoodSettings.Resolver and Aiming.Selected ~= nil and (Aiming.Selected.Character)  then
            local oldVel = game.Players[Aiming.Selected.Name].Character.HumanoidRootPart.Velocity
            game.Players[Aiming.Selected.Name].Character.HumanoidRootPart.Velocity = Vector3.new(oldVel.X, -0, oldVel.Z)
        end 
    end
end)

game.Players.LocalPlayer.Chatted:Connect(function(ReV)
	if ReV == "/e resv2" or "/e rev2" or "/e v2" then
	local RunService = game:GetService("RunService")
		RunService.Heartbeat:Connect(function()
			pcall(function()
				for i,v in pairs(game.Players:GetChildren()) do
					if v.Name ~= game.Players.LocalPlayer.Name then
						local hrp = v.Character.HumanoidRootPart
						hrp.Velocity = Vector3.new(DaHoodSettings.Prediction, 0, DaHoodSettings.Prediction)    
						hrp.AssemblyLinearVelocity = Vector3.new(DaHoodSettings.Prediction, 0, DaHoodSettings.Prediction)   
					end
				end
			end)
		end)
	end
end)
