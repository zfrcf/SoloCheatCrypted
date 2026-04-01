-- [[ SOLOCHEAT V13 - REBORN EDITION ]] --
-- [[ ANTICRASH | FULL ESP | AIMBOT & SILENT | DISCORD ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- [ CONFIGURATION ] --
local Config = {
    Key = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
    Discord = "https://discord.gg/VDNw9dXnJe",
    Aimbot = false,
    Silent = true,
    Prediction = 0.155,
    FOV = 150,
    ShowFOV = true,
    ESP_Enabled = true,
    ESP_Box = true,
    ESP_Tracer = false,
    ESP_Name = true,
    Fly = false,
    FlySpeed = 2,
    NoClip = false,
    Device = "PC",
    MenuKey = Enum.KeyCode.K,
    Accent = Color3.fromRGB(0, 255, 200)
}

-- [ SYSTÈME DE CIBLE ] --
local function GetClosest()
    local target, shortest = nil, Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                if mag < shortest then
                    shortest = mag
                    target = p.Character.Head
                end
            end
        end
    end
    return target
end

-- [ MOTEUR ESP (DRAWING LIB) ] --
local function CreateESP(p)
    local Box = Drawing.new("Square")
    local Line = Drawing.new("Line")
    local Label = Drawing.new("Text")

    RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= LocalPlayer and Config.ESP_Enabled then
            local root = p.Character.HumanoidRootPart
            local pos, vis = Camera:WorldToViewportPoint(root.Position)
            if vis then
                if Config.ESP_Box then
                    Box.Visible = true
                    Box.Size = Vector2.new(2000/pos.Z, 3000/pos.Z)
                    Box.Position = Vector2.new(pos.X - Box.Size.X/2, pos.Y - Box.Size.Y/2)
                    Box.Color = Config.Accent
                    Box.Thickness = 1
                else Box.Visible = false end
                
                if Config.ESP_Tracer then
                    Line.Visible = true
                    Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    Line.To = Vector2.new(pos.X, pos.Y)
                    Line.Color = Config.Accent
                else Line.Visible = false end

                if Config.ESP_Name then
                    Label.Visible = true
                    Label.Text = p.Name
                    Label.Position = Vector2.new(pos.X, pos.Y - (Box.Size.Y/2) - 15)
                    Label.Color = Color3.new(1,1,1)
                    Label.Center = true
                    Label.Outline = true
                else Label.Visible = false end
            else Box.Visible = false; Line.Visible = false; Label.Visible = false end
        else Box.Visible = false; Line.Visible = false; Label.Visible = false end
    end)
end

-- [ UI PRINCIPALE ] --
local function LaunchMenu()
    if CoreGui:FindFirstChild("SoloV13") then CoreGui.SoloV13:Destroy() end
    local UI = Instance.new("ScreenGui", CoreGui); UI.Name = "SoloV13"
    
    local Main = Instance.new("Frame", UI)
    Main.Size = UDim2.new(0, 550, 0, 400); Main.Position = UDim2.new(0.5, -275, 0.5, -200)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14); Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)
    Instance.new("UIStroke", Main).Color = Config.Accent

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 50); Title.Text = "SOLO<font color='#00FFC8'>CHEAT</font> V13 REBORN"
    Title.RichText = true; Title.TextColor3 = Color3.new(1,1,1); Title.Font = "GothamBold"; Title.TextSize = 20; Title.BackgroundTransparency = 1

    local Scroll = Instance.new("ScrollingFrame", Main)
    Scroll.Size = UDim2.new(1, -40, 1, -80); Scroll.Position = UDim2.new(0, 20, 0, 60)
    Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 0
    Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 10)

    local function AddBtn(txt, callback)
        local b = Instance.new("TextButton", Scroll)
        b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
        b.MouseButton1Click:Connect(callback)
        return b
    end

    -- Boutons Combat
    local b1 = AddBtn("SILENT AIM: ON", function() Config.Silent = not Config.Silent end)
    local b2 = AddBtn("AIMBOT CAMERA: OFF", function() Config.Aimbot = not Config.Aimbot end)
    local b3 = AddBtn("BOX ESP: ON", function() Config.ESP_Box = not Config.ESP_Box end)
    local b4 = AddBtn("FLY HACK: OFF", function() Config.Fly = not Config.Fly end)

    -- Spoofer
    AddBtn("SPOOF TO MOBILE", function() Config.Device = "Mobile" end)
    AddBtn("SPOOF TO VR", function() Config.Device = "VR" end)

    -- Croix de fermeture
    local Close = Instance.new("TextButton", Main)
    Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -40, 0, 10)
    Close.Text = "×"; Close.TextColor3 = Color3.new(1,0,0); Close.BackgroundTransparency = 1; Close.TextSize = 30
    Close.MouseButton1Click:Connect(function() UI:Destroy() end)

    -- [ LOOPS ] --
    local FOV = Drawing.new("Circle"); FOV.Thickness = 1
    RunService.RenderStepped:Connect(function()
        b1.Text = "SILENT AIM: " .. (Config.Silent and "ON" or "OFF")
        b1.TextColor3 = Config.Silent and Config.Accent or Color3.new(1,1,1)
        b2.Text = "AIMBOT CAMERA: " .. (Config.Aimbot and "ON" or "OFF")
        b2.TextColor3 = Config.Aimbot and Config.Accent or Color3.new(1,1,1)

        FOV.Visible = Config.ShowFOV; FOV.Radius = Config.FOV; FOV.Position = UIS:GetMouseLocation(); FOV.Color = Config.Accent
        
        if Config.Aimbot then
            local t = GetClosest()
            if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position) end
        end

        if Config.Fly and LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,2,0)
            if UIS:IsKeyDown("W") then LocalPlayer.Character.HumanoidRootPart.CFrame += Camera.CFrame.LookVector * Config.FlySpeed end
        end
    end)

    -- K KEY
    UIS.InputBegan:Connect(function(i, g)
        if i.KeyCode == Config.MenuKey then
            Main.Visible = not Main.Visible
            UIS.MouseBehavior = Main.Visible and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
        end
    end)

    -- Lancer l'ESP et le Silent Aim après l'UI
    for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
    Players.PlayerAdded:Connect(CreateESP)
    
    pcall(function()
        local mt = getrawmetatable(game); local old = mt.__index; setreadonly(mt, false)
        mt.__index = newcclosure(function(self, idx)
            if Config.Silent and self == Mouse and (idx == "Hit" or idx == "Target") then
                local t = GetClosest()
                if t then return (idx == "Hit" and (t.CFrame + (t.Velocity * Config.Prediction)) or t.Parent) end
            end
            return old(self, idx)
        end)
    end)
end

-- [ SYSTÈME DE CLÉ AVEC DISCORD ] --
local function Auth()
    local SG = Instance.new("ScreenGui", CoreGui); local KF = Instance.new("Frame", SG)
    KF.Size = UDim2.new(0, 400, 0, 250); KF.Position = UDim2.new(0.5, -200, 0.5, -125); KF.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Instance.new("UICorner", KF).CornerRadius = UDim.new(0, 20); Instance.new("UIStroke", KF).Color = Config.Accent

    local T = Instance.new("TextLabel", KF); T.Size = UDim2.new(1,0,0,60); T.Text = "SOLO<font color='#00FFC8'>V13</font> AUTH"; T.RichText = true; T.TextColor3 = Color3.new(1,1,1); T.Font = "GothamBold"; T.TextSize = 22; T.BackgroundTransparency = 1
    
    local Box = Instance.new("TextBox", KF); Box.Size = UDim2.new(0.8, 0, 0, 45); Box.Position = UDim2.new(0.1, 0, 0.35, 0); Box.PlaceholderText = "Paste License Key..."; Box.BackgroundColor3 = Color3.fromRGB(25,25,30); Box.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 10)

    local Login = Instance.new("TextButton", KF); Login.Size = UDim2.new(0.4, 0, 0, 40); Login.Position = UDim2.new(0.05, 0, 0.65, 0); Login.Text = "LOGIN"; Login.BackgroundColor3 = Config.Accent; Login.Font = "GothamBold"; Instance.new("UICorner", Login).CornerRadius = UDim.new(0, 10)
    
    local Disc = Instance.new("TextButton", KF); Disc.Size = UDim2.new(0.45, 0, 0, 40); Disc.Position = UDim2.new(0.5, 0, 0.65, 0); Disc.Text = "COPY DISCORD"; Disc.BackgroundColor3 = Color3.fromRGB(88, 101, 242); Disc.TextColor3 = Color3.new(1,1,1); Disc.Font = "GothamBold"; Instance.new("UICorner", Disc).CornerRadius = UDim.new(0, 10)

    Login.MouseButton1Click:Connect(function()
        if Box.Text == Config.Key then SG:Destroy(); LaunchMenu() else Login.Text = "WRONG KEY"; task.wait(1); Login.Text = "LOGIN" end
    end)

    Disc.MouseButton1Click:Connect(function()
        setclipboard(Config.Discord)
        Disc.Text = "COPIED!"
        task.wait(1)
        Disc.Text = "COPY DISCORD"
    end)
end

Auth()
