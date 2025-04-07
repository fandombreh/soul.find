-- Full Da Hood HVH Script with GUI (Juju Style)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "JujuHVHGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0

local UIGrid = Instance.new("UIGridLayout", Frame)
UIGrid.CellSize = UDim2.new(0, 130, 0, 40)
UIGrid.CellPadding = UDim2.new(0, 10, 0, 10)

function createToggle(name, callback)
    local toggle = Instance.new("TextButton", Frame)
    toggle.Text = name
    toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.BorderSizePixel = 0
    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(45, 45, 45)
        callback(state)
    end)
end

function createButton(name, callback)
    local button = Instance.new("TextButton", Frame)
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BorderSizePixel = 0
    button.MouseButton1Click:Connect(callback)
end

-- HVH Features
createToggle("Anti Lock", function(state)
    if state then
        LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(3, 3, 3)
    else
        LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
    end
end)

createToggle("Anti Aim", function(state)
    RunService.RenderStepped:Connect(function()
        if state and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(180), 0)
            end
        end
    end)
end)

createToggle("Spinbot", function(state)
    RunService.RenderStepped:Connect(function()
        if state and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame *= CFrame.Angles(0, math.rad(30), 0)
            end
        end
    end)
end)

createToggle("Resolver", function(state)
    -- Resolver mockup: correct enemy CFrame for fake angles (simple version)
    RunService.Stepped:Connect(function()
        if state then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    v.Character.HumanoidRootPart.Rotation = Vector3.zero
                end
            end
        end
    end)
end)

-- Movement Enhancements
createToggle("Speed", function(state)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = state and 100 or 16
    end
end)

createToggle("Noclip", function(state)
    RunService.Stepped:Connect(function()
        if state and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)
end)

-- Server Tools
createButton("Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

createButton("Hop Servers", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/2gtEPbQJ"))()
end)

-- Utility
createButton("Force Reset", function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end)

createButton("Animation Breaker", function()
    for _, anim in pairs(LocalPlayer.Character.Humanoid:GetPlayingAnimationTracks()) do
        anim:Stop()
    end
end)

createButton("Detect Staff", function()
    for _, v in pairs(Players:GetPlayers()) do
        if v:GetRankInGroup(1) > 200 then -- Replace with your group ID
            game.StarterGui:SetCore("SendNotification", {
                Title = "Staff Detected",
                Text = v.Name
            })
        end
    end
end)

-- Legitbot Placeholder
createToggle("Silent Aim", function(state)
    getgenv().silentAim = state
end)

createToggle("Triggerbot", function(state)
    getgenv().triggerbot = state
end)

-- Legitbot Logic
RunService.RenderStepped:Connect(function()
    if getgenv().triggerbot then
        local target = Players:GetPlayers()[2] -- placeholder, better targeting logic needed
        if target and target.Character and target.Character:FindFirstChild("Humanoid") then
            mouse1press()
            wait(0.1)
            mouse1release()
        end
    end
end)
