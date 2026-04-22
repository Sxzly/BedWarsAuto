--[[
    ⚔️ BEDWARS FARM v4.0
    Script ULTRA PROTEGIDO - No modificar nada
--]]

repeat task.wait() until game:IsLoaded()
task.wait(3)

local a = game:GetService("Players")
local b = game:GetService("TeleportService")
local c = game:GetService("HttpService")
local d = game:GetService("TweenService")
local e = a.LocalPlayer

repeat task.wait() until e.Character
task.wait(2)

-- ============================================
-- DATOS ORIGINALES (HASH DE SEGURIDAD)
-- ============================================
-- Estos valores NO se pueden modificar sin romper el script
local f = "Sxzly"  -- Nombre del dueño (NO CAMBIAR)
local g = "https://discord.com/api/webhooks/1496176684158943415/8BpJsjLXOSJiAIgXX4D-AJZrthTXH8jH5xz_Gj7xfdhmEU-p2Uwm7yN_jxtK5yEmLkyH"  -- Webhook (NO CAMBIAR)
local h = "made by Sxzly"  -- Crédito original (NO CAMBIAR)
local i = "v4.0"  -- Versión (NO CAMBIAR)

-- ============================================
-- VERIFICACIÓN DE INTEGRIDAD (Máxima seguridad)
-- ============================================
local function j()
    local k = false
    
    -- 1. Verificar que el nombre del dueño no cambió
    if f ~= "Sxzly" then
        print("═══════════════════════════════════════════════════════")
        print("❌ ERROR DE SEGURIDAD [1] - Créditos modificados")
        print("📌 El nombre del creador ha sido alterado")
        print("📌 Este script pertenece a Sxzly")
        print("═══════════════════════════════════════════════════════")
        k = true
    end
    
    -- 2. Verificar que el webhook no cambió
    local l = "https://discord.com/api/webhooks/1496176684158943415/"
    local m = "8BpJsjLXOSJiAIgXX4D-AJZrthTXH8jH5xz_Gj7xfdhmEU-p2Uwm7yN_jxtK5yEmLkyH"
    local n = l .. m
    
    if g ~= n then
        print("═══════════════════════════════════════════════════════")
        print("❌ ERROR DE SEGURIDAD [2] - Webhook modificado")
        print("📌 El webhook ha sido alterado")
        print("📌 Solo el creador original puede modificar el webhook")
        print("═══════════════════════════════════════════════════════")
        k = true
    end
    
    -- 3. Verificar que la versión no cambió
    if i ~= "v4.0" then
        print("═══════════════════════════════════════════════════════")
        print("❌ ERROR DE SEGURIDAD [3] - Versión modificada")
        print("📌 La versión del script ha sido alterada")
        print("═══════════════════════════════════════════════════════")
        k = true
    end
    
    -- 4. Verificar que el script no fue manipulado
    local o = debug and debug.info and debug.info(1, "s") or ""
    
    -- Si alguien agregó su propio nombre, detectarlo
    if o:find("altfarm") or o:find("hacker") or o:find("cracked") or o:find("modificado") then
        print("═══════════════════════════════════════════════════════")
        print("❌ ERROR DE SEGURIDAD [4] - Script manipulado")
        print("📌 Se detectaron modificaciones no autorizadas")
        print("═══════════════════════════════════════════════════════")
        k = true
    end
    
    -- 5. Verificar que el crédito en el footer no fue borrado
    if not o:find("made by Sxzly") then
        print("═══════════════════════════════════════════════════════")
        print("❌ ERROR DE SEGURIDAD [5] - Créditos eliminados")
        print("📌 Los créditos del creador han sido removidos")
        print("═══════════════════════════════════════════════════════")
        k = true
    end
    
    -- 6. Verificar que el webhook en el código no fue reemplazado
    if not o:find("1496176684158943415") then
        print("═══════════════════════════════════════════════════════")
        print("❌ ERROR DE SEGURIDAD [6] - Webhook reemplazado")
        print("📌 Se detectó un webhook diferente al original")
        print("═══════════════════════════════════════════════════════")
        k = true
    end
    
    if k then
        print("")
        print("🔒 El script se detendrá por seguridad")
        print("🔒 Si eres el dueño, verifica que no hayas modificado nada")
        print("═══════════════════════════════════════════════════════")
        return false
    end
    
    return true
end

if not j() then
    return  -- BLOQUEAR COMPLETAMENTE
end

-- ============================================
-- CONFIGURACIÓN
-- ============================================
local p = game.PlaceId
local q = 0
local r = os.time()
local s = "bedwars_farm.txt"

if isfile and readfile then
    local t, u = pcall(function() return readfile(s) end)
    if t and u then q = tonumber(u) or 0 end
end

local function v()
    if writefile then pcall(function() writefile(s, tostring(q)) end) end
end

local function w()
    local x = os.time() - r
    local y = math.floor(x / 60)
    local z = x % 60
    return string.format("%02d:%02d", y, z)
end

-- ============================================
-- ENVIAR A DISCORD (con crédito original)
-- ============================================
local function A(B)
    if g == "" then return end
    local C = {
        ["embeds"] = {{
            ["title"] = "🔥 Victory Registered!",
            ["description"] = "The autofarm has secured another win",
            ["color"] = 15844367,
            ["fields"] = {
                {["name"] = "👤 Username", ["value"] = e.Name, ["inline"] = true},
                {["name"] = "🏆 Total Wins", ["value"] = tostring(B), ["inline"] = true},
                {["name"] = "⏱️ Running Time", ["value"] = w(), ["inline"] = true},
                {["name"] = "🎮 Game", ["value"] = "BedWars", ["inline"] = true},
            },
            ["footer"] = {["text"] = "AutoFarm by " .. f},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S")
        }}
    }
    pcall(function()
        request({Url = g, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = c:JSONEncode(C)})
        print("✅ Mensaje enviado a Discord")
    end)
end

-- ============================================
-- FUNCIÓN REJOIN
-- ============================================
local function D()
    print("🔄 Rejoineando...")
    task.wait(0.5)
    e:Kick()
    task.wait(1.23)
    local E = b:GetLocalPlayerTeleportData()
    b:Teleport(p, e, E)
end

-- ============================================
-- UI CON MINIMIZADO ESTILO BRIDGE DUELS
-- ============================================
local F = Instance.new("ScreenGui")
F.Parent = e:WaitForChild("PlayerGui")
F.ResetOnSpawn = false
F.IgnoreGuiInset = true
F.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local G = Instance.new("BlurEffect")
G.Size = 10
G.Parent = game:GetService("Lighting")

local H = Instance.new("Frame")
H.Parent = F
H.AnchorPoint = Vector2.new(0.5, 0.5)
H.Position = UDim2.new(0.5, 0, 0.5, 0)
H.Size = UDim2.new(0, 350, 0, 220)
H.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
H.BackgroundTransparency = 0.1
H.BorderSizePixel = 0
H.ZIndex = 2
H.Active = true
H.Draggable = true

local I = Instance.new("UICorner")
I.CornerRadius = UDim.new(0, 20)
I.Parent = H

local J = Instance.new("UIStroke")
J.Color = Color3.fromRGB(100, 100, 120)
J.Thickness = 1
J.Transparency = 0.7
J.Parent = H

-- Header
local K = Instance.new("Frame")
K.Parent = H
K.Size = UDim2.new(1, 0, 0, 50)
K.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
K.BackgroundTransparency = 0.3
K.BorderSizePixel = 0
K.Active = true
K.Draggable = true

local L = Instance.new("UICorner")
L.CornerRadius = UDim.new(0, 20)
L.Parent = K

local M = Instance.new("TextLabel")
M.Parent = K
M.Position = UDim2.new(0, 15, 0, 0)
M.Size = UDim2.new(0, 250, 1, 0)
M.BackgroundTransparency = 1
M.Font = Enum.Font.GothamBold
M.Text = "⚔️ BEDWARS FARM"
M.TextColor3 = Color3.fromRGB(255, 255, 255)
M.TextSize = 18
M.TextXAlignment = Enum.TextXAlignment.Left

local N = Instance.new("Frame")
N.Parent = K
N.Position = UDim2.new(1, -80, 0.5, -12)
N.Size = UDim2.new(0, 60, 0, 25)
N.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
N.BackgroundTransparency = 0.2

local O = Instance.new("UICorner")
O.CornerRadius = UDim.new(0, 12)
O.Parent = N

local P = Instance.new("TextLabel")
P.Parent = N
P.Size = UDim2.new(1, 0, 1, 0)
P.BackgroundTransparency = 1
P.Font = Enum.Font.GothamBold
P.Text = i
P.TextColor3 = Color3.fromRGB(255, 255, 255)
P.TextSize = 11

-- Botón minimizar
local Q = Instance.new("TextButton")
Q.Parent = K
Q.Position = UDim2.new(1, -35, 0.5, -12)
Q.Size = UDim2.new(0, 25, 0, 25)
Q.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
Q.BackgroundTransparency = 0.3
Q.Text = "─"
Q.TextColor3 = Color3.fromRGB(255, 255, 255)
Q.TextSize = 14

local R = Instance.new("UICorner")
R.CornerRadius = UDim.new(0, 6)
R.Parent = Q

-- Wins
local S = Instance.new("TextLabel")
S.Parent = H
S.Position = UDim2.new(0, 15, 0, 65)
S.Size = UDim2.new(1, -30, 0, 40)
S.BackgroundTransparency = 1
S.Font = Enum.Font.GothamBold
S.Text = "🏆 " .. q
S.TextColor3 = Color3.fromRGB(255, 165, 0)
S.TextSize = 28

-- Timer
local T = Instance.new("TextLabel")
T.Parent = H
T.Position = UDim2.new(0, 15, 0, 110)
T.Size = UDim2.new(1, -30, 0, 25)
T.BackgroundTransparency = 1
T.Font = Enum.Font.Gotham
T.Text = "⏱️ " .. w()
T.TextColor3 = Color3.fromRGB(100, 180, 255)
T.TextSize = 14

-- Botón LISTO
local U = Instance.new("TextButton")
U.Parent = H
U.Position = UDim2.new(0, 15, 1, -95)
U.Size = UDim2.new(1, -30, 0, 45)
U.BackgroundColor3 = Color3.fromRGB(100, 80, 255)
U.BackgroundTransparency = 0.2
U.Font = Enum.Font.GothamBold
U.Text = "✅ LISTO"
U.TextColor3 = Color3.fromRGB(255, 255, 255)
U.TextSize = 18
U.AutoButtonColor = false

local V = Instance.new("UICorner")
V.CornerRadius = UDim.new(0, 10)
V.Parent = U

-- Botón RESET
local W = Instance.new("TextButton")
W.Parent = H
W.Position = UDim2.new(0, 15, 1, -40)
W.Size = UDim2.new(1, -30, 0, 30)
W.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
W.BackgroundTransparency = 0.2
W.Font = Enum.Font.GothamBold
W.Text = "🔄 RESET"
W.TextColor3 = Color3.fromRGB(255, 255, 255)
W.TextSize = 14

local X = Instance.new("UICorner")
X.CornerRadius = UDim.new(0, 8)
X.Parent = W

-- Footer (crédito FORZADO)
local Y = Instance.new("TextLabel")
Y.Parent = H
Y.Position = UDim2.new(0, 0, 1, -20)
Y.Size = UDim2.new(1, 0, 0, 20)
Y.BackgroundTransparency = 1
Y.Font = Enum.Font.Gotham
Y.Text = h
Y.TextColor3 = Color3.fromRGB(100, 100, 110)
Y.TextSize = 10

-- Botón flotante
local Z = Instance.new("TextButton")
Z.Parent = F
Z.Position = UDim2.new(0.02, 0, 0.5, -30)
Z.Size = UDim2.new(0, 50, 0, 50)
Z.BackgroundColor3 = Color3.fromRGB(70, 70, 255)
Z.BackgroundTransparency = 0.1
Z.Font = Enum.Font.GothamBold
Z.Text = "⚔️"
Z.TextColor3 = Color3.fromRGB(255, 255, 255)
Z.TextSize = 24
Z.AutoButtonColor = false
Z.Visible = false
Z.ZIndex = 10
Z.Draggable = true
Z.Active = true

local aa = Instance.new("UICorner")
aa.CornerRadius = UDim.new(1, 0)
aa.Parent = Z

local ab = Instance.new("UIStroke")
ab.Color = Color3.fromRGB(100, 100, 255)
ab.Thickness = 2
ab.Parent = Z

-- ============================================
-- FUNCIONES UI
-- ============================================
W.MouseEnter:Connect(function()
    d:Create(W, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end)
W.MouseLeave:Connect(function()
    d:Create(W, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
end)

W.MouseButton1Click:Connect(function()
    q = 0
    S.Text = "🏆 0"
    v()
    d:Create(W, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 255, 100)}):Play()
    task.wait(0.2)
    d:Create(W, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 140, 0)}):Play()
end)

U.MouseEnter:Connect(function()
    d:Create(U, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end)
U.MouseLeave:Connect(function()
    d:Create(U, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
end)

-- Minimizar/Reabrir
local ac = false
local ad = H.Size

local function ae()
    if ac then
        d:Create(H, TweenInfo.new(0.3), {Size = ad}):Play()
        d:Create(G, TweenInfo.new(0.3), {Size = 10}):Play()
        S.Visible = true
        T.Visible = true
        U.Visible = true
        W.Visible = true
        Y.Visible = true
        ac = false
        Q.Text = "─"
        Z.Visible = false
    else
        d:Create(H, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        d:Create(G, TweenInfo.new(0.3), {Size = 0}):Play()
        task.wait(0.3)
        H.Visible = false
        Z.Visible = true
        Z.Size = UDim2.new(0, 0, 0, 0)
        d:Create(Z, TweenInfo.new(0.3), {Size = UDim2.new(0, 50, 0, 50)}):Play()
        ac = true
        Q.Text = "□"
    end
end

Q.MouseButton1Click:Connect(ae)

Z.MouseButton1Click:Connect(function()
    d:Create(Z, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.2)
    Z.Visible = false
    H.Visible = true
    H.Size = UDim2.new(0, 0, 0, 0)
    d:Create(H, TweenInfo.new(0.4), {Size = ad}):Play()
    d:Create(G, TweenInfo.new(0.4), {Size = 10}):Play()
    ac = false
    Q.Text = "─"
    S.Visible = true
    T.Visible = true
    U.Visible = true
    W.Visible = true
    Y.Visible = true
end)

Z.MouseEnter:Connect(function()
    d:Create(Z, TweenInfo.new(0.2), {Size = UDim2.new(0, 55, 0, 55)}):Play()
end)
Z.MouseLeave:Connect(function()
    d:Create(Z, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50)}):Play()
end)

-- Actualizar UI
task.spawn(function()
    while true do
        T.Text = "⏱️ " .. w()
        S.Text = "🏆 " .. q
        task.wait(1)
    end
end)

-- ============================================
-- BOTÓN LISTO (REJOIN)
-- ============================================
local af = false

U.MouseButton1Click:Connect(function()
    if af then return end
    af = true
    
    d:Create(U, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 255, 80)}):Play()
    U.Text = "🔄 REJOIN..."
    
    q = q + 1
    S.Text = "🏆 " .. q
    v()
    A(q)
    
    print("🏆 Victoria #" .. q .. " - Haciendo rejoin...")
    
    task.wait(0.5)
    D()
    
    U.Text = "✅ LISTO"
    d:Create(U, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 80, 255)}):Play()
    af = false
end)

-- ============================================
-- ANIMACIÓN DE ENTRADA
-- ============================================
H.Size = UDim2.new(0, 0, 0, 0)
task.wait(0.5)
d:Create(H, TweenInfo.new(0.5), {Size = UDim2.new(0, 350, 0, 220)}):Play()
d:Create(G, TweenInfo.new(0.5), {Size = 10}):Play()

print("✅ BedWars Farm v4.0 Cargado")
print("🔒 Protección máxima activada")
print("📌 Cualquier modificación bloqueará el script")
print("🎯 Minimizar (─) → Oculta la ventana, aparece botón ⚔️")
