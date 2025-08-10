-- Jerk Off Script (Both Hands)
-- Makes you perform a jerking animation with both hands in Roblox

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
local backpack = player:FindFirstChildWhichIsA("Backpack")

if not humanoid or not backpack then 
    warn("Humanoid or Backpack not found!")
    return 
end

local tool = Instance.new("Tool")
tool.Name = "Jerk Off (Both Hands)"
tool.ToolTip = "in the stripped club. straight up 'jorking it' with both hands."
tool.RequiresHandle = false
tool.Parent = backpack

local jorkin = false
local trackR = nil
local trackL = nil

local function stopTomfoolery()
    jorkin = false
    if trackR then trackR:Stop() trackR = nil end
    if trackL then trackL:Stop() trackL = nil end
end

local function r15(player)
    return player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.RigType == Enum.HumanoidRigType.R15
end

tool.Equipped:Connect(function() 
    jorkin = true 
end)
tool.Unequipped:Connect(stopTomfoolery)
humanoid.Died:Connect(stopTomfoolery)

while task.wait() do
    if jorkin then
        local isR15 = r15(player)
        if not trackR then
            local animR = Instance.new("Animation")
            animR.AnimationId = not isR15 and "rbxassetid://72042024" or "rbxassetid://698251653"
            trackR = humanoid:LoadAnimation(animR)
        end
        if not trackL then
            local animL = Instance.new("Animation")
            animL.AnimationId = not isR15 and "rbxassetid://72042024" or "rbxassetid://698251653"
            trackL = humanoid:LoadAnimation(animL)
        end

        trackR:Play()
        trackL:Play()
        trackR:AdjustSpeed(isR15 and 0.7 or 0.65)
        trackL:AdjustSpeed(isR15 and 0.7 or 0.65)
        trackR.TimePosition = 0.6
        trackL.TimePosition = 0.6
        task.wait(0.1)
        
        while (trackR and trackR.TimePosition < (not isR15 and 0.65 or 0.7)) or (trackL and trackL.TimePosition < (not isR15 and 0.65 or 0.7)) do 
            task.wait(0.1) 
        end
        
        if trackR then trackR:Stop() trackR = nil end
        if trackL then trackL:Stop() trackL = nil end
    end
end 