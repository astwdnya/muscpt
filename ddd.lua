-- Devon Loader UI Only
-- Extracted UI components for Devon Loader

if DL_LOADED and not _G.DL_DEBUG == true then
    return
end

pcall(function() getgenv().DL_LOADED = true end)
if not game:IsLoaded() then game.Loaded:Wait() end

-- Function and service definitions
function missing(t, f, fallback)
    if type(f) == t then return f end
    return fallback or nil
end

cloneref = missing("function", cloneref, function(...) return ... end)
sethidden = missing("function", sethiddenproperty or set_hidden_property or set_hidden_prop)
gethidden = missing("function", gethiddenproperty or get_hidden_property or get_hidden_prop)
queueteleport = missing("function", queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport))
httprequest = missing("function", request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request))
everyClipboard = missing("function", setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set))
firetouchinterest = missing("function", firetouchinterest)
waxwritefile, waxreadfile = writefile, readfile
writefile = missing("function", waxwritefile) and function(file, data, safe)
    if safe == true then return pcall(waxwritefile, file, data) end
    waxwritefile(file, data)
end
readfile = missing("function", waxreadfile) and function(file, safe)
    if safe == true then return pcall(waxreadfile, file) end
    return waxreadfile(file)
end
isfile = missing("function", isfile, readfile and function(file)
    local success, result = pcall(function()
        return readfile(file)
    end)
    return success and result ~= nil and result ~= ""
end)
makefolder = missing("function", makefolder)
isfolder = missing("function", isfolder)
waxgetcustomasset = missing("function", getcustomasset or getsynasset)
hookfunction = missing("function", hookfunction)
hookmetamethod = missing("function", hookmetamethod)
getnamecallmethod = missing("function", getnamecallmethod or get_namecall_method)
checkcaller = missing("function", checkcaller, function() return false end)
newcclosure = missing("function", newcclosure)
getgc = missing("function", getgc or get_gc_objects)
setthreadidentity = missing("function", setthreadidentity or (syn and syn.set_thread_identity) or syn_context_set or setthreadcontext)
replicatesignal = missing("function", replicatesignal)

COREGUI = cloneref(game:GetService("CoreGui"))
Players = cloneref(game:GetService("Players"))
UserInputService = cloneref(game:GetService("UserInputService"))
TweenService = cloneref(game:GetService("TweenService"))
HttpService = cloneref(game:GetService("HttpService"))
MarketplaceService = cloneref(game:GetService("MarketplaceService"))
RunService = cloneref(game:GetService("RunService"))
TeleportService = cloneref(game:GetService("TeleportService"))
StarterGui = cloneref(game:GetService("StarterGui"))
GuiService = cloneref(game:GetService("GuiService"))
Lighting = cloneref(game:GetService("Lighting"))
ContextActionService = cloneref(game:GetService("ContextActionService"))
ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
GroupService = cloneref(game:GetService("GroupService"))
PathService = cloneref(game:GetService("PathfindingService"))
SoundService = cloneref(game:GetService("SoundService"))
Teams = cloneref(game:GetService("Teams"))
StarterPlayer = cloneref(game:GetService("StarterPlayer"))
InsertService = cloneref(game:GetService("InsertService"))
ChatService = cloneref(game:GetService("Chat"))
ProximityPromptService = cloneref(game:GetService("ProximityPromptService"))
ContentProvider = cloneref(game:GetService("ContentProvider"))
StatsService = cloneref(game:GetService("Stats"))
MaterialService = cloneref(game:GetService("MaterialService"))
AvatarEditorService = cloneref(game:GetService("AvatarEditorService"))
TextService = cloneref(game:GetService("TextService"))
TextChatService = cloneref(game:GetService("TextChatService"))
CaptureService = cloneref(game:GetService("CaptureService"))

Player = cloneref(Players.LocalPlayer)
PlayerGui = cloneref(Players.LocalPlayer:FindFirstChildWhichIsA("PlayerGui"))
PlaceId, JobId = game.PlaceId, game.JobId
IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UserInputService:GetPlatform())

isLegacyChat = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService

-- Asset handling for UI
local dlassets = {
    ["devonloader/assets/bindsandplugins.png"] = "rbxassetid://5147695474",
    ["devonloader/assets/close.png"] = "rbxassetid://3926305904",
    ["devonloader/assets/drag.png"] = "rbxassetid://5144775406",
    ["devonloader/assets/logo.png"] = "rbxassetid://4934506955",
    ["devonloader/assets/minimize.png"] = "rbxassetid://5147694186",
    ["devonloader/assets/open.png"] = "rbxassetid://5147694186",
    ["devonloader/assets/pin_off.png"] = "rbxassetid://5147695474",
    ["devonloader/assets/pin_on.png"] = "rbxassetid://5147695474",
    ["devonloader/assets/reference.png"] = "rbxassetid://5147695474",
    ["devonloader/assets/resize.png"] = "rbxassetid://5144775406"
}

function getcustomasset(asset)
    if dlassets[asset] then
        if waxgetcustomasset then
            local success, result = pcall(function()
                return waxgetcustomasset(asset)
            end)
            if success and result ~= nil and result ~= "" then
                return result
            end
        end
    end
    return dlassets[asset]
end

-- UI Setup
local currentVersion = "5.9.3"

-- Instance creation for UI elements
local DevonLoader = Instance.new("ScreenGui")
local Holder = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Dark = Instance.new("Frame")
local Cmdbar = Instance.new("TextBox")
local CMDsF = Instance.new("ScrollingFrame")
local listlayout = Instance.new("UIListLayout")
local ReferenceButton = Instance.new("ImageButton")
local ColorsButton = Instance.new("ImageButton")
local Settings = Instance.new("Frame")
local Prefix = Instance.new("TextLabel")
local PrefixBox = Instance.new("TextBox")
local Keybinds = Instance.new("TextLabel")
local StayOpen = Instance.new("TextLabel")
local Button = Instance.new("Frame")
local On = Instance.new("TextButton")
local Positions = Instance.new("TextLabel")
local EventBind = Instance.new("TextLabel")
local Plugins = Instance.new("TextLabel")
local Example = Instance.new("TextButton")
local Notification = Instance.new("Frame")
local Title_2 = Instance.new("TextLabel")
local Text = Instance.new("TextLabel")
local shadow = Instance.new("Frame")
local PopupText = Instance.new("TextLabel")
local Exit = Instance.new("TextButton")
local ExitImage = Instance.new("ImageLabel")
local IntroBackground = Instance.new("Frame")
local Logo = Instance.new("ImageLabel")
local Credits = Instance.new("TextLabel")
local MinimizedBar = Instance.new("Frame")
local Open = Instance.new("TextButton")
local Drag = Instance.new("ImageLabel")
local Dark_3 = Instance.new("Frame")
local ResizeIcon = Instance.new("ImageButton")
local background_2 = Instance.new("Frame")
local Colors = Instance.new("Frame")
local Exit_2 = Instance.new("TextButton")
local ExitImage_2 = Instance.new("ImageLabel")
local Shade1 = Instance.new("TextLabel")
local Color1 = Instance.new("TextBox")
local Shade2 = Instance.new("TextLabel")
local Color2 = Instance.new("TextBox")
local Shade3 = Instance.new("TextLabel")
local Color3 = Instance.new("TextBox")
local Text1 = Instance.new("TextLabel")
local Color4 = Instance.new("TextBox")
local Text2 = Instance.new("TextLabel")
local Color5 = Instance.new("TextBox")
local Save = Instance.new("TextButton")
local Scroll = Instance.new("ScrollingFrame")
local Scroll_2 = Instance.new("ScrollingFrame")
local CmdInfo = Instance.new("Frame")
local CmdName = Instance.new("TextLabel")
local CmdDesc = Instance.new("TextLabel")
local CopyCmd = Instance.new("TextButton")
local AddAlias = Instance.new("TextButton")
local AliasList = Instance.new("ScrollingFrame")
local RemoveAlias = Instance.new("TextButton")
local Waypoints = Instance.new("Frame")
local background = Instance.new("Frame")
local Save_2 = Instance.new("TextButton")
local WayName = Instance.new("TextBox")
local Add = Instance.new("TextButton")
local scroll = Instance.new("ScrollingFrame")
local Delete = Instance.new("TextButton")
local Goto = Instance.new("TextButton")
local Directions = Instance.new("TextLabel")
local KeybindEditor = Instance.new("Frame")
local background_4 = Instance.new("Frame")
local Save_3 = Instance.new("TextButton")
local BindCmd = Instance.new("TextBox")
local BindKey = Instance.new("TextBox")
local Add_2 = Instance.new("TextButton")
local Toggles = Instance.new("ScrollingFrame")
local ClickTP = Instance.new("TextLabel")
local Select = Instance.new("TextButton")
local ClickDelete = Instance.new("TextLabel")
local Select_2 = Instance.new("TextButton")
local Cmdbar_2 = Instance.new("TextBox")
local Cmdbar_3 = Instance.new("TextBox")
local CreateToggle = Instance.new("TextLabel")
local Button_2 = Instance.new("Frame")
local On_2 = Instance.new("TextButton")
local shadow_2 = Instance.new("Frame")
local PopupText_2 = Instance.new("TextLabel")
local Exit_3 = Instance.new("TextButton")
local ExitImage_3 = Instance.new("ImageLabel")
local AliasHint = Instance.new("TextLabel")
local PluginEditor = Instance.new("Frame")
local background_3 = Instance.new("Frame")
local Dark_2 = Instance.new("Frame")
local Img = Instance.new("ImageButton")
local AddPlugin = Instance.new("TextButton")
local FileName = Instance.new("TextBox")
local About = Instance.new("TextLabel")
local Directions_2 = Instance.new("TextLabel")
local shadow_3 = Instance.new("Frame")
local PopupText_3 = Instance.new("TextLabel")
local Exit_4 = Instance.new("TextButton")
local ExitImage_4 = Instance.new("ImageLabel")
local Logs = Instance.new("Frame")
local background_5 = Instance.new("Frame")
local Toggle_2 = Instance.new("TextButton")
local Clear_2 = Instance.new("TextButton")
local scroll_3 = Instance.new("ScrollingFrame")
local listlayout_2 = Instance.new("UIListLayout")
local selectChat = Instance.new("TextButton")
local selectJoin = Instance.new("TextButton")

-- UI Setup and Styling
DevonLoader.Name = "DevonLoader"
DevonLoader.Parent = COREGUI
DevonLoader.Enabled = false
DevonLoader.DisplayOrder = 100
DevonLoader.ResetOnSpawn = false

local shade1 = {}
local shade2 = {}
local shade3 = {}
local text1 = {}
local text2 = {}
local scrollcol = {}
local button = {}
local currentShade1 = Color3.fromRGB(36, 36, 37)
local currentShade2 = Color3.fromRGB(26, 26, 27)
local currentShade3 = Color3.fromRGB(46, 46, 47)
local currentText1 = Color3.fromRGB(242, 243, 243)
local currentText2 = Color3.fromRGB(200, 200, 200)
local currentScroll = Color3.fromRGB(40, 40, 41)
local currentButton = Color3.fromRGB(50, 50, 51)

function Darken(Color)
    local H, S, V = Color:ToHSV()
    V = math.clamp(V - 0.03, 0, 1)
    return Color3.fromHSV(H, S, V)
end
function Lighten(Color)
    local H, S, V = Color:ToHSV()
    V = math.clamp(V + 0.03, 0, 1)
    return Color3.fromHSV(H, S, V)
end

function applyTheme()
    for i, v in ipairs(shade1) do
        v.BackgroundColor3 = currentShade1
    end
    for i, v in ipairs(shade2) do
        v.BackgroundColor3 = currentShade2
    end
    for i, v in ipairs(shade3) do
        v.BackgroundColor3 = currentShade3
    end
    for i, v in ipairs(text1) do
        v.TextColor3 = currentText1
    end
    for i, v in ipairs(text2) do
        v.TextColor3 = currentText2
    end
    for i, v in ipairs(scrollcol) do
        v.ScrollBarImageColor3 = currentScroll
    end
    for i, v in ipairs(button) do
        v.BackgroundColor3 = currentButton
    end
end

function loadTheme()
    local themeData = readfile and isfile and isfile("DLthemes.txt") and readfile("DLthemes.txt")
    if themeData then
        local success, result = pcall(function()
            local data = HttpService:JSONDecode(themeData)
            currentShade1 = Color3.fromHex(data.Shade1 or "#242425")
            currentShade2 = Color3.fromHex(data.Shade2 or "#1A1A1B")
            currentShade3 = Color3.fromHex(data.Shade3 or "#2E2E2F")
            currentText1 = Color3.fromHex(data.Text1 or "#F2F3F3")
            currentText2 = Color3.fromHex(data.Text2 or "#C8C8C8")
            currentScroll = Color3.fromHex(data.Scroll or "#282829")
            currentButton = Color3.fromHex(data.Button or "#323233")
        end)
        if success and result then
            applyTheme()
        end
    end
end
if readfile and isfile then
    pcall(loadTheme)
end

function randomString()
    local length = math.random(10, 20)
    local array = {}
    for i = 1, length do
        array[i] = string.char(math.random(32, 126))
    end
    return table.concat(array)
end

PARENT = nil
if get_hidden_gui or gethui then
    local hiddenUI = get_hidden_gui or gethui
    local success, result = pcall(hiddenUI)
    if success then
        PARENT = result
    end
end
if not PARENT then
    if COREGUI:FindFirstChild("RobloxGui") then
        PARENT = COREGUI.RobloxGui
    else
        PARENT = COREGUI
    end
end

local ScaledHolder = Instance.new("Frame")
ScaledHolder.Name = randomString()
ScaledHolder.Parent = DevonLoader
ScaledHolder.BackgroundTransparency = 1
ScaledHolder.Size = UDim2.new(1, 0, 1, 0)

Holder.Name = "Holder"
Holder.Parent = ScaledHolder
Holder.Active = true
Holder.BackgroundColor3 = Color3.fromRGB(26, 26, 27)
Holder.BackgroundTransparency = 1
Holder.BorderSizePixel = 0
Holder.Position = UDim2.new(1, -250, 1, -220)
Holder.Size = UDim2.new(0, 250, 0, 220)
Holder.ZIndex = 10
table.insert(shade2, Holder)

Title.Name = "Title"
Title.Parent = Holder
Title.Active = true
Title.BackgroundColor3 = Color3.fromRGB(36, 36, 37)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(0, 250, 0, 20)
Title.Font = Enum.Font.SourceSans
Title.TextSize = 18
Title.Text = "Devon Loader v" .. currentVersion
table.insert(shade1, Title)

-- CTRL Click Teleport Script
--[[local Plr = game:GetService("Players").LocalPlayer
local Mouse = Plr:GetMouse()
 
Mouse.Button1Down:connect(function()
if not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then return end
if not Mouse.Target then return end
Plr.Character:MoveTo(Mouse.Hit.p)
end)
--]]

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "CTRL click tp",
    Text = "Hold Ctrl then press click to a place you want to teleport to.",
    Duration = 6,
})

-- Configuration
local instant_teleport = true -- Set to true for instant teleport, false for tween
local speed = 1000 -- Only used if instant_teleport is false
local bodyvelocityenabled = true -- set this to false if you are getting kicked
local auto_above = true -- Automatically teleport above objects when clicking underneath

-- Services
local Imput = game:GetService("UserInputService")
local Plr = game.Players.LocalPlayer
local Mouse = Plr:GetMouse()

-- Function to get the top surface of an object
function GetTopSurface(object, hitPoint)
    if not object then return hitPoint end
    
    local size = object.Size
    local cframe = object.CFrame
    local topY = cframe.Y + (size.Y / 2)
    
    return Vector3.new(hitPoint.X, topY + 3, hitPoint.Z)
end

-- Function to find safe teleport position
function FindSafePosition(hitPoint, hitObject)
    if not auto_above then
        return hitPoint
    end
    
    -- If we clicked on an object, teleport to its top
    if hitObject then
        return GetTopSurface(hitObject, hitPoint)
    end
    
    -- If we clicked in air, try to find ground below
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {Plr.Character}
    
    -- Cast ray downward to find ground
    local raycastResult = workspace:Raycast(hitPoint, Vector3.new(0, -1000, 0), raycastParams)
    
    if raycastResult then
        -- Found ground, teleport above it
        return raycastResult.Position + Vector3.new(0, 3, 0)
    else
        -- No ground found, use original position with some height
        return hitPoint + Vector3.new(0, 5, 0)
    end
end

-- Advanced function to detect if we're clicking underneath something
function IsClickingUnderneath(hitPoint)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {Plr.Character}
    
    -- Cast multiple rays upward to detect objects above
    for i = 1, 10 do
        local rayStart = hitPoint + Vector3.new(0, i * 2, 0)
        local raycastResult = workspace:Raycast(rayStart, Vector3.new(0, 50, 0), raycastParams)
        
        if raycastResult then
            -- Found something above, return its top position
            local object = raycastResult.Instance
            local size = object.Size
            local cframe = object.CFrame
            local topY = cframe.Y + (size.Y / 2)
            return Vector3.new(hitPoint.X, topY + 3, hitPoint.Z)
        end
    end
    
    return nil -- Nothing found above
end

-- Teleport function
function To(position)
    local Chr = Plr.Character
    if Chr ~= nil then
        local hm = Chr.HumanoidRootPart
        
        -- Get the object we clicked on
        local hitObject = Mouse.Target
        local hitPoint = Mouse.Hit.p
        
        -- Find safe teleport position
        local final_position = FindSafePosition(hitPoint, hitObject)
        
        -- Additional check for clicking underneath objects
        if auto_above then
            local underneathPosition = IsClickingUnderneath(hitPoint)
            if underneathPosition then
                final_position = underneathPosition
            end
        end
        
        if instant_teleport then
            -- Instant teleport (fastest)
            hm.CFrame = CFrame.new(final_position)
        else
            -- Tween teleport (slower but smoother)
            local ts = game:GetService("TweenService")
            local dist = (hm.Position - final_position).magnitude
            local tweenspeed = dist/tonumber(speed)
            local ti = TweenInfo.new(tonumber(tweenspeed), Enum.EasingStyle.Linear)
            local tp = {CFrame = CFrame.new(final_position)}
            ts:Create(hm, ti, tp):Play()
            
            if bodyvelocityenabled == true then
                local bv = Instance.new("BodyVelocity")
                bv.Parent = hm
                bv.MaxForce = Vector3.new(100000,100000,100000)
                bv.Velocity = Vector3.new(0,0,0)
                wait(tonumber(tweenspeed))
                bv:Destroy()
            end
        end
    end
end

-- Input handler
Imput.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and Imput:IsKeyDown(Enum.KeyCode.LeftControl) then
        To(Mouse.Hit.p)
    end
end)

-- Continue with UI setup (rest of the UI elements)
-- Removed command functionalities and scripts, keeping only UI structure

-- Notification function
function notify(TitleText, ContentText, Duration)
    local NotificationClone = Notification:Clone()
    NotificationClone.Visible = true
    NotificationClone.Name = randomString()
    NotificationClone.Title.Text = TitleText or "Notification"
    NotificationClone.Text.Text = ContentText or "Content"
    NotificationClone.Parent = ScaledHolder
    NotificationClone:TweenPosition(UDim2.new(0.5, -150, 0, 20), "InOut", "Quart", 0.5, true, nil)
    wait(Duration or 3)
    NotificationClone:TweenPosition(UDim2.new(0.5, -150, 0, -100), "InOut", "Quart", 0.5, true, nil)
    wait(0.5)
    NotificationClone:Destroy()
end

-- Minimize functionality
local minimized = false
function minimizeHolder()
    if not minimized then
        Holder:TweenSize(UDim2.new(0, 250, 0, 20), "InOut", "Quart", 0.5, true, nil)
        MinimizedBar.Visible = true
        minimized = true
    end
end
function maximizeHolder()
    if minimized then
        Holder:TweenSize(UDim2.new(0, 250, 0, 220), "InOut", "Quart", 0.5, true, nil)
        MinimizedBar.Visible = false
        minimized = false
    end
end

-- Initial notification
notify("Devon Loader", "UI loaded successfully. No scripts included.", 5)

-- Enable UI
task.delay(0.1, function()
    DevonLoader.Enabled = true
end)

-- Intro animation
task.spawn(function()
    wait()
    Credits:TweenPosition(UDim2.new(0, 0, 0.9, 0), "Out", "Quart", 0.2)
    Logo:TweenSizeAndPosition(UDim2.new(0, 175, 0, 175), UDim2.new(0, 37, 0, 45), "Out", "Quart", 0.3)
    wait(1)
    local OutInfo = TweenInfo.new(1.6809, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
    TweenService:Create(Logo, OutInfo, {ImageTransparency = 1}):Play()
    TweenService:Create(IntroBackground, OutInfo, {BackgroundTransparency = 1}):Play()
    Credits:TweenPosition(UDim2.new(0, 0, 0.9, 30), "Out", "Quart", 0.2)
    wait(0.2)
    Logo:Destroy()
    Credits:Destroy()
    IntroBackground:Destroy()
    minimizeHolder()
    if IsOnMobile then notify("Unstable Device", "On mobile, Devon Loader may have issues or features that are not functioning correctly.") end
end)
