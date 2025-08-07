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
scripts["general/autofarm.lua"] = [[
-- Auto Farm Script
-- Automatically collects nearby items and resources
-- Notification
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Auto Farm",
    Text = "Auto Farm activated! Collecting nearby items...",
    Duration = 6,
})
-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
-- Configuration
local collectionRadius = 50 -- How far to look for items
local autoCollect = true
-- Function to collect nearby items
local function collectNearbyItems()
    if not Character or not HumanoidRootPart then return end
    local items = workspace:GetDescendants()
    for _, item in pairs(items) do
        if item:IsA("Part") and item.Name:lower():find("coin") or 
           item.Name:lower():find("gem") or 
           item.Name:lower():find("item") or
           item.Name:lower():find("collect") then
            local distance = (HumanoidRootPart.Position - item.Position).Magnitude
            if distance <= collectionRadius then
                firetouchinterest(HumanoidRootPart, item, 0)
                firetouchinterest(HumanoidRootPart, item, 1)
                item:Destroy()
            end
        end
    end
end
while autoCollect and wait(1) do
    collectNearbyItems()
end
]]
scripts["general/chattroll.lua"] = [[
local Action = game.Players:GetPlayers()
for i = 1,#Action do
    Action[i].Chatted:connect(function(Message)
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("".."["..Action[i].Name.."]".." "..Message, "All")
    end)
end
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
        -- Check if we're clicking underneath something
        local underPos = IsClickingUnderneath(hitPoint)
        if underPos then
            position = underPos
        else
            position = FindSafePosition(hitPoint, hitObject)
        end
        -- Teleport
        if instant_teleport then
            hm.CFrame = CFrame.new(position)
        else
            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new((position - hm.Position).Magnitude / speed, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local tween = tweenService:Create(hm, tweenInfo, {CFrame = CFrame.new(position)})
            tween:Play()
        end
        -- Body velocity if enabled
        if bodyvelocityenabled then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Velocity = Vector3.new()
            bodyVelocity.Parent = hm
            wait(0.5)
            bodyVelocity:Destroy()
        end
    end
end
-- Connect mouse click event
Imput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and Imput:IsKeyDown(Enum.KeyCode.LeftControl) then
        To(Mouse.Hit.p)
    end
end)
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
scripts["general/executor_bypass.lua"] = [[
-- Executor Bypass Script - Fake Fluxus
-- این اسکریپت executor رو فیک می‌کنه تا اسکریپت‌ها فکر کنن از Fluxus استفاده می‌کنی
local function bypassExecutorCheck()
    -- فیک کردن نام executor
    if getexecutorname then
        local originalName = getexecutorname()
        getexecutorname = function() 
            return "Fluxus" 
        end
    end
    -- فیک کردن متغیرهای معمول executorها
    if not is_sirhurt_closure then
        is_sirhurt_closure = function() 
            return false 
        end
    end
    if not isvm then
        isvm = function() 
            return false 
        end
    end
    if not is_synapse_function then
        is_synapse_function = function() 
            return false 
        end
    end
    -- فیک کردن API های مختلف
    if not syn then
        syn = {}
        syn.request = http_request or request
        syn.crypt = {}
        syn.crypt.hash = function() return "" end
        syn.crypt.encrypt = function() return "" end
        syn.crypt.decrypt = function() return "" end
    end
    if not fluxus then
        fluxus = {}
        fluxus.request = http_request or request
        fluxus.crypt = {}
        fluxus.crypt.hash = function() return "" end
        fluxus.crypt.encrypt = function() return "" end
        fluxus.crypt.decrypt = function() return "" end
    end
    if not krnl then
        krnl = {}
        krnl.request = http_request or request
        krnl.crypt = {}
        krnl.crypt.hash = function() return "" end
        krnl.crypt.encrypt = function() return "" end
        krnl.crypt.decrypt = function() return "" end
    end
    -- فیک کردن Drawing API
    if not Drawing then
        Drawing = {}
        Drawing.new = function(type)
            local obj = {
                Visible = false,
                Color = Color3.fromRGB(255,255,255),
                Size = Vector2.new(0,0),
                Position = Vector2.new(0,0),
                Text = "",
                Thickness = 1,
                Transparency = 1,
                Filled = false,
                Center = false,
                Outline = false,
                Font = 1
            }
            if type == "Square" then
                obj.Size = Vector2.new(100,100)
            elseif type == "Text" then
                obj.Text = "Fake Text"
                obj.Size = 20
            elseif type == "Circle" then
                obj.Size = Vector2.new(50,50)
            elseif type == "Triangle" then
                obj.Size = Vector2.new(50,50)
            elseif type == "Image" then
                obj.Size = Vector2.new(100,100)
            end
            obj.Remove = function() end
            return obj
        end
    end
    -- فیک کردن متغیرهای اضافی
    if not PROTOSMASHER_LOADED then
        PROTOSMASHER_LOADED = false
    end
end
bypassExecutorCheck()
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
-- Connect CapsLock to toggle flying
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.CapsLock then
        toggleFlying()
    end
end)
-- Update flying movement
RunService.Stepped:Connect(function()
    if isFlying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        local lookDirection = Camera.CFrame.LookVector
        local moveDirection = Vector3.new()
        local moveSpeed = flySpeed * flySpeedMultiplier
        -- Check for WASD movement
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + lookDirection
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - lookDirection
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Vector3.new(lookDirection.Z, 0, -lookDirection.X)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - Vector3.new(lookDirection.Z, 0, -lookDirection.X)
        end
        -- Check for up/down movement
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        -- Apply movement
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
            bodyVelocity.Velocity = moveDirection * moveSpeed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        -- Update rotation
        bodyGyro.CFrame = CFrame.new(humanoidRootPart.Position) * CFrame.Angles(0, -math.atan2(lookDirection.X, lookDirection.Z), 0)
    end
end)
-- Speed multiplier controls
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then
        flySpeedMultiplier = 2 -- Boost speed
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Speed Boost",
            Text = "Fly speed boosted!",
            Duration = 2,
        })
    end
end)
UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then
        flySpeedMultiplier = 1 -- Normal speed
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Speed Normal",
            Text = "Fly speed returned to normal.",
            Duration = 2,
        })
    end
end)
]]
scripts["general/god.lua"] = [[
game.Players.LocalPlayer.Character.Humanoid.Name = 1
local l = game.Players.LocalPlayer.Character["1"]:Clone()
l.Parent = game.Players.LocalPlayer.Character
l.Name = "Humanoid"
wait(0.1)
game.Players.LocalPlayer.Character["1"]:Destroy()
game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character
game.Players.LocalPlayer.Character.Animate.Disabled = true
wait(0.1)
game.Players.LocalPlayer.Character.Animate.Disabled = false
game.Players.LocalPlayer.Character.Humanoid.DisplayDistanceType = "None"
]]
scripts["general/hideusername.lua"] = [[
-- Advanced Username Hiding Script
-- Hides username from server and other players using advanced techniques
-- Notification
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Advanced Username Hiding",
    Text = "Using advanced techniques to hide username...",
    Duration = 6,
})
-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local NetworkClient = game:GetService("NetworkClient")
-- Configuration
local hideUsername = true
local originalName = LocalPlayer.Name
local fakeName = "Player" .. math.random(1000, 9999)
-- Advanced username hiding techniques
local function advancedUsernameHiding()
    -- Technique 1: Network packet manipulation
    pcall(function()
        -- Hook network functions to intercept name requests
        local oldNamecall = getrawmetatable(game).__namecall
        setreadonly(getrawmetatable(game), false)
        getrawmetatable(game).__namecall = newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            -- Intercept name-related calls
            if method == "GetName" or method == "GetDisplayName" or method == "GetFullName" then
                return fakeName
            end
            -- Intercept player list calls
            if method == "GetPlayers" then
                local result = oldNamecall(self, ...)
                -- Replace player names in result
                if result and typeof(result) == "table" then
                    for i, player in pairs(result) do
                        if player == LocalPlayer then
                            -- Create fake player object
                            local fakePlayer = {}
                            setmetatable(fakePlayer, {
                                __index = function(t, k)
                                    if k == "Name" or k == "DisplayName" then
                                        return fakeName
                                    end
                                    return player[k]
                                end
                            })
                            result[i] = fakePlayer
                        end
                    end
                end
                return result
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(getrawmetatable(game), true)
    end)
    -- Technique 2: Disable name broadcasting
    pcall(function()
        -- Set fake names
        LocalPlayer.Name = fakeName
        LocalPlayer.DisplayName = fakeName
        -- Disable name change events
        for _, connection in pairs(getconnections(LocalPlayer.Changed)) do
            if connection.Function and tostring(connection.Function):find("Name") then
                connection:Disconnect()
            end
        end
    end)
    -- Technique 3: Chat system manipulation
    pcall(function()
        -- Hook chat system
        local chatService = game:GetService("TextChatService")
        if chatService then
            -- Intercept outgoing messages
            chatService.SendingMessage:Connect(function(message)
                if message.TextSource and message.TextSource.UserId == LocalPlayer.UserId then
                    -- Replace name in outgoing messages
                    message.Text = message.Text:gsub(LocalPlayer.Name, fakeName)
                end
            end)
            -- Intercept incoming messages
            chatService.MessageReceived:Connect(function(message)
                if message.TextSource and message.TextSource.UserId == LocalPlayer.UserId then
                    -- Replace name in incoming messages
                    message.Text = message.Text:gsub(LocalPlayer.Name, fakeName)
                end
            end)
        end
    end)
    -- Technique 4: Leaderboard manipulation
    pcall(function()
        -- Disable leaderboard name updates
        local leaderboard = StarterGui:FindFirstChild("Leaderboard")
        if leaderboard then
            for _, child in pairs(leaderboard:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") then
                    if child.Text == originalName then
                        child.Text = fakeName
                    end
                end
            end
        end
    end)
    -- Technique 5: Overhead name removal
    pcall(function()
        -- Remove overhead name display
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
            for _, gui in pairs(LocalPlayer.Character.Head:GetChildren()) do
                if gui:IsA("BillboardGui") or gui:IsA("SurfaceGui") then
                    gui.Enabled = false
                end
            end
        end
    end)
    -- Notify success
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Username Hidden",
        Text = "Your username is now hidden as: " .. fakeName,
        Duration = 5,
    })
end
-- Execute hiding
if hideUsername then
    advancedUsernameHiding()
end
]]
scripts["general/infinitejump.lua"] = [[
--[[
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
--]]
_G.infinjump = not _G.infinjump
local plr = game:GetService'Players'.LocalPlayer
local m = plr:GetMouse()
m.KeyDown:connect(function(k)
    if _G.infinjump then
        if k:byte() == 32 then
        plrh = game:GetService'Players'.LocalPlayer.Character:FindFirstChildOfClass'Humanoid'
        plrh:ChangeState('Jumping')
        wait()
        plrh:ChangeState('Seated')
        end
    end
end)
]]
scripts["general/invisible.lua"] = [[
-- INVISIBLE Script
-- Makes the local player invisible for all players (R6 & R15)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
-- Hide all character parts
for _, part in pairs(char:GetDescendants()) do
    if part:IsA("BasePart") then
        part.Transparency = 1
        if part:FindFirstChildOfClass("Decal") then
            for _, d in pairs(part:GetChildren()) do
                if d:IsA("Decal") then d.Transparency = 1 end
            end
        end
        if part.Name == "Head" then
            local face = part:FindFirstChild("face")
            if face then face.Transparency = 1 end
        end
    elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
        part.Handle.Transparency = 1
    end
end
-- Hide name (overhead GUI)
local head = char:FindFirstChild("Head")
if head then
    for _, gui in pairs(head:GetChildren()) do
        if gui:IsA("BillboardGui") or gui:IsA("SurfaceGui") then
            gui.Enabled = false
        end
    end
end
-- Optionally: Remove face
local face = head and head:FindFirstChild("face")
if face then face.Transparency = 1 end
-- Optionally: Remove body colors
local bc = char:FindFirstChildOfClass("BodyColors")
if bc then bc:Destroy() end
-- Optionally: Remove shirts/pants
for _, v in pairs(char:GetChildren()) do
    if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
        v:Destroy()
    end
end
-- Notification
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "🫥 Invisible",
        Text = "You are now invisible!",
        Duration = 6,
    })
end)
]]
scripts["general/itemduplicator.lua"] = [[
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
-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 40)
statusLabel.Position = UDim2.new(0, 10, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "No item equipped. Equip an item to duplicate."
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
statusLabel.TextSize = 14
statusLabel.TextWrap = true
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Parent = frame
-- Duplicate Button
local duplicateButton = Instance.new("TextButton")
duplicateButton.Name = "DuplicateButton"
duplicateButton.Size = UDim2.new(0.8, 0, 0, 40)
duplicateButton.Position = UDim2.new(0.1, 0, 0, 90)
duplicateButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
duplicateButton.BorderSizePixel = 0
duplicateButton.Text = "Duplicate Item"
duplicateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
duplicateButton.TextSize = 18
duplicateButton.Font = Enum.Font.SourceSansBold
duplicateButton.Parent = frame
-- Add button corner
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = duplicateButton
-- Add button gradient
local buttonGradient = Instance.new("UIGradient")
buttonGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 200))
})
buttonGradient.Parent = duplicateButton
-- Button functionality
duplicateButton.MouseButton1Click:Connect(function()
    if currentEquippedItem then
        -- Send request to server to duplicate item
        pcall(function()
            remoteEvent:FireServer(currentEquippedItem)
            statusLabel.Text = "Duplicating item: " .. currentEquippedItem.Name
            statusLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
        end)
    else
        statusLabel.Text = "Error: No item equipped to duplicate!"
        statusLabel.TextColor3 = Color3.fromRGB(200, 100, 100)
    end
end)
-- Monitor equipped items
local function checkEquippedItem()
    local character = LocalPlayer.Character
    if character then
        for _, child in pairs(character:GetChildren()) do
            if child:IsA("Tool") then
                if currentEquippedItem ~= child then
                    currentEquippedItem = child
                    statusLabel.Text = "Item equipped: " .. child.Name
                    statusLabel.TextColor3 = Color3.fromRGB(100, 200, 200)
                end
                return
            end
        end
    end
    currentEquippedItem = nil
    statusLabel.Text = "No item equipped. Equip an item to duplicate."
    statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
end
-- Connect character changes
LocalPlayer.CharacterAdded:Connect(function()
    wait(1) -- Wait for character to fully load
    checkEquippedItem()
end)
if LocalPlayer.Character then
    checkEquippedItem()
end
-- Periodically check equipped item
while wait(1) do
    checkEquippedItem()
end
]]

-- Create Neon Gradient GUI
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NeonScriptHub"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

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
