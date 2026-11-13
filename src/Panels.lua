-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY - MODULE: Panels.lua ]
-- Provides specialized dynamic panels: Priority List, Steal Panel, and Settings Panel.
-- ==============================================================================

local Panels = {}

function Panels:SetupPriorityPanel(ctx, priorityPg, opts)
    opts = opts or {}
    local Animations = ctx.Animations
    local Utils = ctx.Utils

    local function renderPriorityPanel()
        for _, child in ipairs(priorityPg:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end

        priorityPg.CanvasSize = UDim2.new(0, 0, 0, 0)
        local list = (opts.GetList and opts.GetList()) or opts.List or {}
        local activeTheme = ctx.ActiveTheme

        for index, taskName in ipairs(list) do
            local card = Instance.new("Frame", priorityPg)
            card.Size = UDim2.new(1, -2, 0, 50)
            card.BackgroundColor3 = activeTheme.CardBg
            card.BackgroundTransparency = 0.20
            card.BorderSizePixel = 0
            card.LayoutOrder = index
            Utils:RoundCorner(card, 12)

            local cardStroke = Instance.new("UIStroke", card)
            cardStroke.Color = (index == 1) and activeTheme.Accent or activeTheme.Stroke
            cardStroke.Thickness = (index == 1) and 1.5 or 1
            cardStroke.Transparency = (index == 1) and 0 or 0.35

            local badge = Instance.new("TextLabel", card)
            badge.Size = UDim2.new(0, 26, 0, 26)
            badge.Position = UDim2.new(0, 8, 0.5, -13)
            badge.BackgroundColor3 = (index == 1) and activeTheme.Accent or activeTheme.BoxBg
            badge.TextColor3 = Color3.fromRGB(255, 255, 255)
            badge.Font = Enum.Font.GothamBold
            badge.TextSize = 11.5
            badge.Text = "#" .. tostring(index)
            badge:SetAttribute("NoTrans", true)
            Utils:RoundCorner(badge, 999)

            local title = Instance.new("TextLabel", card)
            title.Size = UDim2.new(1, -125, 0, 18)
            title.Position = UDim2.new(0, 42, 0, 7)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.TextSize = 12
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.TextTruncate = Enum.TextTruncate.AtEnd
            title.Text = tostring(taskName)

            local desc = Instance.new("TextLabel", card)
            desc.Size = UDim2.new(1, -125, 0, 16)
            desc.Position = UDim2.new(0, 42, 0, 26)
            desc.BackgroundTransparency = 1
            desc.Font = Enum.Font.Gotham
            desc.TextSize = 9.5
            desc.TextColor3 = (index == 1) and activeTheme.Accent2 or activeTheme.SubText
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.TextTruncate = Enum.TextTruncate.AtEnd
            desc.Text = (index == 1 and "Highest Priority (Runs First)" or (index == #list and "Lowest Priority (Idle Fallback)" or "Active Task Priority"))

            local btnHolder = Instance.new("Frame", card)
            btnHolder.Size = UDim2.new(0, 68, 0, 28)
            btnHolder.Position = UDim2.new(1, -74, 0.5, -14)
            btnHolder.BackgroundTransparency = 1

            local upBtn = Instance.new("TextButton", btnHolder)
            upBtn.Size = UDim2.new(0, 30, 0, 28)
            upBtn.Position = UDim2.new(0, 0, 0, 0)
            upBtn.BackgroundColor3 = (index > 1) and activeTheme.BoxBg or activeTheme.RowBg
            upBtn.BackgroundTransparency = (index > 1) and 0.10 or 0.50
            upBtn.TextColor3 = (index > 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 165, 190)
            upBtn.Font = Enum.Font.GothamBold
            upBtn.TextSize = 13
            upBtn.Text = "▲"
            upBtn:SetAttribute("NoTrans", true)
            Utils:RoundCorner(upBtn, 8)
            local upStr = Instance.new("UIStroke", upBtn)
            upStr.Color = activeTheme.Stroke
            upStr.Thickness = 1
            upStr.Transparency = (index > 1) and 0.30 or 0.65
            Animations:AttachTactile(upBtn, ctx.Connections)

            local downBtn = Instance.new("TextButton", btnHolder)
            downBtn.Size = UDim2.new(0, 30, 0, 28)
            downBtn.Position = UDim2.new(0, 36, 0, 0)
            downBtn.BackgroundColor3 = (index < #list) and activeTheme.BoxBg or activeTheme.RowBg
            downBtn.BackgroundTransparency = (index < #list) and 0.10 or 0.50
            downBtn.TextColor3 = (index < #list) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 165, 190)
            downBtn.Font = Enum.Font.GothamBold
            downBtn.TextSize = 13
            downBtn.Text = "▼"
            downBtn:SetAttribute("NoTrans", true)
            Utils:RoundCorner(downBtn, 8)
            local downStr = Instance.new("UIStroke", downBtn)
            downStr.Color = activeTheme.Stroke
            downStr.Thickness = 1
            downStr.Transparency = (index < #list) and 0.30 or 0.65
            Animations:AttachTactile(downBtn, ctx.Connections)

            upBtn.MouseButton1Click:Connect(function()
                if index > 1 then
                    if opts.OnMoveUp then opts.OnMoveUp(index) end
                    renderPriorityPanel()
                end
            end)

            downBtn.MouseButton1Click:Connect(function()
                if index < #list then
                    if opts.OnMoveDown then opts.OnMoveDown(index) end
                    renderPriorityPanel()
                end
            end)
        end
    end

    table.insert(ctx.State.themeSubscribers, function(_, isLiveTick)
        if not isLiveTick and priorityPg.Visible then renderPriorityPanel() end
    end)

    return renderPriorityPanel
end

function Panels:SetupStealPanel(ctx, stealPanelPg, opts)
    opts = opts or {}
    local Animations = ctx.Animations
    local Utils = ctx.Utils
    local State = ctx.State

    local spTopBar = Instance.new("Frame", stealPanelPg)
    spTopBar.Size = UDim2.new(1, 0, 0, 32)
    spTopBar.BackgroundTransparency = 1

    local spSortLbl = Instance.new("TextLabel", spTopBar)
    spSortLbl.Size = UDim2.new(0, 60, 1, 0)
    spSortLbl.Position = UDim2.new(0, 4, 0, 0)
    spSortLbl.BackgroundTransparency = 1
    spSortLbl.Font = Enum.Font.GothamBold
    spSortLbl.TextSize = 11.5
    spSortLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    spSortLbl.TextXAlignment = Enum.TextXAlignment.Left
    spSortLbl.Text = "Sort By:"

    local spSortBtn = Instance.new("TextButton", spTopBar)
    spSortBtn.Size = UDim2.new(0, 150, 0, 26)
    spSortBtn.Position = UDim2.new(0, 62, 0.5, -13)
    spSortBtn.BackgroundColor3 = ctx.ActiveTheme.BoxBg
    spSortBtn.BackgroundTransparency = 0.15
    spSortBtn.BorderSizePixel = 0
    spSortBtn.Font = Enum.Font.GothamBold
    spSortBtn.TextSize = 11
    spSortBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    spSortBtn.Text = (State.spSortChoice or "Value (Money/s)") .. "  v"
    spSortBtn:SetAttribute("NoTrans", true)
    Utils:RoundCorner(spSortBtn, 8)
    Animations:AttachTactile(spSortBtn, ctx.Connections)

    local spSortStr = Instance.new("UIStroke", spSortBtn)
    spSortStr.Thickness = 1
    spSortStr.Color = ctx.ActiveTheme.Stroke
    spSortStr.Transparency = 0.35

    ctx.SpSortBtn = spSortBtn
    ctx.SpSortStr = spSortStr

    local spListScrl = Instance.new("ScrollingFrame", stealPanelPg)
    spListScrl.Size = UDim2.new(1, 0, 1, -38)
    spListScrl.Position = UDim2.new(0, 0, 0, 36)
    spListScrl.BackgroundTransparency = 1
    spListScrl.BorderSizePixel = 0
    spListScrl.ScrollBarThickness = 3
    spListScrl.AutomaticCanvasSize = Enum.AutomaticSize.Y
    spListScrl.CanvasSize = UDim2.new(0, 0, 0, 0)

    local spListLay = Instance.new("UIListLayout", spListScrl)
    spListLay.Padding = UDim.new(0, 8)
    spListLay.SortOrder = Enum.SortOrder.LayoutOrder

    local spListPad = Instance.new("UIPadding", spListScrl)
    spListPad.PaddingTop = UDim.new(0, 4)
    spListPad.PaddingBottom = UDim.new(0, 12)
    spListPad.PaddingLeft = UDim.new(0, 2)
    spListPad.PaddingRight = UDim.new(0, 6)

    local formatValue = opts.FormatValue or function(v) return tostring(v or 0) end

    local function renderStealPanel()
        local savedCanvasY = spListScrl.CanvasPosition.Y
        for _, ch in ipairs(spListScrl:GetChildren()) do
            if ch:IsA("Frame") then ch:Destroy() end
        end
        if State.activeStealButtons then
            table.clear(State.activeStealButtons)
        else
            State.activeStealButtons = {}
        end

        local eggItems = (opts.GetItems and opts.GetItems()) or {}

        table.sort(eggItems, function(a, b)
            if State.spSortChoice == "Value (Money/s)" then
                return (a.Value or 0) > (b.Value or 0)
            elseif State.spSortChoice == "Rarity" then
                if (a.Rank or 0) ~= (b.Rank or 0) then
                    return (a.Rank or 0) > (b.Rank or 0)
                end
                return (a.Value or 0) > (b.Value or 0)
            elseif State.spSortChoice == "Weight (Scale)" then
                return (a.Scale or 0) > (b.Scale or 0)
            end
            return (a.Value or 0) > (b.Value or 0)
        end)

        local activeTheme = ctx.ActiveTheme

        for i, item in ipairs(eggItems) do
            local card = Instance.new("Frame", spListScrl)
            card.Size = UDim2.new(1, -4, 0, 50)
            card.BackgroundColor3 = activeTheme.CardBg
            card.BackgroundTransparency = 0.20
            card.BorderSizePixel = 0
            card.LayoutOrder = i
            Utils:RoundCorner(card, 12)

            local cStr = Instance.new("UIStroke", card)
            cStr.Thickness = 1
            cStr.Color = activeTheme.Stroke
            cStr.Transparency = 0.40

            local img = Instance.new("ImageLabel", card)
            img.Size = UDim2.new(0, 36, 0, 36)
            img.Position = UDim2.new(0, 7, 0.5, -18)
            img.BackgroundColor3 = activeTheme.RowBg
            img.BackgroundTransparency = 0.25
            img.BorderSizePixel = 0
            img.Image = tostring(item.Icon or "")
            Utils:RoundCorner(img, 8)

            local nameLbl = Instance.new("TextLabel", card)
            nameLbl.Size = UDim2.new(1, -135, 0, 18)
            nameLbl.Position = UDim2.new(0, 48, 0, 7)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 12
            nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            nameLbl.Text = string.format("%s [%s]", tostring(item.Name or "Egg"), tostring(item.Rarity or "Common"))

            local subLbl = Instance.new("TextLabel", card)
            subLbl.Size = UDim2.new(1, -135, 0, 16)
            subLbl.Position = UDim2.new(0, 48, 0, 26)
            subLbl.BackgroundTransparency = 1
            subLbl.Font = Enum.Font.Gotham
            subLbl.TextSize = 9.5
            subLbl.TextColor3 = activeTheme.SubText
            subLbl.TextXAlignment = Enum.TextXAlignment.Left
            subLbl.Text = string.format("%s  |  %.2fx  |  %s", formatValue(item.Value or 0), tonumber(item.Scale) or 1, tostring(item.Area or "Unknown"))

            local actBtn = Instance.new("TextButton", card)
            actBtn.Size = UDim2.new(0, 76, 0, 28)
            actBtn.Position = UDim2.new(1, -82, 0.5, -14)
            actBtn.BorderSizePixel = 0
            actBtn.Font = Enum.Font.GothamBold
            actBtn.TextSize = 11.5
            actBtn:SetAttribute("NoTrans", true)
            Utils:RoundCorner(actBtn, 999)
            Animations:AttachTactile(actBtn, ctx.Connections)

            local isThisTarget = (State.targetedSpecificUid == item.Uid)
            actBtn.BackgroundColor3 = isThisTarget and Color3.fromRGB(240, 65, 60) or activeTheme.Accent
            actBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            actBtn.Text = isThisTarget and "Stop Steal" or "Steal"

            State.activeStealButtons[item.Uid] = actBtn

            actBtn.MouseButton1Click:Connect(function()
                if opts.OnSelectItem then
                    opts.OnSelectItem(item, actBtn)
                end
            end)
        end
        spListScrl.CanvasPosition = Vector2.new(0, savedCanvasY)
    end

    local spSortOptions = opts.SortOptions or { "Value (Money/s)", "Rarity", "Weight (Scale)" }
    table.insert(ctx.Connections, spSortBtn.MouseButton1Click:Connect(function()
        State.spSortIndex = ((State.spSortIndex or 1) % #spSortOptions) + 1
        State.spSortChoice = spSortOptions[State.spSortIndex]
        spSortBtn.Text = State.spSortChoice .. "  v"
        renderStealPanel()
    end))

    return renderStealPanel
end

return Panels