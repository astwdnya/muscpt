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