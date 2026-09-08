-- Nico's Nextbots - Inf Slide & Auto Hold Jump (Mobile Verified)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Xóa GUI cũ nếu đang tồn tại
if CoreGui:FindFirstChild("NicoInfSlideMasterUI") then
    CoreGui:FindFirstChild("NicoInfSlideMasterUI"):Destroy()
end

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NicoInfSlideMasterUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")

-- Khung giao diện chính
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 190, 0, 130)
MainFrame.Position = UDim2.new(0.5, -95, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 220, 255)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 0, 26)
Title.Position = UDim2.new(0, 10, 0, 2)
Title.BackgroundTransparency = 1
Title.Text = "Nico Inf Slide & Hold Jump"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextSize = 11
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Nút Thu Gọn (-)
local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.new(0, 22, 0, 22)
MinButton.Position = UDim2.new(1, -26, 0, 4)
MinButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MinButton.Text = "-"
MinButton.TextColor3 = Color3.fromRGB(200, 200, 220)
MinButton.Font = Enum.Font.GothamBold
MinButton.TextSize = 14
MinButton.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinButton

-- Nút Bật/Tắt Giữ Slide
local SlideToggle = Instance.new("TextButton")
SlideToggle.Size = UDim2.new(1, -16, 0, 34)
SlideToggle.Position = UDim2.new(0, 8, 0, 34)
SlideToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
SlideToggle.Text = "Giữ Slide (Inf Slide): OFF"
SlideToggle.TextColor3 = Color3.fromRGB(255, 85, 85)
SlideToggle.Font = Enum.Font.GothamBold
SlideToggle.TextSize = 11
SlideToggle.Parent = MainFrame

local SlideCorner = Instance.new("UICorner")
SlideCorner.CornerRadius = UDim.new(0, 8)
SlideCorner.Parent = SlideToggle

-- Nút Bật/Tắt Auto Giữ Nút Nhảy
local JumpToggle = Instance.new("TextButton")
JumpToggle.Size = UDim2.new(1, -16, 0, 34)
JumpToggle.Position = UDim2.new(0, 8, 0, 74)
JumpToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
JumpToggle.Text = "Auto Giữ Nút Nhảy: OFF"
JumpToggle.TextColor3 = Color3.fromRGB(255, 85, 85)
JumpToggle.Font = Enum.Font.GothamBold
JumpToggle.TextSize = 11
JumpToggle.Parent = MainFrame

local JumpCorner = Instance.new("UICorner")
JumpCorner.CornerRadius = UDim.new(0, 8)
JumpCorner.Parent = JumpToggle

-- Nút Tròn Mở Lại Menu
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 44, 0, 44)
OpenButton.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
OpenButton.Text = "Menu"
OpenButton.TextColor3 = Color3.fromRGB(0, 220, 255)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 11
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 22)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(0, 220, 255)
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenButton

-- Kéo thả Menu
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

---------------------------------------------------------
-- 1. GIỮ NGUYÊN TOUCHGUI MOBILE (CHỐNG MẤT NÚT BẤM)
---------------------------------------------------------
task.spawn(function()
    while true do
        pcall(function()
            local pGui = LocalPlayer:FindFirstChild("PlayerGui")
            if pGui then
                local touchGui = pGui:FindFirstChild("TouchGui")
                if touchGui then
                    touchGui.Enabled = true
                    local frame = touchGui:FindFirstChild("TouchControlFrame")
                    if frame then frame.Visible = true end
                end
            end
        end)
        task.wait(0.25)
    end
end)

---------------------------------------------------------
-- 2. FIX ĐỘN THỔ NỬA NGƯỜI (Khóa HipHeight & Trục Y)
---------------------------------------------------------
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum and hrp then
                -- Giữ độ cao chuẩn 2.0 để tránh bị ép lún xuống đất khi Slide
                if hum.HipHeight < 2.0 then
                    hum.HipHeight = 2.0
                end
                -- Triệt tiêu lực hút xuống dưới khi tiếp đất
                if hum.FloorMaterial ~= Enum.Material.Air and hrp.AssemblyLinearVelocity.Y < -3 then
                    hrp.AssemblyLinearVelocity = Vector3.new(
                        hrp.AssemblyLinearVelocity.X,
                        0,
                        hrp.AssemblyLinearVelocity.Z
                    )
                end
            end
        end
    end)
end)

---------------------------------------------------------
-- 3. TÍNH NĂNG AUTO GIỮ NÚT NHẢY (TỰ ĐỘNG LÀM MỚI JUMP)
---------------------------------------------------------
local autoJumpEnabled = false

-- Chạy ở nhịp RenderStepped để làm mới nút nhảy tức thì ngay khi vừa chạm đất
RunService.RenderStepped:Connect(function()
    if autoJumpEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                -- Nếu đang ở trên mặt đất -> Tự động nảy lên ngay không cần tap tay
                if hum.FloorMaterial ~= Enum.Material.Air then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    hum.Jump = true
                end
            end
        end
    end
end)

---------------------------------------------------------
-- 4. TÍNH NĂNG GIỮ SLIDE LIÊN TỤC (INF SLIDE MECHANIC)
---------------------------------------------------------
local holdSlideEnabled = false

local function triggerSlideInput()
    if firesignal then
        pcall(function()
            firesignal(UserInputService.InputBegan, {
                KeyCode = Enum.KeyCode.C,
                UserInputType = Enum.UserInputType.Keyboard,
                UserInputState = Enum.UserInputState.Begin
            }, false)
        end)
    end
end

task.spawn(function()
    while true do
        if holdSlideEnabled then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    -- Liên tục kích hoạt tín hiệu Slide
                    triggerSlideInput()
                    
                    -- Duy trì gia tốc lướt theo hướng Joystick
                    local moveDir = hum.MoveDirection
                    if moveDir.Magnitude > 0.1 then
                        local currentVel = hrp.AssemblyLinearVelocity
                        local speed = Vector3.new(currentVel.X, 0, currentVel.Z).Magnitude
                        local targetSpeed = math.max(speed, 60)
                        if targetSpeed < 85 then
                            targetSpeed = targetSpeed + 1.5
                        end
                        
                        hrp.AssemblyLinearVelocity = Vector3.new(
                            moveDir.X * targetSpeed,
                            hrp.AssemblyLinearVelocity.Y,
                            moveDir.Z * targetSpeed
                        )
                    end
                end
            end
            task.wait(0.05)
        else
            task.wait(0.2)
        end
    end
end)

---------------------------------------------------------
-- SỰ KIỆN NÚT BẤM GUI
---------------------------------------------------------
SlideToggle.MouseButton1Click:Connect(function()
    holdSlideEnabled = not holdSlideEnabled
    if holdSlideEnabled then
        SlideToggle.Text = "Giữ Slide (Inf Slide): ON"
        SlideToggle.TextColor3 = Color3.fromRGB(85, 255, 127)
        SlideToggle.BackgroundColor3 = Color3.fromRGB(25, 55, 35)
    else
        SlideToggle.Text = "Giữ Slide (Inf Slide): OFF"
        SlideToggle.TextColor3 = Color3.fromRGB(255, 85, 85)
        SlideToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    end
end)

JumpToggle.MouseButton1Click:Connect(function()
    autoJumpEnabled = not autoJumpEnabled
    if autoJumpEnabled then
        JumpToggle.Text = "Auto Giữ Nút Nhảy: ON"
        JumpToggle.TextColor3 = Color3.fromRGB(85, 255, 127)
        JumpToggle.BackgroundColor3 = Color3.fromRGB(25, 55, 35)
    else
        JumpToggle.Text = "Auto Giữ Nút Nhảy: OFF"
        JumpToggle.TextColor3 = Color3.fromRGB(255, 85, 85)
        JumpToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
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
