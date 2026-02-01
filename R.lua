task.spawn(function()
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local LP = Players.LocalPlayer
    local PG = LP:WaitForChild("PlayerGui")

    local PURPLE = Color3.fromRGB(170,0,255)

    -- Prevent double execution globally
    if CoreGui:FindFirstChild("_LXKCR_AlreadyInit") then return end
    local globalFlag = Instance.new("BoolValue")
    globalFlag.Name = "_LXKCR_AlreadyInit"
    globalFlag.Parent = CoreGui

    -- Function to modify a GUI
    local function ModifyGUI(gui)
        if gui:FindFirstChild("_LXKCR_AlreadyInit") then return end
        local flag = Instance.new("BoolValue")
        flag.Name = "_LXKCR_AlreadyInit"
        flag.Parent = gui

        -- Splash Screen GUI
        local splashGUI = Instance.new("ScreenGui")
        splashGUI.Name = "LXKCR_SplashGUI"
        splashGUI.Parent = CoreGui
        splashGUI.ResetOnSpawn = false

        -- Frame behind text
        local splashFrame = Instance.new("Frame")
        splashFrame.Size = UDim2.new(1,0,1,0)
        splashFrame.BackgroundColor3 = Color3.new(0,0,0)
        splashFrame.BackgroundTransparency = 0
        splashFrame.ZIndex = 0
        splashFrame.Parent = splashGUI

        -- Splash Text
        local splashText = Instance.new("TextLabel")
        splashText.Size = UDim2.new(1,0,1,0)
        splashText.BackgroundTransparency = 1
        splashText.Text = "LXKCR HUB LAGGER"
        splashText.TextScaled = true
        splashText.Font = Enum.Font.GothamBlack
        splashText.TextColor3 = Color3.fromRGB(180,0,255)
        splashText.ZIndex = 1
        splashText.Parent = splashGUI

        -- Modify GUI immediately
        for _,v in ipairs(gui:GetDescendants()) do
            if v:IsA("ImageLabel") then
                v:Destroy()
            elseif v:IsA("TextLabel") then
                if v.Text == "❄" then
                    v:Destroy()
                else
                    if v.Text == "FrostHub" then
                        v.Text = "LXKCR Hub"
                    end
                    if string.find(string.lower(v.Text), "discord") then
                        v.Text = "discord.gg/nZaE9w59Nx"
                    end
                    v.TextColor3 = PURPLE
                end
            end
        end

        gui.Name = "LXKCR Lagger"

        -- Constant enforcement
        RunService.RenderStepped:Connect(function()
            for _,v in ipairs(gui:GetDescendants()) do
                if v:IsA("UIStroke") then
                    v.Color = PURPLE
                elseif v:IsA("TextLabel") then
                    if v.Text == "❄" then
                        v:Destroy()
                    else
                        v.TextColor3 = PURPLE
                    end
                end
            end
        end)

        -- Splash fade out after 1 second
        task.spawn(function()
            task.wait(1)
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local frameTween = TweenService:Create(splashFrame, tweenInfo, {BackgroundTransparency = 1})
            local textTween = TweenService:Create(splashText, tweenInfo, {TextTransparency = 1})
            frameTween:Play()
            textTween:Play()
            frameTween.Completed:Wait()
            splashGUI:Destroy()
        end)
    end

    -- Modify initial GUI if it exists
    local initialGUI = PG:FindFirstChild("QuesaidLagGUI")
    if initialGUI then
        ModifyGUI(initialGUI)
    end

    -- Listen for new GUI instances (respawns)
    PG.ChildAdded:Connect(function(child)
        if child.Name == "QuesaidLagGUI" then
            ModifyGUI(child)
        end
    end)

end)

-- Luarmor loader
loadstring(game:HttpGet(
    "https://api.luarmor.net/files/v4/loaders/631b34e178203bc4f117c37b2633c7fa.lua"
))()
