-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY - MODULE: Window.lua ]
-- Manages Window lifecycle, Sidebar tabs, Theme engine, Transparency engine, and Cleanup.
-- ==============================================================================

local Window = {}

function Window:Create(lib, config)
    config = config or {}
    local Themes = lib.Themes
    local Animations = lib.Animations
    local Utils = lib.Utils
    local Modals = lib.Modals
    local Components = lib.Components
    local Panels = lib.Panels

    local safeContainer = Utils:GetSafeParent()
    local guiName = config.GuiName or "SyntaxHubGUI"

    pcall(function()
        for _, child in ipairs(safeContainer:GetChildren()) do
            if child.Name == guiName then child:Destroy() end
        end
    end)

    local mainUI = Instance.new("ScreenGui")
    mainUI.Name = guiName
    mainUI.ResetOnSpawn = false
    mainUI.DisplayOrder = 999999999
    -- Sibling ZIndexBehavior prevents translucent parent containers from rendering over child text/toggles
    mainUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mainUI.Parent = safeContainer

    local sharedState = config.State or {}
    sharedState.activeStealButtons = sharedState.activeStealButtons or {}
    sharedState.themeSubscribers = sharedState.themeSubscribers or {}
    sharedState.themeName = config.Theme or sharedState.themeName or "Sapphire"
    if sharedState.isOpn == nil then sharedState.isOpn = true end
    sharedState.curCat = sharedState.curCat or 1
    sharedState.spSortChoice = sharedState.spSortChoice or "Value (Money/s)"
    sharedState.spSortIndex = sharedState.spSortIndex or 1

    local activeTheme = Themes:Get(sharedState.themeName)

    local ctx = {
        Library = lib,
        Themes = Themes,
        Animations = Animations,
        Utils = Utils,
        Modals = Modals,
        Components = Components,
        Panels = Panels,
        ScreenGui = mainUI,
        State = sharedState,
        ActiveTheme = activeTheme,
        Connections = {},
        Tabs = {},
        TabButtons = {},
        ThemeButtons = {},
        IsAlive = true
    }

    local winSize = config.Size or UDim2.new(0, 510, 0, 345)

    local frm = Instance.new("Frame", mainUI)
    frm.Name = "MainFrame"
    frm.AnchorPoint = Vector2.new(0.5, 0.5)
    frm.Position = UDim2.new(0.5, 0, 0.5, 0)
    frm.Size = winSize
    frm.ClipsDescendants = true
    frm.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frm.BackgroundTransparency = 0.14
    frm.BorderSizePixel = 0
    Utils:RoundCorner(frm, 22)

    local frmGrad = Utils:MakeGradient(frm, 135)
    local frmStr = Instance.new("UIStroke", frm)
    frmStr.Thickness = 1.3
    frmStr.Transparency = 0.25

    local inner = Instance.new("Frame", frm)
    inner.Name = "InnerRim"
    inner.BackgroundTransparency = 1
    inner.Size = UDim2.new(1, -2, 1, -2)
    inner.Position = UDim2.new(0, 1, 0, 1)
    inner.BorderSizePixel = 0
    inner.ZIndex = 1
    Utils:RoundCorner(inner, 21)

    local innerGrad = Utils:MakeGradient(inner, 90)
    innerGrad.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.72), 
        NumberSequenceKeypoint.new(0.45, 0.90), 
        NumberSequenceKeypoint.new(1, 1)
    }

    local topBar = Instance.new("Frame", frm)
    topBar.Name = "TitleBar"
    topBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    topBar.BackgroundTransparency = 1
    topBar.Size = UDim2.new(1, 0, 0, 48)
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 2
    topBar.Active = true

    local topBarGrad = Utils:MakeGradient(topBar, 0)

    local topTxt = Instance.new("TextLabel", topBar)
    topTxt.BackgroundTransparency = 1
    topTxt.Position = UDim2.new(0, 0, 0, 0)
    topTxt.Size = UDim2.new(1, 0, 1, 0)
    topTxt.Font = Enum.Font.GothamBold
    topTxt.TextSize = 18
    topTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
    topTxt.TextXAlignment = Enum.TextXAlignment.Center
    topTxt.TextYAlignment = Enum.TextYAlignment.Center
    topTxt.Text = tostring(config.Title or "Syntaxis")

    local tglBtn = Instance.new("ImageButton", mainUI)
    tglBtn.Name = "Toggle"
    tglBtn.Size = UDim2.new(0, 52, 0, 52)
    tglBtn.Position = UDim2.new(0, 18, 0.5, -26)
    tglBtn.BackgroundColor3 = Color3.fromRGB(32, 60, 110)
    tglBtn.BackgroundTransparency = 0.12
    tglBtn.BorderSizePixel = 0
    tglBtn.Image = config.Icon or "rbxthumb://type=Asset&id=73878877741609&w=150&h=150"
    tglBtn.AutoButtonColor = false
    Utils:RoundCorner(tglBtn, 999)
    Animations:AttachTactile(tglBtn, ctx.Connections)

    local tglStr = Instance.new("UIStroke", tglBtn)
    tglStr.Thickness = 1.5
    tglStr.Transparency = 0.20
    tglStr.Color = activeTheme.Accent

    local side = Instance.new("ScrollingFrame", frm)
    side.Name = "Sidebar"
    side.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    side.BackgroundTransparency = 0.25
    side.BorderSizePixel = 0
    side.Position = UDim2.new(0, 10, 0, 50)
    side.Size = UDim2.new(0, 126, 1, -60)
    side.ZIndex = 2
    side.ScrollBarThickness = 0
    side.AutomaticCanvasSize = Enum.AutomaticSize.Y
    side.CanvasSize = UDim2.new(0, 0, 0, 0)
    Utils:RoundCorner(side, 16)

    local sideGrad = Utils:MakeGradient(side, 135)
    local sideStr = Instance.new("UIStroke", side)
    sideStr.Thickness = 1
    sideStr.Transparency = 0.35

    local sidePad = Instance.new("UIPadding", side)
    sidePad.PaddingTop = UDim.new(0, 10)
    sidePad.PaddingBottom = UDim.new(0, 10)
    sidePad.PaddingLeft = UDim.new(0, 8)
    sidePad.PaddingRight = UDim.new(0, 8)

    local sideLay = Instance.new("UIListLayout", side)
    sideLay.Padding = UDim.new(0, 6)
    sideLay.SortOrder = Enum.SortOrder.LayoutOrder

    local cntFrame = Instance.new("Frame", frm)
    cntFrame.Name = "ContentFrame"
    cntFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    cntFrame.BackgroundTransparency = 0.24
    cntFrame.BorderSizePixel = 0
    cntFrame.Position = UDim2.new(0, 144, 0, 50)
    cntFrame.Size = UDim2.new(1, -154, 1, -60)
    cntFrame.ZIndex = 2
    Utils:RoundCorner(cntFrame, 16)

    local cntGrad = Utils:MakeGradient(cntFrame, 135)
    local cntStr = Instance.new("UIStroke", cntFrame)
    cntStr.Thickness = 1
    cntStr.Transparency = 0.35

    local pageLbl = Instance.new("TextLabel", cntFrame)
    pageLbl.BackgroundTransparency = 1
    pageLbl.Position = UDim2.new(0, 14, 0, 10)
    pageLbl.Size = UDim2.new(1, -28, 0, 22)
    pageLbl.Font = Enum.Font.GothamBold
    pageLbl.TextSize = 16
    pageLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    pageLbl.TextXAlignment = Enum.TextXAlignment.Left
    pageLbl.Text = "Farm"

    local pgLine = Instance.new("Frame", cntFrame)
    pgLine.Size = UDim2.new(0, 32, 0, 2.5)
    pgLine.Position = UDim2.new(0, 14, 0, 33)
    pgLine.BorderSizePixel = 0
    pgLine:SetAttribute("NoTrans", true)
    Utils:RoundCorner(pgLine, 999)

    local pgsHold = Instance.new("Frame", cntFrame)
    pgsHold.Name = "PagesHolder"
    pgsHold.BackgroundTransparency = 1
    pgsHold.Position = UDim2.new(0, 8, 0, 44)
    pgsHold.Size = UDim2.new(1, -16, 1, -50)

    local popupLayer = Instance.new("Frame", frm)
    popupLayer.Name = "PopupOverlayLayer"
    popupLayer.Size = UDim2.new(1, 0, 1, 0)
    popupLayer.Position = UDim2.new(0, 0, 0, 0)
    popupLayer.BackgroundTransparency = 1
    popupLayer.ZIndex = 50

    ctx.MainFrame = frm
    ctx.Sidebar = side
    ctx.ContentFrame = cntFrame
    ctx.PagesHolder = pgsHold
    ctx.PopupLayer = popupLayer
    ctx.ToggleOrb = tglBtn

    Utils:MakeDraggable(topBar, frm, ctx.Connections)
    Utils:MakeDraggable(topTxt, frm, ctx.Connections)
    Utils:MakeDraggable(tglBtn, tglBtn, ctx.Connections)

    local sldrUI = {}
    local prevGrad, prevStr, prevTxt

    local function setCatVis(idx, hov)
        local data = ctx.TabButtons[idx]
        if not data or not ctx.ActiveTheme then return end
        local th = ctx.ActiveTheme
        if sharedState.curCat == idx then
            data.Gradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, th.Accent),
                ColorSequenceKeypoint.new(1, th.Accent2)
            }
            data.Stroke.Color = th.Accent2
            data.Stroke.Transparency = 0.15
            data.Button.BackgroundTransparency = 0.08
            data.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            data.Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Animations:Tween(data.Indicator, Animations.Fast, { Size = UDim2.new(0, 3.5, 0, 18) })
            Animations:Tween(data.Label, Animations.Fast, { Position = UDim2.new(0, 16, 0, 10) })
        else
            data.Gradient.Color = hov and th.ButtonHover or th.Button
            data.Stroke.Color = th.Stroke
            data.Stroke.Transparency = 0.40
            data.Button.BackgroundTransparency = 0.28
            data.Label.TextColor3 = th.Text
            Animations:Tween(data.Indicator, Animations.Fast, { Size = UDim2.new(0, 0, 0, 18) })
            Animations:Tween(data.Label, Animations.Fast, { Position = UDim2.new(0, 14, 0, 10) })
        end
    end

    local function setThmVis(sName, bName, hov)
        local thm = Themes.Palettes[bName]
        local d = ctx.ThemeButtons[bName]
        if not d or not thm then return end
        local isSel = (sName == bName)
        d.Button.TextColor3 = Color3.new(1, 1, 1)
        d.Tint.BackgroundTransparency = (isSel or hov) and 0.28 or 0.68
        d.Gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, thm.Accent),
            ColorSequenceKeypoint.new(1, thm.Accent2)
        }
        d.Stroke.Color = isSel and Color3.fromRGB(255, 255, 255) or thm.Accent
        d.Stroke.Transparency = isSel and 0.10 or 0.35
        d.DotStroke.Color = isSel and Color3.fromRGB(255, 255, 255) or thm.Accent
        d.Tint.BackgroundColor3 = thm.Main.Keypoints[#thm.Main.Keypoints].Value
    end

    local function swapCat(idx)
        if sharedState.activeOpenedDropdown then
            sharedState.activeOpenedDropdown()
        end
        sharedState.curCat = idx
        for i, d in ipairs(ctx.Tabs) do
            if d.Page then
                d.Page.Visible = (i == idx)
            end
            setCatVis(i, false)
        end
        if ctx.Tabs[idx] then
            pageLbl.Text = ctx.Tabs[idx].Title
            task.spawn(function()
                task.wait()
                local tw = pageLbl.TextBounds.X
                pgLine.Size = UDim2.new(0, 0, 0, 2.5)
                Animations:Tween(pgLine, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, tw, 0, 2.5)
                })
            end)
            if ctx.Tabs[idx].OnShow then
                pcall(ctx.Tabs[idx].OnShow)
            end
        end
    end

    local function applyTrans(val)
        val = math.clamp(tonumber(val) or 0, 0, 100)
        local a = val / 100
        if sldrUI.Txt then
            sldrUI.Txt.Text = "Transparency: " .. math.floor(val) .. "%"
            sldrUI.Fil.Size = UDim2.new(a, 0, 1, 0)
            sldrUI.Kn.Position = UDim2.new(a, -8, 0.5, -8)
        end

        local function doT(inst)
            if inst:GetAttribute("NoTrans") then return end
            if inst:IsA("GuiObject") then
                if inst:GetAttribute("OrigBg") == nil then
                    inst:SetAttribute("OrigBg", inst.BackgroundTransparency)
                end
                local origBg = inst:GetAttribute("OrigBg")
                if origBg < 1 then
                    inst.BackgroundTransparency = origBg + ((1 - origBg) * (a * 0.78))
                end
            end
            if inst:IsA("UIStroke") then
                if inst:GetAttribute("OrigStr") == nil then
                    inst:SetAttribute("OrigStr", inst.Transparency)
                end
                local origStr = inst:GetAttribute("OrigStr")
                inst.Transparency = origStr + ((1 - origStr) * (a * 0.35))
            end
        end
        doT(frm)
        for _, child in ipairs(frm:GetDescendants()) do doT(child) end
    end

    local function loadTheme(n)
        local t = Themes.Palettes[n]
        if not t then
            t = Themes.Palettes.Sapphire
            n = "Sapphire"
        end
        sharedState.themeName = n
        ctx.ActiveTheme = t

        topTxt.TextColor3 = Color3.new(1, 1, 1)
        pageLbl.TextColor3 = Color3.new(1, 1, 1)
        frmGrad.Color = t.Main
        topBarGrad.Color = t.Topbar
        sideGrad.Color = t.Main
        cntGrad.Color = t.Main
        frmStr.Color = t.GlassRim or t.Stroke
        sideStr.Color = t.Stroke
        cntStr.Color = t.Stroke
        tglBtn.BackgroundColor3 = t.CardBg
        tglStr.Color = t.Accent
        pgLine.BackgroundColor3 = t.Accent
        innerGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, t.Accent2),
            ColorSequenceKeypoint.new(1, t.Accent)
        }

        if sldrUI.Txt then
            sldrUI.Txt.TextColor3 = Color3.new(1, 1, 1)
            sldrUI.Grad.Color = t.Topbar
            sldrUI.Str.Color = t.Stroke
            sldrUI.Trk.BackgroundColor3 = t.SwitchOff
            sldrUI.Fil.BackgroundColor3 = t.Accent
            sldrUI.Kn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end
        if prevTxt then
            prevTxt.TextColor3 = Color3.new(1, 1, 1)
            prevGrad.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, t.Accent),
                ColorSequenceKeypoint.new(1, t.Accent2)
            }
            prevStr.Color = t.Accent2
            prevTxt.Text = "Current Theme: " .. (t.Name or n)
        end
        if ctx.SpSortBtn then ctx.SpSortBtn.BackgroundColor3 = t.BoxBg end
        if ctx.SpSortStr then ctx.SpSortStr.Color = t.Stroke end

        for i = 1, #ctx.Tabs do setCatVis(i, false) end
        for bName in pairs(ctx.ThemeButtons) do setThmVis(n, bName, false) end
        for _, subFn in ipairs(sharedState.themeSubscribers) do pcall(subFn, t) end
        if config.OnThemeChanged then pcall(config.OnThemeChanged, n, t) end
    end

    local function registerSidebarButton(tabData, idx)
        local btn = Instance.new("TextButton", side)
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.25
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.LayoutOrder = idx
        Utils:RoundCorner(btn, 12)
        Animations:AttachTactile(btn, ctx.Connections)

        local g = Utils:MakeGradient(btn, 135)
        local s = Instance.new("UIStroke", btn)
        s.Thickness = 1
        s.Transparency = 0.35

        local ind = Instance.new("Frame", btn)
        ind.Size = UDim2.new(0, 0, 0, 18)
        ind.Position = UDim2.new(0, 4, 0.5, -9)
        ind.BorderSizePixel = 0
        ind:SetAttribute("NoTrans", true)
        Utils:RoundCorner(ind, 999)

        local lbl = Instance.new("TextLabel", btn)
        lbl.BackgroundTransparency = 1
        lbl.Position = UDim2.new(0, 14, 0, 10)
        lbl.Size = UDim2.new(1, -18, 0, 18)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = tabData.Name

        ctx.TabButtons[idx] = { Button = btn, Gradient = g, Stroke = s, Label = lbl, Indicator = ind }

        table.insert(ctx.Connections, btn.MouseEnter:Connect(function() setCatVis(idx, true) end))
        table.insert(ctx.Connections, btn.MouseLeave:Connect(function() setCatVis(idx, false) end))
        table.insert(ctx.Connections, btn.MouseButton1Click:Connect(function() swapCat(idx) end))
        setCatVis(idx, false)
    end

    local opnSz = frm.Size
    local function openUi()
        frm.Visible = true
        frm.Size = UDim2.new(0, 0, 0, 0)
        Animations:Tween(frm, Animations.Smooth, { Size = opnSz })
        sharedState.isOpn = true
    end

    local function closeUi()
        if sharedState.activeOpenedDropdown then
            sharedState.activeOpenedDropdown()
        end
        local outTw = Animations:Tween(frm, Animations.Smooth, { Size = UDim2.new(0, 0, 0, 0) })
        outTw.Completed:Connect(function()
            if not sharedState.isOpn then frm.Visible = false end
        end)
        sharedState.isOpn = false
    end

    table.insert(ctx.Connections, tglBtn.MouseButton1Click:Connect(function()
        local bSz = UDim2.new(0, 52, 0, 52)
        Animations:Tween(tglBtn, Animations.Fast, { Size = UDim2.new(0, 45, 0, 45) })
        task.delay(0.08, function() Animations:Tween(tglBtn, Animations.Fast, { Size = bSz }) end)
        if sharedState.isOpn then closeUi() else openUi() end
    end))

    -- ==========================================================================
    -- PUBLIC WINDOW OBJECT API
    -- ==========================================================================
    local WinObj = {
        Context = ctx,
        ScreenGui = mainUI,
        MainFrame = frm,
        ToggleOrb = tglBtn
    }

    function WinObj:GetActiveTheme()
        return ctx.ActiveTheme
    end

    function WinObj:SetTheme(themeName)
        loadTheme(themeName)
    end

    function WinObj:SetTransparency(val)
        applyTrans(val)
    end

    function WinObj:SelectTab(idx)
        swapCat(idx)
    end

    function WinObj:ShowWarningModal(title, text)
        Modals:ShowWarning(ctx, title, text)
    end

    function WinObj:ShowDiscordModal(inviteUrl)
        Modals:ShowDiscord(ctx, inviteUrl)
    end

    function WinObj:Notify(opts)
        Modals:Notify(ctx, opts)
    end

    function WinObj:SetVisible(vis)
        if vis then openUi() else closeUi() end
    end

    function WinObj:CreateTab(tabName, pageTitle)
        local idx = #ctx.Tabs + 1
        local pg = Instance.new("ScrollingFrame", pgsHold)
        pg.Name = tostring(tabName) .. "Page"
        pg.Size = UDim2.new(1, 0, 1, 0)
        pg.BackgroundTransparency = 1
        pg.BorderSizePixel = 0
        pg.ScrollBarThickness = 3
        pg.AutomaticCanvasSize = Enum.AutomaticSize.Y
        pg.CanvasSize = UDim2.new(0, 0, 0, 0)
        pg.Visible = (idx == 1)

        local pad = Instance.new("UIPadding", pg)
        pad.PaddingTop = UDim.new(0, 6)
        pad.PaddingBottom = UDim.new(0, 16)
        pad.PaddingLeft = UDim.new(0, 4)
        pad.PaddingRight = UDim.new(0, 8)

        local lay = Instance.new("UIListLayout", pg)
        lay.Padding = UDim.new(0, 10)
        lay.SortOrder = Enum.SortOrder.LayoutOrder

        local tabData = {
            Name = tostring(tabName),
            Title = tostring(pageTitle or tabName),
            Page = pg,
            NextOrder = 0
        }
        ctx.Tabs[idx] = tabData
        registerSidebarButton(tabData, idx)

        local TabObj = {
            Page = pg,
            Index = idx
        }

        function TabObj:CreateCategory(catTitle, defaultOpen, explicitOrder)
            local ord = explicitOrder
            if not ord then
                tabData.NextOrder = tabData.NextOrder + 1
                ord = tabData.NextOrder
            end
            return Components:CreateCategory(ctx, catTitle, pg, ord, defaultOpen)
        end

        return TabObj, pg
    end

    function WinObj:CreatePriorityTab(tabName, pageTitle, opts)
        local idx = #ctx.Tabs + 1
        local priorityPg = Instance.new("ScrollingFrame", pgsHold)
        priorityPg.Name = "PriorityPage"
        priorityPg.Size = UDim2.new(1, 0, 1, 0)
        priorityPg.BackgroundTransparency = 1
        priorityPg.BorderSizePixel = 0
        priorityPg.ScrollBarThickness = 3
        priorityPg.ScrollBarImageColor3 = ctx.ActiveTheme.Accent
        priorityPg.AutomaticCanvasSize = Enum.AutomaticSize.Y
        priorityPg.CanvasSize = UDim2.new(0, 0, 0, 0)
        priorityPg.Visible = (idx == 1)

        local priorityPad = Instance.new("UIPadding", priorityPg)
        priorityPad.PaddingTop = UDim.new(0, 6)
        priorityPad.PaddingBottom = UDim.new(0, 16)
        priorityPad.PaddingLeft = UDim.new(0, 4)
        priorityPad.PaddingRight = UDim.new(0, 8)

        local priorityLayout = Instance.new("UIListLayout", priorityPg)
        priorityLayout.Padding = UDim.new(0, 8)
        priorityLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local renderFn = Panels:SetupPriorityPanel(ctx, priorityPg, opts)

        local tabData = {
            Name = tostring(tabName or "Priority"),
            Title = tostring(pageTitle or "Task Priority"),
            Page = priorityPg,
            OnShow = renderFn
        }
        ctx.Tabs[idx] = tabData
        registerSidebarButton(tabData, idx)

        return {
            Page = priorityPg,
            Render = renderFn,
            Index = idx
        }, renderFn
    end

    function WinObj:CreateStealPanelTab(tabName, pageTitle, opts)
        local idx = #ctx.Tabs + 1
        local stealPanelPg = Instance.new("Frame", pgsHold)
        stealPanelPg.Name = "StealPanelPage"
        stealPanelPg.Size = UDim2.new(1, 0, 1, 0)
        stealPanelPg.BackgroundTransparency = 1
        stealPanelPg.Visible = (idx == 1)

        local renderFn = Panels:SetupStealPanel(ctx, stealPanelPg, opts)

        local tabData = {
            Name = tostring(tabName or "Steal Panel"),
            Title = tostring(pageTitle or "Steal Panel"),
            Page = stealPanelPg,
            OnShow = renderFn
        }
        ctx.Tabs[idx] = tabData
        registerSidebarButton(tabData, idx)

        return {
            Page = stealPanelPg,
            Render = renderFn,
            Index = idx
        }, renderFn
    end

    function WinObj:CreateSettingsTab(tabName, pageTitle, opts)
        opts = opts or {}
        local idx = #ctx.Tabs + 1
        local setPg = Instance.new("Frame", pgsHold)
        setPg.Name = "SettingsPage"
        setPg.Size = UDim2.new(1, 0, 1, 0)
        setPg.BackgroundTransparency = 1
        setPg.Visible = (idx == 1)

        local thmScrl = Instance.new("ScrollingFrame", setPg)
        thmScrl.Size = UDim2.new(1, 0, 1, -94)
        thmScrl.BackgroundTransparency = 1
        thmScrl.BorderSizePixel = 0
        thmScrl.ScrollBarThickness = 3
        thmScrl.CanvasSize = UDim2.new(0, 0, 0, 0)
        thmScrl.AutomaticCanvasSize = Enum.AutomaticSize.Y

        local thmGrid = Instance.new("UIGridLayout", thmScrl)
        thmGrid.CellPadding = UDim2.new(0, 6, 0, 6)
        thmGrid.CellSize = UDim2.new(0.5, -3, 0, 34)
        thmGrid.SortOrder = Enum.SortOrder.LayoutOrder

        sldrUI.Bg = Instance.new("Frame", setPg)
        sldrUI.Bg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sldrUI.Bg.BackgroundTransparency = 0.22
        sldrUI.Bg.Position = UDim2.new(0, 0, 1, -86)
        sldrUI.Bg.Size = UDim2.new(1, 0, 0, 42)
        sldrUI.Bg.BorderSizePixel = 0
        Utils:RoundCorner(sldrUI.Bg, 12)
        sldrUI.Grad = Utils:MakeGradient(sldrUI.Bg, 135)
        sldrUI.Str = Instance.new("UIStroke", sldrUI.Bg)
        sldrUI.Str.Thickness = 1
        sldrUI.Str.Transparency = 0.40

        sldrUI.Txt = Instance.new("TextLabel", sldrUI.Bg)
        sldrUI.Txt.BackgroundTransparency = 1
        sldrUI.Txt.Position = UDim2.new(0, 10, 0, 4)
        sldrUI.Txt.Size = UDim2.new(1, -20, 0, 15)
        sldrUI.Txt.Font = Enum.Font.GothamMedium
        sldrUI.Txt.TextSize = 12
        sldrUI.Txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        sldrUI.Txt.TextXAlignment = Enum.TextXAlignment.Left
        sldrUI.Txt.Text = "Transparency: 0%"

        sldrUI.Trk = Instance.new("Frame", sldrUI.Bg)
        sldrUI.Trk.BackgroundColor3 = Color3.fromRGB(24, 34, 54)
        sldrUI.Trk.BorderSizePixel = 0
        sldrUI.Trk.Position = UDim2.new(0, 10, 0, 24)
        sldrUI.Trk.Size = UDim2.new(1, -20, 0, 6)
        sldrUI.Trk:SetAttribute("NoTrans", true)
        Utils:RoundCorner(sldrUI.Trk, 999)

        sldrUI.Fil = Instance.new("Frame", sldrUI.Trk)
        sldrUI.Fil.BorderSizePixel = 0
        sldrUI.Fil.Size = UDim2.new(0, 0, 1, 0)
        sldrUI.Fil:SetAttribute("NoTrans", true)
        Utils:RoundCorner(sldrUI.Fil, 999)

        sldrUI.Kn = Instance.new("TextButton", sldrUI.Trk)
        sldrUI.Kn.Text = ""
        sldrUI.Kn.AutoButtonColor = false
        sldrUI.Kn.BorderSizePixel = 0
        sldrUI.Kn.Size = UDim2.new(0, 16, 0, 16)
        sldrUI.Kn.Position = UDim2.new(0, -8, 0.5, -8)
        sldrUI.Kn:SetAttribute("NoTrans", true)
        Utils:RoundCorner(sldrUI.Kn, 999)

        local prevBox = Instance.new("Frame", setPg)
        prevBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        prevBox.BackgroundTransparency = 0.22
        prevBox.Position = UDim2.new(0, 0, 1, -36)
        prevBox.Size = UDim2.new(1, 0, 0, 34)
        prevBox.BorderSizePixel = 0
        Utils:RoundCorner(prevBox, 12)
        prevGrad = Utils:MakeGradient(prevBox, 135)
        prevStr = Instance.new("UIStroke", prevBox)
        prevStr.Thickness = 1
        prevStr.Transparency = 0.40

        prevTxt = Instance.new("TextLabel", prevBox)
        prevTxt.BackgroundTransparency = 1
        prevTxt.Position = UDim2.new(0, 10, 0, 0)
        prevTxt.Size = UDim2.new(1, -20, 1, 0)
        prevTxt.Font = Enum.Font.GothamMedium
        prevTxt.TextSize = 12.5
        prevTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
        prevTxt.TextXAlignment = Enum.TextXAlignment.Left
        prevTxt.Text = "Current Theme: " .. tostring(sharedState.themeName)

        for n, td in pairs(Themes.Palettes) do
            local btn = Instance.new("TextButton", thmScrl)
            btn.Name = n .. "Button"
            btn.Text = n
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 12
            btn.AutoButtonColor = false
            btn.BorderSizePixel = 0
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn:SetAttribute("NoTrans", true)
            Utils:RoundCorner(btn, 10)

            local pad = Instance.new("UIPadding", btn)
            pad.PaddingLeft = UDim.new(0, 34)

            local tint = Instance.new("Frame", btn)
            tint.Size = UDim2.new(1, 0, 1, 0)
            tint.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            tint.BackgroundTransparency = 0.72
            tint.BorderSizePixel = 0
            tint:SetAttribute("NoTrans", true)
            Utils:RoundCorner(tint, 10)

            local d = Instance.new("Frame", btn)
            d.Size = UDim2.new(0, 12, 0, 12)
            d.Position = UDim2.new(0, -22, 0.5, -6)
            d.BackgroundColor3 = td.Accent
            d.BorderSizePixel = 0
            d:SetAttribute("NoTrans", true)
            Utils:RoundCorner(d, 999)

            local ds = Instance.new("UIStroke", d)
            ds.Color = Color3.fromRGB(255, 255, 255)
            ds.Thickness = 1.2
            ds.Transparency = 0.20

            local g = Utils:MakeGradient(btn, 135)
            local s = Instance.new("UIStroke", btn)
            s.Thickness = 1
            s.Transparency = 0.40

            ctx.ThemeButtons[n] = { Button = btn, Gradient = g, Stroke = s, Padding = pad, DotStroke = ds, Tint = tint }

            table.insert(ctx.Connections, btn.MouseEnter:Connect(function()
                setThmVis(sharedState.themeName, n, true)
                Animations:Tween(pad, Animations.Fast, { PaddingLeft = UDim.new(0, 38) })
            end))
            table.insert(ctx.Connections, btn.MouseLeave:Connect(function()
                setThmVis(sharedState.themeName, n, false)
                Animations:Tween(pad, Animations.Fast, { PaddingLeft = UDim.new(0, 34) })
            end))
            table.insert(ctx.Connections, btn.MouseButton1Click:Connect(function()
                loadTheme(n)
                if opts.OnThemeSelected then opts.OnThemeSelected(n) end
                local bSz = winSize
                Animations:Tween(frm, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, bSz.X.Offset + 10, 0, bSz.Y.Offset + 8)
                })
                task.delay(0.16, function()
                    Animations:Tween(frm, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = bSz })
                end)
            end))
        end

        table.insert(ctx.Connections, sldrUI.Trk.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local function update(pos)
                    local relX = math.clamp(pos.X - sldrUI.Trk.AbsolutePosition.X, 0, sldrUI.Trk.AbsoluteSize.X)
                    local pct = (relX / math.max(sldrUI.Trk.AbsoluteSize.X, 1)) * 100
                    applyTrans(pct)
                end
                update(input.Position)
                local conn
                conn = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.Change then
                        update(input.Position)
                    elseif input.UserInputState == Enum.UserInputState.End then
                        local finalTrans = math.clamp(tonumber(string.match(sldrUI.Txt.Text, "%d+")) or 0, 0, 100)
                        if opts.OnTransparencyChanged then opts.OnTransparencyChanged(finalTrans) end
                        if conn then conn:Disconnect() end
                    end
                end)
                table.insert(ctx.Connections, conn)
            end
        end))

        local tabData = {
            Name = tostring(tabName or "Settings"),
            Title = tostring(pageTitle or "Settings"),
            Page = setPg
        }
        ctx.Tabs[idx] = tabData
        registerSidebarButton(tabData, idx)

        return {
            Page = setPg,
            Index = idx
        }
    end

    function WinObj:Initialize()
        swapCat(1)
        loadTheme(sharedState.themeName)
        applyTrans(config.Transparency or 0)
    end

    function WinObj:Destroy()
        ctx.IsAlive = false
        if sharedState.activeOpenedDropdown then
            pcall(sharedState.activeOpenedDropdown)
        end
        for _, conn in ipairs(ctx.Connections) do
            pcall(function() conn:Disconnect() end)
        end
        table.clear(ctx.Connections)
        if mainUI then
            pcall(function() mainUI:Destroy() end)
        end
    end

    return WinObj
end

return Window
