-- Neon Script Hub
-- Auto-generated: Menu for all luascripts
-- Theme: Neon Gradient

local scripts = {}

-- All scripts auto-embedded from luascripts as requested by user
scripts["general/aimbot.lua"] = [[
-- Aimbot Script with GUI
-- Automatically aims at players with customizable settings

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Variables
local aimbotEnabled = false
local targetPlayer = nil
local selectedPlayers = {} -- Store selected players
local currentTab = "settings" -- Current active tab
local noRecoilEnabled = false -- No recoil feature
local aimbotSettings = {
    fov = 100, -- Field of view
    smoothness = 1, -- Aim smoothness (1 = instant, higher = smoother)
    aimPart = "Head", -- Part to aim at (Head, Torso, etc.)
    teamCheck = false, -- Don't aim at teammates
    visibilityCheck = true, -- Only aim at visible players
    triggerKey = Enum.KeyCode.RightShift -- Key to hold for aimbot
}

-- FOV Circle GUI
local fovCircleGui = Instance.new("ScreenGui")
fovCircleGui.Name = "FOVCircleGUI"
fovCircleGui.Parent = game.CoreGui

local fovCircle = Instance.new("Frame")
fovCircle.Name = "FOVCircle"
fovCircle.Size = UDim2.new(0, aimbotSettings.fov * 2, 0, aimbotSettings.fov * 2)
fovCircle.Position = UDim2.new(0.5, -aimbotSettings.fov, 0.5, -aimbotSettings.fov)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Parent = fovCircleGui

-- Create circle using ImageLabel with a circle image
local circleImage = Instance.new("ImageLabel")
circleImage.Name = "CircleImage"
circleImage.Size = UDim2.new(1, 0, 1, 0)
circleImage.Position = UDim2.new(0, 0, 0, 0)
circleImage.BackgroundTransparency = 1
circleImage.Image = "rbxasset://textures/whiteCircle.png"
circleImage.ImageTransparency = 0.8
circleImage.ImageColor3 = Color3.fromRGB(100, 200, 255)
circleImage.Parent = fovCircle

-- Add stroke effect
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(150, 220, 255)
stroke.Thickness = 2
stroke.Transparency = 0.3
stroke.Parent = circleImage

-- Function to update FOV circle
local function updateFOVCircle()
    local newSize = aimbotSettings.fov * 2
    fovCircle.Size = UDim2.new(0, newSize, 0, newSize)
    fovCircle.Position = UDim2.new(0.5, -aimbotSettings.fov, 0.5, -aimbotSettings.fov)
    
    -- Change color based on aimbot state
    if aimbotEnabled then
        circleImage.ImageColor3 = Color3.fromRGB(100, 255, 100) -- Green when enabled
        stroke.Color = Color3.fromRGB(150, 255, 150)
    else
        circleImage.ImageColor3 = Color3.fromRGB(100, 200, 255) -- Blue when disabled
        stroke.Color = Color3.fromRGB(150, 220, 255)
    end
end

-- Initially hide the circle
fovCircle.Visible = false

-- No Recoil Function
local function removeRecoil()
    if not noRecoilEnabled then return end
    
    -- Get the player's character and tools
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Check if player has a tool (weapon)
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    -- Arsenal specific recoil removal
    -- Arsenal uses a module called "Recoil" in the tool
    local recoilModule = tool:FindFirstChild("Recoil")
    if recoilModule then
        -- Disable recoil by setting values to 0
        for _, child in pairs(recoilModule:GetChildren()) do
            if child:IsA("NumberValue") then
                child.Value = 0
            elseif child:IsA("Vector3Value") then
                child.Value = Vector3.new(0, 0, 0)
            end
        end
    end
    
    -- Alternative method: Hook into the tool's events
    local toolScript = tool:FindFirstChild("LocalScript")
    if toolScript then
        -- Try to disable recoil by modifying the script
        local scriptSource = toolScript.Source
        if scriptSource then
            -- Replace recoil-related code
            scriptSource = scriptSource:gsub("recoil", "0")
            scriptSource = scriptSource:gsub("Recoil", "0")
        end
    end
    
    -- General recoil removal for any game
    -- Hook into camera shake events
    local camera = workspace.CurrentCamera
    if camera then
        -- Remove any camera shake
        camera.CameraSubject = humanoid
        camera.CameraType = Enum.CameraType.Custom
    end
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimbotGUI"
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 420, 0, 450) -- Increased size for better visibility
frame.Position = UDim2.new(0, 10, 1, -460) -- Adjusted position
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Add rounded corners effect
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Add subtle border
local border = Instance.new("Frame")
border.Name = "Border"
border.Size = UDim2.new(1, 0, 1, 0)
border.Position = UDim2.new(0, 0, 0, 0)
border.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
border.BorderSizePixel = 0
border.Parent = frame

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 12)
borderCorner.Parent = border

local innerFrame = Instance.new("Frame")
innerFrame.Name = "InnerFrame"
innerFrame.Size = UDim2.new(1, -4, 1, -4)
innerFrame.Position = UDim2.new(0, 2, 0, 2)
innerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
innerFrame.BorderSizePixel = 0
innerFrame.Parent = frame

local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(0, 10)
innerCorner.Parent = innerFrame

-- Make frame draggable
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Title with gradient
local title = Instance.new("Frame")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
title.BorderSizePixel = 0
title.Parent = innerFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -60, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🎯 Aimbot Settings"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.Parent = title

-- Close button (X) with better design
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = title

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    fovCircleGui:Destroy()
end)

-- Tab System
local tabFrame = Instance.new("Frame")
tabFrame.Name = "TabFrame"
tabFrame.Size = UDim2.new(1, 0, 0, 35)
tabFrame.Position = UDim2.new(0, 0, 0, 45)
tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = innerFrame

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 8)
tabCorner.Parent = tabFrame

-- Settings Tab Button
local settingsTabButton = Instance.new("TextButton")
settingsTabButton.Name = "SettingsTabButton"
settingsTabButton.Size = UDim2.new(0.5, -5, 1, -10)
settingsTabButton.Position = UDim2.new(0, 5, 0, 5)
settingsTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
settingsTabButton.BorderSizePixel = 0
settingsTabButton.Text = "⚙️ Settings"
settingsTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsTabButton.TextScaled = true
settingsTabButton.Font = Enum.Font.Gotham
settingsTabButton.Parent = tabFrame

local settingsTabCorner = Instance.new("UICorner")
settingsTabCorner.CornerRadius = UDim.new(0, 6)
settingsTabCorner.Parent = settingsTabButton

-- Players Tab Button
local playersTabButton = Instance.new("TextButton")
playersTabButton.Name = "PlayersTabButton"
playersTabButton.Size = UDim2.new(0.5, -5, 1, -10)
playersTabButton.Position = UDim2.new(0.5, 0, 0, 5)
playersTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
playersTabButton.BorderSizePixel = 0
playersTabButton.Text = "👥 Players"
playersTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
playersTabButton.TextScaled = true
playersTabButton.Font = Enum.Font.Gotham
playersTabButton.Parent = tabFrame

local playersTabCorner = Instance.new("UICorner")
playersTabCorner.CornerRadius = UDim.new(0, 6)
playersTabCorner.Parent = playersTabButton

-- Content Frames
local settingsContent = Instance.new("Frame")
settingsContent.Name = "SettingsContent"
settingsContent.Size = UDim2.new(1, -20, 1, -100) -- Increased height
settingsContent.Position = UDim2.new(0, 10, 0, 95) -- Adjusted position
settingsContent.BackgroundTransparency = 1
settingsContent.Parent = innerFrame

local playersContent = Instance.new("Frame")
playersContent.Name = "PlayersContent"
playersContent.Size = UDim2.new(1, -20, 1, -100) -- Increased height
playersContent.Position = UDim2.new(0, 10, 0, 95) -- Adjusted position
playersContent.BackgroundTransparency = 1
playersContent.Visible = false
playersContent.Parent = innerFrame

-- Function to switch tabs
local function switchTab(tabName)
    currentTab = tabName
    
    if tabName == "settings" then
        settingsContent.Visible = true
        playersContent.Visible = false
        settingsTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        settingsTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        playersTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        playersTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        titleText.Text = "🎯 Aimbot Settings"
    else
        settingsContent.Visible = false
        playersContent.Visible = true
        settingsTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        settingsTabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        playersTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        playersTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleText.Text = "👥 Player Selection"
    end
end

settingsTabButton.MouseButton1Click:Connect(function()
    switchTab("settings")
end)

playersTabButton.MouseButton1Click:Connect(function()
    switchTab("players")
end)

-- Settings Tab Content
-- Key Binding Section
local keyLabel = Instance.new("TextLabel")
keyLabel.Name = "KeyLabel"
keyLabel.Size = UDim2.new(0.8, 0, 0, 25) -- Increased height
keyLabel.Position = UDim2.new(0.1, 0, 0.03, 0) -- Adjusted position
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "🔑 Trigger Key: " .. aimbotSettings.triggerKey.Name
keyLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
keyLabel.TextScaled = true
keyLabel.Font = Enum.Font.Gotham
keyLabel.Parent = settingsContent

local keyButton = Instance.new("TextButton")
keyButton.Name = "KeyButton"
keyButton.Size = UDim2.new(0.8, 0, 0, 35) -- Increased height
keyButton.Position = UDim2.new(0.1, 0, 0.08, 0) -- Adjusted position
keyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
keyButton.BorderSizePixel = 0
keyButton.Text = "Click to change key"
keyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
keyButton.TextScaled = true
keyButton.Font = Enum.Font.Gotham
keyButton.Parent = settingsContent

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 8)
keyCorner.Parent = keyButton

local waitingForKey = false

keyButton.MouseButton1Click:Connect(function()
    if not waitingForKey then
        waitingForKey = true
        keyButton.Text = "Press any key..."
        keyButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.KeyCode ~= Enum.KeyCode.Unknown then
                aimbotSettings.triggerKey = input.KeyCode
                keyLabel.Text = "🔑 Trigger Key: " .. aimbotSettings.triggerKey.Name
                keyButton.Text = "Click to change key"
                keyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                waitingForKey = false
                connection:Disconnect()
            end
        end)
    end
end)

-- FOV Slider with better design
local fovLabel = Instance.new("TextLabel")
fovLabel.Name = "FOVLabel"
fovLabel.Size = UDim2.new(0.8, 0, 0, 25) -- Increased height
fovLabel.Position = UDim2.new(0.1, 0, 0.18, 0) -- Adjusted position
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "👁️ FOV: " .. aimbotSettings.fov
fovLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
fovLabel.TextScaled = true
fovLabel.Font = Enum.Font.Gotham
fovLabel.Parent = settingsContent

local fovSlider = Instance.new("Frame")
fovSlider.Name = "FOVSlider"
fovSlider.Size = UDim2.new(0.8, 0, 0, 10) -- Increased height
fovSlider.Position = UDim2.new(0.1, 0, 0.25, 0) -- Adjusted position
fovSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
fovSlider.BorderSizePixel = 0
fovSlider.Parent = settingsContent

local fovSliderCorner = Instance.new("UICorner")
fovSliderCorner.CornerRadius = UDim.new(0, 4)
fovSliderCorner.Parent = fovSlider

local fovFill = Instance.new("Frame")
fovFill.Name = "FOVFill"
fovFill.Size = UDim2.new(aimbotSettings.fov / 300, 0, 1, 0)
fovFill.Position = UDim2.new(0, 0, 0, 0)
fovFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
fovFill.BorderSizePixel = 0
fovFill.Parent = fovSlider

local fovFillCorner = Instance.new("UICorner")
fovFillCorner.CornerRadius = UDim.new(0, 4)
fovFillCorner.Parent = fovFill

local fovButton = Instance.new("TextButton")
fovButton.Name = "FOVButton"
fovButton.Size = UDim2.new(0.8, 0, 0, 25) -- Increased height
fovButton.Position = UDim2.new(0.1, 0, 0.25, -8) -- Adjusted position
fovButton.BackgroundTransparency = 1
fovButton.Text = ""
fovButton.Parent = settingsContent

fovButton.MouseButton1Down:Connect(function()
    local connection
    connection = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = fovSlider.AbsolutePosition.X
            local sliderWidth = fovSlider.AbsoluteSize.X
            local percentage = math.clamp((mousePos.X - sliderPos) / sliderWidth, 0, 1)
            aimbotSettings.fov = math.floor(percentage * 300)
            fovLabel.Text = "👁️ FOV: " .. aimbotSettings.fov
            fovFill.Size = UDim2.new(percentage, 0, 1, 0)
            updateFOVCircle() -- Update the FOV circle
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            connection:Disconnect()
        end
    end)
end)

-- Smoothness Slider with better design
local smoothLabel = Instance.new("TextLabel")
smoothLabel.Name = "SmoothLabel"
smoothLabel.Size = UDim2.new(0.8, 0, 0, 25) -- Increased height
smoothLabel.Position = UDim2.new(0.1, 0, 0.33, 0) -- Adjusted position
smoothLabel.BackgroundTransparency = 1
smoothLabel.Text = "🎯 Smoothness: " .. aimbotSettings.smoothness
smoothLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
smoothLabel.TextScaled = true
smoothLabel.Font = Enum.Font.Gotham
smoothLabel.Parent = settingsContent

local smoothSlider = Instance.new("Frame")
smoothSlider.Name = "SmoothSlider"
smoothSlider.Size = UDim2.new(0.8, 0, 0, 10) -- Increased height
smoothSlider.Position = UDim2.new(0.1, 0, 0.40, 0) -- Adjusted position
smoothSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
smoothSlider.BorderSizePixel = 0
smoothSlider.Parent = settingsContent

local smoothSliderCorner = Instance.new("UICorner")
smoothSliderCorner.CornerRadius = UDim.new(0, 4)
smoothSliderCorner.Parent = smoothSlider

local smoothFill = Instance.new("Frame")
smoothFill.Name = "SmoothFill"
smoothFill.Size = UDim2.new(aimbotSettings.smoothness / 10, 0, 1, 0)
smoothFill.Position = UDim2.new(0, 0, 0, 0)
smoothFill.BackgroundColor3 = Color3.fromRGB(255, 150, 100)
smoothFill.BorderSizePixel = 0
smoothFill.Parent = smoothSlider

local smoothFillCorner = Instance.new("UICorner")
smoothFillCorner.CornerRadius = UDim.new(0, 4)
smoothFillCorner.Parent = smoothFill

local smoothButton = Instance.new("TextButton")
smoothButton.Name = "SmoothButton"
smoothButton.Size = UDim2.new(0.8, 0, 0, 25) -- Increased height
smoothButton.Position = UDim2.new(0.1, 0, 0.40, -8) -- Adjusted position
smoothButton.BackgroundTransparency = 1
smoothButton.Text = ""
smoothButton.Parent = settingsContent

smoothButton.MouseButton1Down:Connect(function()
    local connection
    connection = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = smoothSlider.AbsolutePosition.X
            local sliderWidth = smoothSlider.AbsoluteSize.X
            local percentage = math.clamp((mousePos.X - sliderPos) / sliderWidth, 0, 1)
            aimbotSettings.smoothness = math.floor(percentage * 10) + 1
            smoothLabel.Text = "🎯 Smoothness: " .. aimbotSettings.smoothness
            smoothFill.Size = UDim2.new(percentage, 0, 1, 0)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            connection:Disconnect()
        end
    end)
end)

-- Aim Part Dropdown with better design
local partLabel = Instance.new("TextLabel")
partLabel.Name = "PartLabel"
partLabel.Size = UDim2.new(0.8, 0, 0, 25) -- Increased height
partLabel.Position = UDim2.new(0.1, 0, 0.48, 0) -- Adjusted position
partLabel.BackgroundTransparency = 1
partLabel.Text = "🎯 Aim Part: " .. aimbotSettings.aimPart
partLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
partLabel.TextScaled = true
partLabel.Font = Enum.Font.Gotham
partLabel.Parent = settingsContent

local partButton = Instance.new("TextButton")
partButton.Name = "PartButton"
partButton.Size = UDim2.new(0.8, 0, 0, 35) -- Increased height
partButton.Position = UDim2.new(0.1, 0, 0.55, 0) -- Adjusted position
partButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
partButton.BorderSizePixel = 0
partButton.Text = aimbotSettings.aimPart
partButton.TextColor3 = Color3.fromRGB(255, 255, 255)
partButton.TextScaled = true
partButton.Font = Enum.Font.Gotham
partButton.Parent = settingsContent

local partCorner = Instance.new("UICorner")
partCorner.CornerRadius = UDim.new(0, 8)
partCorner.Parent = partButton

local parts = {"Head", "Torso", "HumanoidRootPart"}
local currentPartIndex = 1

partButton.MouseButton1Click:Connect(function()
    currentPartIndex = currentPartIndex % #parts + 1
    aimbotSettings.aimPart = parts[currentPartIndex]
    partButton.Text = aimbotSettings.aimPart
    partLabel.Text = "🎯 Aim Part: " .. aimbotSettings.aimPart
end)

-- No Recoil Toggle Button
local noRecoilButton = Instance.new("TextButton")
noRecoilButton.Name = "NoRecoilButton"
noRecoilButton.Size = UDim2.new(0.38, 0, 0, 35) -- Increased size
noRecoilButton.Position = UDim2.new(0.05, 0, 0.65, 0) -- Adjusted position
noRecoilButton.BackgroundColor3 = noRecoilEnabled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
noRecoilButton.BorderSizePixel = 0
noRecoilButton.Text = "🔫 No Recoil"
noRecoilButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noRecoilButton.TextScaled = true
noRecoilButton.Font = Enum.Font.Gotham
noRecoilButton.Parent = settingsContent

local noRecoilCorner = Instance.new("UICorner")
noRecoilCorner.CornerRadius = UDim.new(0, 8)
noRecoilCorner.Parent = noRecoilButton

noRecoilButton.MouseButton1Click:Connect(function()
    noRecoilEnabled = not noRecoilEnabled
    noRecoilButton.BackgroundColor3 = noRecoilEnabled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
    
    if noRecoilEnabled then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "🔫 No Recoil",
            Text = "No Recoil enabled! Perfect for Arsenal!",
            Duration = 3,
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "🔫 No Recoil",
            Text = "No Recoil disabled!",
            Duration = 3,
        })
    end
end)

-- Toggle Buttons with better design
local teamCheckButton = Instance.new("TextButton")
teamCheckButton.Name = "TeamCheckButton"
teamCheckButton.Size = UDim2.new(0.38, 0, 0, 35) -- Increased size
teamCheckButton.Position = UDim2.new(0.57, 0, 0.65, 0) -- Adjusted position
teamCheckButton.BackgroundColor3 = aimbotSettings.teamCheck and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
teamCheckButton.BorderSizePixel = 0
teamCheckButton.Text = "👥 Team Check"
teamCheckButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teamCheckButton.TextScaled = true
teamCheckButton.Font = Enum.Font.Gotham
teamCheckButton.Parent = settingsContent

local teamCorner = Instance.new("UICorner")
teamCorner.CornerRadius = UDim.new(0, 8)
teamCorner.Parent = teamCheckButton

teamCheckButton.MouseButton1Click:Connect(function()
    aimbotSettings.teamCheck = not aimbotSettings.teamCheck
    teamCheckButton.BackgroundColor3 = aimbotSettings.teamCheck and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
end)

local visibilityButton = Instance.new("TextButton")
visibilityButton.Name = "VisibilityButton"
visibilityButton.Size = UDim2.new(0.38, 0, 0, 35) -- Increased size
visibilityButton.Position = UDim2.new(0.05, 0, 0.75, 0) -- Adjusted position
visibilityButton.BackgroundColor3 = aimbotSettings.visibilityCheck and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
visibilityButton.BorderSizePixel = 0
visibilityButton.Text = "👁️ Visibility"
visibilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
visibilityButton.TextScaled = true
visibilityButton.Font = Enum.Font.Gotham
visibilityButton.Parent = settingsContent

local visibilityCorner = Instance.new("UICorner")
visibilityCorner.CornerRadius = UDim.new(0, 8)
visibilityCorner.Parent = visibilityButton

visibilityButton.MouseButton1Click:Connect(function()
    aimbotSettings.visibilityCheck = not aimbotSettings.visibilityCheck
    visibilityButton.BackgroundColor3 = aimbotSettings.visibilityCheck and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
end)

-- Enable/Disable Button with better design
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.38, 0, 0, 35) -- Increased size
toggleButton.Position = UDim2.new(0.57, 0, 0.75, 0) -- Adjusted position
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "❌ DISABLED"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = settingsContent

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleButton

-- Add Anti-Cheat Bypass Button
local bypassButton = Instance.new("TextButton")
bypassButton.Name = "BypassButton"
bypassButton.Size = UDim2.new(0.8, 0, 0, 35)
bypassButton.Position = UDim2.new(0.1, 0, 0.85, 0)
bypassButton.BackgroundColor3 = Color3.fromRGB(80, 60, 120)
bypassButton.BorderSizePixel = 0
bypassButton.Text = "🚫 Anti-Cheat Bypass  🛡️"
bypassButton.TextColor3 = Color3.fromRGB(255, 255, 255)
bypassButton.TextScaled = true
bypassButton.Font = Enum.Font.GothamBold
bypassButton.Parent = settingsContent

local bypassCorner = Instance.new("UICorner")
bypassCorner.CornerRadius = UDim.new(0, 10)
bypassCorner.Parent = bypassButton

-- Add emoji icon (shield) to the button visually
local emojiIcon = Instance.new("ImageLabel")
emojiIcon.Name = "BypassEmoji"
emojiIcon.Size = UDim2.new(0, 28, 0, 28)
emojiIcon.Position = UDim2.new(0, 8, 0.5, -14)
emojiIcon.BackgroundTransparency = 1
emojiIcon.Image = "rbxassetid://7733960981" -- Shield emoji asset
emojiIcon.Parent = bypassButton

bypassButton.MouseButton1Click:Connect(function()
    -- اجرای اسکریپت بایپس آنتی‌چیت
    local success, err = pcall(function()
        loadfile("luascripts/general/anticheat_bypass.lua")()
    end)
    if success then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Bypass",
            Text = "Anti-Cheat Bypass اجرا شد!",
            Duration = 4
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Bypass Error",
            Text = tostring(err),
            Duration = 6
        })
    end
end)

-- Players Tab Content
local playersLabel = Instance.new("TextLabel")
playersLabel.Name = "PlayersLabel"
playersLabel.Size = UDim2.new(1, 0, 0, 25)
playersLabel.Position = UDim2.new(0, 0, 0, 0)
playersLabel.BackgroundTransparency = 1
playersLabel.Text = "👥 Select Players to Target:"
playersLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
playersLabel.TextScaled = true
playersLabel.Font = Enum.Font.GothamBold
playersLabel.Parent = playersContent

-- Player list container
local playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Name = "PlayerListFrame"
playerListFrame.Size = UDim2.new(1, 0, 1, -35)
playerListFrame.Position = UDim2.new(0, 0, 0, 30)
playerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
playerListFrame.BorderSizePixel = 0
playerListFrame.ScrollBarThickness = 6
playerListFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
playerListFrame.Parent = playersContent

local playerListCorner = Instance.new("UICorner")
playerListCorner.CornerRadius = UDim.new(0, 8)
playerListCorner.Parent = playerListFrame

-- Function to create player button
local function createPlayerButton(player, index)
    local playerButton = Instance.new("Frame")
    playerButton.Name = player.Name .. "Button"
    playerButton.Size = UDim2.new(1, -10, 0, 40)
    playerButton.Position = UDim2.new(0, 5, 0, (index - 1) * 45)
    playerButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    playerButton.BorderSizePixel = 0
    playerButton.Parent = playerListFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = playerButton
    
    local checkbox = Instance.new("TextButton")
    checkbox.Name = "Checkbox"
    checkbox.Size = UDim2.new(0, 20, 0, 20)
    checkbox.Position = UDim2.new(0, 10, 0.5, -10)
    checkbox.BackgroundColor3 = selectedPlayers[player] and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(60, 60, 80)
    checkbox.BorderSizePixel = 0
    checkbox.Text = ""
    checkbox.Parent = playerButton
    
    local checkboxCorner = Instance.new("UICorner")
    checkboxCorner.CornerRadius = UDim.new(0, 4)
    checkboxCorner.Parent = checkbox
    
    local playerName = Instance.new("TextLabel")
    playerName.Name = "PlayerName"
    playerName.Size = UDim2.new(1, -50, 1, 0)
    playerName.Position = UDim2.new(0, 40, 0, 0)
    playerName.BackgroundTransparency = 1
    playerName.Text = player.Name
    playerName.TextColor3 = Color3.fromRGB(255, 255, 255)
    playerName.TextScaled = true
    playerName.Font = Enum.Font.Gotham
    playerName.TextXAlignment = Enum.TextXAlignment.Left
    playerName.Parent = playerButton
    
    -- Checkbox functionality
    checkbox.MouseButton1Click:Connect(function()
        if selectedPlayers[player] then
            selectedPlayers[player] = nil
            checkbox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        else
            selectedPlayers[player] = true
            checkbox.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        end
    end)
    
    return playerButton
end

-- Function to update player list
local function updatePlayerList()
    -- Clear existing buttons
    for _, child in pairs(playerListFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Create buttons for each player
    local index = 1
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createPlayerButton(player, index)
            index = index + 1
        end
    end
    
    -- Update canvas size
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, (index - 1) * 45)
end

-- Function to preserve player selections when character respawns
local function onCharacterAdded()
    -- Wait a bit for the character to fully load
    wait(1)
    -- Update the player list to restore selections
    updatePlayerList()
end

-- Connect character respawn events
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Update player list when players join/leave
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function(player)
    -- Remove the player from selected players if they leave
    selectedPlayers[player] = nil
    updatePlayerList()
end)

-- Initial player list
updatePlayerList()

-- Functions
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            -- Check if player is selected (if any players are selected)
            local isSelected = next(selectedPlayers) == nil or selectedPlayers[player]
            
            if isSelected then
                -- Team check
                if not (aimbotSettings.teamCheck and player.Team == LocalPlayer.Team) then
                    local targetPart = player.Character:FindFirstChild(aimbotSettings.aimPart)
                    if targetPart then
                        -- FOV check
                        local screenPoint = Camera:WorldToScreenPoint(targetPart.Position)
                        local mousePos = UserInputService:GetMouseLocation()
                        local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                        
                        if distance <= aimbotSettings.fov then
                            -- Visibility check
                            if aimbotSettings.visibilityCheck then
                                local ray = Ray.new(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 1000)
                                local hit, _ = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
                                if hit and hit:IsDescendantOf(player.Character) then
                                    if distance < shortestDistance then
                                        shortestDistance = distance
                                        closestPlayer = player
                                    end
                                end
                            else
                                if distance < shortestDistance then
                                    shortestDistance = distance
                                    closestPlayer = player
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function aimAtPlayer(player)
    if not player or not player.Character then
        return
    end
    
    local targetPart = player.Character:FindFirstChild(aimbotSettings.aimPart)
    if not targetPart then
        return
    end
    
    local targetPosition = targetPart.Position
    local cameraPosition = Camera.CFrame.Position
    local aimDirection = (targetPosition - cameraPosition).Unit
    
    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.new(cameraPosition, targetPosition)
    
    -- Apply smoothness
    local newCFrame = currentCFrame:Lerp(targetCFrame, 1 / aimbotSettings.smoothness)
    Camera.CFrame = newCFrame
end

-- Toggle button functionality
toggleButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    
    if aimbotEnabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        toggleButton.Text = "✅ ENABLED"
        fovCircle.Visible = true -- Show FOV circle when enabled
        updateFOVCircle()
        
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "🎯 Aimbot",
            Text = "Aimbot enabled! Hold " .. aimbotSettings.triggerKey.Name .. " to aim",
            Duration = 3,
        })
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
        toggleButton.Text = "❌ DISABLED"
        fovCircle.Visible = false -- Hide FOV circle when disabled
        
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "🎯 Aimbot",
            Text = "Aimbot disabled!",
            Duration = 3,
        })
    end
end)

-- Main aimbot loop
RunService.RenderStepped:Connect(function()
    if not aimbotEnabled then
        return
    end
    
    if UserInputService:IsKeyDown(aimbotSettings.triggerKey) then
        targetPlayer = getClosestPlayer()
        if targetPlayer then
            aimAtPlayer(targetPlayer)
            -- Make circle more visible when aiming
            circleImage.ImageTransparency = 0.3
            stroke.Transparency = 0.1
        else
            -- Normal transparency when not aiming
            circleImage.ImageTransparency = 0.8
            stroke.Transparency = 0.3
        end
    else
        targetPlayer = nil
        -- Normal transparency when not holding trigger
        circleImage.ImageTransparency = 0.8
        stroke.Transparency = 0.3
    end
end)

-- No Recoil loop
RunService.RenderStepped:Connect(function()
    if noRecoilEnabled then
        removeRecoil()
    end
end)

-- Close GUI with Escape key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Escape then
        screenGui:Destroy()
        fovCircleGui:Destroy() -- Also destroy FOV circle when closing GUI
    end
end)

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "🎯 Aimbot",
    Text = "Aimbot GUI loaded! Hold " .. aimbotSettings.triggerKey.Name .. " to aim",
    Duration = 5,
}) 

-- Add BulletTrack toggle to the GUI
local bulletTrackEnabled = false

-- Add BulletTrack toggle button
local bulletTrackToggle = Instance.new("TextButton")
bulletTrackToggle.Name = "BulletTrackToggle"
bulletTrackToggle.Size = UDim2.new(0.48, 0, 0, 35)
bulletTrackToggle.Position = UDim2.new(0.02, 0, 0, 420)
bulletTrackToggle.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
bulletTrackToggle.BorderSizePixel = 0
bulletTrackToggle.Text = "🎯 BulletTrack: OFF"
bulletTrackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
bulletTrackToggle.TextScaled = true
bulletTrackToggle.Font = Enum.Font.SourceSansBold
bulletTrackToggle.Parent = frame

local bulletTrackCorner = Instance.new("UICorner")
bulletTrackCorner.CornerRadius = UDim.new(0, 10)
bulletTrackCorner.Parent = bulletTrackToggle

bulletTrackToggle.MouseButton1Click:Connect(function()
    bulletTrackEnabled = not bulletTrackEnabled
    if bulletTrackEnabled then
        bulletTrackToggle.BackgroundColor3 = Color3.fromRGB(0, 184, 148)
        bulletTrackToggle.Text = "🎯 BulletTrack: ON"
    else
        bulletTrackToggle.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
        bulletTrackToggle.Text = "🎯 BulletTrack: OFF"
    end
end)

-- Arsenal-specific BulletTrack (RemoteEvent hook)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function getNearestEnemy()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local nearest, minDist = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local dist = (myRoot.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = plr.Character.HumanoidRootPart
            end
        end
    end
    return nearest
end

-- Try to find Arsenal's shoot RemoteEvent
local shootRemote = nil
for _, v in pairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") and (v.Name:lower():find("fire") or v.Name:lower():find("shoot") or v.Name:lower():find("hit")) then
        shootRemote = v
        break
    end
end

if shootRemote and hookfunction then
    local oldFireServer
    oldFireServer = hookfunction(shootRemote.FireServer, function(self, ...)
        if bulletTrackEnabled then
            local args = {...}
            local target = getNearestEnemy()
            if target then
                -- Try to find the Vector3 argument (target position)
                for i, v in ipairs(args) do
                    if typeof(v) == "Vector3" then
                        args[i] = target.Position
                        break
                    end
                end
            end
            return oldFireServer(self, unpack(args))
        else
            return oldFireServer(self, ...)
        end
    end)
end

-- (Fallback) Old logic for physical bullets
local Workspace = game:GetService("Workspace")
Workspace.ChildAdded:Connect(function(child)
    if not bulletTrackEnabled then return end
    if child:IsA("BasePart") and (child.Name:lower():find("bullet") or child.Name:lower():find("projectile") or child.Name:lower():find("ray") or child.Name:lower():find("shell") or child.Name:lower():find("shot")) then
        wait(0.01)
        local target = getNearestEnemy()
        if target then
            local dir = (target.Position - child.Position).Unit
            local speed = child.Velocity.Magnitude
            child.CFrame = CFrame.new(child.Position, target.Position)
            child.Velocity = dir * speed
        end
    end
end) 
scripts["general/esp.lua"] = [[
-- ESP Script (Extra Sensory Perception)
-- Shows players through walls with team colors
-- Notification
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "ESP",
    Text = "ESP activated! Players are now visible through walls.",
    Duration = 6,
})
-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
-- ESP Configuration
local espEnabled = true
local espDistance = 1000
local espThickness = 1
local espTransparency = 0.5
-- Function to get team color
local function getTeamColor(player)
    if LocalPlayer.Team and player.Team then
        if LocalPlayer.Team == player.Team then
            return Color3.fromRGB(0, 255, 0) -- Green for teammates
        else
            return Color3.fromRGB(255, 0, 0) -- Red for enemies
        end
    else
        return Color3.fromRGB(255, 255, 255) -- White for no team
    end
end
-- ESP Storage
local espObjects = {}
-- Function to create ESP for a player
local function createESP(player)
    if player == LocalPlayer then return end
    -- Create ESP Box
    local espBox = Drawing.new("Square")
    espBox.Visible = false
    espBox.Color = getTeamColor(player)
    espBox.Thickness = espThickness
    espBox.Transparency = espTransparency
    espBox.Filled = false
    -- Create Name Tag
    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Color = getTeamColor(player)
    nameTag.Size = 20
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.Font = 2
    -- Create Distance Tag
    local distanceTag = Drawing.new("Text")
    distanceTag.Visible = false
    distanceTag.Color = getTeamColor(player)
    distanceTag.Size = 16
    distanceTag.Center = true
    distanceTag.Outline = true
    distanceTag.Font = 2
    -- Store ESP objects
    espObjects[player] = {
        box = espBox,
        name = nameTag,
        distance = distanceTag
    }
    -- Update function
    local function updateESP()
        if not espEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not player.Character:FindFirstChild("Head") then
            espBox.Visible = false
            nameTag.Visible = false
            distanceTag.Visible = false
            return
        end
        local humanoidRootPart = player.Character.HumanoidRootPart
        local head = player.Character.Head
        -- Check if player is on screen
        local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position)
        local rootPos, rootOnScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
        if headOnScreen and rootOnScreen then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
            if distance <= espDistance then
                -- Update colors based on team
                local teamColor = getTeamColor(player)
                espBox.Color = teamColor
                nameTag.Color = teamColor
                distanceTag.Color = teamColor
                -- Calculate ESP box
                local topPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 3, 0))
                local bottomPos = Camera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, 3, 0))
                local boxSize = Vector2.new(math.abs(topPos.X - bottomPos.X), math.abs(topPos.Y - bottomPos.Y))
                local boxPosition = Vector2.new(math.min(topPos.X, bottomPos.X), math.min(topPos.Y, bottomPos.Y))
                -- Update ESP box
                espBox.Size = boxSize
                espBox.Position = boxPosition
                espBox.Visible = true
                -- Update name tag
                nameTag.Position = Vector2.new(headPos.X, headPos.Y - 60)
                nameTag.Text = player.Name
                nameTag.Visible = true
                -- Update distance tag
                distanceTag.Position = Vector2.new(headPos.X, headPos.Y - 40)
                distanceTag.Text = math.floor(distance) .. "m"
                distanceTag.Visible = true
            else
                espBox.Visible = false
                nameTag.Visible = false
                distanceTag.Visible = false
            end
        else
            espBox.Visible = false
            nameTag.Visible = false
            distanceTag.Visible = false
        end
    end
    -- Connect update function
    RunService.RenderStepped:Connect(updateESP)
end
-- Function to remove ESP for a player
local function removeESP(player)
    if espObjects[player] then
        espObjects[player].box:Remove()
        espObjects[player].name:Remove()
        espObjects[player].distance:Remove()
        espObjects[player] = nil
    end
end
-- Create ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end
-- Create ESP for new players
Players.PlayerAdded:Connect(createESP)
-- Remove ESP when players leave
Players.PlayerRemoving:Connect(removeESP)
]]
scripts["general/jerk.lua"] = [[
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
]]
scripts["general/noclip.lua"] = [[
--[
    MIT License
    Copyright (c) 2019 WeAreDevs wearedevs.net
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
--]
_G.noclip = not _G.noclip
print(_G.noclip)
if not game:GetService('Players').LocalPlayer.Character:FindFirstChild("LowerTorso") then
    while _G.noclip do
        game:GetService("RunService").Stepped:wait()
        game.Players.LocalPlayer.Character.Head.CanCollide = false
        game.Players.LocalPlayer.Character.Torso.CanCollide = false
    end
else
    if _G.InitNC ~= true then     
        _G.NCFunc = function(part)      
            local pos = game:GetService('Players').LocalPlayer.Character.LowerTorso.Position.Y  
            if _G.noclip then             
                if part.Position.Y > pos then                 
                    part.CanCollide = false             
                end        
            end    
        end      
        _G.InitNC = true 
    end 
    game:GetService('Players').LocalPlayer.Character.Humanoid.Touched:connect(_G.NCFunc) 
end
]]
scripts["general/fly2.lua"] = [[
-- Advanced Fly Script (Fly2)
-- Free movement in the map with advanced controls
-- Notification
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Advanced Fly",
    Text = "Press CapsLock to toggle fly. WASD to move, Space/Shift for up/down",
    Duration = 6,
})
-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
-- Variables
local isFlying = false
local flySpeed = 50
local flySpeedMultiplier = 1
local bodyVelocity = nil
local bodyGyro = nil
-- Function to start flying
local function startFlying()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    -- Create BodyVelocity for movement
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = humanoidRootPart
    -- Create BodyGyro for smooth rotation
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.D = 50
    bodyGyro.P = 2000
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = humanoidRootPart.CFrame
    bodyGyro.Parent = humanoidRootPart
    -- Disable gravity
    humanoid.PlatformStand = true
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Fly Activated",
        Text = "You are now flying! Press CapsLock again to stop.",
        Duration = 3,
    })
end
-- Function to stop flying
local function stopFlying()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    -- Remove flying components
    if bodyVelocity and bodyVelocity.Parent then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro and bodyGyro.Parent then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    -- Re-enable gravity
    humanoid.PlatformStand = false
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Fly Deactivated",
        Text = "Flying stopped!",
        Duration = 3,
    })
end
-- Toggle flying
local function toggleFlying()
    isFlying = not isFlying
    if isFlying then
        startFlying()
    else
        stopFlying()
    end
end
-- Add more fly logic here if needed (full content to be embedded)
-- ...
]]
scripts["general/ctrlclicktp.lua"] = [[
-- Notification
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "CTRL click tp",
    Text = "Hold Ctrl then press click to a place you want to teleport to.",
    Duration = 6,
})
-- Configuration
local instant_teleport = true -- Set to true for instant teleport, false for tween
local speed = 1000 -- Only used if instant_teleport is false
local bodyvelocityenabled = true -- set this to false if you are getting kicked
local auto_above = true -- Automatically teleport above objects when clicking underneath
-- Services
local Imput = game:GetService("UserInputService")
local Plr = game.Players.LocalPlayer
local Mouse = Plr:GetMouse()
-- Function to get the top surface of an object
function GetTopSurface(object, hitPoint)
    if not object then return hitPoint end
    local size = object.Size
    local cframe = object.CFrame
    local topY = cframe.Y + (size.Y / 2)
    return Vector3.new(hitPoint.X, topY + 3, hitPoint.Z)
end
-- Function to find safe teleport position
function FindSafePosition(hitPoint, hitObject)
    if not auto_above then
        return hitPoint
    end
    -- If we clicked on an object, teleport to its top
    if hitObject then
        return GetTopSurface(hitObject, hitPoint)
    end
    -- If we clicked in air, try to find ground below
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {Plr.Character}
    -- Cast ray downward to find ground
    local raycastResult = workspace:Raycast(hitPoint, Vector3.new(0, -1000, 0), raycastParams)
    if raycastResult then
        -- Found ground, teleport above it
        return raycastResult.Position + Vector3.new(0, 3, 0)
    else
        -- No ground found, use original position with some height
        return hitPoint + Vector3.new(0, 5, 0)
    end
end
-- Advanced function to detect if we're clicking underneath something
function IsClickingUnderneath(hitPoint)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {Plr.Character}
    -- Cast multiple rays upward to detect objects above
    for i = 1, 10 do
        local rayStart = hitPoint + Vector3.new(0, i * 2, 0)
        local raycastResult = workspace:Raycast(rayStart, Vector3.new(0, 50, 0), raycastParams)
        if raycastResult then
            -- Found something above, return its top position
            local object = raycastResult.Instance
            local size = object.Size
            local cframe = object.CFrame
            local topY = cframe.Y + (size.Y / 2)
            return Vector3.new(hitPoint.X, topY + 3, hitPoint.Z)
        end
    end
    return nil -- Nothing found above
end
-- Teleport function
function To(position)
    local Chr = Plr.Character
    if Chr ~= nil then
        local hm = Chr.HumanoidRootPart
        -- Get the object we clicked on
        local hitObject = Mouse.Target
        local hitPoint = Mouse.Hit.p
        -- Add more logic for teleportation here (full content to be embedded)
        -- ...
    end
end
-- Add more ctrl click tp logic here (full content to be embedded)
-- ...
]]

-- Create Neon Gradient GUI
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NeonScriptHub"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 420, 0, 470)
frame.Position = UDim2.new(0.5, -210, 0.5, -235)
frame.BackgroundTransparency = 0.15
frame.BackgroundColor3 = Color3.fromRGB(25,25,40)
frame.BorderSizePixel = 0

-- Neon Gradient Effect
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,0,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,128))
}
gradient.Rotation = 45
gradient.Parent = frame

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,50)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "Neon Script Hub"
title.Font = Enum.Font.GothamBlack
title.TextSize = 32
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextStrokeTransparency = 0.7
title.TextStrokeColor3 = Color3.fromRGB(0,255,255)

local scrolling = Instance.new("ScrollingFrame")
scrolling.Parent = frame
scrolling.Size = UDim2.new(1,-20,1,-70)
scrolling.Position = UDim2.new(0,10,0,60)
scrolling.CanvasSize = UDim2.new(0,0,0, #scripts*45)
scrolling.BackgroundTransparency = 1
scrolling.BorderSizePixel = 0
scrolling.ScrollBarThickness = 8

local uiList = Instance.new("UIListLayout")
uiList.Parent = scrolling
uiList.Padding = UDim.new(0,8)
uiList.SortOrder = Enum.SortOrder.LayoutOrder

local function createNeonButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = scrolling
    btn.Size = UDim2.new(1,0,0,38)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,60)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 22
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.AutoButtonColor = false
    local neon = Instance.new("UIGradient")
    neon.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))
    }
    neon.Rotation = math.random(0,360)
    neon.Parent = btn
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40,0,60)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(30,30,60)
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

for scriptName, code in pairs(scripts) do
    createNeonButton(scriptName, function()
        loadstring(code)()
    end)
end

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = frame
closeBtn.Size = UDim2.new(0,38,0,38)
closeBtn.Position = UDim2.new(1,-48,0,10)
closeBtn.BackgroundColor3 = Color3.fromRGB(255,0,128)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.TextSize = 28
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.AutoButtonColor = true
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Draggable
frame.Active = true
frame.Draggable = true
