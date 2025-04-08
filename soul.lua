local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()
local Window = Library:CreateWindow({Name = "snoopy.fun", HidePremium = true, SaveConfig = false, ConfigFolder = "juju_live"})

-- State holders
local noclip = false
local speed = false
local flight = false

-- Movement tab
local Movement = Window:CreateTab("Movement")

Movement:CreateToggle({
	Name = "Anti Fling",
	CurrentValue = true,
	Callback = function(bool)
		RunService.Stepped:Connect(function()
			for _, v in pairs(Players:GetPlayers()) do
				if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
					v.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
					v.Character.HumanoidRootPart.RotVelocity = Vector3.new(0,0,0)
				end
			end
		end)
	end
})

Movement:CreateToggle({
	Name = "Noclip",
	CurrentValue = false,
	Callback = function(bool)
		noclip = bool
	end
})

RunService.Stepped:Connect(function()
	if noclip and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide then
				part.CanCollide = false
			end
		end
	end
end)

Movement:CreateToggle({
	Name = "Speed",
	CurrentValue = false,
	Callback = function(bool)
		speed = bool
		if bool then
			while speed do
				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					LocalPlayer.Character:TranslateBy(LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * 0.5)
				end
				RunService.RenderStepped:Wait()
			end
		end
	end
})

Movement:CreateToggle({
	Name = "Flight",
	CurrentValue = false,
	Callback = function(bool)
		flight = bool
		local bp = Instance.new("BodyPosition")
		bp.MaxForce = Vector3.new(1e6, 1e6, 1e6)
		bp.Position = LocalPlayer.Character.HumanoidRootPart.Position
		bp.Parent = LocalPlayer.Character.HumanoidRootPart

		while flight do
			bp.Position = bp.Position + Vector3.new(0, 1, 0)
			wait()
		end
		bp:Destroy()
	end
})

-- Utility tab
local Utility = Window:CreateTab("Utility")

Utility:CreateToggle({
	Name = "Detect Staff",
	CurrentValue = true,
	Callback = function()
		for _, v in ipairs(Players:GetPlayers()) do
			if v:GetRankInGroup(1) >= 200 then -- Change GroupId to your game's group
				warn("Staff Detected:", v.Name)
			end
		end
	end
})

Utility:CreateButton({
	Name = "Force Reset",
	Callback = function()
		LocalPlayer:LoadCharacter()
	end
})

-- Server tab
local Server = Window:CreateTab("Server")

Server:CreateButton({
	Name = "Copy Join Script",
	Callback = function()
		setclipboard('game:GetService("TeleportService"):Teleport(' .. game.PlaceId .. ')')
	end
})

Server:CreateButton({
	Name = "Rejoin Server",
	Callback = function()
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	end
})

Server:CreateButton({
	Name = "Hop Servers",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/GlacierScripts/Hop/main/hop.lua"))()
	end
})
