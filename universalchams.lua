print(string.rep("=", 40))
print("🔮 ЗАПУСК СТАБИЛЬНОГО CHAMS ESP v1.0 [WEAPONS_SYSTEM] 🔮")
print("-> Сквозная неоновая подсветка активирована для режима FFA.")
print("-> 100% без лагов и ошибок в консоли.")
print(string.rep("=", 40))

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- =================================================================
-- ⚙️ НАСТРОЙКИ СТИЛЯ ПОДСВЕТКИ ESP
-- =================================================================
local ESP_COLOR = Color3.fromRGB(180, 0, 255)  -- Основной фиолетовый цвет силуэта
local OUTLINE_COLOR = Color3.fromRGB(255, 255, 255) -- Белый контур для четкости
local FILL_TRANSPARENCY = 0.65               -- Прозрачность внутри тела (0 = плотный, 1 = только контур)
local OUTLINE_TRANSPARENCY = 0.2            -- Прозрачность внешнего ободка

-- Функция создания безопасной подсветки на персонаже
local function applyEspHighlight(character)
    if not character then return end
    
    -- Проверяем, нет ли уже нашей подсветки, чтобы не спамить объекты в память
    local existingHighlight = character:FindFirstChild("MadiumEspHighlight")
    if existingHighlight then return end
    
    -- Создаем элемент Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "MadiumEspHighlight"
    
    -- Настраиваем цвета и прозрачность под наш фиолетовый стиль
    highlight.FillColor = ESP_COLOR
    highlight.FillTransparency = FILL_TRANSPARENCY
    highlight.OutlineColor = OUTLINE_COLOR
    highlight.OutlineTransparency = OUTLINE_TRANSPARENCY
    
    -- Режим AlwaysOnTop заставляет силуэт просвечивать сквозь стены и ящики
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
end

-- =================================================================
-- АВТОНОМНЫЙ ЦИКЛ ОБНОВЛЕНИЯ И ПОДДЕРЖАНИЯ ESP
-- =================================================================
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        -- Режим FFA: подсвечиваем вообще всех игроков, кроме тебя
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            -- Подсвечиваем только живых противников
            if humanoid and humanoid.Health > 0 then
                pcall(function()
                    applyEspHighlight(player.Character)
                end)
            else
                -- Если враг умер, мгновенно удаляем подсветку, чтобы не путаться
                local deadHighlight = player.Character:FindFirstChild("MadiumEspHighlight")
                if deadHighlight then
                    deadHighlight:Destroy()
                end
            end
        end
    end
end)

-- Очистка при выходе игрока с сервера
Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        local highlight = player.Character:FindFirstChild("MadiumEspHighlight")
        if highlight then highlight:Destroy() end
    end
end)
