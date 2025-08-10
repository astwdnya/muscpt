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
        -- Check if item is collectible (you can customize this based on the game)
        if item:IsA("Part") and item.Name:lower():find("coin") or 
           item.Name:lower():find("gem") or 
           item.Name:lower():find("item") or
           item.Name:lower():find("collect") then
            
            local distance = (HumanoidRootPart.Position - item.Position).Magnitude
            
            if distance <= collectionRadius then
                -- Try to collect the item
                firetouchinterest(HumanoidRootPart, item, 0)
                firetouchinterest(HumanoidRootPart, item, 1)
                
                -- Remove the item
                item:Destroy()
            end
        end
    end
end

-- Main loop
while autoCollect and wait(1) do
    collectNearbyItems()
end 