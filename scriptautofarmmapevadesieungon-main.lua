-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Dọn dẹp RenderStep & GUI cũ
pcall(function() RunService:UnbindFromRenderStep("EvadeCamFollow") end)

local parentGui = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

if parentGui:FindFirstChild("EvadeOptimizedHub") then
    parentGui.EvadeOptimizedHub:Destroy()
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EvadeOptimizedHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = parentGui

-- ---------------------------------------------------------
-- NÚT BẬT/TẮT GUI NỔI
-- ---------------------------------------------------------
local openCloseBtn = Instance.new("TextButton")
openCloseBtn.Name = "OpenCloseBtn"
openCloseBtn.Size = UDim2.new(0, 50, 0, 50)
openCloseBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
openCloseBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
openCloseBtn.Text = "MENU"
openCloseBtn.TextColor3 = Color3.fromRGB(85, 235, 145)
openCloseBtn.TextSize = 11
openCloseBtn.Font = Enum.Font.GothamBold
openCloseBtn.Active = true
openCloseBtn.Parent = screenGui

Instance.new("UICorner", openCloseBtn).CornerRadius = UDim.new(1, 0)
local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(85, 235, 145)
openStroke.Thickness = 2
openStroke.Parent = openCloseBtn

local btnDragging, btnDragStart, btnStartPos
openCloseBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = true
        btnDragStart = input.Position
        btnStartPos = openCloseBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - btnDragStart
        openCloseBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
    end
end)
openCloseBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = false
    end
end)

-- ---------------------------------------------------------
-- KHUNG CHÍNH (MAIN FRAME)
-- ---------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 380)
mainFrame.Position = UDim2.new(0.5, -120, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(50, 55, 70)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "EVADE HUB v6.6 (SMART VIP)"
titleLabel.TextColor3 = Color3.fromRGB(220, 225, 235)
titleLabel.TextSize = 11
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local guiVisible = true
local function toggleGuiVisibility()
    guiVisible = not guiVisible
    mainFrame.Visible = guiVisible
    openCloseBtn.TextColor3 = guiVisible and Color3.fromRGB(85, 235, 145) or Color3.fromRGB(235, 85, 85)
    openStroke.Color = guiVisible and Color3.fromRGB(85, 235, 145) or Color3.fromRGB(235, 85, 85)
end

openCloseBtn.MouseButton1Click:Connect(toggleGuiVisibility)

local dragging, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ---------------------------------------------------------
-- TẠO NÚT BẤM MẪU
-- ---------------------------------------------------------
local function createButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 26)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(235, 85, 85)
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = mainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local function createHalfButton(text, posX, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.435, 0, 0, 26)
    btn.Position = UDim2.new(posX, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(235, 85, 85)
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = mainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

-- ---------------------------------------------------------
-- BỐ TRÍ CÁC NÚT BẤM
-- ---------------------------------------------------------
-- Hàng 1: Auto Farm ON/OFF (Y = 33)
local autoFarmBtn = createButton("AUTO FARM: OFF", 33)

-- Hàng 2: Chọn Chế Độ Farm Cuộn (Y = 64)
local selectFarmModeModalBtn = createButton("CHẾ ĐỘ FARM: 🌌 Sky High (1,500m)", 64)
selectFarmModeModalBtn.TextColor3 = Color3.fromRGB(85, 205, 255)

-- Hàng 3: Chọn Player Target (Y = 95)
local selectPlayerModalBtn = createButton("CHỌN PLAYER: [CHƯA CHỌN]", 95)
selectPlayerModalBtn.TextColor3 = Color3.fromRGB(180, 200, 240)

-- Hàng 4: SPECTATE CAM + NÚT ĐỔI CAM QUICK SWITCH (Y = 126)
local spectateBtn = Instance.new("TextButton")
spectateBtn.Size = UDim2.new(0.52, 0, 0, 26)
spectateBtn.Position = UDim2.new(0.05, 0, 0, 126)
spectateBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
spectateBtn.Text = "🎥 SPECTATE: OFF"
spectateBtn.TextColor3 = Color3.fromRGB(235, 85, 85)
spectateBtn.TextSize = 9
spectateBtn.Font = Enum.Font.GothamBold
spectateBtn.Parent = mainFrame
Instance.new("UICorner", spectateBtn).CornerRadius = UDim.new(0, 6)

local cycleCamBtn = Instance.new("TextButton")
cycleCamBtn.Size = UDim2.new(0.35, 0, 0, 26)
cycleCamBtn.Position = UDim2.new(0.60, 0, 0, 126)
cycleCamBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
cycleCamBtn.Text = "⏭️ ĐỔI CAM"
cycleCamBtn.TextColor3 = Color3.fromRGB(255, 220, 100)
cycleCamBtn.TextSize = 9
cycleCamBtn.Font = Enum.Font.GothamBold
cycleCamBtn.Parent = mainFrame
Instance.new("UICorner", cycleCamBtn).CornerRadius = UDim.new(0, 6)

-- Hàng 5: ESP Target & ESP All (Y = 157)
local espTargetBtn = createHalfButton("ESP TARGET: OFF", 0.05, 157)
local espAllBtn = createHalfButton("ESP ALL: OFF", 0.515, 157)

-- Hàng 6: Teleport Target (Y = 188)
local tpBtn = createButton("TELEPORT TARGET: OFF", 188)

-- Hàng 7: VFLY + Speed (Y = 219)
local vflyBtn = Instance.new("TextButton")
vflyBtn.Size = UDim2.new(0.62, 0, 0, 26)
vflyBtn.Position = UDim2.new(0.05, 0, 0, 219)
vflyBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
vflyBtn.Text = "VFLY: OFF"
vflyBtn.TextColor3 = Color3.fromRGB(235, 85, 85)
vflyBtn.TextSize = 10
vflyBtn.Font = Enum.Font.GothamBold
vflyBtn.Parent = mainFrame
Instance.new("UICorner", vflyBtn).CornerRadius = UDim.new(0, 6)

local flySpeedBox = Instance.new("TextBox")
flySpeedBox.Size = UDim2.new(0.26, 0, 0, 26)
flySpeedBox.Position = UDim2.new(0.69, 0, 0, 219)
flySpeedBox.BackgroundColor3 = Color3.fromRGB(12, 13, 16)
flySpeedBox.Text = "50"
flySpeedBox.PlaceholderText = "Speed"
flySpeedBox.TextColor3 = Color3.fromRGB(85, 235, 145)
flySpeedBox.TextSize = 10
flySpeedBox.Font = Enum.Font.GothamBold
flySpeedBox.Parent = mainFrame
Instance.new("UICorner", flySpeedBox).CornerRadius = UDim.new(0, 6)

-- Hàng 8: Noclip (Y = 250)
local noclipBtn = createButton("NOCLIP: OFF", 250)

-- Hàng 9: Auto Farm Token Infinite (Y = 281)
local tokenFarmBtn = createButton("⚡ AUTO FARM TOKEN INFINITE", 281)
tokenFarmBtn.TextColor3 = Color3.fromRGB(185, 120, 255)

-- Hàng 10: Auto Revive Script (Y = 312)
local reviveScriptBtn = createButton("🩸 AUTO REVIVE (CẦN GET KEY)", 312)
reviveScriptBtn.TextColor3 = Color3.fromRGB(255, 120, 120)

-- Hàng 11: Smart VIP Server Hop (Y = 343)
local serverHopBtn = createButton("👑 SMART VIP SERVER (SVR KÍN)", 343)
serverHopBtn.TextColor3 = Color3.fromRGB(255, 215, 0)

-- ---------------------------------------------------------
-- MENU CUỘN CHỌN AFK FARM MODE
-- ---------------------------------------------------------
local farmPickerFrame = Instance.new("Frame")
farmPickerFrame.Name = "FarmPickerFrame"
farmPickerFrame.Size = UDim2.new(0, 220, 0, 250)
farmPickerFrame.Position = UDim2.new(1, 10, 0, 0)
farmPickerFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
farmPickerFrame.BorderSizePixel = 0
farmPickerFrame.Visible = false
farmPickerFrame.Parent = mainFrame

Instance.new("UICorner", farmPickerFrame).CornerRadius = UDim.new(0, 8)
local farmPickerStroke = Instance.new("UIStroke")
farmPickerStroke.Color = Color3.fromRGB(60, 65, 80)
farmPickerStroke.Thickness = 1
farmPickerStroke.Parent = farmPickerFrame

local farmTitleBar = Instance.new("TextLabel")
farmTitleBar.Size = UDim2.new(1, 0, 0, 28)
farmTitleBar.BackgroundTransparency = 1
farmTitleBar.Text = "CHỌN CHẾ ĐỘ AFK FARM"
farmTitleBar.TextColor3 = Color3.fromRGB(85, 205, 255)
farmTitleBar.TextSize = 10
farmTitleBar.Font = Enum.Font.GothamBold
farmTitleBar.Parent = farmPickerFrame

local farmScroll = Instance.new("ScrollingFrame")
farmScroll.Size = UDim2.new(0.92, 0, 0, 210)
farmScroll.Position = UDim2.new(0.04, 0, 0.12, 0)
farmScroll.BackgroundColor3 = Color3.fromRGB(12, 13, 16)
farmScroll.BorderSizePixel = 0
farmScroll.ScrollBarThickness = 3
farmScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 85, 100)
farmScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
farmScroll.Parent = farmPickerFrame
Instance.new("UICorner", farmScroll).CornerRadius = UDim.new(0, 5)

local farmListLayout = Instance.new("UIListLayout")
farmListLayout.Padding = UDim.new(0, 4)
farmListLayout.SortOrder = Enum.SortOrder.LayoutOrder
farmListLayout.Parent = farmScroll

local farmListPadding = Instance.new("UIPadding")
farmListPadding.PaddingTop = UDim.new(0, 4)
farmListPadding.PaddingLeft = UDim.new(0, 4)
farmListPadding.PaddingRight = UDim.new(0, 4)
farmListPadding.Parent = farmScroll

selectFarmModeModalBtn.MouseButton1Click:Connect(function()
    farmPickerFrame.Visible = not farmPickerFrame.Visible
end)

local farmModes = {
    {name = "🌌 Sky High (1,500m)", pos = Vector3.new(0, 1500, 0)},
    {name = "🚀 Stratosphere (3,000m)", pos = Vector3.new(0, 3000, 0)},
    {name = "🪐 Deep Void (5,000m)", pos = Vector3.new(0, 5000, 0)},
    {name = "🕳️ Under Map (-200m)", pos = Vector3.new(0, -200, 0)},
    {name = "🧭 Edge North (1,200m)", pos = Vector3.new(0, 1200, 3000)},
    {name = "🧭 Edge South (1,200m)", pos = Vector3.new(0, 1200, -3000)},
    {name = "🧭 Edge East (1,200m)", pos = Vector3.new(3000, 1200, 0)},
    {name = "🧭 Edge West (1,200m)", pos = Vector3.new(-3000, 1200, 0)},
    {name = "⚡ Dynamic Jitter (An Toàn)", dynamic = "jitter"},
    {name = "🌀 High Orbit (Quay Vòng)", dynamic = "orbit"}
}

local currentFarmModeIndex = 1
local farmButtons = {}

for idx, mode in ipairs(farmModes) do
    local fBtn = Instance.new("TextButton")
    fBtn.Size = UDim2.new(1, 0, 0, 25)
    fBtn.Font = Enum.Font.GothamMedium
    fBtn.TextSize = 9
    fBtn.Text = mode.name
    fBtn.TextXAlignment = Enum.TextXAlignment.Left
    fBtn.TextColor3 = (idx == currentFarmModeIndex) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 185, 200)
    fBtn.BackgroundColor3 = (idx == currentFarmModeIndex) and Color3.fromRGB(40, 110, 200) or Color3.fromRGB(22, 25, 32)
    fBtn.Parent = farmScroll
    Instance.new("UICorner", fBtn).CornerRadius = UDim.new(0, 4)

    local fPad = Instance.new("UIPadding")
    fPad.PaddingLeft = UDim.new(0, 6)
    fPad.Parent = fBtn

    farmButtons[idx] = fBtn

    fBtn.MouseButton1Click:Connect(function()
        currentFarmModeIndex = idx
        selectFarmModeModalBtn.Text = "CHẾ ĐỘ FARM: " .. mode.name
        farmPickerFrame.Visible = false

        for i, btn in ipairs(farmButtons) do
            btn.BackgroundColor3 = (i == currentFarmModeIndex) and Color3.fromRGB(40, 110, 200) or Color3.fromRGB(22, 25, 32)
            btn.TextColor3 = (i == currentFarmModeIndex) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 185, 200)
        end
    end)
end

-- ---------------------------------------------------------
-- MENU CUỘN CHỌN PLAYER (PLAYER PICKER FRAME)
-- ---------------------------------------------------------
local playerPickerFrame = Instance.new("Frame")
playerPickerFrame.Name = "PlayerPickerFrame"
playerPickerFrame.Size = UDim2.new(0, 220, 0, 250)
playerPickerFrame.Position = UDim2.new(1, 10, 0, 0)
playerPickerFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
playerPickerFrame.BorderSizePixel = 0
playerPickerFrame.Visible = false
playerPickerFrame.Parent = mainFrame

Instance.new("UICorner", playerPickerFrame).CornerRadius = UDim.new(0, 8)
local pickerStroke = Instance.new("UIStroke")
pickerStroke.Color = Color3.fromRGB(60, 65, 80)
pickerStroke.Thickness = 1
pickerStroke.Parent = playerPickerFrame

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0.9, 0, 0, 26)
searchBox.Position = UDim2.new(0.05, 0, 0.04, 0)
searchBox.BackgroundColor3 = Color3.fromRGB(12, 13, 16)
searchBox.PlaceholderText = "🔍 Tìm player..."
searchBox.PlaceholderColor3 = Color3.fromRGB(100, 105, 120)
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(220, 225, 235)
searchBox.TextSize = 10
searchBox.Font = Enum.Font.GothamMedium
searchBox.ClearTextOnFocus = false
searchBox.Parent = playerPickerFrame
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 5)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0.9, 0, 0, 200)
scrollFrame.Position = UDim2.new(0.05, 0, 0.16, 0)
scrollFrame.BackgroundColor3 = Color3.fromRGB(12, 13, 16)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 85, 100)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = playerPickerFrame
Instance.new("UICorner", scrollFrame).CornerRadius = UDim.new(0, 5)

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 3)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 3)
listPadding.PaddingLeft = UDim.new(0, 3)
listPadding.PaddingRight = UDim.new(0, 3)
listPadding.Parent = scrollFrame

selectPlayerModalBtn.MouseButton1Click:Connect(function()
    playerPickerFrame.Visible = not playerPickerFrame.Visible
end)

-- ---------------------------------------------------------
-- TỐI ƯU HÓA HỆ THỐNG ESP (FIX LAG & PING)
-- ---------------------------------------------------------
local targetEspGui = Instance.new("BillboardGui")
targetEspGui.Name = "PersistentTargetESP"
targetEspGui.AlwaysOnTop = true
targetEspGui.Size = UDim2.new(0, 200, 0, 30)
targetEspGui.StudsOffset = Vector3.new(0, 3.5, 0)
targetEspGui.Enabled = false
targetEspGui.Parent = screenGui

local espTextLabel = Instance.new("TextLabel")
espTextLabel.Name = "ESPLabel"
espTextLabel.Size = UDim2.new(1, 0, 1, 0)
espTextLabel.BackgroundTransparency = 1
espTextLabel.TextStrokeTransparency = 0.2
espTextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
espTextLabel.Font = Enum.Font.GothamBold
espTextLabel.TextSize = 13
espTextLabel.Parent = targetEspGui

local targetHighlight = Instance.new("Highlight")
targetHighlight.Name = "TargetHighlight"
targetHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
targetHighlight.FillTransparency = 0.4
targetHighlight.OutlineTransparency = 0
targetHighlight.Enabled = false
targetHighlight.Parent = screenGui

local allEspGuis = {}
local allHighlights = {}

local function getOrCreateEspForPlayer(plr)
    if allEspGuis[plr] then return allEspGuis[plr] end

    local bGui = Instance.new("BillboardGui")
    bGui.Name = "EspAll_" .. plr.Name
    bGui.AlwaysOnTop = true
    bGui.Size = UDim2.new(0, 200, 0, 30)
    bGui.StudsOffset = Vector3.new(0, 3.5, 0)
    bGui.Enabled = false
    bGui.Parent = screenGui

    local txt = Instance.new("TextLabel")
    txt.Name = "ESPLabel"
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.TextStrokeTransparency = 0.2
    txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 12
    txt.Parent = bGui

    allEspGuis[plr] = bGui
    return bGui
end

local function getOrCreateHighlightForPlayer(plr)
    if allHighlights[plr] then return allHighlights[plr] end

    local hl = Instance.new("Highlight")
    hl.Name = "EspHlAll_" .. plr.Name
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.Enabled = false
    hl.Parent = screenGui

    allHighlights[plr] = hl
    return hl
end

local function removeEspForPlayer(plr)
    if allEspGuis[plr] then allEspGuis[plr]:Destroy() allEspGuis[plr] = nil end
    if allHighlights[plr] then allHighlights[plr]:Destroy() allHighlights[plr] = nil end
end

Players.PlayerRemoving:Connect(removeEspForPlayer)

-- ---------------------------------------------------------
-- LOGIC KIỂM TRA TRẠNG THÁI
-- ---------------------------------------------------------
local autoFarmEnabled = false
local safePlatform = nil
local spectateEnabled = false
local espTargetEnabled = false
local espAllEnabled = false
local tpEnabled = false
local selectedPlayer = nil
local originalCFrame = nil
local tpThread = nil

local vflyEnabled = false
local flySpeed = 50
local bodyVel, bodyGyro = nil, nil
local vflyLoop = nil

local noclipEnabled = false
local noclipConnection = nil
local playerButtons = {}

local function getCharacterPart(char)
    if not char then return nil end
    return char.PrimaryPart or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
end

local function isDowned(plr)
    if not plr or not plr.Character then return false end
    local char = plr.Character
    
    if char:GetAttribute("Downed") or plr:GetAttribute("Downed") 
        or char:GetAttribute("Incapacitated") or plr:GetAttribute("Incapacitated")
        or char:GetAttribute("Down") then
        return true
    end

    if char:FindFirstChild("Downed") or char:FindFirstChild("Incapacitated") or char:FindFirstChild("Revive") then
        return true
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and (hum.PlatformStand or hum:GetState() == Enum.HumanoidStateType.Physics) then
        return true
    end

    return false
end

-- NOCLIP
local function setNoclip(enabled)
    noclipEnabled = enabled
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end

    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = true end
            end
        end
    end
end

noclipBtn.MouseButton1Click:Connect(function()
    setNoclip(not noclipEnabled)
    noclipBtn.Text = noclipEnabled and "NOCLIP: ON" or "NOCLIP: OFF"
    noclipBtn.TextColor3 = noclipEnabled and Color3.fromRGB(85, 235, 145) or Color3.fromRGB(235, 85, 85)
    noclipBtn.BackgroundColor3 = noclipEnabled and Color3.fromRGB(28, 52, 38) or Color3.fromRGB(35, 38, 48)
end)

-- VFLY
local function stopVFly()
    if vflyLoop then vflyLoop:Disconnect() vflyLoop = nil end
    if bodyVel then bodyVel:Destroy() bodyVel = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false end
end

local function startVFly()
    stopVFly()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    hum.PlatformStand = true

    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bodyVel.Velocity = Vector3.zero
    bodyVel.Parent = root

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bodyGyro.P = 9000
    bodyGyro.CFrame = root.CFrame
    bodyGyro.Parent = root

    vflyLoop = RunService.RenderStepped:Connect(function()
        if not vflyEnabled or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            stopVFly()
            return
        end
        local currentHum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if currentHum then
            currentHum.PlatformStand = true
            local moveDir = currentHum.MoveDirection
            if moveDir.Magnitude > 0 then
                local lookVec = Camera.CFrame.LookVector
                local flatLook = Vector3.new(lookVec.X, 0, lookVec.Z)
                flatLook = flatLook.Magnitude > 0 and flatLook.Unit or Vector3.new(0, 0, -1)
                
                local flatCamCF = CFrame.new(Vector3.zero, flatLook)
                local localMove = flatCamCF:VectorToObjectSpace(moveDir)
                local flyDir = Camera.CFrame:VectorToWorldSpace(localMove)
                
                bodyVel.Velocity = flyDir * flySpeed
            else
                bodyVel.Velocity = Vector3.zero
            end
            bodyGyro.CFrame = Camera.CFrame
        end
    end)
end

vflyBtn.MouseButton1Click:Connect(function()
    vflyEnabled = not vflyEnabled
    vflyBtn.Text = vflyEnabled and "VFLY: ON" or "VFLY: OFF"
    vflyBtn.TextColor3 = vflyEnabled and Color3.fromRGB(85, 235, 145) or Color3.fromRGB(235, 85, 85)
    vflyBtn.BackgroundColor3 = vflyEnabled and Color3.fromRGB(28, 52, 38) or Color3.fromRGB(35, 38, 48)

    if vflyEnabled then startVFly() else stopVFly() end
end)

flySpeedBox.FocusLost:Connect(function()
    local val = tonumber(flySpeedBox.Text)
    if val then flySpeed = val else flySpeedBox.Text = tostring(flySpeed) end
end)

-- AUTO FARM ENGINE
local function getSafePlatform(pos)
    if not safePlatform or not safePlatform.Parent then
        safePlatform = Instance.new("Part")
        safePlatform.Name = "EvadeMultiPlatform"
        safePlatform.Size = Vector3.new(50, 2, 50)
        safePlatform.Anchored = true
        safePlatform.Transparency = 0.5
        safePlatform.Material = Enum.Material.ForceField
        safePlatform.Parent = Workspace
    end
    safePlatform.Position = pos
    return safePlatform
end

autoFarmBtn.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    autoFarmBtn.Text = autoFarmEnabled and "AUTO FARM: ON" or "AUTO FARM: OFF"
    autoFarmBtn.TextColor3 = autoFarmEnabled and Color3.fromRGB(85, 235, 145) or Color3.fromRGB(235, 85, 85)
    autoFarmBtn.BackgroundColor3 = autoFarmEnabled and Color3.fromRGB(28, 52, 38) or Color3.fromRGB(35, 38, 48)
end)

task.spawn(function()
    local orbitAngle = 0
    while true do
        if autoFarmEnabled and not tpEnabled then
            pcall(function()
                local mode = farmModes[currentFarmModeIndex]
                local targetPos = Vector3.zero

                if mode.dynamic == "jitter" then
                    targetPos = Vector3.new(math.random(-50, 50), 1500 + math.random(-5, 5), math.random(-50, 50))
                elseif mode.dynamic == "orbit" then
                    orbitAngle = orbitAngle + 0.1
                    targetPos = Vector3.new(math.cos(orbitAngle) * 500, 1800, math.sin(orbitAngle) * 500)
                else
                    targetPos = mode.pos
                end

                local plat = getSafePlatform(targetPos)
                local myPart = getCharacterPart(LocalPlayer.Character)
                if myPart then
                    local dist = (myPart.Position - targetPos).Magnitude
                    if dist > 30 then
                        LocalPlayer.Character:PivotTo(plat.CFrame + Vector3.new(0, 4, 0))
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- ANTI AFK
task.spawn(function()
    pcall(function()
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
end)

-- ---------------------------------------------------------
-- CHỨC NĂNG SPECTATE PLAYER CAMERA REAL-TIME
-- ---------------------------------------------------------
local function updateCameraSubject()
    if spectateEnabled and selectedPlayer and selectedPlayer.Character then
        local targetHum = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
        if targetHum then
            Camera.CameraType = Enum.CameraType.Custom
            Camera.CameraSubject = targetHum
            return
        end
    end

    if LocalPlayer.Character then
        local myHum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if myHum then
            Camera.CameraType = Enum.CameraType.Custom
            Camera.CameraSubject = myHum
        end
    end
end

spectateBtn.MouseButton1Click:Connect(function()
    if not selectedPlayer and not spectateEnabled then
        local validPlayers = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(validPlayers, p) end
        end
        if #validPlayers > 0 then
            selectedPlayer = validPlayers[1]
            selectPlayerModalBtn.Text = "PLAYER: " .. selectedPlayer.DisplayName
        end
    end

    spectateEnabled = not spectateEnabled
    spectateBtn.Text = spectateEnabled and "🎥 SPECTATE: ON" or "🎥 SPECTATE: OFF"
    spectateBtn.TextColor3 = spectateEnabled and Color3.fromRGB(85, 235, 145) or Color3.fromRGB(235, 85, 85)
    spectateBtn.BackgroundColor3 = spectateEnabled and Color3.fromRGB(28, 52, 38) or Color3.fromRGB(35, 38, 48)

    updateCameraSubject()
end)

local function cycleNextPlayer()
    local validPlayers = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(validPlayers, p) end
    end

    if #validPlayers == 0 then
        selectPlayerModalBtn.Text = "CHỌN PLAYER: [KHÔNG CÓ AI]"
        return
    end

    local currentIndex = 0
    for i, p in ipairs(validPlayers) do
        if p == selectedPlayer then currentIndex = i break end
    end

    local nextIndex = currentIndex + 1
    if nextIndex > #validPlayers then nextIndex = 1 end

    selectedPlayer = validPlayers[nextIndex]
    selectPlayerModalBtn.Text = "PLAYER: " .. selectedPlayer.DisplayName

    for p, _ in pairs(playerButtons) do updateButtonAppearance(p) end

    if spectateEnabled then updateCameraSubject() end
end

cycleCamBtn.MouseButton1Click:Connect(cycleNextPlayer)

-- ESP & SPECTATE RENDER LOOP
task.spawn(function()
    while true do
        task.wait(0.08)

        if spectateEnabled and selectedPlayer and selectedPlayer.Character then
            local targetHum = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
            if targetHum and Camera.CameraSubject ~= targetHum then
                Camera.CameraType = Enum.CameraType.Custom
                Camera.CameraSubject = targetHum
            end
        end

        local myPart = getCharacterPart(LocalPlayer.Character)

        -- Target ESP
        if espTargetEnabled and selectedPlayer then
            local targetChar = selectedPlayer.Character
            local targetPart = getCharacterPart(targetChar)
            if myPart and targetPart and targetChar then
                local distance = (myPart.Position - targetPart.Position).Magnitude
                if distance <= 5000 then
                    targetEspGui.Adornee = targetPart
                    targetEspGui.Enabled = true
                    targetHighlight.Adornee = targetChar
                    targetHighlight.Enabled = true

                    local downed = isDowned(selectedPlayer)
                    espTextLabel.Text = (downed and "🚨 " or "") .. selectedPlayer.DisplayName .. " [" .. math.floor(distance) .. "m]"
                    espTextLabel.TextColor3 = downed and Color3.fromRGB(255, 40, 40) or Color3.fromRGB(80, 255, 140)
                    targetHighlight.FillColor = downed and Color3.fromRGB(255, 30, 30) or Color3.fromRGB(50, 200, 100)
                else
                    targetEspGui.Enabled = false targetHighlight.Enabled = false
                end
            else
                targetEspGui.Enabled = false targetHighlight.Enabled = false
            end
        else
            targetEspGui.Enabled = false targetHighlight.Enabled = false
        end

        -- All ESP
        if espAllEnabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    local tChar = plr.Character
                    local targetPart = getCharacterPart(tChar)
                    if myPart and targetPart and tChar then
                        local distance = (myPart.Position - targetPart.Position).Magnitude
                        if distance <= 5000 then
                            local gui = getOrCreateEspForPlayer(plr)
                            local hl = getOrCreateHighlightForPlayer(plr)
                            gui.Adornee = targetPart gui.Enabled = true
                            hl.Adornee = tChar hl.Enabled = true

                            local label = gui:FindFirstChild("ESPLabel")
                            local downed = isDowned(plr)
                            if label then
                                label.Text = (downed and "🚨 " or "") .. plr.DisplayName .. " [" .. math.floor(distance) .. "m]"
                                label.TextColor3 = downed and Color3.fromRGB(255, 40, 40) or Color3.fromRGB(80, 255, 140)
                            end
                            hl.FillColor = downed and Color3.fromRGB(255, 20, 20) or Color3.fromRGB(40, 180, 80)
                        else
                            if allEspGuis[plr] then allEspGuis[plr].Enabled = false end
                            if allHighlights[plr] then allHighlights[plr].Enabled = false end
                        end
                    else
                        if allEspGuis[plr] then allEspGuis[plr].Enabled = false end
                        if allHighlights[plr] then allHighlights[plr].Enabled = false end
                    end
                end
            end
        else
            for _, gui in pairs(allEspGuis) do gui.Enabled = false end
            for _, hl in pairs(allHighlights) do hl.Enabled = false end
        end
    end
end)

-- CONTROLS
espTargetBtn.MouseButton1Click:Connect(function()
    espTargetEnabled = not espTargetEnabled
    espTargetBtn.Text = espTargetEnabled and "ESP TARGET: ON" or "ESP TARGET: OFF"
    espTargetBtn.TextColor3 = espTargetEnabled and Color3.fromRGB(85, 235, 145) or Color3.fromRGB(235, 85, 85)
    espTargetBtn.BackgroundColor3 = espTargetEnabled and Color3.fromRGB(28, 52, 38) or Color3.fromRGB(35, 38, 48)
    if not espTargetEnabled then targetEspGui.Enabled = false targetHighlight.Enabled = false end
end)

espAllBtn.MouseButton1Click:Connect(function()
    espAllEnabled = not espAllEnabled
    espAllBtn.Text = espAllEnabled and "ESP ALL: ON" or "ESP ALL: OFF"
    espAllBtn.TextColor3 = espAllEnabled and Color3.fromRGB(85, 235, 145) or Color3.fromRGB(235, 85, 85)
    espAllBtn.BackgroundColor3 = espAllEnabled and Color3.fromRGB(28, 52, 38) or Color3.fromRGB(35, 38, 48)
    if not espAllEnabled then
        for _, gui in pairs(allEspGuis) do gui.Enabled = false end
        for _, hl in pairs(allHighlights) do hl.Enabled = false end
    end
end)

-- TELEPORT TARGET
local function toggleTeleport()
    if not selectedPlayer then
        tpBtn.Text = "CHỌN PLAYER TRƯỚC!"
        task.delay(1.2, function() tpBtn.Text = tpEnabled and "TELEPORT TARGET: ON" or "TELEPORT TARGET: OFF" end)
        return
    end

    tpEnabled = not tpEnabled
    tpBtn.Text = tpEnabled and "TELEPORT TARGET: ON" or "TELEPORT TARGET: OFF"
    tpBtn.TextColor3 = tpEnabled and Color3.fromRGB(85, 235, 145) or Color3.fromRGB(235, 85, 85)
    tpBtn.BackgroundColor3 = tpEnabled and Color3.fromRGB(28, 52, 38) or Color3.fromRGB(35, 38, 48)

    local myChar = LocalPlayer.Character
    local myPart = getCharacterPart(myChar)

    if tpEnabled then
        if myPart then originalCFrame = myPart.CFrame end
        if tpThread then task.cancel(tpThread) end
        tpThread = task.spawn(function()
            while tpEnabled do
                local targetPart = selectedPlayer and getCharacterPart(selectedPlayer.Character)
                local currentMyChar = LocalPlayer.Character
                if targetPart and currentMyChar then
                    currentMyChar:PivotTo(targetPart.CFrame * CFrame.new(0, 3, 4))
                end
                task.wait(0.15)
            end
        end)
    else
        if tpThread then task.cancel(tpThread) end
        if originalCFrame and myChar then myChar:PivotTo(originalCFrame) originalCFrame = nil end
    end
end

tpBtn.MouseButton1Click:Connect(toggleTeleport)

-- PLAYER PICKER LIST
function updateButtonAppearance(plr)
    local btn = playerButtons[plr]
    if not btn then return end
    local downed = isDowned(plr)
    btn.Text = plr.DisplayName .. " (@" .. plr.Name .. ")" .. (downed and " [GỤC]" or " [SỐNG]")
    btn.LayoutOrder = downed and 1 or 2

    if selectedPlayer == plr then
        btn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        btn.BackgroundColor3 = downed and Color3.fromRGB(80, 20, 20) or Color3.fromRGB(22, 25, 32)
        btn.TextColor3 = downed and Color3.fromRGB(255, 90, 90) or Color3.fromRGB(180, 185, 200)
    end
end

local function addPlayerButton(plr)
    if plr == LocalPlayer or playerButtons[plr] then return end

    local pBtn = Instance.new("TextButton")
    pBtn.Size = UDim2.new(1, 0, 0, 24)
    pBtn.Font = Enum.Font.GothamMedium
    pBtn.TextSize = 9
    pBtn.TextXAlignment = Enum.TextXAlignment.Left
    pBtn.Parent = scrollFrame
    Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 4)

    local pPadding = Instance.new("UIPadding")
    pPadding.PaddingLeft = UDim.new(0, 5)
    pPadding.Parent = pBtn

    playerButtons[plr] = pBtn
    updateButtonAppearance(plr)

    pBtn.MouseButton1Click:Connect(function()
        if selectedPlayer == plr then
            selectedPlayer = nil
            selectPlayerModalBtn.Text = "CHỌN PLAYER: [CHƯA CHỌN]"
            targetEspGui.Enabled = false
            targetHighlight.Enabled = false
            if spectateEnabled then updateCameraSubject() end
        else
            selectedPlayer = plr
            selectPlayerModalBtn.Text = "PLAYER: " .. plr.DisplayName
            playerPickerFrame.Visible = false
            if spectateEnabled then updateCameraSubject() end
        end
        for p, _ in pairs(playerButtons) do updateButtonAppearance(p) end
    end)
end

local function removePlayerButton(plr)
    if playerButtons[plr] then playerButtons[plr]:Destroy() playerButtons[plr] = nil end
    if selectedPlayer == plr then
        selectedPlayer = nil
        selectPlayerModalBtn.Text = "CHỌN PLAYER: [CHƯA CHỌN]"
        targetEspGui.Enabled = false
        targetHighlight.Enabled = false
        if spectateEnabled then updateCameraSubject() end
        if tpEnabled then toggleTeleport() end
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = string.lower(searchBox.Text)
    for plr, btn in pairs(playerButtons) do
        local nameMatch = string.find(string.lower(plr.Name), searchText, 1, true)
        local dispMatch = string.find(string.lower(plr.DisplayName), searchText, 1, true)
        btn.Visible = (searchText == "" or nameMatch or dispMatch) ~= nil
    end
end)

for _, plr in pairs(Players:GetPlayers()) do addPlayerButton(plr) end
Players.PlayerAdded:Connect(addPlayerButton)
Players.PlayerRemoving:Connect(removePlayerButton)

-- ---------------------------------------------------------
-- SMART VIP SERVER HOP ENGINE (QUÉT THÔNG MINH SVR KÍN)
-- ---------------------------------------------------------
local visitedServers = {}

local function smartVipServerHop()
    serverHopBtn.Text = "🔍 ĐANG TÌM SERVER KÍN (1-2 P)..."
    task.spawn(function()
        local placeId = game.PlaceId
        local cursor = ""
        local bestServerId = nil
        local bestPlayerCount = 999
        local bestPing = 9999

        -- Quét qua nhiều trang API để tìm ra server có cực ít người chơi & ping tối ưu nhất
        for page = 1, 8 do
            local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/0?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
            local success, result = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(url))
            end)

            if success and result and result.data then
                for _, server in ipairs(result.data) do
                    if server.id ~= game.JobId and not visitedServers[server.id] then
                        local playing = server.playing or 999
                        local ping = server.ping or 999

                        -- Tiêu chuẩn Server Kín: Từ 1 đến 3 người chơi
                        if playing > 0 and playing <= 3 then
                            if playing < bestPlayerCount or (playing == bestPlayerCount and ping < bestPing) then
                                bestPlayerCount = playing
                                bestPing = ping
                                bestServerId = server.id

                                -- Ưu tiên tuyệt đối: Nếu tìm thấy server chỉ có 1 người, chọn ngay!
                                if playing == 1 then break end
                            end
                        end
                    end
                end

                if bestServerId and bestPlayerCount == 1 then break end
                cursor = result.nextPageCursor or ""
                if not cursor or cursor == "" then break end
            else
                break
            end
            task.wait(0.1)
        end

        if bestServerId then
            visitedServers[bestServerId] = true
            serverHopBtn.Text = "🚀 CHUYỂN ĐẾN SVR KÍN (" .. tostring(bestPlayerCount) .. " PLAYER)..."
            task.wait(0.5)
            TeleportService:TeleportToPlaceInstance(placeId, bestServerId, LocalPlayer)
        else
            serverHopBtn.Text = "❌ KHÔNG THẤY SVR KÍN HỢP LỆ!"
            task.wait(1.5)
            serverHopBtn.Text = "👑 SMART VIP SERVER (SVR KÍN)"
        end
    end)
end

serverHopBtn.MouseButton1Click:Connect(smartVipServerHop)

tokenFarmBtn.MouseButton1Click:Connect(function()
    tokenFarmBtn.Text = "⏳ ĐANG TẢI SCRIPT..."
    task.spawn(function()
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/LuckyEvaletion/Script/refs/heads/main/Evade"))() end)
        tokenFarmBtn.Text = "⚡ AUTO FARM TOKEN INFINITE"
    end)
end)

reviveScriptBtn.MouseButton1Click:Connect(function()
    reviveScriptBtn.Text = "⏳ ĐANG TẢI SCRIPT..."
    task.spawn(function()
        pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Evade-Auto-Revive-All-Aura-XRAY-ESP-Fly-Speed-Float-No-Clip-n-More-246232"))() end)
        reviveScriptBtn.Text = "🩸 AUTO REVIVE (CẦN GET KEY)"
    end)
end)
