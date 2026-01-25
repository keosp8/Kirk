-- LXKCR Duels Hub (All-in-one)
-- Paste as a LocalScript (StarterPlayerScripts or PlayerGui)
-- שים לב: הקוד משתמש ב־pcall ובבדיקות עבור פונקציות שיכולות להיעדר

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local MaterialService = game:GetService("MaterialService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ========== CONFIG DEFAULTS ==========
local CONFIG = {
    Theme = {
        Primary = Color3.fromRGB(153, 102, 255), -- סגול ניאון
        Accent = Color3.fromRGB(255,255,255)
    },
    Steal = {
        Enabled = false,
        ShowBar = true,
        Radius = 63,
        ProgressSpeed = 0.5, -- כמה שניות עד 100% => השתמש כדי לכוונן (0.5 = מהיר יותר)
    },
    AutoGrab = {
        Enabled = false,
        PickupRadius = 63,
        Cooldown = 0.5
    },
    Booster = {
        Enabled = false,
        Speed = 25,
        StealingSpeed = 30
    },
    AutoBat = {
        Enabled = false,
        Keybind = nil
    },
    Helicopter = {
        Enabled = false,
        SpinSpeed = 10
    },
    Unwalk = {
        Enabled = false
    },
    PlaceBlock = {
        Enabled = false,
        Keybind = nil, -- אם nil => תמיד כשהקופץ
        Size = Vector3.new(4,1,4),
        Lifetime = 5
    },
    AntiRagdoll = {
        Enabled = true,
        DisableItemRemotes = true
    },
    Optimizer = {
        Enabled = true,
        Settings = {
            ["FPS Cap"] = true,
            ["No Camera Effects"] = true,
            ["No Clothes"] = true,
            ["Low Water Graphics"] = true,
            ["No Shadows"] = true,
            ["Low Rendering"] = true,
            ["Low Quality Parts"] = true,
            ["Low Quality Models"] = true,
            ["Reset Materials"] = true
        }
    }
}

-- keep track of dynamic state
local state = {
    autoGrabConn = nil,
    autoBatConn = nil,
    heliAlign = nil,
    heliAttachment = nil,
    heliConn = nil,
    unwalkConns = {},
    antiItemWatcher = nil,
    stealProgress = 0,
    stealTarget = nil,
    stealLastTime = 0,
    placeBlockKeyDown = false
}

-- ========== UTILITIES ==========
local function safeFireProximity(prompt)
    if not prompt then return false end
    -- try the common exploit function first
    local ok, err = pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt, prompt.HoldDuration or 0.1)
        else
            -- fallback: :InputHold not available reliably; try :HoldBegin / :HoldEnd if present
            if prompt._rbx_internal and type(prompt._rbx_internal) == "table" then
                -- nothing wise; most exploits provide fireproximityprompt
            end
        end
    end)
    return ok
end

local function findClosestProximity(rootPos, radius)
    local closest, closestDist = nil, radius
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Enabled then
            local action = (v.ActionText or ""):lower()
            local object = (v.ObjectText or ""):lower()
            local parentName = v.Parent and v.Parent.Name:lower() or ""
            if action:find("sell") or object:find("sell") or parentName:find("sell") then
                -- skip sell prompts
            else
                local part = v:FindFirstAncestorWhichIsA("BasePart")
                if part then
                    local dist = (part.Position - rootPos).Magnitude
                    if dist <= closestDist then
                        closestDist = dist
                        closest = v
                    end
                end
            end
        end
    end
    return closest
end

local function isPlayerCharacter(inst)
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character and inst:IsDescendantOf(pl.Character) then
            return true
        end
    end
    return false
end

-- ========== UI BUILD ==========
local gui = Instance.new("ScreenGui")
gui.Name = "LXKCR_DuelsHub"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- main frame
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 420, 0, 300)
main.Position = UDim2.new(0.5, -210, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
main.AnchorPoint = Vector2.new(0.5,0.5)
main.Parent = gui
local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0,12)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 2
mainStroke.Color = CONFIG.Theme.Primary

-- header
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,36)
header.Position = UDim2.new(0,0,0,0)
header.BackgroundTransparency = 1
local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(0.6, -10, 1, 0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "LXKCR Hub • Duels"
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.TextColor3 = CONFIG.Theme.Accent
title.TextXAlignment = Enum.TextXAlignment.Left

-- minimize button
local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.new(0,28,0,24)
minBtn.Position = UDim2.new(1,-36,0,6)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.TextColor3 = Color3.fromRGB(20,20,20)
minBtn.BackgroundColor3 = CONFIG.Theme.Primary
minBtn.BorderSizePixel = 0
local minCorner = Instance.new("UICorner", minBtn)
minCorner.CornerRadius = UDim.new(0,6)

-- close (optional)
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0,28,0,24)
closeBtn.Position = UDim2.new(1,-6,0,6)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(240,240,240)
closeBtn.BackgroundTransparency = 1
closeBtn.BorderSizePixel = 0

-- content container
local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -20, 1, -56)
container.Position = UDim2.new(0,10,0,46)
container.BackgroundTransparency = 1

-- left column
local leftCol = Instance.new("Frame", container)
leftCol.Size = UDim2.new(0.5, -8, 1, 0)
leftCol.Position = UDim2.new(0,0,0,0)
leftCol.BackgroundTransparency = 1

-- right column
local rightCol = Instance.new("Frame", container)
rightCol.Size = UDim2.new(0.5, -8, 1, 0)
rightCol.Position = UDim2.new(0.5, 8, 0, 0)
rightCol.BackgroundTransparency = 1

-- small helper to create toggle
local function createToggle(parent, y, labelText, initial)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1,0,0,28)
    btn.Position = UDim2.new(0,0,0,y)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.BorderSizePixel = 0
    local corner = Instance.new("UICorner", btn); corner.CornerRadius = UDim.new(0,6)
    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(0.7,0,1,0); lbl.Position = UDim2.new(0,8,0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = labelText; lbl.TextColor3 = Color3.fromRGB(230,230,230); lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextSize = 14
    local toggleFrame = Instance.new("Frame", btn)
    toggleFrame.Size = UDim2.new(0,36,0,20); toggleFrame.Position = UDim2.new(1,-44,0.5,-10)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30,30,30); toggleFrame.BorderSizePixel = 0
    local tcorner = Instance.new("UICorner", toggleFrame); tcorner.CornerRadius = UDim.new(0,10)
    local knob = Instance.new("Frame", toggleFrame)
    knob.Size = UDim2.new(0.45,0,1,0); knob.Position = UDim2.new(0,2,0,0)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255); knob.BorderSizePixel = 0
    local knobCorner = Instance.new("UICorner", knob); knobCorner.CornerRadius = UDim.new(0,8)

    local glow = Instance.new("UIStroke", btn)
    glow.Thickness = 1; glow.Color = Color3.fromRGB(0,0,0); glow.Transparency = 1

    -- set initial
    local on = initial or false
    if on then
        toggleFrame.BackgroundColor3 = CONFIG.Theme.Primary
        knob.Position = UDim2.new(0.55,0,0,0)
    else
        toggleFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
        knob.Position = UDim2.new(0,2,0,0)
    end

    -- click handler returns a function to toggle
    local function setState(s)
        on = s
        if on then
            TweenService:Create(toggleFrame, TweenInfo.new(0.18), {BackgroundColor3 = CONFIG.Theme.Primary}):Play()
            TweenService:Create(knob, TweenInfo.new(0.18), {Position = UDim2.new(0.55,0,0,0)}):Play()
        else
            TweenService:Create(toggleFrame, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(30,30,30)}):Play()
            TweenService:Create(knob, TweenInfo.new(0.18), {Position = UDim2.new(0,2,0,0)}):Play()
        end
    end

    btn.MouseButton1Click:Connect(function()
        setState(not on)
    end)

    return btn, function() return on end, setState
end

-- small helper to create slider
local function createSlider(parent, y, labelText, minV, maxV, initial)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1,0,0,48)
    frame.Position = UDim2.new(0,0,0,y)
    frame.BackgroundTransparency = 1
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1,0,0,18)
    lbl.Position = UDim2.new(0,0,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextColor3 = Color3.fromRGB(230,230,230)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local barBg = Instance.new("Frame", frame)
    barBg.Size = UDim2.new(1, -50, 0, 16)
    barBg.Position = UDim2.new(0,0,0,24)
    barBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
    barBg.BorderSizePixel = 0
    local bgCorner = Instance.new("UICorner", barBg); bgCorner.CornerRadius = UDim.new(0,8)
    local fill = Instance.new("Frame", barBg)
    fill.Size = UDim2.new(((initial or minV)-minV)/(maxV-minV), 0, 1, 0)
    fill.BackgroundColor3 = CONFIG.Theme.Primary
    local fillCorner = Instance.new("UICorner", fill); fillCorner.CornerRadius = UDim.new(0,8)
    local knob = Instance.new("Frame", barBg)
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new(fill.Size.X.Scale, fill.Size.X.Offset, 0.5, -6)
    knob.BackgroundColor3 = CONFIG.Theme.Accent
    knob.BorderSizePixel = 0
    local knobCorner = Instance.new("UICorner", knob); knobCorner.CornerRadius = UDim.new(0,8)
    local valueLabel = Instance.new("TextLabel", frame)
    valueLabel.Size = UDim2.new(0,46,0,18)
    valueLabel.Position = UDim2.new(1, -46, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(initial or minV)
    valueLabel.TextColor3 = Color3.fromRGB(220,220,220)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 13

    local dragging = false
    local function updateFromPos(x)
        local rel = math.clamp((x - barBg.AbsolutePosition.X)/barBg.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, -6, 0.5, -6)
        local val = math.floor(minV + rel*(maxV-minV) + 0.5)
        valueLabel.Text = tostring(val)
        return val
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local val = updateFromPos(input.Position.X)
        end
    end)

    -- initial set
    if initial then
        local rel = math.clamp((initial - minV)/(maxV - minV), 0, 1)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, -6, 0.5, -6)
        valueLabel.Text = tostring(initial)
    end

    return frame, function() return tonumber(valueLabel.Text) end, function(v)
        local rel = math.clamp((v - minV)/(maxV - minV), 0, 1)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, -6, 0.5, -6)
        valueLabel.Text = tostring(math.floor(v+0.5))
    end
end

-- ========== CREATE LEFT SIDE CONTROLS ==========
local y = 0
local autoStealBtn, autoStealState, autoStealSet = createToggle(leftCol, y, "Auto Steal", CONFIG.Steal.Enabled); y = y + 34
local showBarBtn, showBarState, showBarSet = createToggle(leftCol, y, "Show Steal Bar", CONFIG.Steal.ShowBar); y = y + 34
local autoGrabBtn, autoGrabState, autoGrabSet = createToggle(leftCol, y, "Auto Grab (Proximity)", CONFIG.AutoGrab.Enabled); y = y + 34
local antiRBtn, antiRState, antiRSet = createToggle(leftCol, y, "Anti Ragdoll", CONFIG.AntiRagdoll.Enabled); y = y + 34
local antiItemBtn, antiItemState, antiItemSet = createToggle(leftCol, y, "Anti Item Remotes", CONFIG.AntiRagdoll.Enabled); y = y + 34

local sliderFrame, getRadius, setRadius = createSlider(leftCol, y, "Steal Radius", 5, 200, CONFIG.Steal.Radius); y = y + 52

-- ========== CREATE RIGHT SIDE CONTROLS ==========
local y2 = 0
local boosterBtn, boosterState, boosterSet = createToggle(rightCol, y2, "Booster (Speed)", CONFIG.Booster.Enabled); y2 = y2 + 34
local stealingModeBtn, stealingModeState, stealingModeSet = createToggle(rightCol, y2, "Stealing Mode (use stealing speed)", false); y2 = y2 + 34
local autoBatBtn, autoBatState, autoBatSet = createToggle(rightCol, y2, "Auto Bat", CONFIG.AutoBat.Enabled); y2 = y2 + 34
local heliBtn, heliState, heliSet = createToggle(rightCol, y2, "Helicopter (Spin)", CONFIG.Helicopter.Enabled); y2 = y2 + 34
local unwalkBtn, unwalkState, unwalkSet = createToggle(rightCol, y2, "Unwalk Anim", CONFIG.Unwalk.Enabled); y2 = y2 + 34
local placeBlockBtn, placeBlockState, placeBlockSet = createToggle(rightCol, y2, "Place Block on Jump", false); y2 = y2 + 34

local spinSlider, getSpin, setSpin = createSlider(rightCol, y2, "Heli Rotation", 1, 60, CONFIG.Helicopter.SpinSpeed); y2 = y2 + 52
local boosterSlider, getBooster, setBooster = createSlider(rightCol, y2, "Booster Speed", 5, 100, CONFIG.Booster.Speed); y2 = y2 + 52

-- ========== STEAL BAR (CENTER BOTTOM) ==========
local barParent = Instance.new("Frame", main)
barParent.Size = UDim2.new(0.58,0,0,72)
barParent.Position = UDim2.new(0.5, -barParent.Size.X.Offset/2, 1, -84)
barParent.BackgroundTransparency = 1

local stealFrame = Instance.new("Frame", barParent)
stealFrame.Size = UDim2.new(1,0,0,36)
stealFrame.Position = UDim2.new(0,0,0,0)
stealFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
local sCorner = Instance.new("UICorner", stealFrame); sCorner.CornerRadius = UDim.new(0,8)
local stealFill = Instance.new("Frame", stealFrame)
stealFill.Size = UDim2.new(0,0,1,0)
stealFill.BackgroundColor3 = CONFIG.Theme.Primary
local fillCorner = Instance.new("UICorner", stealFill); fillCorner.CornerRadius = UDim.new(0,8)
local percentLabel = Instance.new("TextLabel", stealFrame)
percentLabel.Size = UDim2.new(1,0,1,0); percentLabel.BackgroundTransparency = 1; percentLabel.Font = Enum.Font.GothamBlack; percentLabel.TextSize = 16
percentLabel.TextColor3 = CONFIG.Theme.Accent; percentLabel.Text = "READY"
percentLabel.TextScaled = false
percentLabel.TextXAlignment = Enum.TextXAlignment.Center; percentLabel.TextYAlignment = Enum.TextYAlignment.Center

local leftRadiusLabel = Instance.new("TextLabel", barParent)
leftRadiusLabel.Size = UDim2.new(0,60,0,16)
leftRadiusLabel.Position = UDim2.new(0, -62, 0.5, -8)
leftRadiusLabel.BackgroundTransparency = 1
leftRadiusLabel.Text = "" -- can use for extra info
leftRadiusLabel.TextColor3 = Color3.fromRGB(220,220,220)
leftRadiusLabel.Font = Enum.Font.Gotham
leftRadiusLabel.TextSize = 12
leftRadiusLabel.TextXAlignment = Enum.TextXAlignment.Left

local rightRadiusLabel = Instance.new("TextLabel", barParent)
rightRadiusLabel.Size = UDim2.new(0,60,0,16)
rightRadiusLabel.Position = UDim2.new(1, 2, 0.5, -8)
rightRadiusLabel.BackgroundTransparency = 1
rightRadiusLabel.Text = tostring(CONFIG.Steal.Radius)
rightRadiusLabel.TextColor3 = Color3.fromRGB(220,220,220)
rightRadiusLabel.Font = Enum.Font.Gotham
rightRadiusLabel.TextSize = 12
rightRadiusLabel.TextXAlignment = Enum.TextXAlignment.Right

-- stars background effect (simple)
local starsContainer = Instance.new("Frame", main)
starsContainer.Size = UDim2.new(1,0,1,0)
starsContainer.Position = UDim2.new(0,0,0,0)
starsContainer.BackgroundTransparency = 1
starsContainer.ZIndex = 0

local function spawnStar()
    local star = Instance.new("ImageLabel", starsContainer)
    star.BackgroundTransparency = 1
    star.Image = "" -- leave blank to use simple frame shapes, or set to small star image id if you have
    star.Size = UDim2.new(0, math.random(2,6), 0, math.random(2,6))
    star.Position = UDim2.new(math.random(), 0, -0.02, 0)
    star.BackgroundColor3 = Color3.fromRGB(200,180,255)
    star.BorderSizePixel = 0
    star.Rotation = math.random(0,360)
    star.ZIndex = 0
    local destY = 1.02
    local t = TweenService:Create(star, TweenInfo.new(math.random(4,9)), {Position = UDim2.new(star.Position.X.Scale, 0, destY, 0), BackgroundTransparency = 1})
    t:Play()
    Debris:AddItem(star, 10)
end

-- spawn some stars periodically
spawn(function()
    while gui.Parent do
        spawnStar()
        task.wait(0.12)
    end
end)

-- ========== DRAGGING & MINIMIZE ==========
local dragging, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        container.Visible = false
        stealFrame.Visible = false
        TweenService:Create(main, TweenInfo.new(0.2), {Size = UDim2.new(0, 220, 0, 48)}):Play()
    else
        container.Visible = true
        stealFrame.Visible = true
        TweenService:Create(main, TweenInfo.new(0.2), {Size = UDim2.new(0, 420, 0, 300)}):Play()
    end
end)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ========== HOOK UI TO STATE ==========
-- radius slider update -> label
local function updateRadiusFromUI()
    local r = getRadius() or CONFIG.Steal.Radius
    CONFIG.Steal.Radius = r
    rightRadiusLabel.Text = tostring(r)
    CONFIG.AutoGrab.PickupRadius = r
end

-- connect slider finished (we already set drag events) - also poll changes
spawn(function()
    while gui.Parent do
        updateRadiusFromUI()
        setRadius(CONFIG.Steal.Radius)
        setBooster(CONFIG.Booster.Speed)
        setSpin(CONFIG.Helicopter.SpinSpeed)
        task.wait(0.4)
    end
end)

-- toggles initial states: when toggles change we update CONFIG and call handlers
local function syncToggles()
    CONFIG.Steal.Enabled = autoStealState()
    CONFIG.Steal.ShowBar = showBarState()
    CONFIG.AutoGrab.Enabled = autoGrabState()
    CONFIG.AntiRagdoll.Enabled = antiRState()
    CONFIG.AntiRagdoll.DisableItemRemotes = antiItemState()
    CONFIG.Booster.Enabled = boosterState()
    CONFIG.AutoBat.Enabled = autoBatState()
    CONFIG.Helicopter.Enabled = heliState()
    CONFIG.Unwalk.Enabled = unwalkState()
    CONFIG.PlaceBlock.Enabled = placeBlockState()
end
-- update on click: connect each button to update config and call specific toggles below
autoStealBtn.MouseButton1Click:Connect(function() CONFIG.Steal.Enabled = autoStealState() end)
showBarBtn.MouseButton1Click:Connect(function() CONFIG.Steal.ShowBar = showBarState(); stealFrame.Visible = CONFIG.Steal.ShowBar end)
autoGrabBtn.MouseButton1Click:Connect(function() CONFIG.AutoGrab.Enabled = autoGrabState() end)
antiRBtn.MouseButton1Click:Connect(function() CONFIG.AntiRagdoll.Enabled = antiRState() end)
antiItemBtn.MouseButton1Click:Connect(function() CONFIG.AntiRagdoll.DisableItemRemotes = antiItemState() end)
boosterBtn.MouseButton1Click:Connect(function() CONFIG.Booster.Enabled = boosterState() end)
stealingModeBtn.MouseButton1Click:Connect(function() end) -- read stealingModeState later
autoBatBtn.MouseButton1Click:Connect(function() CONFIG.AutoBat.Enabled = autoBatState() end)
heliBtn.MouseButton1Click:Connect(function() CONFIG.Helicopter.Enabled = heliState() end)
unwalkBtn.MouseButton1Click:Connect(function() CONFIG.Unwalk.Enabled = unwalkState() end)
placeBlockBtn.MouseButton1Click:Connect(function() CONFIG.PlaceBlock.Enabled = placeBlockState() end)

-- ========== CORE LOGIC: Auto Grab (Proximity) ==========
do
    local onCooldown = false
    local heartbeatConn = nil

    local function tryPickup()
        if onCooldown then return end
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local prompt = findClosestProximity(root.Position, CONFIG.AutoGrab.PickupRadius)
        if not prompt then return end
        pcall(function() safeFireProximity(prompt) end)
        onCooldown = true
        task.delay(CONFIG.AutoGrab.Cooldown, function() onCooldown = false end)
    end

    RunService.Heartbeat:Connect(function()
        if CONFIG.AutoGrab.Enabled then
            tryPickup()
        end
    end)
end

-- ========== CORE LOGIC: Auto Steal Bar ==========
do
    local progress = 0
    local rate = CONFIG.Steal.ProgressSpeed -- progress per second to fill
    local function setPercent(p)
        percentLabel.Text = tostring(math.floor(p*100)) .. "%"
        stealFill.Size = UDim2.new(p,0,1,0)
    end

    RunService.Heartbeat:Connect(function(dt)
        CONFIG.Steal.Radius = getRadius()
        rightRadiusLabel.Text = tostring(CONFIG.Steal.Radius)
        -- find target if any within radius
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then
            percentLabel.Text = "READY"
            stealFill.Size = UDim2.new(0,0,1,0)
            return
        end
        local target = findClosestProximity(root.Position, CONFIG.Steal.Radius)
        if not CONFIG.Steal.Enabled or not target then
            percentLabel.Text = "READY"
            stealFill.Size = UDim2.new(0,0,1,0)
            progress = 0
            return
        end

        -- we have target and Auto Steal enabled
        progress = progress + dt * rate
        if progress > 1 then
            -- attempt steal
            pcall(function() safeFireProximity(target) end)
            progress = 0
        end
        setPercent(progress)
    end)
end

-- ========== AUTO BAT ==========
do
    RunService.Heartbeat:Connect(function()
        if not CONFIG.AutoBat.Enabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local ok, tool = pcall(function() return LocalPlayer.Backpack:FindFirstChild("Bat") end)
        tool = (ok and tool) or char:FindFirstChild("Bat")
        if tool and tool.Parent ~= char then
            pcall(function() humanoid:EquipTool(tool) end)
        end
        pcall(function() if char:FindFirstChild("Bat") and char:FindFirstChild("Bat").Activate then char:FindFirstChild("Bat"):Activate() end end)
    end)
end

-- ========== HELICOPTER (Spin) ==========
do
    local align, attach
    local function enableHeli(enable)
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if enable then
            if not attach or not attach.Parent then
                attach = Instance.new("Attachment"); attach.Parent = hrp
            end
            if not align or not align.Parent then
                align = Instance.new("AlignOrientation")
                align.Attachment0 = attach
                align.Mode = Enum.OrientationAlignmentMode.OneAttachment
                align.Responsiveness = 50
                align.MaxTorque = math.huge
                align.RigidityEnabled = false
                align.Parent = hrp
            end
            align.Enabled = true
            state.heliAlign = align
            state.heliAttachment = attach
        else
            if align then
                align.Enabled = false
                align:Destroy()
                align = nil
            end
            if attach then
                attach:Destroy()
                attach = nil
            end
            state.heliAlign = nil
            state.heliAttachment = nil
        end
    end

    -- continuous update rotation
    local angle = 0
    RunService.Heartbeat:Connect(function(dt)
        if CONFIG.Helicopter.Enabled and state.heliAlign and state.heliAttachment then
            local sp = getSpin() or CONFIG.Helicopter.SpinSpeed
            angle = angle + (sp * dt)
            state.heliAlign.CFrame = CFrame.Angles(0, angle, 0)
        end
    end)

    heliBtn.MouseButton1Click:Connect(function()
        local enable = heliState()
        enableHeli(enable)
        CONFIG.Helicopter.Enabled = enable
    end)
end

-- ========== BOOSTER (Velocity) & STEALING MODE SPEED SWITCH ==========
do
    local conn
    local function startBooster()
        if conn then conn:Disconnect(); conn = nil end
        conn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end
            if hum.MoveDirection.Magnitude > 0 then
                local vel = hrp.Velocity
                local dir = hum.MoveDirection
                local speed = getBooster() or CONFIG.Booster.Speed
                if stealingModeState() then
                    speed = tonumber(getBooster()) or CONFIG.Booster.Speed
                end
                hrp.Velocity = Vector3.new(dir.X * speed, vel.Y, dir.Z * speed)
            end
        end)
        state.boosterConn = conn
    end

    boosterBtn.MouseButton1Click:Connect(function()
        if boosterState() then
            startBooster()
        else
            if state.boosterConn then state.boosterConn:Disconnect(); state.boosterConn = nil end
        end
    end)
end

-- ========== UNWALK (stop walk animations) ==========
do
    local function stopAnimTracks(humanoid)
        if not humanoid then return end
        local ok, animator = pcall(function() return humanoid:FindFirstChildOfClass("Animator") end)
        if ok and animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                pcall(function() track:Stop() end)
            end
            -- also connect to future tracks and stop them
            local conn
            conn = animator.ChildAdded:Connect(function(child)
                task.wait(0.01)
                if child:IsA("AnimationTrack") then
                    pcall(function() child:Stop() end)
                end
            end)
            table.insert(state.unwalkConns, conn)
        end
    end

    local function clearUnwalkConns()
        for _, c in ipairs(state.unwalkConns) do
            pcall(function() c:Disconnect() end)
        end
        state.unwalkConns = {}
    end

    local function applyUnwalk(enable)
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if enable then
            stopAnimTracks(hum)
        else
            clearUnwalkConns()
        end
    end

    unwalkBtn.MouseButton1Click:Connect(function()
        local en = unwalkState()
        applyUnwalk(en)
    end)

    Players.PlayerAdded:Connect(function(pl)
        -- nothing special
    end)
end

-- ========== PLACE BLOCK ON JUMP ==========
do
    local function placeBlockAt(pos)
        local part = Instance.new("Part")
        part.Size = CONFIG.PlaceBlock.Size
        part.Anchored = true
        part.CanCollide = true
        part.Material = Enum.Material.Plastic
        part.Color = CONFIG.Theme.Primary
        part.CFrame = CFrame.new(pos - Vector3.new(0, CONFIG.PlaceBlock.Size.Y/2, 0))
        part.Parent = workspace
        Debris:AddItem(part, CONFIG.PlaceBlock.Lifetime)
        return part
    end

    local function onJumpRequest()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        -- if keybind set: require key pressed
        if CONFIG.PlaceBlock.Keybind then
            if not state.placeBlockKeyDown then return end
        end
        -- only place if not standing on ground? user didn't require that; we'll always place
        placeBlockAt(hrp.Position - Vector3.new(0, hrp.Size.Y/2 + 0.5, 0))
    end

    -- connect to Humanoid.Jumping event
    local function connectChar(character)
        local hum = character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Jumping:Connect(function(active)
                if active and CONFIG.PlaceBlock.Enabled then
                    onJumpRequest()
                end
            end)
        end
    end
    if LocalPlayer.Character then connectChar(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(connectChar)

    -- keybind pressing state
    UserInputService.InputBegan:Connect(function(input, gpe)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if CONFIG.PlaceBlock.Keybind and input.KeyCode == CONFIG.PlaceBlock.Keybind then
                state.placeBlockKeyDown = true
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input, gpe)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if CONFIG.PlaceBlock.Keybind and input.KeyCode == CONFIG.PlaceBlock.Keybind then
                state.placeBlockKeyDown = false
            end
        end
    end)
end

-- ========== ANTI RAGDOLL & ANTI ITEM REMOTES ==========
do
    local BlockedStates = {
        [Enum.HumanoidStateType.Ragdoll] = true,
        [Enum.HumanoidStateType.FallingDown] = true,
        [Enum.HumanoidStateType.Physics] = true,
        [Enum.HumanoidStateType.Dead] = true
    }
    local DisabledRemotes = {}

    local function RestoreMotors(character)
        for _, v in ipairs(character:GetDescendants()) do
            if v:IsA("Motor6D") then
                v.Enabled = true
            elseif v:IsA("Constraint") then
                v.Enabled = false
            end
        end
    end
    local Frozen = false

    local function ForceNormal(character)
        local hum = character:FindFirstChildOfClass("Humanoid")
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        pcall(function() hum.Health = hum.MaxHealth end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end)
        if not Frozen then
            Frozen = true
            hrp.Anchored = true
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.CFrame = hrp.CFrame + Vector3.new(0,1.5,0)
        end
    end
    local function Release(character)
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp and Frozen then
            hrp.Anchored = false
            Frozen = false
        end
    end

    local function InitAntiRagdoll(character)
        local hum = character:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        for state in pairs(BlockedStates) do
            pcall(function() hum:SetStateEnabled(state, false) end)
        end
        hum.StateChanged:Connect(function(_, new)
            if CONFIG.AntiRagdoll.Enabled and BlockedStates[new] then
                ForceNormal(character)
                RestoreMotors(character)
            end
        end)
        RunService.Stepped:Connect(function()
            if not CONFIG.AntiRagdoll.Enabled then
                Release(character); return
            end
            if BlockedStates[hum:GetState()] then
                ForceNormal(character)
            else
                Release(character)
            end
            pcall(function() hum.Health = hum.MaxHealth end)
        end)
    end

    local function KillRemote(remote)
        if not getconnections or not remote:IsA("RemoteEvent") then return end
        if DisabledRemotes[remote] then return end
        local name = remote.Name:lower()
        local keywords = {"useitem","combatservice","ragdoll"}
        for _, key in ipairs(keywords) do
            if name:find(key) then
                DisabledRemotes[remote] = {}
                for _, c in ipairs(getconnections(remote.OnClientEvent)) do
                    if c.Disable then
                        pcall(function() c:Disable() end)
                        table.insert(DisabledRemotes[remote], c)
                    end
                end
                break
            end
        end
    end

    -- watch player char
    LocalPlayer.CharacterAdded:Connect(function(char) task.wait(0.3); InitAntiRagdoll(char) end)
    if LocalPlayer.Character then InitAntiRagdoll(LocalPlayer.Character) end

    -- anti item remotes scanning
    if CONFIG.AntiRagdoll.DisableItemRemotes then
        for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
            pcall(function() KillRemote(obj) end)
        end
        state.antiItemWatcher = ReplicatedStorage.DescendantAdded:Connect(function(obj) pcall(function() KillRemote(obj) end) end)
    end
end

-- ========== OPTIMIZER (ONLY YOUR SETTINGS) ==========
do
    if CONFIG.Optimizer.Enabled then
        local s = CONFIG.Optimizer.Settings
        -- FPS UNCAP (if possible)
        if s["FPS Cap"] and setfpscap then
            pcall(function() setfpscap(1e6) end)
        end
        -- No camera effects
        if s["No Camera Effects"] then
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") then
                    pcall(function() v.Enabled = false end)
                end
            end
        end
        -- No shadows
        if s["No Shadows"] then
            pcall(function() Lighting.GlobalShadows = false; Lighting.FogEnd = 9e9; Lighting.ShadowSoftness = 0 end)
            if sethiddenproperty then pcall(function() sethiddenproperty(Lighting, "Technology", 2) end) end
        end
        -- Low rendering
        if s["Low Rendering"] then
            pcall(function() settings().Rendering.QualityLevel = 1; settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04 end)
        end
        -- Low water graphics
        if s["Low Water Graphics"] then
            task.spawn(function()
                local terrain = workspace:FindFirstChildOfClass("Terrain")
                if terrain then
                    pcall(function()
                        terrain.WaterWaveSize = 0
                        terrain.WaterWaveSpeed = 0
                        terrain.WaterReflectance = 0
                        terrain.WaterTransparency = 0
                        if sethiddenproperty then sethiddenproperty(terrain, "Decoration", false) end
                    end)
                end
            end)
        end
        -- Reset materials
        if s["Reset Materials"] then
            pcall(function()
                for _, v in pairs(MaterialService:GetChildren()) do pcall(function() v:Destroy() end) end
                MaterialService.Use2022Materials = false
            end)
        end
        -- No clothes / hair / accessories (destroy these)
        if s["No Clothes"] then
            local function stripChar(char)
                if not char then return end
                for _, v in pairs(char:GetChildren()) do
                    if v:IsA("Clothing")
                    or v:IsA("Accessory")
                    or v:IsA("Hat")
                    or v:IsA("ShirtGraphic")
                    or v:IsA("BodyColors")
                    or v:IsA("SurfaceAppearance") then
                        pcall(function() v:Destroy() end)
                    end
                end
            end
            -- run on existing players
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl.Character then stripChar(pl.Character) end
            end
            -- connect for new chars
            Players.PlayerAdded:Connect(function(pl)
                pl.CharacterAdded:Connect(function(c) task.wait(0.1); stripChar(c) end)
            end)
            -- also local player char
            if LocalPlayer.Character then stripChar(LocalPlayer.Character) end
            LocalPlayer.CharacterAdded:Connect(function(c) task.wait(0.1); stripChar(c) end)
        end

        -- low quality parts & models
        if s["Low Quality Parts"] then
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsA("MeshPart") then
                    pcall(function() v.Material = Enum.Material.Plastic; v.Reflectance = 0 end)
                end
                if v:IsA("Model") and s["Low Quality Models"] then
                    pcall(function() v.LevelOfDetail = 1 end)
                end
            end
        end

        -- watch new descendants and apply simple rules (optional)
        workspace.DescendantAdded:Connect(function(inst)
            -- quick treatments
            if inst:IsA("PostEffect") and s["No Camera Effects"] then
                pcall(function() inst.Enabled = false end)
            elseif inst:IsA("Clothing") and s["No Clothes"] then
                pcall(function() inst:Destroy() end)
            elseif inst:IsA("Accessory") and s["No Clothes"] then
                pcall(function() inst:Destroy() end)
            elseif inst:IsA("BasePart") and s["Low Quality Parts"] then
                pcall(function() inst.Material = Enum.Material.Plastic; inst.Reflectance = 0 end)
            end
        end)
    end
end

-- ========== KEYBINDS (for AutoBat & PlaceBlock) ==========
do
    -- small keybind setter UI: click a button to set keybind (we use rightCol top area for simplicity)
    local function makeKeybindButton(parent, y, label, initialKey, setFunc)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1,0,0,26)
        btn.Position = UDim2.new(0,0,0,y)
        btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
        btn.TextColor3 = Color3.fromRGB(220,220,220)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.Text = label .. " : [ "..(initialKey and initialKey.Name or "None").." ]"
        local corner = Instance.new("UICorner", btn); corner.CornerRadius = UDim.new(0,6)
        local waiting = false
        btn.MouseButton1Click:Connect(function()
            if waiting then return end
            waiting = true
            btn.Text = "Press a key..."
            local conn
            conn = UserInputService.InputBegan:Connect(function(input, gp)
                if not gp and input.UserInputType == Enum.UserInputType.Keyboard then
                    setFunc(input.KeyCode)
                    btn.Text = label .. " : [ "..input.KeyCode.Name.." ]"
                    waiting = false
                    conn:Disconnect()
                end
            end)
        end)
        return btn
    end

    -- AutoBat keybind
    local function setAutoBatKey(k)
        CONFIG.AutoBat.Keybind = k
    end
    local abKeyBtn = makeKeybindButton(rightCol, y2, "AutoBat Keybind", CONFIG.AutoBat.Keybind, setAutoBatKey); y2 = y2 + 30

    -- PlaceBlock keybind
    local function setPlaceBlockKey(k)
        CONFIG.PlaceBlock.Keybind = k
    end
    local pbKeyBtn = makeKeybindButton(rightCol, y2, "PlaceBlock Keybind", CONFIG.PlaceBlock.Keybind, setPlaceBlockKey); y2 = y2 + 30

    -- key input handling
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local code = input.KeyCode
            -- AutoBat toggle by key?
            if CONFIG.AutoBat.Keybind and code == CONFIG.AutoBat.Keybind then
                CONFIG.AutoBat.Enabled = not CONFIG.AutoBat.Enabled
                autoBatSet(CONFIG.AutoBat.Enabled)
            end
            if CONFIG.PlaceBlock.Keybind and code == CONFIG.PlaceBlock.Keybind then
                state.placeBlockKeyDown = true
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local code = input.KeyCode
            if CONFIG.PlaceBlock.Keybind and code == CONFIG.PlaceBlock.Keybind then
                state.placeBlockKeyDown = false
            end
        end
    end)
end

-- ========== MAIN POLLERS / SYNC ==========
-- apply initial visibility of steal bar
stealFrame.Visible = CONFIG.Steal.ShowBar

-- small loop to sync toggles / slider values to CONFIG
spawn(function()
    while gui.Parent do
        CONFIG.Steal.Enabled = autoStealState()
        CONFIG.Steal.ShowBar = showBarState()
        CONFIG.AutoGrab.Enabled = autoGrabState()
        CONFIG.AntiRagdoll.Enabled = antiRState()
        CONFIG.AntiRagdoll.DisableItemRemotes = antiItemState()
        CONFIG.Booster.Enabled = boosterState()
        CONFIG.AutoBat.Enabled = autoBatState()
        CONFIG.Helicopter.Enabled = heliState()
        CONFIG.Unwalk.Enabled = unwalkState()
        CONFIG.PlaceBlock.Enabled = placeBlockState()

        CONFIG.Steal.Radius = getRadius()
        CONFIG.Helicopter.SpinSpeed = getSpin()
        CONFIG.Booster.Speed = getBooster()

        -- apply heli live
        if CONFIG.Helicopter.Enabled and not state.heliAlign then
            -- enable handled by heli toggle click earlier, but ensure
            -- try to enable
            -- (call handler)
            local char = LocalPlayer.Character
            if char then
                -- trigger the click handler programmatically
                -- but safe to call: we set heliState via UI already
            end
        end

        -- apply booster connection
        if CONFIG.Booster.Enabled and not state.boosterConn then
            boosterBtn.MouseButton1Click:Fire() -- attempt to start
        end
        if not CONFIG.Booster.Enabled and state.boosterConn then
            if state.boosterConn then pcall(function() state.boosterConn:Disconnect() end); state.boosterConn=nil end
        end

        task.wait(0.35)
    end
end)

-- ========== FINAL MESSAGE IN GUI (small footer) ==========
local footer = Instance.new("TextLabel", main)
footer.Size = UDim2.new(1,0,0,16)
footer.Position = UDim2.new(0,0,1,-18)
footer.BackgroundTransparency = 1
footer.Text = "discord.gg/nZaE9w59Nx"
footer.TextSize = 12
footer.TextColor3 = Color3.fromRGB(200,200,200)
footer.Font = Enum.Font.Gotham
footer.TextXAlignment = Enum.TextXAlignment.Center

-- done
print("LXKCR Duels Hub loaded")
