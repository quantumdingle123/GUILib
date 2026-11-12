-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY - MODULE: Loader.lua ]
-- Dynamic Themed Boot & Loading Sequence with Orbital Emblem and Comet Progress
-- ==============================================================================

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Loader = {}
Loader.__index = Loader

local DEFAULT_STEPS = {
    { Threshold = 0.20, Text = "Checking client environment..." },
    { Threshold = 0.45, Text = "Requiring library modules..." },
    { Threshold = 0.70, Text = "Building UI components..." },
    { Threshold = 0.90, Text = "Applying theme styles..." },
    { Threshold = 1.00, Text = "Ready!" }
}

function Loader.new(lib, config)
    config = config or {}
    local Themes = lib.Themes
    local Utils = lib.Utils

    local themeName = config.Theme or "Sapphire"
    local activeTheme = Themes:Get(themeName)

    local safeContainer = Utils:GetSafeParent()
    local guiName = "Syntaxis_Loader_" .. tostring(math.random(10000, 99999))

    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = guiName
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 1000000000
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = safeContainer

    -- Fullscreen Ambient Dim
    local bgDim = Instance.new("Frame", screenGui)
    bgDim.Name = "AmbientDim"
    bgDim.Size = UDim2.new(1, 0, 1, 0)
    bgDim.BackgroundColor3 = Color3.fromRGB(4, 7, 16)
    bgDim.BackgroundTransparency = 1
    bgDim.BorderSizePixel = 0

    -- Particle holder
    local particleHolder = Instance.new("Frame", bgDim)
    particleHolder.Name = "Particles"
    particleHolder.Size = UDim2.new(1, 0, 1, 0)
    particleHolder.BackgroundTransparency = 1

    -- Central Card
    local card = Instance.new("Frame", screenGui)
    card.Name = "LoaderCard"
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.new(0.5, 0, 0.5, 0)
    card.Size = UDim2.new(0, 460, 0, 250)
    card.BackgroundColor3 = Color3.fromRGB(11, 16, 30)
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    Utils:RoundCorner(card, 18)

    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = activeTheme.Accent
    cardStroke.Thickness = 1.4
    cardStroke.Transparency = 1

    -- Card Top Highlight Specular Sheen
    local topSheen = Instance.new("Frame", card)
    topSheen.Name = "TopSheen"
    topSheen.Size = UDim2.new(1, -36, 0, 1)
    topSheen.Position = UDim2.new(0, 18, 0, 1)
    topSheen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    topSheen.BackgroundTransparency = 0.7
    topSheen.BorderSizePixel = 0
    local sheenGrad = Utils:MakeGradient(topSheen, 0)
    sheenGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }
    sheenGrad.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    }

    -- 1. Logo Stage (Centered at top)
    local emblemStage = Instance.new("Frame", card)
    emblemStage.Name = "EmblemStage"
    emblemStage.AnchorPoint = Vector2.new(0.5, 0)
    emblemStage.Position = UDim2.new(0.5, 0, 0, 18)
    emblemStage.Size = UDim2.new(0, 72, 0, 72)
    emblemStage.BackgroundTransparency = 1

    -- Outer Aura Ring (Pulsing)
    local auraRing = Instance.new("Frame", emblemStage)
    auraRing.Name = "AuraRing"
    auraRing.AnchorPoint = Vector2.new(0.5, 0.5)
    auraRing.Position = UDim2.new(0.5, 0, 0.5, 0)
    auraRing.Size = UDim2.new(1, 14, 1, 14)
    auraRing.BackgroundTransparency = 1
    Utils:RoundCorner(auraRing, 999)

    local auraStroke = Instance.new("UIStroke", auraRing)
    auraStroke.Color = activeTheme.Accent
    auraStroke.Thickness = 1.2
    auraStroke.Transparency = 0.5

    -- Logo Image
    local logoImg = Instance.new("ImageLabel", emblemStage)
    logoImg.Name = "LogoImage"
    logoImg.AnchorPoint = Vector2.new(0.5, 0.5)
    logoImg.Position = UDim2.new(0.5, 0, 0.5, 0)
    logoImg.Size = UDim2.new(1, 0, 1, 0)
    logoImg.BackgroundTransparency = 1
    logoImg.Image = config.Icon or "rbxassetid://71471996876777"
    logoImg.ScaleType = Enum.ScaleType.Fit
    Utils:RoundCorner(logoImg, 999)

    -- 2. Title & Game Name (Centered Typography)
    local titleLbl = Instance.new("TextLabel", card)
    titleLbl.Name = "Title"
    titleLbl.AnchorPoint = Vector2.new(0.5, 0)
    titleLbl.Position = UDim2.new(0.5, 0, 0, 96)
    titleLbl.Size = UDim2.new(1, -40, 0, 24)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = tostring(config.Title or "Syntaxis")
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.TextSize = 20
    titleLbl.TextXAlignment = Enum.TextXAlignment.Center

    local gameName = config.GameName or config.Subtitle or "tungtung"
    local gameLbl = Instance.new("TextLabel", card)
    gameLbl.Name = "GameName"
    gameLbl.AnchorPoint = Vector2.new(0.5, 0)
    gameLbl.Position = UDim2.new(0.5, 0, 0, 122)
    gameLbl.Size = UDim2.new(1, -40, 0, 18)
    gameLbl.BackgroundTransparency = 1
    gameLbl.Font = Enum.Font.GothamMedium
    gameLbl.Text = tostring(gameName)
    gameLbl.TextColor3 = activeTheme.SubText or Color3.fromRGB(180, 205, 240)
    gameLbl.TextSize = 13
    gameLbl.TextXAlignment = Enum.TextXAlignment.Center

    -- 3. Progress Track & Fill
    local track = Instance.new("Frame", card)
    track.Name = "ProgressTrack"
    track.AnchorPoint = Vector2.new(0.5, 0)
    track.Position = UDim2.new(0.5, 0, 0, 156)
    track.Size = UDim2.new(1, -60, 0, 8)
    track.BackgroundColor3 = Color3.fromRGB(12, 20, 38)
    track.BackgroundTransparency = 0.3
    track.BorderSizePixel = 0
    Utils:RoundCorner(track, 999)

    local trackStroke = Instance.new("UIStroke", track)
    trackStroke.Color = Color3.fromRGB(255, 255, 255)
    trackStroke.Thickness = 1
    trackStroke.Transparency = 0.88

    local fill = Instance.new("Frame", track)
    fill.Name = "ProgressFill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = activeTheme.Accent
    fill.BorderSizePixel = 0
    Utils:RoundCorner(fill, 999)

    local fillGrad = Utils:MakeGradient(fill, 0)
    fillGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, activeTheme.Accent),
        ColorSequenceKeypoint.new(0.7, activeTheme.Accent),
        ColorSequenceKeypoint.new(1, activeTheme.Accent2 or Color3.fromRGB(255, 255, 255))
    }

    -- Glowing Comet Tip
    local comet = Instance.new("Frame", fill)
    comet.Name = "CometHead"
    comet.AnchorPoint = Vector2.new(0.5, 0.5)
    comet.Position = UDim2.new(1, 0, 0.5, 0)
    comet.Size = UDim2.new(0, 14, 0, 14)
    comet.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    comet.BorderSizePixel = 0
    comet.Visible = false
    Utils:RoundCorner(comet, 999)

    local cometStroke = Instance.new("UIStroke", comet)
    cometStroke.Color = activeTheme.Accent
    cometStroke.Thickness = 2.5
    cometStroke.Transparency = 0.2

    -- 4. Status Row
    local statusRow = Instance.new("Frame", card)
    statusRow.Name = "StatusRow"
    statusRow.AnchorPoint = Vector2.new(0.5, 0)
    statusRow.Position = UDim2.new(0.5, 0, 0, 178)
    statusRow.Size = UDim2.new(1, -60, 0, 20)
    statusRow.BackgroundTransparency = 1

    local statusDot = Instance.new("Frame", statusRow)
    statusDot.Name = "Dot"
    statusDot.AnchorPoint = Vector2.new(0, 0.5)
    statusDot.Position = UDim2.new(0, 0, 0.5, 0)
    statusDot.Size = UDim2.new(0, 6, 0, 6)
    statusDot.BackgroundColor3 = activeTheme.Accent
    statusDot.BorderSizePixel = 0
    Utils:RoundCorner(statusDot, 999)

    local statusLbl = Instance.new("TextLabel", statusRow)
    statusLbl.Name = "StatusLabel"
    statusLbl.AnchorPoint = Vector2.new(0, 0.5)
    statusLbl.Position = UDim2.new(0, 14, 0.5, 0)
    statusLbl.Size = UDim2.new(1, -70, 1, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Font = Enum.Font.GothamMedium
    statusLbl.Text = "Initializing environment..."
    statusLbl.TextColor3 = Color3.fromRGB(215, 230, 250)
    statusLbl.TextSize = 12
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left

    local percentLbl = Instance.new("TextLabel", statusRow)
    percentLbl.Name = "PercentLabel"
    percentLbl.AnchorPoint = Vector2.new(1, 0.5)
    percentLbl.Position = UDim2.new(1, 0, 0.5, 0)
    percentLbl.Size = UDim2.new(0, 50, 1, 0)
    percentLbl.BackgroundTransparency = 1
    percentLbl.Font = Enum.Font.GothamBold
    percentLbl.Text = "0%"
    percentLbl.TextColor3 = activeTheme.Accent
    percentLbl.TextSize = 12
    percentLbl.TextXAlignment = Enum.TextXAlignment.Right

    -- Subtle Bottom Security Badge
    local secLbl = Instance.new("TextLabel", card)
    secLbl.Name = "SecurityNotice"
    secLbl.AnchorPoint = Vector2.new(0.5, 1)
    secLbl.Position = UDim2.new(0.5, 0, 1, -12)
    secLbl.Size = UDim2.new(1, -40, 0, 14)
    secLbl.BackgroundTransparency = 1
    secLbl.Font = Enum.Font.Gotham
    secLbl.Text = "SYNTAXIS ENGINE • SECURE BOOT"
    secLbl.TextColor3 = Color3.fromRGB(110, 135, 175)
    secLbl.TextSize = 10
    secLbl.TextXAlignment = Enum.TextXAlignment.Center

    local selfObj = setmetatable({
        _lib = lib,
        _config = config,
        _theme = activeTheme,
        _screenGui = screenGui,
        _bgDim = bgDim,
        _card = card,
        _cardStroke = cardStroke,
        _auraRing = auraRing,
        _auraStroke = auraStroke,
        _fill = fill,
        _comet = comet,
        _statusLbl = statusLbl,
        _percentLbl = percentLbl,
        _statusDot = statusDot,
        _particleHolder = particleHolder,
        _connections = {},
        _isDismissed = false,
        _onCompleteCallbacks = {},
        _steps = config.Steps or DEFAULT_STEPS,
        _duration = math.max(0.8, config.Duration or 2.2)
    }, Loader)

    selfObj:_InitAnimations()
    selfObj:_InitParticles()

    if config.AutoPlay ~= false then
        task.spawn(function()
            selfObj:Play()
        end)
    end

    return selfObj
end

function Loader:_InitAnimations()
    local auraConn
    local t = 0
    auraConn = RunService.RenderStepped:Connect(function(dt)
        if self._isDismissed then
            if auraConn then auraConn:Disconnect() end
            return
        end
        t = t + dt * 2.5
        local s = 14 + math.sin(t) * 3
        local alpha = 0.45 + math.sin(t) * 0.25
        self._auraRing.Size = UDim2.new(1, s, 1, s)
        self._auraStroke.Transparency = math.clamp(alpha, 0.2, 0.8)
    end)
    table.insert(self._connections, auraConn)

    self._card.Size = UDim2.new(0, 430, 0, 230)
    TweenService:Create(self._bgDim, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.25
    }):Play()

    TweenService:Create(self._card, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 460, 0, 250),
        BackgroundTransparency = 0.08
    }):Play()

    TweenService:Create(self._cardStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0.35
    }):Play()
end

function Loader:_InitParticles()
    local pCount = 18
    for i = 1, pCount do
        task.spawn(function()
            if self._isDismissed then return end
            task.wait(math.random() * 1.5)
            while not self._isDismissed and self._particleHolder and self._particleHolder.Parent do
                local p = Instance.new("Frame", self._particleHolder)
                local sz = math.random(2, 4)
                p.Size = UDim2.new(0, sz, 0, sz)
                p.Position = UDim2.new(math.random(), 0, 1.05, 0)
                p.BackgroundColor3 = self._theme.Accent
                p.BackgroundTransparency = 0.4
                p.BorderSizePixel = 0
                local c = Instance.new("UICorner", p)
                c.CornerRadius = UDim.new(1, 0)

                local travelTime = math.random(35, 60) / 10
                local targetY = math.random(-10, 40) / 100
                local driftX = (math.random() - 0.5) * 0.15

                local tween = TweenService:Create(p, TweenInfo.new(travelTime, Enum.EasingStyle.Linear), {
                    Position = UDim2.new(p.Position.X.Scale + driftX, 0, targetY, 0),
                    BackgroundTransparency = 1
                })
                tween:Play()
                task.wait(travelTime)
                p:Destroy()
            end
        end)
    end
end

function Loader:SetProgress(ratio, statusText)
    ratio = math.clamp(ratio, 0, 1)
    local pct = math.floor(ratio * 100)
    self._percentLbl.Text = tostring(pct) .. "%"
    if statusText then
        self._statusLbl.Text = tostring(statusText)
    end

    if ratio > 0.02 then
        self._comet.Visible = true
    end

    TweenService:Create(self._fill, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(ratio, 0, 1, 0)
    }):Play()
end

function Loader:Play(callback)
    local steps = self._steps
    local totalDuration = self._duration
    local startTime = os.clock()

    task.spawn(function()
        local currentRatio = 0
        while currentRatio < 1 and not self._isDismissed do
            local elapsed = os.clock() - startTime
            local targetRatio = math.clamp(elapsed / totalDuration, 0, 1)

            currentRatio = math.min(1, targetRatio)

            local activeText = steps[#steps].Text
            for _, s in ipairs(steps) do
                if currentRatio <= s.Threshold then
                    activeText = s.Text
                    break
                end
            end

            self:SetProgress(currentRatio, activeText)
            task.wait(0.04)
        end

        if not self._isDismissed then
            self:SetProgress(1, "Ready!")
            task.wait(0.35)
            self:Dismiss(callback)
        end
    end)
end

function Loader:OnComplete(callback)
    if typeof(callback) == "function" then
        if self._isDismissed then
            callback()
        else
            table.insert(self._onCompleteCallbacks, callback)
        end
    end
    return self
end

function Loader:Dismiss(callback)
    if self._isDismissed then return end
    self._isDismissed = true

    for _, conn in ipairs(self._connections) do
        pcall(function() conn:Disconnect() end)
    end

    local exitInfo = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    TweenService:Create(self._card, exitInfo, {
        Size = UDim2.new(0, 400, 0, 210),
        BackgroundTransparency = 1
    }):Play()

    TweenService:Create(self._cardStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Transparency = 1
    }):Play()

    local bgTween = TweenService:Create(self._bgDim, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    })
    bgTween:Play()

    bgTween.Completed:Connect(function()
        pcall(function() self._screenGui:Destroy() end)
        if typeof(callback) == "function" then callback() end
        for _, cb in ipairs(self._onCompleteCallbacks) do
            pcall(cb)
        end
    end)
end

return Loader
