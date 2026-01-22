local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer

--================ GUI =================--

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LXKCR_BOOST_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 160)
mainFrame.Position = UDim2.new(0.78, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 25, 80)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner", mainFrame)
frameCorner.CornerRadius = UDim.new(0,12)

local frameStroke = Instance.new("UIStroke", mainFrame)
frameStroke.Thickness = 2
frameStroke.Color = Color3.fromRGB(180,130,255)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-10,0,26)
title.Position = UDim2.new(0,5,0,6)
title.BackgroundTransparency = 1
title.Text = "LXKCR BOOST"
title.Font = Enum.Font.GothamBlack
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(235,215,255)
title.Parent = mainFrame

--================ MINIMIZE BUTTON =================--

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Position = UDim2.new(1, -28, 0, 4)
MinBtn.BackgroundColor3 = Color3.fromRGB(200,180,255)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.TextColor3 = Color3.fromRGB(50,20,80)
MinBtn.BorderSizePixel = 0
MinBtn.Parent = mainFrame

local minBtnCorner = Instance.new("UICorner", MinBtn)
minBtnCorner.CornerRadius = UDim.new(0,6)

--================ CONTAINER ===================

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1,0,1,-40)
Container.Position = UDim2.new(0,0,0,40)
Container.BackgroundTransparency = 1
Container.Parent = mainFrame

--================ TEXTBOXES ==================

local boosterBox = Instance.new("TextBox")
boosterBox.Size = UDim2.new(1,-20,0,28)
boosterBox.Position = UDim2.new(0,10,0,0)
boosterBox.BackgroundColor3 = Color3.fromRGB(70,45,100)
boosterBox.Text = "25"
boosterBox.Font = Enum.Font.GothamBold
boosterBox.TextSize = 14
boosterBox.TextColor3 = Color3.fromRGB(235,215,255)
boosterBox.ClearTextOnFocus = false
boosterBox.BorderSizePixel = 0
boosterBox.Parent = Container

local boosterCorner = Instance.new("UICorner", boosterBox)
boosterCorner.CornerRadius = UDim.new(0,6)

local boosterStrokeBox = Instance.new("UIStroke", boosterBox)
boosterStrokeBox.Color = Color3.fromRGB(180,130,255)

local stealingBox = Instance.new("TextBox")
stealingBox.Size = UDim2.new(1,-20,0,28)
stealingBox.Position = UDim2.new(0,10,0,35)
stealingBox.BackgroundColor3 = Color3.fromRGB(70,45,100)
stealingBox.Text = "30"
stealingBox.Font = Enum.Font.GothamBold
stealingBox.TextSize = 14
stealingBox.TextColor3 = Color3.fromRGB(235,215,255)
stealingBox.ClearTextOnFocus = false
stealingBox.BorderSizePixel = 0
stealingBox.Parent = Container

local stealingCorner = Instance.new("UICorner", stealingBox)
stealingCorner.CornerRadius = UDim.new(0,6)

local stealingStrokeBox = Instance.new("UIStroke", stealingBox)
stealingStrokeBox.Color = Color3.fromRGB(180,130,255)

--================ TOGGLES ==================

local boosterToggle = Instance.new("TextButton")
boosterToggle.Size = UDim2.new(0,80,0,28)
boosterToggle.Position = UDim2.new(0,10,0,70)
boosterToggle.BackgroundColor3 = Color3.fromRGB(90,60,130)
boosterToggle.Text = "BOOSTER"
boosterToggle.Font = Enum.Font.GothamBold
boosterToggle.TextSize = 14
boosterToggle.TextColor3 = Color3.fromRGB(240,225,255)
boosterToggle.Parent = Container

local boosterBtnCorner = Instance.new("UICorner", boosterToggle)
boosterBtnCorner.CornerRadius = UDim.new(0,6)

local boosterStrokeEffect = Instance.new("UIStroke")
boosterStrokeEffect.Thickness = 2
boosterStrokeEffect.Color = Color3.fromRGB(180,130,255)
boosterStrokeEffect.Parent = boosterToggle

local stealingToggle = Instance.new("TextButton")
stealingToggle.Size = UDim2.new(0,80,0,28)
stealingToggle.Position = UDim2.new(0,90,0,70)
stealingToggle.BackgroundColor3 = Color3.fromRGB(90,60,130)
stealingToggle.Text = "STEALING"
stealingToggle.Font = Enum.Font.GothamBold
stealingToggle.TextSize = 14
stealingToggle.TextColor3 = Color3.fromRGB(240,225,255)
stealingToggle.Parent = Container

local stealingBtnCorner = Instance.new("UICorner", stealingToggle)
stealingBtnCorner.CornerRadius = UDim.new(0,6)

local stealingStrokeEffect = Instance.new("UIStroke")
stealingStrokeEffect.Thickness = 2
stealingStrokeEffect.Color = Color3.fromRGB(180,130,255)
stealingStrokeEffect.Parent = stealingToggle

--================ FOOTER ==================

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1,-10,0,16)
footer.Position = UDim2.new(0,5,1,-18)
footer.BackgroundTransparency = 1
footer.Text = "discord.gg/nZaE9w59Nx"
footer.Font = Enum.Font.Gotham
footer.TextSize = 11
footer.TextColor3 = Color3.fromRGB(200,180,255)
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.Parent = mainFrame

--================ BOOST LOGIC ==================

local boosterEnabled = false
local stealingEnabled = false
local boosterSpeed = tonumber(boosterBox.Text) or 25
local stealingSpeed = tonumber(stealingBox.Text) or 30
local savedBoosterSpeed = boosterSpeed
local boosterConn

boosterBox.FocusLost:Connect(function()
	local num = tonumber(boosterBox.Text)
	if num and num>0 then
		boosterSpeed = num
		savedBoosterSpeed = num
		boosterBox.Text = tostring(num)
	else
		boosterBox.Text = tostring(boosterSpeed)
	end
end)

stealingBox.FocusLost:Connect(function()
	local num = tonumber(stealingBox.Text)
	if num and num>0 then
		stealingSpeed = num
		stealingBox.Text = tostring(num)
	end
end)

--================ BOOSTER TOGGLE ==================

local boosterNormalColor = Color3.fromRGB(90,60,130)
local boosterActiveColor = Color3.fromRGB(255,255,255)
local boosterNormalTextColor = Color3.fromRGB(240,225,255)
local boosterActiveTextColor = Color3.fromRGB(0,0,0)

boosterToggle.MouseButton1Click:Connect(function()
	boosterEnabled = not boosterEnabled
	if boosterEnabled then
		TweenService:Create(
			boosterToggle,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = boosterActiveColor, TextColor3 = boosterActiveTextColor}
		):Play()
		TweenService:Create(
			boosterStrokeEffect,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Color = Color3.fromRGB(180,130,255)}
		):Play()

		if boosterConn then boosterConn:Disconnect() end
		boosterConn = RunService.Heartbeat:Connect(function()
			local char = LocalPlayer.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChildOfClass("Humanoid")
			if not hrp or not hum then return end
			if hum.MoveDirection.Magnitude>0 then
				local vel = hrp.Velocity
				local dir = hum.MoveDirection
				hrp.Velocity = Vector3.new(dir.X*boosterSpeed, vel.Y, dir.Z*boosterSpeed)
			end
		end)
	else
		TweenService:Create(
			boosterToggle,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = boosterNormalColor, TextColor3 = boosterNormalTextColor}
		):Play()
		TweenService:Create(
			boosterStrokeEffect,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Color = Color3.fromRGB(180,130,255)}
		):Play()
		if boosterConn then boosterConn:Disconnect() boosterConn=nil end
	end
end)

--================ STEALING ATTRIBUTE ==================

local normalColor = Color3.fromRGB(90,60,130)
local activeColor = Color3.fromRGB(255,255,255)
local normalTextColor = Color3.fromRGB(240,225,255)
local activeTextColor = Color3.fromRGB(0,0,0)

local function startStealing()
	if boosterEnabled then
		savedBoosterSpeed = boosterSpeed
		boosterSpeed = stealingSpeed
	else
		boosterSpeed = stealingSpeed
		if boosterConn then boosterConn:Disconnect() end
		boosterConn = RunService.Heartbeat:Connect(function()
			local char = LocalPlayer.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hrp and hum and hum.MoveDirection.Magnitude>0 then
				local vel = hrp.Velocity
				local dir = hum.MoveDirection
				hrp.Velocity = Vector3.new(dir.X*boosterSpeed, vel.Y, dir.Z*boosterSpeed)
			end
		end)
	end
end

local function resetStealing()
	if boosterEnabled then
		boosterSpeed = savedBoosterSpeed
	else
		if boosterConn then boosterConn:Disconnect() boosterConn=nil end
	end
end

LocalPlayer:SetAttribute("Stealing", false)
LocalPlayer:GetAttributeChangedSignal('Stealing'):Connect(function()
	local currentStealing = LocalPlayer:GetAttribute('Stealing') or false
	if currentStealing then
		startStealing()
		TweenService:Create(
			stealingToggle,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = activeColor, TextColor3 = activeTextColor}
		):Play()
		TweenService:Create(
			stealingStrokeEffect,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Color = Color3.fromRGB(180,130,255)}
		):Play()
	else
		resetStealing()
		TweenService:Create(
			stealingToggle,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = normalColor, TextColor3 = normalTextColor}
		):Play()
		TweenService:Create(
			stealingStrokeEffect,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Color = Color3.fromRGB(180,130,255)}
		):Play()
	end
end)

--================ DRAG ==================

local dragging, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=false
	end
end)

--================ MINIMIZE FUNCTION ==================

local minimized = false
local normalSize = mainFrame.Size
local miniSize = UDim2.new(mainFrame.Size.X.Scale, mainFrame.Size.X.Offset, 0, 40)

MinBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		Container.Visible = false
		footer.Visible = false
		TweenService:Create(
			mainFrame,
			TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			{Size = miniSize}
		):Play()
	else
		Container.Visible = true
		footer.Visible = true
		TweenService:Create(
			mainFrame,
			TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			{Size = normalSize}
		):Play()
	end
end)

--================ SNOW EFFECT ==================

task.spawn(function()
	while mainFrame.Parent do
		local snow = Instance.new("Frame")
		snow.Size = UDim2.new(0,2,0,2)
		snow.BackgroundColor3 = Color3.fromRGB(245,235,255)
		snow.BorderSizePixel = 0
		snow.Position = UDim2.new(math.random(),0,0,-5)
		snow.Parent = mainFrame

		TweenService:Create(snow, TweenInfo.new(math.random(2,4)),{
			Position = UDim2.new(snow.Position.X.Scale,0,1,10),
			BackgroundTransparency = 1
		}):Play()

		Debris:AddItem(snow,4)
		task.wait(0.1)
	end
end)
