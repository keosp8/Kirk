-- ts file was generated at discord.gg/25ms

local _call9 = game:GetService('TweenService')
local _LocalPlayer10 = game:GetService('Players').LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

--================ GUI =================--

local _call14 = Instance.new('ScreenGui')
_call14.Name = 'LXKCR_BOOST_GUI'
_call14.ResetOnSpawn = false
_call14.Parent = _LocalPlayer10:WaitForChild('PlayerGui')

local _call16 = Instance.new('Frame')
_call16.Name = 'Container'
_call16.Size = UDim2.new(0, 150, 0, 100)
_call16.Position = UDim2.new(0.78, 0, 0.3, 0)
_call16.BackgroundColor3 = Color3.fromRGB(50, 25, 80)
_call16.BorderSizePixel = 0
_call16.Parent = _call14

local _call24 = Instance.new('UICorner', _call16)
_call24.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", _call16)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(180, 130, 255)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 26)
title.Position = UDim2.new(0, 5, 0, 6)
title.BackgroundTransparency = 1
title.Text = "LXKCR BOOST"
title.Font = Enum.Font.GothamBlack
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(235, 215, 255)
title.Parent = _call16

local _call72 = Instance.new('TextBox')
_call72.Name = 'SpeedInput'
_call72.Size = UDim2.new(1, -20, 0, 28)
_call72.Position = UDim2.new(0, 10, 0, 40)
_call72.BackgroundColor3 = Color3.fromRGB(70, 45, 100)
_call72.Text = '25'
_call72.Font = Enum.Font.GothamBold
_call72.TextSize = 14
_call72.TextColor3 = Color3.fromRGB(235, 215, 255)
_call72.ClearTextOnFocus = false
_call72.BorderSizePixel = 0
_call72.Parent = _call16

local _call84 = Instance.new('UICorner', _call72)
_call84.CornerRadius = UDim.new(0, 6)

local _call88 = Instance.new('UIStroke', _call72)
_call88.Color = Color3.fromRGB(180, 130, 255)

-- Toggle Switch
local toggleFrame = Instance.new("Frame")
toggleFrame.Size = UDim2.new(0, 52, 0, 22)
toggleFrame.Position = UDim2.new(0.5, -26, 1, -30)
toggleFrame.BackgroundColor3 = Color3.fromRGB(90, 60, 130)
toggleFrame.Parent = _call16

local toggleCorner = Instance.new("UICorner", toggleFrame)
toggleCorner.CornerRadius = UDim.new(1, 0)

local toggleCircle = Instance.new("Frame")
toggleCircle.Size = UDim2.new(0, 18, 0, 18)
toggleCircle.Position = UDim2.new(0, 2, 0.5, -9)
toggleCircle.BackgroundColor3 = Color3.fromRGB(240, 225, 255)
toggleCircle.Parent = toggleFrame

local circleCorner = Instance.new("UICorner", toggleCircle)
circleCorner.CornerRadius = UDim.new(1, 0)

--================ SPEED LOGIC (UNCHANGED) =================--

local _Enabled = false
local _Speed = 25
local _HeartbeatConn

_call72.FocusLost:Connect(function()
	local _num = tonumber(_call72.Text)
	if _num and _num > 0 then
		_Speed = _num
		_call72.Text = tostring(_Speed)
	else
		_call72.Text = tostring(_Speed)
	end
end)

toggleFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		_Enabled = not _Enabled

		if _Enabled then
			toggleCircle:TweenPosition(
				UDim2.new(1, -20, 0.5, -9),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.15,
				true
			)

			_HeartbeatConn = RunService.Heartbeat:Connect(function()
				local _Character131 = _LocalPlayer10.Character
				if not _Character131 then return end

				local _call133 = _Character131:FindFirstChild("HumanoidRootPart")
				local _Humanoid = _Character131:FindFirstChildOfClass("Humanoid")
				if not _call133 or not _Humanoid then return end

				local _MoveDirection136 = _Humanoid.MoveDirection
				if _MoveDirection136.Magnitude > 0 then
					_call133.Velocity = Vector3.new(
						_MoveDirection136.X * _Speed,
						_call133.Velocity.Y,
						_MoveDirection136.Z * _Speed
					)
				end
			end)
		else
			toggleCircle:TweenPosition(
				UDim2.new(0, 2, 0.5, -9),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.15,
				true
			)

			if _HeartbeatConn then
				_HeartbeatConn:Disconnect()
				_HeartbeatConn = nil
			end
		end
	end
end)

--================ DRAG =================--

local dragging, dragStart, startPos

_call16.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = _call16.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		_call16.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

--================ SNOW EFFECT =================--

task.spawn(function()
	while _call16.Parent do
		local snow = Instance.new("Frame")
		snow.Size = UDim2.new(0, 2, 0, 2)
		snow.BackgroundColor3 = Color3.fromRGB(245, 235, 255)
		snow.BorderSizePixel = 0
		snow.Position = UDim2.new(math.random(), 0, 0, -5)
		snow.Parent = _call16

		_call9:Create(
			snow,
			TweenInfo.new(math.random(2, 4)),
			{
				Position = UDim2.new(snow.Position.X.Scale, 0, 1, 10),
				BackgroundTransparency = 1
			}
		):Play()

		Debris:AddItem(snow, 4)
		task.wait(0.1)
	end
end)
