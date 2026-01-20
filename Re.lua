-- LXKCR Auto Bat

local Players = game:GetService('Players')
local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local RunService = game:GetService('RunService')

local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new('ScreenGui')
ScreenGui.Name = 'LXKCR_AutoBat'
ScreenGui.Parent = game:GetService('CoreGui')
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainColor = Color3.fromRGB(138, 43, 226) -- סגול
local textColor = Color3.fromRGB(240, 240, 240)
local textColorSecondary = Color3.fromRGB(150, 150, 150)

local MainFrame = Instance.new('Frame', ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 140)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -60)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0

local Corner = Instance.new('UICorner', MainFrame)
Corner.CornerRadius = UDim.new(0, 8)

local Stroke = Instance.new('UIStroke', MainFrame)
Stroke.Color = mainColor
Stroke.Thickness = 1.5
Stroke.Transparency = 0.5

-- Draggable functionality
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Title
local Title = Instance.new('TextLabel', MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = 'LXKCR Auto Bat'
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = textColor

-- Auto Bat Button
local AutoBatButton = Instance.new('TextButton', MainFrame)
AutoBatButton.Size = UDim2.new(1, -20, 0, 35)
AutoBatButton.Position = UDim2.new(0, 10, 0, 35)
AutoBatButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
AutoBatButton.AutoButtonColor = false
AutoBatButton.Text = ''

local ButtonCorner = Instance.new('UICorner', AutoBatButton)
ButtonCorner.CornerRadius = UDim.new(0, 6)

local ButtonLabel = Instance.new('TextLabel', AutoBatButton)
ButtonLabel.Size = UDim2.new(1, -40, 1, 0)
ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
ButtonLabel.BackgroundTransparency = 1
ButtonLabel.Text = 'Auto Bat'
ButtonLabel.Font = Enum.Font.GothamMedium
ButtonLabel.TextSize = 12
ButtonLabel.TextColor3 = textColorSecondary
ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left

local ToggleFrame = Instance.new('Frame', AutoBatButton)
ToggleFrame.Size = UDim2.new(0, 20, 0, 20)
ToggleFrame.Position = UDim2.new(1, -30, 0.5, -10)
ToggleFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

local ToggleCorner = Instance.new('UICorner', ToggleFrame)
ToggleCorner.CornerRadius = UDim.new(0, 4)

local ToggleInner = Instance.new('Frame', ToggleFrame)
ToggleInner.Size = UDim2.new(1, -4, 1, -4)
ToggleInner.Position = UDim2.new(0, 2, 0, 2)
ToggleInner.BackgroundColor3 = mainColor
ToggleInner.BackgroundTransparency = 1

local ToggleInnerCorner = Instance.new('UICorner', ToggleInner)
ToggleInnerCorner.CornerRadius = UDim.new(0, 2)

-- Keybind label
local KeybindLabel = Instance.new('TextButton', MainFrame)
KeybindLabel.Size = UDim2.new(1, -20, 0, 30)
KeybindLabel.Position = UDim2.new(0, 10, 0, 80)
KeybindLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
KeybindLabel.Text = 'Keybind: [ None ]'
KeybindLabel.Font = Enum.Font.GothamBold
KeybindLabel.TextSize = 12
KeybindLabel.TextColor3 = textColorSecondary

local KeybindCorner = Instance.new('UICorner', KeybindLabel)
KeybindCorner.CornerRadius = UDim.new(0, 6)

-- Footer
local Footer = Instance.new('TextLabel', MainFrame)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = 'discord.gg/juaasMbS'
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 10
Footer.TextColor3 = Color3.fromRGB(88, 101, 242)

-- Auto Bat state
local AutoBatEnabled = false
local BatConnection

-- Function to toggle Auto Bat
local function toggleAutoBat()
    AutoBatEnabled = not AutoBatEnabled
    if AutoBatEnabled then
        ToggleInner.BackgroundTransparency = 0
        ButtonLabel.TextColor3 = textColor
        
        -- הפונקציה של ה-Bat נשארת בדיוק כמו שהיא
        BatConnection = RunService.RenderStepped:Connect(function(...)
            local _Character183 = LocalPlayer.Character
            local _call185 = _Character183:FindFirstChildOfClass('Humanoid')

            _call185:EquipTool(LocalPlayer.Backpack:FindFirstChild('Bat'))
            _Character183:FindFirstChild('Bat'):Activate()
        end)
    else
        ToggleInner.BackgroundTransparency = 1
        ButtonLabel.TextColor3 = textColorSecondary
        if BatConnection then
            BatConnection:Disconnect()
        end
    end
end

-- Button click toggle
AutoBatButton.MouseButton1Click:Connect(toggleAutoBat)

-- Keybind functionality
local CurrentKey = nil

KeybindLabel.MouseButton1Click:Connect(function()
    KeybindLabel.Text = 'Press any key...'
    KeybindLabel.TextColor3 = mainColor

    local keyConn
    keyConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            CurrentKey = input.KeyCode
            KeybindLabel.Text = 'Keybind: [ ' .. tostring(CurrentKey):gsub("Enum.KeyCode.", "") .. ' ]'
            KeybindLabel.TextColor3 = textColorSecondary
            keyConn:Disconnect()
        end
    end)
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and CurrentKey and input.KeyCode == CurrentKey then
        toggleAutoBat()
    end
end)
