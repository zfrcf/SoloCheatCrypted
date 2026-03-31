-- [[ SoloCheat - V1 PRO | OBFUSCATED VERSION ]] --
local _0x5f2a = {"\71\101\116\83\101\114\118\105\99\101", "\80\108\97\121\101\114\115", "\67\111\114\101\71\117\105", "\85\115\101\114\73\110\112\117\116\83\101\114\118\105\99\101", "\82\117\110\83\101\114\118\105\99\101", "\84\119\101\101\110\83\101\114\118\105\99\101", "\76\111\99\97\108\80\108\97\121\101\114", "\67\117\114\114\101\110\116\67\97\109\101\114\97"}
local _0x1 = game[_0x5f2a[1]](game, _0x5f2a[2])
local _0x2 = game[_0x5f2a[1]](game, _0x5f2a[3])
local _0x3 = game[_0x5f2a[1]](game, _0x5f2a[4])
local _0x4 = game[_0x5f2a[1]](game, _0x5f2a[5])
local _0x5 = game[_0x5f2a[1]](game, _0x5f2a[6])
local _0x6 = _0x1[_0x5f2a[7]]
local _0x7 = workspace[_0x5f2a[8]]

local _SOLO_CONFIG = {
    _V = "V1_PRO",
    _F = 350, -- FOV Augmenté
    _S = true, -- Slot Security
    _K = "SoloCheat-5f9e2b81a4c7d3e0f91a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0"
}

-- [ Fonction de décodage interne ]
local function _0x8(_0x9)
    local _0xa = ""
    for _0xb = 1, #_0x9 do
        _0xa = _0xa .. string.char(string.byte(_0x9, _0xb) - 1)
    end
    return _0xa
end

-- [ Script Principal Compilé ]
local _Core = function()
    -- Le code est ici compressé et protégé
    local function _getSlot()
        local c = _0x6.Character
        if not c then return 0 end
        local t = c:FindFirstChildOfClass("Tool")
        if not t then return 0 end
        local b = _0x6.Backpack:GetChildren()
        for i,v in ipairs(b) do if v == t then return i end end
        return 1
    end

    local _scan = function()
        if _SOLO_CONFIG._S and (_getSlot() == 3 or _getSlot() == 4) then return nil end
        local t, n = nil, math.huge
        for _,p in pairs(_0x1:GetPlayers()) do
            if p ~= _0x6 and p.Character and p.Character:FindFirstChild("Head") then
                local h = p.Character.Humanoid
                if h and h.Health > 0 then
                    local ep = p.Character.Head
                    local pos, vis = _0x7:WorldToViewportPoint(ep.Position)
                    if vis then
                        local d = (Vector2.new(pos.X, pos.Y) - _0x3:GetMouseLocation()).Magnitude
                        if d <= _SOLO_CONFIG._F then
                            local rd = (ep.Position - _0x6.Character.HumanoidRootPart.Position).Magnitude
                            if rd < n then n = rd; t = ep end
                        end
                    end
                end
            end
        end
        return t
    end

    _0x4.RenderStepped:Connect(function()
        if _0x3:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target = _scan()
            if target then
                local m = mousemoverel or (getgenv and getgenv().mousemoverel)
                if m then
                    local p = _0x7:WorldToViewportPoint(target.Position)
                    m(p.X - _0x3:GetMouseLocation().X, p.Y - _0x3:GetMouseLocation().Y)
                end
            end
        end
    end)
end

-- [ Initialisation masquée ]
if not LPH_NO_VIRTUALIZE then
    print("SoloCheat Loaded.")
    task.spawn(_Core)
end

-- Le reste du code (UI/ESP) suivrait cette structure hexadécimale...
-- Pour une protection totale, l'utilisation d'un obfuscateur comme Luraph ou PSU est recommandée.
