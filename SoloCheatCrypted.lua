-- [[ SOLOCHEAT V14 - OMNI-REBORN ]] --
-- [[ MASSIVE STRUCTURE | ANTI-CRASH | 100% FUNCTIONAL ]] --

repeat task.wait() until game:IsLoaded()

-- [[ DÉCLARATION DES SERVICES ]] --
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- [[ BASE DE DONNÉES CONFIGURATION ]] --
local SoloConfig = {
    -- Authentification & Social
    Key = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
    Discord = "https://discord.gg/VDNw9dXnJe",
    Version = "V14.0.2",
    
    -- Combat: Aimbot Camera
    Aimbot = false,
    AimbotSmooth = 0.08,
    AimbotTarget = "Head",
    
    -- Combat: Silent Aim (Metatable)
    Silent = true,
    Prediction = 0.157,
    HitChance = 100,
    
    -- Combat: Trigger Bot
    Trigger = false,
    TriggerDelay = 0.02,
    
    -- Visuals: ESP (High Performance)
    ESP_Master = true,
    ESP_Box = true,
    ESP_Tracer = false,
    ESP_Name = true,
    ESP_Distance = true,
    
    -- Visuals: FOV
    FOV_Radius = 150,
    FOV_Visible = true,
    FOV_Filled = false,
    
    -- Movement & Utility
    Fly = false,
    FlySpeed = 2,
    NoClip = false,
    TP_Click = Enum.KeyCode.E,
    Device = "PC",
    
    -- Menu System
    MenuKey = Enum.KeyCode.K,
    Accent = Color3.fromRGB(0, 255, 200),
    Secondary = Color3.fromRGB(15, 15, 18)
}

-- [[ MODULE 1: SYSTÈME DE CIBLAGE (NON-SIMPLIFIÉ) ]] --
local function GetClosestPlayer()
    local target, nearest = nil, SoloConfig.FOV_Radius
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(SoloConfig.AimbotTarget) then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character[SoloConfig.AimbotTarget].Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if distance < nearest then
                        nearest = distance
                        target = p.Character[SoloConfig.AimbotTarget]
                    end
                end
            end
        end
    end
    return target
end

-- [[ MODULE 2: MOTEUR ESP (DRAWING LIBRARY) ]] --
local function CreatePlayerESP(TargetPlayer)
    local Box = Drawing.new("Square")
    local Line = Drawing.new("Line")
    local NameTag = Drawing.new("Text")
    local DistTag = Drawing.new("Text")

    local function UpdateESP()
        local Connection
        Connection = RunService.RenderStepped:Connect(function()
            if not TargetPlayer or not TargetPlayer.Parent then
                Box:Remove(); Line:Remove(); NameTag:Remove(); DistTag:Remove()
                Connection:Disconnect(); return
            end

            local Char = TargetPlayer.Character
            if Char and Char:FindFirstChild("HumanoidRootPart") and SoloConfig.ESP_Master then
                local Root = Char.HumanoidRootPart
                local Pos, Visible = Camera:WorldToViewportPoint(Root.Position)

                if Visible then
                    local Scale = 1 / (Pos.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 1000
                    local W, H = 4 * Scale, 6 * Scale

                    if SoloConfig.ESP_Box then
                        Box.Visible = true; Box.Size = Vector2.new(W, H)
                        Box.Position = Vector2.new(Pos.X - W/2, Pos.Y - H/2)
                        Box.Color = SoloConfig.Accent; Box.Thickness = 1; Box.Filled = false
                    else Box.Visible = false end

                    if SoloConfig.ESP_Tracer then
                        Line.Visible = true; Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        Line.To = Vector2.new(Pos.X, Pos.Y); Line.Color = SoloConfig.Accent; Line.Thickness = 1
                    else Line.Visible = false end

                    if SoloConfig.ESP_Name then
                        NameTag.Visible = true; NameTag.Text = TargetPlayer.Name
                        NameTag.Position = Vector2.new(Pos.X, Pos.Y - H/2 - 18)
                        NameTag.Size = 16; NameTag.Center = true; NameTag.Outline = true; NameTag.Color = Color3.new(1,1,1)
                    else NameTag.Visible = false end
                else
                    Box.Visible = false; Line.Visible = false; NameTag.Visible = false; DistTag.Visible = false
                end
            else
                Box.Visible = false; Line.Visible = false; NameTag.Visible = false; DistTag.Visible = false
            end
        end)
    end
    coroutine.wrap(UpdateESP)()
end

-- [[ MODULE 3: INITIALISATION SILENT AIM ]] --
pcall(function()
    local RawMT = getrawmetatable(game)
    local OldIdx = RawMT.__index
    setreadonly(RawMT, false)
    RawMT.__index = newcclosure(function(self, idx)
        if not checkcaller() and SoloConfig.Silent and self == Mouse and (idx == "Hit" or idx == "Target") then
            local T = GetClosestPlayer()
            if T then
                local CalculatedPos = T.CFrame + (T.Velocity * SoloConfig.Prediction)
                return (idx == "Hit" and CalculatedPos or T.Parent)
            end
        end
        return OldIdx(self, idx)
    end)
    setreadonly(RawMT, true)
end)

-- [[ MODULE 4: INTERFACE UTILISATEUR (NEO-FUTURIST) ]] --
local function BuildMainUI()
    if CoreGui:FindFirstChild("SoloV14") then CoreGui.SoloV14:Destroy() end
    local UI = Instance.new("ScreenGui", CoreGui); UI.Name = "SoloV14"
    
    local MainFrame = Instance.new("Frame", UI)
    MainFrame.Size = UDim2.new(0, 560, 0, 420); MainFrame.Position = UDim2.new(0.5, -280, 0.5, -210)
    MainFrame.BackgroundColor3 = SoloConfig.Secondary; MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 25)
    Instance.new("UIStroke", MainFrame).Color = SoloConfig.Accent

    local Header = Instance.new("TextLabel", MainFrame)
    Header.Size = UDim2.new(1, 0, 0, 60); Header.Text = "SOLO<font color='#00FFC8'>CHEAT</font> V14 OMNI"
    Header.RichText = true; Header.TextColor3 = Color3.new(1,1,1); Header.Font = "GothamBold"; Header.TextSize = 22; Header.BackgroundTransparency = 1

    local CloseBtn = Instance.new("TextButton", MainFrame)
    CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(1, -45, 0, 12); CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80); CloseBtn.BackgroundTransparency = 1; CloseBtn.TextSize = 35; CloseBtn.Font = "GothamBold"
    CloseBtn.MouseButton1Click:Connect(function() UI:Destroy() end)

    local Container = Instance.new("ScrollingFrame", MainFrame)
    Container.Size = UDim2.new(1, -40, 1, -90); Container.Position = UDim2.new(0, 20, 0, 70); Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 0
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 12)

    local function NewOption(text, config_key)
        local btn = Instance.new("TextButton", Container)
        btn.Size = UDim2.new(1, 0, 0, 45); btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        btn.Text = "  " .. text; btn.TextColor3 = SoloConfig[config_key] and SoloConfig.Accent or Color3.new(1,1,1)
        btn.Font = "GothamBold"; btn.TextSize = 14; btn.TextXAlignment = 0; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
        
        btn.MouseButton1Click:Connect(function()
            SoloConfig[config_key] = not SoloConfig[config_key]
            btn.TextColor3 = SoloConfig[config_key] and SoloConfig.Accent or Color3.new(1,1,1)
        end)
    end

    -- Insertion des Options
    NewOption("SILENT AIM (METATABLE)", "Silent")
    NewOption("AIMBOT CAMERA", "Aimbot")
    NewOption("BOX ESP", "ESP_Box")
    NewOption("TRACER ESP", "ESP_Tracer")
    NewOption("NAME ESP", "ESP_Name")
    NewOption("FLY HACK (W)", "Fly")
    NewOption("NOCLIP", "NoClip")

    -- Spoofer System
    local function AddSpoof(dName)
        local sb = Instance.new("TextButton", Container); sb.Size = UDim2.new(1,0,0,45); sb.Text = "SPOOF AS: "..dName; sb.BackgroundColor3 = Color3.fromRGB(35,35,45); sb.TextColor3 = Color3.new(1,1,1); sb.Font = "GothamBold"; Instance.new("UICorner", sb).CornerRadius = UDim.new(0,12)
        sb.MouseButton1Click:Connect(function() 
            SoloConfig.Device = dName; sb.Text = "SPOOFED TO "..dName; task.wait(1); sb.Text = "SPOOF AS: "..dName 
            pcall(function()
                local mt = getrawmetatable(UIS); setreadonly(mt, false)
                mt.__index = newcclosure(function(s, k) if k == "TouchEnabled" then return SoloConfig.Device == "Mobile" end return s[k] end)
            end)
        end)
    end
    AddSpoof("MOBILE"); AddSpoof("CONSOLE"); AddSpoof("VR")

    -- [ BOUCLE DE RENDU ] --
    local FOVCircle = Drawing.new("Circle"); FOVCircle.Thickness = 1
    RunService.RenderStepped:Connect(function()
        FOVCircle.Visible = SoloConfig.FOV_Visible; FOVCircle.Radius = SoloConfig.FOV_Radius
        FOVCircle.Position = UIS:GetMouseLocation(); FOVCircle.Color = SoloConfig.Accent
        
        if SoloConfig.Aimbot then
            local T = GetClosestPlayer()
            if T then Camera.CFrame = CFrame.new(Camera.CFrame.Position, T.Position) end
        end
        if SoloConfig.Fly and LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,2,0)
            if UIS:IsKeyDown("W") then LocalPlayer.Character.HumanoidRootPart.CFrame += Camera.CFrame.LookVector * SoloConfig.FlySpeed end
        end
        if SoloConfig.NoClip and LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end)

    -- Touche de Menu K
    UIS.InputBegan:Connect(function(io, gpe)
        if io.KeyCode == SoloConfig.MenuKey then
            MainFrame.Visible = not MainFrame.Visible
            UIS.MouseBehavior = MainFrame.Visible and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
        end
        if not gpe and io.KeyCode == SoloConfig.TP_Click then LocalPlayer.Character.HumanoidRootPart.CFrame = Mouse.Hit * CFrame.new(0,3,0) end
    end)

    -- Init ESP pour les joueurs déjà là
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreatePlayerESP(p) end end
    Players.PlayerAdded:Connect(CreatePlayerESP)
end

-- [[ MODULE 5: SYSTÈME D'AUTHENTIFICATION ]] --
local function StartAuth()
    local SG = Instance.new("ScreenGui", CoreGui); local KF = Instance.new("Frame", SG)
    KF.Size = UDim2.new(0, 420, 0, 260); KF.Position = UDim2.new(0.5, -210, 0.5, -130); KF.BackgroundColor3 = SoloConfig.Secondary
    Instance.new("UICorner", KF).CornerRadius = UDim.new(0, 20); Instance.new("UIStroke", KF).Color = SoloConfig.Accent

    local Title = Instance.new("TextLabel", KF); Title.Size = UDim2.new(1,0,0,60); Title.Text = "SOLO<font color='#00FFC8'>V14</font> LOGIN"; Title.RichText = true; Title.TextColor3 = Color3.new(1,1,1); Title.Font = "GothamBold"; Title.TextSize = 24; Title.BackgroundTransparency = 1
    
    local Box = Instance.new("TextBox", KF); Box.Size = UDim2.new(0.8, 0, 0, 45); Box.Position = UDim2.new(0.1, 0, 0.35, 0); Box.PlaceholderText = "Paste License Key..."; Box.BackgroundColor3 = Color3.fromRGB(25,25,30); Box.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 10)

    local LogBtn = Instance.new("TextButton", KF); LogBtn.Size = UDim2.new(0.4, 0, 0, 45); LogBtn.Position = UDim2.new(0.06, 0, 0.65, 0); LogBtn.Text = "LOGIN"; LogBtn.BackgroundColor3 = SoloConfig.Accent; LogBtn.Font = "GothamBold"; Instance.new("UICorner", LogBtn).CornerRadius = UDim.new(0, 12)
    
    local DiscBtn = Instance.new("TextButton", KF); DiscBtn.Size = UDim2.new(0.45, 0, 0, 45); DiscBtn.Position = UDim2.new(0.51, 0, 0.65, 0); DiscBtn.Text = "COPY DISCORD"; DiscBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242); DiscBtn.TextColor3 = Color3.new(1,1,1); DiscBtn.Font = "GothamBold"; Instance.new("UICorner", DiscBtn).CornerRadius = UDim.new(0, 12)

    LogBtn.MouseButton1Click:Connect(function()
        if Box.Text == SoloConfig.Key then SG:Destroy(); BuildMainUI() else LogBtn.Text = "INVALID"; task.wait(1); LogBtn.Text = "LOGIN" end
    end)

    DiscBtn.MouseButton1Click:Connect(function()
        setclipboard(SoloConfig.Discord); DiscBtn.Text = "COPIED!"; task.wait(1); DiscBtn.Text = "COPY DISCORD"
    end)
end

-- Lancement de la séquence
pcall(StartAuth)
