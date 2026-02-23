-- LXKCR Duels V2 - BLACK & WHITE EDITION
-- Made by @ryzee2ww
-- Discord: discord.gg/nZaE9w59Nx

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local LP = Player

-- Black & White Theme Colors
local BLACK = Color3.fromRGB(0, 0, 0)
local WHITE = Color3.fromRGB(255, 255, 255)
local GRAY = Color3.fromRGB(150, 150, 150)
local DARK_GRAY = Color3.fromRGB(40, 40, 40)
local DARKER_BG = Color3.fromRGB(20, 20, 20)
local BTN_BG = Color3.fromRGB(30, 30, 30)
local BTN_OFF = Color3.fromRGB(50, 50, 50)

-- Config System
local Config = {
    Spin = false,
    SpinSpeed = 50,
    AutoGrabRadius = 20,
    Keybinds = {
        Spin = "Q",
        HitboxExpander = "H",
        SpeedBoost = "C",
        AutoGrab = "G",
        Unwalk = "X",
        PlayerESP = "E",
        Optimizer = "O",
        JumpBoost = "J",
        BatAimbot = "R",
        AntiRagdoll = "K",
        GalaxySky = "Y"
    },
    HitboxExpander = false,
    JumpBoost = false,
    SpeedBoost = false,
    AutoGrab = false,
    Optimizer = false,
    Unwalk = false,
    SpeedValue = 31,
    StealSpeed = 29,
    PlayerESP = false,
    FOV = 110,
    HitboxSize = 15,
    AntiRagdoll = false,
    InfiniteJump = false,
    AutoDuelButton = false,
    AutoDuelActive = false,
    BatAimbotButton = false,
    BatAimbotActive = false,
    BestPetESP = false,
    GalaxySky = false
}

local ConfigFileName = "LXKCR_Duels_BW_Config.json"

local function SaveConfig()
    local data = {}
    for k, v in pairs(Config) do
        data[k] = v
    end
    
    local success = false
    if writefile then
        pcall(function()
            writefile(ConfigFileName, HttpService:JSONEncode(data))
            success = true
        end)
    end
    return success
end

local function LoadConfig()
    local success = pcall(function()
        if readfile and isfile and isfile(ConfigFileName) then
            local data = HttpService:JSONDecode(readfile(ConfigFileName))
            if data then
                for k, v in pairs(data) do
                    if Config[k] ~= nil then
                        if type(v) == "table" and type(Config[k]) == "table" then
                            for k2, v2 in pairs(v) do
                                Config[k][k2] = v2
                            end
                        else
                            Config[k] = v
                        end
                    end
                end
            end
        end
    end)
    if success then
        print("📂 Config loaded from " .. ConfigFileName)
    else
        print("📂 No config found, using defaults")
    end
end

LoadConfig()

local function Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties or {}) do
        instance[k] = v
    end
    return instance
end

local function CreateStarsAnimation(parent)
    for i = 1, 25 do
        local size = math.random(2, 5)
        local star = Create("Frame", {
            BackgroundColor3 = WHITE,
            BackgroundTransparency = 0.7,
            BorderSizePixel = 0,
            Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0),
            Size = UDim2.new(0, size, 0, size),
            ZIndex = 1,
            Parent = parent
        })
        
        Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = star})
        
        task.spawn(function()
            local angle = math.random(0, 360)
            local radius = math.random(10, 50)
            local centerX = star.Position.X.Scale
            local centerY = star.Position.Y.Scale
            local speed = math.random(5, 15) / 100
            
            while star and star.Parent do
                angle = angle + speed
                local newX = centerX + math.cos(math.rad(angle)) * radius / 1000
                local newY = centerY + math.sin(math.rad(angle)) * radius / 1000
                
                TweenService:Create(star, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
                    Position = UDim2.new(newX, 0, newY, 0)
                }):Play()
                
                task.wait(0.5)
            end
        end)
        
        task.spawn(function()
            while star and star.Parent do
                local randomDelay = math.random(10, 30) / 10
                task.wait(randomDelay)
                TweenService:Create(star, TweenInfo.new(1, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = math.random(40, 90) / 100
                }):Play()
            end
        end)
    end
end

for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name == "LXKCR_Duels" or gui.Name == "LXKCR_Stats" or gui.Name == "LXKCR_Progress" or gui.Name == "LXKCR_AutoDuel" or gui.Name == "LXKCR_Open" or gui.Name == "LXKCR_BatAimbot" then
        gui:Destroy()
    end
end

-- Stats Bar
local StatsGui = Create("ScreenGui", {
    Name = "LXKCR_Stats",
    ResetOnSpawn = false,
    Parent = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local StatsBar = Create("Frame", {
    Size = UDim2.new(0, 500, 0, 30),
    Position = UDim2.new(0.5, -250, 0, 10),
    BackgroundColor3 = BLACK,
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    Parent = StatsGui
})

Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = StatsBar})

local StatsStroke = Create("UIStroke", {
    Color = WHITE,
    Thickness = 2,
    Parent = StatsBar
})

local StatsGradient = Create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, WHITE),
        ColorSequenceKeypoint.new(0.3, GRAY),
        ColorSequenceKeypoint.new(0.6, WHITE),
        ColorSequenceKeypoint.new(1, GRAY)
    }),
    Parent = StatsStroke
})

task.spawn(function()
    local rotation = 0
    while StatsBar.Parent do
        rotation = (rotation + 3) % 360
        StatsGradient.Rotation = rotation
        task.wait(0.02)
    end
end)

CreateStarsAnimation(StatsBar)

local TitleLabel = Create("TextLabel", {
    Size = UDim2.new(0, 180, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Text = "LXKCR DUELS V2",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 10,
    Parent = StatsBar
})

local DiscordLabel = Create("TextLabel", {
    Size = UDim2.new(0, 190, 1, 0),
    Position = UDim2.new(0, 195, 0, 0),
    BackgroundTransparency = 1,
    Text = "discord.gg/nZaE9w59Nx",
    TextColor3 = GRAY,
    Font = Enum.Font.GothamSemibold,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 10,
    Parent = StatsBar
})

local StatsLabel = Create("TextLabel", {
    Size = UDim2.new(1, -390, 1, 0),
    Position = UDim2.new(0, 390, 0, 0),
    BackgroundTransparency = 1,
    Text = "FPS: 60 | MS: 100",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamSemibold,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Right,
    ZIndex = 10,
    Parent = StatsBar
})

task.spawn(function()
    while true do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = math.floor(Player:GetNetworkPing() * 1000)
        StatsLabel.Text = string.format("FPS: %d | MS: %d", fps, ping)
        task.wait(1)
    end
end)

-- Progress Bar GUI (SMALLER)
local ProgressGui = Create("ScreenGui", {
    Name = "LXKCR_Progress",
    ResetOnSpawn = false,
    Parent = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local progressBar = Create("Frame", {
    Size = UDim2.new(0, 280, 0, 38),  -- SMALLER SIZE
    Position = UDim2.new(0.5, -140, 0, 48),
    BackgroundColor3 = BLACK,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Visible = Config.AutoGrab,
    Parent = ProgressGui
})

Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = progressBar})

local pStroke = Create("UIStroke", {
    Thickness = 2,
    Parent = progressBar
})

local pGrad = Create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, WHITE),
        ColorSequenceKeypoint.new(0.3, GRAY),
        ColorSequenceKeypoint.new(0.6, WHITE),
        ColorSequenceKeypoint.new(1, GRAY)
    }),
    Parent = pStroke
})

task.spawn(function()
    local r = 0
    while progressBar.Parent do
        r = (r + 3) % 360
        pGrad.Rotation = r
        task.wait(0.02)
    end
end)

for i = 1, 10 do
    local ball = Create("Frame", {
        Size = UDim2.new(0, math.random(2, 3), 0, math.random(2, 3)),
        Position = UDim2.new(math.random(3, 97) / 100, 0, math.random(15, 85) / 100, 0),
        BackgroundColor3 = WHITE,
        BackgroundTransparency = math.random(20, 50) / 100,
        BorderSizePixel = 0,
        ZIndex = 1,
        Parent = progressBar
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ball})
    
    task.spawn(function()
        local startX = ball.Position.X.Scale
        local startY = ball.Position.Y.Scale
        local phase = math.random() * math.pi * 2
        while ball.Parent do
            local t = tick() + phase
            local newX = startX + math.sin(t * (0.5 + i * 0.1)) * 0.03
            local newY = startY + math.cos(t * (0.4 + i * 0.08)) * 0.05
            ball.Position = UDim2.new(math.clamp(newX, 0.02, 0.98), 0, math.clamp(newY, 0.1, 0.9), 0)
            ball.BackgroundTransparency = 0.3 + math.sin(t * 2) * 0.2
            task.wait(0.03)
        end
    end)
end

-- READY/STEALING Label on LEFT
local ProgressLabel = Create("TextLabel", {
    Size = UDim2.new(0.4, 0, 0.5, 0),
    Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    Text = "READY",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 3,
    Parent = progressBar
})

-- PERCENTAGE Label on RIGHT
local ProgressPercentLabel = Create("TextLabel", {
    Size = UDim2.new(0.4, 0, 0.5, 0),
    Position = UDim2.new(1, -8, 0, 0),
    AnchorPoint = Vector2.new(1, 0),
    BackgroundTransparency = 1,
    Text = "0%",
    TextColor3 = GRAY,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Right,
    ZIndex = 3,
    Parent = progressBar
})

local RadiusInput = Create("TextBox", {
    Size = UDim2.new(0, 32, 0, 16),
    Position = UDim2.new(1, -36, 0, 2),
    BackgroundColor3 = DARK_GRAY,
    Text = tostring(Config.AutoGrabRadius),
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 9,
    ZIndex = 3,
    Parent = progressBar
})

Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = RadiusInput})

local pTrack = Create("Frame", {
    Size = UDim2.new(0.94, 0, 0, 6),
    Position = UDim2.new(0.03, 0, 1, -10),
    BackgroundColor3 = DARK_GRAY,
    ZIndex = 2,
    Parent = progressBar
})

Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = pTrack})

local ProgressBarFill = Create("Frame", {
    Size = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = WHITE,
    ZIndex = 2,
    Parent = pTrack
})

Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ProgressBarFill})

local FillGradient = Create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, WHITE),
        ColorSequenceKeypoint.new(0.25, GRAY),
        ColorSequenceKeypoint.new(0.5, WHITE),
        ColorSequenceKeypoint.new(0.75, GRAY),
        ColorSequenceKeypoint.new(1, WHITE)
    }),
    Parent = ProgressBarFill
})

-- Auto Duel Button GUI
local AutoDuelGui = Create("ScreenGui", {
    Name = "LXKCR_AutoDuel",
    ResetOnSpawn = false,
    Parent = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local ActiveAutoDuelBtn = Create("TextButton", {
    Size = UDim2.new(0, 120, 0, 40),
    Position = UDim2.new(1, -130, 0.5, -20),
    BackgroundColor3 = DARK_GRAY,
    Text = "ACTIVE AUTO D",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    Visible = Config.AutoDuelButton,
    Parent = AutoDuelGui
})

Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ActiveAutoDuelBtn})
Create("UIStroke", {Color = WHITE, Thickness = 2, Parent = ActiveAutoDuelBtn})

-- Bat Aimbot Button GUI
local BatAimbotGui = Create("ScreenGui", {
    Name = "LXKCR_BatAimbot",
    ResetOnSpawn = false,
    Parent = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local ActiveBatAimbotBtn = Create("TextButton", {
    Size = UDim2.new(0, 120, 0, 40),
    Position = UDim2.new(1, -130, 0.5, 30),
    BackgroundColor3 = DARK_GRAY,
    Text = "BAT AIMBOT",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    Visible = Config.BatAimbotButton,
    Parent = BatAimbotGui
})

Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ActiveBatAimbotBtn})
Create("UIStroke", {Color = GRAY, Thickness = 2, Parent = ActiveBatAimbotBtn})

-- Open Button GUI
local OpenBtnGui = Create("ScreenGui", {
    Name = "LXKCR_Open",
    ResetOnSpawn = false,
    Parent = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local OpenBtn = Create("TextButton", {
    Size = UDim2.new(0, 65, 0, 65),
    Position = UDim2.new(0, 15, 0.5, -32.5),
    BackgroundColor3 = DARKER_BG,
    BackgroundTransparency = 0.2,
    Text = "OPEN",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    Visible = false,
    Parent = OpenBtnGui
})

Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = OpenBtn})
Create("UIStroke", {Color = WHITE, Thickness = 3, Parent = OpenBtn})

-- Main GUI
local ScreenGui = Create("ScreenGui", {
    Name = "LXKCR_Duels",
    ResetOnSpawn = false,
    Parent = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local MainContainer = Create("Frame", {
    Size = UDim2.new(0, 600, 0, 400),
    Position = UDim2.new(0.5, -300, 0.5, -200),
    BackgroundTransparency = 1,
    Active = true,
    Visible = true,
    Parent = ScreenGui
})

local MainFrame = Create("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = BLACK,
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    Parent = MainContainer
})

Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = MainFrame})
Create("UIStroke", {Color = WHITE, Thickness = 2, Parent = MainFrame})
CreateStarsAnimation(MainFrame)

local TitleBar = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = BTN_BG,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    ZIndex = 10,
    Parent = MainFrame
})

Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = TitleBar})

local Title = Create("TextLabel", {
    Size = UDim2.new(0, 350, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    BackgroundTransparency = 1,
    Text = "LXKCR DUELS V2 | discord.gg/nZaE9w59Nx",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 11,
    Parent = TitleBar
})

local CloseBtn = Create("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -35, 0, 5),
    BackgroundColor3 = DARK_GRAY,
    Text = "X",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    ZIndex = 11,
    Parent = TitleBar
})

Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = CloseBtn})

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    task.wait(0.3)
    MainContainer.Visible = false
    MainContainer.Size = UDim2.new(0, 600, 0, 400)
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainContainer.Visible = true
    OpenBtn.Visible = false
    
    MainContainer.Size = UDim2.new(0, 0, 0, 0)
    MainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(MainContainer, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200)
    }):Play()
end)

local ContentFrame = Create("Frame", {
    Size = UDim2.new(1, -20, 1, -55),
    Position = UDim2.new(0, 10, 0, 45),
    BackgroundTransparency = 1,
    ZIndex = 10,
    Parent = MainFrame
})

local CombatLabel = Create("TextLabel", {
    Size = UDim2.new(0.33, -7, 0, 22),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    Text = "COMBAT",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 11,
    Parent = ContentFrame
})

local MovementLabel = Create("TextLabel", {
    Size = UDim2.new(0.33, -7, 0, 22),
    Position = UDim2.new(0.33, 3.5, 0, 0),
    BackgroundTransparency = 1,
    Text = "MOVEMENT",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 11,
    Parent = ContentFrame
})

local OtherLabel = Create("TextLabel", {
    Size = UDim2.new(0.33, -7, 0, 22),
    Position = UDim2.new(0.66, 7, 0, 0),
    BackgroundTransparency = 1,
    Text = "OTHER",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 11,
    Parent = ContentFrame
})

local CombatColumn = Create("ScrollingFrame", {
    Size = UDim2.new(0.33, -7, 1, -27),
    Position = UDim2.new(0, 0, 0, 27),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = WHITE,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ZIndex = 10,
    Parent = ContentFrame
})

local MovementColumn = Create("ScrollingFrame", {
    Size = UDim2.new(0.33, -7, 1, -27),
    Position = UDim2.new(0.33, 3.5, 0, 27),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = WHITE,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ZIndex = 10,
    Parent = ContentFrame
})

local OtherColumn = Create("ScrollingFrame", {
    Size = UDim2.new(0.33, -7, 1, -27),
    Position = UDim2.new(0.66, 7, 0, 27),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = WHITE,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ZIndex = 10,
    Parent = ContentFrame
})

for _, column in pairs({CombatColumn, MovementColumn, OtherColumn}) do
    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = column
    })
end

local changingKeybind = nil
local keybindButtons = {}

local KeybindChangeGui = Create("ScreenGui", {
    Name = "KeybindChange",
    ResetOnSpawn = false,
    Parent = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Enabled = false
})

local KeybindFrame = Create("Frame", {
    Size = UDim2.new(0, 300, 0, 120),
    Position = UDim2.new(0.5, -150, 0.5, -60),
    BackgroundColor3 = DARKER_BG,
    BorderSizePixel = 0,
    Parent = KeybindChangeGui
})

Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = KeybindFrame})
Create("UIStroke", {Color = WHITE, Thickness = 3, Parent = KeybindFrame})

local KeybindTitle = Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundTransparency = 1,
    Text = "Press any key...",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    Parent = KeybindFrame
})

local KeybindCancel = Create("TextButton", {
    Size = UDim2.new(0, 100, 0, 35),
    Position = UDim2.new(0.5, -50, 1, -45),
    BackgroundColor3 = BTN_OFF,
    Text = "CANCEL",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    Parent = KeybindFrame
})

Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = KeybindCancel})

KeybindCancel.MouseButton1Click:Connect(function()
    changingKeybind = nil
    KeybindChangeGui.Enabled = false
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not changingKeybind then return end
    
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local keyName = input.KeyCode.Name
        changingKeybind.keybind = keyName
        changingKeybind.keyLabel.Text = keyName
        Config.Keybinds[changingKeybind.configKey] = keyName
        changingKeybind = nil
        KeybindChangeGui.Enabled = false
        SaveConfig()
    end
end)

local toggleStates = {}

local function CreateToggle(parent, name, configKey, layoutOrder, callback)
    local keybind = Config.Keybinds[configKey] or "?"
    
    local ToggleFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = BTN_BG,
        BorderSizePixel = 0,
        LayoutOrder = layoutOrder,
        ZIndex = 11,
        Parent = parent
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ToggleFrame})
    Create("UIStroke", {Color = GRAY, Thickness = 1.5, Transparency = 0.5, Parent = ToggleFrame})
    
    local Label = Create("TextLabel", {
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 7, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = WHITE,
        Font = Enum.Font.GothamSemibold,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 12,
        Parent = ToggleFrame
    })
    
    local KeyLabel = Create("TextButton", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 120, 0, 9),
        BackgroundColor3 = BTN_OFF,
        Text = keybind,
        TextColor3 = WHITE,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        ZIndex = 12,
        Parent = ToggleFrame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = KeyLabel})
    
    local keybindData = {
        name = name,
        keybind = keybind,
        keyLabel = KeyLabel,
        configKey = configKey,
        callback = nil
    }
    
    table.insert(keybindButtons, keybindData)
    
    KeyLabel.MouseButton1Click:Connect(function()
        changingKeybind = keybindData
        KeybindChangeGui.Enabled = true
        KeybindTitle.Text = "Press any key for " .. name
    end)
    
    local ToggleBtn = Create("TextButton", {
        Size = UDim2.new(0, 38, 0, 20),
        Position = UDim2.new(1, -45, 0.5, -10),
        BackgroundColor3 = BTN_OFF,
        Text = "",
        ZIndex = 12,
        Parent = ToggleFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleBtn})
    
    local Circle = Create("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(200, 200, 200),
        ZIndex = 13,
        Parent = ToggleBtn
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Circle})
    
    local enabled = false
    toggleStates[configKey] = ToggleBtn
    
    local function setToggleState(state)
        enabled = state
        if enabled then
            ToggleBtn.BackgroundColor3 = WHITE
            Circle.BackgroundColor3 = BLACK
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
        else
            ToggleBtn.BackgroundColor3 = BTN_OFF
            Circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
        end
    end
    
    ToggleBtn.MouseButton1Click:Connect(function()
        setToggleState(not enabled)
        
        if callback then
            callback(enabled)
        end
        
        SaveConfig()
    end)
    
    keybindData.callback = function()
        setToggleState(not enabled)
        
        if callback then
            callback(enabled)
        end
    end
    
    return ToggleBtn, function() return enabled end, setToggleState
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or changingKeybind then return end
    
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local keyName = input.KeyCode.Name
        
        for _, keybindData in pairs(keybindButtons) do
            if keybindData.keybind == keyName and keybindData.callback then
                keybindData.callback()
            end
        end
    end
end)

local function CreateEditableSlider(parent, name, min, max, default, configKey, layoutOrder, callback)
    local SliderFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = BTN_BG,
        BorderSizePixel = 0,
        LayoutOrder = layoutOrder,
        ZIndex = 11,
        Parent = parent
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SliderFrame})
    Create("UIStroke", {Color = GRAY, Thickness = 1.5, Transparency = 0.5, Parent = SliderFrame})
    
    local Label = Create("TextLabel", {
        Size = UDim2.new(0.6, 0, 0, 18),
        Position = UDim2.new(0, 7, 0, 3),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = WHITE,
        Font = Enum.Font.GothamSemibold,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 12,
        Parent = SliderFrame
    })
    
    local ValueBox = Create("TextBox", {
        Size = UDim2.new(0, 32, 0, 16),
        Position = UDim2.new(1, -39, 0, 4),
        BackgroundColor3 = BTN_OFF,
        Text = tostring(default),
        TextColor3 = WHITE,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        ZIndex = 12,
        ClearTextOnFocus = false,
        Parent = SliderFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ValueBox})
    
    local SliderBg = Create("Frame", {
        Size = UDim2.new(1, -14, 0, 9),
        Position = UDim2.new(0, 7, 0, 28),
        BackgroundColor3 = Color3.fromRGB(25, 25, 35),
        BorderSizePixel = 0,
        ZIndex = 12,
        Parent = SliderFrame
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderBg})
    
    local SliderFill = Create("Frame", {
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = WHITE,
        BorderSizePixel = 0,
        ZIndex = 13,
        Parent = SliderBg
    })
    
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderFill})
    
    local dragging = false
    
    local function UpdateSlider(input)
        local pos = input.Position
        local relativeX = math.clamp((pos.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        
        TweenService:Create(SliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(relativeX, 0, 1, 0)
        }):Play()
        
        local actualValue = math.floor(min + (max - min) * relativeX)
        ValueBox.Text = tostring(actualValue)
        
        if configKey then
            Config[configKey] = actualValue
        end
        
        if callback then
            callback(actualValue)
        end
        
        SaveConfig()
    end
    
    SliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    ValueBox.FocusLost:Connect(function(enterPressed)
        local num = tonumber(ValueBox.Text)
        if num and num >= min and num <= max then
            local actualValue = math.floor(num)
            ValueBox.Text = tostring(actualValue)
            
            local relativeX = (actualValue - min) / (max - min)
            TweenService:Create(SliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                Size = UDim2.new(relativeX, 0, 1, 0)
            }):Play()
            
            if configKey then
                Config[configKey] = actualValue
            end
            
            if callback then
                callback(actualValue)
            end
            
            SaveConfig()
        else
            ValueBox.Text = tostring(Config[configKey] or default)
        end
    end)
    
    return SliderFill, ValueBox
end

local Connections = {}
local IsStealing = false
local StealProgress = 0
local circleParts = {}
local CIRCLE_ENABLED = false

local function createCircle()
    for _, part in ipairs(circleParts) do
        if part then part:Destroy() end
    end
    circleParts = {}
    
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local points = {}
    for i = 0, 64 do
        local angle = math.rad(i * 360 / 64)
        table.insert(points, Vector3.new(math.cos(angle), 0, math.sin(angle)) * Config.AutoGrabRadius)
    end
    
    for i = 1, #points do
        local nextIndex = i % #points + 1
        local p1 = points[i]
        local p2 = points[nextIndex]
        
        local part = Instance.new("Part")
        part.Anchored = true
        part.CanCollide = false
        part.Size = Vector3.new((p2 - p1).Magnitude, 0.2, 0.3)
        part.Color = WHITE
        part.Material = Enum.Material.Neon
        part.Transparency = 0.3
        part.TopSurface = Enum.SurfaceType.Smooth
        part.BottomSurface = Enum.SurfaceType.Smooth
        part.Parent = workspace
        table.insert(circleParts, part)
    end
end

local function updateCircle()
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local points = {}
    for i = 0, 64 do
        local angle = math.rad(i * 360 / 64)
        table.insert(points, Vector3.new(math.cos(angle), 0, math.sin(angle)) * Config.AutoGrabRadius)
    end
    
    for i, part in ipairs(circleParts) do
        local nextIndex = i % #points + 1
        local p1 = points[i]
        local p2 = points[nextIndex]
        local center = (p1 + p2) / 2 + root.Position
        
        part.CFrame = CFrame.new(center, center + Vector3.new(p2.X - p1.X, 0, p2.Z - p1.Z)) * CFrame.Angles(0, math.pi/2, 0)
    end
end

RadiusInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(RadiusInput.Text)
        if num and num >= 5 and num <= 200 then
            Config.AutoGrabRadius = math.floor(num)
            if CIRCLE_ENABLED then
                createCircle()
            end
            SaveConfig()
        else
            RadiusInput.Text = tostring(Config.AutoGrabRadius)
        end
    end
end)

local AnimalsData = require(ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Animals"))
local allAnimalsCache = {}
local PromptMemoryCache = {}
local InternalStealCache = {}

local function getHRP()
    local char = Player.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function isMyBase(plotName)
    local plot = workspace.Plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yourBase = sign:FindFirstChild("YourBase")
        if yourBase and yourBase:IsA("BillboardGui") then
            return yourBase.Enabled == true
        end
    end
    return false
end

local function scanSinglePlot(plot)
    if not plot or not plot:IsA("Model") then return end
    if isMyBase(plot.Name) then return end
    
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return end
    
    for _, podium in ipairs(podiums:GetChildren()) do
        if podium:IsA("Model") and podium:FindFirstChild("Base") then
            local animalName = "Unknown"
            local spawn = podium.Base:FindFirstChild("Spawn")
            if spawn then
                for _, child in ipairs(spawn:GetChildren()) do
                    if child:IsA("Model") and child.Name ~= "PromptAttachment" then
                        animalName = child.Name
                        local animalInfo = AnimalsData[animalName]
                        if animalInfo and animalInfo.DisplayName then
                            animalName = animalInfo.DisplayName
                        end
                        break
                    end
                end
            end
            
            table.insert(allAnimalsCache, {
                name = animalName,
                plot = plot.Name,
                slot = podium.Name,
                worldPosition = podium:GetPivot().Position,
                uid = plot.Name .. "_" .. podium.Name,
            })
        end
    end
end

local function findProximityPromptForAnimal(animalData)
    if not animalData then return nil end
    
    local cachedPrompt = PromptMemoryCache[animalData.uid]
    if cachedPrompt and cachedPrompt.Parent then
        return cachedPrompt
    end
    
    local plot = workspace.Plots:FindFirstChild(animalData.plot)
    if not plot then return nil end
    
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    
    local base = podium:FindFirstChild("Base")
    if not base then return nil end
    
    local spawn = base:FindFirstChild("Spawn")
    if not spawn then return nil end
    
    local attach = spawn:FindFirstChild("PromptAttachment")
    if not attach then return nil end
    
    for _, p in ipairs(attach:GetChildren()) do
        if p:IsA("ProximityPrompt") then
            PromptMemoryCache[animalData.uid] = p
            return p
        end
    end
    
    return nil
end

local function buildStealCallbacks(prompt)
    if InternalStealCache[prompt] then return end
    
    local data = {
        holdCallbacks = {},
        triggerCallbacks = {},
        ready = true,
    }
    
    local ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(conns1) == "table" then
        for _, conn in ipairs(conns1) do
            if type(conn.Function) == "function" then
                table.insert(data.holdCallbacks, conn.Function)
            end
        end
    end
    
    local ok2, conns2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(conns2) == "table" then
        for _, conn in ipairs(conns2) do
            if type(conn.Function) == "function" then
                table.insert(data.triggerCallbacks, conn.Function)
            end
        end
    end
    
    if (#data.holdCallbacks > 0) or (#data.triggerCallbacks > 0) then
        InternalStealCache[prompt] = data
    end
end

local function executeInternalStealAsync(prompt)
    local data = InternalStealCache[prompt]
    if not data or not data.ready then return false end
    
    data.ready = false
    IsStealing = true
    StealProgress = 0
    
    ProgressLabel.Text = "STEALING"  -- CHANGED TO "STEALING"
    
    local stealStartTime = tick()
    local progressConnection
    
    task.spawn(function()
        if #data.holdCallbacks > 0 then
            for _, fn in ipairs(data.holdCallbacks) do
                task.spawn(fn)
            end
        end
        
        progressConnection = RunService.Heartbeat:Connect(function()
            if not IsStealing then 
                if progressConnection then progressConnection:Disconnect() end
                return 
            end
            local prog = math.clamp((tick() - stealStartTime) / 1.3, 0, 1)
            StealProgress = prog
            if ProgressBarFill then ProgressBarFill.Size = UDim2.new(prog, 0, 1, 0) end
            if ProgressPercentLabel then 
                local percent = math.floor(prog * 100)
                ProgressPercentLabel.Text = percent .. "%"  -- SHOWS PERCENTAGE
            end
        end)
        
        task.wait(1.3)
        StealProgress = 1
        
        if #data.triggerCallbacks > 0 then
            for _, fn in ipairs(data.triggerCallbacks) do
                task.spawn(fn)
            end
        end
        
        if progressConnection then progressConnection:Disconnect() end
        
        if ProgressLabel then ProgressLabel.Text = "READY" end
        if ProgressPercentLabel then ProgressPercentLabel.Text = "0%" end
        if ProgressBarFill then ProgressBarFill.Size = UDim2.new(0, 0, 1, 0) end
        
        data.ready = true
        IsStealing = false
        StealProgress = 0
    end)
    
    return true
end

local function getNearestAnimal()
    local hrp = getHRP()
    if not hrp then return nil end
    
    local nearest = nil
    local minDist = math.huge
    
    for _, animalData in ipairs(allAnimalsCache) do
        if isMyBase(animalData.plot) then continue end
        
        if animalData.worldPosition then
            local dist = (hrp.Position - animalData.worldPosition).Magnitude
            if dist < minDist and dist <= Config.AutoGrabRadius then
                minDist = dist
                nearest = animalData
            end
        end
    end
    
    return nearest
end

task.wait(2)
local plots = workspace:WaitForChild("Plots", 10)
if plots then
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            scanSinglePlot(plot)
        end
    end
    
    task.spawn(function()
        while true do
            allAnimalsCache = {}
            for _, plot in ipairs(plots:GetChildren()) do
                if plot:IsA("Model") then
                    scanSinglePlot(plot)
                end
            end
            task.wait(5)
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if not Config.AutoGrab then return end
    if IsStealing then return end
    
    local targetAnimal = getNearestAnimal()
    if not targetAnimal then return end
    
    local prompt = PromptMemoryCache[targetAnimal.uid]
    if not prompt or not prompt.Parent then
        prompt = findProximityPromptForAnimal(targetAnimal)
    end
    
    if prompt then
        buildStealCallbacks(prompt)
        if InternalStealCache[prompt] then
            executeInternalStealAsync(prompt)
        end
    end
end)

local antiRagdollActive = false

local function startAntiRagdoll()
    if Connections.antiRagdoll then return end
    Connections.antiRagdoll = RunService.Heartbeat:Connect(function()
        if not antiRagdollActive then return end
        local char = Player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local humState = hum:GetState()
            if humState == Enum.HumanoidStateType.Physics or humState == Enum.HumanoidStateType.Ragdoll or humState == Enum.HumanoidStateType.FallingDown then
                hum:ChangeState(Enum.HumanoidStateType.Running)
                workspace.CurrentCamera.CameraSubject = hum
                pcall(function()
                    if Player.Character then
                        local PlayerModule = Player.PlayerScripts:FindFirstChild("PlayerModule")
                        if PlayerModule then
                            local Controls = require(PlayerModule:FindFirstChild("ControlModule"))
                            Controls:Enable()
                        end
                    end
                end)
                if root then
                    root.Velocity = Vector3.new(0, 0, 0)
                    root.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") and obj.Enabled == false then obj.Enabled = true end
        end
    end)
end

local function stopAntiRagdoll()
    if Connections.antiRagdoll then
        Connections.antiRagdoll:Disconnect()
        Connections.antiRagdoll = nil
    end
end

local galaxySkyEnabled = false

local function enableGalaxySky()
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") or obj:IsA("Atmosphere") then
            obj:Destroy()
        end
    end
    
    local sky = Instance.new("Sky", Lighting)
    sky.Name = "LXKCR_GalaxySky"
    sky.SkyboxBk = "rbxassetid://159454299"
    sky.SkyboxDn = "rbxassetid://159454296"
    sky.SkyboxFt = "rbxassetid://159454293"
    sky.SkyboxLf = "rbxassetid://159454286"
    sky.SkyboxRt = "rbxassetid://159454300"
    sky.SkyboxUp = "rbxassetid://159454288"
    sky.StarCount = 5000
    sky.SunAngularSize = 0
    sky.MoonAngularSize = 0
    
    Lighting.Ambient = Color3.fromRGB(100, 50, 150)
    Lighting.OutdoorAmbient = Color3.fromRGB(80, 40, 120)
    Lighting.Brightness = 1.5
    Lighting.ColorShift_Bottom = Color3.fromRGB(138, 43, 226)
    Lighting.ColorShift_Top = Color3.fromRGB(186, 85, 211)
end

local function disableGalaxySky()
    local galaxySky = Lighting:FindFirstChild("LXKCR_GalaxySky")
    if galaxySky then
        galaxySky:Destroy()
    end
    
    Lighting.Ambient = Color3.fromRGB(128, 128, 128)
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    Lighting.Brightness = 2
    Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
end

local performanceEnabled = false
local performanceConnections = {}

local function enablePerformance()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1000
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    Lighting.Brightness = 0
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    Lighting.Ambient = Color3.fromRGB(160,160,160)
    Lighting.OutdoorAmbient = Color3.fromRGB(160,160,160)

    for _, v in Lighting:GetChildren() do
        if v:IsA("PostEffect") then v.Enabled = false end
    end

    local function stripLocal(char)
        if not char then return end
        for _, item in char:GetChildren() do
            if item:IsA("Accessory") or item:IsA("Hat") or item:IsA("Shirt") or
               item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("CharacterMesh") or
               item:IsA("Face") then item:Destroy() end
        end
    end

    if Player.Character then stripLocal(Player.Character) end
    table.insert(performanceConnections, Player.CharacterAdded:Connect(function(char)
        task.wait(0.1) stripLocal(char)
    end))

    local globalStripLoop = task.spawn(function()
        while performanceEnabled do
            for _, model in Workspace:GetChildren() do
                if model:IsA("Model") and model:FindFirstChildWhichIsA("Humanoid") then
                    for _, item in model:GetChildren() do
                        if item:IsA("Accessory") or item:IsA("Hat") or item:IsA("CharacterMesh") or
                           item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or
                           item:IsA("Face") then item:Destroy() end
                    end
                end
            end
            task.wait(0.3)
        end
    end)
    table.insert(performanceConnections, globalStripLoop)

    local flatMaterial = Enum.Material.SmoothPlastic
    local knownClones = {}

    local function flattenAvatar(model)
        if not model then return end
        for _, part in model:GetDescendants() do
            if part:IsA("Decal") then part.Texture = "" end
            if part:IsA("BasePart") then
                part.Material = flatMaterial
                part.Color = Color3.new(1,1,1)
            end
        end
    end

    local function isCharacter(obj)
        return obj:IsA("Model") and obj:FindFirstChildWhichIsA("Humanoid") and obj:FindFirstChild("HumanoidRootPart")
    end

    local function onNewObj(obj)
        if isCharacter(obj) and not knownClones[obj] then
            knownClones[obj] = true
            task.spawn(flattenAvatar, obj)
        end
    end

    for _, obj in Workspace:GetChildren() do onNewObj(obj) end
    table.insert(performanceConnections, Workspace.ChildAdded:Connect(onNewObj))

    local function applyLowGraphics(v)
        if Player.Character and (v:IsDescendantOf(Player.Character) or v == Player.Character) then return end
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = false
        end
        if v:IsA("BasePart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        end
        if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end
    end

    for _, v in Workspace:GetDescendants() do applyLowGraphics(v) end
    table.insert(performanceConnections, Workspace.DescendantAdded:Connect(applyLowGraphics))

    local function disableAnimations(model)
        if Players:GetPlayerFromCharacter(model) then return end
        for _, v in model:GetDescendants() do
            if v:IsA("AnimationController") or v:IsA("Animator") then v:Destroy()
            elseif v:IsA("Humanoid") then v:ChangeState(Enum.HumanoidStateType.Physics) end
        end
    end

    local function reduceBrainRot(model)
        if Player.Character and (model == Player.Character or model:IsDescendantOf(Player.Character)) then return end
        if model.Name:lower():find("brainrot") then
            for _, v in model:GetDescendants() do
                if v:IsA("BasePart") then v.Material = Enum.Material.Plastic v.Reflectance = 0 end
                if v:IsA("AnimationController") or v:IsA("Animator") then v:Destroy() end
                if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end
            end
        end
    end

    local function hideEvents(model)
        if Player.Character and (model == Player.Character or model:IsDescendantOf(Player.Character)) then return end
        local n = model.Name:lower()
        if n:find("fire") or n:find("taco") or n:find("nyan") then
            for _, v in model:GetDescendants() do
                if v:IsA("BasePart") then v.Transparency = 1 end
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Sparkles") then v.Enabled = false end
                if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end
                if v:IsA("AnimationController") or v:IsA("Animator") then v:Destroy() end
            end
        end
    end

    for _, obj in Workspace:GetDescendants() do
        if obj:IsA("Model") then
            disableAnimations(obj)
            reduceBrainRot(obj)
            hideEvents(obj)
        end
    end

    table.insert(performanceConnections, Workspace.DescendantAdded:Connect(function(desc)
        if desc:IsA("Model") then
            disableAnimations(desc)
            reduceBrainRot(desc)
            hideEvents(desc)
        end
    end))
end

local function disablePerformance()
    for _, c in performanceConnections do
        if typeof(c) == "RBXScriptConnection" then c:Disconnect()
        elseif typeof(c) == "thread" then task.cancel(c) end
    end
    table.clear(performanceConnections)
end

local unwalkEnabled = false
local unwalkConnections = {}

local function enableUnwalk()
    local char = Player.Character
    if not char then return end
    
    local humanoid = char:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    
    humanoid.WalkSpeed = 16
    humanoid.JumpPower = 50
    
    local animate = char:WaitForChild("Animate", 5)
    if not animate then return end
    
    for _, v in pairs(animate:GetChildren()) do
        if v.Name ~= "idle" then
            if v:IsA("Folder") then
                for _, v2 in pairs(v:GetChildren()) do
                    if v2:IsA("StringValue") then
                        v2.Value = ""
                    end
                end
            end
        end
    end
    
    local idle = animate:FindFirstChild("idle")
    if idle then
        for _, v in pairs(idle:GetChildren()) do
            if v:IsA("StringValue") then
                v.Value = "rbxassetid://507766388"
            end
        end
    end
    
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://507766388"
    
    local loadedAnimation = humanoid:LoadAnimation(animation)
    loadedAnimation.Looped = true
    loadedAnimation.Priority = Enum.AnimationPriority.Core
    loadedAnimation:AdjustWeight(10)
    loadedAnimation:Play()
    
    local heartbeatConn = RunService.Heartbeat:Connect(function()
        if not unwalkEnabled then return end
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            if track ~= loadedAnimation then
                track:Stop(0)
            end
        end
        loadedAnimation:AdjustWeight(10)
    end)
    table.insert(unwalkConnections, heartbeatConn)
    
    local clearAnimConn = RunService.Heartbeat:Connect(function()
        if not unwalkEnabled then return end
        if animate.Parent then
            for _, v in pairs(animate:GetChildren()) do
                if v.Name ~= "idle" then
                    if v:IsA("Folder") then
                        for _, v2 in pairs(v:GetChildren()) do
                            if v2:IsA("StringValue") then
                                v2.Value = ""
                            end
                        end
                    end
                end
            end
        end
    end)
    table.insert(unwalkConnections, clearAnimConn)
end

local function disableUnwalk()
    for _, conn in ipairs(unwalkConnections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    unwalkConnections = {}
    
    local char = Player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
        end
        
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end
end

local espEnabled = false
local espConnections = {}

local function createPlayerESP(plr)
    if plr == Player then return end
    if not plr.Character then return end
    if plr.Character:FindFirstChild("LXKCR_ESP") then return end
    
    local char = plr.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not (hrp and head) then return end
    
    local hitbox = Instance.new("BoxHandleAdornment")
    hitbox.Name = "LXKCR_ESP"
    hitbox.Adornee = hrp
    hitbox.Size = Vector3.new(4, 6, 2)
    hitbox.Color3 = WHITE
    hitbox.Transparency = 0.7
    hitbox.ZIndex = 10
    hitbox.AlwaysOnTop = true
    hitbox.Parent = char
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "LXKCR_ESPLabel"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = char
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = plr.DisplayName or plr.Name
    label.TextColor3 = WHITE
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextStrokeTransparency = 0.7
    label.TextStrokeColor3 = BLACK
    label.Parent = billboard
end

local function removePlayerESP(plr)
    if not plr.Character then return end
    local hitbox = plr.Character:FindFirstChild("LXKCR_ESP")
    local nameGui = plr.Character:FindFirstChild("LXKCR_ESPLabel")
    if hitbox then hitbox:Destroy() end
    if nameGui then nameGui:Destroy() end
end

local function enablePlayerESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player then
            if plr.Character then
                createPlayerESP(plr)
            end
            local conn = plr.CharacterAdded:Connect(function()
                task.wait(0.1)
                if espEnabled then
                    createPlayerESP(plr)
                end
            end)
            table.insert(espConnections, conn)
        end
    end
    
    local playerAddedConn = Players.PlayerAdded:Connect(function(plr)
        if plr == Player then return end
        
        local charAddedConn = plr.CharacterAdded:Connect(function()
            task.wait(0.1)
            if espEnabled then
                createPlayerESP(plr)
            end
        end)
        table.insert(espConnections, charAddedConn)
    end)
    table.insert(espConnections, playerAddedConn)
end

local function disablePlayerESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        removePlayerESP(plr)
    end
    for _, conn in ipairs(espConnections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    espConnections = {}
end

local petESPEnabled = false
local petESPConnection = nil
local currentPetESP = nil

local function parseValue(text)
    text = tostring(text or ""):gsub("%s", "")
    local num, suffix = text:match("([%d%.]+)([KkMmBbTt]?)")
    if not num then return 0 end
    num = tonumber(num) or 0
    local multipliers = {K=1e3, M=1e6, B=1e9, T=1e12}
    local mult = multipliers[(suffix or ""):upper()] or 1
    return num * mult
end

local function createPetESP(part, displayText, valueText)
    if currentPetESP then
        pcall(function() currentPetESP:Destroy() end)
    end
    
    if not part then return end
    
    local bb = Instance.new("BillboardGui")
    bb.Name = "LXKCR_PetESP"
    bb.Size = UDim2.new(0, 150, 0, 40)
    bb.AlwaysOnTop = true
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.Adornee = part
    bb.Parent = CoreGui
    
    local name = Instance.new("TextLabel", bb)
    name.Size = UDim2.new(1, 0, 0, 20)
    name.BackgroundTransparency = 1
    name.Font = Enum.Font.GothamBold
    name.Text = displayText
    name.TextColor3 = WHITE
    name.TextSize = 14
    name.TextStrokeTransparency = 0.5
    
    local value = Instance.new("TextLabel", bb)
    value.Size = UDim2.new(1, 0, 0, 20)
    value.Position = UDim2.new(0, 0, 0, 20)
    value.BackgroundTransparency = 1
    value.Font = Enum.Font.GothamBold
    value.Text = valueText
    value.TextColor3 = Color3.fromRGB(0, 255, 100)
    value.TextSize = 14
    value.TextStrokeTransparency = 0.5
    
    currentPetESP = bb
end

local function enablePetESP()
    petESPConnection = task.spawn(function()
        while petESPEnabled do
            local debris = Workspace:FindFirstChild("Debris")
            if debris then
                local bestPet = {value = -1, part = nil, text = "", display = ""}
                
                for _, template in ipairs(debris:GetChildren()) do
                    if template.Name == "FastOverheadTemplate" then
                        local surfaceGui = template:FindFirstChildOfClass("SurfaceGui")
                        if surfaceGui then
                            local genLabel = surfaceGui:FindFirstChild("Generation", true)
                            if genLabel and genLabel:IsA("TextLabel") then
                                local text = genLabel.Text or ""
                                if text ~= "" and (text:find("/s") or text:find("K") or text:find("M") or text:find("B")) then
                                    local val = parseValue(text)
                                    if val > bestPet.value then
                                        local targetPart = surfaceGui.Adornee
                                        if targetPart and targetPart:IsA("BasePart") then
                                            local displayName = surfaceGui:FindFirstChild("DisplayName", true)
                                            bestPet = {
                                                part = targetPart,
                                                value = val,
                                                text = text,
                                                display = displayName and displayName.Text or "Pet"
                                            }
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                
                if bestPet.part and bestPet.part.Parent then
                    createPetESP(bestPet.part, bestPet.display, bestPet.text)
                end
            end
            
            task.wait(0.5)
        end
        
        if currentPetESP then
            pcall(function() currentPetESP:Destroy() end)
        end
    end)
end

local function disablePetESP()
    if petESPConnection then
        task.cancel(petESPConnection)
        petESPConnection = nil
    end
    
    if currentPetESP then
        pcall(function() currentPetESP:Destroy() end)
        currentPetESP = nil
    end
end

local coordESPFolder = Instance.new("Folder", workspace)
coordESPFolder.Name = "LXKCR_CoordESP"

local function createCoordMarker(position, labelText, color)
    local dot = Instance.new("Part", coordESPFolder)
    dot.Name = "CoordMarker_" .. labelText
    dot.Anchored = true
    dot.CanCollide = false
    dot.CastShadow = false
    dot.Material = Enum.Material.Neon
    dot.Color = color
    dot.Shape = Enum.PartType.Ball
    dot.Size = Vector3.new(1, 1, 1)
    dot.Position = position
    dot.Transparency = 0.2

    local bb = Instance.new("BillboardGui", dot)
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 100, 0, 20)
    bb.StudsOffset = Vector3.new(0, 2, 0)
    bb.MaxDistance = 300

    local text = Instance.new("TextLabel", bb)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = labelText
    text.TextColor3 = color
    text.TextStrokeColor3 = BLACK
    text.TextStrokeTransparency = 0
    text.Font = Enum.Font.GothamBold
    text.TextSize = 12
    text.TextScaled = false

    return dot
end

createCoordMarker(Vector3.new(-476.48, -6.28, 92.73), "L1", WHITE)
createCoordMarker(Vector3.new(-483.12, -4.95, 94.80), "L END", WHITE)
createCoordMarker(Vector3.new(-476.16, -6.52, 25.62), "R1", WHITE)
createCoordMarker(Vector3.new(-483.04, -5.09, 23.14), "R END", WHITE)

-- YOUR NEW INSTANT AUTO DUEL
local autoDuelRunning = false

local function startInstantAutoDuel()
    if autoDuelRunning then return end
    autoDuelRunning = true
    
    local function getPlayerSide()
        local hrp = getHRP()
        if not hrp then return "unknown" end
        
        if hrp.Position.Z > 60 then
            return "right"
        else
            return "left"
        end
    end
    
    local function runAutoDuel()
        if not autoDuelRunning then return end
        
        local side = getPlayerSide()
        
        local VELOCITY_SPEED = 58
        local SECOND_PHASE_SPEED = 29.4
        local JUMP_VELOCITY = 50
        
        local path
        if side == "right" then
            path = {
                {pos = Vector3.new(-470.6, -5.9, 34.4)},
                {pos = Vector3.new(-484.2, -3.9, 21.4)},
                {pos = Vector3.new(-475.6, -5.8, 29.3)},
                {pos = Vector3.new(-473.4, -5.9, 111)}
            }
        else
            path = {
                {pos = Vector3.new(-474.7, -5.9, 91.0)},
                {pos = Vector3.new(-483.4, -3.9, 97.3)},
                {pos = Vector3.new(-474.7, -5.9, 91.0)},
                {pos = Vector3.new(-476.1, -5.5, 25.4)}
            }
        end
        
        local char = Player.Character or Player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        
        for i, point in ipairs(path) do
            if not autoDuelRunning then break end
            
            local speed = i > 2 and SECOND_PHASE_SPEED or VELOCITY_SPEED
            
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not autoDuelRunning then
                    conn:Disconnect()
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    return
                end
                
                local pos = hrp.Position
                local dir = Vector3.new(point.pos.X, pos.Y, point.pos.Z) - pos
                
                if dir.Magnitude <= 2 then
                    conn:Disconnect()
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    return
                end
                
                hrp.AssemblyLinearVelocity = Vector3.new(dir.Unit.X * speed, hrp.AssemblyLinearVelocity.Y, dir.Unit.Z * speed)
            end)
            
            while autoDuelRunning and (Vector3.new(hrp.Position.X, 0, hrp.Position.Z) - Vector3.new(point.pos.X, 0, point.pos.Z)).Magnitude > 2 do
                RunService.Heartbeat:Wait()
            end
            
            if i == 2 and autoDuelRunning then
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, JUMP_VELOCITY, hrp.AssemblyLinearVelocity.Z)
                -- NO WAIT - INSTANT JUMP!
            end
            
            -- NO WAIT BETWEEN WAYPOINTS - INSTANT TRANSITIONS!
        end
        
        if autoDuelRunning then
            runAutoDuel() -- INSTANTLY RESTART LOOP
        end
    end
    
    task.spawn(runAutoDuel)
end

local function stopInstantAutoDuel()
    autoDuelRunning = false
    Config.AutoDuelActive = false
    
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
    end
    
    ActiveAutoDuelBtn.BackgroundColor3 = DARK_GRAY
end

ActiveAutoDuelBtn.MouseButton1Click:Connect(function()
    Config.AutoDuelActive = not Config.AutoDuelActive
    
    if Config.AutoDuelActive then
        ActiveAutoDuelBtn.BackgroundColor3 = WHITE
        ActiveAutoDuelBtn.TextColor3 = BLACK
        startInstantAutoDuel()
    else
        ActiveAutoDuelBtn.BackgroundColor3 = DARK_GRAY
        ActiveAutoDuelBtn.TextColor3 = WHITE
        stopInstantAutoDuel()
    end
    
    SaveConfig()
end)

-- BAT AIMBOT (OLD ORIGINAL VERSION)
local batAimbotRunning = false
local batAimbotConnection = nil
local alignOri = nil
local attach0 = nil

local function findBat()
    local c = Player.Character
    if not c then return nil end
    local bp = Player:FindFirstChildOfClass("Backpack")
    for _, ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then
            return ch
        end
    end
    if bp then
        for _, ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then
                return ch
            end
        end
    end
    return nil
end

local function getClosestTarget()
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

    local hrp = char.HumanoidRootPart
    local closest = nil
    local shortestDistance = 100

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local targetHrp = plr.Character.HumanoidRootPart
            local dist = (targetHrp.Position - hrp.Position).Magnitude

            if dist <= shortestDistance then
                shortestDistance = dist
                closest = targetHrp
            end
        end
    end
    return closest
end

local function startBatAimbot()
    if batAimbotRunning then return end
    batAimbotRunning = true
    
    local char = Player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.AutoRotate = false
    end

    attach0 = Instance.new("Attachment", hrp)

    alignOri = Instance.new("AlignOrientation")
    alignOri.Attachment0 = attach0
    alignOri.Mode = Enum.OrientationAlignmentMode.OneAttachment
    alignOri.RigidityEnabled = true
    alignOri.MaxTorque = math.huge
    alignOri.Responsiveness = 200
    alignOri.Parent = hrp

    batAimbotConnection = RunService.RenderStepped:Connect(function()
        if not batAimbotRunning then return end
        local target = getClosestTarget()
        if not target then return end

        local dist = (target.Position - hrp.Position).Magnitude
        if dist > 100 then return end

        local lookPos = Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z)
        alignOri.CFrame = CFrame.lookAt(hrp.Position, lookPos)
        
        local bat = findBat()
        if bat then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and bat.Parent ~= char then
                hum:EquipTool(bat)
            end
            pcall(function()
                bat:Activate()
            end)
        end
    end)
end

local function stopBatAimbot()
    batAimbotRunning = false
    
    if batAimbotConnection then
        batAimbotConnection:Disconnect()
        batAimbotConnection = nil
    end

    if alignOri then
        alignOri:Destroy()
        alignOri = nil
    end

    if attach0 then
        attach0:Destroy()
        attach0 = nil
    end

    local char = Player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = true
        end
    end
end

ActiveBatAimbotBtn.MouseButton1Click:Connect(function()
    Config.BatAimbotActive = not Config.BatAimbotActive
    
    if Config.BatAimbotActive then
        ActiveBatAimbotBtn.BackgroundColor3 = WHITE
        ActiveBatAimbotBtn.TextColor3 = BLACK
        startBatAimbot()
    else
        ActiveBatAimbotBtn.BackgroundColor3 = DARK_GRAY
        ActiveBatAimbotBtn.TextColor3 = WHITE
        stopBatAimbot()
    end
    
    SaveConfig()
end)

local function startSpeedBoost()
    if Connections.speed then return end
    Connections.speed = RunService.Heartbeat:Connect(function()
        if not Config.SpeedBoost then return end
        local char = Player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if humanoid and hrp then
                local moveDir = humanoid.MoveDirection
                if moveDir.Magnitude > 0 then
                    local currentStealing = LP:GetAttribute('Stealing') or false
                    local speed = currentStealing and Config.StealSpeed or Config.SpeedValue
                    local newVelocity = Vector3.new(moveDir.X, 0, moveDir.Z) * speed
                    hrp.Velocity = Vector3.new(newVelocity.X, hrp.Velocity.Y, newVelocity.Z)
                end
            end
        end
    end)
end

local function stopSpeedBoost()
    if Connections.speed then
        Connections.speed:Disconnect()
        Connections.speed = nil
    end
end

-- CREATE TOGGLES AND SLIDERS
local unwalkToggle, _, setUnwalk = CreateToggle(CombatColumn, "Unwalk", "Unwalk", 1, function(enabled)
    Config.Unwalk = enabled
    unwalkEnabled = enabled
    
    if enabled then
        enableUnwalk()
    else
        disableUnwalk()
    end
end)

local spinToggle, _, setSpin = CreateToggle(CombatColumn, "Spin", "Spin", 2, function(enabled)
    Config.Spin = enabled
    
    if enabled then
        local function addSpin(character)
            local hrp = character:WaitForChild("HumanoidRootPart")
            if hrp:FindFirstChild("LXKCR_Spin") then return end
            
            local bav = Instance.new("BodyAngularVelocity")
            bav.Name = "LXKCR_Spin"
            bav.AngularVelocity = Vector3.new(0, Config.SpinSpeed, 0)
            bav.MaxTorque = Vector3.new(0, 1e7, 0)
            bav.P = 1250
            bav.Parent = hrp
        end
        
        if Player.Character then
            addSpin(Player.Character)
        end
        
        Connections["SPIN BOT"] = Player.CharacterAdded:Connect(function(char)
            task.wait(1)
            addSpin(char)
        end)
    else
        if Connections["SPIN BOT"] then
            Connections["SPIN BOT"]:Disconnect()
            Connections["SPIN BOT"] = nil
        end
        
        if Player.Character then
            local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:FindFirstChild("LXKCR_Spin") then
                hrp.LXKCR_Spin:Destroy()
            end
        end
    end
end)

CreateEditableSlider(CombatColumn, "Spin Speed", 1, 100, Config.SpinSpeed, "SpinSpeed", 3, function(value)
    Config.SpinSpeed = value
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local spin = Player.Character.HumanoidRootPart:FindFirstChild("LXKCR_Spin")
        if spin then
            spin.AngularVelocity = Vector3.new(0, value, 0)
        end
    end
end)

local hitboxToggle, _, setHitbox = CreateToggle(CombatColumn, "Hitbox", "HitboxExpander", 4, function(enabled)
    Config.HitboxExpander = enabled
    
    if enabled then
        Connections["HITBOX"] = RunService.Heartbeat:Connect(function()
            for _, targetPlayer in ipairs(Players:GetPlayers()) do
                if targetPlayer ~= Player then
                    local character = targetPlayer.Character
                    if character then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                            hrp.Transparency = 0.5
                            hrp.Color = WHITE
                            hrp.Material = Enum.Material.ForceField
                            hrp.CanCollide = false
                            
                            if not hrp:FindFirstChild("HitboxOutline") then
                                local outline = Instance.new("SelectionBox")
                                outline.Name = "HitboxOutline"
                                outline.Adornee = hrp
                                outline.Color3 = BLACK
                                outline.LineThickness = 0.05
                                outline.Transparency = 0
                                outline.Parent = hrp
                            end
                        end
                    end
                end
            end
        end)
    else
        if Connections["HITBOX"] then
            Connections["HITBOX"]:Disconnect()
            Connections["HITBOX"] = nil
        end
        
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= Player then
                local character = targetPlayer.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                        hrp.Material = Enum.Material.Plastic
                        
                        local outline = hrp:FindFirstChild("HitboxOutline")
                        if outline then outline:Destroy() end
                    end
                end
            end
        end
    end
end)

CreateEditableSlider(CombatColumn, "Hitbox Size", 5, 30, Config.HitboxSize, "HitboxSize", 5, function(value)
    Config.HitboxSize = value
end)

local antiRagdollToggle, _, setAntiRagdoll = CreateToggle(CombatColumn, "Anti Ragdoll", "AntiRagdoll", 6, function(enabled)
    Config.AntiRagdoll = enabled
    antiRagdollActive = enabled
    
    if enabled then
        startAntiRagdoll()
    else
        stopAntiRagdoll()
    end
end)

local batAimbotToggle, _, setBatAimbot = CreateToggle(CombatColumn, "Bat Aimbot", "BatAimbot", 7, function(enabled)
    Config.BatAimbotButton = enabled
    ActiveBatAimbotBtn.Visible = enabled
    
    if not enabled then
        stopBatAimbot()
        Config.BatAimbotActive = false
        ActiveBatAimbotBtn.BackgroundColor3 = DARK_GRAY
        ActiveBatAimbotBtn.TextColor3 = WHITE
    end
    
    SaveConfig()
end)

local instaGrabToggle, _, setInstaGrab = CreateToggle(MovementColumn, "Insta Grab", "AutoGrab", 1, function(enabled)
    Config.AutoGrab = enabled
    progressBar.Visible = enabled
    
    if enabled then
        CIRCLE_ENABLED = true
        createCircle()
        
        if Player.Character then
            RunService:BindToRenderStep("CircleFollow", Enum.RenderPriority.Camera.Value + 1, function()
                updateCircle()
            end)
        end
    else
        CIRCLE_ENABLED = false
        RunService:UnbindFromRenderStep("CircleFollow")
        for _, part in ipairs(circleParts) do
            if part then part:Destroy() end
        end
        circleParts = {}
    end
end)

local speedToggle, _, setSpeed = CreateToggle(MovementColumn, "Speed Boost", "SpeedBoost", 2, function(enabled)
    Config.SpeedBoost = enabled
    
    if enabled then
        startSpeedBoost()
    else
        stopSpeedBoost()
    end
end)

CreateEditableSlider(MovementColumn, "Speed Value", 16, 100, Config.SpeedValue, "SpeedValue", 3, function(value)
    Config.SpeedValue = value
end)

CreateEditableSlider(MovementColumn, "Steal Speed", 16, 100, Config.StealSpeed, "StealSpeed", 4, function(value)
    Config.StealSpeed = value
end)

local jumpToggle, _, setJump = CreateToggle(MovementColumn, "Jump Boost", "JumpBoost", 5, function(enabled)
    Config.JumpBoost = enabled
    
    local TARGET_GRAVITY = 30
    local DEFAULT_GRAVITY = 196.2
    local jumpForceName = "LXKCR_JumpLift"
    
    if enabled then
        Connections["JUMP"] = RunService.Heartbeat:Connect(function()
            local char = Player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hrp and hum then
                    local existingForce = hrp:FindFirstChild(jumpForceName)
                    if not existingForce then
                        local bf = Instance.new("BodyForce")
                        bf.Name = jumpForceName
                        local liftAmount = (DEFAULT_GRAVITY - TARGET_GRAVITY)
                        bf.Force = Vector3.new(0, liftAmount * hrp:GetMass(), 0)
                        bf.Parent = hrp
                    end
                    
                    hum.UseJumpPower = true
                    hum.JumpPower = 50
                end
            end
        end)
    else
        if Connections["JUMP"] then
            Connections["JUMP"]:Disconnect()
            Connections["JUMP"] = nil
        end
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local force = char.HumanoidRootPart:FindFirstChild(jumpForceName)
            if force then force:Destroy() end
        end
    end
end)

local infJumpToggle, _, setInfJump = CreateToggle(MovementColumn, "Infinite Jump", "InfiniteJump", 6, function(enabled)
    Config.InfiniteJump = enabled
    
    local jumpForce = 50
    local clampFallSpeed = 80
    
    if enabled then
        Connections["INF JUMP FALL"] = RunService.Heartbeat:Connect(function()
            local char = Player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Velocity.Y < -clampFallSpeed then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, -clampFallSpeed, hrp.Velocity.Z)
            end
        end)
        
        Connections["INF JUMP"] = UserInputService.JumpRequest:Connect(function()
            local char = Player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpForce, hrp.Velocity.Z)
            end
        end)
    else
        if Connections["INF JUMP"] then
            Connections["INF JUMP"]:Disconnect()
            Connections["INF JUMP"] = nil
        end
        if Connections["INF JUMP FALL"] then
            Connections["INF JUMP FALL"]:Disconnect()
            Connections["INF JUMP FALL"] = nil
        end
    end
end)

local autoDuelToggle, _, setAutoDuel = CreateToggle(MovementColumn, "Auto Duel", "AutoDuelButton", 7, function(enabled)
    Config.AutoDuelButton = enabled
    ActiveAutoDuelBtn.Visible = enabled
    
    if not enabled then
        stopInstantAutoDuel()
    end
    
    SaveConfig()
end)

-- REMOVED AUTO DUEL SPEED SLIDER (as requested)

local VisualLabel = Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 18),
    BackgroundTransparency = 1,
    Text = "VISUAL",
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    LayoutOrder = 1,
    ZIndex = 11,
    Parent = OtherColumn
})

local espToggle, _, setESP = CreateToggle(OtherColumn, "Player ESP", "PlayerESP", 2, function(enabled)
    Config.PlayerESP = enabled
    espEnabled = enabled
    
    if enabled then
        enablePlayerESP()
    else
        disablePlayerESP()
    end
end)

local petESPToggle, _, setPetESP = CreateToggle(OtherColumn, "Pet ESP", "BestPetESP", 3, function(enabled)
    Config.BestPetESP = enabled
    petESPEnabled = enabled
    
    if enabled then
        enablePetESP()
    else
        disablePetESP()
    end
end)

local galaxySkyToggle, _, setGalaxySky = CreateToggle(OtherColumn, "Galaxy Sky", "GalaxySky", 4, function(enabled)
    Config.GalaxySky = enabled
    galaxySkyEnabled = enabled
    
    if enabled then
        enableGalaxySky()
    else
        disableGalaxySky()
    end
end)

CreateEditableSlider(OtherColumn, "FOV", 70, 120, Config.FOV, "FOV", 5, function(value)
    Config.FOV = value
    workspace.CurrentCamera.FieldOfView = value
end)

local optimizerToggle, _, setOptimizer = CreateToggle(OtherColumn, "Optimizer", "Optimizer", 6, function(enabled)
    Config.Optimizer = enabled
    performanceEnabled = enabled
    
    if enabled then
        enablePerformance()
    else
        disablePerformance()
    end
end)

task.spawn(function()
    task.wait(2)
    
    if Config.Unwalk then setUnwalk(true) unwalkEnabled = true enableUnwalk() end
    if Config.Spin then setSpin(true) end
    if Config.HitboxExpander then setHitbox(true) end
    if Config.AutoGrab then setInstaGrab(true) end
    if Config.SpeedBoost then setSpeed(true) startSpeedBoost() end
    if Config.JumpBoost then setJump(true) end
    if Config.InfiniteJump then setInfJump(true) end
    if Config.AutoDuelButton then setAutoDuel(true) ActiveAutoDuelBtn.Visible = true end
    if Config.PlayerESP then setESP(true) espEnabled = true enablePlayerESP() end
    if Config.BestPetESP then setPetESP(true) petESPEnabled = true enablePetESP() end
    if Config.Optimizer then setOptimizer(true) performanceEnabled = true enablePerformance() end
    if Config.BatAimbotButton then setBatAimbot(true) ActiveBatAimbotBtn.Visible = true end
    if Config.AntiRagdoll then setAntiRagdoll(true) antiRagdollActive = true startAntiRagdoll() end
    if Config.GalaxySky then setGalaxySky(true) galaxySkyEnabled = true enableGalaxySky() end
    
    if Config.AutoDuelActive then
        ActiveAutoDuelBtn.BackgroundColor3 = WHITE
        ActiveAutoDuelBtn.TextColor3 = BLACK
        startInstantAutoDuel()
    end
    
    if Config.BatAimbotActive then
        ActiveBatAimbotBtn.BackgroundColor3 = WHITE
        ActiveBatAimbotBtn.TextColor3 = BLACK
        startBatAimbot()
    end
    
    workspace.CurrentCamera.FieldOfView = Config.FOV
    
    print("✅ BLACK & WHITE EDITION - All settings loaded")
end)

local dragging, dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainContainer.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightControl then
        if MainContainer.Visible then
            TweenService:Create(MainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            
            task.wait(0.3)
            MainContainer.Visible = false
            MainContainer.Size = UDim2.new(0, 600, 0, 400)
            OpenBtn.Visible = true
        else
            MainContainer.Visible = true
            OpenBtn.Visible = false
            
            MainContainer.Size = UDim2.new(0, 0, 0, 0)
            MainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            TweenService:Create(MainContainer, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 600, 0, 400),
                Position = UDim2.new(0.5, -300, 0.5, -200)
            }):Play()
        end
    end
end)

Player.CharacterAdded:Connect(function()
    task.wait(1)
    if CIRCLE_ENABLED then
        createCircle()
        RunService:BindToRenderStep("CircleFollow", Enum.RenderPriority.Camera.Value + 1, function()
            updateCircle()
        end)
    end
    
    if unwalkEnabled then
        task.wait(0.5)
        enableUnwalk()
    end
    
    if espEnabled then
        task.wait(0.5)
        enablePlayerESP()
    end
    
    if Config.Spin then
        task.wait(0.5)
        local hrp = Player.Character:WaitForChild("HumanoidRootPart")
        if hrp:FindFirstChild("LXKCR_Spin") then return end
        
        local bav = Instance.new("BodyAngularVelocity")
        bav.Name = "LXKCR_Spin"
        bav.AngularVelocity = Vector3.new(0, Config.SpinSpeed, 0)
        bav.MaxTorque = Vector3.new(0, 1e7, 0)
        bav.P = 1250
        bav.Parent = hrp
    end
end)

print("✅ LXKCR DUELS V2 - BLACK & WHITE EDITION LOADED!")
print("🖤 Full black & white theme!")
print("⚡ Your instant auto duel integrated!")
print("📊 Smaller progress bar with READY/STEALING text + percentage!")
print("🚫 Auto Duel Speed slider removed!")
print("💬 Discord: discord.gg/nZaE9w59Nx")
print("⌨️ Press RIGHT CTRL to toggle GUI")
