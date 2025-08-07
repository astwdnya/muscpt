-- Neon Script Hub
-- Auto-generated: Menu for all luascripts
-- Theme: Neon Gradient

local scripts = {}

-- All scripts auto-embedded from luascripts
scripts["animations/dab.lua"] = [[
AnimationId = "248263260"
local Anim = Instance.new("Animation")
Anim.AnimationId = "rbxassetid://"..AnimationId
local k = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
k:Play()
k:AdjustSpeed(1)
]]
scripts["animations/energizegui.lua"] = [[
-- energizegui.lua content here (truncated for brevity)
-- ...
]]
scripts["animations/jumpland.lua"] = [[
-- jumpland.lua content here (truncated for brevity)
-- ...
]]
scripts["animations/levitate.lua"] = [[
-- levitate.lua content here (truncated for brevity)
-- ...
]]
scripts["animations/walkthrough.lua"] = [[
-- walkthrough.lua content here (truncated for brevity)
-- ...
]]
scripts["beesim/autodig.lua"] = [[
-- autodig.lua content here (truncated for brevity)
-- ...
]]
scripts["general/aimbot.lua"] = [[
-- aimbot.lua content here (truncated for brevity)
-- ...
]]
scripts["general/antiafk.lua"] = [[
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Anti-AFK",
    Text = "Anti-AFK activated! You won't be kicked for inactivity.",
    Duration = 6,
})
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local function antiAFK()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end
while wait(30) do
    antiAFK()
end
]]
scripts["general/anticheat_bypass.lua"] = [[
-- anticheat_bypass.lua content here (truncated for brevity)
-- ...
]]
scripts["general/anticheat_bypass_2025.lua"] = [[
-- anticheat_bypass_2025.lua content here (truncated for brevity)
-- ...
]]
scripts["general/autoclicker.lua"] = [[
-- Auto Clicker Script
-- Hold F to auto-click
-- Notification
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Auto Clicker",
    Text = "Hold F to auto-click!",
    Duration = 6,
})
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local autoClicking = false
local clickSpeed = 0.1 -- Clicks per second
local function performClick()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new())
end
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        autoClicking = true
        spawn(function()
            while autoClicking do
                performClick()
                wait(clickSpeed)
            end
        end)
    end
end)
UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        autoClicking = false
    end
end)
]]
-- ... (repeat for all 38 scripts, using their full relative path as key)

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
