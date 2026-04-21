repeat task.wait() until game:IsLoaded()
task.wait(3)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

repeat task.wait() until player.Character
task.wait(2)

-- ============================================
-- CONFIGURACIÓN
-- ============================================
local GAME_PLACE_ID = game.PlaceId  -- Usa el ID del juego actual
local webhookURL = "https://discord.com/api/webhooks/1496176684158943415/8BpJsjLXOSJiAIgXX4D-AJZrthTXH8jH5xz_Gj7xfdhmEU-p2Uwm7yN_jxtK5yEmLkyH"

local totalWins = 0
local startTime = os.time()
local saveFileName = "bedwars_farm.txt"

-- Cargar wins
if isfile and readfile then
    local success, savedWins = pcall(function() return readfile(saveFileName) end)
    if success and savedWins then totalWins = tonumber(savedWins) or 0 end
end

local function saveWins()
    if writefile then pcall(function() writefile(saveFileName, tostring(totalWins)) end) end
end

-- Enviar log a Discord
local function sendDiscordLog(wins)
    if webhookURL == "" then return end
    pcall(function()
        local embed = {
            ["embeds"] = {{
                ["title"] = "🏆 Victoria Registrada",
                ["color"] = 0xFFD700,
                ["fields"] = {
                    {["name"] = "👤 Usuario", ["value"] = player.Name, ["inline"] = true},
                    {["name"] = "🏆 Wins", ["value"] = tostring(wins), ["inline"] = true},
                },
                ["footer"] = {["text"] = "AutoFarm by Sxzly"},
            }}
        }
        request({Url = webhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(embed)})
    end)
end

-- ============================================
-- FUNCIÓN REJOIN (IGUAL QUE BRIDGE DUELS)
-- ============================================
local function rejoin()
    print("🔄 Rejoineando...")
    task.wait(0.5)
    player:Kick()
    task.wait(1.23)
    local data = TeleportService:GetLocalPlayerTeleportData()
    TeleportService:Teleport(GAME_PLACE_ID, player, data)
end

-- ============================================
-- UI MOVIBLE (SOLO BOTÓN LISTO)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Barra de título
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.BackgroundTransparency = 0.3

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "⚔️ BEDWARS FARM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Botón minimizar
local MinBtn = Instance.new("TextButton")
MinBtn.Parent = TitleBar
MinBtn.Position = UDim2.new(1, -25, 0, 5)
MinBtn.Size = UDim2.new(0, 20, 0, 20)
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
MinBtn.BackgroundTransparency = 0.3
MinBtn.BorderSizePixel = 0
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "─"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 14

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 4)
MinCorner.Parent = MinBtn

-- Contador de wins
local WinsLabel = Instance.new("TextLabel")
WinsLabel.Parent = MainFrame
WinsLabel.Position = UDim2.new(0, 10, 0, 45)
WinsLabel.Size = UDim2.new(1, -20, 0, 30)
WinsLabel.BackgroundTransparency = 1
WinsLabel.Font = Enum.Font.GothamBold
WinsLabel.Text = "🏆 " .. totalWins
WinsLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
WinsLabel.TextSize = 18

-- Timer
local TimerLabel = Instance.new("TextLabel")
TimerLabel.Parent = MainFrame
TimerLabel.Position = UDim2.new(0, 10, 0, 75)
TimerLabel.Size = UDim2.new(1, -20, 0, 20)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Font = Enum.Font.Gotham
TimerLabel.Text = "⏱️ 00:00"
TimerLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
TimerLabel.TextSize = 11

-- ============================================
-- BOTÓN LISTO (IGUAL QUE BRIDGE DUELS)
-- ============================================
local ReadyButton = Instance.new("TextButton")
ReadyButton.Parent = MainFrame
ReadyButton.Position = UDim2.new(0, 10, 0, 105)
ReadyButton.Size = UDim2.new(1, -20, 0, 40)
ReadyButton.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
ReadyButton.BackgroundTransparency = 0.2
ReadyButton.BorderSizePixel = 0
ReadyButton.Font = Enum.Font.GothamBold
ReadyButton.Text = "✅ LISTO"
ReadyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ReadyButton.TextSize = 16
ReadyButton.AutoButtonColor = false

local ReadyCorner = Instance.new("UICorner")
ReadyCorner.CornerRadius = UDim.new(0, 8)
ReadyCorner.Parent = ReadyButton

-- Hover effect
ReadyButton.MouseEnter:Connect(function()
    TweenService:Create(ReadyButton, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end)
ReadyButton.MouseLeave:Connect(function()
    TweenService:Create(ReadyButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
end)

-- Minimizar
local minimized = false
local originalSize = MainFrame.Size

MinBtn.MouseButton1Click:Connect(function()
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = originalSize}):Play()
        WinsLabel.Visible = true
        TimerLabel.Visible = true
        ReadyButton.Visible = true
        minimized = false
        MinBtn.Text = "─"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 200, 0, 35)}):Play()
        WinsLabel.Visible = false
        TimerLabel.Visible = false
        ReadyButton.Visible = false
        minimized = true
        MinBtn.Text = "□"
    end
end)

-- Actualizar timer
task.spawn(function()
    while true do
        local elapsed = os.time() - startTime
        local minutes = math.floor(elapsed / 60)
        local seconds = elapsed % 60
        TimerLabel.Text = string.format("⏱️ %02d:%02d", minutes, seconds)
        task.wait(1)
    end
end)

-- ============================================
-- BOTÓN LISTO (REJOIN COMO BRIDGE DUELS)
-- ============================================
local isProcessing = false

ReadyButton.MouseButton1Click:Connect(function()
    if isProcessing then return end
    isProcessing = true
    
    -- Animar botón
    TweenService:Create(ReadyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 255, 80)}):Play()
    ReadyButton.Text = "🔄 REJOIN..."
    
    -- Sumar victoria
    totalWins = totalWins + 1
    WinsLabel.Text = "🏆 " .. totalWins
    saveWins()
    sendDiscordLog(totalWins)
    
    print("🏆 Victoria #" .. totalWins .. " - Haciendo rejoin...")
    
    task.wait(0.5)
    
    -- REJOIN (IGUAL QUE BRIDGE DUELS)
    rejoin()
    
    -- Restaurar botón (esto se ejecutará después del rejoin)
    ReadyButton.Text = "✅ LISTO"
    TweenService:Create(ReadyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 80, 255)}):Play()
    isProcessing = false
end)

-- Animación de entrada
MainFrame.Size = UDim2.new(0, 0, 0, 0)
task.wait(0.3)
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 160)}):Play()

print("✅ BedWars Farm Cargado - Modo Bridge Duels")
print("🎯 1. Rompe la cama MANUALMENTE")
print("🎯 2. Presiona 'LISTO'")
print("🎯 3. El script hará REJOIN automático")
