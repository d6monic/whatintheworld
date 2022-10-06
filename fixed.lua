-- // Dependencies
_G.PRED = 0.025
local Aiming = loadstring(game:HttpGet("https://gist.githubusercontent.com/s17tzz/b3360969505c1f0f18950c1e1feb474f/raw/3e9e27e5856ef41efe14139ee5ef4d0abd36bda1/xp2jgvJNRxNKkM.lua"))()
Aiming.TeamCheck(false)
Aiming.ShowFOV = true
Aiming.FOV = 25
-- // Services
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- // Vars
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CurrentCamera = Workspace.CurrentCamera

--// Spoof the Current Anticheat
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
    Prediction = 0.025,
    AimLockKeybind = Enum.KeyCode.E
}
getgenv().DaHoodSettings = DaHoodSettings

-- // Overwrite to account downed
function Aiming.Check()
    -- // Check A
    if not (Aiming.Enabled == true and Aiming.Selected ~= LocalPlayer and Aiming.SelectedPart ~= nil) then
        return false
    end

    -- // Check if downed
    local Character = Aiming.Character(Aiming.Selected)
    local KOd = Character:WaitForChild"K.O".Value
    local Grabbed = Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil

    -- // Check B
    if (KOd or Grabbed) then
        return false
    end

    -- //
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

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

mouse.KeyDown:Connect(function(key)
    if key == "v" then
        if Aiming.Enabled == false then
        Aiming.Enabled = true
        else
        Aiming.Enabled = false
        end
    end
end)


RunService.RenderStepped:Connect(function()

    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    local Value = tostring(ping)
    local pingValue = Value:split(" ")
    local PingNumber = pingValue[1]
    
    DaHoodSettings.Prediction = PingNumber / 1000 + _G.PRED
    
                    if Aiming.Character.Humanoid.Jump == true and AimlockTarget.Character.Humanoid.FloorMaterial == Enum.Material.Air then
                    Aiming.TargetPart = "RightFoot"
                else
                    Aiming.Character:WaitForChild("Humanoid").StateChanged:Connect(function(new)
                    
                    if new == Enum.HumanoidStateType.Freefall then
                    Aiming.TargetPart = "RightFoot"
                    else
                    
                    Aiming.TargetPart = Aiming.SelectedPart
                    
                    end
                    
                    end)
                    
                end

end)