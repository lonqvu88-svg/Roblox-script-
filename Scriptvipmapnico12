local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Xóa GUI cũ
if CoreGui:FindFirstChild("NicoSilentSlideMobile") then
    CoreGui:FindFirstChild("NicoSilentSlideMobile"):Destroy()
end

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NicoSilentSlideMobile"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")

-- Bảng Main
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 160, 0, 90)
MainFrame.Position = UDim2.new(0.5, -80, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 255, 170)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 0, 26)
Title.Position = UDim2.new(0, 10, 0, 2)
Title.BackgroundTransparency = 1
Title.Text = "Nico Silent Slide"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Nút Thu Gọn (-)
local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.new(0, 20, 0, 20)
MinButton.Position = UDim2.new(1, -24, 0, 5)
MinButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MinButton.Text = "-"
MinButton.TextColor3 = Color3.fromRGB(200, 200, 220)
MinButton.Font = Enum.Font.GothamBold
MinButton.TextSize = 14
MinButton.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 5)
MinCorner.Parent = MinButton

-- Nút Toggle Bật/Tắt
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -16, 0, 36)
ToggleButton.Position = UDim2.new(0, 8, 0, 34)
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ToggleButton.Text = "Auto Slide: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 85, 85)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 12
ToggleButton.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

-- Nút Icon Thu Gọn
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 44, 0, 44)
OpenButton.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
OpenButton.Text = "Slide"
OpenButton.TextColor3 = Color3.fromRGB(0, 255, 170)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 11
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 22)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(0, 255, 170)
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenButton

-- Dragging Support
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

-- CORE: Lõi Execute Silent Slide chống mất UI Mobile
local autoSlideActive = false

local function triggerSilentSlide()
    if not getconnections then return end

    -- 1. Kích hoạt thẳng vào nút Slide UI của game (Dựa trên tên nút)
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        for _, v in pairs(playerGui:GetDescendants()) do
            if (v:IsA("ImageButton") or v:IsA("TextButton")) and v.Visible then
                local name = string.lower(v.Name)
                if string.find(name, "slide") or string.find(name, "crouch") or string.find(name, "action") then
                    pcall(function()
                        for _, conn in pairs(getconnections(v.MouseButton1Down)) do
                            if type(conn.Function) == "function" then conn.Function() end
                        end
                        for _, conn in pairs(getconnections(v.Activated)) do
                            if type(conn.Function) == "function" then conn.Function() end
                        end
                    end)
                end
            end
        end
    end

    -- 2. Inject tín hiệu "C" giả vào InputBegan (Bypass Roblox Engine)
    local fakeInputBegin = { KeyCode = Enum.KeyCode.C, UserInputType = Enum.UserInputType.Keyboard, UserInputState = Enum.UserInputState.Begin }
    pcall(function()
        for _, conn in pairs(getconnections(UserInputService.InputBegan)) do
            if type(conn.Function) == "function" then conn.Function(fakeInputBegin, false) end
        end
    end)
end

task.spawn(function()
    while true do
        if autoSlideActive then
            triggerSilentSlide()
            task.wait(0.35)
        else
            task.wait(0.2)
        end
    end
end)

-- UI Events
ToggleButton.MouseButton1Click:Connect(function()
    autoSlideActive = not autoSlideActive
    if autoSlideActive then
        ToggleButton.Text = "Auto Slide: ON"
        ToggleButton.TextColor3 = Color3.fromRGB(85, 255, 127)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 55, 35)
    else
        ToggleButton.Text = "Auto Slide: OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 85, 85)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    end
end)

MinButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)
