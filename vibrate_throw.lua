-- Vibrate Noclip Script
-- ترکیب حرکت آزاد (noclip) و ویبره شدید در یک محدوده کوچک

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local root = char:FindFirstChild("HumanoidRootPart")
local humanoid = char:FindFirstChildOfClass("Humanoid")

if not root or not humanoid then
    warn("No HumanoidRootPart or Humanoid found!")
    return
end

-- تنظیمات
local vibratePower = 8 -- شدت ویبره (مقدار آفست)
local moveSpeed = 60 -- سرعت حرکت noclip
local running = true

-- وضعیت کلیدها
local moveDir = Vector3.new()
local up = false
local down = false

-- کنترل کیبورد
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then moveDir = moveDir + Vector3.new(0,0,-1) end
    if input.KeyCode == Enum.KeyCode.S then moveDir = moveDir + Vector3.new(0,0,1) end
    if input.KeyCode == Enum.KeyCode.A then moveDir = moveDir + Vector3.new(-1,0,0) end
    if input.KeyCode == Enum.KeyCode.D then moveDir = moveDir + Vector3.new(1,0,0) end
    if input.KeyCode == Enum.KeyCode.Space then up = true end
    if input.KeyCode == Enum.KeyCode.LeftShift then down = true end
end)
UserInputService.InputEnded:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then moveDir = moveDir - Vector3.new(0,0,-1) end
    if input.KeyCode == Enum.KeyCode.S then moveDir = moveDir - Vector3.new(0,0,1) end
    if input.KeyCode == Enum.KeyCode.A then moveDir = moveDir - Vector3.new(-1,0,0) end
    if input.KeyCode == Enum.KeyCode.D then moveDir = moveDir - Vector3.new(1,0,0) end
    if input.KeyCode == Enum.KeyCode.Space then up = false end
    if input.KeyCode == Enum.KeyCode.LeftShift then down = false end
end)

-- غیرفعال کردن کلاژن و گرانش
humanoid:ChangeState(Enum.HumanoidStateType.Physics)
root.CanCollide = false

-- حلقه اصلی: حرکت + ویبره
RunService.RenderStepped:Connect(function(dt)
    if not running then return end
    -- حرکت با کیبورد
    local camCF = workspace.CurrentCamera.CFrame
    local move = (camCF.RightVector * moveDir.X + camCF.LookVector * moveDir.Z)
    if up then move = move + Vector3.new(0,1,0) end
    if down then move = move + Vector3.new(0,-1,0) end
    if move.Magnitude > 0 then
        root.CFrame = root.CFrame + move.Unit * moveSpeed * dt
    end
    -- ویبره شدید در محدوده کوچک
    local vibrateOffset = Vector3.new(
        (math.random()-0.5)*2*vibratePower,
        (math.random()-0.5)*2*vibratePower,
        (math.random()-0.5)*2*vibratePower
    )
    root.CFrame = root.CFrame + vibrateOffset * dt
end)

-- توقف روی مرگ
humanoid.Died:Connect(function()
    running = false
end)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "💥 Vibrate Noclip",
        Text = "Move freely and vibrate with high power!",
        Duration = 6,
    })
end) 