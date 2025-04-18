-- GUI nút bật/tắt
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 130, 0, 40)
ToggleButton.Position = UDim2.new(0, 20, 0, 350)
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "Auto Angel V3: OFF"
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18

_G.AutoAngel = false

ToggleButton.MouseButton1Click:Connect(function()
    _G.AutoAngel = not _G.AutoAngel
    ToggleButton.Text = _G.AutoAngel and "Auto Angel V3: ON" or "Auto Angel V3: OFF"
end)

-- Các hàm phụ
function ExpandFullHitbox()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:lower():find("hitbox") or part:IsDescendantOf(char)) then
            part.Size = Vector3.new(60, 60, 60)
            part.Transparency = 1
            part.CanCollide = false
        end
    end
end

function EnableHaki()
    pcall(function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
    end)
end

function UseCSkill()
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, "C", false, game)
    wait(0.1)
    vim:SendKeyEvent(false, "C", false, game)
end

function SuperM1()
    local vim = game:GetService("VirtualInputManager")
    for i = 1, 10 do
        vim:SendMouseButtonEvent(0,0,0,true,game,0)
        vim:SendMouseButtonEvent(0,0,0,false,game,0)
        wait(0.0175)
    end
end

function GetRaceProgress()
    return game.Players.LocalPlayer.Data.RaceProgress.Value
end

function FinishQuest()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceTrainer", "Finish")
end

function GetAngelQuest()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceTrainer", "Start")
end

function HopToAnotherServer()
    local HttpService = game:GetService("HttpService")
    local tpService = game:GetService("TeleportService")
    local placeId = game.PlaceId
    local servers = {}
    local req = syn and syn.request or http_request
    local body = req({
        Url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
    }).Body
    for _, server in pairs(HttpService:JSONDecode(body).data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            table.insert(servers, server.id)
        end
    end
    if #servers > 0 then
        tpService:TeleportToPlaceInstance(placeId, servers[math.random(1, #servers)], game.Players.LocalPlayer)
    end
end

function IsAngelPlayer(p)
    return p and p.Character and p.Data and p.Data.Race and p.Data.Race.Value == "Angel"
        and p.Team ~= game.Players.LocalPlayer.Team
        and p.Character:FindFirstChild("HumanoidRootPart")
        and p.Character:FindFirstChild("Humanoid")
        and p.Character.Humanoid.Health > 0
        and p:FindFirstChild("PVP") and p.PVP.Value == true
end

function FindAngelWithPVP()
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and IsAngelPlayer(p) then
            return p
        end
    end
end

-- Auto chính
task.spawn(function()
    while task.wait(1) do
        if _G.AutoAngel then
            ExpandFullHitbox()
            EnableHaki()

            if GetRaceProgress() >= 4 then
                FinishQuest()
                continue
            end

            GetAngelQuest()
            wait(0.5)

            local enemy = FindAngelWithPVP()
            if enemy then
                repeat
                    if enemy and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") and enemy.Character.Humanoid.Health > 0 then
                        local myChar = game.Players.LocalPlayer.Character
                        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                            myChar.HumanoidRootPart.CFrame = enemy.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                            UseCSkill()
                            SuperM1()
                        end
                    end
                    task.wait(0.05)
                until enemy.Character.Humanoid.Health <= 0 or not _G.AutoAngel

                -- Kiểm tra xong có trả nhiệm vụ được không
                if GetRaceProgress() >= 4 then
                    FinishQuest()
                end
            else
                HopToAnotherServer()
                wait(3)
            end
        end
    end
end)
