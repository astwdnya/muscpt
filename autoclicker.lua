-- Auto Clicker Script
-- Hold F to auto-click

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Auto Clicker",
    Text = "Hold F to auto-click!",
    Duration = 6,
})

-- Services
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- Configuration
local autoClicking = false
local clickSpeed = 0.1 -- Clicks per second

-- Function to perform click
local function performClick()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new())
end

-- Input handler
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        autoClicking = true
        
        -- Start auto-clicking
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