-- Auto V3 Angel - Full Auto NPC + Attack + Turn in
-- By @yourName (edit for your usage)

local Players, RS, TPService, HttpService = game:GetService("Players"), game:GetService("ReplicatedStorage"), game:GetService("TeleportService"), game:GetService("HttpService")
local LP = Players.LocalPlayer
local Char, HRP = LP.Character or LP.CharacterAdded:Wait(), nil

local ENABLED = false
local AUTO_HOP = true
local HIT_DELAY = 0.0175
local ATTACK_RANGE = 50

-- GUI
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 130, 0, 36)
toggleBtn.Position = UDim2.new(0, 10, 0, 180)
toggleBtn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Text = "Auto Angel V3 [OFF]"
toggleBtn.AutoButtonColor = false
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.BorderSizePixel = 0
toggleBtn.BackgroundTransparency = 0.1
toggleBtn.MouseButton1Click:Connect(function()
	ENABLED = not ENABLED
	toggleBtn.Text = ENABLED and "Auto Angel V3 [ON]" or "Auto Angel V3 [OFF]"
end)

-- Helper functions
local function isAngel(p)
	local ok, result = pcall(function()
		return p:FindFirstChild("Data") and p.Data:FindFirstChild("Race") and (p.Data.Race.Value == "Skypiean" or p.Data.Race.Value == "Angel")
	end)
	return ok and result
end

local function getTarget()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LP and isAngel(p) and p.Character and p.Character:FindFirstChild("Humanoid") then
			return p
		end
	end
end

local function moveTo(cf)
	HRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if HRP then
		HRP.CFrame = cf
	end
end

local function useDragonTalonC()
	local tool = LP.Character and LP.Character:FindFirstChild("Dragon Talon")
	if tool then
		local skillC = tool:FindFirstChild("C")
		if skillC then skillC:Activate() end
	end
end

local function talkToMythicalSpirit()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v.Name == "Mythological Spirit" then
			moveTo(v.HumanoidRootPart.CFrame + Vector3.new(0,2,0))
			fireclickdetector(v:FindFirstChildWhichIsA("ClickDetector"))
			wait(0.3)
			RS.Remotes.CommF_:InvokeServer("StartRaceV3")
			break
		end
	end
end

local function turnIn()
	RS.Remotes.CommF_:InvokeServer("RaceV3Progress", "Completed")
end

local function checkPVPDisabled(target)
	local tag = target and target:FindFirstChild("Data") and target.Data:FindFirstChild("PvPDisabled")
	return tag and tag.Value == true
end

local function attackTarget(target)
	local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
	if not tool then return end
	for i = 1, 100 do
		if not target or not target.Character or not target.Character:FindFirstChild("Humanoid") then break end
		if target.Character.Humanoid.Health <= 0 then break end
		if checkPVPDisabled(target) then break end
		moveTo(target.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, 0, -3))
		tool:Activate()
		useDragonTalonC()
		task.wait(HIT_DELAY)
	end
end

-- Server hop
local function hopServer()
	if not AUTO_HOP then return end
	local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/2753915549/servers/Public?sortOrder=Asc&limit=100"))
	for _, v in pairs(servers.data) do
		if v.playing < v.maxPlayers then
			TPService:TeleportToPlaceInstance(game.PlaceId, v.id)
			break
		end
	end
end

-- Main loop
task.spawn(function()
	while task.wait(2) do
		if ENABLED then
			talkToMythicalSpirit()
			local enemy = getTarget()
			if enemy then
				attackTarget(enemy)
				task.wait(1)
				if enemy.Character and enemy.Character.Humanoid.Health <= 0 or checkPVPDisabled(enemy) then
					turnIn()
				end
			else
				hopServer()
			end
		end
	end
end)
