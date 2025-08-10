-- ESP (Extra Sensory Perception) functionality extracted from Infinite Yield FE v6.3.2

-- Required services
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local workspace = game:GetService("Workspace")

-- ESP variables
local ESPObjects = {}
local ESPEnabled = false
local ESPTeam = false
local ESPName = false
local ESPBox = false
local ESPTracer = false
local ESPDistance = false

-- Utility function to generate random string (used for GUI element names)
local function randomString()
    local length = math.random(10, 20)
    local array = {}
    for i = 1, length do
        array[i] = string.char(math.random(32, 126))
    end
    return table.concat(array)
end

-- Function to create ESP elements for a player's head
function CreateESP(part)
    local ESP = Instance.new("BillboardGui")
    ESP.Name = randomString()
    ESP.Parent = part
    ESP.Adornee = part
    ESP.Size = UDim2.new(0, 100, 0, 100)
    ESP.StudsOffset = Vector3.new(0, part.Size.Y / 1.5 + 2, 0)
    ESP.AlwaysOnTop = true
    ESP.Enabled = false
    
    local Frame = Instance.new("Frame")
    Frame.Parent = ESP
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1
    
    local Name = Instance.new("TextLabel")
    Name.Name = "Name"
    Name.Parent = Frame
    Name.Size = UDim2.new(1, 0, 0, 30)
    Name.BackgroundTransparency = 1
    Name.TextColor3 = Color3.new(1, 1, 1)
    Name.TextStrokeTransparency = 0
    Name.TextStrokeColor3 = Color3.new(0, 0, 0)
    Name.TextSize = 14
    Name.Font = Enum.Font.SourceSans
    Name.Text = part.Parent.Name
    
    local Distance = Instance.new("TextLabel")
    Distance.Name = "Distance"
    Distance.Parent = Frame
    Distance.Position = UDim2.new(0, 0, 0, 30)
    Distance.Size = UDim2.new(1, 0, 0, 30)
    Distance.BackgroundTransparency = 1
    Distance.TextColor3 = Color3.new(1, 1, 1)
    Distance.TextStrokeTransparency = 0
    Distance.TextStrokeColor3 = Color3.new(0, 0, 0)
    Distance.TextSize = 14
    Distance.Font = Enum.Font.SourceSans
    Distance.Text = ""
    
    local Box = Instance.new("BoxHandleAdornment")
    Box.Name = randomString()
    Box.Parent = part
    Box.Adornee = part
    Box.Size = part.Size + Vector3.new(0.5, 0.5, 0.5)
    Box.Color3 = Color3.new(1, 1, 1)
    Box.Transparency = 0.5
    Box.AlwaysOnTop = true
    Box.Visible = false
    Box.ZIndex = 10
    
    local Tracer = Instance.new("LineHandleAdornment")
    Tracer.Name = randomString()
    Tracer.Parent = part
    Tracer.Adornee = part
    Tracer.Length = 10
    Tracer.Thickness = 1
    Tracer.Color3 = Color3.new(1, 1, 1)
    Tracer.Transparency = 0.5
    Tracer.Visible = false
    
    ESPObjects[part.Parent] = {ESP = ESP, Box = Box, Tracer = Tracer}
end

-- Function to manage ESP for a specific player
function ESP(plr)
    if plr.Character and plr ~= Players.LocalPlayer and plr.Character:FindFirstChild("Head") then
        local Head = plr.Character:FindFirstChild("Head")
        CreateESP(Head)
        local ESP = ESPObjects[plr]
        if ESP then
            local Name = ESP.ESP:FindFirstChild("Frame"):FindFirstChild("Name")
            local Distance = ESP.ESP:FindFirstChild("Frame"):FindFirstChild("Distance")
            local Box = ESP.Box
            local Tracer = ESP.Tracer
            local update
            update = RunService.RenderStepped:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") then
                    local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(plr.Character:FindFirstChild("Head").Position)
                    local teamCheck = ESPTeam and (Players.LocalPlayer.Team == plr.Team)
                    ESP.ESP.Enabled = ESPEnabled and onScreen and not teamCheck
                    Name.Visible = ESPName and ESPEnabled and onScreen and not teamCheck
                    Distance.Visible = ESPDistance and ESPEnabled and onScreen and not teamCheck
                    Box.Visible = ESPBox and ESPEnabled and onScreen and not teamCheck
                    Tracer.Visible = ESPTracer and ESPEnabled and onScreen and not teamCheck
                    if ESPDistance and onScreen then
                        local dist = (Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Head") and 
                                     (Players.LocalPlayer.Character:FindFirstChild("Head").Position - plr.Character:FindFirstChild("Head").Position).magnitude) or 0
                        Distance.Text = math.floor(dist + 0.5) .. " studs"
                    end
                    if Tracer.Visible then
                        local screenPos = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                        local startPos = workspace.CurrentCamera:WorldToScreenPoint(plr.Character:FindFirstChild("Head").Position)
                        local diff = screenPos - Vector2.new(startPos.X, startPos.Y)
                        Tracer.Length = diff.Magnitude / 10
                        Tracer.CFrame = CFrame.new(Vector3.new(0, 0, 0), Vector3.new(diff.X, diff.Y, 0))
                    end
                else
                    ESP.ESP.Enabled = false
                    Name.Visible = false
                    Distance.Visible = false
                    Box.Visible = false
                    Tracer.Visible = false
                end
                if not plr.Parent then
                    update:Disconnect()
                    ESP.ESP:Destroy()
                    ESP.Box:Destroy()
                    ESP.Tracer:Destroy()
                    ESPObjects[plr] = nil
                end
            end)
        end
    end
end

-- Notification function (minimal version for ESP feedback)
local function notify(title, text)
    print(string.format("%s: %s", title, text))
    -- Note: Original script uses a GUI notification system, simplified here to console output
end

-- Command definitions
local function addcmd(name, aliases, func)
    -- Simplified command handler (not using full Infinite Yield command system)
    _G.commands = _G.commands or {}
    _G.commands[name] = {NAME = name, ALIAS = aliases, FUNC = func}
end

addcmd('esp', {}, function(args, speaker)
    ESPEnabled = true
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer then
            ESP(plr)
        end
    end
    notify("ESP", "Enabled")
end)

addcmd('unesp', {'noesp'}, function(args, speaker)
    ESPEnabled = false
    for _, ESP in pairs(ESPObjects) do
        ESP.ESP.Enabled = false
        ESP.ESP:FindFirstChild("Frame"):FindFirstChild("Name").Visible = false
        ESP.ESP:FindFirstChild("Frame"):FindFirstChild("Distance").Visible = false
        ESP.Box.Visible = false
        ESP.Tracer.Visible = false
    end
    notify("ESP", "Disabled")
end)

addcmd('espteam', {'espteams'}, function(args, speaker)
    ESPTeam = not ESPTeam
    notify("ESP Team", ESPTeam and "Enabled" or "Disabled")
end)

addcmd('espname', {'espnames'}, function(args, speaker)
    ESPName = not ESPName
    notify("ESP Names", ESPName and "Enabled" or "Disabled")
end)

addcmd('espbox', {'espboxes'}, function(args, speaker)
    ESPBox = not ESPBox
    notify("ESP Boxes", ESPBox and "Enabled" or "Disabled")
end)

addcmd('esptracer', {'esptracers'}, function(args, speaker)
    ESPTracer = not ESPTracer
    notify("ESP Tracers", ESPTracer and "Enabled" or "Disabled")
end)

addcmd('espdistance', {}, function(args, speaker)
    ESPDistance = not ESPDistance
    notify("ESP Distance", ESPDistance and "Enabled" or "Disabled")
end)

-- Hook for new players
Players.PlayerAdded:Connect(function(plr)
    if ESPEnabled then
        repeat wait(1) until plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        ESP(plr)
    end
end)

-- Initialize ESP for existing players
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= Players.LocalPlayer and ESPEnabled then
        ESP(plr)
    end
end
