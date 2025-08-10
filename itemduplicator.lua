-- Item Duplicator Script (Client)
-- Creates a copy of the currently equipped item using server validation

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- Create RemoteEvent if it doesn't exist
local remoteEvent
if not ReplicatedStorage:FindFirstChild("ItemDuplicatorRemote") then
    remoteEvent = Instance.new("RemoteEvent")
    remoteEvent.Name = "ItemDuplicatorRemote"
    remoteEvent.Parent = ReplicatedStorage
else
    remoteEvent = ReplicatedStorage.ItemDuplicatorRemote
end

-- Variables
local currentEquippedItem = nil

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ItemDuplicatorGUI"
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Add rounded corners
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

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
title.BorderSizePixel = 0
title.Text = "🎮 Item Duplicator"
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

-- Current item label
local itemLabel = Instance.new("TextLabel")
itemLabel.Name = "ItemLabel"
itemLabel.Size = UDim2.new(1, -20, 0, 30)
itemLabel.Position = UDim2.new(0, 10, 0, 45)
itemLabel.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
itemLabel.BorderSizePixel = 0
itemLabel.Text = "Current Item: None"
itemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
itemLabel.TextScaled = true
itemLabel.Font = Enum.Font.SourceSans
itemLabel.Parent = frame

-- Add corner to item label
local itemCorner = Instance.new("UICorner")
itemCorner.CornerRadius = UDim.new(0, 8)
itemCorner.Parent = itemLabel

-- Copy button
local copyButton = Instance.new("TextButton")
copyButton.Name = "CopyButton"
copyButton.Size = UDim2.new(0.8, 0, 0, 40)
copyButton.Position = UDim2.new(0.1, 0, 0, 85)
copyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
copyButton.BorderSizePixel = 0
copyButton.Text = "Create a Copy"
copyButton.TextColor3 = Color3.fromRGB(200, 200, 200)
copyButton.TextScaled = true
copyButton.Font = Enum.Font.SourceSansBold
copyButton.Parent = frame

-- Add corner to copy button
local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 10)
copyCorner.Parent = copyButton

-- Add drag functionality
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

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Function to update current item
local function updateCurrentItem(item)
    currentEquippedItem = item
    
    if item then
        itemLabel.Text = "Current Item: " .. item.Name
        copyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        itemLabel.Text = "Current Item: None"
        copyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        copyButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

-- Function to create copy
local function createCopy()
    if not currentEquippedItem then
        StarterGui:SetCore("SendNotification", {
            Title = "❌ Error",
            Text = "No item equipped!",
            Duration = 3
        })
        return
    end
    
    print("=== Requesting Item Duplication ===")
    print("Original Item:", currentEquippedItem:GetFullName())
    
    -- Request server to duplicate the item
    remoteEvent:FireServer(currentEquippedItem)
    
    -- Show waiting notification
    StarterGui:SetCore("SendNotification", {
        Title = "⏳ Processing",
        Text = "Requesting item duplication...",
        Duration = 2
    })
end

-- Listen for server response
remoteEvent.OnClientEvent:Connect(function(success, message)
    if success then
        StarterGui:SetCore("SendNotification", {
            Title = "✅ Success",
            Text = message,
            Duration = 3
        })
        print("=== Item Duplication Success ===")
    else
        StarterGui:SetCore("SendNotification", {
            Title = "❌ Error",
            Text = message,
            Duration = 3
        })
        print("=== Item Duplication Failed ===")
        print("Error:", message)
    end
end)

-- Function to handle character
local function onCharacterAdded(character)
    -- Clear current item when character respawns
    updateCurrentItem(nil)
    
    -- Check for tools in character
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            updateCurrentItem(tool)
        end
    end
    
    -- Connect to Tool events
    character.ChildAdded:Connect(function(tool)
        if tool:IsA("Tool") then
            updateCurrentItem(tool)
        end
    end)
    
    character.ChildRemoved:Connect(function(tool)
        if tool:IsA("Tool") and tool == currentEquippedItem then
            updateCurrentItem(nil)
        end
    end)
end

-- Connect to CharacterAdded event
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Check if character already exists
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

-- Copy button click
copyButton.MouseButton1Click:Connect(function()
    createCopy()
end)

-- Initial notification
StarterGui:SetCore("SendNotification", {
    Title = "🎮 Item Duplicator",
    Text = "GUI opened! Equip an item to create a copy.",
    Duration = 5
}) 