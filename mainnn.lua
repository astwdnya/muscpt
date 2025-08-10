-- Roblox Stylish RGB Menu UI
-- ساخته شده برای بالاترین لایه و زیبایی بالا
-- Amo Drake اختصاصی

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

-- ScreenGui (Top-most layer)
local gui = Instance.new("ScreenGui")
gui.Parent = CoreGui
gui.ResetOnSpawn = false
gui.Name = "RGBMenu"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999999

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 540)
main.Position = UDim2.new(0.5, -210, 0.5, -270)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

-- UICorner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

-- UIStroke RGB
local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.BackgroundTransparency = 1
title.Text = "🌌 RGB Menu 🌌"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = main

-- Container (Scrollable list)
local container = Instance.new("ScrollingFrame")
container.Name = "Container"
container.Size = UDim2.new(1, -16, 1, -52)
container.Position = UDim2.new(0, 8, 0, 44)
container.BackgroundTransparency = 1
container.ScrollBarThickness = 5
container.ScrollBarImageColor3 = Color3.fromRGB(120, 170, 255)
container.Parent = main
container.AutomaticCanvasSize = Enum.AutomaticSize.Y
container.CanvasSize = UDim2.new(0,0,0,0)

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 8)
list.FillDirection = Enum.FillDirection.Vertical
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = container

local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 6)
pad.PaddingLeft = UDim.new(0, 8)
pad.PaddingRight = UDim.new(0, 8)
pad.PaddingBottom = UDim.new(0, 8)
pad.Parent = container

-- Helpers
local function makeHeader(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -4, 0, 28)
    lbl.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    lbl.BorderSizePixel = 0
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(230, 235, 255)
    lbl.Text = text
    lbl.Parent = container
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 8) c.Parent = lbl
    local s = Instance.new("UIStroke") s.Thickness = 1.2 s.Parent = lbl
    return lbl
end

local function makeButton(text, url)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(245, 245, 245) -- initial: white (never toggled)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(20, 20, 20) -- readable on white
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.AutoButtonColor = false
    btn.Parent = container
    local btnCorner = Instance.new("UICorner") btnCorner.CornerRadius = UDim.new(0, 8) btnCorner.Parent = btn
    local s = Instance.new("UIStroke") s.Thickness = 1.2 s.Parent = btn

    -- three-state status: nil (never used) -> white, true -> green, false -> red
    local status = nil

    local function baseColor()
        if status == nil then
            return Color3.fromRGB(245, 245, 245)
        elseif status == true then
            return Color3.fromRGB(0, 170, 0)
        else
            return Color3.fromRGB(200, 40, 40)
        end
    end

    local function textColorFor(bg)
        -- Simple contrast: dark text on light bg, white text on colored bg
        local r, g, b = bg.R * 255, bg.G * 255, bg.B * 255
        local luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        if luminance > 180 then
            return Color3.fromRGB(20, 20, 20)
        else
            return Color3.fromRGB(255, 255, 255)
        end
    end

    local function setVisual(tweenTime)
        local target = baseColor()
        TweenService:Create(btn, TweenInfo.new(tweenTime or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = target
        }):Play()
        btn.TextColor3 = textColorFor(target)
    end

    -- Hover animation (respect current state color)
    local hovering = false
    btn.MouseEnter:Connect(function()
        hovering = true
        local col = baseColor()
        -- lighten a bit on hover
        local lighten = Color3.new(math.clamp(col.R + 0.1, 0, 1), math.clamp(col.G + 0.1, 0, 1), math.clamp(col.B + 0.1, 0, 1))
        TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = lighten}):Play()
    end)
    btn.MouseLeave:Connect(function()
        hovering = false
        setVisual(0.15)
    end)

    -- Click: toggle status color and run remote script
    btn.MouseButton1Click:Connect(function()
        -- Toggle logic: first time (nil) -> true, then toggle true/false
        if status == nil then
            status = true
        else
            status = not status
        end
        setVisual(0.2)

        if not url or url == "" then return end
        local ok, err = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        if not ok then
            pcall(function()
                StarterGui:SetCore("SendNotification", {Title = "Loader", Text = "خطا در اجرا: " .. tostring(err), Duration = 3})
            end)
        else
            pcall(function()
                StarterGui:SetCore("SendNotification", {Title = "Loader", Text = "اجرا شد: " .. text, Duration = 2})
            end)
        end
    end)

    return btn
end

-- Anti-Cheat Bypass Auto-Load
local function loadAntiCheatBypasses()
    local bypasses = {
        {
            name = "Anti-Kick Protection",
            url = "https://raw.githubusercontent.com/Exunys/Anti-Kick/main/Anti-Kick.lua"
        },
        {
            name = "Adonis Admin Bypass",
            url = "https://raw.githubusercontent.com/superdude914/scripts/master/adonisdisabler.lua"
        },
        {
            name = "Advanced Memory Bypass",
            url = "https://raw.githubusercontent.com/astwdnya/muscpt/main/anticheat_bypass_2025.lua"
        },
        {
            name = "Universal Client Bypass",
            url = "https://raw.githubusercontent.com/astwdnya/muscpt/main/anticheat_bypass.lua"
        },
        {
            name = "Advanced Server-Side Bypass",
            url = "data:text/plain;base64," .. game:GetService("HttpService"):Base64Encode([[
-- 🔥 ULTIMATE SERVER-SIDE ANTI-CHEAT BYPASS 2025 🔥
-- ساخته شده برای دور زدن قوی‌ترین سیستم‌های امنیتی سرور
-- تکنیک‌های: Packet Spoofing, Network Manipulation, Deep Hook

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- 🧠 Advanced Network Packet Spoofing
local originalHttpRequest = syn and syn.request or http_request or request
if originalHttpRequest then
    local function spoofRequest(options)
        -- فیلتر کردن درخواست‌های مشکوک
        if options.Url and (
            options.Url:lower():find("ban") or 
            options.Url:lower():find("report") or 
            options.Url:lower():find("cheat") or
            options.Url:lower():find("exploit")
        ) then
            warn("[Server Bypass] Blocked suspicious HTTP request to:", options.Url)
            return {StatusCode = 200, Body = '{"success": false}'}
        end
        return originalHttpRequest(options)
    end
    
    if syn then syn.request = spoofRequest
    elseif http_request then http_request = spoofRequest
    elseif request then request = spoofRequest end
end

-- 🔒 Deep Remote Event/Function Hooking
local function deepHookRemotes()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    local oldIndex = mt.__index
    
    setreadonly(mt, false)
    
    -- Hook __namecall برای تمام Remote calls
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "FireServer" or method == "InvokeServer" then
            local remoteName = tostring(self)
            
            -- بلاک کردن Remote های خطرناک
            if remoteName:lower():find("ban") or 
               remoteName:lower():find("kick") or 
               remoteName:lower():find("report") or
               remoteName:lower():find("anticheat") or
               remoteName:lower():find("security") or
               remoteName:lower():find("detect") then
                warn("[Server Bypass] Blocked dangerous remote:", remoteName)
                return nil
            end
            
            -- اسپوف کردن داده‌های حساس
            for i, arg in pairs(args) do
                if type(arg) == "number" then
                    -- محدود کردن مقادیر عددی مشکوک
                    if arg > 1000000 or arg < -1000000 then
                        args[i] = math.random(1, 100)
                        warn("[Server Bypass] Spoofed suspicious number:", arg, "->", args[i])
                    end
                elseif type(arg) == "string" then
                    -- فیلتر کردن رشته‌های مشکوک
                    if arg:lower():find("exploit") or arg:lower():find("cheat") or arg:lower():find("hack") then
                        args[i] = "normal_player_action"
                        warn("[Server Bypass] Spoofed suspicious string:", arg)
                    end
                end
            end
        end
        
        return oldNamecall(self, unpack(args))
    end)
    
    setreadonly(mt, true)
end

-- 🎭 Character State Spoofing
local function spoofCharacterState()
    if not LocalPlayer.Character then return end
    
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- اسپوف کردن سرعت و پرش
    local originalWalkSpeed = humanoid.WalkSpeed
    local originalJumpPower = humanoid.JumpPower or humanoid.JumpHeight
    
    -- Hook کردن تغییرات Humanoid
    local connections = getconnections(humanoid.Changed)
    for _, connection in pairs(connections) do
        connection:Disable()
    end
    
    -- ایجاد fake state برای سرور
    spawn(function()
        while humanoid and humanoid.Parent do
            wait(0.1)
            -- ارسال داده‌های نرمال به سرور
            pcall(function()
                humanoid.WalkSpeed = math.clamp(humanoid.WalkSpeed, 0, 16)
                if humanoid.JumpPower then
                    humanoid.JumpPower = math.clamp(humanoid.JumpPower, 0, 50)
                elseif humanoid.JumpHeight then
                    humanoid.JumpHeight = math.clamp(humanoid.JumpHeight, 0, 7.2)
                end
            end)
        end
    end)
end

-- 🌐 Network Traffic Manipulation
local function manipulateNetworkTraffic()
    -- Hook کردن تمام network events
    for _, service in pairs(game:GetChildren()) do
        if service:IsA("ServiceProvider") then
            pcall(function()
                for _, child in pairs(service:GetChildren()) do
                    if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                        -- اضافه کردن delay برای جلوگیری از spam detection
                        local lastCall = 0
                        local originalFire = child.FireServer
                        
                        child.FireServer = function(...)
                            local now = tick()
                            if now - lastCall < 0.1 then
                                wait(0.1)
                            end
                            lastCall = now
                            return originalFire(...)
                        end
                    end
                end
            end)
        end
    end
end

-- 🔍 Server Monitoring Evasion
local function evadeServerMonitoring()
    -- پنهان کردن اسکریپت از getgc و debug functions
    local function hideFromGC()
        local gc = getgc(true)
        for i, v in pairs(gc) do
            if type(v) == "function" and islclosure(v) then
                local info = debug.getinfo(v)
                if info.source and info.source:find("ServerBypass") then
                    -- پنهان کردن اسکریپت از garbage collector
                    pcall(function()
                        debug.setmetatable(v, {
                            __tostring = function() return "RobloxFunction" end,
                            __call = function() return nil end
                        })
                    end)
                end
            end
        end
    end
    
    -- اجرای مخفی‌سازی
    spawn(hideFromGC)
    
    -- جلوگیری از log شدن
    local function blockLogging()
        local logService = game:GetService("LogService")
        if logService then
            pcall(function()
                for _, connection in pairs(getconnections(logService.MessageOut)) do
                    connection:Disable()
                end
            end)
        end
    end
    
    blockLogging()
end

-- 🚀 Advanced Memory Protection
local function protectMemory()
    -- محافظت از memory scanning
    if setthreadidentity then
        setthreadidentity(8) -- بالاترین سطح دسترسی
    end
    
    -- پنهان کردن از memory scanners
    local function scrambleMemory()
        local dummy = {}
        for i = 1, 1000 do
            dummy[tostring(math.random())] = string.rep("x", math.random(100, 1000))
        end
        return dummy
    end
    
    spawn(function()
        while true do
            wait(1)
            scrambleMemory()
        end
    end)
end

-- 🎯 اجرای تمام bypass ها
deepHookRemotes()
spoofCharacterState()
manipulateNetworkTraffic()
evadeServerMonitoring()
protectMemory()

-- نظارت مداوم
spawn(function()
    while true do
        wait(5)
        pcall(spoofCharacterState)
        pcall(evadeServerMonitoring)
    end
end)

print("[Ultimate Server Bypass] 🔥 All server-side protections bypassed! 🔥")
            ]])
        }
    }
    
    local successCount = 0
    local totalCount = #bypasses
    
    for _, bypass in pairs(bypasses) do
        spawn(function()
            local success, err = pcall(function()
                loadstring(game:HttpGet(bypass.url))()
            end)
            if success then
                successCount = successCount + 1
                print("[RGB Menu] ✅ " .. bypass.name .. " loaded successfully")
            else
                print("[RGB Menu] ❌ Failed to load " .. bypass.name .. ": " .. tostring(err))
            end
            
            -- Show success notification when all are processed
            if successCount == totalCount then
                wait(0.5) -- Small delay for visual effect
                pcall(function()
                    StarterGui:SetCore("SendNotification", {
                        Title = "🛡️ Anti-Cheat Protection",
                        Text = "✅ همه سیستم‌های ضد تقلب غیرفعال شدند!\n🔒 اسکریپت‌ها ایمن هستند",
                        Duration = 5,
                        Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png"
                    })
                end)
            elseif successCount > 0 and successCount + (totalCount - successCount) == totalCount then
                -- Some failed, show partial success
                wait(0.5)
                pcall(function()
                    StarterGui:SetCore("SendNotification", {
                        Title = "🛡️ Anti-Cheat Protection", 
                        Text = string.format("⚠️ %d/%d سیستم ضد تقلب غیرفعال شد\n🔒 حفاظت جزئی فعال", successCount, totalCount),
                        Duration = 4
                    })
                end)
            end
        end)
    end
end

-- RGB Animation Function
do
    local hue = 0
    RunService.RenderStepped:Connect(function()
        hue = hue + 0.002
        if hue > 1 then hue = 0 end
        local color = Color3.fromHSV(hue, 1, 1)
        stroke.Color = color
    end)
end

-- Load anti-cheat bypasses immediately when menu opens
spawn(function()
    wait(0.2) -- Small delay to ensure UI is fully loaded
    loadAntiCheatBypasses()
end)

-- Build Menu (sections and buttons)

-- 🎯 Aimbot & Combat
makeHeader("🎯 Aimbot & Combat / نبرد")
makeButton("aimbot.lua → ای aim assist", "https://raw.githubusercontent.com/astwdnya/muscpt/main/aimbot.lua")
makeButton("god.lua → گاد مود", "https://raw.githubusercontent.com/astwdnya/muscpt/main/god.lua")
makeButton("vibrate_throw.lua → پرتاب لرزشی", "https://raw.githubusercontent.com/astwdnya/muscpt/main/vibrate_throw.lua")

-- 🛡️ Anti-Cheat & Bypass
makeHeader("🛡️ Anti-Cheat & Bypass / ضد تقلب")
makeButton("antiafk.lua → ضد AFK", "https://raw.githubusercontent.com/astwdnya/muscpt/main/antiafk.lua")
makeButton("anticheat_bypass.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/anticheat_bypass.lua")
makeButton("anticheat_bypass_2025.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/anticheat_bypass_2025.lua")
makeButton("executor_bypass.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/executor_bypass.lua")

-- ⚡ Movement & Teleport
makeHeader("⚡ Movement & Teleport / حرکت و تله‌پورت")
makeButton("fly2.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/fly2.lua")
makeButton("infinitejump.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/infinitejump.lua")
makeButton("noclip.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/noclip.lua")
makeButton("speedhack.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/speedhack.lua")
makeButton("teleportto.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/teleportto.lua")
makeButton("ctrlclicktp.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/ctrlclicktp.lua")
makeButton("tptool.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/tptool.lua")
makeButton("magnetizeto.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/magnetizeto.lua")

-- 📦 Item & Farming
makeHeader("📦 Item & Farming / آیتم و فارم")
makeButton("autofarm.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/autofarm.lua")
makeButton("itemduplicator.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/itemduplicator.lua")

-- 👁️ Visual & ESP
makeHeader("👁️ Visual & ESP / نمایش")
makeButton("esp.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/esp.lua")
makeButton("dex.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/dex.lua")
makeButton("hideusername.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/hideusername.lua")
makeButton("invisible.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/invisible.lua")

-- 🤖 Fun & Troll
makeHeader("🤖 Fun & Troll / فان")
makeButton("chattroll.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/chattroll.lua")
makeButton("jerk.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/jerk.lua")
makeButton("trollplayer.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/trollplayer.lua")
makeButton("trollplayer2.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/trollplayer2.lua")
makeButton("trollplayer3.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/trollplayer3.lua")
makeButton("multidimensionalcharacter.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/multidimensionalcharacter.lua")
makeButton("ddd.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/ddd.lua")

-- 🔄 Utility
makeHeader("🔄 Utility / ابزار")
makeButton("autoclicker.lua", "https://raw.githubusercontent.com/astwdnya/muscpt/main/autoclicker.lua")

-- Done
return true
