-- Anti-AFK Script
-- Prevents you from being kicked for inactivity

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Anti-AFK",
    Text = "Anti-AFK activated! You won't be kicked for inactivity.",
    Duration = 6,
})

-- Services
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Anti-AFK function
local function antiAFK()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end

-- Run anti-AFK every 30 seconds
while wait(30) do
    antiAFK()
end 