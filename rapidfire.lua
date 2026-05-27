print(string.rep("=", 40))
print("🚀 ЗАПУСК ULTRA RAPID FIRE v2.0 [NAMECALL MULTIPLIER] 🚀")
print("-> Сетевые пакеты WeaponFired дублируются напрямую в памяти!")
print("-> Вы стреляете сами на ЛКМ. Скорость выкручена на максимум.")
print(string.rep("=", 40))

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- =================================================================
-- НАСТРОЙКИ СКОРОСТРЕЛ ЬНОСТИ (МНОЖИТЕЛЬ ПАКЕТОВ)
-- =================================================================
local FIRE_MULTIPLIER = 100 -- Сколько пуль/ракет вылетит ЗА ОДИН твой клик (поставь 30 для безумия)

-- Перехватываем нативный метод вызова сетевых ивентов игры
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Ловим оригинальный пакет выстрела, который генерирует твоя пушка при нажатии на ЛКМ
    if not checkcaller() and method == "FireServer" and (self.Name == "WeaponFired" or self.Name:lower():find("fire") or self.Name:lower():find("shot")) then
        -- Вытаскиваем текущее оружие из рук персонажа
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        
        if tool then
            -- МГНОВЕННЫЙ МНОЖИТЕЛЬ: Запускаем цикл, который отправляет этот же пакет на сервер многократно в тот же миг!
            task.spawn(function()
                for i = 1, FIRE_MULTIPLIER do
                    -- Шлем оригинальные аргументы игры без поломки структуры данных
                    oldNamecall(self, unpack(args))
                    
                    -- Наносекундная микро-задержка, чтобы сервер успел зарегистрировать снаряды и не кикнул
                    if i % 3 == 0 then
                        RunService.Heartbeat:Wait()
                    end
                end
            end)
        end
    end
    
    return oldNamecall(self, ...)
end)

-- Глобальный взлом атрибутов скорострельности оружия (если игра хранит конфиги в Tool)
RunService.Heartbeat:Connect(function()
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        -- Пробегаемся по всем скрытым настройкам внутри пушки и выкручиваем задержку выстрела в ноль
        pcall(function()
            if tool:GetAttribute("Cooldown") or tool:GetAttribute("FireRate") or tool:GetAttribute("Delay") then
                tool:SetAttribute("Cooldown", 0)
                tool:SetAttribute("FireRate", 0)
                tool:SetAttribute("Delay", 0)
            end
            
            -- Проверяем наличие конфигурационных папок внутри Grenade Launcher
            local config = tool:FindFirstChild("Configuration") or tool:FindFirstChild("Settings")
            if config then
                for _, val in ipairs(config:GetChildren()) do
                    if val:IsA("NumberValue") or val:IsA("IntValue") then
                        if val.Name:lower():find("rate") or val.Name:lower():find("delay") or val.Name:lower():find("cooldown") or val.Name:lower():find("time") then
                            val.Value = 0 -- Стираем задержку перезарядки между выстрелами
                        end
                    end
                end
            end
        end)
    end
end)

print("Скрипт успешно применен. Возьмите Гренадерку или Ракетницу и кликните ЛКМ!")
print(string.rep("=", 40))
