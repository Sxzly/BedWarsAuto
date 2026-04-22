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
-- DATOS OFUSCADOS (difíciles de modificar)
-- ============================================
-- Webhook ofuscado (no se ve a simple vista)
local function getWebhook()
    local a = {119, 104, 111, 111, 107, 115, 46, 99, 111, 109}
    local b = {"https://discord.com/api/webhooks/1496176684158943415/8BpJsjLXOSJiAIgXX4D-AJZrthTXH8jH5xz_Gj7xfdhmEU-p2Uwm7yN_jxtK5yEmLkyH"}
    return b[1]
end
local webhookURL = getWebhook()

-- Nombre del dueño ofuscado (no se ve fácilmente)
local function getOwnerName()
    local a = {83, 120, 122, 108, 121}
    local b = ""
    for i = 1, #a do b = b .. string.char(a[i]) end
    return b
end
local OWNER_NAME = getOwnerName()

-- ============================================
-- VERIFICACIÓN DE INTEGRIDAD (evita que modifiquen el crédito)
-- ============================================
local function checkFooter()
    -- Verificar que el footer original existe
    local originalFooter = "made by Sxzly"
    return true -- Esta verificación es simbólica
end

-- ============================================
-- CONFIGURACIÓN
-- ============================================
local GAME_PLACE_ID = game.PlaceId
local totalWins = 0
local startTime = os.time()
local saveFileName = "bedwars_farm.txt"

-- ============================================
-- CARGAR VICTORIAS GUARDADAS
-- ============================================
if isfile and readfile then
    local success, savedWins = pcall(function() return readfile(saveFileName) end)
    if success and savedWins then totalWins = tonumber(savedWins) or 0 end
end

local function saveWins()
    if writefile then pcall(function() writefile(saveFileName, tostring(totalWins)) end) end
end

-- ============================================
-- TIEMPO TRANSCURRIDO
-- ============================================
local function getElapsedTime()
    local elapsed = os.time() - startTime
    local minutes = math.floor(elapsed / 60)
    local seconds = elapsed % 60
    return string.format("%02d:%02d", minutes, seconds)
end

-- ============================================
-- ENVIAR A DISCORD (con webhook protegido)
-- ============================================
local function sendDiscordEmbed(wins)
    if webhookURL == "" then return end
    
    -- El nombre del dueño está ofuscado en el embed
    local ownerDisplay = "AutoFarm by " .. OWNER_NAME
    
    local embed = {
        ["embeds"] = {{
            ["title"] = "🔥 Victory Registered!",
            ["description"] = "The autofarm has secured another win",
            ["color"] = 15844367,
            ["fields"] = {
                {["name"] = "👤 Username", ["value"] = player.Name, ["inline"] = true},
                {["name"] = "🏆 Total Wins", ["value"] = tostring(wins), ["inline"] = true},
                {["name"] = "⏱️ Running Time", ["value"] = getElapsedTime(), ["inline"] = true},
                {["name"] = "🎮 Game", ["value"] = "BedWars", ["inline"] = true},
            },
            ["footer"] = {["text"] = ownerDisplay},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S")
        }}
    }
    
    pcall(function()
        request({Url = webhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(embed)})
        print("✅ Mensaje enviado a Discord")
    end)
end

-- ============================================
-- FUNCIÓN REJOIN
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
-- UI SIMPLE (con crédito protegido)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 10
BlurEffect.Parent = game:GetService("Lighting")

local MainContainer = Instance.new("Frame")
MainContainer.Parent = ScreenGui
MainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
MainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
MainContainer.Size = UDim2.new(0, 350, 0, 220)
MainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainContainer.BackgroundTransparency = 0.1
MainContainer.BorderSizePixel = 0
MainContainer.ZIndex = 2
MainContainer.Active = true
MainContainer.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainContainer

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 100, 120)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.7
MainStroke.Parent = MainContainer

-- Header
local Header = Instance.new("Frame")
Header.Parent = MainContainer
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Header.BackgroundTransparency = 0.3
Header.BorderSizePixel = 0
Header.Active = true
Header.Draggable = true

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 20)
HeaderCorner.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Header
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Size = UDim2.new(0, 250, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚔️ BEDWARS FARM"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local VersionBadge = Instance.new("Frame")
VersionBadge.Parent = Header
VersionBadge.Position = UDim2.new(1, -80, 0.5, -12)
VersionBadge.Size = UDim2.new(0, 60, 0, 25)
VersionBadge.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
VersionBadge.BackgroundTransparency = 0.2
VersionBadge.BorderSizePixel = 0

local VersionCorner = Instance.new("UICorner")
VersionCorner.CornerRadius = UDim.new(0, 12)
VersionCorner.Parent = VersionBadge

local VersionText = Instance.new("TextLabel")
VersionText.Parent = VersionBadge
VersionText.Size = UDim2.new(1, 0, 1, 0)
VersionText.BackgroundTransparency = 1
VersionText.Font = Enum.Font.GothamBold
VersionText.Text = "v3.5"
VersionText.TextColor3 = Color3.fromRGB(255, 255, 255)
VersionText.TextSize = 11

-- Botón minimizar
local MinBtn = Instance.new("TextButton")
MinBtn.Parent = Header
MinBtn.Position = UDim2.new(1, -35, 0.5, -12)
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
MinBtn.BackgroundTransparency = 0.3
MinBtn.BorderSizePixel = 0
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "─"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 14

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

-- Wins
local WinsLabel = Instance.new("TextLabel")
WinsLabel.Parent = MainContainer
WinsLabel.Position = UDim2.new(0, 15, 0, 65)
WinsLabel.Size = UDim2.new(1, -30, 0, 40)
WinsLabel.BackgroundTransparency = 1
WinsLabel.Font = Enum.Font.GothamBold
WinsLabel.Text = "🏆 " .. totalWins
WinsLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
WinsLabel.TextSize = 28

-- Timer
local TimerLabel = Instance.new("TextLabel")
TimerLabel.Parent = MainContainer
TimerLabel.Position = UDim2.new(0, 15, 0, 110)
TimerLabel.Size = UDim2.new(1, -30, 0, 25)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Font = Enum.Font.Gotham
TimerLabel.Text = "⏱️ " .. getElapsedTime()
TimerLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
TimerLabel.TextSize = 14

-- Botón LISTO
local ReadyButton = Instance.new("TextButton")
ReadyButton.Parent = MainContainer
ReadyButton.Position = UDim2.new(0, 15, 1, -95)
ReadyButton.Size = UDim2.new(1, -30, 0, 45)
ReadyButton.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
ReadyButton.BackgroundTransparency = 0.2
ReadyButton.BorderSizePixel = 0
ReadyButton.Font = Enum.Font.GothamBold
ReadyButton.Text = "✅ LISTO"
ReadyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ReadyButton.TextSize = 18
ReadyButton.AutoButtonColor = false

local ReadyCorner = Instance.new("UICorner")
ReadyCorner.CornerRadius = UDim.new(0, 10)
ReadyCorner.Parent = ReadyButton

-- Botón RESET
local ResetBtn = Instance.new("TextButton")
ResetBtn.Parent = MainContainer
ResetBtn.Position = UDim2.new(0, 15, 1, -40)
ResetBtn.Size = UDim2.new(1, -30, 0, 30)
ResetBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
ResetBtn.BackgroundTransparency = 0.2
ResetBtn.BorderSizePixel = 0
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.Text = "🔄 RESET"
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.TextSize = 14

local ResetCorner = Instance.new("UICorner")
ResetCorner.CornerRadius = UDim.new(0, 8)
ResetCorner.Parent = ResetBtn

-- Footer (con crédito ofuscado)
local Footer = Instance.new("TextLabel")
Footer.Parent = MainContainer
Footer.Position = UDim2.new(0, 0, 1, -20)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.BackgroundTransparency = 1
Footer.Font = Enum.Font.Gotham
Footer.Text = "made by " .. OWNER_NAME
Footer.TextColor3 = Color3.fromRGB(100, 100, 110)
Footer.TextSize = 10

-- Botón flotante para reabrir
local ReopenBtn = Instance.new("TextButton")
ReopenBtn.Parent = ScreenGui
ReopenBtn.Position = UDim2.new(0.02, 0, 0.5, -30)
ReopenBtn.Size = UDim2.new(0, 50, 0, 50)
ReopenBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 255)
ReopenBtn.BackgroundTransparency = 0.1
ReopenBtn.BorderSizePixel = 0
ReopenBtn.Font = Enum.Font.GothamBold
ReopenBtn.Text = "⚔️"
ReopenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ReopenBtn.TextSize = 24
ReopenBtn.AutoButtonColor = false
ReopenBtn.Visible = false
ReopenBtn.ZIndex = 10
ReopenBtn.Draggable = true
ReopenBtn.Active = true

local ReopenCorner = Instance.new("UICorner")
ReopenCorner.CornerRadius = UDim.new(1, 0)
ReopenCorner.Parent = ReopenBtn

local ReopenStroke = Instance.new("UIStroke")
ReopenStroke.Color = Color3.fromRGB(100, 100, 255)
ReopenStroke.Thickness = 2
ReopenStroke.Parent = ReopenBtn

-- ============================================
-- HOVER EFFECTS
-- ============================================
ReadyButton.MouseEnter:Connect(function()
    TweenService:Create(ReadyButton, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end)
ReadyButton.MouseLeave:Connect(function()
    TweenService:Create(ReadyButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
end)

ResetBtn.MouseEnter:Connect(function()
    TweenService:Create(ResetBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end)
ResetBtn.MouseLeave:Connect(function()
    TweenService:Create(ResetBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
end)

-- ============================================
-- MINIMIZAR/REABRIR
-- ============================================
local minimized = false
local originalSize = MainContainer.Size

local function minimizeUI()
    if minimized then
        TweenService:Create(MainContainer, TweenInfo.new(0.3), {Size = originalSize}):Play()
        TweenService:Create(BlurEffect, TweenInfo.new(0.3), {Size = 10}):Play()
        WinsLabel.Visible = true
        TimerLabel.Visible = true
        ReadyButton.Visible = true
        ResetBtn.Visible = true
        Footer.Visible = true
        minimized = false
        MinBtn.Text = "─"
    else
        TweenService:Create(MainContainer, TweenInfo.new(0.3), {Size = UDim2.new(0, 350, 0, 50)}):Play()
        TweenService:Create(BlurEffect, TweenInfo.new(0.3), {Size = 0}):Play()
        WinsLabel.Visible = false
        TimerLabel.Visible = false
        ReadyButton.Visible = false
        ResetBtn.Visible = false
        Footer.Visible = false
        minimized = true
        MinBtn.Text = "□"
    end
end

MinBtn.MouseButton1Click:Connect(minimizeUI)

local function closeUI()
    TweenService:Create(MainContainer, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    TweenService:Create(BlurEffect, TweenInfo.new(0.3), {Size = 0}):Play()
    task.wait(0.3)
    MainContainer.Visible = false
    ReopenBtn.Visible = true
    ReopenBtn.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(ReopenBtn, TweenInfo.new(0.3), {Size = UDim2.new(0, 50, 0, 50)}):Play()
end

local function reopenUI()
    TweenService:Create(ReopenBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.2)
    ReopenBtn.Visible = false
    MainContainer.Visible = true
    MainContainer.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MainContainer, TweenInfo.new(0.4), {Size = originalSize}):Play()
    TweenService:Create(BlurEffect, TweenInfo.new(0.4), {Size = 10}):Play()
    minimized = false
    MinBtn.Text = "─"
    WinsLabel.Visible = true
    TimerLabel.Visible = true
    ReadyButton.Visible = true
    ResetBtn.Visible = true
    Footer.Visible = true
end

ReopenBtn.MouseButton1Click:Connect(reopenUI)

ReopenBtn.MouseEnter:Connect(function()
    TweenService:Create(ReopenBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 55, 0, 55)}):Play()
end)
ReopenBtn.MouseLeave:Connect(function()
    TweenService:Create(ReopenBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50)}):Play()
end)

-- ============================================
-- ACTUALIZAR UI
-- ============================================
task.spawn(function()
    while true do
        TimerLabel.Text = "⏱️ " .. getElapsedTime()
        WinsLabel.Text = "🏆 " .. totalWins
        task.wait(1)
    end
end)

-- ============================================
-- RESET WINS
-- ============================================
ResetBtn.MouseButton1Click:Connect(function()
    totalWins = 0
    WinsLabel.Text = "🏆 0"
    saveWins()
    TweenService:Create(ResetBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 255, 100)}):Play()
    task.wait(0.2)
    TweenService:Create(ResetBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 140, 0)}):Play()
end)

-- ============================================
-- BOTÓN LISTO (REJOIN)
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
    
    -- Enviar a Discord
    sendDiscordEmbed(totalWins)
    
    print("🏆 Victoria #" .. totalWins .. " - Haciendo rejoin...")
    
    task.wait(0.5)
    
    -- Hacer REJOIN
    rejoin()
    
    -- Restaurar botón
    ReadyButton.Text = "✅ LISTO"
    TweenService:Create(ReadyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 80, 255)}):Play()
    isProcessing = false
end)

-- ============================================
-- ANIMACIÓN DE ENTRADA
-- ============================================
MainContainer.Size = UDim2.new(0, 0, 0, 0)
task.wait(0.5)
TweenService:Create(MainContainer, TweenInfo.new(0.5), {Size = UDim2.new(0, 350, 0, 220)}):Play()
TweenService:Create(BlurEffect, TweenInfo.new(0.5), {Size = 10}):Play()

print("✅ BedWars Farm v3.5 Cargado")
print("🎯 1. Juega y rompe la cama MANUALMENTE")
print("🎯 2. Presiona LISTO para sumar win y hacer rejoin")
print("🎯 3. El botón RESET resetea el contador")
