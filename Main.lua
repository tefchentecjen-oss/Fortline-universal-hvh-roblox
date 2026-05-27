print(string.rep("=", 50))
print("🔮 ЗАПУСК ULTIMATE MONOLITH v11.0 [NEVERLOSE + HARD VISUALS] 🔮")
print("-> Добавлены: 3D Boxes, Jump ESP, Snaplines, Names. Бинд: Клавиша HOME!")
print(string.rep("=", 50))

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")
local hpCache = {}
local espCache = {}
local lastClick = 0

-- =================================================================
-- ⚙️ ПОЛНАЯ ТАБЛИЦА НАСТРОЕК (ПРИВЯЗАНА К КНОПКАМ МЕНЮ)
-- =================================================================
getgenv().MadiumConfig = {
    AimbotEnabled = true,
    AutoFireEnabled = true,
    TracersEnabled = true,
    GhostChamsEnabled = true,
    HitLogsEnabled = true,
    HitSoundEnabled = true,
    
    -- НОВЫЕ ТУГГЛЫ ДЛЯ ДОФИГА ВИЗУАЛОВ
    ThreeDBoxes = true,
    JumpESP = true,
    Snaplines = true,
    NamesESP = true,
    
    GhostTransparency = 0.6,
    LaserColor = Color3.fromRGB(180, 0, 255),
    CLICK_DELAY = 0.02
}

getgenv().MadiumNewModeData = {
    TargetHumanoid = nil,
    TargetHeadPosition = nil,
    TargetPart = nil,
    TargetName = "",
    TargetCharacter = nil
}

local hitSoundObject = Instance.new("Sound")
hitSoundObject.SoundId = "rbxassetid://135698842254153"
hitSoundObject.Volume = 1.6
hitSoundObject.Parent = SoundService

local FUNNY_MESSAGES = {
    "походу сегодня не его день...",
    "отправился в канаву!",
    "минус кабина, отдыхай",
    "удаляй игру, бро, без шансов",
    "серверная валидация не спасла!"
}

local GHOST_DURATION, COLOR_SHIFT_SPEED, FLOAT_SPEED, FADE_DURATION = 1.3, 4, 1.8, 0.4

-- =================================================================
-- 🎨 СОЗДАНИЕ PREMIUM ИНТЕРФЕЙСА (NEVERLOSE COMPACT DESIGN)
-- =================================================================
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "NeverloseMadiumUI_v11"
if syn and syn.protect_gui then syn.protect_gui(MainGui) end
MainGui.Parent = CoreGui

local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 460, 0, 360) -- Увеличили размер под новые визуалы
MenuFrame.Position = UDim2.new(0.5, -230, 0.5, -180)
MenuFrame.BackgroundColor3 = Color3.fromRGB(8, 11, 15)
MenuFrame.BackgroundTransparency = 0.05
MenuFrame.Active = true
MenuFrame.Draggable = true 
MenuFrame.Parent = MainGui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 6)
MenuCorner.Parent = MenuFrame

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(5, 7, 10)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MenuFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 6)
SidebarCorner.Parent = Sidebar

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 45)
Logo.BackgroundTransparency = 1
Logo.Text = "NEVERLOSE"
Logo.TextColor3 = Color3.fromRGB(0, 160, 255)
Logo.Font = Enum.Font.SourceSansBold
Logo.TextSize = 16
Logo.Parent = Sidebar

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -135, 1, -20)
Container.Position = UDim2.new(0, 128, 0, 10)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 160, 255)
Container.CanvasSize = UDim2.new(0, 0, 0, 520) -- Увеличили прокрутку под функции
Container.Parent = MenuFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Container

local function addNeverloseToggle(configKey, displayName)
    local toggleRow = Instance.new("Frame")
    toggleRow.Size = UDim2.new(1, -5, 0, 32)
    toggleRow.BackgroundColor3 = Color3.fromRGB(12, 16, 22)
    toggleRow.BorderSizePixel = 0
    toggleRow.Parent = Container
    
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 4)
    rowCorner.Parent = toggleRow
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -60, 1, 0)
    textLabel.Position = UDim2.new(0, 10, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = displayName
    textLabel.TextColor3 = Color3.fromRGB(200, 210, 220)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 13
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = toggleRow
    
    local boxBtn = Instance.new("TextButton")
    boxBtn.Size = UDim2.new(0, 36, 0, 18)
    boxBtn.Position = UDim2.new(1, -46, 0.5, -9)
    boxBtn.BackgroundColor3 = getgenv().MadiumConfig[configKey] and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(25, 30, 40)
    boxBtn.Text = ""
    boxBtn.Parent = toggleRow
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(1, 0)
    boxCorner.Parent = boxBtn
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = getgenv().MadiumConfig[configKey] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Parent = boxBtn
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle
    
    boxBtn.MouseButton1Click:Connect(function()
        getgenv().MadiumConfig[configKey] = not getgenv().MadiumConfig[configKey]
        local targetColor = getgenv().MadiumConfig[configKey] and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(25, 30, 40)
        local targetPos = getgenv().MadiumConfig[configKey] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        TweenService:Create(boxBtn, TweenInfo.new(0.12), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(circle, TweenInfo.new(0.12), {Position = targetPos}):Play()
    end)
end

-- Добавляем все старые и новые переключатели в меню
addNeverloseToggle("AimbotEnabled", "💣 Rage Silent Aim")
addNeverloseToggle("AutoFireEnabled", "🔫 Automatic Triggerbot")
addNeverloseToggle("TracersEnabled", "⚡ Purple Laser Tracers")
addNeverloseToggle("GhostChamsEnabled", "👻 Rainbow Ghost Chams")
addNeverloseToggle("HitLogsEnabled", "💥 Center Screen Hit-Logs")
addNeverloseToggle("HitSoundEnabled", "🔔 Premium Bell Hitmarker")
addNeverloseToggle("ThreeDBoxes", "📦 3D Box ESP")
addNeverloseToggle("JumpESP", "🦘 Jump State ESP")
addNeverloseToggle("Snaplines", "👁️ Snaplines Tracer")
addNeverloseToggle("NamesESP", "📝 Name & Distance ESP")

-- 🔥 БИНД НА КЛАВИШУ HOME ДЛЯ СКРЫТИЯ/ОТКРЫТИЯ МЕНЮ
local menuVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Home then
        menuVisible = not menuVisible
        MenuFrame.Visible = menuVisible
    end
end)

-- =================================================================
-- 🛠️ ФУНКЦИИ ГЕНЕРАЦИИ ОБЪЕКТОВ DRAWING API ДЛЯ ESP (БЕЗ БАГОВ)
-- =================================================================
local function createDrawingObjects()
    local tracer = Drawing.new("Line")
    tracer.Thickness = 1.0
    tracer.Color = Color3.fromRGB(0, 160, 255)
    tracer.Visible = false
    
    local text = Drawing.new("Text")
    text.Size = 13
    text.Center = true
    text.Outline = true
    text.Color = Color3.fromRGB(255, 255, 255)
    text.Visible = false
    
    local stateText = Drawing.new("Text")
    stateText.Size = 11
    stateText.Center = true
    stateText.Outline = true
    stateText.Color = Color3.fromRGB(255, 60, 60)
    stateText.Visible = false
    
    return {Tracer = tracer, Text = text, StateText = stateText}
end

-- Функция создания легитного и стабильного 3D Бокса без просадки FPS
local function create3DBox(character)
    local box = character:FindFirstChild("Madium3DBox")
    if not box then
        box = Instance.new("BoxHandleAdornment")
        box.Name = "Madium3DBox"
        box.Color3 = Color3.fromRGB(0, 160, 255)
        box.Transparency = 0.65
        box.AlwaysOnTop = true
        box.ZIndex = 4
        box.Parent = character
    end
    if character:FindFirstChild("HumanoidRootPart") then
        box.Adornee = character.HumanoidRootPart
        box.Size = character:GetExtentsSize() + Vector3.new(0.3, 0.3, 0.3)
    end
    return box
end

-- =================================================================
-- ВСПЫШКА ЛОГОВ ПО ЦЕНТРУ ЭКРАНА
-- =================================================================
local LogScreenGui = Instance.new("ScreenGui")
LogScreenGui.Name = "MadiumMonolithCenterUI"
LogScreenGui.Parent = CoreGui

local LogContainer = Instance.new("Frame")
LogContainer.Size = UDim2.new(0, 500, 0, 300)
LogContainer.Position = UDim2.new(0.5, -250, 0.5, 55)
LogContainer.BackgroundTransparency = 1
LogContainer.Parent = LogScreenGui

local LogLayout = Instance.new("UIListLayout")
LogLayout.SortOrder = Enum.SortOrder.LayoutOrder
LogLayout.VerticalAlignment = Enum.VerticalAlignment.Top
LogLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
LogLayout.Padding = UDim.new(0, 6)
LogLayout.Parent = LogContainer

local function createHitLogMessage(enemyName, damageValue, positionVector)
    if not getgenv().MadiumConfig.HitLogsEnabled then return end
    local randomPhrase = FUNNY_MESSAGES[math.random(1, #FUNNY_MESSAGES)]
    local posX, posY, posZ = math.floor(positionVector.X), math.floor(positionVector.Y), math.floor(positionVector.Z)
    
    local logLabel = Instance.new("TextLabel")
    logLabel.Size = UDim2.new(1, 0, 0, 40)
    logLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    logLabel.BackgroundTransparency = 0.15
    logLabel.BorderSizePixel = 0
    logLabel.RichText = true
    logLabel.Text = string.format(" 💥 [HIT] %s | Урон: -%d | XYZ: (%d, %d, %d) -> %s", enemyName, damageValue, posX, posY, posZ, randomPhrase)
    logLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    logLabel.Font = Enum.Font.SourceSansBold
    logLabel.TextSize = 15
    logLabel.TextXAlignment = Enum.TextXAlignment.Center
    logLabel.Parent = LogContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = logLabel
    
    logLabel.TextTransparency = 1
    logLabel.BackgroundTransparency = 1
    
    TweenService:Create(logLabel, TweenInfo.new(0.12), {TextTransparency = 0, BackgroundTransparency = 0.15}):Play()
    
    task.spawn(function()
        task.wait(2.8)
        local fadeTween = TweenService:Create(logLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1, BackgroundTransparency = 1})
        fadeTween:Play()
        fadeTween.Completed:Connect(function() logLabel:Destroy() end)
    end)
end

-- =================================================================
-- ГЕНЕРАЦИЯ ГЕОМЕТРИЧЕСКОГО РАДУЖНОГО ПРИЗРАКА
-- =================================================================
local function spawnRainbowGhost(targetCharacter)
    if not getgenv().MadiumConfig.GhostChamsEnabled then return end
    if not targetCharacter then return end
    
    local ghostModel = Instance.new("Model")
    ghostModel.Name = "MadiumMonolithGhost"
    ghostModel.Parent = Workspace
    
    local partsList = {}
    
    for _, part in ipairs(targetCharacter:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            local ghostPart = Instance.new("Part")
            ghostPart.Size = part.Size
            ghostPart.CFrame = part.CFrame
            ghostPart.Material = Enum.Material.Neon
            ghostPart.Transparency = getgenv().MadiumConfig.GhostTransparency
            ghostPart.Anchored = true
            ghostPart.CanCollide = false
            ghostPart.Parent = ghostModel
            
            table.insert(partsList, {
                Part = ghostPart,
                LocalOffset = targetCharacter.HumanoidRootPart.CFrame:ToObjectSpace(part.CFrame)
            })
        end
    end
    
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 1
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = ghostModel
    
    local startTime = os.clock()
    local centerPosition = targetCharacter.HumanoidRootPart.Position
    
    local animConnection
    animConnection = RunService.RenderStepped:Connect(function()
        local elapsed = os.clock() - startTime
        if elapsed >= GHOST_DURATION then
            animConnection:Disconnect()
            return
        end
        
        local hue = (os.clock() * (COLOR_SHIFT_SPEED / 10)) % 1
        local rainbowColor = Color3.fromHSV(hue, 0.8, 1)
        highlight.OutlineColor = rainbowColor
        
        for _, data in ipairs(partsList) do
            if data.Part and data.Part.Parent then
                data.Part.CFrame = CFrame.new(centerPosition + Vector3.new(0, elapsed * FLOAT_SPEED, 0)) * data.LocalOffset
                data.Part.Color = rainbowColor
            end
        end
    end)
    
    task.spawn(function()
        task.wait(GHOST_DURATION)
        if animConnection.Connected then animConnection:Disconnect() end
        
        local tweenInfo = TweenInfo.new(FADE_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        for _, data in ipairs(partsList) do
            if data.Part and data.Part.Parent then
                TweenService:Create(data.Part, tweenInfo, {Transparency = 1}):Play()
            end
        end
        
        local hTween = TweenService:Create(highlight, tweenInfo, {OutlineTransparency = 1})
        hTween:Play()
        hTween.Completed:Connect(function() ghostModel:Destroy() end)
    end)
end

local function createCustomPurpleBeam(startPos, endPos)
    if not getgenv().MadiumConfig.TracersEnabled then return end
    
    local beamHolder = Instance.new("Part")
    beamHolder.Size = Vector3.new(0, 0, 0)
    beamHolder.Transparency = 1
    beamHolder.Anchored = true
    beamHolder.Position = startPos
    beamHolder.Parent = Workspace
    
    local attachStart = Instance.new("Attachment", beamHolder)
    attachStart.WorldPosition = startPos
    
    local attachEnd = Instance.new("Attachment", beamHolder)
    attachEnd.WorldPosition = endPos
    
    local beam = Instance.new("Beam")
    beam.Attachment0 = attachStart
    beam.Attachment1 = attachEnd
    beam.Color = ColorSequence.new(getgenv().MadiumConfig.LaserColor)
    beam.Width0 = 0.12
    beam.Width1 = 0.12
    beam.FaceCamera = true
    beam.LightEmission = 1
    beam.Parent = beamHolder
    
    local t = getgenv().MadiumConfig.GhostTransparency
    task.spawn(function()
        task.wait(0.15)
        while t < 1 do
            t = t + (RunService.RenderStepped:Wait() * 3.5)
            pcall(function() beam.Transparency = NumberSequence.new(t) end)
        end
        beamHolder:Destroy()
    end)
end

-- =================================================================
-- 🌀 ЕДИНЫЙ ЦИКЛ ОБРАБОТКИ СКАНИРОВАНИЯ, АВТО-СТРЕЛЬБЫ И ДОФИГА ESP
-- =================================================================
RunService.RenderStepped:Connect(function()
    local activeCamera = Workspace.CurrentCamera or Camera
    local silentData = getgenv().MadiumNewModeData
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local head = player.Character:FindFirstChild("Head")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and head and hrp then
                -- --- 1. МОНИТОРИНГ ЗДОРОВЬЯ (ЛОГИ, ЗВУК, ПРИЗРАКИ) ---
                local currentHp = humanoid.Health
                if hpCache[player] == nil then hpCache[player] = currentHp end
                
                if currentHp < hpCache[player] and currentHp > 0 then
                    local damageDealt = hpCache[player] - currentHp
                    if silentData.TargetName == player.Name then
                        if getgenv().MadiumConfig.HitSoundEnabled then
                            pcall(function()
                                if hitSoundObject.IsPlaying then hitSoundObject:Stop() end
                                hitSoundObject:Play()
                            end)
                        end
                        task.spawn(spawnRainbowGhost, player.Character)
                        task.spawn(createHitLogMessage, player.Name, damageDealt, head.Position)
                    end
                end
                
                hpCache[player] = currentHp
                
                if currentHp > 0 then
                    local distance = (head.Position - myPos).Magnitude
                    if distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
                
                -- --- 2. ОТРИСОВКА ESP ---
                if not espCache[player] then espCache[player] = createDrawingObjects() end
                local drawings = espCache[player]
                local hrpPos, onScreen = activeCamera:WorldToViewportPoint(hrp.Position)
                
                if onScreen and humanoid.Health > 0 then
                    if getgenv().MadiumConfig.ThreeDBoxes then
                        local box3d = create3DBox(player.Character)
                        box3d.Visible = true
                    else
                        local box3d = player.Character:FindFirstChild("Madium3DBox")
                        if box3d then box3d.Visible = false end
                    end
                    
                    if getgenv().MadiumConfig.Snaplines then
                        drawings.Tracer.From = Vector2.new(activeCamera.ViewportSize.X / 2, activeCamera.ViewportSize.Y)
                        drawings.Tracer.To = Vector2.new(hrpPos.X, hrpPos.Y)
                        drawings.Tracer.Visible = true
                    else
                        drawings.Tracer.Visible = false
                    end
                    
                    if getgenv().MadiumConfig.NamesESP then
                        drawings.Text.Text = string.format("%s [%dm]", player.Name, math.floor(distance))
                        drawings.Text.Position = Vector2.new(hrpPos.X, hrpPos.Y - 35)
                        drawings.Text.Visible = true
                    else
                        drawings.Text.Visible = false
                    end
                    
                    if getgenv().MadiumConfig.JumpESP then
                        local isJumping = humanoid.FloorMaterial == Enum.Material.Air
                        drawings.StateText.Text = isJumping and "[JUMPING]" or "[GROUND]"
                        drawings.StateText.Color = isJumping and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(0, 255, 100)
                        drawings.StateText.Position = Vector2.new(hrpPos.X, hrpPos.Y - 20)
                        drawings.StateText.Visible = true
                    else
                        drawings.StateText.Visible = false
                    end
                else
                    local box3d = player.Character:FindFirstChild("Madium3DBox")
                    if box3d then box3d.Visible = false end
                    drawings.Tracer.Visible = false
                    drawings.Text.Visible = false
                    drawings.StateText.Visible = false
                end
            end
        end
    end
    
    -- --- 3. АВТО-СТРЕЛЬБА ---
    if getgenv().MadiumConfig.AimbotEnabled and closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
        silentData.TargetHumanoid = closestPlayer.Character:FindFirstChildOfClass("Humanoid")
        silentData.TargetHeadPosition = closestPlayer.Character.Head.Position
        silentData.TargetPart = closestPlayer.Character.Head
        silentData.TargetName = closestPlayer.Name
        silentData.TargetCharacter = closestPlayer.Character
        
        if getgenv().MadiumConfig.AutoFireEnabled then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and (tick() - lastClick > getgenv().MadiumConfig.CLICK_DELAY) then
                lastClick = tick()
                task.spawn(function()
                    mouse1press()
                    task.wait(0.01)
                    mouse1release()
                end)
            end
        end
    else
        silentData.TargetHumanoid = nil
    end
end)

-- =================================================================
-- 🛰️ СЕТЕВОЙ ХУК WEAPONS_SYSTEM
-- =================================================================
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and method == "FireServer" and getgenv().MadiumConfig.AimbotEnabled then
        local targetHeadPos = getgenv().MadiumNewModeData.TargetHeadPosition
        local targetPart = getgenv().MadiumNewModeData.TargetPart
        local targetHumanoid = getgenv().MadiumNewModeData.TargetHumanoid
        
        if targetHeadPos and targetPart and targetHumanoid then
            if self.Name == "WeaponFired" then
                for i = 1, #args do
                    if typeof(args[i]) == "table" and args[i].origin and args[i].dir then
                        task.spawn(createCustomPurpleBeam, args[i].origin, targetHeadPos)
                        pcall(function() rawset(args[i], "dir", (targetHeadPos - args[i].origin).Unit) end)
                    end
                end
                return oldNamecall(self, unpack(args))
            end
            
            if self.Name == "WeaponHit" then
                for i = 1, #args do
                    local currentArg = args[i]
                    if typeof(currentArg) == "table" and currentArg.pid and currentArg.p then
                        pcall(function()
                            rawset(currentArg, "part", targetPart)
                            rawset(currentArg, "h", targetHumanoid)
                            rawset(currentArg, "p", targetHeadPos)
                        end)
                        return oldNamecall(self, unpack(args))
                    end
                end
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

Players.PlayerRemoving:Connect(function(player)
    hpCache[player] = nil
    if espCache[player] then
        espCache[player].Tracer:Destroy()
        espCache[player].Text:Destroy()
        espCache[player].StateText:Destroy()
        espCache[player] = nil
    end
end)
