local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- 1. XÓA GUI CŨ NẾU CÓ
if CoreGui:FindFirstChild("NicoTrickSlideMobile") then
    CoreGui:FindFirstChild("NicoTrickSlideMobile"):Destroy()
end

-- 2. TẠO SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NicoTrickSlideMobile"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")

-- 3. THIẾT KẾ MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 160, 0, 90)
MainFrame.Position = UDim2.new(0.5, -80, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 170, 0)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 0, 26)
Title.Position = UDim2.new(0, 10, 0, 2)
Title.BackgroundTransparency = 1
Title.Text = "Inf Trick Slide"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Nút thu gọn (-)
local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.new(0, 20, 0, 20)
MinButton.Position = UDim2.new(1, -24, 0, 5)
MinButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MinButton.Text = "-"
MinButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MinButton.Font = Enum.Font.GothamBold
MinButton.TextSize = 14
MinButton.Parent = MainFrame
Instance.new("UICorner", MinButton).CornerRadius = UDim.new(0, 5)

-- Nút Toggle ON/OFF
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -16, 0, 36)
ToggleButton.Position = UDim2.new(0, 8, 0, 34)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleButton.Text = "Trick Slide: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 85, 85)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 12
ToggleButton.Parent = MainFrame
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 8)

-- Icon khi thu gọn
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 44, 0, 44)
OpenButton.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
OpenButton.Text = "Trick"
OpenButton.TextColor3 = Color3.fromRGB(255, 170, 0)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 11
OpenButton.Visible = false
OpenButton.Parent = ScreenGui
Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(0, 22)
local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(255, 170, 0)
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenButton

-- 4. KÉO THẢ MƯỢT TRÊN MOBILE
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(MainFrame)
makeDraggable(OpenButton)

-- 5. LÕI EXPLOIT "TRICK SLIDE" KHÔNG ĐỨT QUÃNG
local autoSlideActive = false
local charEvents = ReplicatedStorage:WaitForChild("events"):WaitForChild("player"):WaitForChild("char")
local slideRemote = charEvents:WaitForChild("Sliding")
local rotationRemote = charEvents:WaitForChild("CharRotation")

task.spawn(function()
    while true do
        if autoSlideActive then
            pcall(function()
                -- Gửi tín hiệu lướt liên tục lên server (Bypass cooldown/animation)
                slideRemote:FireServer(true)
                
                -- Kết hợp tự động nhảy (Bunny Hop) để giữ đà (momentum) mãi mãi
                local char = LocalPlayer.Character
                if char and char:FindFirstC
