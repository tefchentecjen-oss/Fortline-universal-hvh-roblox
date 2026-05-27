print(string.rep("=", 40))
print("🕺 ЗАПУСК BONE SPINNER ANTI-AIM v3.0 [SUSTAV SPIN] 🕺")
print("-> Наклон зафиксирован на 45 градусах.")
print("-> Руки, голова и пояс бешено крутятся отдельно от ног!")
print(string.rep("=", 40))

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- =================================================================
-- ⚙️ НАСТРОЙКИ СКОРОСТИ И НАКЛОНА ЧАСТЕЙ ТЕЛА
-- =================================================================
local LEAN_ANGLE = 45      -- Умеренный наклон торса вперед
local SPIN_SPEED = 160     -- Скорость вращения частей тела (чем выше, тем быстрее твист)

local currentBoneAngle = 0

RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local lowerTorso = character:FindFirstChild("LowerTorso") or character:FindFirstChild("Torso")
    local upperTorso = character:FindFirstChild("UpperTorso")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and rootPart and lowerTorso then
        -- 1. ТАЗ И НАПРАВЛЕНИЕ НОГ ОСТАЮТСЯ ЛЕГИТНЫМИ (Чтобы не ломать ходьбу)
        local rootJoint = rootPart:FindFirstChild("RootJoint") or lowerTorso:FindFirstChild("RootJoint")
        if rootJoint then
            -- Фиксируем ноги лицом к экрану для стабильного бега
            rootJoint.C1 = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(90), 0, math.rad(180))
        end
        
        -- Динамический счетчик угла для верхних костей
        currentBoneAngle = (currentBoneAngle + SPIN_SPEED) % 360
        local boneTurnRad = math.rad(currentBoneAngle)
        local leanRad = math.rad(LEAN_ANGLE)
        
        -- 2. БЕШЕНОЕ ВРАЩЕНИЕ ПОЯСА (Торс закручивается по кругу)
        if upperTorso then
            local waist = upperTorso:FindFirstChild("Waist") or lowerTorso:FindFirstChild("Waist")
            if waist then
                -- Наклоняем торс по оси X на 45° и бешено крутим вокруг оси Y!
                waist.C1 = CFrame.new(0, 0, 0) * CFrame.Angles(leanRad, boneTurnRad, 0)
            end
        end
        
        -- 3. БЕШЕНОЕ СИНХРОННОЕ ВРАЩЕНИЕ ГОЛОВЫ И ШЕИ
        local head = character:FindFirstChild("Head")
        if upperTorso and head then
            local neck = head:FindFirstChild("Neck") or upperTorso:FindFirstChild("Neck")
            if neck then
                -- Голова крутится в противоход торсу для максимального глитч-эффекта
                neck.C1 = CFrame.new(0, -0.5, 0) * CFrame.Angles(math.rad(-90) - leanRad, -boneTurnRad, 0)
            end
        end

        -- 4. ВРАЩЕНИЕ СУСТАВОВ РУК И ОРУЖИЯ (Motor6D конечностей)
        for _, motor in ipairs(character:GetDescendants()) do
            if motor:IsA("Motor6D") then
                -- Ищем суставы левого и правого плеча (R15 и R6 форматы)
                if motor.Name:find("Shoulder") or motor.Name:find("Arm") then
                    pcall(function()
                        -- Заставляем руки с оружием бешено крутиться пропеллером на каждом кадре
                        motor.C1 = motor.C1 * CFrame.Angles(0, math.rad(SPIN_SPEED), 0)
                    end)
                end
            end
        end
    end
end)

print("Bone Спиннер успешно применен! Переключитесь на клавишу 'K' для проверки.")
print(string.rep("=", 40))
