-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local infiniteJumpEnabled = false

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfiniteJumpGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Small circular button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.5, -25, 0.5, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
ToggleButton.Text = "OFF"
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextScaled = true
ToggleButton.AutoButtonColor = true
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.BorderSizePixel = 0
ToggleButton.TextWrapped = true
ToggleButton.Active = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.5,0)
UICorner.Parent = ToggleButton

-- Dragging (mobile)
local dragging = false
local dragStartPos
local touchStartPos

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        touchStartPos = input.Position
        dragStartPos = ToggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - touchStartPos
        ToggleButton.Position = UDim2.new(
            dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
            dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
        )
    end
end)

-- Update button UI
local function UpdateButtonUI()
    if infiniteJumpEnabled then
        ToggleButton.Text = "ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- hijau
    else
        ToggleButton.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- hitam
    end
end

-- Toggle Infinite Jump
ToggleButton.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    UpdateButtonUI()
end)

-- Infinite Jump logic (natural, auto-detect JumpPower)
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if humanoid and hrp then
            local jumpPower = humanoid.UseJumpPower and humanoid.JumpPower or 50
            hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpPower, hrp.Velocity.Z)
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Set UI awal
UpdateButtonUI()
