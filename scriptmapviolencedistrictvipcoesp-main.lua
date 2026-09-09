-- Pallet ESP Ultra (Optimized Performance & Warm Color Palette)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local MAX_DISTANCE = 350
local MAX_HIGHLIGHTS = 25
local ESP_ENABLED = true

-- Cấu hình màu sắc dịu mắt (Vàng Amber ấm)
local MAIN_COLOR = Color3.fromRGB(235, 175, 85)       -- Màu khối Highlight & GUI
local TEXT_COLOR = Color3.fromRGB(255, 230, 170)       -- Màu chữ Pallet
local BG_COLOR = Color3.fromRGB(22, 24, 30)           -- Nền GUI
local HEADER_COLOR = Color3.fromRGB(30, 34, 44)       -- Header GUI

local Cache = {}
local KnownPallets = {}

-- 1. Khởi tạo ScreenGUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PalletESP_Optimized"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 95)
MainFrame.Position = UDim2.new(0.5, -100, 0.2, 0)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = MAIN_COLOR
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = HEADER_COLOR
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Pallet ESP (Warm)"
Title.TextColor3 = MAIN_COLOR
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 22, 0, 22)
MinBtn.Position = UDim2.new(1, -25, 0, 4)
MinBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.Parent = Header

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, -20, 0, 38)
ToggleBtn.Position = UDim2.new(0, 10, 0, 42)
ToggleBtn.BackgroundColor3 = MAIN_COLOR
ToggleBtn.Text = "PALLET ESP: ON"
ToggleBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 13
ToggleBtn.Parent = MainFrame

-- Logic Drag GUI
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Thu gọn GUI
local isMin = false
MinBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    MainFrame:TweenSize(isMin and UDim2.new(0, 200, 0, 30) or UDim2.new(0, 200, 0, 95), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
    MinBtn.Text = isMin and "+" or "-"
    ToggleBtn.Visible = not isMin
end)

-- 2. Hệ thống Cache & Nhận diện Pallet (Chống Lag)
local function getPalletTarget(inst)
    local nameLower = string.lower(inst.Name)
    if string.find(nameLower, "pallet") then
        if inst:IsA("Model") then
            return inst
        elseif inst:IsA("BasePart") then
            local model = inst:FindFirstAncestorOfClass("Model")
            if model and model ~= Workspace then
                return model
            end
            return inst
        end
    end
    return nil
end

local function registerPallet(obj)
    local target = getPalletTarget(obj)
    if target then
        KnownPallets[target] = true
    end
end

-- Quét ban đầu 1 lần duy nhất
for _, obj in ipairs(Workspace:GetDescendants()) do
    registerPallet(obj)
end

-- Tự động cập nhật khi có vật thể mới/bị xóa
Workspace.DescendantAdded:Connect(registerPallet)
Workspace.DescendantRemoving:Connect(function(obj)
    if KnownPallets[obj] then
        KnownPallets[obj] = nil
    end
    if Cache[obj] then
        if Cache[obj].Highlight then Cache[obj].Highlight:Destroy() end
        if Cache[obj].Billboard then Cache[obj].Billboard:Destroy() end
        Cache[obj] = nil
    end
end)

local function removeESP(target)
    if Cache[target] then
        if Cache[target].Highlight then Cache[target].Highlight:Destroy() end
        if Cache[target].Billboard then Cache[target].Billboard:Destroy() end
        Cache[target] = nil
    end
end

local function clearAllESP()
    for target, _ in pairs(Cache) do
        removeESP(target)
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    ToggleBtn.Text = ESP_ENABLED and "PALLET ESP: ON" or "PALLET ESP: OFF"
    ToggleBtn.BackgroundColor3 = ESP_ENABLED and MAIN_COLOR or Color3.fromRGB(160, 60, 60)
    ToggleBtn.TextColor3 = ESP_ENABLED and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 255, 255)
    if not ESP_ENABLED then clearAllESP() end
end)

-- 3. Vòng lặp cập nhật khoảng cách & ESP (Đã tối ưu CPU)
task.spawn(function()
    while true do
        task.wait(0.2)
        if ESP_ENABLED then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            if hrp then
                local myPos = hrp.Position
                local palletList = {}

                -- Chỉ duyệt các Pallet đã lưu trong danh sách (Không quét lại Workspace)
                for target, _ in pairs(KnownPallets) do
                    if target and target.Parent then
                        local pos = target:IsA("Model") and target:GetPivot().Position or target.Position
                        local dist = (myPos - pos).Magnitude

                        if dist <= MAX_DISTANCE then
                            table.insert(palletList, {Target = target, Dist = math.floor(dist)})
                        end
                    else
                        KnownPallets[target] = nil
                    end
                end

                -- Sắp xếp khoảng cách từ gần đến xa
                table.sort(palletList, function(a, b) return a.Dist < b.Dist end)

                local currentVisibleTargets = {}

                for index, item in ipairs(palletList) do
                    local target = item.Target
                    local dist = item.Dist
                    currentVisibleTargets[target] = true

                    if not Cache[target] then
                        -- Chữ hiển thị 3D
                        local bb = Instance.new("BillboardGui")
                        bb.Name = "Pallet_Text"
                        bb.Size = UDim2.new(0, 140, 0, 25)
                        bb.StudsOffset = Vector3.new(0, 2, 0)
                        bb.AlwaysOnTop = true
                        
                        local targetPart = target:IsA("Model") and (target.PrimaryPart or target:FindFirstChildOfClass("BasePart")) or target
                        bb.Adornee = targetPart or target
                        
                        local lbl = Instance.new("TextLabel")
                        lbl.Name = "Label"
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.Text = string.format("Pallet [%dm]", dist)
                        lbl.TextColor3 = TEXT_COLOR
                        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) -- Đổ bóng đen giúp rõ ban ngày
                        lbl.TextStrokeTransparency = 0.2
                        lbl.Font = Enum.Font.SourceSansBold
                        lbl.TextSize = 13
                        lbl.Parent = bb
                        bb.Parent = ScreenGui

                        -- Khối Highlight dịu mắt (Không viền)
                        local hl = nil
                        if index <= MAX_HIGHLIGHTS then
                            hl = Instance.new("Highlight")
                            hl.Name = "Pallet_HL"
                            hl.Adornee = target
                            hl.FillColor = MAIN_COLOR
                            hl.FillTransparency = 0.65 -- Mức trong suốt dịu mắt ban đêm
                            hl.OutlineTransparency = 1 -- ĐÃ TẮT VIỀN ESP
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Parent = target
                        end

                        Cache[target] = { Highlight = hl, Billboard = bb }
                    else
                        -- Cập nhật lại số mét
                        local lbl = Cache[target].Billboard:FindFirstChild("Label")
                        if lbl then lbl.Text = string.format("Pallet [%dm]", dist) end

                        -- Bật/tắt highlight dựa theo giới hạn khoảng cách gần nhất
                        if index <= MAX_HIGHLIGHTS and not Cache[target].Highlight then
                            local hl = Instance.new("Highlight")
                            hl.Name = "Pallet_HL"
                            hl.Adornee = target
                            hl.FillColor = MAIN_COLOR
                            hl.FillTransparency = 0.65
                            hl.OutlineTransparency = 1 -- ĐÃ TẮT VIỀN ESP
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Parent = target
                            Cache[target].Highlight = hl
                        elseif index > MAX_HIGHLIGHTS and Cache[target].Highlight then
                            Cache[target].Highlight:Destroy()
                            Cache[target].Highlight = nil
                        end
                    end
                end

                -- Xóa ESP của các pallet nằm ngoài phạm vi hoặc đã bị phá hủy
                for target, _ in pairs(Cache) do
                    if not currentVisibleTargets[target] then
                        removeESP(target)
                    end
                end
            end
        end
    end
end)
