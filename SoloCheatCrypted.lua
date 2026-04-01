-- [[ SOLOCHEAT V10 - EDITION INFINITY ]] --
-- [[ TOTAL FUSION | NO DELETIONS | NEO-UI ]] --

repeat task.wait() until game:IsLoaded()

-- [[ SERVICES & VARIABLES ]] --
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION INTÉGRALE (RIEN D'OUBLIÉ) ]] --
local Config = {
    -- Authentification
    FileName = "SoloV10_Auth.txt",
    CorrectKey = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
    Discord = "https://discord.gg/VDNw9dXnJe",
    
    -- Combat (Silent + Trigger)
    Silent = true,
    Prediction = 0.158,
    Trigger = false,
    TriggerDelay = 0.02,
    FOV = 180,
    ShowFOV = true,
    TargetPart = "Head",
    TeamCheck = true,
    
    -- Movement (Fly + NoClip + TP)
    Fly = false,
    FlySpeed = 2,
    NoClip = false,
    TP_Key = Enum.KeyCode.E,
    
    -- Visuals (ESP)
    ESP_Enabled = true,
    ESP_Box = false,
    
    -- Device Spoofer
    Device = "PC", -- "PC", "Mobile", "Console", "VR"
    
    -- Menu
    MenuKey = Enum.KeyCode.K,
    Accent = Color3.fromRGB(0, 255, 200),
    Bg = Color3.fromRGB(12, 12, 14)
}

-- [[ 1. SILENT AIM METATABLE (FONCTIONNEL) ]] --
local function GetClosest()
    local target, dist = nil, Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.TargetPart) then
            if Config.TeamCheck and p.Team == LocalPlayer.Team then continue end
            local pos, vis = Camera:WorldToViewportPoint(p.Character[Config.TargetPart].Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                if mag < dist then dist = mag; target = p.Character[Config.TargetPart] end
            end
        end
    end
    return target
end

pcall(function()
    local mt = getrawmetatable(game)
    local old = mt.__index
    setreadonly(mt, false)
    mt.__index = newcclosure(function(self, idx)
        if not checkcaller() and Config.Silent and self == Mouse and (idx == "Hit" or idx == "Target") then
            local t = GetClosest()
            if t then return (idx == "Hit" and (t.CFrame + (t.Velocity * Config.Prediction)) or t.Parent) end
        end
        return old(self, idx)
    end)
    setreadonly(mt, true)
end)

-- [[ 2. DEVICE SPOOFER MODULE ]] --
local function ApplyDevice(target)
    Config.Device = target
    pcall(function()
        local mt = getrawmetatable(UIS)
        local old = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(self, idx)
            if idx == "TouchEnabled" then return Config.Device == "Mobile" end
            if idx == "GamepadEnabled" then return Config.Device == "Console" end
            if idx == "VREnabled" then return Config.Device == "VR" end
            return old(self, idx)
        end)
        setreadonly(mt, true)
    end)
end

-- [[ 3. INTERFACE NEO-ARRONDIE ]] --
local function InitCheat()
    if CoreGui:FindFirstChild("SoloV10") then CoreGui.SoloV10:Destroy() end
    local UI = Instance.new("ScreenGui", CoreGui); UI.Name = "SoloV10"
    
    local Main = Instance.new("Frame", UI)
    Main.Size = UDim2.new(0, 580, 0, 400); Main.Position = UDim2.new(0.5, -290, 0.5, -200); Main.BackgroundColor3 = Config.Bg
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20); Instance.new("UIStroke", Main).Color = Config.Accent

    -- Titre "SoloCheat" (TOUJOURS LÀ)
    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(0, 250, 0, 50); Title.Position = UDim2.new(0, 20, 0, 5)
    Title.Text = "SOLO<font color='#00FFC8'>CHEAT</font> V10"; Title.RichText = true; Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = "GothamBold"; Title.TextSize = 20; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0

    -- Croix de fermeture
    local Close = Instance.new("TextButton", Main)
    Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -40, 0, 10); Close.Text = "×"; Close.TextColor3 = Color3.new(1,0.2,0.2)
    Close.BackgroundTransparency = 1; Close.Font = "GothamBold"; Close.TextSize = 30
    Close.MouseButton1Click:Connect(function() UI:Destroy() end)

    -- Sidebar & Tabs
    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 140, 1, -60); Sidebar.Position = UDim2.new(0, 10, 0, 50); Sidebar.BackgroundTransparency = 1
    local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -170, 1, -70); Container.Position = UDim2.new(0, 160, 0, 60); Container.BackgroundTransparency = 1
    local List = Instance.new("UIListLayout", Sidebar); List.Padding = UDim.new(0, 5)

    local function NewTab(name)
        local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 35); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(20,20,25); b.TextColor3 = Color3.new(0.8,0.8,0.8); b.Font = "GothamBold"; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
        local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 0
        Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
        b.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do v.Visible = false end
            p.Visible = true
        end)
        return p
    end

    local function NewToggle(parent, txt, k)
        local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -5, 0, 40); f.BackgroundColor3 = Color3.fromRGB(25,25,30); Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, -50, 1, 0); l.Position = UDim2.new(0, 10, 0, 0); l.Text = txt; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.TextXAlignment = 0; l.Font = "Gotham"
        local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0, 35, 0, 18); btn.Position = UDim2.new(1, -45, 0.5, -9); btn.Text = ""; btn.BackgroundColor3 = Config[k] and Config.Accent or Color3.fromRGB(60,60,60); Instance.new("UICorner", btn, UDim.new(1,0))
        btn.MouseButton1Click:Connect(function() Config[k] = not Config[k]; btn.BackgroundColor3 = Config[k] and Config.Accent or Color3.fromRGB(60,60,60) end)
    end

    -- Tab Combat
    local T1 = NewTab("Combat")
    NewToggle(T1, "SILENT AIM", "Silent")
    NewToggle(T1, "TRIGGER BOT", "Trigger")
    NewToggle(T1, "TEAM CHECK", "TeamCheck")
    NewToggle(T1, "SHOW FOV", "ShowFOV")

    -- Tab Movement
    local T2 = NewTab("Movement")
    NewToggle(T2, "FLY HACK (W)", "Fly")
    NewToggle(T2, "NOCLIP", "NoClip")
    local tpLabel = Instance.new("TextLabel", T2); tpLabel.Size = UDim2.new(1,0,0,30); tpLabel.Text = "TP Key: [E]"; tpLabel.TextColor3 = Config.Accent; tpLabel.BackgroundTransparency = 1; tpLabel.Font = "GothamBold"

    -- Tab Settings (Spoofer + Discord)
    local T3 = NewTab("Settings")
    for _, d in pairs({"PC", "Mobile", "Console", "VR"}) do
        local db = Instance.new("TextButton", T3); db.Size = UDim2.new(1,-5,0,35); db.Text = "SPOOF TO: "..d; db.BackgroundColor3 = Color3.fromRGB(30,30,35); db.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", db).CornerRadius = UDim.new(0, 10)
        db.MouseButton1Click:Connect(function() ApplyDevice(d); db.Text = "SPOOFED!"; task.wait(1); db.Text = "SPOOF TO: "..d end)
    end
    local dsc = Instance.new("TextButton", T3); dsc.Size = UDim2.new(1,-5,0,35); dsc.Text = "COPY DISCORD"; dsc.BackgroundColor3 = Color3.fromRGB(88, 101, 242); dsc.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", dsc).CornerRadius = UDim.new(0,10)
    dsc.MouseButton1Click:Connect(function() setclipboard(Config.Discord); dsc.Text = "COPIED!"; task.wait(1); dsc.Text = "COPY DISCORD" end)

    -- [[ 4. LOGIQUE DE BOUCLE ]] --
    local FOV = Drawing.new("Circle"); FOV.Thickness = 1
    RunService.RenderStepped:Connect(function()
        FOV.Visible = Config.ShowFOV; FOV.Radius = Config.FOV; FOV.Position = UIS:GetMouseLocation(); FOV.Color = Config.Accent
        
        if Config.Trigger then
            local t = Mouse.Target
            if t and t.Parent:FindFirstChild("Humanoid") then
                local p = Players:GetPlayerFromCharacter(t.Parent)
                if p and p ~= LocalPlayer and (not Config.TeamCheck or p.Team ~= LocalPlayer.Team) then
                    task.wait(Config.TriggerDelay); mouse1press(); task.wait(0.01); mouse1release()
                end
            end
        end

        if Config.Fly and LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,2,0)
            if UIS:IsKeyDown("W") then LocalPlayer.Character.HumanoidRootPart.CFrame += Camera.CFrame.LookVector * Config.FlySpeed end
        end

        if Config.NoClip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end)

    -- [[ K KEY (MENU + LIBÉRATION SOURIS) ]] --
    UIS.InputBegan:Connect(function(i, g)
        if i.KeyCode == Config.MenuKey then
            Main.Visible = not Main.Visible
            if Main.Visible then
                UIS.MouseBehavior = Enum.MouseBehavior.Default -- Libère la souris pour cliquer
                UIS.MouseIconEnabled = true
            else
                UIS.MouseBehavior = Enum.MouseBehavior.LockCenter -- Re-verrouille pour jouer
            end
        end
        if not g and i.KeyCode == Config.TP_Key then LocalPlayer.Character.HumanoidRootPart.CFrame = Mouse.Hit * CFrame.new(0,3,0) end
    end)

    T1.Visible = true
end

-- [[ 5. KEY SYSTEM (NEO-UI) ]] --
local function KeySystem()
    local SG = Instance.new("ScreenGui", CoreGui); local KF = Instance.new("Frame", SG)
    KF.Size = UDim2.new(0, 400, 0, 220); KF.Position = UDim2.new(0.5, -200, 0.5, -110); KF.BackgroundColor3 = Config.Bg; Instance.new("UICorner", KF).CornerRadius = UDim.new(0, 20); Instance.new("UIStroke", KF).Color = Config.Accent
    
    local T = Instance.new("TextLabel", KF); T.Size = UDim2.new(1,0,0,60); T.Text = "SOLO<font color='#00FFC8'>V10</font> AUTH"; T.RichText = true; T.TextColor3 = Color3.new(1,1,1); T.Font = "GothamBold"; T.TextSize = 22; T.BackgroundTransparency = 1
    local B = Instance.new("TextBox", KF); B.Size = UDim2.new(0.8, 0, 0, 45); B.Position = UDim2.new(0.1, 0, 0.4, 0); B.PlaceholderText = "Enter License Key..."; B.BackgroundColor3 = Color3.fromRGB(20,20,25); B.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", B).CornerRadius = UDim.new(0, 10)
    local V = Instance.new("TextButton", KF); V.Size = UDim2.new(0.4, 0, 0, 40); V.Position = UDim2.new(0.3, 0, 0.75, 0); V.Text = "LOGIN"; V.BackgroundColor3 = Config.Accent; V.Font = "GothamBold"; Instance.new("UICorner", V).CornerRadius = UDim.new(0, 10)

    V.MouseButton1Click:Connect(function()
        if B.Text == Config.CorrectKey then SG:Destroy(); InitCheat() else V.Text = "DENIED"; task.wait(1); V.Text = "LOGIN" end
    end)
end

pcall(KeySystem)
