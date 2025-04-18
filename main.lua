-- Auto Thức Tỉnh Thiên Thần V3 (Full System)
-- KRNL Supported | Made by ChatGPT + You

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")

-- SETTINGS
local HIT_DELAY = 0.0175
local ATTACK_DISTANCE = 50
local AUTO_HOP = true
local ENABLED = false
local triedServers = {}

-- GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "AutoAngelGUI"
ScreenGui.ResetOnSpawn = false

-- Toggle Button
local Toggle = Instance.new("TextButton")
Toggle.Parent = ScreenGui
Toggle.Size = UDim2.new(0, 160, 0, 50)
Toggle.Position = UDim2.new(0, 20, 0, 220)
Toggle.Text = "AutoAngel [OFF]"
Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.TextSize = 20
Toggle.Font = Enum.Font.GothamBold
Toggle.AutoButtonColor = true
Toggle.ClipsDescendants = true
Toggle.BackgroundTransparency = 0
Toggle.BorderSizePixel = 0
Toggle.TextWrapped = true
Toggle.AnchorPoint = Vector2.new(0, 0)
Toggle.BorderMode = Enum.BorderMode.Outline
Toggle.ZIndex = 2
Toggle.TextStrokeTransparency = 0.5
Toggle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Toggle.SizeConstraint = Enum.SizeConstraint.RelativeXY
Toggle.UICorner = Instance.new("UICorner", Toggle)
Toggle.UICorner.CornerRadius = UDim.new(0, 25)

-- Status Text
local statusText = Instance.new("TextLabel", ScreenGui)
statusText.Size = UDim2.new(1, 0, 0, 30)
statusText.Position = UDim2.new(0, 0, 0, 0)
statusText.Text = ""
statusText.BackgroundTransparency = 1
statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
statusText.TextSize = 20
statusText.Font = Enum.Font.GothamBold

Toggle.MouseButton1Click:Connect(function()
    ENABLED = not ENABLED
    Toggle.Text = ENABLED and "AutoAngel [ON]" or "AutoAngel [OFF]"
    statusText.Text = ENABLED and "Đang tự động lấy V3..." or ""
end)

-- Kiểm tra tộc
local function isAngel(player)
    local success, result = pcall(function()
        if player:FindFirstChild("Data") and player.Data:FindFirstChild("Race") then
            local race = player.Data.Race.Value
            return race:lower() == "skypiean" or race:lower() == "angel"
        end
        return false
    end)
    return success and result
end

-- Hop thông minh
local function smartHop()
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/2753915549/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if success and response and response.data then
        for _, server in pairs(response.data) do
            if server.playing < server.maxPlayers and not triedServers[server.id] then
                triedServers[server.id] = true
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                return
            end
        end
    end
end

-- Tìm Angel gần nhất
local function getAngel()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isAngel(player) then
            return player
        end
    end
    return nil
end

-- Di chuyển đến mục tiêu
local function moveToTarget(target)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetHRP = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if hrp and targetHRP then
        local tween = TweenService:Create(hrp, TweenInfo.new(0.25), {CFrame = targetHRP.CFrame * CFrame.new(0, 0, -3)})
        tween:Play()
    end
end

-- Tấn công mục tiêu
local function attackTarget(target)
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if not tool then return end

    for i = 1, 300 do
        if not target or not target.Character or not target.Character:FindFirstChild("Humanoid") then break end
        local hp = target.Character.Humanoid.Health
        local pvpOff = target.Character:FindFirstChild("ForceField") -- nếu PvP tắt

        if hp <= 0 or pvpOff then
            task.wait(1) -- delay 1s đề phòng Ghost
            if target.Character.Humanoid.Health <= 0 or target.Character:FindFirstChild("ForceField") then
                break
            end
        end

        moveToTarget(target)
        tool:Activate()
        task.wait(HIT_DELAY)
    end
end

-- Sử dụng Dragon Talon để phá Ken
local function useSkillC()
    local cSkill = LocalPlayer.Character:FindFirstChild("Dragon Talon") and LocalPlayer.Character["Dragon Talon"]:FindFirstChild("C")
    if cSkill then cSkill:Activate() end
end

-- Thức tỉnh V3
local function awakenRaceV3()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartRaceV3")
end

-- Tiến trình chính
task.spawn(function()
    while true do
        task.wait(2)
        if ENABLED then
            local target = getAngel()
            if not target then
                smartHop()
                continue
            end

            awakenRaceV3()
            useSkillC()
            attackTarget(target)
            ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV3Progress", "Completed")
        end
    end
end)
