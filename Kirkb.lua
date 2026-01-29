— invisble script

-- LXKCR Mini Hub | Full Invisible Script (Compact GUI)
print("LXKCR Mini Hub Manual Invisible Loaded")

-- ========== SERVICES ==========
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ========== STATE VARIABLES ==========
local connections = {SemiInvisible = {}}
local isInvisible = false
local clone, oldRoot, hip, animTrack, connection, characterConnection

-- ========== GUI ==========
for _, gui in pairs(game.CoreGui:GetChildren()) do
    if gui.Name == "LXKCR_MiniHub_ManualInvis" then gui:Destroy() end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LXKCR_MiniHub_ManualInvis"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,200,0,100)
mainFrame.Position = UDim2.new(0.5,-100,0.5,-50)
mainFrame.BackgroundColor3 = Color3.fromRGB(40,0,60)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,6)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(180,0,180)
stroke.Thickness = 1

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,24)
title.BackgroundTransparency = 1
title.Text = "LXKCR Invisble"
title.TextColor3 = Color3.fromRGB(180,0,180)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

-- Footer
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1,0,0,16)
footer.Position = UDim2.new(0,0,1,-16)
footer.BackgroundTransparency = 1
footer.Text = "discord.gg/nZaE9w59Nx"
footer.TextColor3 = Color3.fromRGB(180,0,180)
footer.Font = Enum.Font.Gotham
footer.TextSize = 12
footer.Parent = mainFrame

-- ========== STARS BACKGROUND ==========
local stars = {}
local STAR_COUNT = 30
for i=1,STAR_COUNT do
    local star = Instance.new("Frame")
    star.Size = UDim2.new(0,1,0,1)
    star.Position = UDim2.new(math.random(),0,math.random(),0)
    star.BackgroundColor3 = Color3.fromRGB(255,255,255)
    star.BorderSizePixel = 0
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1,0)
    corner.Parent = star
    star.Parent = mainFrame
    table.insert(stars,{obj=star,speed=0.008})
end

RunService.RenderStepped:Connect(function()
    for _,s in ipairs(stars) do
        local obj = s.obj
        local pos = obj.Position
        local x = pos.X.Scale - s.speed
        if x < 0 then x = 1 end
        obj.Position = UDim2.new(x,0,pos.Y.Scale,0)
        obj.BackgroundTransparency = math.clamp(0.3 + math.sin(tick()*2 + x*10)*0.2,0,0.8)
    end
end)

-- ========== TOGGLE BUTTON ==========
local toggleFrame = Instance.new("TextButton") 
toggleFrame.Size = UDim2.new(0, 50, 0, 20)
toggleFrame.Position = UDim2.new(0.5,-25,0,40)
toggleFrame.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
toggleFrame.Text = ""
toggleFrame.AutoButtonColor = false
toggleFrame.Parent = mainFrame
Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(1, 0)

local toggleCircle = Instance.new("Frame")
toggleCircle.Size = UDim2.new(0, 16, 0, 16)
toggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
toggleCircle.BackgroundColor3 = Color3.fromRGB(255,255,255)
toggleCircle.Parent = toggleFrame
Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1,0)

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Size = UDim2.new(1,0,0,18)
toggleLabel.Position = UDim2.new(0,0,1,2)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Text = "Invisible OFF"
toggleLabel.TextColor3 = Color3.fromRGB(255,255,255)
toggleLabel.Font = Enum.Font.Gotham
toggleLabel.TextSize = 14
toggleLabel.Parent = toggleFrame

-- Tweens
local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local tweenON = TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(1,-18,0.5,-8)})
local tweenOFF = TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(0,2,0.5,-8)})

-- ========== INVISIBILITY LOGIC ==========
local function removeFolders()
    local playerName = player.Name
    local playerFolder = Workspace:FindFirstChild(playerName)
    if not playerFolder then return end
    local doubleRig = playerFolder:FindFirstChild("DoubleRig")
    if doubleRig then doubleRig:Destroy() end
    local constraints = playerFolder:FindFirstChild("Constraints")
    if constraints then constraints:Destroy() end
    local childAddedConn = playerFolder.ChildAdded:Connect(function(child)
        if child.Name == "DoubleRig" or child.Name == "Constraints" then
            child:Destroy()
        end
    end)
    table.insert(connections.SemiInvisible, childAddedConn)
end

local function doClone()
    if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
        hip = player.Character.Humanoid.HipHeight
        oldRoot = player.Character:FindFirstChild("HumanoidRootPart")
        if not oldRoot or not oldRoot.Parent then return false end
        local tempParent = Instance.new("Model")
        tempParent.Parent = game
        player.Character.Parent = tempParent
        clone = oldRoot:Clone()
        clone.Parent = player.Character
        oldRoot.Parent = game.Workspace.CurrentCamera
        clone.CFrame = oldRoot.CFrame
        player.Character.PrimaryPart = clone
        player.Character.Parent = game.Workspace
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("Weld") or v:IsA("Motor6D") then
                if v.Part0 == oldRoot then v.Part0 = clone end
                if v.Part1 == oldRoot then v.Part1 = clone end
            end
        end
        tempParent:Destroy()
        return true
    end
    return false
end

local function revertClone()
    if not oldRoot or not oldRoot:IsDescendantOf(game.Workspace) or not player.Character or player.Character.Humanoid.Health <= 0 then
        return false
    end
    local tempParent = Instance.new("Model")
    tempParent.Parent = game
    player.Character.Parent = tempParent
    oldRoot.Parent = player.Character
    player.Character.PrimaryPart = oldRoot
    player.Character.Parent = game.Workspace
    oldRoot.CanCollide = true
    for _, v in pairs(player.Character:GetDescendants()) do
        if v:IsA("Weld") or v:IsA("Motor6D") then
            if v.Part0 == clone then v.Part0 = oldRoot end
            if v.Part1 == clone then v.Part1 = oldRoot end
        end
    end
    if clone then
        local oldPos = clone.CFrame
        clone:Destroy()
        clone = nil
        oldRoot.CFrame = oldPos
    end
    oldRoot = nil
    if player.Character and player.Character.Humanoid then
        player.Character.Humanoid.HipHeight = hip
    end
end

local function animationTrickery()
    if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
        local anim = Instance.new("Animation")
        anim.AnimationId = "http://www.roblox.com/asset/?id=18537363391"
        local humanoid = player.Character.Humanoid
        local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid)
        animTrack = animator:LoadAnimation(anim)
        animTrack.Priority = Enum.AnimationPriority.Action4
        animTrack:Play(0, 1, 0)
        anim:Destroy()
        local animStoppedConn = animTrack.Stopped:Connect(function()
            if isInvisible then animationTrickery() end
        end)
        table.insert(connections.SemiInvisible, animStoppedConn)
        task.delay(0, function()
            animTrack.TimePosition = 0.7
            task.delay(1, function()
                animTrack:AdjustSpeed(math.huge)
            end)
        end)
    end
end

local function enableInvisibility()
    if not player.Character or player.Character.Humanoid.Health <= 0 then return false end
    removeFolders()
    local success = doClone()
    if success then
        task.wait(0.1)
        animationTrickery()
        connection = RunService.PreSimulation:Connect(function(dt)
            if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and oldRoot then
                local root = player.Character.PrimaryPart or player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local cf = root.CFrame - Vector3.new(0, player.Character.Humanoid.HipHeight + (root.Size.Y/2) - 1 + 0.09, 0)
                    oldRoot.CFrame = cf * CFrame.Angles(math.rad(180), 0, 0)
                    oldRoot.Velocity = root.Velocity
                    oldRoot.CanCollide = false
                end
            end
        end)
        table.insert(connections.SemiInvisible, connection)
        characterConnection = player.CharacterAdded:Connect(function(newChar)
            if isInvisible then
                if animTrack then animTrack:Stop(); animTrack:Destroy(); animTrack=nil end
                if connection then connection:Disconnect() end
                revertClone()
                removeFolders()
                isInvisible=false
                for _, conn in ipairs(connections.SemiInvisible) do if conn then conn:Disconnect() end end
                connections.SemiInvisible = {}
            end
        end)
        table.insert(connections.SemiInvisible, characterConnection)
        return true
    end
    return false
end

local function disableInvisibility()
    if animTrack then animTrack:Stop(); animTrack:Destroy(); animTrack=nil end
    if connection then connection:Disconnect() end
    if characterConnection then characterConnection:Disconnect() end
    revertClone()
    removeFolders()
end

local function setupGodmode()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local mt = getrawmetatable(game)
    local oldNC = mt.__namecall
    local oldNI = mt.__newindex
    setreadonly(mt,false)
    mt.__namecall = newcclosure(function(self,...)
        local m = getnamecallmethod()
        if self==hum then
            if m=="ChangeState" and select(1,...):IsA(Enum.HumanoidStateType) and select(1,...)==Enum.HumanoidStateType.Dead then return end
            if m=="SetStateEnabled" then
                local st,en = ...
                if st==Enum.HumanoidStateType.Dead and en==true then return end
            end
            if m=="Destroy" then return end
        end
        if self==char and m=="BreakJoints" then return end
        return oldNC(self,...)
    end)
    mt.__newindex=newcclosure(function(self,k,v)
        if self==hum then
            if k=="Health" and type(v)=="number" and v<=0 then return end
            if k=="MaxHealth" and type(v)=="number" and v<hum.MaxHealth then return end
            if k=="BreakJointsOnDeath" and v==true then return end
            if k=="Parent" and v==nil then return end
        end
        return oldNI(self,k,v)
    end)
    setreadonly(mt,true)
end

-- ========== TOGGLE BUTTON LOGIC ==========
toggleFrame.MouseButton1Click:Connect(function()
    isInvisible = not isInvisible
    toggleLabel.Text = isInvisible and "Invisible ON" or "Invisible OFF"
    if isInvisible then
        tweenON:Play()
        toggleFrame.BackgroundColor3 = Color3.fromRGB(130,0,200)
        removeFolders()
        setupGodmode()
        enableInvisibility()
    else
        tweenOFF:Play()
        toggleFrame.BackgroundColor3 = Color3.fromRGB(100,0,150)
        disableInvisibility()
        for _, conn in ipairs(connections.SemiInvisible) do if conn then conn:Disconnect() end end
        connections.SemiInvisible = {}
    end
end)
