-- Arsenal Anti-Cheat Bypass Script
-- نابودگر آنتی‌چیت سگ‌طور مخصوص ARSENAL
-- نوشته شده توسط یه آدم خفن که از آنتی‌چیت متنفره!

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- نابود کردن LocalScriptهای آنتی‌چیت
for _, v in pairs(LocalPlayer.PlayerScripts:GetChildren()) do
    if v:IsA("LocalScript") and (v.Name:lower():find("anti") or v.Name:lower():find("cheat") or v.Name:lower():find("security") or v.Name:lower():find("handler")) then
        v.Disabled = true
        v:Destroy()
    end
end

-- نابود کردن آنتی‌چیت‌های داخل ReplicatedStorage
for _, v in pairs(ReplicatedStorage:GetChildren()) do
    if v:IsA("ModuleScript") and (v.Name:lower():find("anti") or v.Name:lower():find("cheat") or v.Name:lower():find("security")) then
        v:Destroy()
    end
end

-- هوک کردن RemoteEventهای حساس
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if tostring(self):lower():find("ban") or tostring(self):lower():find("kick") or tostring(self):lower():find("report") then
        -- بلاک کردن هرگونه تلاش برای بن یا کیک
        return nil
    end
    -- بلاک کردن Remoteهای مشکوک
    if tostring(self):lower():find("remote") or tostring(self):lower():find("event") then
        if method == "FireServer" or method == "InvokeServer" then
            -- اینجا می‌تونی پارامترها رو فیک بدی یا اصلاً ارسال نکنی
            -- return nil -- برای بلاک کامل
        end
    end
    return oldNamecall(self, unpack(args))
end)
setreadonly(mt, true)

-- نابود کردن هر اسکریپت مشکوک جدید که اضافه بشه
LocalPlayer.PlayerScripts.ChildAdded:Connect(function(child)
    if child:IsA("LocalScript") and (child.Name:lower():find("anti") or child.Name:lower():find("cheat") or child.Name:lower():find("security") or child.Name:lower():find("handler")) then
        child.Disabled = true
        child:Destroy()
    end
end)

-- پیام موفقیت
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Bypass",
    Text = "Anti-Cheat Arsenal ***گاییده شد***! حالا برو هرچی خواستی بزن!",
    Duration = 8
}) 