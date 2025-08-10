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

-- Flying movement loop
local function updateFlying()
    if not isFlying or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
    
    if not bodyVelocity or not bodyVelocity.Parent then
        return
    end
    
    local moveVector = Vector3.new(0, 0, 0)
    local cameraCFrame = Camera.CFrame
    
    -- Get input
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveVector = moveVector + cameraCFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveVector = moveVector - cameraCFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveVector = moveVector - cameraCFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveVector = moveVector + cameraCFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        moveVector = moveVector + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        moveVector = moveVector + Vector3.new(0, -1, 0)
    end
    
    -- Normalize and apply speed
    if moveVector.Magnitude > 0 then
        moveVector = moveVector.Unit * (flySpeed * flySpeedMultiplier)
    end
    
    -- Apply movement
    bodyVelocity.Velocity = moveVector
    
    -- Update rotation to follow camera
    if bodyGyro and bodyGyro.Parent then
        bodyGyro.CFrame = cameraCFrame
    end
end

-- Connect flying update to RunService
local flyingConnection = nil

local function startFlyingLoop()
    if flyingConnection then
        flyingConnection:Disconnect()
    end
    
    flyingConnection = RunService.Heartbeat:Connect(updateFlying)
end

local function stopFlyingLoop()
    if flyingConnection then
        flyingConnection:Disconnect()
        flyingConnection = nil
    end
end

-- Input handler
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.CapsLock then
        toggleFlying()
        
        if isFlying then
            startFlyingLoop()
        else
            stopFlyingLoop()
        end
    elseif input.KeyCode == Enum.KeyCode.RightBracket then
        -- Increase speed
        flySpeedMultiplier = math.min(flySpeedMultiplier + 0.5, 3)
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Speed Increased",
            Text = "Fly Speed: " .. math.floor(flySpeed * flySpeedMultiplier),
            Duration = 2,
        })
    elseif input.KeyCode == Enum.KeyCode.LeftBracket then
        -- Decrease speed
        flySpeedMultiplier = math.max(flySpeedMultiplier - 0.5, 0.5)
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Speed Decreased",
            Text = "Fly Speed: " .. math.floor(flySpeed * flySpeedMultiplier),
            Duration = 2,
        })
    end
end)

-- Cleanup when character respawns
LocalPlayer.CharacterAdded:Connect(function(character)
    isFlying = false
    stopFlyingLoop()
    
    -- Clean up any remaining components
    wait(1)
    if character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = character.HumanoidRootPart
        
        for _, child in pairs(humanoidRootPart:GetChildren()) do
            if child:IsA("BodyVelocity") or child:IsA("BodyGyro") then
                child:Destroy()
            end
        end
    end
end)

-- Cleanup when script stops
game:BindToClose(function()
    stopFlyingLoop()
    if bodyVelocity then
        bodyVelocity:Destroy()
    end
    if bodyGyro then
        bodyGyro:Destroy()
    end
end) 