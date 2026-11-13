-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY - MODULE: Loader.lua ]
-- Architectural Monolith Splash, iOS Background Blur & Window Morph
-- ==============================================================================

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local Loader = {}
Loader.__index = Loader

local BLUR_INSTANCE_NAME = "Syntaxis_LoaderBlur"

local DEFAULT_STEPS = {
    { Threshold = 0.22, Step = "01 / 05", Text = "Checking client environment..." },
    { Threshold = 0.48, Step = "02 / 05", Text = "Requiring library modules..." },
    { Threshold = 0.72, Step = "03 / 05", Text = "Building UI components..." },
    { Threshold = 0.88, Step = "04 / 05", Text = "Applying theme styles..." },
    { Threshold = 1.00, Step = "05 / 05", Text = "Initializing keybinds & controls..." }
}

local SURFACE_PALETTES = {
    Sapphire = {
        SurfaceStart = Color3.fromRGB(14, 24, 46),
        SurfaceEnd   = Color3.fromRGB(22, 42, 78),
        Well         = Color3.fromRGB(10, 18, 36),
        SubText      = Color3.fromRGB(176, 206, 238)
    },
    Emerald = {
        SurfaceStart = Color3.fromRGB(11, 30, 20),
        SurfaceEnd   = Color3.fromRGB(18, 48, 32),
        Well         = Color3.fromRGB(8, 22, 15),
        SubText      = Color3.fromRGB(178, 226, 200)
    },
    Ruby = {
        SurfaceStart = Color3.fromRGB(32, 11, 17),
        SurfaceEnd   = Color3.fromRGB(52, 17, 26),
        Well         = Color3.fromRGB(22, 8, 12),
        SubText      = Color3.fromRGB(232, 184, 194)
    },
    Amethyst = {
        SurfaceStart = Color3.fromRGB(24, 13, 42),
        SurfaceEnd   = Color3.fromRGB(38, 20, 66),
        Well         = Color3.fromRGB(16, 9, 30),
        SubText      = Color3.fromRGB(212, 190, 238)
    },
    Midnight = {
        SurfaceStart = Color3.fromRGB(16, 20, 28),
        SurfaceEnd   = Color3.fromRGB(26, 32, 46),
        Well         = Color3.fromRGB(11, 14, 20),
        SubText      = Color3.fromRGB(186, 200, 220)
    },
    Amber = {
        SurfaceStart = Color3.fromRGB(32, 18, 6),
        SurfaceEnd   = Color3.fromRGB(52, 29, 10),
        Well         = Color3.fromRGB(22, 12, 4),
        SubText      = Color3.fromRGB(238, 210, 170)
    },
    Obsidian = {
        SurfaceStart = Color3.fromRGB(12, 13, 16),
        SurfaceEnd   = Color3.fromRGB(20, 22, 28),
        Well         = Color3.fromRGB(8, 9, 12),
        SubText      = Color3.fromRGB(190, 198, 212)
    },
    Rainbow = {
        SurfaceStart = Color3.fromRGB(16, 17, 26),
        SurfaceEnd   = Color3.fromRGB(26, 28, 42),
        Well         = Color3.fromRGB(10, 11, 18),
        SubText      = Color3.fromRGB(214, 218, 238)
    }
}

local function getLoaderTokens(themeName, activeTheme)
    local preset = SURFACE_PALETTES[themeName]
    if preset then
        return preset
    end
    local black = Color3.new(0, 0, 0)
    local baseSwitch = activeTheme.SwitchOff or Color3.fromRGB(18, 34, 64)
    local baseRow = activeTheme.RowBg or Color3.fromRGB(22, 46, 88)
    return {
        SurfaceStart = baseSwitch:Lerp(black, 0.22),
        SurfaceEnd   = baseRow:Lerp(black, 0.12),
        Well         = baseSwitch:Lerp(black, 0.42),
        SubText      = activeTheme.SubText or Color3.fromRGB(176, 206, 238)
    }
end

local function createBackgroundBlur(blurParent, initialSize)
    -- Clean up any orphaned Syntaxis loader blur before instantiating a fresh effect
    pcall(function()
        for _, child in ipairs(blurParent:GetChildren()) do
            if child:IsA("BlurEffect") and child.Name == BLUR_INSTANCE_NAME then
                child:Destroy()
            end
        end
    end)

    local ok, blur = pcall(function()
        local b = Instance.new("BlurEffect")
        b.Name = BLUR_INSTANCE_NAME
        b.Size = initialSize
        b.Enabled = true
        b.Parent = blurParent
        return b
    end)
    return ok and blur or nil
end

function Loader.new(lib, config)
    config = config or {}
    local Themes = lib.Themes
    local Utils = lib.Utils

    local themeName = config.Theme or "Sapphire"
    local activeTheme = Themes:Get(themeName)
    local tokens = getLoaderTokens(themeName, activeTheme)
    local layoutMode = tostring(config.Layout or "B"):upper()

    local blurEnabled = (config.BlurEnabled ~= false)
    local blurSize = math.clamp(tonumber(config.BlurSize) or 20, 0, 56)
    local scrimTrans = math.clamp(tonumber(config.BackdropTransparency) or 0.74, 0, 1)
    local cardTrans = math.clamp(tonumber(config.CardTransparency) or 0.16, 0, 0.85)
    local blurParent = config.BlurParent or Lighting

    local safeContainer = config.Parent or Utils:GetSafeParent()
    local guiName = config.GuiName or ("Syntaxis_Loader_" .. tostring(math.random(10000, 99999)))

    local function protectGui(gui)
        if Utils and Utils.ProtectGui then
            Utils:ProtectGui(gui)
            return
        end
        pcall(function() gui:SetAttribute("SyntaxisInstance", true) end)
        if typeof(syn) == "table" and typeof(syn.protect_gui) == "function" then
            pcall(syn.protect_gui, gui)
        elseif typeof(protectgui) == "function" then
            pcall(protectgui, gui)
        end
    end

    local scrimGui = Instance.new("ScreenGui")
    scrimGui.Name = guiName .. "_Scrim"
    scrimGui.ResetOnSpawn = false
    scrimGui.IgnoreGuiInset = true
    scrimGui.DisplayOrder = 999999998
    scrimGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    protectGui(scrimGui)
    scrimGui.Parent = safeContainer

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = guiName
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = (config.IgnoreGuiInset == true)
    screenGui.DisplayOrder = 1000000000
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    protectGui(screenGui)
    screenGui.Parent = safeContainer

    -- =========================================================================
    -- 1. iOS DEPTH BACKDROP (Lighting.BlurEffect + Subtle Edge-to-Edge Scrim)
    -- =========================================================================
    local backdropScrim = Instance.new("Frame", scrimGui)
    backdropScrim.Name = "BackdropScrim"
    backdropScrim.Size = UDim2.new(1, 0, 1, 0)
    backdropScrim.Position = UDim2.new(0, 0, 0, 0)
    backdropScrim.BackgroundColor3 = Color3.fromRGB(6, 10, 18)
    backdropScrim.BackgroundTransparency = config.SkipEntrance and scrimTrans or 1
    backdropScrim.BorderSizePixel = 0
    backdropScrim.ZIndex = 1

    local blurEffect = nil
    if blurEnabled and blurSize > 0 then
        blurEffect = createBackgroundBlur(blurParent, config.SkipEntrance and blurSize or 0)
    end

    local baseWidth = (layoutMode == "B") and 360 or 380
    local baseHeight = (layoutMode == "B") and 196 or 176

    -- =========================================================================
    -- 2. ARCHITECTURAL MONOLITH CONTAINER (Frosted surface over blurred world)
    -- =========================================================================
    local monolith = Instance.new("Frame", screenGui)
    monolith.Name = "MonolithFrame"
    monolith.AnchorPoint = Vector2.new(0.5, 0.5)
    monolith.Position = config.MorphPosition or UDim2.new(0.5, 0, 0.5, 0)
    monolith.Size = UDim2.new(0, baseWidth, 0, baseHeight)
    monolith.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    monolith.BackgroundTransparency = cardTrans
    monolith.BorderSizePixel = 0
    monolith.ClipsDescendants = true
    monolith.ZIndex = 2

    local monolithCorner = Instance.new("UICorner", monolith)
    monolithCorner.CornerRadius = UDim.new(0, 16)

    local monolithGrad = Utils:MakeGradient(monolith, 135)
    monolithGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, tokens.SurfaceStart),
        ColorSequenceKeypoint.new(1, tokens.SurfaceEnd)
    }

    local monolithStroke = Instance.new("UIStroke", monolith)
    monolithStroke.Color = activeTheme.Stroke
    monolithStroke.Thickness = 1
    monolithStroke.Transparency = 0.52

    -- 1px Top Rim Specular Highlight (GlassRim token)
    local topRim = Instance.new("Frame", monolith)
    topRim.Name = "TopRimHighlight"
    topRim.Position = UDim2.new(0, 0, 0, 0)
    topRim.Size = UDim2.new(1, 0, 0, 1)
    topRim.BackgroundColor3 = activeTheme.GlassRim or activeTheme.Stroke
    topRim.BackgroundTransparency = 0
    topRim.BorderSizePixel = 0
    topRim.ZIndex = 5

    local topRimGrad = Utils:MakeGradient(topRim, 0)
    topRimGrad.Color = ColorSequence.new(activeTheme.GlassRim or activeTheme.Stroke)
    topRimGrad.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.05, 1),
        NumberSequenceKeypoint.new(0.5, 0.42),
        NumberSequenceKeypoint.new(0.95, 1),
        NumberSequenceKeypoint.new(1, 1)
    }

    -- Inner Padded Content Holder
    local padTop = (layoutMode == "B") and 20 or 22
    local padBottom = (layoutMode == "B") and 18 or 20
    local content = Instance.new("Frame", monolith)
    content.Name = "ContentHolder"
    content.Position = UDim2.new(0, 24, 0, padTop)
    content.Size = UDim2.new(1, -48, 1, -(padTop + padBottom))
    content.BackgroundTransparency = 1
    content.ZIndex = 2

    local titleText = tostring(config.Title or "Syntaxis")
    local gameName = tostring(config.GameName or config.Subtitle or "tungtung")
    local iconAsset = config.Icon or "rbxassetid://71471996876777"

    local stepLabel = nil

    if layoutMode == "B" then
        -- =====================================================================
        -- LAYOUT B: CENTERED ARCHITECTURAL MONOLITH (360 x 196)
        -- =====================================================================
        local headerB = Instance.new("Frame", content)
        headerB.Name = "CenteredHeader"
        headerB.Position = UDim2.new(0, 0, 0, 0)
        headerB.Size = UDim2.new(1, 0, 0, 92)
        headerB.BackgroundTransparency = 1

        local logoImg = Instance.new("ImageLabel", headerB)
        logoImg.Name = "Logo"
        logoImg.AnchorPoint = Vector2.new(0.5, 0)
        logoImg.Position = UDim2.new(0.5, 0, 0, 0)
        logoImg.Size = UDim2.new(0, 46, 0, 46)
        logoImg.BackgroundTransparency = 1
        logoImg.Image = iconAsset
        logoImg.ScaleType = Enum.ScaleType.Fit
        Utils:RoundCorner(logoImg, 999)

        local titleLbl = Instance.new("TextLabel", headerB)
        titleLbl.Name = "Title"
        titleLbl.Position = UDim2.new(0, 0, 0, 52)
        titleLbl.Size = UDim2.new(1, 0, 0, 22)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.Text = titleText
        titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLbl.TextSize = 18
        titleLbl.TextXAlignment = Enum.TextXAlignment.Center

        local subLbl = Instance.new("TextLabel", headerB)
        subLbl.Name = "Subtitle"
        subLbl.Position = UDim2.new(0, 0, 0, 74)
        subLbl.Size = UDim2.new(1, 0, 0, 17)
        subLbl.BackgroundTransparency = 1
        subLbl.Font = Enum.Font.GothamMedium
        subLbl.Text = gameName
        subLbl.TextColor3 = tokens.SubText
        subLbl.TextSize = 13
        subLbl.TextXAlignment = Enum.TextXAlignment.Center
    else
        -- =====================================================================
        -- LAYOUT A: HORIZONTAL ARCHITECTURAL LOCKUP (380 x 176)
        -- =====================================================================
        local headerA = Instance.new("Frame", content)
        headerA.Name = "HeaderRow"
        headerA.Position = UDim2.new(0, 0, 0, 0)
        headerA.Size = UDim2.new(1, 0, 0, 48)
        headerA.BackgroundTransparency = 1

        -- 48x48 Recessed Emblem Mount (Zero extra radar circles)
        local emblemMount = Instance.new("Frame", headerA)
        emblemMount.Name = "EmblemMount"
        emblemMount.Position = UDim2.new(0, 0, 0, 0)
        emblemMount.Size = UDim2.new(0, 48, 0, 48)
        emblemMount.BackgroundColor3 = tokens.Well
        emblemMount.BackgroundTransparency = 0.12
        emblemMount.BorderSizePixel = 0
        Utils:RoundCorner(emblemMount, 12)

        local mountStroke = Instance.new("UIStroke", emblemMount)
        mountStroke.Color = activeTheme.Stroke
        mountStroke.Thickness = 1
        mountStroke.Transparency = 0.62

        local logoImg = Instance.new("ImageLabel", emblemMount)
        logoImg.Name = "Logo"
        logoImg.AnchorPoint = Vector2.new(0.5, 0.5)
        logoImg.Position = UDim2.new(0.5, 0, 0.5, 0)
        logoImg.Size = UDim2.new(0, 40, 0, 40)
        logoImg.BackgroundTransparency = 1
        logoImg.Image = iconAsset
        logoImg.ScaleType = Enum.ScaleType.Fit
        Utils:RoundCorner(logoImg, 999)

        -- Typography Lockup (Syntaxis + Game Subtitle)
        local titleLbl = Instance.new("TextLabel", headerA)
        titleLbl.Name = "Title"
        titleLbl.Position = UDim2.new(0, 62, 0, 3)
        titleLbl.Size = UDim2.new(1, -130, 0, 22)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.Text = titleText
        titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLbl.TextSize = 18
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left

        local subLbl = Instance.new("TextLabel", headerA)
        subLbl.Name = "Subtitle"
        subLbl.Position = UDim2.new(0, 62, 0, 26)
        subLbl.Size = UDim2.new(1, -130, 0, 18)
        subLbl.BackgroundTransparency = 1
        subLbl.Font = Enum.Font.GothamMedium
        subLbl.Text = gameName
        subLbl.TextColor3 = tokens.SubText
        subLbl.TextSize = 13
        subLbl.TextXAlignment = Enum.TextXAlignment.Left

        -- Top-Right Functional Stage Counter (01 / 05)
        if config.ShowStepCounter ~= false then
            local stepBadge = Instance.new("Frame", headerA)
            stepBadge.Name = "StepBadge"
            stepBadge.AnchorPoint = Vector2.new(1, 0.5)
            stepBadge.Position = UDim2.new(1, 0, 0.5, 0)
            stepBadge.Size = UDim2.new(0, 58, 0, 24)
            stepBadge.BackgroundColor3 = tokens.Well
            stepBadge.BackgroundTransparency = 0.12
            stepBadge.BorderSizePixel = 0
            Utils:RoundCorner(stepBadge, 6)

            local badgeStroke = Instance.new("UIStroke", stepBadge)
            badgeStroke.Color = activeTheme.Stroke
            badgeStroke.Thickness = 1
            badgeStroke.Transparency = 0.62

            stepLabel = Instance.new("TextLabel", stepBadge)
            stepLabel.Name = "StepLabel"
            stepLabel.Size = UDim2.new(1, 0, 1, 0)
            stepLabel.BackgroundTransparency = 1
            stepLabel.Text = "01 / 05"
            stepLabel.TextColor3 = tokens.SubText
            stepLabel.TextSize = 11
            stepLabel.TextXAlignment = Enum.TextXAlignment.Center
            Utils:ApplyTabularFont(stepLabel, Enum.FontWeight.Bold)
        end
    end

    -- =========================================================================
    -- STRUCTURAL 1PX HAIRLINE DIVIDER
    -- =========================================================================
    local dividerY = (layoutMode == "B") and 108 or 72
    local divider = Instance.new("Frame", content)
    divider.Name = "StructuralDivider"
    divider.Position = UDim2.new(0, 0, 0, dividerY)
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.BackgroundColor3 = activeTheme.Stroke
    divider.BackgroundTransparency = 0.65
    divider.BorderSizePixel = 0

    -- =========================================================================
    -- LOWER ZONE: TELEMETRY ROW + 4PX PRECISION PROGRESS BAR
    -- =========================================================================
    local telemetryZone = Instance.new("Frame", content)
    telemetryZone.Name = "TelemetryZone"
    telemetryZone.AnchorPoint = Vector2.new(0, 1)
    telemetryZone.Position = UDim2.new(0, 0, 1, 0)
    telemetryZone.Size = UDim2.new(1, 0, 0, 32)
    telemetryZone.BackgroundTransparency = 1

    local pctFmt = Utils:CreateNumericFormatter(0, 100, 1, "%", {
        TextSize = 12,
        Weight = Enum.FontWeight.Bold,
        Padding = 4
    })

    local statusLbl = Instance.new("TextLabel", telemetryZone)
    statusLbl.Name = "StatusLabel"
    statusLbl.Position = UDim2.new(0, 0, 0, 0)
    statusLbl.Size = UDim2.new(1, -(pctFmt.ReservedWidth + 8), 0, 18)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Font = Enum.Font.GothamMedium
    statusLbl.Text = "Checking client environment..."
    statusLbl.TextColor3 = tokens.SubText
    statusLbl.TextSize = 12
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.TextTruncate = Enum.TextTruncate.AtEnd

    local percentLbl = Instance.new("TextLabel", telemetryZone)
    percentLbl.Name = "PercentLabel"
    percentLbl.AnchorPoint = Vector2.new(1, 0)
    percentLbl.Position = UDim2.new(1, 0, 0, 0)
    percentLbl.Size = UDim2.new(0, pctFmt.ReservedWidth, 0, 18)
    percentLbl.BackgroundTransparency = 1
    percentLbl.TextColor3 = activeTheme.Accent
    percentLbl.TextSize = 12
    percentLbl.TextXAlignment = Enum.TextXAlignment.Right
    Utils:ApplyTabularFont(percentLbl, Enum.FontWeight.Bold)
    percentLbl.Text = pctFmt.Format(0)

    -- 4px Recessed Progress Track (No oversized knob)
    local track = Instance.new("Frame", telemetryZone)
    track.Name = "ProgressTrack"
    track.AnchorPoint = Vector2.new(0, 1)
    track.Position = UDim2.new(0, 0, 1, 0)
    track.Size = UDim2.new(1, 0, 0, 4)
    track.BackgroundColor3 = tokens.Well
    track.BackgroundTransparency = 0.12
    track.BorderSizePixel = 0
    track.ClipsDescendants = true
    Utils:RoundCorner(track, 999)

    local fill = Instance.new("Frame", track)
    fill.Name = "ProgressFill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fill.BorderSizePixel = 0
    Utils:RoundCorner(fill, 999)

    local fillGrad = Utils:MakeGradient(fill, 0)
    fillGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, activeTheme.Accent),
        ColorSequenceKeypoint.new(1, activeTheme.Accent2 or activeTheme.Accent)
    }

    local steps = config.Steps or DEFAULT_STEPS

    local selfObj = setmetatable({
        _lib = lib,
        _config = config,
        _theme = activeTheme,
        _tokens = tokens,
        _scrimGui = scrimGui,
        _screenGui = screenGui,
        _backdropScrim = backdropScrim,
        _blurEffect = blurEffect,
        _blurSize = blurSize,
        _scrimTrans = scrimTrans,
        _cardTrans = cardTrans,
        _monolith = monolith,
        _monolithCorner = monolithCorner,
        _monolithGrad = monolithGrad,
        _monolithStroke = monolithStroke,
        _topRim = topRim,
        _content = content,
        _stepLbl = stepLabel,
        _statusLbl = statusLbl,
        _percentLbl = percentLbl,
        _pctFmt = pctFmt,
        _fill = fill,
        _baseWidth = baseWidth,
        _baseHeight = baseHeight,
        _steps = steps,
        _duration = math.max(1.0, config.Duration or 3.2),
        _isDismissed = false,
        _isCancelled = false,
        _onCompleteCallbacks = {}
    }, Loader)

    -- Guarantee BlurEffect & Scrim cleanup even if ScreenGui is destroyed externally
    screenGui.Destroying:Connect(function()
        selfObj:_CleanupBlur()
        selfObj:_CleanupScrim()
    end)

    if config.SkipEntrance ~= true then
        selfObj:_PlayEntrance()
    end

    if config.AutoPlay ~= false then
        task.spawn(function()
            selfObj:Play()
        end)
    end

    return selfObj
end

function Loader:_CleanupBlur()
    if self._blurEffect then
        pcall(function() self._blurEffect:Destroy() end)
        self._blurEffect = nil
    end
end

function Loader:_CleanupScrim()
    if self._scrimGui then
        pcall(function() self._scrimGui:Destroy() end)
        self._scrimGui = nil
    end
    self._backdropScrim = nil
end

function Loader:Destroy()
    self._isCancelled = true
    self._isDismissed = true
    self:_CleanupBlur()
    self:_CleanupScrim()
    if self._screenGui then
        pcall(function() self._screenGui:Destroy() end)
        self._screenGui = nil
    end
end

function Loader:_PlayEntrance()
    local enterInfo = TweenInfo.new(0.36, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    self._monolith.Size = UDim2.new(0, self._baseWidth - 14, 0, self._baseHeight - 8)
    self._monolith.BackgroundTransparency = math.min(1, self._cardTrans + 0.35)
    TweenService:Create(self._monolith, enterInfo, {
        Size = UDim2.new(0, self._baseWidth, 0, self._baseHeight),
        BackgroundTransparency = self._cardTrans
    }):Play()

    if self._backdropScrim then
        TweenService:Create(self._backdropScrim, enterInfo, {
            BackgroundTransparency = self._scrimTrans
        }):Play()
    end

    if self._blurEffect and self._blurSize > 0 then
        TweenService:Create(self._blurEffect, enterInfo, {
            Size = self._blurSize
        }):Play()
    end
end

function Loader:SetProgress(ratio, statusText, stepLabelText)
    ratio = math.clamp(tonumber(ratio) or 0, 0, 1)
    local pct = math.floor(ratio * 100 + 0.5)
    self._percentLbl.Text = self._pctFmt and self._pctFmt.Format(pct) or (tostring(pct) .. "%")

    local totalSteps = #self._steps
    local matchedIndex = totalSteps
    local matchedStep = self._steps[totalSteps]

    for idx, s in ipairs(self._steps) do
        if ratio <= s.Threshold then
            matchedIndex = idx
            matchedStep = s
            break
        end
    end

    if statusText then
        self._statusLbl.Text = tostring(statusText)
    elseif ratio >= 1 then
        self._statusLbl.Text = "Ready"
    elseif matchedStep and matchedStep.Text then
        self._statusLbl.Text = matchedStep.Text
    end

    if self._stepLbl then
        if stepLabelText then
            self._stepLbl.Text = tostring(stepLabelText)
        elseif matchedStep and matchedStep.Step then
            self._stepLbl.Text = matchedStep.Step
        else
            self._stepLbl.Text = string.format("%02d / %02d", matchedIndex, totalSteps)
        end
    end

    TweenService:Create(
        self._fill,
        TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        { Size = UDim2.new(ratio, 0, 1, 0) }
    ):Play()
end

function Loader:Play(callback)
    local totalDuration = self._duration
    local startTime = os.clock()

    task.spawn(function()
        local currentRatio = 0
        while currentRatio < 1 and not self._isDismissed and not self._isCancelled do
            local elapsed = os.clock() - startTime
            local linearRatio = math.clamp(elapsed / totalDuration, 0, 1)

            -- Intentional non-linear progression curve across the 5 stages
            local curvedRatio
            if linearRatio < 0.24 then
                curvedRatio = (linearRatio / 0.24) * 0.22
            elseif linearRatio < 0.50 then
                curvedRatio = 0.22 + ((linearRatio - 0.24) / 0.26) * 0.26
            elseif linearRatio < 0.76 then
                curvedRatio = 0.48 + ((linearRatio - 0.50) / 0.26) * 0.24
            elseif linearRatio < 0.90 then
                curvedRatio = 0.72 + ((linearRatio - 0.76) / 0.14) * 0.16
            else
                curvedRatio = 0.88 + ((linearRatio - 0.90) / 0.10) * 0.12
            end

            currentRatio = math.clamp(curvedRatio, 0, 1)
            self:SetProgress(currentRatio)
            task.wait(0.03)
        end

        if not self._isDismissed and not self._isCancelled then
            self:SetProgress(1, "Ready", string.format("%02d / %02d", #self._steps, #self._steps))
            task.wait(0.28)
            if not self._isDismissed and not self._isCancelled then
                self:Dismiss(callback)
            end
        end
    end)
end

function Loader:OnComplete(callback)
    if typeof(callback) == "function" then
        if self._isDismissed and not self._isCancelled then
            callback()
        elseif not self._isCancelled then
            table.insert(self._onCompleteCallbacks, callback)
        end
    end
    return self
end

function Loader:_FadeOutContent(duration)
    local fadeInfo = TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    if self._topRim then
        TweenService:Create(self._topRim, fadeInfo, { BackgroundTransparency = 1 }):Play()
    end
    for _, inst in ipairs(self._content:GetDescendants()) do
        if inst:IsA("TextLabel") then
            TweenService:Create(inst, fadeInfo, { TextTransparency = 1 }):Play()
        elseif inst:IsA("ImageLabel") then
            TweenService:Create(inst, fadeInfo, { ImageTransparency = 1 }):Play()
        elseif inst:IsA("Frame") then
            TweenService:Create(inst, fadeInfo, { BackgroundTransparency = 1 }):Play()
        elseif inst:IsA("UIStroke") then
            TweenService:Create(inst, fadeInfo, { Transparency = 1 }):Play()
        end
    end
end

function Loader:_TweenOutBackground(tweenInfo)
    if self._backdropScrim then
        TweenService:Create(self._backdropScrim, tweenInfo, {
            BackgroundTransparency = 1
        }):Play()
    end
    if self._blurEffect then
        TweenService:Create(self._blurEffect, tweenInfo, {
            Size = 0
        }):Play()
    end
end

function Loader:Dismiss(callback)
    if self._isDismissed or self._isCancelled then return end
    self._isDismissed = true

    local targetFrame = self._config.TargetFrame
    local toggleOrb = self._config.ToggleOrb
    local morphTargetSize = (targetFrame and targetFrame.Size) or self._config.MorphSize or UDim2.new(0, 510, 0, 345)
    local morphTargetPos = (targetFrame and targetFrame.Position) or self._config.MorphPosition or UDim2.new(0.5, 0, 0.5, 0)
    local shouldMorph = (self._config.MorphToWindow ~= false)

    -- Step 1: Fade out internal telemetry, top rim & header cleanly
    self:_FadeOutContent(0.14)

    if shouldMorph then
        task.wait(0.08)
        if self._isCancelled or not self._screenGui or not self._screenGui.Parent then return end
        -- Step 2: Dimensional Morph in exact coordinate space + synchronized iOS blur clear
        local morphInfo = TweenInfo.new(0.36, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        self._monolithGrad.Color = self._theme.Main
        self:_TweenOutBackground(morphInfo)

        TweenService:Create(self._monolithCorner, morphInfo, {
            CornerRadius = UDim.new(0, 22)
        }):Play()

        TweenService:Create(self._monolithStroke, morphInfo, {
            Color = self._theme.GlassRim or self._theme.Stroke,
            Thickness = 1.3,
            Transparency = 0.25
        }):Play()

        local morphTween = TweenService:Create(self._monolith, morphInfo, {
            Size = morphTargetSize,
            Position = morphTargetPos,
            BackgroundTransparency = 0.14
        })
        morphTween:Play()

        morphTween.Completed:Connect(function()
            self:_CleanupBlur()
            self:_CleanupScrim()
            if self._isCancelled then return end

            if targetFrame and targetFrame.Parent then
                targetFrame.Visible = true
            end
            if toggleOrb and toggleOrb.Parent then
                local orbTargetSize = self._config.ToggleOrbSize or UDim2.new(0, 52, 0, 52)
                toggleOrb.Size = UDim2.new(0, 0, 0, 0)
                toggleOrb.Visible = true
                TweenService:Create(
                    toggleOrb,
                    TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    { Size = orbTargetSize }
                ):Play()
            end

            if typeof(callback) == "function" then callback() end
            for _, cb in ipairs(self._onCompleteCallbacks) do
                pcall(cb)
            end

            -- Yield one heartbeat so target window renders cleanly underneath before crossfade
            task.wait()
            if self._isCancelled or not self._screenGui or not self._screenGui.Parent then return end
            local revealInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            TweenService:Create(self._monolithStroke, revealInfo, { Transparency = 1 }):Play()
            local fadeShell = TweenService:Create(self._monolith, revealInfo, {
                BackgroundTransparency = 1
            })
            fadeShell:Play()
            fadeShell.Completed:Connect(function()
                pcall(function()
                    if self._screenGui then self._screenGui:Destroy() end
                end)
            end)
        end)
    else
        -- Clean dissolve fallback when MorphToWindow = false
        local exitInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        self:_TweenOutBackground(exitInfo)

        local closeTween = TweenService:Create(self._monolith, exitInfo, {
            Size = UDim2.new(0, self._baseWidth - 12, 0, self._baseHeight - 8),
            BackgroundTransparency = 1
        })
        TweenService:Create(self._monolithStroke, exitInfo, { Transparency = 1 }):Play()
        closeTween:Play()

        closeTween.Completed:Connect(function()
            self:_CleanupBlur()
            self:_CleanupScrim()
            pcall(function()
                if self._screenGui then self._screenGui:Destroy() end
            end)
            if self._isCancelled then return end
            if typeof(callback) == "function" then callback() end
            for _, cb in ipairs(self._onCompleteCallbacks) do
                pcall(cb)
            end
        end)
    end
end

return Loader
