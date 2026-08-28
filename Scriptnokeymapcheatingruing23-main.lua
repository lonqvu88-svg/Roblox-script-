-- ==========================================
-- 🛡️ TEACHER RADAR & ALERT SYSTEM
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ⚙️ CẤU HÌNH THÔNG SỐ (Có thể điều chỉnh)
local DETECT_DISTANCE = 45     -- Khoảng cách tối đa cảnh báo (Studs)
local FOV_ANGLE_THRESHOLD = 0.25 -- Độ rộng góc nhìn GV (> 0.25 là đang nhìn về phía bạn)

-- 🎨 TẠO INTERFACE (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeacherRadarGUI"
ScreenGui.ResetOnSpawn = false

-- Đảm bảo tương thích với các Executor (Gethui / CoreGui / PlayerGui)
if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Khung chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 270, 0, 135)
MainFrame.Position = UDim2.new(0.5, -135, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Thanh tiêu đề (Dùng để kéo thả)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(34, 36, 46)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Text = "🛡️ TEACHER RADAR"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Nút Thu gọn GUI
local MinBtn = Instance.new("TextButton")
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -32, 0, 2.5)
MinBtn.BackgroundTransparency = 1
MinBtn.Parent = TopBar

-- Vùng nội dung
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -45)
ContentFrame.Position = UDim2.new(0, 10, 0, 42)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Nhãn trạng thái chính
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 0, 42)
StatusLabel.BackgroundColor3 = Color3.fromRGB(46, 180, 90)
StatusLabel.Text = "✅ AN TOÀN"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 15
StatusLabel.Parent = ContentFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusLabel

-- Nhãn chi tiết
local DetailsLabel = Instance.new("TextLabel")
DetailsLabel.Size = UDim2.new(1, 0, 0, 30)
DetailsLabel.Position = UDim2.new(0, 0, 0, 48)
DetailsLabel.BackgroundTransparency = 1
DetailsLabel.Text = "Đang quét môi trường..."
DetailsLabel.TextColor3 = Color3.fromRGB(170, 175, 190)
DetailsLabel.Font = Enum.Font.Gotham
DetailsLabel.TextSize = 11
DetailsLabel.Parent = ContentFrame

-- ==========================================
-- 🖱️ CHỨC NĂNG KÉO THẢ & THU GỌN
-- ==========================================

local dragging, dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        ContentFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 270, 0, 35)
        MinBtn.Text = "+"
    else
        ContentFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 270, 0, 135)
        MinBtn.Text = "−"
    end
end)

-- ==========================================
-- 🧠 THUẬT TOÁN PHÁT HIỆN GIÁO VIÊN (LOGIC)
-- ==========================================

local function FindTeacher()
    -- Ưu tiên tìm Model có tên chứa "Teacher" hoặc "GiaoVien"
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("teacher") or obj.Name:lower():find("prof")) then
            if obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head") then
                return obj
            end
        end
    end
    -- Thuật toán dự phòng: Quét các NPC không phải người chơi
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
            if obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head") then
                return obj
            end
        end
    end
    return nil
end

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local teacher = FindTeacher()
    if not teacher then
        StatusLabel.Text = "🔍 ĐANG QUÉT GV..."
        StatusLabel.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
        DetailsLabel.Text = "Không tìm thấy NPC Giáo Viên trong Map"
        return
    end

    local teacherPart = teacher:FindFirstChild("Head") or teacher:FindFirstChild("HumanoidRootPart")
    local playerPart = char:FindFirstChild("Head") or char.HumanoidRootPart

    -- 1. Tính khoảng cách
    local distance = (teacherPart.Position - playerPart.Position).Magnitude

    -- 2. Tính hướng nhìn của Giáo Viên (Dot Product)
    local teacherLookVector = teacherPart.CFrame.LookVector
    local directionToPlayer = (playerPart.Position - teacherPart.Position).Unit
    local dotProduct = teacherLookVector:Dot(directionToPlayer)

    -- 3. Kiểm tra vật cản giữa GV và Player (Raycast Line-of-Sight)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {teacher, char}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local rayResult = workspace:Raycast(teacherPart.Position, (playerPart.Position - teacherPart.Position), raycastParams)
    local isVisionBlocked = (rayResult ~= nil) -- Nối thẳng bị vướng tường/bàn ghế

    -- 4. Đánh giá mức độ rủi ro
    if distance <= DETECT_DISTANCE and dotProduct > FOV_ANGLE_THRESHOLD and not isVisionBlocked then
        -- 🔥 NGUY HIỂM TỘT ĐỘ: Đang trong tầm mắt + không có vật cản
        StatusLabel.Text = "🚨 BỊ LÊN BẢNG! (GV ĐANG NHÌN)"
        StatusLabel.BackgroundColor3 = Color3.fromRGB(225, 45, 45)
        DetailsLabel.Text = string.format("Cách: %.1f studs | Góc nhìn: TRỰC TIẾP", distance)

    elseif distance <= DETECT_DISTANCE and dotProduct > FOV_ANGLE_THRESHOLD and isVisionBlocked then
        -- ⚠️ CẢNH BÁO: Đang nhìn về hướng mình nhưng có vật cản (bàn/tường)
        StatusLabel.Text = "⚠️ CẢNH BÁO (CÓ VẬT CẢN)"
        StatusLabel.BackgroundColor3 = Color3.fromRGB(235, 140, 20)
        DetailsLabel.Text = string.format("Cách: %.1f studs | Đã bị vật cản che", distance)

    elseif distance <= DETECT_DISTANCE then
        -- 🟡 TRONG BÁN KÍNH: Ở gần nhưng GV đang quay lưng đi chỗ khác
        StatusLabel.Text = "🟡 TRONG BÁN KÍNH GV"
        StatusLabel.BackgroundColor3 = Color3.fromRGB(210, 170, 30)
        DetailsLabel.Text = string.format("Cách: %.1f studs | GV đang quay hướng khác", distance)

    else
        -- 🟢 AN TOÀN: Ngoài bán kính nguy hiểm
        StatusLabel.Text = "✅ AN TOÀN"
        StatusLabel.BackgroundColor3 = Color3.fromRGB(46, 180, 90)
        DetailsLabel.Text = string.format("Cách: %.1f studs | Khoảng cách an toàn", distance)
    end
end)
