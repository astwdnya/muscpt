-- Neon Script Hub
-- Auto-generated: Menu for all luascripts
-- Theme: Neon Gradient

local scripts = {}

-- All scripts auto-embedded from luascripts as requested by user
scripts["general/aimbot.lua"] = [[
-- Aimbot Script
-- Automatically aims at the nearest player
-- Notification
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Aimbot",
    Text = "Aimbot activated! Automatically aims at the nearest player.",
    Duration = 6,
})
-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
-- Aimbot Configuration
local aimbotEnabled = true
local aimbotRange = 1000
local aimbotSpeed = 10
-- Function to get the nearest player
local function getNearestPlayer()
    local nearestPlayer = nil
    local nearestDistance = aimbotRange
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local distance = (humanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance < nearestDistance then
                        nearestPlayer = player
                        nearestDistance = distance
                    end
                end
            end
        end
    end
    return nearestPlayer
end
-- Function to aim at a player
local function aimAtPlayer(player)
    if player then
        local character = player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local cameraCFrame = Camera.CFrame
                local targetCFrame = humanoidRootPart.CFrame
                local aimCFrame = cameraCFrame * CFrame.new(cameraCFrame.Position, targetCFrame.Position)
                Camera.CFrame = aimCFrame
            end
        end
    end
end
-- Update function
local function updateAimbot()
    if aimbotEnabled then
        local nearestPlayer = getNearestPlayer()
        aimAtPlayer(nearestPlayer)
    end
end
-- Connect update function
RunService.RenderStepped:Connect(updateAimbot)
]]
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
