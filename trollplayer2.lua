-- Troll Player 2 - Teleport Others To You
-- Modern GUI, bottom left, similar to trollplayer

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrollPlayer2GUI"
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 340, 0, 320)
frame.Position = UDim2.new(0, 10, 1, -330)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 65)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
})
gradient.Rotation = 45
gradient.Parent = frame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
title.BorderSizePixel = 0
title.Text = "🧲 Troll Player 2 - Teleport To You"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 80))
})
titleGradient.Rotation = 45
titleGradient.Parent = title

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -35, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Player list label
local playerListLabel = Instance.new("TextLabel")
playerListLabel.Name = "PlayerListLabel"
playerListLabel.Size = UDim2.new(1, -20, 0, 30)
playerListLabel.Position = UDim2.new(0, 10, 0, 45)
playerListLabel.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
playerListLabel.BorderSizePixel = 0
playerListLabel.Text = "👥 Players in Server:"
playerListLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
playerListLabel.TextScaled = true
playerListLabel.Font = Enum.Font.SourceSansBold
playerListLabel.Parent = frame

local labelCorner = Instance.new("UICorner")
labelCorner.CornerRadius = UDim.new(0, 8)
labelCorner.Parent = playerListLabel

-- Player list frame (scrollable)
local playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Name = "PlayerListFrame"
playerListFrame.Size = UDim2.new(1, -20, 0, 120)
playerListFrame.Position = UDim2.new(0, 10, 0, 80)
playerListFrame.BackgroundColor3 = Color3.fromRGB(90, 90, 110)
playerListFrame.BorderSizePixel = 0
playerListFrame.ScrollBarThickness = 8
playerListFrame.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 140)
playerListFrame.Parent = frame

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 8)
listCorner.Parent = playerListFrame

-- Selected player display
local selectedPlayerLabel = Instance.new("TextLabel")
selectedPlayerLabel.Name = "SelectedPlayerLabel"
selectedPlayerLabel.Size = UDim2.new(1, -20, 0, 30)
selectedPlayerLabel.Position = UDim2.new(0, 10, 0, 210)
selectedPlayerLabel.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
selectedPlayerLabel.BorderSizePixel = 0
selectedPlayerLabel.Text = "🎯 Selected: None"
selectedPlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
selectedPlayerLabel.TextScaled = true
selectedPlayerLabel.Font = Enum.Font.SourceSans
selectedPlayerLabel.Parent = frame

local selectedCorner = Instance.new("UICorner")
selectedCorner.CornerRadius = UDim.new(0, 8)
selectedCorner.Parent = selectedPlayerLabel

-- Teleport button
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(0.98, 0, 0, 40)
teleportButton.Position = UDim2.new(0.01, 0, 0, 255)
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 184, 148)
teleportButton.BorderSizePixel = 0
teleportButton.Text = "🧲 Teleport Player To Me"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextScaled = true
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.Parent = frame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 10)
teleportCorner.Parent = teleportButton

-- Player selection logic
local selectedPlayer = nil

local function createPlayerButton(player, index)
    local button = Instance.new("TextButton")
    button.Name = "Player_" .. player.Name
    button.Size = UDim2.new(1, -10, 0, 28)
    button.Position = UDim2.new(0, 5, 0, (index - 1) * 32)
    button.BackgroundColor3 = Color3.fromRGB(110, 110, 130)
    button.BorderSizePixel = 0
    button.Text = "👤 " .. player.Name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSans
    button.Parent = playerListFrame
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(130, 130, 150)}):Play()
    end)
    button.MouseLeave:Connect(function()
        if selectedPlayer ~= player then
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(110, 110, 130)}):Play()
        end
    end)
    button.MouseButton1Click:Connect(function()
        -- Reset all buttons
        for _, child in pairs(playerListFrame:GetChildren()) do
            if child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(110, 110, 130)}):Play()
            end
        end
        -- Highlight selected button
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 150, 200)}):Play()
        selectedPlayer = player
        selectedPlayerLabel.Text = "🎯 Selected: " .. player.Name
        selectedPlayerLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    end)
    return button
end

local function updatePlayerList()
    for _, child in pairs(playerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    local playerIndex = 1
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createPlayerButton(player, playerIndex)
            playerIndex = playerIndex + 1
        end
    end
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, playerIndex * 32)
end

updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

teleportButton.MouseButton1Click:Connect(function()
    if not selectedPlayer then
        selectedPlayerLabel.Text = "🎯 Selected: None (Select a player!)"
        selectedPlayerLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    if not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        selectedPlayerLabel.Text = "❌ Player not available!"
        selectedPlayerLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    selectedPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
    selectedPlayerLabel.Text = "✅ Teleported: " .. selectedPlayer.Name
    selectedPlayerLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
end)

-- Notification
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "🧲 Troll Player 2",
        Text = "Select a player to teleport them to you!",
        Duration = 6,
    })
end) 