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
