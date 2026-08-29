local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- Tự động xác định Parent GUI phù hợp
local parentGui = (gethui and gethui()) or CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")

-- Xóa GUI cũ nếu đã chạy trước đó
if parentGui:FindFirstChild("TeacherESP_GUI") then
    parentGui:FindFirstChild("TeacherESP_GUI"):Destroy()
end

-- Canvas GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeacherESP_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = parentGui

-- Khung chính (Main Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 115)
mainFrame.Position = UDim2.new(0.5, -110, 0.35, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 60, 60)
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.25
mainStroke.Parent = mainFrame

-- Thanh tiêu đề (Title Bar - Dùng để kéo thả)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -35, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "ESP Teacher Controller"
titleText.TextColor3 = Color3.fromRGB(240, 240, 240)
titleText.TextSize = 12
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Nút Thu Gọn (-)
local miniBtn = Instance.new("TextButton")
miniBtn.Name = "MinimizeButton"
miniBtn.Size = UDim2.new(0, 22, 0, 22)
miniBtn.Position = UDim2.new(1, -27, 0, 5)
miniBtn.BackgroundColor3 = Color3.fromRGB(48, 48, 58)
miniBtn.Text = "-"
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.TextSize = 14
miniBtn.Font = Enum.Font.GothamBold
miniBtn.Parent = titleBar

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 4)
miniCorner.Parent = miniBtn

-- Vùng chứa nội dung
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -32)
contentFrame.Position = UDim2.new(0, 0, 0, 32)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Nút Bật/Tắt ESP
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleESP"
toggleBtn.Size = UDim2.new(1, -20, 0, 34)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
toggleBtn.Text = "ESP Giáo Viên: TẮT"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 12
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = contentFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 18)
statusLabel.Position = UDim2.new(0, 10, 0, 48)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Trạng thái: Chưa kích hoạt"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = contentFrame

----------------------------------------------------
-- TÍNH NĂNG KÉO THẢ (DRAGGABLE)
----------------------------------------------------
local dragging, dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

----------------------------------------------------
-- TÍNH NĂNG THU GỌN / MỞ RỘNG
----------------------------------------------------
local isMinimized = false
miniBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame:TweenSize(UDim2.new(0, 220, 0, 32), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.18, true)
        miniBtn.Text = "+"
        contentFrame.Visible = false
    else
        mainFrame:TweenSize(UDim2.new(0, 220, 0, 115), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.18, true)
        miniBtn.Text = "-"
        contentFrame.Visible = true
    end
end)

----------------------------------------------------
-- HỆ THỐNG ESP & HIGHLIGHT KHÔNG GIỚI HẠN Khoảng cách
----------------------------------------------------
local espEnabled = false
local activeESP = {}

-- Từ khóa nhận diện NPC (có thể thêm/sửa tên NPC trong game của bạn)
local targetKeywords = {"giáo viên", "giaovien", "teacher", "baldi", "miss", "mister"}

local function isTargetNPC(model)
    if not model:IsA("Model") then return false end
    if not model:FindFirstChildOfClass("Humanoid") then return false end
    
    local nameLower = string.lower(model.Name)
    for _, kw in ipairs(targetKeywords) do
        if string.find(nameLower, kw) then
            return true
        end
    end
    return false
end

local function applyESP(npc)
    if activeESP[npc] then return end

    local head = npc:FindFirstChild("Head") or npc.PrimaryPart or npc:FindFirstChildWhichIsA("BasePart")
    if not head then return end

    -- 1. Tên ESP hiển thị trên đầu
    local bgui = Instance.new("BillboardGui")
    bgui.Name = "TeacherNameESP"
    bgui.Adornee = head
    bgui.Size = UDim2.new(0, 160, 0, 40)
    bgui.StudsOffset = Vector3.new(0, 3, 0)
    bgui.AlwaysOnTop = true
    bgui.MaxDistance = math.huge -- Không giới hạn khoảng cách

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = "giáo viên⚠️"
    txt.TextColor3 = Color3.fromRGB(255, 45, 45)
    txt.TextTransparency = 0.25 -- Hơi mờ nhẹ nhưng nhìn rất rõ
    txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    txt.TextStrokeTransparency = 0.35
    txt.TextSize = 16
    txt.Font = Enum.Font.FredokaOne
    txt.Parent = bgui

    -- 2. Viền Highlight bao quanh thân NPC
    local hl = Instance.new("Highlight")
    hl.Name = "TeacherHighlightESP"
    hl.Adornee = npc
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Nhìn xuyên tường
    hl.FillColor = Color3.fromRGB(255, 50, 50)
    hl.FillTransparency = 0.55 -- Thân highlight hơi mờ nhẹ vừa đủ nhìn rõ
    hl.OutlineColor = Color3.fromRGB(255, 200, 200)
    hl.OutlineTransparency = 0.25
    hl.Parent = npc

    bgui.Parent = head
    activeESP[npc] = {Billboard = bgui, Highlight = hl}
end

local function removeESP(npc)
    if activeESP[npc] then
        if activeESP[npc].Billboard then activeESP[npc].Billboard:Destroy() end
        if activeESP[npc].Highlight then activeESP[npc].Highlight:Destroy() end
        activeESP[npc] = nil
    end
end

local function clearAllESP()
    for npc, _ in pairs(activeESP) do
        removeESP(npc)
    end
end

local function updateESP()
    if not espEnabled then
        clearAllESP()
        return
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if isTargetNPC(obj) then
            applyESP(obj)
        end
    end
end

-- Vòng lặp quét NPC liên tục khi bật ESP
task.spawn(function()
    while true do
        task.wait(1)
        if espEnabled then
            updateESP()
        end
    end
end)

-- Sự kiện nhấn nút Bật/Tắt
toggleBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        toggleBtn.Text = "ESP Giáo Viên: BẬT"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 175, 75)
        statusLabel.Text = "Trạng thái: Đang quét NPC..."
        statusLabel.TextColor3 = Color3.fromRGB(110, 230, 110)
        updateESP()
    else
        toggleBtn.Text = "ESP Giáo Viên: TẮT"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
        statusLabel.Text = "Trạng thái: Đã tắt"
        statusLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
        clearAllESP()
    end
end)
