loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    Ragebot = false,
    CameraLock = false,
    TriggerBot = false,
    ESP = false,
    Tracers = false,
    AntiLock = false,
    AimPart = "Head",
    Range = 1000,
}

local CurrentTarget = nil

local function getClosestPlayer()
    local closest = nil
    local shortest = Settings.Range
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Settings.AimPart) then
            local part = player.Character[Settings.AimPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

local function rageBot()
    if Settings.Ragebot and CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild(Settings.AimPart) then
        local part = CurrentTarget.Character[Settings.AimPart]
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
    end
end

local function triggerBot()
    if Settings.TriggerBot and CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild(Settings.AimPart) then
        local Mouse = LocalPlayer:GetMouse()
        local target = Mouse.Target
        if target and target:IsDescendantOf(CurrentTarget.Character) then
            mouse1click()
        end
    end
end

local function drawESP(player)
    local Box = Drawing.new("Text")
    Box.Size = 13
    Box.Center = true
    Box.Outline = true
    Box.Font = 2
    Box.Color = Color3.new(1, 0, 0)
    Box.Visible = false

    local Tracer = Drawing.new("Line")
    Tracer.Thickness = 1.5
    Tracer.Color = Color3.fromRGB(255, 0, 0)
    Tracer.Visible = false

    RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            Box.Visible = onScreen and Settings.ESP
            Tracer.Visible = onScreen and Settings.Tracers

            if onScreen then
                Box.Position = Vector2.new(pos.X, pos.Y - 30)
                Box.Text = player.Name
                Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                Tracer.To = Vector2.new(pos.X, pos.Y)
            end
        else
            Box.Visible = false
            Tracer.Visible = false
        end
    end)
end

local function antiLock()
    if Settings.AntiLock and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        root.Velocity = Vector3.new(math.random(-15,15), 0, math.random(-15,15))
    end
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        drawESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    drawESP(player)
end)

RunService.RenderStepped:Connect(function()
    if Settings.CameraLock then
        CurrentTarget = getClosestPlayer()
    end
    rageBot()
    triggerBot()
    antiLock()
end)

-- UI Setup
local Window = Rayfield:CreateWindow({
    Name = "soul.find",
    LoadingTitle = "soul.find Da Hood HvH",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "soul.find", 
        FileName = "soul.find_settings"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

local Tab = Window:CreateTab("Main", 4483362458)

Tab:CreateToggle({
    Name = "RageBot",
    CurrentValue = Settings.Ragebot,
    Callback = function(v)
        Settings.Ragebot = v
    end,
})

Tab:CreateToggle({
    Name = "Camera Lock",
    CurrentValue = Settings.CameraLock,
    Callback = function(v)
        Settings.CameraLock = v
    end,
})

Tab:CreateToggle({
    Name = "TriggerBot",
    CurrentValue = Settings.TriggerBot,
    Callback = function(v)
        Settings.TriggerBot = v
    end,
})

Tab:CreateToggle({
    Name = "ESP",
    CurrentValue = Settings.ESP,
    Callback = function(v)
        Settings.ESP = v
    end,
})

Tab:CreateToggle({
    Name = "Tracers",
    CurrentValue = Settings.Tracers,
    Callback = function(v)
        Settings.Tracers = v
    end,
})

Tab:CreateToggle({
    Name = "Anti-Lock",
    CurrentValue = Settings.AntiLock,
    Callback = function(v)
        Settings.AntiLock = v
    end,
})

Tab:CreateDropdown({
    Name = "Aim Part",
    Options = {"Head", "UpperTorso", "HumanoidRootPart"},
    CurrentOption = Settings.AimPart,
    Callback = function(v)
        Settings.AimPart = v
    end,
})

Tab:CreateSlider({
    Name = "Aim Range",
    Range = {50, 1000},
    Increment = 10,
    Suffix = "px",
    CurrentValue = Settings.Range,
    Callback = function(v)
        Settings.Range = v
    end,
})
