print(string.rep("=", 40))
print("🐰 ЗАПУСК СВЕРХБЫСТРОГО БХОПА С УСКОРЕНИЕМ v1.0 🐰")
print("-> Зажмите ПРОБЕЛ для автопрыжка.")
print("-> Скорость постепенно нарастает с каждым прыжком!")
print(string.rep("=", 40))

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- =================================================================
-- НАСТРОЙКИ СКОРОСТИ И НАБОРА УСКОРЕНИЯ
-- =================================================================
local MAX_BHOP_SPEED = 75     -- Максимальная скорость, до которой можно разогнаться
local SPEED_GAIN = 1.8       -- Сколько скорости добавляется за каждый прыжок
local BASE_SPEED = 16        -- Дефолтная скорость бега в вашей игре

local currentBhopSpeed = BASE_SPEED
local isSpacePressed = false

-- Отслеживаем зажатие пробела
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Space then
        isSpacePressed = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        isSpacePressed = false
        currentBhopSpeed = BASE_SPEED -- Сбрасываем разгон при отпускании пробела
    end
end)

-- Основной физический цикл ускорения
RunService.Heartbeat:Connect(function()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if hrp and humanoid and humanoid.Health > 0 then
        -- Если зажат пробел и персонаж находится на земле (или падает)
        if isSpacePressed then
            -- Автоматический прыжок: меняем состояние гуманоида, убирая задержку приземления
            if humanoid.FloorMaterial ~= Enum.Material.Air then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                
                -- Наращиваем скорость за легитный тайминг прыжка
                if currentBhopSpeed < MAX_BHOP_SPEED then
                    currentBhopSpeed = currentBhopSpeed + SPEED_GAIN
                end
            end
            
            -- Рассчитываем вектор направления движения игрока (куда зажаты клавиши)
            local moveDirection = humanoid.MoveDirection
            
            -- Если игрок физически куда-то идет (зажаты W, A, S или D)
            if moveDirection.Magnitude > 0 then
                -- Жестко перезаписываем горизонтальную скорость (X и Z) в обход WalkSpeed
                -- Вертикальную скорость (Y) оставляем нетронутой, чтобы прыжок летел вверх нормально
                hrp.Velocity = Vector3.new(
                    moveDirection.X * currentBhopSpeed,
                    hrp.Velocity.Y,
                    moveDirection.Z * currentBhopSpeed
                )
            end
        else
            -- Если пробел не зажат, плавно возвращаем базовую скорость
            currentBhopSpeed = BASE_SPEED
        end
    end
end)

-- Фикс сброса разгона при респавне персонажа
LocalPlayer.CharacterAdded:Connect(function()
    currentBhopSpeed = BASE_SPEED
    isSpacePressed = false
end)

print("Бхоп успешно активирован. Приятного полета по карте!")
print(string.rep("=", 40))
