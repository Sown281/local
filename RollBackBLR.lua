local plr = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Biến toggle để bật/tắt freeze data
local isFreezing = false

-- Chờ game tải xong
repeat wait()
until game:IsLoaded() and game:FindFirstChild("CoreGui") and pcall(function() return game.CoreGui end)

-- Hàm gửi yêu cầu freeze data
local function freezeData()
    print("Freezing data")
    ReplicatedStorage.Packages.Knit.Services.CustomizationService.RE.Customize:FireServer(unpack({
        [1] = "Emotes",
        [2] = "Default\255", -- Gửi chuỗi bất thường để "freeze"
        [3] = "1"
    }))
end

-- Hàm dừng freeze và lưu dữ liệu bình thường
local function unfreezeData()
    print("Unfreezing data")
    ReplicatedStorage.Packages.Knit.Services.CustomizationService.RE.Customize:FireServer(unpack({
        [1] = "Emotes",
        [2] = "Default", -- Gửi yêu cầu bình thường để "unfreeze"
        [3] = "1"
    }))
end

-- Vòng lặp để giữ freeze data khi toggle bật
spawn(function()
    while true do
        if isFreezing then
            freezeData()
            wait(1) -- Gửi yêu cầu mỗi giây để duy trì trạng thái freeze
        else
            wait(0.1) -- Giảm tải CPU khi không freeze
        end
    end
end)

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FreezeDataUI"
ScreenGui.Parent = game.CoreGui

-- Frame chính (nền)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Màu xám đậm
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Bo góc cho Frame
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Freeze Data"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Frame bóng đổ (Shadow)
local ShadowFrame = Instance.new("Frame")
ShadowFrame.Size = UDim2.new(0, 180, 0, 50) -- Lớn hơn nút một chút
ShadowFrame.Position = UDim2.new(0.5, -90, 0.45, 0) -- Dịch chuyển để hiển thị bóng
ShadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Màu đen cho bóng
ShadowFrame.BorderSizePixel = 0
ShadowFrame.Transparency = 0.7 -- Độ mờ để tạo hiệu ứng bóng
ShadowFrame.ZIndex = 0 -- Đặt dưới nút
ShadowFrame.Parent = MainFrame

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 10) -- Bo góc tương tự Frame
ShadowCorner.Parent = ShadowFrame

-- Nút Toggle
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 160, 0, 40)
ToggleButton.Position = UDim2.new(0.5, -80, 0.4, 0) -- Gần giữa
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- Màu đỏ khi tắt
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.TextSize = 16
ToggleButton.ZIndex = 1 -- Đặt trên bóng
ToggleButton.Parent = MainFrame

-- Bo góc cho nút
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = ToggleButton

-- Thêm viền nhẹ cho nút
local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Thickness = 1
ButtonStroke.Color = Color3.fromRGB(100, 100, 100)
ButtonStroke.Transparency = 0.5 -- Viền mờ để nổi bật
ButtonStroke.Parent = ToggleButton

-- Hàm tạo animation
local function playToggleAnimation(isOn)
    local targetColor = isOn and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    local tweenInfo = TweenInfo.new(
        0.4,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut
    )

    -- Animation đổi màu
    local colorTween = TweenService:Create(ToggleButton, tweenInfo, {BackgroundColor3 = targetColor})
    colorTween:Play()

    -- Animation "nhảy" nhẹ và mượt
    local scaleUp = TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 165, 0, 44),
        Position = UDim2.new(0.5, -82.5, 0.4, -7)
    })
    local scaleDown = TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 160, 0, 40),
        Position = UDim2.new(0.5, -80, 0.4, -5)
    })

    scaleUp:Play()
    scaleUp.Completed:Connect(function()
        scaleDown:Play()
    end)

    -- Animation bóng đổ (phóng to và thu nhỏ nhẹ)
    local shadowScaleUp = TweenService:Create(ShadowFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 190, 0, 60),
        Position = UDim2.new(0.5, -95, 0.45, 2)
    })
    local shadowScaleDown = TweenService:Create(ShadowFrame, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 180, 0, 50),
        Position = UDim2.new(0.5, -90, 0.45, 0)
    })

    shadowScaleUp:Play()
    shadowScaleUp.Completed:Connect(function()
        shadowScaleDown:Play()
    end)
end

-- Logic khi nhấn nút toggle
ToggleButton.MouseButton1Click:Connect(function()
    isFreezing = not isFreezing
    if isFreezing then
        ToggleButton.Text = "ON"
        playToggleAnimation(true)
        print("Freeze data activated")
    else
        ToggleButton.Text = "OFF"
        playToggleAnimation(false)
        unfreezeData()
        print("Freeze data deactivated")
    end
end)

-- Logic kéo thả (draggable)
local dragging
local dragInput
local dragStart
local startPos

MainFrame.InputBegan:Connect(function(input)
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

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

print("Freeze data toggle script with modern UI, shadow, and enhanced animation loaded")
