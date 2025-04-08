
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer


local Aimbot = {
    Enabled = false,
    Prediction = false,
    FOV = 150,
    Smoothness = 0.2,
    TargetPart = "Head"
}


local function roundify(obj)
    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 8)
    uicorner.Parent = obj
end

local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "SoulzAimbotUI"

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 270, 0, 270)
Main.Position = UDim2.new(0, -300, 0, 100)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
roundify(Main)

TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Position = UDim2.new(0, 50, 0, 100)
}):Play()

local function newLabel(text, posY)
    local l = Instance.new("TextLabel", Main)
    l.Text = text
    l.Size = UDim2.new(1, -20, 0, 22)
    l.Position = UDim2.new(0, 10, 0, posY)
    l.TextColor3 = Color3.fromRGB(230, 230, 230)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Gotham
    l.TextSize = 17
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

local function newButton(text, posY, callback)
    local b = Instance.new("TextButton", Main)
    b.Text = text
    b.Size = UDim2.new(1, -20, 0, 26)
    b.Position = UDim2.new(0, 10, 0, posY)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 15
    roundify(b)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function newSlider(name, posY, min, max, default, callback)
    local label = newLabel(name .. ": " .. tostring(default), posY)
    local slider = Instance.new("TextButton", Main)
    slider.Position = UDim2.new(0, 10, 0, posY + 24)
    slider.Size = UDim2.new(1, -20, 0, 20)
    slider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    slider.Text = ""
    roundify(slider)

    local fill = Instance.new("Frame", slider)
    fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    roundify(fill)

    local dragging = false
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mx = UserInputService:GetMouseLocation().X
            local percent = math.clamp((mx - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local val = math.floor((min + (max - min) * percent) * 100) / 100
            fill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = name .. ": " .. val
            callback(val)
        end
    end)
end

local function newDropdown(posY, items, callback)
    local label = newLabel("Target Part:", posY)
    local box = Instance.new("TextButton", Main)
    box.Size = UDim2.new(1, -20, 0, 25)
    box.Position = UDim2.new(0, 10, 0, posY + 22)
    box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    box.Text = items[1]
    box.TextColor3 = Color3.new(1,1,1)
    box.Font = Enum.Font.Gotham
    box.TextSize = 15
    roundify(box)
    box.MouseButton1Click:Connect(function()
        local i = table.find(items, box.Text) or 1
        i = (i % #items) + 1
        box.Text = items[i]
        callback(items[i])
    end)
end


newLabel("Soulz.find 5)
newButton("Toggle Aimbot", 30, function()
    Aimbot.Enabled = not Aimbot.Enabled
end)
newButton("Toggle Prediction", 60, function()
    Aimbot.Prediction = not Aimbot.Prediction
end)
newDropdown(90, {"Head", "HumanoidRootPart"}, function(v) Aimbot.TargetPart = v end)
newSlider("FOV", 120, 50, 300, Aimbot.FOV, function(v) Aimbot.FOV = v end)
newSlider("Smooth", 160, 0.05, 1, Aimbot.Smoothness, function(v) Aimbot.Smoothness = v end)


local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 255, 0)
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Visible = true


local function GetClosestTarget()
    local closest, shortest = nil, Aimbot.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Aimbot.TargetPart) then
            local part = p.Character[Aimbot.TargetPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = part
                end
            end
        end
    end
    return closest
end


local isCDown = false
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.C then
        isCDown = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.C then
        isCDown = false
    end
end)


RunService.RenderStepped:Connect(function()
    FOVCircle.Radius = Aimbot.FOV
    FOVCircle.Position = UserInputService:GetMouseLocation()
    if Aimbot.Enabled and isCDown then
        local target = GetClosestTarget()
        if target then
            local futurePos = target.Position
            if Aimbot.Prediction and target.Velocity then
                futurePos += target.Velocity * 0.125
            end
            local dir = (futurePos - Camera.CFrame.Position).Unit
            local newCF = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + dir)
            Camera.CFrame = Camera.CFrame:Lerp(newCF, Aimbot.Smoothness)
        end
    end
end)
