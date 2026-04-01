-- [[ SOLOCHEAT - FINAL TITAN EDITION ]] --
-- [[ ESP COMPLET | AIMBOT vs SILENT | DISCORD INCLUDED ]] --

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local Config = {
    CorrectKey = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
    Discord = "https://discord.gg/VDNw9dXnJe",
    -- Combat
    Aimbot = false,
    AimbotSmooth = 0.05,
    Silent = true,
    Prediction = 0.158,
    Trigger = false,
    FOV = 150,
    ShowFOV = true,
    TargetPart = "Head",
    TeamCheck = true,
    -- Visuals (ESP)
    ESP_Enabled = true,
    ESP_Box = true,
    ESP_Tracer = false,
    ESP_Name = true,
    -- Movement
    Fly = false,
    FlySpeed = 2,
    NoClip = false,
    TP_Key = Enum.KeyCode.E,
    -- System
    MenuKey = Enum.KeyCode.K,
    Device = "PC",
    Accent = Color3.fromRGB(0, 255, 200)
}

-- [[ ENGINE: TARGETING ]] --
local function GetTarget()
    local target, dist = nil, Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(Config.TargetPart) then
            if Config.TeamCheck and p.Team == LocalPlayer.Team then continue end
            local hum = p.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local pos, vis = Camera:WorldToViewportPoint(p.Character[Config.TargetPart].Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if mag < dist then dist = mag; target = p.Character[Config.TargetPart] end
                end
            end
        end
    end
    return target
end

-- [[ ENGINE: SILENT AIM (METATABLE) ]] --
local mt = getrawmetatable(game)
local old = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(self, idx)
    if not checkcaller() and Config.Silent and self == Mouse and (idx == "Hit" or idx == "Target") then
        local t = GetTarget()
        if t then return (idx == "Hit" and (t.CFrame + (t.Velocity * Config.Prediction)) or t.Parent) end
    end
    return old(self, idx)
end)
setreadonly(mt, true)

-- [[ ENGINE: ESP (DRAWING LIB) ]] --
local function AddESP(p)
    local Box = Drawing.new("Square")
    local Tracer = Drawing.new("Line")
    local Name = Drawing.new("Text")
    
    RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= LocalPlayer and Config.ESP_Enabled then
            local hrp = p.Character.HumanoidRootPart
            local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
            if vis then
                if Config.ESP_Box then
                    Box.Visible = true; Box.Size = Vector2.new(2000/pos.Z, 3000/pos.Z)
                    Box.Position = Vector2.new(pos.X - Box.Size.X/2, pos.Y - Box.Size.Y/2)
                    Box.Color = Config.Accent; Box.Thickness = 1
                else Box.Visible = false end
                if Config.ESP_Tracer then
                    Tracer.Visible = true; Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    Tracer.To = Vector2.new(pos.X, pos.Y); Tracer.Color = Config.Accent
                else Tracer.Visible = false end
                if Config.ESP_Name then
                    Name.Visible = true; Name.Text = p.Name; Name.Position = Vector2.new(pos.X, pos.Y - 40); Name.Center = true; Name.Outline = true; Name.Color = Color3.new(1,1,1)
                else Name.Visible = false end
            else Box.Visible = false; Tracer.Visible = false; Name.Visible = false end
        else Box.Visible = false; Tracer.Visible = false; Name.Visible = false end
    end)
end
for _, p in pairs(Players:GetPlayers()) do AddESP(p) end
Players.PlayerAdded:Connect(AddESP)

-- [[ UI: MAIN CHEAT ]] --
local function InitCheat()
    if CoreGui:FindFirstChild("SoloV12") then CoreGui.SoloV12:Destroy() end
    local UI = Instance.new("ScreenGui", CoreGui); UI.Name = "SoloV12"
    local Main = Instance.new("Frame", UI)
    Main.Size = UDim2.new(0, 600, 0, 420); Main.Position = UDim2.new(0.5, -300, 0.5, -210); Main.BackgroundColor3 = Color3.fromRGB(10,10,12)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20); Instance.new("UIStroke", Main).Color = Config.Accent

    local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1,0,0,50); Title.Text = "SOLO<font color='#00FFC8'>CHEAT</font> V12"; Title.RichText = true; Title.TextColor3 = Color3.new(1,1,1); Title.Font = "GothamBold"; Title.TextSize = 20; Title.BackgroundTransparency = 1

    local Container = Instance.new("ScrollingFrame", Main); Container.Size = UDim2.new(1, -40, 1, -80); Container.Position = UDim2.new(0, 20, 0, 60); Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 0
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 10)

    local function Toggle(txt, k)
        local b = Instance.new("TextButton", Container); b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(20,20,25); b.Text = txt
        b.TextColor3 = Config[k] and Config.Accent or Color3.new(1,1,1); b.Font = "GothamBold"; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
        b.MouseButton1Click:Connect(function() Config[k] = not Config[k]; b.TextColor3 = Config[k] and Config.Accent or Color3.new(1,1,1) end)
    end

    Toggle("AIMBOT CAMERA", "Aimbot")
    Toggle("SILENT AIM (METATABLE)", "Silent")
    Toggle("BOX ESP", "ESP_Box")
    Toggle("TRACERS ESP", "ESP_Tracer")
    Toggle("FLY HACK", "Fly")
    Toggle("NOCLIP", "NoClip")

    -- Spoofer Buttons
    for _, d in pairs({"PC", "Mobile", "Console", "VR"}) do
        local sb = Instance.new("TextButton", Container); sb.Size = UDim2.new(1,0,0,40); sb.Text = "SPOOF: "..d; sb.BackgroundColor3 = Color3.fromRGB(30,30,40); sb.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", sb).CornerRadius = UDim.new(0, 10)
        sb.MouseButton1Click:Connect(function() 
            Config.Device = d
            pcall(function()
                local u_mt = getrawmetatable(UIS); setreadonly(u_mt, false)
                u_mt.__index = newcclosure(function(s, i) if i == "TouchEnabled" then return Config.Device == "Mobile" end return s[i] end)
            end)
            sb.Text = "ACTIVE: "..d
        end)
    end

    -- Loops & Inputs
    local FOV = Drawing.new("Circle"); FOV.Thickness = 1
    RunService.RenderStepped:Connect(function()
        FOV.Visible = Config.ShowFOV; FOV.Radius = Config.FOV; FOV.Position = UIS:GetMouseLocation(); FOV.Color = Config.Accent
        if Config.Aimbot then
            local t = GetTarget()
            if t then TweenService:Create(Camera, TweenInfo.new(Config.AimbotSmooth), {CFrame = CFrame.new(Camera.CFrame.Position, t.Position)}):Play() end
        end
        if Config.Fly and LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,2,0)
            if UIS:IsKeyDown("W") then LocalPlayer.Character.HumanoidRootPart.CFrame += Camera.CFrame.LookVector * Config.FlySpeed end
        end
    end)

    UIS.InputBegan:Connect(function(i, g)
        if i.KeyCode == Config.MenuKey then
            Main.Visible = not Main.Visible
            UIS.MouseBehavior = Main.Visible and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
        end
        if not g and i.KeyCode == Config.TP_Key then LocalPlayer.Character.HumanoidRootPart.CFrame = Mouse.Hit * CFrame.new(0,3,0) end
    end)
end

-- [[ UI: KEY SYSTEM & DISCORD ]] --
local function KeySys()
    local SG = Instance.new("ScreenGui", CoreGui); local KF = Instance.new("Frame", SG)
    KF.Size = UDim2.new(0, 420, 0, 260); KF.Position = UDim2.new(0.5, -210, 0.5, -130); KF.BackgroundColor3 = Color3.fromRGB(12,12,14)
    Instance.new("UICorner", KF).CornerRadius = UDim.new(0, 20); Instance.new("UIStroke", KF).Color = Config.Accent
    
    local T = Instance.new("TextLabel", KF); T.Size = UDim2.new(1,0,0,60); T.Text = "SOLO<font color='#00FFC8'>V12</font> AUTH"; T.RichText = true; T.TextColor3 = Color3.new(1,1,1); T.Font = "GothamBold"; T.TextSize = 24; T.BackgroundTransparency = 1
    local B = Instance.new("TextBox", KF); B.Size = UDim2.new(0.8, 0, 0, 45); B.Position = UDim2.new(0.1, 0, 0.3, 0); B.PlaceholderText = "Paste License..."; B.BackgroundColor3 = Color3.fromRGB(25,25,30); B.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", B).CornerRadius = UDim.new(0, 10)
    
    local V = Instance.new("TextButton", KF); V.Size = UDim2.new(0.4, 0, 0, 40); V.Position = UDim2.new(0.05, 0, 0.65, 0); V.Text = "LOGIN"; V.BackgroundColor3 = Config.Accent; V.Font = "GothamBold"; Instance.new("UICorner", V).CornerRadius = UDim.new(0, 10)
    local D = Instance.new("TextButton", KF); D.Size = UDim2.new(0.45, 0, 0, 40); D.Position = UDim2.new(0.5, 0, 0.65, 0); D.Text = "COPY DISCORD"; D.BackgroundColor3 = Color3.fromRGB(88, 101, 242); D.TextColor3 = Color3.new(1,1,1); D.Font = "GothamBold"; Instance.new("UICorner", D).CornerRadius = UDim.new(0, 10)

    V.MouseButton1Click:Connect(function() if B.Text == Config.CorrectKey then SG:Destroy(); InitCheat() else V.Text = "WRONG"; task.wait(1); V.Text = "LOGIN" end end)
    D.MouseButton1Click:Connect(function() setclipboard(Config.Discord); D.Text = "COPIED!"; task.wait(1); D.Text = "COPY DISCORD" end)
    
    local L = Instance.new("TextLabel", KF); L.Size = UDim2.new(1,0,0,30); L.Position = UDim2.new(0,0,0.85,0); L.Text = "Need a key? Join our Discord."; L.TextColor3 = Color3.new(0.6,0.6,0.6); L.Font = "Gotham"; L.TextSize = 12; L.BackgroundTransparency = 1
end

KeySys()
