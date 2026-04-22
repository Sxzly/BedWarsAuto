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
local GAME_PLACE_ID = game.PlaceId
local webhookURL = "https://discord.com/api/webhooks/1496176684158943415/8BpJsjLXOSJiAIgXX4D-AJZrthTXH8jH5xz_Gj7xfdhmEU-p2Uwm7yN_jxtK5yEmLkyH"

local totalWins = 0
local startTime = os.time()
local saveFileName = "bedwars_farm.txt"

-- ============================================
-- VARIABLES (MODO GUARDADO)
-- ============================================
local savedGameMode = nil      -- Modo guardado (ej: "👥 DUOS 2v2")
local savedTotalPlayers = 0    -- Jugadores totales del modo guardado
local savedEnemies = 0         -- Enemigos del modo guardado
local savedTeams = ""          -- Equipos del modo guardado
local modeLocked = false       -- Si ya se guardó el modo (solo se guarda UNA vez)
local isProcessing = false

-- ============================================
-- DETECTOR DE MODO ACTUAL (EN VIVO)
-- ============================================
local function detectCurrentMode()
    local teams = {}
    local playersByTeam = {}
    local myTeam = player.Team
    
    -- Recopilar todos los equipos y sus jugadores
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer.Team then
            local teamName = otherPlayer.Team.Name
            teams[teamName] = true
            playersByTeam[teamName] = (playersByTeam[teamName] or 0) + 1
        end
    end
    
    local teamList = {}
    for teamName in pairs(teams) do
        table.insert(teamList, teamName)
    end
    
    local numTeams = #teamList
    local playersPerTeam = {}
    for teamName, count in pairs(playersByTeam) do
        table.insert(playersPerTeam, {team = teamName, count = count})
    end
    
    table.sort(playersPerTeam, function(a, b) return a.count > b.count end)
    
    local maxPlayersPerTeam = playersPerTeam[1] and playersPerTeam[1].count or 0
    local totalRealPlayers = 0
    for _, p in pairs(playersPerTeam) do
        totalRealPlayers = totalRealPlayers + p.count
    end
    local enemies = totalRealPlayers - (playersByTeam[myTeam and myTeam.Name or ""] or 0)
    
    -- Construir string de equipos
    local teamsStr = ""
    for _, p in pairs(playersPerTeam) do
        teamsStr = teamsStr .. p.team .. ":" .. p.count .. " "
    end
    
    -- Detectar por número de equipos
    local mode = "Desconocido"
    local modeIcon = "❓"
    
    if numTeams == 2 then
        if maxPlayersPerTeam == 1 then
            mode = "DUELO 1v1"
            modeIcon = "⚔️"
        elseif maxPlayersPerTeam == 2 then
            mode = "DUOS 2v2"
            modeIcon = "👥"
        elseif maxPlayersPerTeam == 3 then
            mode = "TRIOS 3v3"
            modeIcon = "👥"
        elseif maxPlayersPerTeam == 4 then
            mode = "CUADRAS 4v4"
            modeIcon = "👥"
        elseif maxPlayersPerTeam == 5 then
            mode = "5v5"
            modeIcon = "👥"
        elseif maxPlayersPerTeam == 8 then
            mode = "8v8"
            modeIcon = "👥"
        elseif maxPlayersPerTeam == 16 then
            mode = "16v16"
            modeIcon = "👥"
        else
            mode = maxPlayersPerTeam .. "v" .. maxPlayersPerTeam
            modeIcon = "👥"
        end
    elseif numTeams == 3 then
        if maxPlayersPerTeam == 2 then
            mode = "2v2v2"
            modeIcon = "🔥"
        elseif maxPlayersPerTeam == 3 then
            mode = "3v3v3"
            modeIcon = "🔥"
        elseif maxPlayersPerTeam == 4 then
            mode = "4v4v4"
            modeIcon = "🔥"
        else
            mode = maxPlayersPerTeam .. "v" .. maxPlayersPerTeam .. "v" .. maxPlayersPerTeam
            modeIcon = "🔥"
        end
    elseif numTeams == 4 then
        if maxPlayersPerTeam == 2 then
            mode = "2v2v2v2"
            modeIcon = "💀"
        elseif maxPlayersPerTeam == 3 then
            mode = "3v3v3v3"
            modeIcon = "💀"
        else
            mode = maxPlayersPerTeam .. "v" .. maxPlayersPerTeam .. "v" .. maxPlayersPerTeam .. "v" .. maxPlayersPerTeam
            modeIcon = "💀"
        end
    elseif numTeams >= 5 then
        mode = "FFA " .. numTeams .. " equipos"
        modeIcon = "⚡"
    end
    
    return modeIcon .. " " .. mode, totalRealPlayers, enemies, teamsStr
end

-- ============================================
-- FUNCIONES AUXILIARES
-- ============================================
local function getElapsedTime()
    local elapsed = os.time() - startTime
    local hours = math.floor(elapsed / 3600)
    local minutes = math.floor((elapsed % 3600) / 60)
    local seconds = elapsed % 60
    
    if hours > 0 then
        return string.format("%dh %dm %ds", hours, minutes, seconds)
    elseif minutes > 0 then
        return string.format("%dm %ds", minutes, seconds)
    else
        return string.format("%ds", seconds)
    end
end

if isfile and readfile then
    local success, savedWins = pcall(function() return readfile(saveFileName) end)
    if success and savedWins then totalWins = tonumber(savedWins) or 0 end
end

local function saveWins()
    if writefile then pcall(function() writefile(saveFileName, tostring(totalWins)) end) end
end

local function sendDiscordEmbed(wins, gameMode, totalPlayers, enemies, teams)
    if webhookURL == "" then return end
    
    local placeStatus = (game.PlaceId == 6872265039) and "Lobby" or "In-Game"
    local color = 0xFFD700
    if gameMode:find("DUELO") then color = 0x00FF00
    elseif gameMode:find("DUOS") then color = 0x00AAFF
    elseif gameMode:find("TRIOS") then color = 0xFFAA00
    elseif gameMode:find("CUADRAS") then color = 0xFF5500
    elseif gameMode:find("v2v2v") then color = 0xFF00FF end
    
    local embed = {
        ["embeds"] = {{
            ["title"] = "🔥 Victory Registered!",
            ["description"] = "The autofarm has secured another win",
            ["color"] = color,
            ["fields"] = {
                {["name"] = "👤 Username", ["value"] = player.Name, ["inline"] = true},
                {["name"] = "🏆 Total Wins", ["value"] = tostring(wins), ["inline"] = true},
                {["name"] = "⏱️ Running Time", ["value"] = getElapsedTime(), ["inline"] = true},
                {["name"] = "🎮 Game Mode", ["value"] = gameMode, ["inline"] = true},
                {["name"] = "👥 Total Players", ["value"] = tostring(totalPlayers), ["inline"] = true},
                {["name"] = "⚔️ Enemies", ["value"] = tostring(enemies), ["inline"] = true},
                {["name"] = "📊 Teams", ["value"] = teams, ["inline"] = false},
                {["name"] = "📍 Place Status", ["value"] = placeStatus, ["inline"] = true},
                {["name"] = "🎮 Game", ["value"] = "BedWars", ["inline"] = true},
            },
            ["footer"] = {["text"] = "AutoFarm by Sxzly | Modo bloqueado"},
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
-- UI SIMPLE
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
MainContainer.Size = UDim2.new(0, 350, 0, 250)
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
VersionText.Text = "v3.6"
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

-- Stats
local WinsLabel = Instance.new("TextLabel")
WinsLabel.Parent = MainContainer
WinsLabel.Position = UDim2.new(0, 15, 0, 65)
WinsLabel.Size = UDim2.new(1, -30, 0, 40)
WinsLabel.BackgroundTransparency = 1
WinsLabel.Font = Enum.Font.GothamBold
WinsLabel.Text = "🏆 " .. totalWins
WinsLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
WinsLabel.TextSize = 28

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

local Footer = Instance.new("TextLabel")
Footer.Parent = MainContainer
Footer.Position = UDim2.new(0, 0, 1, -20)
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.BackgroundTransparency = 1
Footer.Font = Enum.Font.Gotham
Footer.Text = "made by Sxzly"
Footer.TextColor3 = Color3.fromRGB(100, 100, 110)
Footer.TextSize = 10

-- Botón flotante
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

-- Hover effects
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

-- Minimizar/Reabrir
local minimized = false
local originalSize = MainContainer.Size

local function minimizeUI()
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
end

MinBtn.MouseButton1Click:Connect(minimizeUI)
ReopenBtn.MouseButton1Click:Connect(reopenUI)

ReopenBtn.MouseEnter:Connect(function()
    TweenService:Create(ReopenBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 55, 0, 55)}):Play()
end)
ReopenBtn.MouseLeave:Connect(function()
    TweenService:Create(ReopenBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50)}):Play()
end)

-- Actualizar UI (solo wins y tiempo)
task.spawn(function()
    while true do
        TimerLabel.Text = "⏱️ " .. getElapsedTime()
        WinsLabel.Text = "🏆 " .. totalWins
        
        -- Mostrar modo bloqueado en la UI (opcional, para que el usuario sepa)
        if modeLocked and savedGameMode then
            -- Esto es opcional, si no quieres que se vea, comenta estas líneas
            -- Footer.Text = "made by Sxzly | Modo: " .. savedGameMode
        end
        
        task.wait(1)
    end
end)

-- Reset wins (NO resetea el modo guardado)
ResetBtn.MouseButton1Click:Connect(function()
    totalWins = 0
    WinsLabel.Text = "🏆 0"
    saveWins()
    TweenService:Create(ResetBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 255, 100)}):Play()
    task.wait(0.2)
    TweenService:Create(ResetBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 140, 0)}):Play()
end)

-- ============================================
-- BOTÓN LISTO: SOLO LA PRIMERA VEZ GUARDA EL MODO
-- ============================================
ReadyButton.MouseButton1Click:Connect(function()
    if isProcessing then return end
    isProcessing = true
    
    -- ============================================
    -- PRIMERA VEZ: Guardar el modo
    -- ============================================
    if not modeLocked then
        -- Detectar el modo actual
        local gameMode, totalPlayers, enemies, teams = detectCurrentMode()
        
        if gameMode and totalPlayers >= 2 then
            -- Guardar el modo
            savedGameMode = gameMode
            savedTotalPlayers = totalPlayers
            savedEnemies = enemies
            savedTeams = teams
            modeLocked = true
            
            print("🎮 MODO GUARDADO (PRIMERA VEZ):", savedGameMode)
            print("   📊 Todas las partidas siguientes usarán este modo")
        else
            -- No se pudo detectar el modo
            print("⚠️ No se detectó modo. Asegúrate de estar en una partida")
            TweenService:Create(ReadyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
            task.wait(1)
            TweenService:Create(ReadyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 80, 255)}):Play()
            isProcessing = false
            return
        end
    end
    
    -- ============================================
    -- Usar el modo guardado (siempre el mismo después de la primera vez)
    -- ============================================
    local gameMode = savedGameMode or "Modo Desconocido"
    local totalPlayers = savedTotalPlayers or 2
    local enemies = savedEnemies or 1
    local teams = savedTeams or "No detectado"
    
    -- Animar botón
    TweenService:Create(ReadyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 255, 80)}):Play()
    ReadyButton.Text = "🔄 REJOIN..."
    
    -- Sumar victoria
    totalWins = totalWins + 1
    WinsLabel.Text = "🏆 " .. totalWins
    saveWins()
    
    -- Enviar a Discord
    sendDiscordEmbed(totalWins, gameMode, totalPlayers, enemies, teams)
    
    print("🏆 Victoria #" .. totalWins .. " - Modo: " .. gameMode .. " (usando modo guardado)")
    
    -- Pequeña pausa
    task.wait(0.5)
    
    -- Hacer REJOIN
    rejoin()
    
    -- Restaurar botón
    ReadyButton.Text = "✅ LISTO"
    TweenService:Create(ReadyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 80, 255)}):Play()
    isProcessing = false
end)

-- Animación de entrada
MainContainer.Size = UDim2.new(0, 0, 0, 0)
task.wait(0.5)
TweenService:Create(MainContainer, TweenInfo.new(0.5), {Size = UDim2.new(0, 350, 0, 250)}):Play()
TweenService:Create(BlurEffect, TweenInfo.new(0.5), {Size = 10}):Play()

print("✅ BedWars Farm v3.6 - Modo se guarda SOLO la primera vez")
print("🎯 1. Entra al modo que quieras (2v2, 3v3, etc.)")
print("🎯 2. Presiona LISTO por PRIMERA VEZ → Guarda el modo")
print("🎯 3. Todas las siguientes veces que presiones LISTO, usará el MISMO modo")
print("🎯 4. El modo NO cambia hasta que reinicies el script")
