-- Tạo giao diện menu chính
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "MainMenu"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0.4, 0, 0.5, 0)
frame.Position = UDim2.new(0.3, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0.2, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Main Menu"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 36
title.TextColor3 = Color3.new(1, 1, 1)

local function createButton(text, positionY)
    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0.8, 0, 0.2, 0)
    button.Position = UDim2.new(0.1, 0, positionY, 0)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = text
    button.Font = Enum.Font.SourceSans
    button.TextSize = 24
    button.TextColor3 = Color3.new(1, 1, 1)
    return button
end

local playButton = createButton("Play", 0.3)
local settingsButton = createButton("Settings", 0.55)
local exitButton = createButton("Exit", 0.8)

playButton.MouseButton1Click:Connect(function()
    print("Play button clicked")
    -- Thêm mã để chuyển sang trò chơi
end)

settingsButton.MouseButton1Click:Connect(function()
    print("Settings button clicked")
    -- Thêm mã để mở cài đặt
end)

exitButton.MouseButton1Click:Connect(function()
    print("Exit button clicked")
    -- Thêm mã để thoát trò chơi hoặc đóng menu
end)
