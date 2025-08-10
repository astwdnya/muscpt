-- Speed Hack Script
-- Controls: 
-- Q = Normal Speed
-- E = Fast Speed  
-- R = Super Fast Speed
-- T = Ultra Fast Speed

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Speed Hack",
    Text = "Q=Normal, E=Fast, R=Super Fast, T=Ultra Fast",
    Duration = 6,
})

-- Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Speed values
local speeds = {
    normal = 16,
    fast = 50,
    super = 100,
    ultra = 200
}

-- Function to set speed
function SetSpeed(speed)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Speed Changed",
            Text = "Speed: " .. speed,
            Duration = 2,
        })
    end
end

-- Input handler
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Q then
        SetSpeed(speeds.normal)
    elseif input.KeyCode == Enum.KeyCode.E then
        SetSpeed(speeds.fast)
    elseif input.KeyCode == Enum.KeyCode.R then
        SetSpeed(speeds.super)
    elseif input.KeyCode == Enum.KeyCode.T then
        SetSpeed(speeds.ultra)
    end
end) 