print(string.rep("=", 40))
print("🌌 ЗАПУСК ЯРКОЙ КОСМИЧЕСКОЙ НОЧИ MADIUM COSMIC MOON v1.1 🌌")
print("-> Освещение карты успешно поднято. Чернота устранена!")
print(string.rep("=", 40))

local Lighting = game:GetService("Lighting")

-- =================================================================
-- 1. УВЕЛИЧЕНИЕ ЯРКОСТИ И КОСМИЧЕСКОГО ПОДСВЕТА (ОСВЕТЛЕНИЕ)
-- =================================================================
Lighting.ClockTime = 0 -- Полночь
Lighting.GeographicLatitude = 45 

-- ПОДНИМАЕМ ДЕФОЛТНУЮ ЯРКОСТЬ
Lighting.Brightness = 1.2 -- Выкрутили яркость лунного света (было 0.2), теперь все объекты светятся
Lighting.OutdoorAmbient = Color3.fromRGB(60, 80, 120) -- Сделали пассивный свет неба ярким небесно-синим (было 15, 20, 35)
Lighting.Ambient = Color3.fromRGB(40, 45, 60) -- Осветлили самые глубокие углы и закрытые помещения
Lighting.ShadowSoftness = 0.2 -- Слегка смягчили тени, чтобы картинка была более приятной для глаз

-- Настраиваем Bloom (Эффект неонового свечения для трейсеров и звезд)
local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
if not bloom then
    bloom = Instance.new("BloomEffect", Lighting)
end
bloom.Intensity = 0.8 -- Чуть снизили, чтобы из-за высокой яркости экран не засвечивало
bloom.Size = 15
bloom.Threshold = 0.9

-- =================================================================
-- 2. ЗАМЕНА СТАНДАРТНОГО НЕБА НА КОМЕТНЫЙ НЕОН (SKY BOX)
-- =================================================================
for _, child in ipairs(Lighting:GetChildren()) do
    if child:IsA("Sky") then
        child:Destroy()
    end
end

local cosmicSky = Instance.new("Sky")
cosmicSky.Name = "MadiumCosmicSky"

-- Те же сочные HD-текстуры глубокого космоса с кометами и туманностями
cosmicSky.SkyboxBk = "rbxassetid://12061214041"
cosmicSky.SkyboxDn = "rbxassetid://12061213761"
cosmicSky.SkyboxFt = "rbxassetid://12061214304"
cosmicSky.SkyboxLf = "rbxassetid://12061214545"
cosmicSky.SkyboxRt = "rbxassetid://12061214957"
cosmicSky.SkyboxUp = "rbxassetid://12061215160"

cosmicSky.StarCount = 6000 -- Еще больше сияющих звезд
cosmicSky.CelestialBodiesShown = true
cosmicSky.Parent = Lighting

-- =================================================================
-- 3. СОЗДАНИЕ НЕОНОВОГО ТУМАНА И СВЕЧЕНИЯ ГОРИЗОНТА
-- =================================================================
local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
if not atmosphere then
    atmosphere = Instance.new("Atmosphere", Lighting)
end

atmosphere.Density = 0.15 -- Сделали воздух чуть прозрачнее, чтобы убрать лишнюю мглу
atmosphere.Offset = 0.2
atmosphere.Color = Color3.fromRGB(140, 50, 255) -- Фиолетовое неоновое свечение горизонта
atmosphere.Decay = Color3.fromRGB(20, 60, 180) -- Приятный синий градиент
atmosphere.Glare = 1.0 
atmosphere.Haze = 1.5 

print("Осветленная космическая ночь готова! Карта стала яркой и контрастной.")
print(string.rep("=", 40))
