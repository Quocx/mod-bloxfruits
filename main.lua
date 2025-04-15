local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local canDodge = true
local cooldownTime = 1.5

-- GUI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "MainMenu"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0.4, 0, 0.5, 0)
frame.Position = UDim2.new(0.3, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local UICorner = Instance.new("UICorner", frame)
UICorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0.2, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Main Menu"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 36
title.TextColor3 = Color3.new(1, 1, 1)

-- Bóng chữ
local shadow = title:Clone()
shadow.Name = "TitleShadow"
shadow.TextColor3 = Color3.new(0, 0, 0)
shadow.Position = UDim2.new(0, 2, 0, 2)
shadow.ZIndex = title.ZIndex - 1
shadow.Parent = frame

local function createButton(text, positionY)
    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0.8, 0, 0.15, 0)
    button.Position = UDim2.new(0.1, 0, positionY, 0)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = text
    button.Font = Enum.Font.SourceSans
    button.TextSize = 24
    button.TextColor3 = Color3.new(1, 1, 1)

    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 8)

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)

    return button
end

local playButton = createButton("Play", 0.25)
local settingsButton = createButton("Settings", 0.45)
local dodgeButton = createButton("Cyborg Dodge", 0.65)
local exitButton = createButton("Exit", 0.85)

-- Né Cyborg
local function createAfterImage()
	local clone = character:Clone()
	clone.Name = "AfterImage"
	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = true
			v.CanCollide = false
			v.Transparency = 0.5
			v.Material = Enum.Material.Neon
		elseif v:IsA("Decal") or v:IsA("Script") or v:IsA("LocalScript") then
			v:Destroy()
		end
	end
	clone.Parent = workspace
	Debris:AddItem(clone, 0.3)
end

local function playCyborgEffect()
	local effect = Instance.new("Part")
	effect.Size = Vector3.new(1, 1, 1)
	effect.Shape = Enum.PartType.Ball
	effect.Material = Enum.Material.Neon
	effect.Color = Color3.fromRGB(0, 255, 255)
	effect.Anchored = true
	effect.CanCollide = false
	effect.Position = humanoidRootPart.Position
	effect.Parent = workspace

	local particle = Instance.new("ParticleEmitter", effect)
	particle.Texture = "rbxassetid://4483345998"
	particle.Speed = NumberRange.new(0)
	particle.Size = NumberSequence.new(3)
	particle.Lifetime = NumberRange.new(0.2)
	particle.Rate = 1000
	particle.LightEmission = 1
	particle.Rotation = NumberRange.new(0, 360)
	particle.Transparency = NumberSequence.new(0.2)

	Debris:AddItem(effect, 0.3)
end

local function dodge()
	if not canDodge then return end
	canDodge = false

	local direction = humanoidRootPart.CFrame.lookVector
	local targetPos = humanoidRootPart.Position + direction * 15

	createAfterImage()
	playCyborgEffect()

	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPos)})
	tween:Play()

	task.delay(cooldownTime, function()
		canDodge = true
	end)
end

-- Kích hoạt né khi bấm R
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.R then
		dodge()
	end
end)

-- Nút chức năng
playButton.MouseButton1Click:Connect(function()
	print("Play button clicked")
end)

settingsButton.MouseButton1Click:Connect(function()
	print("Settings button clicked")
end)

dodgeButton.MouseButton1Click:Connect(function()
	print("Cyborg Dodge enabled – Use R to dodge")
end)

exitButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)
