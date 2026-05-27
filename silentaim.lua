print(string.rep("=", 40))
print("🔮 ЗАПУСК SILENT AIM v7.1 + CUSTOM PURPLE TRACERS 🔮")
print("-> Сайлент работает на убой по ивенту WeaponHit.")
print("-> Фиолетовые лазеры с эффектом Fade Out привязаны к WeaponFired!")
print(string.rep("=", 40))

-- Глобальная таблица для кэширования нашей цели
getgenv().MadiumNewModeData = {
    TargetHumanoid = nil,
    TargetHeadPosition = nil,
    TargetPart = nil
}

local PlayersService = game:GetService("Players")
local RunService = game:GetService("RunService")
local WorkspaceService = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local LocalPlayer = PlayersService.LocalPlayer

-- =================================================================
-- ⚙️ НАСТРОЙКИ СТИЛЯ ФИОЛЕТОВОГО ТРЕЙСЕРА
-- =================================================================
local GHOST_COLOR = Color3.fromRGB(180, 0, 255) -- Фиолетовый неоновый цвет
local GHOST_BASE_TRANSPARENCY = 0.3            -- Начальная полупрозрачность
local DISPLAY_DURATION = 0.15                  -- Сколько секунд лазер висит в воздухе
local FADE_SPEED = 3.0                         -- Скорость плавного растворения (Fade Out)

-- Функция создания красивого фиолетового луча в 3D мире
local function createCustomPurpleBeam(startPos, endPos)
    local beamHolder = Instance.new("Part")
    beamHolder.Name = "MadiumLaserHolder"
    beamHolder.Size = Vector3.new(0, 0, 0)
    beamHolder.Transparency = 1
    beamHolder.Anchored = true
    beamHolder.CanCollide = false
    beamHolder.Position = startPos
    beamHolder.Parent = WorkspaceService

    local attachStart = Instance.new("Attachment", beamHolder)
    attachStart.WorldPosition = startPos

    local attachEnd = Instance.new("Attachment", beamHolder)
    attachEnd.WorldPosition = endPos

    local beam = Instance.new("Beam")
    beam.Attachment0 = attachStart
    beam.Attachment1 = attachEnd
    
    -- Настройки стиля неонового лазера
    beam.Color = ColorSequence.new(GHOST_COLOR) 
    beam.Width0 = 0.12 -- Толщина у ствола
    beam.Width1 = 0.12 -- Толщина у цели
    beam.FaceCamera = true 
    
    local currentTransparency = GHOST_BASE_TRANSPARENCY
    beam.Transparency = NumberSequence.new(currentTransparency) 
    beam.LightEmission = 1 -- Свечение в темноте
    beam.Parent = beamHolder

    -- Безопасный и плавный Fade Out на каждый кадр без использования TweenService
    task.spawn(function()
        task.wait(DISPLAY_DURATION) 
        while currentTransparency < 1 do
            currentTransparency = currentTransparency + (RunService.RenderStepped:Wait() * FADE_SPEED)
            if currentTransparency > 1 then currentTransparency = 1 end
            pcall(function()
                beam.Transparency = NumberSequence.new(currentTransparency)
            end)
        end
        beamHolder:Destroy() -- Очищаем оперативную память
    end)
end

-- =================================================================
-- ПОТОК 1: АВТОНОМНЫЙ ИНФИНИТИ-СКАНЕР (Ближайший враг на 360°)
-- =================================================================
RunService.RenderStepped:Connect(function()
    local closestPlayer = nil
    local shortestDistance = math.huge

    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position

    for _, player in ipairs(PlayersService:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            -- Режим FFA: Проверки команд отключены
            if humanoid.Health > 0 then
                local enemyPos = player.Character.Head.Position
                local distance = (enemyPos - myPos).Magnitude
                
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    
    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
        getgenv().MadiumNewModeData.TargetHumanoid = closestPlayer.Character:FindFirstChildOfClass("Humanoid")
        getgenv().MadiumNewModeData.TargetHeadPosition = closestPlayer.Character.Head.Position
        getgenv().MadiumNewModeData.TargetPart = closestPlayer.Character.Head
    else
        getgenv().MadiumNewModeData.TargetHumanoid = nil
        getgenv().MadiumNewModeData.TargetHeadPosition = nil
        getgenv().MadiumNewModeData.TargetPart = nil
    end
end)

-- =================================================================
-- ПОТОК 2: СЕТЕВОЙ ХУК (ОБРАБОТКА УРОНА И ОТРИСОВКА ВИЗУАЛЬНЫХ ЛАЗЕРОВ)
-- =================================================================
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and method == "FireServer" then
        local targetHeadPos = getgenv().MadiumNewModeData.TargetHeadPosition
        local targetPart = getgenv().MadiumNewModeData.TargetPart
        local targetHumanoid = getgenv().MadiumNewModeData.TargetHumanoid
        
        if targetHeadPos and targetPart and targetHumanoid then
            
            -- 🔥 ЧАСТЬ А: РИСУЕМ КАСТ ОМНЫЙ ФИОЛЕТОВЫЙ ТРЕЙСЕР ПРИ ВЫСТРЕЛЕ
            if self.Name == "WeaponFired" then
                for i = 1, #args do
                    if typeof(args[i]) == "table" and args[i].origin and args[i].dir then
                        local weaponOrigin = args[i].origin -- Забираем реальную точку вылета пули
                        
                        -- Рисуем роскошный фиолетовый лазер строго из ствола в голову жертвы аима!
                        pcall(function()
                            createCustomPurpleBeam(weaponOrigin, targetHeadPos)
                        end)
                        
                        -- Направляем легитный трассер игры туда же, чтобы визуалы полностью совпадали
                        local silentDirection = (targetHeadPos - weaponOrigin).Unit
                        pcall(function()
                            rawset(args[i], "dir", silentDirection)
                        end)
                    end
                end
                return oldNamecall(self, unpack(args))
            end
            
            -- 🔥 ЧАСТЬ Б: РЕГИСТРИРУЕМ УЛЬТРА-УРОН В ГОЛОВУ ВРАГА
            if self.Name == "WeaponHit" then
                for i = 1, #args do
                    if typeof(args[i]) == "table" and args[i].pid and args[i].p then
                        pcall(function()
                            rawset(args[i], "part", targetPart)       
                            rawset(args[i], "h", targetHumanoid)      
                            rawset(args[i], "p", targetHeadPos)       
                            if args[i].m then
                                rawset(args[i], "m", Enum.Material.Plastic)
                            end
                        end)
                        return oldNamecall(self, unpack(args))
                    end
                end
            end
            
        end
    end
    
    return oldNamecall(self, ...)
end)
