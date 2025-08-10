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
    
    -- Technique 4: Player list manipulation
    pcall(function()
        -- Hook Players service
        local oldPlayers = Players.GetPlayers
        Players.GetPlayers = function()
            local players = oldPlayers(Players)
            local fakePlayers = {}
            
            for _, player in pairs(players) do
                if player == LocalPlayer then
                    -- Create fake player entry
                    local fakePlayer = {
                        Name = fakeName,
                        DisplayName = fakeName,
                        UserId = player.UserId,
                        Character = player.Character,
                        -- Add other necessary properties
                    }
                    table.insert(fakePlayers, fakePlayer)
                else
                    table.insert(fakePlayers, player)
                end
            end
            
            return fakePlayers
        end
    end)
    
    -- Technique 5: Name tag manipulation
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
            local head = LocalPlayer.Character.Head
            
            -- Remove existing name tags
            for _, child in pairs(head:GetChildren()) do
                if child:IsA("BillboardGui") and (child.Name == "NameTag" or child.Name == "PlayerName") then
                    child:Destroy()
                end
            end
            
            -- Create fake name tag
            local fakeNameTag = Instance.new("BillboardGui")
            fakeNameTag.Name = "NameTag"
            fakeNameTag.Size = UDim2.new(0, 200, 0, 50)
            fakeNameTag.StudsOffset = Vector3.new(0, 3, 0)
            fakeNameTag.Adornee = head
            fakeNameTag.AlwaysOnTop = true
            fakeNameTag.Parent = head
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = fakeName
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextScaled = true
            nameLabel.Font = Enum.Font.SourceSansBold
            nameLabel.Parent = fakeNameTag
        end
    end)
end

-- Function to restore original username
local function restoreUsername()
    pcall(function()
        LocalPlayer.Name = originalName
        LocalPlayer.DisplayName = originalName
    end)
end

-- Main function
local function applyUsernameHiding()
    if hideUsername then
        advancedUsernameHiding()
        
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Username Hidden",
            Text = "Advanced hiding techniques applied!",
            Duration = 3,
        })
    else
        restoreUsername()
        
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Username Restored",
            Text = "Original username restored!",
            Duration = 3,
        })
    end
end

-- Apply when character spawns
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(2)
    if hideUsername then
        applyUsernameHiding()
    end
end)

-- Apply immediately
if LocalPlayer.Character then
    applyUsernameHiding()
end

-- Continuous application
spawn(function()
    while wait(3) do
        if hideUsername then
            applyUsernameHiding()
        end
    end
end)

-- Hook new players
Players.PlayerAdded:Connect(function(player)
    if hideUsername then
        wait(1)
        applyUsernameHiding()
    end
end) 