--// LXKCR BOOST | Velocity Booster
--// Stealing Attribute Support

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer

-- File
local FILE_NAME = "LXKCR_Settings.json"

-- Load settings
local Settings = { Speed = 25 }
pcall(function()
    if readfile(FILE_NAME) then
        Settings = HttpService:JSONDecode(readfile(FILE_NAME))
    end
end)

local function Save()
    writefile(FILE_NAME, HttpService:JSONEncode(Settings))
end

-- GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "LXKCR_Boost"
GUI.ResetOnSpawn = false
GUI.Parent = LP:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 165, 0, 110)
MainFrame.Position = UDim2.new(1, -180, 0.32, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12,12,12)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = GUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,10)

-- Stroke + Gradient
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(170,120,255)
Stroke.Thickness = 2
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local Gradient = Instance.new("UIGradient", Stroke)
Gradient.Color = ColorSequence.new(
    Color3.fromRGB(170,120,255),
    Color3.fromRGB(0,0,0)
)

TweenService:Create(
    Gradient,
    TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
    {Rotation = 360}
):Play()

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,26)
Title.BackgroundTransparency = 1
Title.Text = "LXKCR BOOST"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextColor3 = Color3.new(1,1,1)

-- Speed Box
local SpeedBox = Instance.new("TextBox", MainFrame)
SpeedBox.Size = UDim2.new(1,-24,0,26)
SpeedBox.Position = UDim2.new(0,12,0,34)
SpeedBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
SpeedBox.TextColor3 = Color3.new(1,1,1)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 14
SpeedBox.TextXAlignment = Enum.TextXAlignment.Center
SpeedBox.ClearTextOnFocus = false
SpeedBox.Text = tostring(Settings.Speed)
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0,6)
Instance.new("UIStroke", SpeedBox).Color = Color3.fromRGB(170,120,255)

SpeedBox:GetPropertyChangedSignal("Text"):Connect(function()
    local v = tonumber(SpeedBox.Text)
    if v then
        Settings.Speed = v
        Save()
    end
end)

-- Toggle
local Toggle = Instance.new("Frame", MainFrame)
Toggle.Size = UDim2.new(0,52,0,22)
Toggle.Position = UDim2.new(0.5,-26,0,66)
Toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1,0)

local Knob = Instance.new("Frame", Toggle)
Knob.Size = UDim2.new(0,18,0,18)
Knob.Position = UDim2.new(0,2,0.5,-9)
Knob.BackgroundColor3 = Color3.fromRGB(170,120,255)
Instance.new("UICorner", Knob).CornerRadius = UDim.new(1,0)

-- Footer
local Footer = Instance.new("TextLabel", MainFrame)
Footer.BackgroundTransparency = 1
Footer.Position = UDim2.new(0,0,1,-16)
Footer.Size = UDim2.new(1,0,0,14)
Footer.Font = Enum.Font.GothamMedium
Footer.TextSize = 10
Footer.TextColor3 = Color3.fromRGB(100,100,100)
Footer.Text = "discord.gg/juaasMbSD7"
Footer.TextXAlignment = Enum.TextXAlignment.Center

-- Logic
local Enabled = false
local BoostConn

local function UpdateToggle()
    Knob:TweenPosition(
        Enabled and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.15,
        true
    )
end

local function DisableBoost()
    Enabled = false
    UpdateToggle()
    if BoostConn then
        BoostConn:Disconnect()
        BoostConn = nil
    end
end

local function EnableBoost()
    Enabled = true
    UpdateToggle()
    BoostConn = RunService.RenderStepped:Connect(function()
        local Char = LP.Character
        if not Char then return end

        local HRP = Char:FindFirstChild("HumanoidRootPart")
        local Hum = Char:FindFirstChild("Humanoid")
        if not HRP or not Hum then return end

        local Dir = Hum.MoveDirection
        if Dir.Magnitude > 0 then
            HRP.AssemblyLinearVelocity = Vector3.new(
                Dir.X * Settings.Speed,
                HRP.AssemblyLinearVelocity.Y,
                Dir.Z * Settings.Speed
            )
        end
    end)
end

-- Toggle Click
Toggle.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
    and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    -- Stealing lock
    if LP:GetAttribute("Stealing") then
        DisableBoost()
        return
    end

    if Enabled then
        DisableBoost()
    else
        EnableBoost()
    end
end)

-- Stealing Attribute Listener (החלק החשוב)
LP:GetAttributeChangedSignal("Stealing"):Connect(function()
    if LP:GetAttribute("Stealing") then
        DisableBoost()
    end
end)

-- Initial check
if LP:GetAttribute("Stealing") then
    DisableBoost()
end
