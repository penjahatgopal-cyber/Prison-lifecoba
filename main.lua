
-- DONGKAK WAR | TEST GUI
-- Untuk game uji coba milik sendiri di Roblox Studio

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("DONGKAK_WAR")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "DONGKAK_WAR"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(300, 390)
frame.Position = UDim2.new(0.5, -150, 0.5, -195)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 40, 75)
stroke.Thickness = 2
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -45, 0, 42)
title.Position = UDim2.fromOffset(10, 4)
title.BackgroundTransparency = 1
title.Text = "🔥 DONGKAK WAR"
title.TextColor3 = Color3.fromRGB(255, 55, 85)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 30)
close.Position = UDim2.new(1, -38, 0, 8)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(180, 35, 55)
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.Parent = frame
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 7)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 32)
status.Position = UDim2.fromOffset(10, 47)
status.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
status.Text = "STATUS: SIAP, BRE!"
status.TextColor3 = Color3.fromRGB(100, 255, 150)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.Parent = frame
Instance.new("UICorner", status).CornerRadius = UDim.new(0, 6)

local function setStatus(message)
    status.Text = "STATUS: " .. message
end

local function getCharacter()
    local char = player.Character
    if not char then
        setStatus("KARAKTER BELUM ADA")
        return nil
    end

    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if not root or not hum or hum.Health <= 0 then
        setStatus("KARAKTER TIDAK SIAP")
        return nil
    end

    return char, root, hum
end

local function makeButton(text, y, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -24, 0, 36)
    button.Position = UDim2.fromOffset(12, y)
    button.BackgroundColor3 = Color3.fromRGB(42, 42, 56)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    button.AutoButtonColor = true
    button.Parent = frame

    Instance.new("UICorner", button).CornerRadius =
        UDim.new(0, 7)

    button.MouseButton1Click:Connect(function()
        local success, err = pcall(callback)
        if not success then
            setStatus("ERROR: " .. tostring(err))
        end
    end)

    return button
end

-- 1. TELEPORT KE MARKER BUATAN DI GAME SENDIRI
makeButton("📍 TELEPORT KE TEST POINT", 88, function()
    local char, root = getCharacter()
    if not root then return end

    local point = workspace:FindFirstChild(
        "TestTeleportPoint", true
    )

    if not point or not point:IsA("BasePart") then
        setStatus("BUAT PART TestTeleportPoint DULU")
        return
    end

    char:PivotTo(point.CFrame + Vector3.new(0, 3, 0))
    setStatus("TELEPORT BERHASIL!")
end)

-- 2. KEMBALI KE SPAWN
makeButton("🏠 KEMBALI KE SPAWN", 132, function()
    local char, root = getCharacter()
    if not root then return end

    local spawn = workspace:FindFirstChildWhichIsA(
        "SpawnLocation", true
    )

    if not spawn then
        setStatus("SPAWN BELUM DITEMUKAN")
        return
    end

    char:PivotTo(spawn.CFrame + Vector3.new(0, 4, 0))
    setStatus("KEMBALI KE SPAWN!")
end)

-- 3. KECEPATAN LARI UNTUK PENGUJIAN
local fast = false
makeButton("🏃 TOGGLE SPEED TEST", 176, function()
    local _, _, hum = getCharacter()
    if not hum then return end

    fast = not fast
    hum.WalkSpeed = fast and 28 or 16

    setStatus(fast and "SPEED TEST ON" or "SPEED NORMAL")
end)

-- 4. LOMPAT UNTUK PENGUJIAN
local highJump = false
makeButton("🦘 TOGGLE JUMP TEST", 220, function()
    local _, _, hum = getCharacter()
    if not hum then return end

    highJump = not highJump
    hum.UseJumpPower = true
    hum.JumpPower = highJump and 85 or 50

    setStatus(highJump and "JUMP TEST ON" or "JUMP NORMAL")
end)

-- 5. HEAL KARAKTER SENDIRI DI GAME TEST
makeButton("❤️ HEAL TEST CHARACTER", 264, function()
    local _, _, hum = getCharacter()
    if not hum then return end

    hum.Health = hum.MaxHealth
    setStatus("HEAL BERHASIL!")
end)

-- 6. RESET PENGATURAN GERAK
makeButton("🔄 RESET MOVEMENT", 308, function()
    local _, _, hum = getCharacter()
    if not hum then return end

    fast = false
    highJump = false
    hum.WalkSpeed = 16
    hum.UseJumpPower = true
    hum.JumpPower = 50

    setStatus("MOVEMENT DI-RESET")
end)

-- 7. MINIMIZE GUI
local minimized = false
local oldSize = frame.Size

makeButton("➖ MINIMIZE / SHOW", 352, function()
    minimized = not minimized

    for _, item in ipairs(frame:GetChildren()) do
        if item:IsA("TextButton") and item ~= close then
            item.Visible = not minimized
        end
    end

    status.Visible = not minimized
    frame.Size = minimized
        and UDim2.fromOffset(300, 48)
        or oldSize

    setStatus("GUI SIAP")
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

player.CharacterAdded:Connect(function()
    fast = false
    highJump = false
    setStatus("KARAKTER RESPAWN")
end)

print("DONGKAK WAR TEST GUI loaded!")
