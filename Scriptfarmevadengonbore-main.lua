-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

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
mainFrame.Size = UDim2.new(0, 230, 0, 300)
mainFrame.Position = UDim2.new(0.5, -115, 0.25, 0)
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
titleLabel.Text = "EVADE HUB v5.4"
titleLabel.TextColor3 = Color3.fromRGB(220, 225, 235)
titleLabel.TextSize = 12
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
-- TẠO NÚT BẤM
-- ---------------------------------------------------------
local function createButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 28)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(235, 85, 85)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = mainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local function createHalfButton(text, posX, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.435, 0, 0, 28)
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

local autoFarmBtn = createButton("AUTO FARM (Y=1500): OFF", 35)
local selectPlayerModalBtn = createButton("CHỌN PLAYER: [CHƯA CHỌN]", 68)
selectPlayerModalBtn.TextColor3 = Color3.fromRGB(180, 200, 240)

local camBtn = createButton("CAM FOLLOW: OFF (V)", 101)

local espTargetBtn = createHalfButton("ESP TARGET: OFF", 0.05, 134)
local espAllBtn = createHalfButton("ESP ALL: OFF", 0.515, 134)

local tpBtn = createButton("TELEPORT TARGET: OFF", 167)

local vflyBtn = Instance.new("TextButton")
vflyBtn.Size = UDim2.new(0.62, 0, 0, 28)
vflyBtn.Position = UDim2.new(0.05, 0, 0, 200)
vflyBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
vflyBtn.Text = "VFLY: OFF"
vflyBtn.TextColor3 = Color3.fromRGB(235, 85, 85)
vflyBtn.TextSize = 10
vflyBtn.Font = Enum.Font.GothamBold
vflyBtn.AutoButtonColor = false
vflyBtn.Parent = mainFrame
Instance.new("UICorner", vflyBtn).CornerRadius = UDim.new(0, 6)

local flySpeedBox = Instance.new("TextBox")
flySpeedBox.Size = UDim2.new(0.26, 0, 0, 28)
flySpeedBox.Position = UDim2.new(0.69, 0, 0, 200)
flySpeedBox.BackgroundColor3 = Color3.fromRGB(12, 13, 16)
flySpeedBox.Text = "50"
flySpeedBox.PlaceholderText = "Speed"
flySpeedBox.TextColor3 = Color3.fromRGB(85, 235, 145)
flySpeedBox.TextSize = 10
flySpeedBox.Font = Enum.Font.GothamBold
flySpeedBox.Parent = mainFrame
Instance.new("UICorner", flySpeedBox).CornerRadius = UDim.new(0, 6)

local flySpeedStroke = Instance.new("UIStroke")
flySpeedStroke.Color = Color3.fromRGB(60, 65, 80)
flySpeedStroke.Thickness = 1
flySpeedStroke.Parent = flySpeedBox

local noclipBtn = createButton("NOCLIP: OFF", 233)

-- ---------------------------------------------------------
-- KHUNG CHỌN PLAYER
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
-- ESP BILLBOARD & HIGHLIGHT SYSTEM
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
    if allEspGuis[plr] then
        allEspGuis[plr]:Destroy()
        allEspGuis[plr] = nil
    end
    if allHighlights[plr] then
        allHighlights[plr]:Destroy()
        allHighlights[plr] = nil
    end
end

Players.PlayerRemoving:Connect(removeEspForPlayer)

-- ---------------------------------------------------------
-- BIẾN & LOGIC HỆ THỐNG
-- ---------------------------------------------------------
local autoFarmEnabled = false
local safePlatform = nil
local camEnabled = false
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
    return char.PrimaryPart 
        or char:FindFirstChild("HumanoidRootPart") 
        or char:FindFirstChild("Head") 
        or char:FindFirstChildWhichIsA("BasePart")
end

-- HÀM NHẬN DIỆN GỤC CHUẨN XÁC DÀNH RIÊNG CHO EVADE
local function isDowned(plr)
    if not plr or not plr.Character then return false end
    local char = plr.Character
    
    -- 1. Quét ProximityPrompt (Đặc trưng của Evade: Nhân vật sống KHÔNG BAO GIỜ có Prompt)
    for _, desc in ipairs(char:GetDescendants()) do
        if desc:IsA("ProximityPrompt") and desc.Enabled then
            return true
        end
    end

    -- 2. Quét Attributes trên Character & Player
    if char:GetAttribute("Downed") == true 
        or plr:GetAttribute("Downed") == true 
        or char:GetAttribute("Incapacitated") == true 
        or plr:GetAttribute("Incapacitated") == true
        or char:GetAttribute("Down") == true then
        return true
    end

    -- 3. Quét Object/Tag ẩn
    if char:FindFirstChild("Downed") or char:FindFirstChild("Incapacitated") or char:FindFirstChild("Revive") then
        return true
    end

    -- 4. Quét Folder lưu dữ liệu trận đấu Evade trong Workspace
    local gameFolder = workspace:FindFirstChild("Game") or workspace:FindFirstChild("Map")
    if gameFolder then
        local playersFolder = gameFolder:FindFirstChild("Players")
        if playersFolder then
            local pData = playersFolder:FindFirstChild(plr.Name)
            if pData and (pData:GetAttribute("Downed") == true or pData:FindFirstChild("Downed")) then
                return true
            end
        end
    end

    -- 5. Trạng thái vật lý Humanoid (Nằm/Ragdoll/Sấp mặt)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if hum.PlatformStand or hum:GetState() == Enum.HumanoidStateType.Physics then
            return true
        end
    end

    return false
end

-- NOCLIP
local function setNoclip(enabled)
    noclipEnabled = enabled
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end

    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
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
    if vflyLoop then
        vflyLoop:Disconnect()
        vflyLoop = nil
    end
    if bodyVel then bodyVel:Destroy() bodyVel = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
end

local function startVFly()
    stopVFly()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    bodyVel = Instance.new("BodyVelocity")
    bodyVel.Name = "EvadeVFlyVelocity"
    bodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bodyVel.Velocity = Vector3.zero
    bodyVel.Parent = root

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = "EvadeVFlyGyro"
    bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bodyGyro.P = 9000
    bodyGyro.CFrame = root.CFrame
    bodyGyro.Parent = root

    vflyLoop = RunService.RenderStepped:Connect(function()
        if not vflyEnabled or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            stopVFly()
            return
        end

        local moveVector = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then 
            moveVector = moveVector - Vector3.new(0, 1, 0) 
        end

        if bodyVel then bodyVel.Velocity = moveVector * flySpeed end
        if bodyGyro then bodyGyro.CFrame = Camera.CFrame end
    end)
end

vflyBtn.MouseButton1Click:Connect(function()
    vflyEnabled = not vflyEnabled
    vflyBtn.Text = vflyEnabled and "VFLY: ON" or "VFLY: OFF"
    vflyBtn.TextColor3 = vflyEnabled and Color3.fromRGB(85, 235, 145) or Color3.fromRGB(235, 85, 85)
    vflyBtn.BackgroundColor3 = vflyEnabled and Color3.fromRGB(28, 52, 38) or Color3.fromRGB(35, 38, 48)

    if vflyEnabled then
        startVFly()
    else
        stopVFly()
    end
end)

flySpeedBox.FocusLost:Connect(function()
    local val = tonumber(flySpeedBox.Text)
    if val then
        flySpeed = val
    else
        flySpeedBox.Text = tostring(flySpeed)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if noclipEnabled then setNoclip(true) end
    if vflyEnabled then startVFly() end
end)

-- AUTO FARM
local function getSafePlatform()
    if not safePlatform or not safePlatform.Parent then
        safePlatform = Instance.new("Part")
        safePlatform.Name = "EvadeSafePlatform1500"
        safePlatform.Size = Vector3.new(50, 2, 50)
        safePlatform.Position = Vector3.new(0, 1500, 0)
        safePlatform.Anchored = true
        safePlatform.Transparency = 0.5
        safePlatform.Material = Enum.Material.ForceField
        safePlatform.Parent = Workspace
    end
    return safePlatform
end

autoFarmBtn.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    autoFarmBtn.Text = autoFarmEnabled and "AUTO FARM (Y=1500): ON" or "AUTO FARM (Y=1500): OFF"
    autoFarmBtn.TextColor3 = autoFarmEnabled and Color3.fromRGB(85, 235, 145) or Color3.fromRGB(235, 85, 85)
    autoFarmBtn.BackgroundColor3 = autoFarmEnabled and Color3.fromRGB(28, 52, 38) or Color3.fromRGB(35, 38, 48)

    if autoFarmEnabled and not tpEnabled then
        local plat = getSafePlatform()
        pcall(function()
            if LocalPlayer.Character then
                LocalPlayer.Character:PivotTo(plat.CFrame + Vector3.new(0, 4, 0))
            end
        end)
    end
end)

task.spawn(function()
    while true do
        if autoFarmEnabled and not tpEnabled then
            pcall(function()
                local plat = getSafePlatform()
                local myPart = getCharacterPart(LocalPlayer.Character)
                if myPart then
                    local platPos = plat.Position
                    local distXZ = Vector2.new(myPart.Position.X - platPos.X, myPart.Position.Z - platPos.Z).Magnitude
                    local isBelow = myPart.Position.Y < (platPos.Y - 2)
                    
                    if distXZ > 25 or isBelow then
                        task.wait(0.7)
                        if autoFarmEnabled and not tpEnabled and LocalPlayer.Character then
                            LocalPlayer.Character:PivotTo(plat.CFrame + Vector3.new(0, 4, 0))
                        end
                    end
                end
            end)
        end
        task.wait(0.3)
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

-- CAM FOLLOW
local camLerpSpeed = 12

local function toggleCam()
    camEnabled = not camEnabled
    camBtn.Text = camEnabled and "CAM FOLLOW: ON (V)" or "CAM FOLLOW: OFF (V)"
    camBtn.TextColor3 = camEnabled and Color3.fromRGB(85, 235, 145) or Color3.fromRGB(235, 85, 85)
    camBtn.BackgroundColor3 = camEnabled and Color3.fromRGB(28, 52, 38) or Color3.fromRGB(35, 38, 48)
end

camBtn.MouseButton1Click:Connect(toggleCam)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.V then
        toggleCam()
    end
end)

RunService:BindToRenderStep("EvadeCamFollow", Enum.RenderPriority.Camera.Value + 1, function(dt)
    if not camEnabled then return end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if hum and hum.MoveDirection.Magnitude > 0.1 then
        local camCF = Camera.CFrame
        local pitch, currentYaw, roll = camCF:ToOrientation()
        
        local moveDir = hum.MoveDirection
        local targetYaw = math.atan2(-moveDir.X, -moveDir.Z)
        
        local angleDiff = (targetYaw - currentYaw + math.pi) % (math.pi * 2) - math.pi
        local smoothedYaw = currentYaw + angleDiff * math.clamp(dt * camLerpSpeed, 0, 1)
        
        Camera.CFrame = CFrame.new(camCF.Position) 
            * CFrame.Angles(0, smoothedYaw, 0) 
            * CFrame.Angles(pitch, 0, 0)
    end
end)

-- TARGET ESP
espTargetBtn.MouseButton1Click:Connect(function()
    espTargetEnabled = not espTargetEnabled
    espTargetBtn.Text = espTargetEnabled and "ESP TARGET: ON" or "ESP TARGET: OFF"
    espTargetBtn.TextColor3 = espTargetEnabled and Color3.fromRGB(85, 235, 145) or Color3.fromRGB(235, 85, 85)
    espTargetBtn.BackgroundColor3 = espTargetEnabled and Color3.fromRGB(28, 52, 38) or Color3.fromRGB(35, 38, 48)
    
    if not espTargetEnabled then
        targetEspGui.Enabled = false
        targetEspGui.Adornee = nil
        targetHighlight.Enabled = false
        targetHighlight.Adornee = nil
    end
end)

-- ALL PLAYER ESP
espAllBtn.MouseButton1Click:Connect(function()
    espAllEnabled = not espAllEnabled
    espAllBtn.Text = espAllEnabled and "ESP ALL: ON" or "ESP ALL: OFF"
    espAllBtn.TextColor3 = espAllEnabled and Color3.fromRGB(85, 235, 145) or Color3.fromRGB(235, 85, 85)
    espAllBtn.BackgroundColor3 = espAllEnabled and Color3.fromRGB(28, 52, 38) or Color3.fromRGB(35, 38, 48)
    
    if not espAllEnabled then
        for _, gui in pairs(allEspGuis) do
            gui.Enabled = false
            gui.Adornee = nil
        end
        for _, hl in pairs(allHighlights) do
            hl.Enabled = false
            hl.Adornee = nil
        end
    end
end)

-- TELEPORT TARGET
local function toggleTeleport()
    if not selectedPlayer then
        tpBtn.Text = "CHỌN PLAYER TRƯỚC!"
        task.delay(1.2, function()
            tpBtn.Text = tpEnabled and "TELEPORT TARGET: ON" or "TELEPORT TARGET: OFF"
        end)
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
                    for _, p in ipairs(currentMyChar:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.CanCollide = false
                        end
                    end
                    local safeCFrame = targetPart.CFrame * CFrame.new(0, 3, 4)
                    currentMyChar:PivotTo(safeCFrame)
                end
                task.wait(0.1)
            end
        end)
    else
        if tpThread then task.cancel(tpThread) end
        if originalCFrame and myChar then
            myChar:PivotTo(originalCFrame)
            originalCFrame = nil
        end
    end
end

tpBtn.MouseButton1Click:Connect(toggleTeleport)

-- ---------------------------------------------------------
-- SAN LỌC DANH SÁCH PLAYER
-- ---------------------------------------------------------
local function updateButtonAppearance(plr)
    local btn = playerButtons[plr]
    if not btn then return end
    
    local downed = isDowned(plr)
    btn.Text = plr.DisplayName .. " (@" .. plr.Name .. ")" .. (downed and " [GỤC - CẦN CỨU]" or " [SỐNG]")
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
            targetEspGui.Adornee = nil
            targetHighlight.Enabled = false
            targetHighlight.Adornee = nil
        else
            selectedPlayer = plr
            selectPlayerModalBtn.Text = "PLAYER: " .. plr.DisplayName
            playerPickerFrame.Visible = false
        end

        for p, _ in pairs(playerButtons) do
            updateButtonAppearance(p)
        end
    end)
end

local function removePlayerButton(plr)
    if playerButtons[plr] then
        playerButtons[plr]:Destroy()
        playerButtons[plr] = nil
    end
    if selectedPlayer == plr then
        selectedPlayer = nil
        selectPlayerModalBtn.Text = "CHỌN PLAYER: [CHƯA CHỌN]"
        targetEspGui.Enabled = false
        targetEspGui.Adornee = nil
        targetHighlight.Enabled = false
        targetHighlight.Adornee = nil
        if tpEnabled then toggleTeleport() end
    end
end

local function filterPlayers()
    local searchText = string.lower(searchBox.Text)
    for plr, btn in pairs(playerButtons) do
        local nameMatch = string.find(string.lower(plr.Name), searchText, 1, true)
        local dispMatch = string.find(string.lower(plr.DisplayName), searchText, 1, true)
        btn.Visible = (searchText == "" or nameMatch or dispMatch) ~= nil
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(filterPlayers)

for _, plr in pairs(Players:GetPlayers()) do
    addPlayerButton(plr)
end

Players.PlayerAdded:Connect(addPlayerButton)
Players.PlayerRemoving:Connect(removePlayerButton)

task.spawn(function()
    while task.wait(0.5) do
        for plr, _ in pairs(playerButtons) do
            updateButtonAppearance(plr)
        end
    end
end)

-- ---------------------------------------------------------
-- ESP MAIN LOOP (HỆ THỐNG HIGHLIGHT XUYÊN TƯỜNG DỄ NHÌN)
-- ---------------------------------------------------------
RunService.RenderStepped:Connect(function()
    local myPart = getCharacterPart(LocalPlayer.Character)

    -- 1. Target ESP
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

                local distInt = math.floor(distance)
                local downed = isDowned(selectedPlayer)

                if downed then
                    espTextLabel.Text = "🚨 " .. selectedPlayer.DisplayName .. " [GỤC] [" .. distInt .. "m]"
                    espTextLabel.TextColor3 = Color3.fromRGB(255, 40, 40)
                    targetHighlight.FillColor = Color3.fromRGB(255, 30, 30)
                    targetHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                else
                    espTextLabel.Text = selectedPlayer.DisplayName .. " [" .. distInt .. "m]"
                    espTextLabel.TextColor3 = Color3.fromRGB(80, 255, 140)
                    targetHighlight.FillColor = Color3.fromRGB(50, 200, 100)
                    targetHighlight.OutlineColor = Color3.fromRGB(0, 255, 100)
                end
            else
                targetEspGui.Enabled = false
                targetHighlight.Enabled = false
            end
        else
            targetEspGui.Enabled = false
            targetHighlight.Enabled = false
        end
    else
        targetEspGui.Enabled = false
        targetHighlight.Enabled = false
    end

    -- 2. ESP All Players
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

                        gui.Adornee = targetPart
                        gui.Enabled = true

                        hl.Adornee = tChar
                        hl.Enabled = true

                        local label = gui:FindFirstChild("ESPLabel")
                        local downed = isDowned(plr)

                        if downed then
                            if label then
                                label.Text = "🚨 " .. plr.DisplayName .. " [GỤC] [" .. math.floor(distance) .. "m]"
                                label.TextColor3 = Color3.fromRGB(255, 40, 40)
                            end
                            -- Hào quang màu ĐỎ RỰC phát sáng xuyên tường khi gục
                            hl.FillColor = Color3.fromRGB(255, 20, 20)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        else
                            if label then
                                label.Text = plr.DisplayName .. " [" .. math.floor(distance) .. "m]"
                                label.TextColor3 = Color3.fromRGB(80, 255, 140)
                            end
                            -- Hào quang màu XANH LÁ nhạt khi bình thường
                            hl.FillColor = Color3.fromRGB(40, 180, 80)
                            hl.OutlineColor = Color3.fromRGB(0, 255, 120)
                        end
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
end)
