-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY - MODULE: StatusBar.lua ]
-- Floating, draggable top-right telemetry pill (Avatar, Ping, FPS, Players)
-- with an animated expandable Nearby Players drawer, responsive clamping,
-- and full live theme synchronization.
-- ==============================================================================

local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")

local ICON_PING = "rbxassetid://85991442119968"
local ICON_FPS = "rbxassetid://136228823216967"
local ICON_PLAYERS = "rbxassetid://103676501054440"
local ICON_NEARBY = "rbxassetid://77254416579526"

local PILL_HEIGHT = 34
local PILL_GAP = 6
local DIVIDER_W = 1
local DRAWER_HEADER_HEIGHT = 34
local DRAWER_ROW_HEIGHT = 32
local DRAWER_ROW_PAD = 2
local DRAWER_MAX_HEIGHT = 252
local DRAWER_GAP = 6
local EDGE_MARGIN = 8
local DRAG_THRESHOLD_PX = 5
local FPS_REFRESH_INTERVAL = 0.50
local DISTANCE_REFRESH_INTERVAL = 0.35
local DEFAULT_STUDS_TO_METERS = 0.28

local StatusBar = {}

local function resolveAccent(theme)
    local accent = (theme and theme.Accent) or Color3.fromRGB(64, 168, 255)
    local luma = accent.R * 0.299 + accent.G * 0.587 + accent.B * 0.114
    if luma < 0.45 and theme then
        local fallback = theme.Accent2 or theme.GlassRim or Color3.fromRGB(228, 234, 244)
        local rim = theme.GlassRim or Color3.fromRGB(255, 255, 255)
        return fallback:Lerp(rim, 0.35)
    end
    return accent
end

local function computeSurfaceBg(theme)
    local black = Color3.fromRGB(15, 15, 18)
    local tint = (theme and (theme.DropBg or theme.RowBg)) or black
    return black:Lerp(tint, 0.22)
end

local function getCharacterRootPos(playerObj)
    if not playerObj then return nil end
    local char = nil
    local okChar = pcall(function()
        char = playerObj.Character
    end)
    if not okChar or not char then return nil end

    local root = nil
    pcall(function()
        root = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
    end)
    if root and typeof(root) == "Instance" and root:IsA("BasePart") then
        return root.Position
    end
    return nil
end

local function createThemedIcon(assetId, fallbackGlyph, sizePx, initialColor, connections, zBase)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(0, sizePx, 0, sizePx)
    holder.BackgroundTransparency = 1
    holder.BorderSizePixel = 0
    holder.ZIndex = zBase

    local img = Instance.new("ImageLabel")
    img.Name = "Icon"
    img.Size = UDim2.fromScale(1, 1)
    img.BackgroundTransparency = 1
    img.BorderSizePixel = 0
    img.ScaleType = Enum.ScaleType.Fit
    img.Image = assetId
    img.ImageColor3 = initialColor
    img.ZIndex = zBase
    img.Parent = holder

    local fallback = Instance.new("TextLabel")
    fallback.Name = "Fallback"
    fallback.Size = UDim2.fromScale(1, 1)
    fallback.BackgroundTransparency = 1
    fallback.Font = Enum.Font.GothamBold
    fallback.TextSize = math.max(10, sizePx - 2)
    fallback.TextColor3 = initialColor
    fallback.Text = fallbackGlyph
    fallback.Visible = false
    fallback.ZIndex = zBase
    fallback.Parent = holder

    local okConn, loadedConn = pcall(function()
        return img:GetPropertyChangedSignal("IsLoaded"):Connect(function()
            local loaded = false
            pcall(function() loaded = img.IsLoaded end)
            if loaded then
                fallback.Visible = false
            end
        end)
    end)
    if okConn and loadedConn then
        table.insert(connections, loadedConn)
    end

    task.spawn(function()
        local loaded = false
        pcall(function() loaded = img.IsLoaded end)
        if loaded then return end

        local fetchedOk = false
        pcall(function()
            ContentProvider:PreloadAsync({ img }, function(_, status)
                if status == Enum.AssetFetchStatus.Success then
                    fetchedOk = true
                end
            end)
        end)

        if not img or not img.Parent then return end
        pcall(function() loaded = img.IsLoaded end)
        if loaded or fetchedOk then
            fallback.Visible = false
        else
            fallback.Visible = true
        end
    end)

    return holder, img, fallback
end

local function readPingMs(localPlr)
    local okStats, netVal = pcall(function()
        local net = Stats and Stats:FindFirstChild("Network")
        local serverStats = net and net:FindFirstChild("ServerStatsItem")
        local dataPing = serverStats and serverStats:FindFirstChild("Data Ping")
        if dataPing and type(dataPing.GetValue) == "function" then
            return dataPing:GetValue()
        end
        return nil
    end)
    if okStats and type(netVal) == "number" and netVal > 0 then
        return netVal
    end
    if localPlr then
        local okPlr, pingSec = pcall(function()
            return localPlr:GetNetworkPing()
        end)
        if okPlr and type(pingSec) == "number" and pingSec > 0 then
            return pingSec * 1000
        end
    end
    return nil
end

function StatusBar:Create(ctx, config)
    config = config or {}
    local Animations = ctx.Animations
    local Utils = ctx.Utils
    local sharedState = ctx.State
    local screenGui = ctx.ScreenGui
    local activeTheme = ctx.ActiveTheme

    if Utils and Utils.ElevateIdentity then
        Utils:ElevateIdentity(7)
    end

    local isAlive = true
    local localConns = {}
    local isExpanded = false
    local isDirty = true
    local hasDragged = false
    local isVisible = (config.StatusBarVisible ~= false)
    local isFlippedUp = false
    local normRight = 1.0
    local normTop = 0.0
    local activeDrawerTween = nil
    local thumbCache = {}
    local rowPool = {}
    local currentRowCount = 0
    local studsToMeters = tonumber(config.StudsToMeters) or DEFAULT_STUDS_TO_METERS
    local playersProvider = (type(config.StatusBarPlayersProvider) == "function") and config.StatusBarPlayersProvider or nil

    local semiBoldWeight = nil
    local boldWeight = nil
    pcall(function()
        semiBoldWeight = Enum.FontWeight.SemiBold
        boldWeight = Enum.FontWeight.Bold
    end)

    local pingFmt = Utils:CreateNumericFormatter(0, 999, 1, "", {
        TextSize = 11,
        Weight = boldWeight,
        Padding = 2
    })
    local fpsFmt = Utils:CreateNumericFormatter(0, 999, 1, "", {
        TextSize = 11,
        Weight = boldWeight,
        Padding = 2
    })
    local countFmt = Utils:CreateNumericFormatter(0, 999, 1, "", {
        TextSize = 11,
        Weight = boldWeight,
        Padding = 2
    })

    local msUnitW = math.ceil(Utils:MeasureTextWidth("ms", 11, nil, Enum.Font.GothamMedium)) + 2
    local fpsUnitW = math.ceil(Utils:MeasureTextWidth("fps", 11, nil, Enum.Font.GothamMedium)) + 2
    local playersWordW = math.ceil(Utils:MeasureTextWidth("players", 11, nil, Enum.Font.GothamMedium)) + 2

    local pingSectionW = 14 + 4 + pingFmt.ReservedWidth + 2 + msUnitW
    local fpsSectionW = 14 + 4 + fpsFmt.ReservedWidth + 2 + fpsUnitW
    local playersBtnW = 5 + 14 + 4 + countFmt.ReservedWidth + 3 + playersWordW + 6
    local pillWidth = 12 + 22 + PILL_GAP + pingSectionW + PILL_GAP + DIVIDER_W + PILL_GAP
        + fpsSectionW + PILL_GAP + DIVIDER_W + PILL_GAP + playersBtnW

    local initialAccent = resolveAccent(activeTheme)
    local initialSurface = computeSurfaceBg(activeTheme)
    local initialStrokeColor = initialAccent

    local root = Instance.new("Frame")
    root.Name = "SyntaxisStatusBar"
    root.AnchorPoint = Vector2.new(1, 0)
    root.Position = config.StatusBarPosition or UDim2.new(1, -14, 0, 8)
    root.Size = UDim2.new(0, pillWidth, 0, PILL_HEIGHT)
    root.BackgroundTransparency = 1
    root.BorderSizePixel = 0
    root.Visible = isVisible
    root.ZIndex = 40

    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 1
    uiScale.Parent = root

    -- Top Status Pill
    local pill = Instance.new("Frame")
    pill.Name = "StatusPill"
    pill.Size = UDim2.fromScale(1, 1)
    pill.BackgroundColor3 = initialSurface
    pill.BackgroundTransparency = 0.08
    pill.BorderSizePixel = 0
    pill.Active = true
    pill.ZIndex = 41
    pill.Parent = root
    Utils:RoundCorner(pill, 999)

    local pillStroke = Instance.new("UIStroke")
    pillStroke.Thickness = 1.3
    pillStroke.Transparency = 0.25
    pillStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    pillStroke.Color = initialStrokeColor
    pillStroke.Parent = pill

    local pillContent = Instance.new("Frame")
    pillContent.Name = "Content"
    pillContent.Size = UDim2.new(1, -12, 1, 0)
    pillContent.Position = UDim2.new(0, 6, 0, 0)
    pillContent.BackgroundTransparency = 1
    pillContent.ZIndex = 42
    pillContent.Parent = pill

    local pillLayout = Instance.new("UIListLayout")
    pillLayout.FillDirection = Enum.FillDirection.Horizontal
    pillLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    pillLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pillLayout.Padding = UDim.new(0, PILL_GAP)
    pillLayout.Parent = pillContent

    -- 1. Avatar Headshot Badge
    local avatarHolder = Instance.new("Frame")
    avatarHolder.Name = "Avatar"
    avatarHolder.Size = UDim2.new(0, 22, 0, 22)
    avatarHolder.BackgroundColor3 = Color3.fromRGB(36, 40, 52)
    avatarHolder.BorderSizePixel = 0
    avatarHolder.LayoutOrder = 1
    avatarHolder.ZIndex = 43
    avatarHolder.Parent = pillContent
    Utils:RoundCorner(avatarHolder, 999)

    local avatarInitial = Instance.new("TextLabel")
    avatarInitial.Size = UDim2.fromScale(1, 1)
    avatarInitial.BackgroundTransparency = 1
    avatarInitial.Font = Enum.Font.GothamBold
    avatarInitial.TextSize = 10
    avatarInitial.TextColor3 = Color3.fromRGB(255, 255, 255)
    avatarInitial.Text = "?"
    avatarInitial.ZIndex = 43
    avatarInitial.Parent = avatarHolder

    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size = UDim2.fromScale(1, 1)
    avatarImg.BackgroundTransparency = 1
    avatarImg.BorderSizePixel = 0
    avatarImg.ScaleType = Enum.ScaleType.Crop
    avatarImg.ZIndex = 44
    avatarImg.Parent = avatarHolder
    Utils:RoundCorner(avatarImg, 999)

    local function bindAvatarThumbnail(plr, holderFrame, imgLbl, initLbl)
        local disp = "S"
        local uid = 0
        pcall(function()
            disp = tostring(plr.DisplayName or plr.Name or "P")
            uid = tonumber(plr.UserId) or 0
        end)
        initLbl.Text = string.upper(string.sub(disp, 1, 1))
        if uid > 0 then
            if not thumbCache[uid] then
                thumbCache[uid] = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(uid) .. "&w=100&h=100"
            end
            imgLbl.Image = thumbCache[uid]
            local loaded = false
            pcall(function() loaded = imgLbl.IsLoaded end)
            initLbl.Visible = not loaded
            local okC, c = pcall(function()
                return imgLbl:GetPropertyChangedSignal("IsLoaded"):Connect(function()
                    local isOk = false
                    pcall(function() isOk = imgLbl.IsLoaded end)
                    initLbl.Visible = not isOk
                end)
            end)
            if okC and c then
                table.insert(localConns, c)
            end
        else
            imgLbl.Image = ""
            initLbl.Visible = true
        end
    end

    -- Helper for Ping & FPS segments
    local function createMetricSegment(name, iconAsset, fallbackGlyph, valWidth, unitText, unitWidth, orderIdx)
        local seg = Instance.new("Frame")
        seg.Name = name
        seg.Size = UDim2.new(0, 14 + 4 + valWidth + 2 + unitWidth, 1, 0)
        seg.BackgroundTransparency = 1
        seg.LayoutOrder = orderIdx
        seg.ZIndex = 42
        seg.Parent = pillContent

        local iconHolder, iconImg, iconFallback = createThemedIcon(iconAsset, fallbackGlyph, 14, initialAccent, localConns, 43)
        iconHolder.AnchorPoint = Vector2.new(0, 0.5)
        iconHolder.Position = UDim2.new(0, 0, 0.5, 0)
        iconHolder.Parent = seg

        local valLbl = Instance.new("TextLabel")
        valLbl.Name = "Value"
        valLbl.Size = UDim2.new(0, valWidth, 1, 0)
        valLbl.Position = UDim2.new(0, 18, 0, 0)
        valLbl.BackgroundTransparency = 1
        valLbl.TextSize = 11
        valLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.TextYAlignment = Enum.TextYAlignment.Center
        valLbl.Text = "--"
        valLbl.ZIndex = 43
        Utils:ApplyTabularFont(valLbl, boldWeight)
        valLbl.Parent = seg

        local unitLbl = Instance.new("TextLabel")
        unitLbl.Name = "Unit"
        unitLbl.Size = UDim2.new(0, unitWidth, 1, 0)
        unitLbl.Position = UDim2.new(0, 18 + valWidth + 2, 0, 0)
        unitLbl.BackgroundTransparency = 1
        unitLbl.Font = Enum.Font.GothamMedium
        unitLbl.TextSize = 11
        unitLbl.TextColor3 = activeTheme.SubText
        unitLbl.TextXAlignment = Enum.TextXAlignment.Left
        unitLbl.TextYAlignment = Enum.TextYAlignment.Center
        unitLbl.Text = unitText
        unitLbl.ZIndex = 43
        unitLbl.Parent = seg

        return iconImg, iconFallback, valLbl, unitLbl
    end

    local function createDivider(orderIdx)
        local div = Instance.new("Frame")
        div.Name = "Divider"
        div.Size = UDim2.new(0, DIVIDER_W, 0, 14)
        div.BackgroundColor3 = activeTheme.Stroke
        div.BackgroundTransparency = 0.60
        div.BorderSizePixel = 0
        div.LayoutOrder = orderIdx
        div.ZIndex = 42
        div.Parent = pillContent
        return div
    end

    local pingIcon, pingFallback, pingValLbl, pingUnitLbl = createMetricSegment("PingSegment", ICON_PING, "~", pingFmt.ReservedWidth, "ms", msUnitW, 2)
    local div1 = createDivider(3)
    local fpsIcon, fpsFallback, fpsValLbl, fpsUnitLbl = createMetricSegment("FpsSegment", ICON_FPS, "*", fpsFmt.ReservedWidth, "fps", fpsUnitW, 4)
    local div2 = createDivider(5)

    -- Interactive Players segment button
    local playersBtn = Instance.new("TextButton")
    playersBtn.Name = "PlayersButton"
    playersBtn.Size = UDim2.new(0, playersBtnW, 0, 26)
    playersBtn.BackgroundColor3 = initialAccent
    playersBtn.BackgroundTransparency = 1
    playersBtn.BorderSizePixel = 0
    playersBtn.AutoButtonColor = false
    playersBtn.Text = ""
    playersBtn.LayoutOrder = 6
    playersBtn.ZIndex = 43
    playersBtn.Parent = pillContent
    Utils:RoundCorner(playersBtn, 999)

    local _, playersIcon, playersFallback = createThemedIcon(ICON_PLAYERS, "@", 14, initialAccent, localConns, 44)
    playersIcon.Parent.AnchorPoint = Vector2.new(0, 0.5)
    playersIcon.Parent.Position = UDim2.new(0, 5, 0.5, 0)
    playersIcon.Parent.Parent = playersBtn

    local playersCountLbl = Instance.new("TextLabel")
    playersCountLbl.Name = "CountValue"
    playersCountLbl.Size = UDim2.new(0, countFmt.ReservedWidth, 1, 0)
    playersCountLbl.Position = UDim2.new(0, 23, 0, 0)
    playersCountLbl.BackgroundTransparency = 1
    playersCountLbl.TextSize = 11
    playersCountLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    playersCountLbl.TextXAlignment = Enum.TextXAlignment.Right
    playersCountLbl.TextYAlignment = Enum.TextYAlignment.Center
    playersCountLbl.Text = "1"
    playersCountLbl.ZIndex = 44
    Utils:ApplyTabularFont(playersCountLbl, boldWeight)
    playersCountLbl.Parent = playersBtn

    local playersWordLbl = Instance.new("TextLabel")
    playersWordLbl.Name = "PlayersWord"
    playersWordLbl.Size = UDim2.new(0, playersWordW, 1, 0)
    playersWordLbl.Position = UDim2.new(0, 23 + countFmt.ReservedWidth + 3, 0, 0)
    playersWordLbl.BackgroundTransparency = 1
    playersWordLbl.Font = Enum.Font.GothamMedium
    playersWordLbl.TextSize = 11
    playersWordLbl.TextColor3 = activeTheme.SubText
    playersWordLbl.TextXAlignment = Enum.TextXAlignment.Left
    playersWordLbl.TextYAlignment = Enum.TextYAlignment.Center
    playersWordLbl.Text = "players"
    playersWordLbl.ZIndex = 44
    playersWordLbl.Parent = playersBtn

    -- Expandable Nearby Players Drawer
    local drawer = Instance.new("Frame")
    drawer.Name = "NearbyPlayersDrawer"
    drawer.AnchorPoint = Vector2.new(1, 0)
    drawer.Position = UDim2.new(1, 0, 1, DRAWER_GAP)
    drawer.Size = UDim2.new(0, pillWidth, 0, 0)
    drawer.BackgroundColor3 = initialSurface
    drawer.BackgroundTransparency = 0.06
    drawer.BorderSizePixel = 0
    drawer.ClipsDescendants = true
    drawer.Visible = false
    drawer.Active = true
    drawer.ZIndex = 45
    drawer.Parent = root
    Utils:RoundCorner(drawer, 14)

    local drawerStroke = Instance.new("UIStroke")
    drawerStroke.Thickness = 1.2
    drawerStroke.Transparency = 0.28
    drawerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    drawerStroke.Color = initialStrokeColor
    drawerStroke.Parent = drawer

    local drawerHeader = Instance.new("Frame")
    drawerHeader.Name = "Header"
    drawerHeader.Size = UDim2.new(1, 0, 0, DRAWER_HEADER_HEIGHT)
    drawerHeader.BackgroundTransparency = 1
    drawerHeader.ZIndex = 46
    drawerHeader.Parent = drawer

    local nearbyIconHolder, nearbyIcon, nearbyFallback = createThemedIcon(ICON_NEARBY, "P", 14, initialAccent, localConns, 47)
    nearbyIconHolder.AnchorPoint = Vector2.new(0, 0.5)
    nearbyIconHolder.Position = UDim2.new(0, 12, 0.5, 0)
    nearbyIconHolder.Parent = drawerHeader

    local nearbyTitle = Instance.new("TextLabel")
    nearbyTitle.Size = UDim2.new(1, -36, 1, 0)
    nearbyTitle.Position = UDim2.new(0, 32, 0, 0)
    nearbyTitle.BackgroundTransparency = 1
    nearbyTitle.Font = Enum.Font.GothamMedium
    nearbyTitle.TextSize = 11.5
    nearbyTitle.TextColor3 = activeTheme.SubText
    nearbyTitle.TextXAlignment = Enum.TextXAlignment.Left
    nearbyTitle.TextYAlignment = Enum.TextYAlignment.Center
    nearbyTitle.Text = "Nearby players"
    nearbyTitle.ZIndex = 47
    nearbyTitle.Parent = drawerHeader

    local headerDiv = Instance.new("Frame")
    headerDiv.Name = "HeaderDivider"
    headerDiv.Size = UDim2.new(1, 0, 0, 1)
    headerDiv.Position = UDim2.new(0, 0, 0, DRAWER_HEADER_HEIGHT)
    headerDiv.BackgroundColor3 = activeTheme.Stroke
    headerDiv.BackgroundTransparency = 0.65
    headerDiv.BorderSizePixel = 0
    headerDiv.ZIndex = 46
    headerDiv.Parent = drawer

    local playerScroll = Instance.new("ScrollingFrame")
    playerScroll.Name = "PlayerList"
    playerScroll.Position = UDim2.new(0, 0, 0, DRAWER_HEADER_HEIGHT + 1)
    playerScroll.Size = UDim2.new(1, 0, 1, -(DRAWER_HEADER_HEIGHT + 1))
    playerScroll.BackgroundTransparency = 1
    playerScroll.BorderSizePixel = 0
    playerScroll.ScrollBarThickness = 2
    playerScroll.ScrollBarImageColor3 = initialAccent
    playerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    playerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    playerScroll.ZIndex = 46
    playerScroll.Parent = drawer

    local scrollPad = Instance.new("UIPadding")
    scrollPad.PaddingTop = UDim.new(0, 4)
    scrollPad.PaddingBottom = UDim.new(0, 6)
    scrollPad.PaddingLeft = UDim.new(0, 8)
    scrollPad.PaddingRight = UDim.new(0, 8)
    scrollPad.Parent = playerScroll

    local scrollLayout = Instance.new("UIListLayout")
    scrollLayout.Padding = UDim.new(0, DRAWER_ROW_PAD)
    scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    scrollLayout.Parent = playerScroll

    -- Resolve LocalPlayer cleanly without yielding main thread
    local cachedLocalPlayer = nil
    pcall(function() cachedLocalPlayer = Players.LocalPlayer end)
    if cachedLocalPlayer then
        bindAvatarThumbnail(cachedLocalPlayer, avatarHolder, avatarImg, avatarInitial)
    else
        task.spawn(function()
            local deadline = os.clock() + 10
            while isAlive and not cachedLocalPlayer and os.clock() < deadline do
                pcall(function() cachedLocalPlayer = Players.LocalPlayer end)
                if cachedLocalPlayer then
                    bindAvatarThumbnail(cachedLocalPlayer, avatarHolder, avatarImg, avatarInitial)
                    break
                end
                task.wait(0.2)
            end
        end)
    end

    local function getPlayersList(excludedPlr)
        local raw = playersProvider and playersProvider() or Players:GetPlayers()
        local list = {}
        for _, p in ipairs(raw) do
            if p ~= excludedPlr then
                table.insert(list, p)
            end
        end
        return list
    end

    local function updateResponsiveScaleAndClamp()
        if not screenGui or not screenGui.Parent or not root or not root.Parent then return end
        local viewSize = screenGui.AbsoluteSize
        local viewW = viewSize.X
        local viewH = viewSize.Y
        if viewW <= 0 or viewH <= 0 then return end

        local nextScale = math.min(1, math.max(0.72, (viewW - (EDGE_MARGIN * 2)) / pillWidth))
        uiScale.Scale = nextScale

        local scaledW = pillWidth * nextScale
        local scaledH = PILL_HEIGHT * nextScale
        if hasDragged then
            local targetRight = math.clamp(normRight * viewW, scaledW + EDGE_MARGIN, math.max(scaledW + EDGE_MARGIN, viewW - EDGE_MARGIN))
            local targetTop = math.clamp(normTop * viewH, EDGE_MARGIN, math.max(EDGE_MARGIN, viewH - scaledH - EDGE_MARGIN))
            normRight = targetRight / viewW
            normTop = targetTop / viewH
            root.AnchorPoint = Vector2.new(1, 0)
            root.Position = UDim2.new(normRight, 0, normTop, 0)
        end
    end

    local function computeDrawerTargetMetrics()
        local scale = math.max(uiScale.Scale, 0.5)
        local rowsHeight = currentRowCount * DRAWER_ROW_HEIGHT + math.max(0, currentRowCount - 1) * DRAWER_ROW_PAD + 10
        local desiredUnscaled = DRAWER_HEADER_HEIGHT + 1 + math.min(math.max(DRAWER_ROW_HEIGHT + 10, rowsHeight), DRAWER_MAX_HEIGHT)

        if not screenGui or not screenGui.Parent then
            isFlippedUp = false
            return desiredUnscaled
        end

        local guiOriginY = screenGui.AbsolutePosition.Y
        local viewH = screenGui.AbsoluteSize.Y
        local relTop = pill.AbsolutePosition.Y - guiOriginY
        local relBot = relTop + pill.AbsoluteSize.Y
        local spaceBelow = (viewH - EDGE_MARGIN - (relBot + DRAWER_GAP * scale)) / scale
        local spaceAbove = ((relTop - DRAWER_GAP * scale) - EDGE_MARGIN) / scale

        if spaceBelow >= desiredUnscaled or spaceBelow >= spaceAbove then
            isFlippedUp = false
            drawer.AnchorPoint = Vector2.new(1, 0)
            drawer.Position = UDim2.new(1, 0, 1, DRAWER_GAP)
            return math.min(desiredUnscaled, math.max(DRAWER_HEADER_HEIGHT + 44, spaceBelow))
        else
            isFlippedUp = true
            drawer.AnchorPoint = Vector2.new(1, 1)
            drawer.Position = UDim2.new(1, 0, 0, -DRAWER_GAP)
            return math.min(desiredUnscaled, math.max(DRAWER_HEADER_HEIGHT + 44, spaceAbove))
        end
    end

    local function updatePlayerCountDisplay(excludedPlr)
        local list = getPlayersList(excludedPlr)
        local count = #list
        playersCountLbl.Text = countFmt.Format(count)
        playersWordLbl.Text = (count == 1) and "player" or "players"
        return list
    end

    local function createOrUpdatePlayerRow(plr)
        local entry = rowPool[plr]
        local dispName = "Player"
        pcall(function() dispName = tostring(plr.DisplayName or plr.Name or "Player") end)

        if not entry then
            local row = Instance.new("Frame")
            row.Name = "Row_" .. dispName
            row.Size = UDim2.new(1, 0, 0, DRAWER_ROW_HEIGHT)
            row.BackgroundTransparency = 1
            row.BorderSizePixel = 0
            row.ZIndex = 47

            local rowAvatar = Instance.new("Frame")
            rowAvatar.Size = UDim2.new(0, 22, 0, 22)
            rowAvatar.AnchorPoint = Vector2.new(0, 0.5)
            rowAvatar.Position = UDim2.new(0, 4, 0.5, 0)
            rowAvatar.BackgroundColor3 = Color3.fromRGB(36, 40, 52)
            rowAvatar.BorderSizePixel = 0
            rowAvatar.ZIndex = 48
            rowAvatar.Parent = row
            Utils:RoundCorner(rowAvatar, 999)

            local rowInitial = Instance.new("TextLabel")
            rowInitial.Size = UDim2.fromScale(1, 1)
            rowInitial.BackgroundTransparency = 1
            rowInitial.Font = Enum.Font.GothamBold
            rowInitial.TextSize = 10
            rowInitial.TextColor3 = Color3.fromRGB(255, 255, 255)
            rowInitial.ZIndex = 48
            rowInitial.Parent = rowAvatar

            local rowAvatarImg = Instance.new("ImageLabel")
            rowAvatarImg.Size = UDim2.fromScale(1, 1)
            rowAvatarImg.BackgroundTransparency = 1
            rowAvatarImg.BorderSizePixel = 0
            rowAvatarImg.ScaleType = Enum.ScaleType.Crop
            rowAvatarImg.ZIndex = 49
            rowAvatarImg.Parent = rowAvatar
            Utils:RoundCorner(rowAvatarImg, 999)

            bindAvatarThumbnail(plr, rowAvatar, rowAvatarImg, rowInitial)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(1, -92, 1, 0)
            nameLbl.Position = UDim2.new(0, 34, 0, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Font = Enum.Font.GothamSemibold
            nameLbl.TextSize = 11.5
            nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.TextYAlignment = Enum.TextYAlignment.Center
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            nameLbl.Text = dispName
            nameLbl.ZIndex = 48
            nameLbl.Parent = row

            local distLbl = Instance.new("TextLabel")
            distLbl.Size = UDim2.new(0, 52, 1, 0)
            distLbl.AnchorPoint = Vector2.new(1, 0)
            distLbl.Position = UDim2.new(1, -4, 0, 0)
            distLbl.BackgroundTransparency = 1
            distLbl.TextSize = 11
            distLbl.TextColor3 = activeTheme.SubText
            distLbl.TextXAlignment = Enum.TextXAlignment.Right
            distLbl.TextYAlignment = Enum.TextYAlignment.Center
            distLbl.Text = "--"
            distLbl.ZIndex = 48
            Utils:ApplyTabularFont(distLbl, semiBoldWeight)
            distLbl.Parent = row

            pcall(function() row.Parent = playerScroll end)

            entry = {
                Player = plr,
                Row = row,
                NameLabel = nameLbl,
                DistLabel = distLbl,
                DisplayName = dispName,
                IsSelf = (plr == cachedLocalPlayer)
            }
            rowPool[plr] = entry
        else
            entry.DisplayName = dispName
            entry.IsSelf = (plr == cachedLocalPlayer)
            entry.NameLabel.Text = dispName
        end

        return entry
    end

    local function updateRowsAndDistances(excludedPlr)
        if not isAlive then return end
        if Utils and Utils.ElevateIdentity then
            Utils:ElevateIdentity(7)
        end
        pcall(function() cachedLocalPlayer = cachedLocalPlayer or Players.LocalPlayer end)

        local currentList = getPlayersList(excludedPlr)
        local activeSet = {}
        local sortable = {}

        local localPos = getCharacterRootPos(cachedLocalPlayer)
        local currentAccent = resolveAccent(ctx.ActiveTheme)

        for _, plr in ipairs(currentList) do
            activeSet[plr] = true
            local entry = createOrUpdatePlayerRow(plr)
            local distMeters = nil

            if entry.IsSelf then
                entry.DistLabel.Text = "you"
                entry.DistLabel.TextColor3 = currentAccent
            else
                local targetPos = getCharacterRootPos(plr)
                if localPos and targetPos then
                    local studs = (localPos - targetPos).Magnitude
                    distMeters = math.floor(studs * studsToMeters + 0.5)
                    entry.DistLabel.Text = tostring(distMeters) .. "m"
                else
                    entry.DistLabel.Text = "--"
                end
                entry.DistLabel.TextColor3 = ctx.ActiveTheme.SubText
            end

            table.insert(sortable, {
                Entry = entry,
                IsSelf = entry.IsSelf,
                Dist = distMeters,
                Name = entry.DisplayName
            })
        end

        for plr, entry in pairs(rowPool) do
            if not activeSet[plr] then
                pcall(function() entry.Row:Destroy() end)
                rowPool[plr] = nil
            end
        end

        table.sort(sortable, function(a, b)
            if a.IsSelf ~= b.IsSelf then
                return a.IsSelf == true
            end
            if a.Dist ~= nil and b.Dist ~= nil then
                if a.Dist ~= b.Dist then
                    return a.Dist < b.Dist
                end
            elseif (a.Dist ~= nil) ~= (b.Dist ~= nil) then
                return a.Dist ~= nil
            end
            return a.Name < b.Name
        end)

        for idx, item in ipairs(sortable) do
            item.Entry.Row.LayoutOrder = item.IsSelf and 0 or idx
        end

        currentRowCount = #sortable
        isDirty = false
    end

    local function setExpanded(expand)
        expand = (expand == true)
        if isExpanded == expand then return end
        isExpanded = expand

        if activeDrawerTween then
            pcall(function() activeDrawerTween:Cancel() end)
            activeDrawerTween = nil
        end

        if isExpanded then
            updatePlayerCountDisplay(nil)
            updateRowsAndDistances(nil)
            local targetH = computeDrawerTargetMetrics()
            drawer.Size = UDim2.new(0, pillWidth, 0, 0)
            drawer.Visible = true
            Animations:Tween(playersBtn, Animations.Fast, { BackgroundTransparency = 0.84 })
            local tw = Animations:Tween(drawer, Animations.Drop, { Size = UDim2.new(0, pillWidth, 0, targetH) })
            activeDrawerTween = tw
            if tw then
                pcall(function()
                    tw.Completed:Connect(function(playbackState)
                        if activeDrawerTween == tw and playbackState == Enum.PlaybackState.Completed then
                            activeDrawerTween = nil
                        end
                    end)
                end)
            end
        else
            Animations:Tween(playersBtn, Animations.Fast, { BackgroundTransparency = 1 })
            local tw = Animations:Tween(drawer, Animations.Fast, { Size = UDim2.new(0, pillWidth, 0, 0) })
            activeDrawerTween = tw
            if tw then
                pcall(function()
                    tw.Completed:Connect(function(playbackState)
                        if activeDrawerTween ~= tw or playbackState ~= Enum.PlaybackState.Completed then
                            return
                        end
                        activeDrawerTween = nil
                        if not isExpanded and drawer then
                            drawer.Visible = false
                        end
                    end)
                end)
            else
                drawer.Visible = false
            end
        end
    end

    local function applyThemeColors(t)
        if not isAlive or not root or not root.Parent then return end
        local orbAccent = resolveAccent(t)
        local surface = computeSurfaceBg(t)

        pill.BackgroundColor3 = surface
        pillStroke.Color = orbAccent
        drawer.BackgroundColor3 = surface
        drawerStroke.Color = orbAccent

        pingIcon.ImageColor3 = orbAccent
        pingFallback.TextColor3 = orbAccent
        fpsIcon.ImageColor3 = orbAccent
        fpsFallback.TextColor3 = orbAccent
        playersIcon.ImageColor3 = orbAccent
        playersFallback.TextColor3 = orbAccent
        nearbyIcon.ImageColor3 = orbAccent
        nearbyFallback.TextColor3 = orbAccent

        playersBtn.BackgroundColor3 = orbAccent
        playerScroll.ScrollBarImageColor3 = orbAccent
        pingUnitLbl.TextColor3 = t.SubText
        fpsUnitLbl.TextColor3 = t.SubText
        playersWordLbl.TextColor3 = t.SubText
        nearbyTitle.TextColor3 = t.SubText
        div1.BackgroundColor3 = t.Stroke
        div2.BackgroundColor3 = t.Stroke
        headerDiv.BackgroundColor3 = t.Stroke

        for _, entry in pairs(rowPool) do
            if entry.IsSelf then
                entry.DistLabel.TextColor3 = orbAccent
            else
                entry.DistLabel.TextColor3 = t.SubText
            end
        end
    end

    local StatusBarObj = {
        Root = root,
        Pill = pill,
        Drawer = drawer
    }

    local themeSubFn = nil
    local function removeThemeSubscriber()
        if not themeSubFn or not sharedState or not sharedState.themeSubscribers then return end
        for i = #sharedState.themeSubscribers, 1, -1 do
            if sharedState.themeSubscribers[i] == themeSubFn then
                table.remove(sharedState.themeSubscribers, i)
            end
        end
        themeSubFn = nil
    end

    themeSubFn = function(t)
        if not isAlive or not ctx.IsAlive or not root or not root.Parent then
            removeThemeSubscriber()
            return
        end
        applyThemeColors(t)
    end
    table.insert(sharedState.themeSubscribers, themeSubFn)

    -- Dragging + Click Disambiguation (> 5px threshold)
    local activeDragInput = nil
    local dragStartPointer = nil
    local dragStartRight = 0
    local dragStartTop = 0
    local isDragging = false
    local suppressUntil = 0

    local function resetDrag()
        local wasDragging = isDragging
        if wasDragging then
            suppressUntil = os.clock() + 0.15
        end
        activeDragInput = nil
        dragStartPointer = nil
        isDragging = false
        if wasDragging and isExpanded then
            local targetH = computeDrawerTargetMetrics()
            Animations:Tween(drawer, Animations.Fast, { Size = UDim2.new(0, pillWidth, 0, targetH) })
        end
    end

    local function beginPointerTrack(input)
        local uType = input.UserInputType
        if uType ~= Enum.UserInputType.MouseButton1 and uType ~= Enum.UserInputType.Touch then
            return
        end
        if activeDragInput then return end
        local guiOrigin = (screenGui and screenGui.Parent) and screenGui.AbsolutePosition or Vector2.new(0, 0)
        activeDragInput = input
        dragStartPointer = input.Position
        isDragging = false
        suppressUntil = 0
        dragStartRight = (pill.AbsolutePosition.X + pill.AbsoluteSize.X) - guiOrigin.X
        dragStartTop = pill.AbsolutePosition.Y - guiOrigin.Y
    end

    table.insert(localConns, pill.InputBegan:Connect(beginPointerTrack))
    table.insert(localConns, playersBtn.InputBegan:Connect(beginPointerTrack))

    table.insert(localConns, UserInputService.InputChanged:Connect(function(input)
        if not isAlive or not activeDragInput then return end
        local isMouseDrag = (activeDragInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement)
        local isTouchDrag = (activeDragInput.UserInputType == Enum.UserInputType.Touch and input == activeDragInput)
        if not isMouseDrag and not isTouchDrag then return end

        local delta = input.Position - dragStartPointer
        if not isDragging then
            if math.sqrt(delta.X * delta.X + delta.Y * delta.Y) < DRAG_THRESHOLD_PX then
                return
            end
            isDragging = true
            hasDragged = true
            suppressUntil = os.clock() + 5
        end

        local viewSize = (screenGui and screenGui.Parent) and screenGui.AbsoluteSize or Vector2.new(1280, 720)
        local viewW = math.max(viewSize.X, 1)
        local viewH = math.max(viewSize.Y, 1)
        local scaledW = pill.AbsoluteSize.X
        local scaledH = pill.AbsoluteSize.Y

        local clampedRight = math.clamp(dragStartRight + delta.X, scaledW + EDGE_MARGIN, math.max(scaledW + EDGE_MARGIN, viewW - EDGE_MARGIN))
        local clampedTop = math.clamp(dragStartTop + delta.Y, EDGE_MARGIN, math.max(EDGE_MARGIN, viewH - scaledH - EDGE_MARGIN))
        normRight = clampedRight / viewW
        normTop = clampedTop / viewH
        root.AnchorPoint = Vector2.new(1, 0)
        root.Position = UDim2.new(normRight, 0, normTop, 0)
    end))

    table.insert(localConns, UserInputService.InputEnded:Connect(function(input)
        if not activeDragInput then return end
        if input == activeDragInput or (activeDragInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseButton1) then
            resetDrag()
        end
    end))

    table.insert(localConns, UserInputService.WindowFocusReleased:Connect(function()
        resetDrag()
    end))

    table.insert(localConns, playersBtn.MouseEnter:Connect(function()
        if not isExpanded then
            Animations:Tween(playersBtn, Animations.Fast, { BackgroundTransparency = 0.90 })
        end
    end))

    table.insert(localConns, playersBtn.MouseLeave:Connect(function()
        if not isExpanded then
            Animations:Tween(playersBtn, Animations.Fast, { BackgroundTransparency = 1 })
        end
    end))

    table.insert(localConns, playersBtn.Activated:Connect(function()
        if isDragging or os.clock() < suppressUntil then
            return
        end
        setExpanded(not isExpanded)
    end))

    -- Live telemetry loop (FPS & Ping every 0.5s; distance sort every 0.35s when expanded)
    local frameCount = 0
    local fpsAcc = 0
    local distAcc = 0
    local okHb, hbConn = pcall(function()
        return RunService.Heartbeat:Connect(function(dt)
            if not isAlive or not root or not root.Parent then return end
            if dt and dt > 0 then
                frameCount = frameCount + 1
                fpsAcc = fpsAcc + dt
            end

            if fpsAcc >= FPS_REFRESH_INTERVAL then
                local fpsVal = math.clamp(math.floor((frameCount / fpsAcc) + 0.5), 0, 999)
                fpsValLbl.Text = fpsFmt.Format(fpsVal)
                frameCount = 0
                fpsAcc = 0

                local pingMs = readPingMs(cachedLocalPlayer)
                if pingMs then
                    pingValLbl.Text = pingFmt.Format(math.clamp(math.floor(pingMs + 0.5), 0, 999))
                else
                    pingValLbl.Text = "--"
                end
            end

            if isExpanded and root.Visible then
                distAcc = distAcc + (dt or 0)
                if distAcc >= DISTANCE_REFRESH_INTERVAL then
                    distAcc = 0
                    updateRowsAndDistances(nil)
                end
            end
        end)
    end)
    if okHb and hbConn then
        table.insert(localConns, hbConn)
    end

    -- Player list lifecycle listeners
    local okJoin, joinConn = pcall(function()
        return Players.PlayerAdded:Connect(function(plr)
            if not isAlive then return end
            updatePlayerCountDisplay(nil)
            isDirty = true
            if isExpanded then
                updateRowsAndDistances(nil)
                local targetH = computeDrawerTargetMetrics()
                Animations:Tween(drawer, Animations.Fast, { Size = UDim2.new(0, pillWidth, 0, targetH) })
            end
            pcall(function()
                local dConn = plr:GetPropertyChangedSignal("DisplayName"):Connect(function()
                    isDirty = true
                    if isExpanded then updateRowsAndDistances(nil) end
                end)
                table.insert(localConns, dConn)
            end)
        end)
    end)
    if okJoin and joinConn then
        table.insert(localConns, joinConn)
    end

    local okLeave, leaveConn = pcall(function()
        return Players.PlayerRemoving:Connect(function(leavingPlr)
            if not isAlive then return end
            updatePlayerCountDisplay(leavingPlr)
            if rowPool[leavingPlr] then
                pcall(function() rowPool[leavingPlr].Row:Destroy() end)
                rowPool[leavingPlr] = nil
            end
            isDirty = true
            if isExpanded then
                updateRowsAndDistances(leavingPlr)
                local targetH = computeDrawerTargetMetrics()
                Animations:Tween(drawer, Animations.Fast, { Size = UDim2.new(0, pillWidth, 0, targetH) })
            end
            task.defer(function()
                if isAlive then updatePlayerCountDisplay(nil) end
            end)
        end)
    end)
    if okLeave and leaveConn then
        table.insert(localConns, leaveConn)
    end

    -- Viewport resize re-clamping
    local okResize, resizeConn = pcall(function()
        return screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            updateResponsiveScaleAndClamp()
            if isExpanded then
                local targetH = computeDrawerTargetMetrics()
                drawer.Size = UDim2.new(0, pillWidth, 0, targetH)
            end
        end)
    end)
    if okResize and resizeConn then
        table.insert(localConns, resizeConn)
    end

    -- Parent into live ScreenGui cleanly at the end
    pcall(function()
        root.Parent = screenGui
    end)
    updateResponsiveScaleAndClamp()
    updatePlayerCountDisplay(nil)

    function StatusBarObj:SetVisible(vis)
        isVisible = (vis == true)
        if root then
            root.Visible = isVisible
            if not isVisible and isExpanded then
                setExpanded(false)
            end
        end
    end

    function StatusBarObj:IsVisible()
        return isVisible
    end

    function StatusBarObj:SetExpanded(expand)
        setExpanded(expand)
    end

    function StatusBarObj:IsExpanded()
        return isExpanded
    end

    function StatusBarObj:RefreshPlayers()
        updatePlayerCountDisplay(nil)
        updateRowsAndDistances(nil)
        if isExpanded then
            local targetH = computeDrawerTargetMetrics()
            Animations:Tween(drawer, Animations.Fast, { Size = UDim2.new(0, pillWidth, 0, targetH) })
        end
    end

    function StatusBarObj:ApplyThemeColors(t)
        applyThemeColors(t)
    end

    function StatusBarObj:Destroy()
        if not isAlive then return end
        isAlive = false
        removeThemeSubscriber()
        if activeDrawerTween then
            pcall(function() activeDrawerTween:Cancel() end)
            activeDrawerTween = nil
        end
        for _, c in ipairs(localConns) do
            pcall(function() c:Disconnect() end)
        end
        table.clear(localConns)
        for _, entry in pairs(rowPool) do
            pcall(function() entry.Row:Destroy() end)
        end
        table.clear(rowPool)
        if root then
            pcall(function() root:Destroy() end)
        end
    end

    table.insert(ctx.Connections, {
        Disconnect = function()
            StatusBarObj:Destroy()
        end
    })

    return StatusBarObj
end

return StatusBar
