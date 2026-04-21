repeat task.wait() until game:IsLoaded()
task.wait(3)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

repeat task.wait() until player.Character
task.wait(2)

local webhookURL = "https://discord.com/api/webhooks/1496176684158943415/8BpJsjLXOSJiAIgXX4D-AJZrthTXH8jH5xz_Gj7xfdhmEU-p2Uwm7yN_jxtK5yEmLkyH"
local GAME_PLACE_ID = 8560631822
local currentPlaceId = game.PlaceId

local totalWins = 0
local saveFileName = "bedwars_wins.txt"

if isfile and readfile then
    local success, savedWins = pcall(function() return readfile(saveFileName) end)
    if success and savedWins then totalWins = tonumber(savedWins) or 0 end
end

local function saveWins()
    if writefile then pcall(function() writefile(saveFileName, tostring(totalWins)) end) end
end

local function breakEnemyBed()
    local myTeam = player.Team
    if not myTeam then return false end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("bed") or v.Name:lower():find("cama")) then
            local isEnemyBed = true
            if v.Parent and v.Parent.Name:lower():find(myTeam.Name:lower()) then isEnemyBed = false end
            if isEnemyBed then
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.3)
                    firetouchinterest(hrp, v, 1)
                    task.wait(0.1)
                    firetouchinterest(hrp, v, 0)
                    return true
                end
            end
        end
    end
    return false
end

local function hasEnemies()
    local myTeam = player.Team
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            if myTeam then
                if otherPlayer.Team and otherPlayer.Team ~= myTeam then
                    local char = otherPlayer.Character
                    if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then return true end
                end
            else
                local char = otherPlayer.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then return true end
            end
        end
    end
    return false
end

local function rejoinGame()
    task.wait(1)
    local teleportData = TeleportService:GetLocalPlayerTeleportData()
    TeleportService:Teleport(GAME_PLACE_ID, player, teleportData)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.1

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "⚔️ BEDWARS AUTO"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

local WinsText = Instance.new("TextLabel")
WinsText.Parent = MainFrame
WinsText.Position = UDim2.new(0, 0, 0, 45)
WinsText.Size = UDim2.new(1, 0, 0, 30)
WinsText.BackgroundTransparency = 1
WinsText.Font = Enum.Font.GothamBold
WinsText.Text = "🏆 VICTORIAS: " .. totalWins
WinsText.TextColor3 = Color3.fromRGB(255, 165, 0)
WinsText.TextSize = 16

local StatusText = Instance.new("TextLabel")
StatusText.Parent = MainFrame
StatusText.Position = UDim2.new(0, 0, 0, 80)
StatusText.Size = UDim2.new(1, 0, 0, 25)
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.Gotham
StatusText.Text = "🟢 Buscando cama..."
StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusText.TextSize = 12

if currentPlaceId == GAME_PLACE_ID then
    print("✅ BedWars AutoFarm Iniciado")
    local gameEnded = false
    
    while true do
        StatusText.Text = "🛏️ Buscando cama enemiga..."
        local bedBroken = breakEnemyBed()
        if bedBroken then
            print("✅ Cama rota!")
            StatusText.Text = "✅ Cama rota!"
        end
        task.wait(2)
        
        if not hasEnemies() and not gameEnded then
            gameEnded = true
            totalWins = totalWins + 1
            WinsText.Text = "🏆 VICTORIAS: " .. totalWins
            StatusText.Text = "🎉 VICTORIA! Rejoineando..."
            print("🎉 Victoria #" .. totalWins)
            saveWins()
            task.wait(2)
            rejoinGame()
            task.wait(5)
            gameEnded = false
        end
        task.wait(3)
    end
else
    print("⏸️ Ejecuta esto DENTRO de una partida de BedWars")
end
