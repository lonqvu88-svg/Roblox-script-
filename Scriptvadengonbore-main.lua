local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local PlaceId = game.PlaceId
local CurrentJobId = game.JobId
local Blacklist = {}

-- Giao diện GUI Pro
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ProServerHopper"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 160)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(45, 45, 55)

-- Logic Kéo Thả GUI
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Các thành phần chữ & nút
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -20, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "PRO HOPPER (< 2 PLAYERS)"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, -20, 0, 25)
Status.Position = UDim2.new(0, 10, 0, 35)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.Text = "Trạng thái: Sẵn sàng"
Status.TextColor3 = Color3.fromRGB(150, 150, 160)
Status.TextSize = 11
Status.TextXAlignment = Enum.TextXAlignment.Left

local HopBtn = Instance.new("TextButton", MainFrame)
HopBtn.Size = UDim2.new(1, -20, 0, 42)
HopBtn.Position = UDim2.new(0, 10, 0, 68)
HopBtn.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
HopBtn.Font = Enum.Font.GothamBold
HopBtn.Text = "TÌM SERVER ≤ 1 NGƯỜI"
HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopBtn.TextSize = 12
Instance.new("UICorner", HopBtn).CornerRadius = UDim.new(0, 8)

local Info = Instance.new("TextLabel", MainFrame)
Info.Size = UDim2.new(1, -20, 0, 30)
Info.Position = UDim2.new(0, 10, 0, 120)
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.Gotham
Info.Text = "Nhấn [K] để ẩn/hiện bảng điều khiển"
Info.TextColor3 = Color3.fromRGB(90, 90, 100)
Info.TextSize = 10

-- Bật/Tắt UI bằng phím K
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Thuật toán tìm Server sâu
local isHopping = false
local function FindServerUnder2()
    if isHopping then return end
    isHopping = true
    HopBtn.Text = "ĐANG ĐỌC DỮ LIỆU..."
    
    local cursor = ""
    local foundServer = nil

    task.spawn(function()
        while isHopping and not foundServer do
            local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/0?sortOrder=Asc&limit=100"
            if cursor ~= "" then
                url = url .. "&cursor=" .. cursor
            end

            local success, result = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(url))
            end)

            if success and result and result.data then
                for _, server in ipairs(result.data) do
                    -- Điều kiện: Số người < 2 (0 hoặc 1) và không nằm trong danh sách đen
                    if server.id ~= CurrentJobId and not Blacklist[server.id] and server.playing < 2 then
                        foundServer = server
                        break
                    end
                end

                if not foundServer then
                    if result.nextPageCursor then
                        cursor = result.nextPageCursor
                        Status.Text = "Trạng thái: Đang quét trang tiếp theo..."
                        task.wait(0.2)
                    else
                        Status.Text = "Kết quả: Không có server nào < 2 người!"
                        break
                    end
                end
            else
                Status.Text = "Lỗi: Không thể tải danh sách server!"
                break
            end
        end

        if foundServer then
            Status.Text = "Đang vào server: " .. foundServer.playing .. " người chơi"
            Blacklist[foundServer.id] = true
            TeleportService:TeleportToPlaceInstance(PlaceId, foundServer.id, LocalPlayer)
        else
            isHopping = false
            HopBtn.Text = "TÌM SERVER ≤ 1 NGƯỜI"
        end
    end)
end

-- Tự xử lý khi Teleport thất bại
TeleportService.TeleportInitFailed:Connect(function(player)
    if player == LocalPlayer then
        Status.Text = "Lỗi kết nối! Đang tìm lại..."
        isHopping = false
        task.wait(1)
        FindServerUnder2()
    end
end)

HopBtn.MouseButton1Click:Connect(FindServerUnder2)
