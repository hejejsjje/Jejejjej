local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local locked = false
local target = nil

-- ฟังก์ชั่นหาผู้เล่นที่ใกล้เมาส์ที่สุด
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if distance < shortestDistance then
                    closestPlayer = player.Character.HumanoidRootPart
                    shortestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

-- ปุ่มเปิด/ปิด
TextButton.MouseButton1Click:Connect(function()
    locked = not locked
    TextButton.Text = locked and "Lock: ON" or "Lock: OFF"
    TextButton.BackgroundColor3 = locked and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- อัปเดต Camera ทุกเฟรม
RunService.RenderStepped:Connect(function()
    if locked then
        target = getClosestPlayer()
        if target then
            -- ปรับมุมกล้องให้หันไปที่เป้าหมาย (Smoothing เล็กน้อย)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)
