--[[local Plr = game:GetService("Players").LocalPlayer
local Mouse = Plr:GetMouse()
 
Mouse.Button1Down:connect(function()
if not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then return end
if not Mouse.Target then return end
Plr.Character:MoveTo(Mouse.Hit.p)
end)
--]]

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
        
        -- Find safe teleport position
        local final_position = FindSafePosition(hitPoint, hitObject)
        
        -- Additional check for clicking underneath objects
        if auto_above then
            local underneathPosition = IsClickingUnderneath(hitPoint)
            if underneathPosition then
                final_position = underneathPosition
            end
        end
        
        if instant_teleport then
            -- Instant teleport (fastest)
            hm.CFrame = CFrame.new(final_position)
        else
            -- Tween teleport (slower but smoother)
            local ts = game:GetService("TweenService")
            local dist = (hm.Position - final_position).magnitude
            local tweenspeed = dist/tonumber(speed)
            local ti = TweenInfo.new(tonumber(tweenspeed), Enum.EasingStyle.Linear)
            local tp = {CFrame = CFrame.new(final_position)}
            ts:Create(hm, ti, tp):Play()
            
            if bodyvelocityenabled == true then
                local bv = Instance.new("BodyVelocity")
                bv.Parent = hm
                bv.MaxForce = Vector3.new(100000,100000,100000)
                bv.Velocity = Vector3.new(0,0,0)
                wait(tonumber(tweenspeed))
                bv:Destroy()
            end
        end
    end
end

-- Input handler
Imput.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and Imput:IsKeyDown(Enum.KeyCode.LeftControl) then
        To(Mouse.Hit.p)
    end
end) 