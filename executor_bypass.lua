-- Executor Bypass Script - Fake Fluxus
-- این اسکریپت executor رو فیک می‌کنه تا اسکریپت‌ها فکر کنن از Fluxus استفاده می‌کنی

local function bypassExecutorCheck()
    -- فیک کردن نام executor
    if getexecutorname then
        local originalName = getexecutorname()
        getexecutorname = function() 
            return "Fluxus" 
        end
    end
    
    -- فیک کردن متغیرهای معمول executorها
    if not is_sirhurt_closure then
        is_sirhurt_closure = function() 
            return false 
        end
    end
    
    if not isvm then
        isvm = function() 
            return false 
        end
    end
    
    if not is_synapse_function then
        is_synapse_function = function() 
            return false 
        end
    end
    
    -- فیک کردن API های مختلف
    if not syn then
        syn = {}
        syn.request = http_request or request
        syn.crypt = {}
        syn.crypt.hash = function() return "" end
        syn.crypt.encrypt = function() return "" end
        syn.crypt.decrypt = function() return "" end
    end
    
    if not fluxus then
        fluxus = {}
        fluxus.request = http_request or request
        fluxus.crypt = {}
        fluxus.crypt.hash = function() return "" end
        fluxus.crypt.encrypt = function() return "" end
        fluxus.crypt.decrypt = function() return "" end
    end
    
    if not krnl then
        krnl = {}
        krnl.request = http_request or request
        krnl.crypt = {}
        krnl.crypt.hash = function() return "" end
        krnl.crypt.encrypt = function() return "" end
        krnl.crypt.decrypt = function() return "" end
    end
    
    -- فیک کردن Drawing API
    if not Drawing then
        Drawing = {}
        Drawing.new = function(type)
            local obj = {
                Visible = false,
                Color = Color3.fromRGB(255,255,255),
                Size = Vector2.new(0,0),
                Position = Vector2.new(0,0),
                Text = "",
                Thickness = 1,
                Transparency = 1,
                Filled = false,
                Center = false,
                Outline = false,
                Font = 1
            }
            
            if type == "Square" then
                obj.Size = Vector2.new(100,100)
            elseif type == "Text" then
                obj.Text = "Fake Text"
                obj.Size = 20
            elseif type == "Circle" then
                obj.Size = Vector2.new(50,50)
            elseif type == "Triangle" then
                obj.Size = Vector2.new(50,50)
            elseif type == "Image" then
                obj.Size = Vector2.new(100,100)
            end
            
            obj.Remove = function() end
            return obj
        end
    end
    
    -- فیک کردن متغیرهای اضافی
    if not PROTOSMASHER_LOADED then
        PROTOSMASHER_LOADED = false
    end
    
    if not SENTINEL_LOADED then
        SENTINEL_LOADED = false
    end
    
    if not KRNL_LOADED then
        KRNL_LOADED = false
    end
    
    if not FLUXUS_LOADED then
        FLUXUS_LOADED = true
    end
    
    -- فیک کردن متدهای اضافی
    if not getrawmetatable then
        getrawmetatable = function() return {} end
    end
    
    if not setreadonly then
        setreadonly = function() end
    end
    
    if not newcclosure then
        newcclosure = function(func) return func end
    end
    
    if not islclosure then
        islclosure = function() return false end
    end
    
    if not iscclosure then
        iscclosure = function() return true end
    end
    
    -- پیام موفقیت
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Executor Bypass",
        Text = "Fluxus فیک شد! حالا همه اسکریپت‌ها کار می‌کنن!",
        Duration = 5,
    })
end

-- اجرای بایپس
bypassExecutorCheck()

-- تابع برای اجرای مجدد در صورت نیاز
_G.ReapplyExecutorBypass = bypassExecutorCheck 