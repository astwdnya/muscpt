-- Troll Player Script
-- Follows a player by teleporting behind them

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Variables
local targetPlayer = nil
local isFollowing = false
local followDistance = 3 -- Distance behind the player
local teleportInterval = 0.01 -- Teleport interval in seconds
local autoFollowAll = false -- Auto follow all enemies
local checkTeam = true -- Check team before following

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrollPlayerGUI"
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 380, 0, 380)
frame.Position = UDim2.new(0, 10, 1, -390)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Add rounded corners effect
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Add gradient background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 65)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
})
gradient.Rotation = 45
gradient.Parent = frame

-- Create title first
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
title.BorderSizePixel = 0
title.Text = "🎯 Troll Player - Select Target"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

-- Add corner to title
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Add gradient to title
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 80))
})
titleGradient.Rotation = 45
titleGradient.Parent = title

-- Now add drag functionality after title is created
local dragging
local dragInput
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Add cursor change on hover
title.MouseEnter:Connect(function()
    title.Cursor = "SizeAll"
end)

title.MouseLeave:Connect(function()
    title.Cursor = "Arrow"
end)

-- Close button (X)
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

-- Add corner to close button
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Close button hover effect
closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
end)

closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
end)

-- Close button click
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Settings frame
local settingsFrame = Instance.new("Frame")
settingsFrame.Name = "SettingsFrame"
settingsFrame.Size = UDim2.new(1, -20, 0, 80)
settingsFrame.Position = UDim2.new(0, 10, 0, 45)
settingsFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
settingsFrame.BorderSizePixel = 0
settingsFrame.Parent = frame

-- Add corner to settings frame
local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 8)
settingsCorner.Parent = settingsFrame

-- Teleport interval input
local intervalLabel = Instance.new("TextLabel")
intervalLabel.Name = "IntervalLabel"
intervalLabel.Size = UDim2.new(0.4, 0, 0, 25)
intervalLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
intervalLabel.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
intervalLabel.BorderSizePixel = 0
intervalLabel.Text = "⏱️ Interval (sec):"
intervalLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
intervalLabel.TextScaled = true
intervalLabel.Font = Enum.Font.SourceSans
intervalLabel.Parent = settingsFrame

-- Add corner to interval label
local intervalLabelCorner = Instance.new("UICorner")
intervalLabelCorner.CornerRadius = UDim.new(0, 4)
intervalLabelCorner.Parent = intervalLabel

local intervalInput = Instance.new("TextBox")
intervalInput.Name = "IntervalInput"
intervalInput.Size = UDim2.new(0.25, 0, 0, 25)
intervalInput.Position = UDim2.new(0.45, 0, 0.1, 0)
intervalInput.BackgroundColor3 = Color3.fromRGB(90, 90, 110)
intervalInput.BorderSizePixel = 0
intervalInput.Text = tostring(teleportInterval)
intervalInput.TextColor3 = Color3.fromRGB(255, 255, 255)
intervalInput.TextScaled = true
intervalInput.Font = Enum.Font.SourceSans
intervalInput.Parent = settingsFrame

-- Add corner to interval input
local intervalInputCorner = Instance.new("UICorner")
intervalInputCorner.CornerRadius = UDim.new(0, 4)
intervalInputCorner.Parent = intervalInput

local saveButton = Instance.new("TextButton")
saveButton.Name = "SaveButton"
saveButton.Size = UDim2.new(0.2, 0, 0, 25)
saveButton.Position = UDim2.new(0.72, 0, 0.1, 0)
saveButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
saveButton.BorderSizePixel = 0
saveButton.Text = "💾 Save"
saveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveButton.TextScaled = true
saveButton.Font = Enum.Font.SourceSansBold
saveButton.Parent = settingsFrame

-- Add corner to save button
local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 4)
saveCorner.Parent = saveButton

-- Team check toggle
local teamCheckLabel = Instance.new("TextLabel")
teamCheckLabel.Name = "TeamCheckLabel"
teamCheckLabel.Size = UDim2.new(0.4, 0, 0, 25)
teamCheckLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
teamCheckLabel.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
teamCheckLabel.BorderSizePixel = 0
teamCheckLabel.Text = "🛡️ Check Team:"
teamCheckLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
teamCheckLabel.TextScaled = true
teamCheckLabel.Font = Enum.Font.SourceSans
teamCheckLabel.Parent = settingsFrame

-- Add corner to team check label
local teamCheckLabelCorner = Instance.new("UICorner")
teamCheckLabelCorner.CornerRadius = UDim.new(0, 4)
teamCheckLabelCorner.Parent = teamCheckLabel

local teamCheckToggle = Instance.new("TextButton")
teamCheckToggle.Name = "TeamCheckToggle"
teamCheckToggle.Size = UDim2.new(0.25, 0, 0, 25)
teamCheckToggle.Position = UDim2.new(0.45, 0, 0.6, 0)
teamCheckToggle.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
teamCheckToggle.BorderSizePixel = 0
teamCheckToggle.Text = "✅ ON"
teamCheckToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
teamCheckToggle.TextScaled = true
teamCheckToggle.Font = Enum.Font.SourceSansBold
teamCheckToggle.Parent = settingsFrame

-- Add corner to team check toggle
local teamCheckCorner = Instance.new("UICorner")
teamCheckCorner.CornerRadius = UDim.new(0, 4)
teamCheckCorner.Parent = teamCheckToggle

-- Player list label
local playerListLabel = Instance.new("TextLabel")
playerListLabel.Name = "PlayerListLabel"
playerListLabel.Size = UDim2.new(1, -20, 0, 30)
playerListLabel.Position = UDim2.new(0, 10, 0, 135)
playerListLabel.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
playerListLabel.BorderSizePixel = 0
playerListLabel.Text = "👥 Players in Server:"
playerListLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
playerListLabel.TextScaled = true
playerListLabel.Font = Enum.Font.SourceSansBold
playerListLabel.Parent = frame

-- Add corner to player list label
local labelCorner = Instance.new("UICorner")
labelCorner.CornerRadius = UDim.new(0, 8)
labelCorner.Parent = playerListLabel

-- Player list frame (scrollable)
local playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Name = "PlayerListFrame"
playerListFrame.Size = UDim2.new(1, -20, 0, 100) -- Made smaller to fit new controls
playerListFrame.Position = UDim2.new(0, 10, 0, 170)
playerListFrame.BackgroundColor3 = Color3.fromRGB(90, 90, 110)
playerListFrame.BorderSizePixel = 0
playerListFrame.ScrollBarThickness = 8
playerListFrame.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 140)
playerListFrame.Parent = frame

-- Add corner to player list frame
local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 8)
listCorner.Parent = playerListFrame

-- Selected player display
local selectedPlayerLabel = Instance.new("TextLabel")
selectedPlayerLabel.Name = "SelectedPlayerLabel"
selectedPlayerLabel.Size = UDim2.new(1, -20, 0, 30)
selectedPlayerLabel.Position = UDim2.new(0, 10, 0, 280)
selectedPlayerLabel.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
selectedPlayerLabel.BorderSizePixel = 0
selectedPlayerLabel.Text = "🎯 Selected: None"
selectedPlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
selectedPlayerLabel.TextScaled = true
selectedPlayerLabel.Font = Enum.Font.SourceSans
selectedPlayerLabel.Parent = frame

-- Add corner to selected player label
local selectedCorner = Instance.new("UICorner")
selectedCorner.CornerRadius = UDim.new(0, 8)
selectedCorner.Parent = selectedPlayerLabel

-- Distance display
local distanceLabel = Instance.new("TextLabel")
distanceLabel.Name = "DistanceLabel"
distanceLabel.Size = UDim2.new(1, -20, 0, 25)
distanceLabel.Position = UDim2.new(0, 10, 0, 315)
distanceLabel.BackgroundColor3 = Color3.fromRGB(110, 110, 130)
distanceLabel.BorderSizePixel = 0
distanceLabel.Text = "📏 Distance: --"
distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
distanceLabel.TextScaled = true
distanceLabel.Font = Enum.Font.SourceSans
distanceLabel.Parent = frame

-- Add corner to distance label
local distanceCorner = Instance.new("UICorner")
distanceCorner.CornerRadius = UDim.new(0, 6)
distanceCorner.Parent = distanceLabel

local followButton = Instance.new("TextButton")
followButton.Name = "FollowButton"
followButton.Size = UDim2.new(0.48, 0, 0, 35)
followButton.Position = UDim2.new(0.02, 0, 0, 345)
followButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
followButton.BorderSizePixel = 0
followButton.Text = "🚀 Follow"
followButton.TextColor3 = Color3.fromRGB(255, 255, 255)
followButton.TextScaled = true
followButton.Font = Enum.Font.SourceSansBold
followButton.Parent = frame

-- Add corner to follow button
local followCorner = Instance.new("UICorner")
followCorner.CornerRadius = UDim.new(0, 10)
followCorner.Parent = followButton

local stopButton = Instance.new("TextButton")
stopButton.Name = "StopButton"
stopButton.Size = UDim2.new(0.48, 0, 0, 35)
stopButton.Position = UDim2.new(0.5, 0, 0, 345)
stopButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
stopButton.BorderSizePixel = 0
stopButton.Text = "⏹️ Stop"
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopButton.TextScaled = true
stopButton.Font = Enum.Font.SourceSansBold
stopButton.Parent = frame

-- Add corner to stop button
local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 10)
stopCorner.Parent = stopButton

-- Auto follow all button
local autoFollowButton = Instance.new("TextButton")
autoFollowButton.Name = "AutoFollowButton"
autoFollowButton.Size = UDim2.new(0.98, 0, 0, 30)
autoFollowButton.Position = UDim2.new(0.01, 0, 0, 385)
autoFollowButton.BackgroundColor3 = Color3.fromRGB(150, 100, 200)
autoFollowButton.BorderSizePixel = 0
autoFollowButton.Text = "🔄 Auto Follow All Enemies"
autoFollowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoFollowButton.TextScaled = true
autoFollowButton.Font = Enum.Font.SourceSansBold
autoFollowButton.Parent = frame

-- Add corner to auto follow button
local autoFollowCorner = Instance.new("UICorner")
autoFollowCorner.CornerRadius = UDim.new(0, 8)
autoFollowCorner.Parent = autoFollowButton

-- Save button click
saveButton.MouseButton1Click:Connect(function()
    local newInterval = tonumber(intervalInput.Text)
    if newInterval and newInterval > 0 then
        teleportInterval = newInterval
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "✅ Saved",
            Text = "Interval set to: " .. teleportInterval .. " seconds",
            Duration = 2,
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "❌ Error",
            Text = "Please enter a valid number!",
            Duration = 3,
        })
    end
end)

-- Team check toggle click
teamCheckToggle.MouseButton1Click:Connect(function()
    checkTeam = not checkTeam
    if checkTeam then
        teamCheckToggle.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        teamCheckToggle.Text = "✅ ON"
    else
        teamCheckToggle.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        teamCheckToggle.Text = "❌ OFF"
    end
end)

-- Function to check if player is enemy
local function isEnemy(player)
    if not checkTeam then return true end
    
    local localTeam = LocalPlayer.Team
    local playerTeam = player.Team
    
    if not localTeam or not playerTeam then return true end
    return localTeam ~= playerTeam
end

-- Function to get all enemies
local function getAllEnemies()
    local enemies = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isEnemy(player) and player.Character then
            table.insert(enemies, player)
        end
    end
    return enemies
end

-- Function to create player button
local function createPlayerButton(player, index)
    local button = Instance.new("TextButton")
    button.Name = "Player_" .. player.Name
    button.Size = UDim2.new(1, -10, 0, 25)
    button.Position = UDim2.new(0, 5, 0, (index - 1) * 28)
    button.BackgroundColor3 = Color3.fromRGB(110, 110, 130)
    button.BorderSizePixel = 0
    button.Text = "👤 " .. player.Name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSans
    button.Parent = playerListFrame
    
    -- Add corner to button
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(130, 130, 150)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        if targetPlayer ~= player then
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(110, 110, 130)}):Play()
        end
    end)
    
    -- Click to select
    button.MouseButton1Click:Connect(function()
        -- Reset all buttons
        for _, child in pairs(playerListFrame:GetChildren()) do
            if child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(110, 110, 130)}):Play()
            end
        end
        
        -- Highlight selected button
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 150, 200)}):Play()
        
        -- Set target player
        targetPlayer = player
        selectedPlayerLabel.Text = "🎯 Selected: " .. player.Name
        selectedPlayerLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    end)
    
    return button
end

-- Function to update player list
local function updatePlayerList()
    -- Clear existing buttons
    for _, child in pairs(playerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Create buttons for all players
    local playerIndex = 1
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then -- Don't show ourselves
            createPlayerButton(player, playerIndex)
            playerIndex = playerIndex + 1
        end
    end
    
    -- Update scroll frame size
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, playerIndex * 28)
end

-- Function to calculate distance
local function calculateDistance()
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local targetPos = targetPlayer.Character.HumanoidRootPart.Position
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    return math.floor((targetPos - myPos).Magnitude)
end

-- Function to follow player
local function followPlayer()
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local targetRootPart = targetPlayer.Character.HumanoidRootPart
    local myRootPart = LocalPlayer.Character.HumanoidRootPart
    
    -- Calculate position behind the target
    local targetCFrame = targetRootPart.CFrame
    local behindPosition = targetCFrame.Position - (targetCFrame.LookVector * followDistance)
    
    -- Teleport behind the player
    myRootPart.CFrame = CFrame.new(behindPosition, targetCFrame.Position)
    
    -- Update distance display
    local distance = calculateDistance()
    if distance then
        distanceLabel.Text = "📏 Distance: " .. distance .. " studs"
        if distance <= 5 then
            distanceLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- Green for close
        elseif distance <= 15 then
            distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0) -- Yellow for medium
        else
            distanceLabel.TextColor3 = Color3.fromRGB(255, 100, 100) -- Red for far
        end
    end
end

-- Auto follow all enemies function
local function autoFollowAllEnemies()
    local enemies = getAllEnemies()
    if #enemies == 0 then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "❌ No Enemies",
            Text = "No enemies found to follow!",
            Duration = 3,
        })
        return
    end
    
    local currentEnemyIndex = 1
    
    spawn(function()
        while autoFollowAll do
            -- Refresh enemies list
            enemies = getAllEnemies()
            
            if #enemies == 0 then
                wait(1)
            else
                -- Check if current enemy is still valid
                if currentEnemyIndex > #enemies then
                    currentEnemyIndex = 1
                end
                
                local currentEnemy = enemies[currentEnemyIndex]
                if not currentEnemy or not currentEnemy.Character then
                    -- Enemy died or left, move to next
                    table.remove(enemies, currentEnemyIndex)
                    if currentEnemyIndex > #enemies then
                        currentEnemyIndex = 1
                    end
                    
                    if #enemies > 0 then
                        game:GetService("StarterGui"):SetCore("SendNotification",{
                            Title = "🔄 Auto Follow",
                            Text = "Enemy died! Moving to next target...",
                            Duration = 2,
                        })
                    end
                else
                    -- Follow current enemy (separate from normal follow mode)
                    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        wait(0.1)
                    else
                        local targetRootPart = currentEnemy.Character.HumanoidRootPart
                        local myRootPart = LocalPlayer.Character.HumanoidRootPart
                        
                        -- Calculate position behind the target
                        local targetCFrame = targetRootPart.CFrame
                        local behindPosition = targetCFrame.Position - (targetCFrame.LookVector * followDistance)
                        
                        -- Teleport behind the player
                        myRootPart.CFrame = CFrame.new(behindPosition, targetCFrame.Position)
                        
                        -- Update distance display
                        local distance = math.floor((targetRootPart.Position - myRootPart.Position).Magnitude)
                        distanceLabel.Text = "📏 Distance: " .. distance .. " studs (Auto)"
                        if distance <= 5 then
                            distanceLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- Green for close
                        elseif distance <= 15 then
                            distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0) -- Yellow for medium
                        else
                            distanceLabel.TextColor3 = Color3.fromRGB(255, 100, 100) -- Red for far
                        end
                        
                        -- Update selected player display
                        selectedPlayerLabel.Text = "🎯 Auto Following: " .. currentEnemy.Name
                        selectedPlayerLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
                    end
                    
                    -- Move to next enemy after some time
                    currentEnemyIndex = currentEnemyIndex + 1
                    if currentEnemyIndex > #enemies then
                        currentEnemyIndex = 1
                    end
                end
            end
            
            wait(teleportInterval)
        end
    end)
end

-- Follow button click
followButton.MouseButton1Click:Connect(function()
    if not targetPlayer then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "❌ Error",
            Text = "Please select a player first!",
            Duration = 3,
        })
        return
    end
    
    if not targetPlayer.Character then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "❌ Error",
            Text = "Selected player is not in game!",
            Duration = 3,
        })
        return
    end
    
    isFollowing = true
    TweenService:Create(followButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
    followButton.Text = "🔄 Following..."
    
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "🎯 Troll Player",
        Text = "Now following: " .. targetPlayer.Name,
        Duration = 3,
    })
    
    -- Start following loop
    spawn(function()
        while isFollowing and targetPlayer and targetPlayer.Character do
            followPlayer()
            wait(teleportInterval)
        end
    end)
end)

-- Stop button click
stopButton.MouseButton1Click:Connect(function()
    isFollowing = false
    autoFollowAll = false
    targetPlayer = nil
    TweenService:Create(followButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 180, 50)}):Play()
    followButton.Text = "🚀 Follow"
    TweenService:Create(autoFollowButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(150, 100, 200)}):Play()
    autoFollowButton.Text = "🔄 Auto Follow All Enemies"
    selectedPlayerLabel.Text = "🎯 Selected: None"
    selectedPlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distanceLabel.Text = "📏 Distance: --"
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    -- Reset all buttons
    for _, child in pairs(playerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            TweenService:Create(child, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(110, 110, 130)}):Play()
        end
    end
    
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "🎯 Troll Player",
        Text = "Stopped following!",
        Duration = 3,
    })
end)

-- Auto follow button click
autoFollowButton.MouseButton1Click:Connect(function()
    autoFollowAll = not autoFollowAll
    
    if autoFollowAll then
        TweenService:Create(autoFollowButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
        autoFollowButton.Text = "🔄 Auto Following..."
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "🔄 Auto Follow",
            Text = "Started auto following all enemies!",
            Duration = 3,
        })
        autoFollowAllEnemies()
    else
        TweenService:Create(autoFollowButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(150, 100, 200)}):Play()
        autoFollowButton.Text = "🔄 Auto Follow All Enemies"
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "🔄 Auto Follow",
            Text = "Stopped auto following!",
            Duration = 3,
        })
    end
end)

-- Update player list when players join/leave
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Initial player list update
updatePlayerList()

-- Close GUI with Escape key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Escape then
        screenGui:Destroy()
    end
end)

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "🎯 Troll Player",
    Text = "GUI opened! Select a player to follow them.",
    Duration = 6,
}) 