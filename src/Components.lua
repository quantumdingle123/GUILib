-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY - MODULE: Components.lua ]
-- Provides reusable UI controls: Categories, Toggles, Sliders, Floating Dropdowns,
-- Multi-Dropdowns, Buttons, Textboxes, Labels, and Separators.
-- ==============================================================================

local RunService = game:GetService("RunService")

local Components = {}

function Components:CreateCategory(ctx, title, parent, order, defaultOpen)
    local Animations = ctx.Animations
    local Utils = ctx.Utils
    local activeTheme = ctx.ActiveTheme

    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundColor3 = activeTheme.CardBg
    frame.BackgroundTransparency = 0.22
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.LayoutOrder = order or 1
    Utils:RoundCorner(frame, 14)

    local fStr = Instance.new("UIStroke", frame)
    fStr.Thickness = 1
    fStr.Color = activeTheme.Stroke
    fStr.Transparency = 0.35

    local header = Instance.new("TextButton", frame)
    header.Size = UDim2.new(1, 0, 0, 44)
    header.BackgroundTransparency = 1
    header.Text = ""
    header.AutoButtonColor = false

    local bar = Instance.new("Frame", header)
    bar.Size = UDim2.new(0, 3.5, 0, 18)
    bar.Position = UDim2.new(0, 12, 0.5, -9)
    bar.BackgroundColor3 = activeTheme.Accent
    bar.BorderSizePixel = 0
    bar:SetAttribute("NoTrans", true)
    Utils:RoundCorner(bar, 999)

    local titleLbl = Instance.new("TextLabel", header)
    titleLbl.Size = UDim2.new(1, -65, 1, 0)
    titleLbl.Position = UDim2.new(0, 24, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Text = tostring(title or "Category")

    local arrow = Instance.new("TextLabel", header)
    arrow.Size = UDim2.new(0, 28, 0, 28)
    arrow.AnchorPoint = Vector2.new(0.5, 0.5)
    arrow.Position = UDim2.new(1, -18, 0.5, 0)
    arrow.BackgroundTransparency = 1
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 13
    arrow.TextColor3 = activeTheme.Accent2
    arrow.Text = ">"
    arrow.Rotation = defaultOpen and 90 or 0

    local divLine = Instance.new("Frame", frame)
    divLine.Size = UDim2.new(1, -24, 0, 1)
    divLine.Position = UDim2.new(0, 12, 0, 44)
    divLine.BackgroundColor3 = activeTheme.Stroke
    divLine.BackgroundTransparency = defaultOpen and 0.50 or 1
    divLine.BorderSizePixel = 0
    divLine:SetAttribute("NoTrans", true)

    -- Position content at Y = 56 (12px breathing room below the 44px header)
    local content = Instance.new("Frame", frame)
    content.Name = "Content"
    content.Position = UDim2.new(0, 0, 0, 56)
    content.Size = UDim2.new(1, 0, 0, 0)
    content.BackgroundTransparency = 1
    content.Visible = true

    local cPad = Instance.new("UIPadding", content)
    cPad.PaddingLeft = UDim.new(0, 10)
    cPad.PaddingRight = UDim.new(0, 10)

    local cLay = Instance.new("UIListLayout", content)
    cLay.Padding = UDim.new(0, 10)
    cLay.SortOrder = Enum.SortOrder.LayoutOrder

    local isOpen = defaultOpen or false

    local function updateSize()
        if not isOpen and ctx.State.activeOpenedDropdown then
            ctx.State.activeOpenedDropdown()
        end
        local contentH = cLay.AbsoluteContentSize.Y
        content.Size = UDim2.new(1, 0, 0, contentH)
        local targetH = 56 + contentH + 12
        if isOpen then
            Animations:Tween(divLine, Animations.Smooth, { BackgroundTransparency = 0.50 })
            Animations:Tween(frame, Animations.Smooth, { Size = UDim2.new(1, 0, 0, targetH) })
            Animations:Tween(arrow, Animations.Fast, { Rotation = 90 })
        else
            Animations:Tween(divLine, Animations.Fast, { BackgroundTransparency = 1 })
            Animations:Tween(frame, Animations.Smooth, { Size = UDim2.new(1, 0, 0, 44) })
            Animations:Tween(arrow, Animations.Fast, { Rotation = 0 })
        end
    end

    table.insert(ctx.Connections, cLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local contentH = cLay.AbsoluteContentSize.Y
        content.Size = UDim2.new(1, 0, 0, contentH)
        if isOpen then
            local targetH = 56 + contentH + 12
            Animations:Tween(frame, Animations.Smooth, { Size = UDim2.new(1, 0, 0, targetH) })
        end
    end))

    table.insert(ctx.Connections, header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        updateSize()
    end))

    if defaultOpen then
        task.defer(function()
            task.wait(0.05)
            if isOpen then
                local contentH = cLay.AbsoluteContentSize.Y
                content.Size = UDim2.new(1, 0, 0, contentH)
                frame.Size = UDim2.new(1, 0, 0, 56 + contentH + 12)
            end
        end)
    end

    table.insert(ctx.State.themeSubscribers, function(th)
        frame.BackgroundColor3 = th.CardBg
        fStr.Color = th.Stroke
        bar.BackgroundColor3 = th.Accent
        arrow.TextColor3 = th.Accent2
        divLine.BackgroundColor3 = th.Stroke
    end)

    -- Build object API for adding controls directly to this category
    local CategoryObj = {
        Container = content,
        Frame = frame,
        NextOrder = 0
    }

    local function nextOrder(explicitOrder)
        if explicitOrder then
            if explicitOrder > CategoryObj.NextOrder then
                CategoryObj.NextOrder = explicitOrder
            end
            return explicitOrder
        end
        CategoryObj.NextOrder = CategoryObj.NextOrder + 1
        return CategoryObj.NextOrder
    end

    function CategoryObj:CreateToggle(tTitle, desc, defaultState, callback, explicitOrder)
        return Components:CreateToggle(ctx, tTitle, desc, defaultState, content, nextOrder(explicitOrder), callback)
    end

    function CategoryObj:CreateSlider(sTitle, desc, min, max, defaultVal, increment, callback, explicitOrder)
        return Components:CreateSlider(ctx, sTitle, desc, min, max, defaultVal, increment, content, nextOrder(explicitOrder), callback)
    end

    function CategoryObj:CreateDropdown(dTitle, desc, items, defaultVal, callback, explicitOrder)
        return Components:CreateDropdown(ctx, dTitle, desc, items, defaultVal, content, nextOrder(explicitOrder), callback)
    end

    function CategoryObj:CreateMultiDropdown(dTitle, desc, items, defaultMap, callback, explicitOrder)
        return Components:CreateMultiDropdown(ctx, dTitle, desc, items, defaultMap, content, nextOrder(explicitOrder), callback)
    end

    function CategoryObj:CreateButton(bTitle, desc, btnText, callback, explicitOrder)
        return Components:CreateButton(ctx, bTitle, desc, btnText, content, nextOrder(explicitOrder), callback)
    end

    function CategoryObj:CreateTextbox(tbTitle, desc, placeholder, defaultText, callback, explicitOrder)
        return Components:CreateTextbox(ctx, tbTitle, desc, placeholder, defaultText, content, nextOrder(explicitOrder), callback)
    end

    function CategoryObj:CreateLabel(text, explicitOrder)
        return Components:CreateLabel(ctx, text, content, nextOrder(explicitOrder))
    end

    function CategoryObj:CreateSeparator(explicitOrder)
        return Components:CreateSeparator(ctx, content, nextOrder(explicitOrder))
    end

    return CategoryObj, content
end

function Components:CreateToggle(ctx, title, desc, defaultState, parent, order, callback)
    local Animations = ctx.Animations
    local Utils = ctx.Utils
    local activeTheme = ctx.ActiveTheme

    local state = defaultState or false
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 52)
    row.BackgroundColor3 = activeTheme.RowBg
    row.BackgroundTransparency = 0.22
    row.BorderSizePixel = 0
    row.LayoutOrder = order or 1
    Utils:RoundCorner(row, 10)

    local rowStr = Instance.new("UIStroke", row)
    rowStr.Thickness = 1
    rowStr.Color = activeTheme.Stroke
    rowStr.Transparency = 0.40

    local tit = Instance.new("TextLabel", row)
    tit.Size = UDim2.new(1, -76, 0, 18)
    tit.Position = UDim2.new(0, 12, 0, 7)
    tit.BackgroundTransparency = 1
    tit.Font = Enum.Font.GothamBold
    tit.TextSize = 12
    tit.TextColor3 = Color3.fromRGB(255, 255, 255)
    tit.TextXAlignment = Enum.TextXAlignment.Left
    tit.Text = tostring(title or "Toggle")

    local sub = Instance.new("TextLabel", row)
    sub.Size = UDim2.new(1, -76, 0, 20)
    sub.Position = UDim2.new(0, 12, 0, 25)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 9.5
    sub.TextColor3 = activeTheme.SubText
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.TextWrapped = true
    sub.Text = tostring(desc or "")

    local sw = Instance.new("TextButton", row)
    sw.AnchorPoint = Vector2.new(1, 0.5)
    sw.Size = UDim2.new(0, 44, 0, 24)
    sw.Position = UDim2.new(1, -12, 0.5, 0)
    sw.BackgroundColor3 = state and activeTheme.Accent or activeTheme.SwitchOff
    sw.BackgroundTransparency = state and 0 or 0.12
    sw.BorderSizePixel = 0
    sw.Text = ""
    sw.AutoButtonColor = false
    sw:SetAttribute("NoTrans", true)
    Utils:RoundCorner(sw, 999)

    local swStr = Instance.new("UIStroke", sw)
    swStr.Thickness = 1.2
    swStr.Color = state and activeTheme.Accent2 or activeTheme.Stroke
    swStr.Transparency = state and 0.15 or 0.25
    swStr:SetAttribute("NoTrans", true)

    local dot = Instance.new("Frame", sw)
    dot.AnchorPoint = Vector2.new(0, 0.5)
    dot.Size = UDim2.new(0, 18, 0, 18)
    dot.Position = state and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BorderSizePixel = 0
    dot:SetAttribute("NoTrans", true)
    Utils:RoundCorner(dot, 999)

    local function setState(newState, fireCallback)
        state = (newState == true)
        Animations:Tween(sw, Animations.Fast, {
            BackgroundColor3 = state and ctx.ActiveTheme.Accent or ctx.ActiveTheme.SwitchOff,
            BackgroundTransparency = state and 0 or 0.12
        })
        Animations:Tween(swStr, Animations.Fast, {
            Color = state and ctx.ActiveTheme.Accent2 or ctx.ActiveTheme.Stroke,
            Transparency = state and 0.15 or 0.25
        })
        Animations:Tween(dot, Animations.iOSSpring, {
            Position = state and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        })
        if fireCallback and callback then
            callback(state)
        end
    end

    table.insert(ctx.Connections, sw.MouseButton1Click:Connect(function()
        setState(not state, true)
    end))

    table.insert(ctx.State.themeSubscribers, function(th)
        row.BackgroundColor3 = th.RowBg
        rowStr.Color = th.Stroke
        sub.TextColor3 = th.SubText
        if state then
            sw.BackgroundColor3 = th.Accent
            swStr.Color = th.Accent2
        else
            sw.BackgroundColor3 = th.SwitchOff
            swStr.Color = th.Stroke
        end
    end)

    return {
        Instance = row,
        SetValue = function(_, v, fire) setState(v, fire) end,
        GetValue = function() return state end
    }
end

function Components:CreateSlider(ctx, title, desc, min, max, defaultVal, increment, parent, order, callback)
    local Utils = ctx.Utils
    local activeTheme = ctx.ActiveTheme
    increment = increment or 1
    local curVal = math.clamp(tonumber(defaultVal) or min, min, max)

    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 52)
    row.BackgroundColor3 = activeTheme.RowBg
    row.BackgroundTransparency = 0.22
    row.BorderSizePixel = 0
    row.LayoutOrder = order or 1
    Utils:RoundCorner(row, 10)

    local rowStr = Instance.new("UIStroke", row)
    rowStr.Thickness = 1
    rowStr.Color = activeTheme.Stroke
    rowStr.Transparency = 0.40

    local tit = Instance.new("TextLabel", row)
    tit.Size = UDim2.new(1, -96, 0, 18)
    tit.Position = UDim2.new(0, 12, 0, 6)
    tit.BackgroundTransparency = 1
    tit.Font = Enum.Font.GothamBold
    tit.TextSize = 12
    tit.TextColor3 = Color3.fromRGB(255, 255, 255)
    tit.TextXAlignment = Enum.TextXAlignment.Left
    tit.Text = tostring(title or "Slider")

    local sub = Instance.new("TextLabel", row)
    sub.Size = UDim2.new(1, -96, 0, 20)
    sub.Position = UDim2.new(0, 12, 0, 24)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 9.5
    sub.TextColor3 = activeTheme.SubText
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Text = tostring(desc or "")

    local valLbl = Instance.new("TextLabel", row)
    valLbl.Size = UDim2.new(0, 75, 0, 18)
    valLbl.Position = UDim2.new(1, -87, 0, 6)
    valLbl.BackgroundTransparency = 1
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 11.5
    valLbl.TextColor3 = activeTheme.Accent2
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Text = tostring(curVal)

    local trk = Instance.new("Frame", row)
    trk.Size = UDim2.new(0, 80, 0, 6)
    trk.Position = UDim2.new(1, -92, 0.5, 6)
    trk.BackgroundColor3 = activeTheme.SwitchOff
    trk.BorderSizePixel = 0
    trk:SetAttribute("NoTrans", true)
    Utils:RoundCorner(trk, 999)

    local pct = math.clamp((curVal - min) / math.max(max - min, 0.0001), 0, 1)
    local fil = Instance.new("Frame", trk)
    fil.Size = UDim2.new(pct, 0, 1, 0)
    fil.BackgroundColor3 = activeTheme.Accent
    fil.BorderSizePixel = 0
    fil:SetAttribute("NoTrans", true)
    Utils:RoundCorner(fil, 999)

    local kn = Instance.new("TextButton", trk)
    kn.Size = UDim2.new(0, 15, 0, 15)
    kn.Position = UDim2.new(pct, -7.5, 0.5, -7.5)
    kn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    kn.BorderSizePixel = 0
    kn.Text = ""
    kn:SetAttribute("NoTrans", true)
    Utils:RoundCorner(kn, 999)

    local knStr = Instance.new("UIStroke", kn)
    knStr.Thickness = 1
    knStr.Color = Color3.fromRGB(200, 205, 220)
    knStr.Transparency = 0.4

    local function setValue(val, fireCallback)
        local snappedVal = math.floor((val / increment) + 0.5) * increment
        snappedVal = math.clamp(snappedVal, min, max)
        curVal = snappedVal
        local finalPct = (snappedVal - min) / math.max(max - min, 0.0001)
        fil.Size = UDim2.new(finalPct, 0, 1, 0)
        kn.Position = UDim2.new(finalPct, -7.5, 0.5, -7.5)
        valLbl.Text = tostring(snappedVal)
        if fireCallback and callback then callback(snappedVal) end
    end

    local function updateFromPos(inputPos)
        local relX = math.clamp(inputPos.X - trk.AbsolutePosition.X, 0, trk.AbsoluteSize.X)
        local newPct = relX / math.max(trk.AbsoluteSize.X, 1)
        local rawVal = min + (max - min) * newPct
        setValue(rawVal, true)
    end

    table.insert(ctx.Connections, trk.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateFromPos(input.Position)
            local moveConn
            moveConn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.Change then
                    updateFromPos(input.Position)
                elseif input.UserInputState == Enum.UserInputState.End then
                    if moveConn then moveConn:Disconnect() end
                end
            end)
            table.insert(ctx.Connections, moveConn)
        end
    end))

    table.insert(ctx.State.themeSubscribers, function(th)
        row.BackgroundColor3 = th.RowBg
        rowStr.Color = th.Stroke
        sub.TextColor3 = th.SubText
        valLbl.TextColor3 = th.Accent2
        fil.BackgroundColor3 = th.Accent
        trk.BackgroundColor3 = th.SwitchOff
    end)

    return {
        Instance = row,
        SetValue = function(_, v, fire) setValue(v, fire) end,
        GetValue = function() return curVal end
    }
end

function Components:CreateDropdown(ctx, title, desc, items, defaultVal, parent, order, callback)
    local Animations = ctx.Animations
    local Utils = ctx.Utils
    local activeTheme = ctx.ActiveTheme
    local frm = ctx.MainFrame
    local cntFrame = ctx.ContentFrame
    local popupLayer = ctx.PopupLayer

    local isExpanded = false
    local currentVal = tostring(defaultVal or "All")
    local dropWidth = 128
    local dropHeight = math.clamp(#items * 26 + 8, 60, 114)
    local activeDropTween = nil
    local stepConn = nil

    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 52)
    row.BackgroundColor3 = activeTheme.RowBg
    row.BackgroundTransparency = 0.22
    row.BorderSizePixel = 0
    row.LayoutOrder = order or 1
    Utils:RoundCorner(row, 10)

    local rowStr = Instance.new("UIStroke", row)
    rowStr.Thickness = 1
    rowStr.Color = activeTheme.Stroke
    rowStr.Transparency = 0.40

    local tit = Instance.new("TextLabel", row)
    tit.Size = UDim2.new(1, -(dropWidth + 24), 0, 18)
    tit.Position = UDim2.new(0, 12, 0, 7)
    tit.BackgroundTransparency = 1
    tit.Font = Enum.Font.GothamBold
    tit.TextSize = 12
    tit.TextColor3 = Color3.fromRGB(255, 255, 255)
    tit.TextXAlignment = Enum.TextXAlignment.Left
    tit.Text = tostring(title or "Dropdown")

    local sub = Instance.new("TextLabel", row)
    sub.Size = UDim2.new(1, -(dropWidth + 24), 0, 20)
    sub.Position = UDim2.new(0, 12, 0, 25)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 9.5
    sub.TextColor3 = activeTheme.SubText
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.TextWrapped = true
    sub.Text = tostring(desc or "")

    local box = Instance.new("TextButton", row)
    box.AnchorPoint = Vector2.new(1, 0.5)
    box.Size = UDim2.new(0, dropWidth, 0, 28)
    box.Position = UDim2.new(1, -10, 0.5, 0)
    box.BackgroundColor3 = activeTheme.BoxBg
    box.BackgroundTransparency = 0.12
    box.BorderSizePixel = 0
    box.Text = ""
    box.AutoButtonColor = false
    box:SetAttribute("NoTrans", true)
    Utils:RoundCorner(box, 8)

    local boxStr = Instance.new("UIStroke", box)
    boxStr.Thickness = 1
    boxStr.Color = activeTheme.Stroke
    boxStr.Transparency = 0.30
    boxStr:SetAttribute("NoTrans", true)

    local valLbl = Instance.new("TextLabel", box)
    valLbl.Size = UDim2.new(1, -24, 1, 0)
    valLbl.Position = UDim2.new(0, 8, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Font = Enum.Font.GothamMedium
    valLbl.TextSize = 10.5
    valLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    valLbl.TextXAlignment = Enum.TextXAlignment.Left
    valLbl.TextTruncate = Enum.TextTruncate.AtEnd
    valLbl.Text = currentVal

    local arr = Instance.new("TextLabel", box)
    arr.Size = UDim2.new(0, 16, 1, 0)
    arr.Position = UDim2.new(1, -18, 0, 0)
    arr.BackgroundTransparency = 1
    arr.Font = Enum.Font.GothamBold
    arr.TextSize = 11
    arr.TextColor3 = activeTheme.Accent2
    arr.Text = "v"

    local dropArea = Instance.new("Frame", popupLayer)
    dropArea.Name = "FloatingDropdown_" .. tostring(title)
    dropArea.Size = UDim2.new(0, dropWidth, 0, 0)
    dropArea.BackgroundColor3 = activeTheme.DropBg
    dropArea.BackgroundTransparency = 0.03
    dropArea.BorderSizePixel = 0
    dropArea.ClipsDescendants = true
    dropArea.Visible = false
    dropArea.ZIndex = 60
    dropArea:SetAttribute("NoTrans", true)
    Utils:RoundCorner(dropArea, 8)

    local dropAreaStr = Instance.new("UIStroke", dropArea)
    dropAreaStr.Thickness = 1.2
    dropAreaStr.Color = activeTheme.Stroke
    dropAreaStr.Transparency = 0.20
    dropAreaStr:SetAttribute("NoTrans", true)

    local optScrl = Instance.new("ScrollingFrame", dropArea)
    optScrl.Size = UDim2.new(1, -6, 1, -6)
    optScrl.Position = UDim2.new(0, 3, 0, 3)
    optScrl.BackgroundTransparency = 1
    optScrl.BorderSizePixel = 0
    optScrl.ScrollBarThickness = 2
    optScrl.ScrollBarImageColor3 = activeTheme.Accent2
    optScrl.ZIndex = 61

    local optLay = Instance.new("UIListLayout", optScrl)
    optLay.Padding = UDim.new(0, 2)
    optLay.SortOrder = Enum.SortOrder.LayoutOrder

    table.insert(ctx.Connections, optLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        optScrl.CanvasSize = UDim2.new(0, 0, 0, optLay.AbsoluteContentSize.Y + 4)
    end))

    local closeMenu

    local function updateDropPosition()
        if not box or not box.Parent or not frm or not frm.Parent or not box.Visible then
            return false, 0
        end
        local frmPos = frm.AbsolutePosition
        local frmSize = frm.AbsoluteSize
        local boxPos = box.AbsolutePosition
        local boxSize = box.AbsoluteSize

        local cntTop = cntFrame.AbsolutePosition.Y + 38
        local cntBot = cntFrame.AbsolutePosition.Y + cntFrame.AbsoluteSize.Y - 4
        if boxPos.Y + boxSize.Y < cntTop or boxPos.Y > cntBot then
            return false, 0
        end

        local catFrame = parent and parent.Parent
        if catFrame and catFrame:IsA("GuiObject") then
            local catBot = catFrame.AbsolutePosition.Y + catFrame.AbsoluteSize.Y
            if boxPos.Y + boxSize.Y > catBot + 2 then
                return false, 0
            end
        end

        local relX = boxPos.X - frmPos.X
        local relYBelow = (boxPos.Y - frmPos.Y) + boxSize.Y + 4
        local availBelow = frmSize.Y - relYBelow - 8

        if availBelow >= 72 then
            local targetH = math.min(dropHeight, availBelow)
            dropArea.AnchorPoint = Vector2.new(0, 0)
            dropArea.Position = UDim2.new(0, relX, 0, relYBelow)
            return true, targetH
        else
            local relYAbove = (boxPos.Y - frmPos.Y) - 4
            local availAbove = relYAbove - 50
            local targetH = math.min(dropHeight, math.max(68, availAbove))
            dropArea.AnchorPoint = Vector2.new(0, 1)
            dropArea.Position = UDim2.new(0, relX, 0, relYAbove)
            return true, targetH
        end
    end

    local function populateOptions()
        for _, ch in ipairs(optScrl:GetChildren()) do
            if ch:IsA("TextButton") then ch:Destroy() end
        end

        for i, item in ipairs(items) do
            local itemStr = tostring(item)
            local isSel = (itemStr == currentVal)

            local btn = Instance.new("TextButton", optScrl)
            btn.Size = UDim2.new(1, -4, 0, 24)
            btn.BackgroundColor3 = isSel and ctx.ActiveTheme.Accent or ctx.ActiveTheme.RowBg
            btn.BackgroundTransparency = isSel and 0.08 or 0.30
            btn.Text = (isSel and "  ✓ " or "    ") .. itemStr
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = isSel and Enum.Font.GothamBold or Enum.Font.GothamMedium
            btn.TextSize = 10.5
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.TextTruncate = Enum.TextTruncate.AtEnd
            btn.LayoutOrder = i
            btn.ZIndex = 62
            btn:SetAttribute("NoTrans", true)
            Utils:RoundCorner(btn, 6)

            btn.MouseButton1Click:Connect(function()
                currentVal = itemStr
                if callback then callback(item) end
                if closeMenu then closeMenu() end
            end)
        end
    end

    closeMenu = function()
        if not isExpanded then return end
        isExpanded = false
        if stepConn then stepConn:Disconnect(); stepConn = nil end
        if activeDropTween then activeDropTween:Cancel() end
        arr.Text = "v"
        valLbl.Text = currentVal
        valLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        boxStr.Color = ctx.ActiveTheme.Stroke
        activeDropTween = Animations:Tween(dropArea, Animations.Fast, { Size = UDim2.new(0, dropWidth, 0, 0) })
        activeDropTween.Completed:Connect(function()
            if not isExpanded then dropArea.Visible = false end
        end)
        if ctx.State.activeOpenedDropdown == closeMenu then
            ctx.State.activeOpenedDropdown = nil
        end
    end

    local function toggleMenu()
        if isExpanded then
            closeMenu()
        else
            if ctx.State.activeOpenedDropdown and ctx.State.activeOpenedDropdown ~= closeMenu then
                ctx.State.activeOpenedDropdown()
            end
            local ok, targetH = updateDropPosition()
            if not ok then return end

            isExpanded = true
            ctx.State.activeOpenedDropdown = closeMenu
            arr.Text = "^"
            valLbl.Text = "Select..."
            valLbl.TextColor3 = ctx.ActiveTheme.SubText
            boxStr.Color = ctx.ActiveTheme.Accent2
            populateOptions()

            if activeDropTween then activeDropTween:Cancel() end
            dropArea.Size = UDim2.new(0, dropWidth, 0, 0)
            dropArea.Visible = true
            activeDropTween = Animations:Tween(dropArea, Animations.Drop, { Size = UDim2.new(0, dropWidth, 0, targetH) })

            if stepConn then stepConn:Disconnect() end
            stepConn = RunService.RenderStepped:Connect(function()
                if not isExpanded then
                    if stepConn then stepConn:Disconnect(); stepConn = nil end
                    return
                end
                local stillVisible = updateDropPosition()
                if not stillVisible then
                    closeMenu()
                end
            end)
        end
    end

    table.insert(ctx.Connections, box.MouseButton1Click:Connect(toggleMenu))

    table.insert(ctx.State.themeSubscribers, function(th)
        row.BackgroundColor3 = th.RowBg
        rowStr.Color = th.Stroke
        sub.TextColor3 = th.SubText
        box.BackgroundColor3 = th.BoxBg
        boxStr.Color = isExpanded and th.Accent2 or th.Stroke
        valLbl.TextColor3 = isExpanded and th.SubText or Color3.fromRGB(255, 255, 255)
        dropArea.BackgroundColor3 = th.DropBg
        dropAreaStr.Color = th.Stroke
        optScrl.ScrollBarImageColor3 = th.Accent2
        arr.TextColor3 = th.Accent2
        if isExpanded then populateOptions() end
    end)

    return {
        Instance = row,
        SetValue = function(_, v, fire)
            currentVal = tostring(v)
            if not isExpanded then valLbl.Text = currentVal end
            if fire and callback then callback(v) end
        end,
        GetValue = function() return currentVal end,
        Refresh = function(_, newItems)
            if type(newItems) == "table" then
                items = newItems
                dropHeight = math.clamp(#items * 26 + 8, 60, 114)
                if isExpanded then populateOptions() end
            end
        end
    }
end

function Components:CreateMultiDropdown(ctx, title, desc, items, defaultMap, parent, order, callback)
    local Animations = ctx.Animations
    local Utils = ctx.Utils
    local activeTheme = ctx.ActiveTheme
    local frm = ctx.MainFrame
    local cntFrame = ctx.ContentFrame
    local popupLayer = ctx.PopupLayer

    local isExpanded = false
    local dropWidth = 128
    local dropHeight = math.clamp(#items * 26 + 8, 60, 114)
    local activeDropTween = nil
    local stepConn = nil

    local selectedMap = {}
    if type(defaultMap) == "table" then
        for k, v in pairs(defaultMap) do
            if v == true then selectedMap[k] = true end
        end
    end

    local isAreaMenu = (title == "Target Areas")
    if isAreaMenu then
        local hasSpecific = false
        for k, v in pairs(selectedMap) do
            if k ~= "All" and v == true then
                hasSpecific = true
                break
            end
        end
        if hasSpecific then
            selectedMap["All"] = nil
        elseif next(selectedMap) == nil then
            selectedMap["All"] = true
        end
    end

    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 52)
    row.BackgroundColor3 = activeTheme.RowBg
    row.BackgroundTransparency = 0.22
    row.BorderSizePixel = 0
    row.LayoutOrder = order or 1
    Utils:RoundCorner(row, 10)

    local rowStr = Instance.new("UIStroke", row)
    rowStr.Thickness = 1
    rowStr.Color = activeTheme.Stroke
    rowStr.Transparency = 0.40

    local tit = Instance.new("TextLabel", row)
    tit.Size = UDim2.new(1, -(dropWidth + 24), 0, 18)
    tit.Position = UDim2.new(0, 12, 0, 7)
    tit.BackgroundTransparency = 1
    tit.Font = Enum.Font.GothamBold
    tit.TextSize = 12
    tit.TextColor3 = Color3.fromRGB(255, 255, 255)
    tit.TextXAlignment = Enum.TextXAlignment.Left
    tit.Text = tostring(title or "Multi-Dropdown")

    local sub = Instance.new("TextLabel", row)
    sub.Size = UDim2.new(1, -(dropWidth + 24), 0, 20)
    sub.Position = UDim2.new(0, 12, 0, 25)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 9.5
    sub.TextColor3 = activeTheme.SubText
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.TextWrapped = true
    sub.Text = tostring(desc or "")

    local box = Instance.new("TextButton", row)
    box.AnchorPoint = Vector2.new(1, 0.5)
    box.Size = UDim2.new(0, dropWidth, 0, 28)
    box.Position = UDim2.new(1, -10, 0.5, 0)
    box.BackgroundColor3 = activeTheme.BoxBg
    box.BackgroundTransparency = 0.12
    box.BorderSizePixel = 0
    box.Text = ""
    box.AutoButtonColor = false
    box:SetAttribute("NoTrans", true)
    Utils:RoundCorner(box, 8)

    local boxStr = Instance.new("UIStroke", box)
    boxStr.Thickness = 1
    boxStr.Color = activeTheme.Stroke
    boxStr.Transparency = 0.30
    boxStr:SetAttribute("NoTrans", true)

    local valLbl = Instance.new("TextLabel", box)
    valLbl.Size = UDim2.new(1, -24, 1, 0)
    valLbl.Position = UDim2.new(0, 8, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Font = Enum.Font.GothamMedium
    valLbl.TextSize = 10.5
    valLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    valLbl.TextXAlignment = Enum.TextXAlignment.Left
    valLbl.TextTruncate = Enum.TextTruncate.AtEnd

    local function getSummaryText()
        local count = 0
        local lastKey = nil
        for k, v in pairs(selectedMap) do
            if v == true and (not isAreaMenu or k ~= "All") then
                count = count + 1
                lastKey = k
            end
        end

        if isAreaMenu and (selectedMap["All"] == true or count == 0) then
            return "All"
        elseif count == 0 then
            return "None"
        elseif count == 1 then
            return tostring(lastKey)
        else
            return tostring(count) .. " Selected"
        end
    end

    local function updateSummaryLabel()
        if isExpanded then
            valLbl.Text = "Select..."
            valLbl.TextColor3 = ctx.ActiveTheme.SubText
        else
            valLbl.Text = getSummaryText()
            valLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
    updateSummaryLabel()

    local arr = Instance.new("TextLabel", box)
    arr.Size = UDim2.new(0, 16, 1, 0)
    arr.Position = UDim2.new(1, -18, 0, 0)
    arr.BackgroundTransparency = 1
    arr.Font = Enum.Font.GothamBold
    arr.TextSize = 11
    arr.TextColor3 = activeTheme.Accent2
    arr.Text = "v"

    local dropArea = Instance.new("Frame", popupLayer)
    dropArea.Name = "FloatingMultiDropdown_" .. tostring(title)
    dropArea.Size = UDim2.new(0, dropWidth, 0, 0)
    dropArea.BackgroundColor3 = activeTheme.DropBg
    dropArea.BackgroundTransparency = 0.03
    dropArea.BorderSizePixel = 0
    dropArea.ClipsDescendants = true
    dropArea.Visible = false
    dropArea.ZIndex = 60
    dropArea:SetAttribute("NoTrans", true)
    Utils:RoundCorner(dropArea, 8)

    local dropAreaStr = Instance.new("UIStroke", dropArea)
    dropAreaStr.Thickness = 1.2
    dropAreaStr.Color = activeTheme.Stroke
    dropAreaStr.Transparency = 0.20
    dropAreaStr:SetAttribute("NoTrans", true)

    local optScrl = Instance.new("ScrollingFrame", dropArea)
    optScrl.Size = UDim2.new(1, -6, 1, -6)
    optScrl.Position = UDim2.new(0, 3, 0, 3)
    optScrl.BackgroundTransparency = 1
    optScrl.BorderSizePixel = 0
    optScrl.ScrollBarThickness = 2
    optScrl.ScrollBarImageColor3 = activeTheme.Accent2
    optScrl.ZIndex = 61

    local optLay = Instance.new("UIListLayout", optScrl)
    optLay.Padding = UDim.new(0, 2)
    optLay.SortOrder = Enum.SortOrder.LayoutOrder

    table.insert(ctx.Connections, optLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        optScrl.CanvasSize = UDim2.new(0, 0, 0, optLay.AbsoluteContentSize.Y + 4)
    end))

    local closeMenu

    local function updateDropPosition()
        if not box or not box.Parent or not frm or not frm.Parent or not box.Visible then
            return false, 0
        end
        local frmPos = frm.AbsolutePosition
        local frmSize = frm.AbsoluteSize
        local boxPos = box.AbsolutePosition
        local boxSize = box.AbsoluteSize

        local cntTop = cntFrame.AbsolutePosition.Y + 38
        local cntBot = cntFrame.AbsolutePosition.Y + cntFrame.AbsoluteSize.Y - 4
        if boxPos.Y + boxSize.Y < cntTop or boxPos.Y > cntBot then
            return false, 0
        end

        local catFrame = parent and parent.Parent
        if catFrame and catFrame:IsA("GuiObject") then
            local catBot = catFrame.AbsolutePosition.Y + catFrame.AbsoluteSize.Y
            if boxPos.Y + boxSize.Y > catBot + 2 then
                return false, 0
            end
        end

        local relX = boxPos.X - frmPos.X
        local relYBelow = (boxPos.Y - frmPos.Y) + boxSize.Y + 4
        local availBelow = frmSize.Y - relYBelow - 8

        if availBelow >= 72 then
            local targetH = math.min(dropHeight, availBelow)
            dropArea.AnchorPoint = Vector2.new(0, 0)
            dropArea.Position = UDim2.new(0, relX, 0, relYBelow)
            return true, targetH
        else
            local relYAbove = (boxPos.Y - frmPos.Y) - 4
            local availAbove = relYAbove - 50
            local targetH = math.min(dropHeight, math.max(68, availAbove))
            dropArea.AnchorPoint = Vector2.new(0, 1)
            dropArea.Position = UDim2.new(0, relX, 0, relYAbove)
            return true, targetH
        end
    end

    local function populateOptions()
        for _, ch in ipairs(optScrl:GetChildren()) do
            if ch:IsA("TextButton") then ch:Destroy() end
        end

        for i, item in ipairs(items) do
            local itemStr = tostring(item)
            local isSel = (selectedMap[itemStr] == true)

            local btn = Instance.new("TextButton", optScrl)
            btn.Size = UDim2.new(1, -4, 0, 24)
            btn.BackgroundColor3 = isSel and ctx.ActiveTheme.Accent or ctx.ActiveTheme.RowBg
            btn.BackgroundTransparency = isSel and 0.08 or 0.30
            btn.Text = (isSel and "  ✓ " or "    ") .. itemStr
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = isSel and Enum.Font.GothamBold or Enum.Font.GothamMedium
            btn.TextSize = 10.5
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.TextTruncate = Enum.TextTruncate.AtEnd
            btn.LayoutOrder = i
            btn.ZIndex = 62
            btn:SetAttribute("NoTrans", true)
            Utils:RoundCorner(btn, 6)

            btn.MouseButton1Click:Connect(function()
                if isAreaMenu then
                    if itemStr == "All" then
                        table.clear(selectedMap)
                        selectedMap["All"] = true
                    else
                        selectedMap["All"] = nil
                        if selectedMap[itemStr] then
                            selectedMap[itemStr] = nil
                        else
                            selectedMap[itemStr] = true
                        end
                        local anySel = false
                        for k, v in pairs(selectedMap) do
                            if v == true then anySel = true; break end
                        end
                        if not anySel then selectedMap["All"] = true end
                    end
                else
                    if selectedMap[itemStr] then
                        selectedMap[itemStr] = nil
                    else
                        selectedMap[itemStr] = true
                    end
                end

                populateOptions()
                if callback then callback(selectedMap) end
            end)
        end
    end

    closeMenu = function()
        if not isExpanded then return end
        isExpanded = false
        if stepConn then stepConn:Disconnect(); stepConn = nil end
        if activeDropTween then activeDropTween:Cancel() end
        arr.Text = "v"
        updateSummaryLabel()
        boxStr.Color = ctx.ActiveTheme.Stroke
        activeDropTween = Animations:Tween(dropArea, Animations.Fast, { Size = UDim2.new(0, dropWidth, 0, 0) })
        activeDropTween.Completed:Connect(function()
            if not isExpanded then dropArea.Visible = false end
        end)
        if ctx.State.activeOpenedDropdown == closeMenu then
            ctx.State.activeOpenedDropdown = nil
        end
    end

    local function toggleMenu()
        if isExpanded then
            closeMenu()
        else
            if ctx.State.activeOpenedDropdown and ctx.State.activeOpenedDropdown ~= closeMenu then
                ctx.State.activeOpenedDropdown()
            end
            local ok, targetH = updateDropPosition()
            if not ok then return end

            isExpanded = true
            ctx.State.activeOpenedDropdown = closeMenu
            arr.Text = "^"
            updateSummaryLabel()
            boxStr.Color = ctx.ActiveTheme.Accent2
            populateOptions()

            if activeDropTween then activeDropTween:Cancel() end
            dropArea.Size = UDim2.new(0, dropWidth, 0, 0)
            dropArea.Visible = true
            activeDropTween = Animations:Tween(dropArea, Animations.Drop, { Size = UDim2.new(0, dropWidth, 0, targetH) })

            if stepConn then stepConn:Disconnect() end
            stepConn = RunService.RenderStepped:Connect(function()
                if not isExpanded then
                    if stepConn then stepConn:Disconnect(); stepConn = nil end
                    return
                end
                local stillVisible = updateDropPosition()
                if not stillVisible then
                    closeMenu()
                end
            end)
        end
    end

    table.insert(ctx.Connections, box.MouseButton1Click:Connect(toggleMenu))

    table.insert(ctx.State.themeSubscribers, function(th)
        row.BackgroundColor3 = th.RowBg
        rowStr.Color = th.Stroke
        sub.TextColor3 = th.SubText
        box.BackgroundColor3 = th.BoxBg
        boxStr.Color = isExpanded and th.Accent2 or th.Stroke
        updateSummaryLabel()
        dropArea.BackgroundColor3 = th.DropBg
        dropAreaStr.Color = th.Stroke
        optScrl.ScrollBarImageColor3 = th.Accent2
        arr.TextColor3 = th.Accent2
        if isExpanded then populateOptions() end
    end)

    return {
        Instance = row,
        GetValue = function() return selectedMap end,
        SetValue = function(_, newMap, fire)
            if type(newMap) == "table" then
                table.clear(selectedMap)
                for k, v in pairs(newMap) do
                    if v == true then selectedMap[k] = true end
                end
                updateSummaryLabel()
                if fire and callback then callback(selectedMap) end
            end
        end
    }
end

function Components:CreateButton(ctx, title, desc, btnText, parent, order, callback)
    local Animations = ctx.Animations
    local Utils = ctx.Utils
    local activeTheme = ctx.ActiveTheme

    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 52)
    row.BackgroundColor3 = activeTheme.RowBg
    row.BackgroundTransparency = 0.22
    row.BorderSizePixel = 0
    row.LayoutOrder = order or 1
    Utils:RoundCorner(row, 10)

    local rowStr = Instance.new("UIStroke", row)
    rowStr.Thickness = 1
    rowStr.Color = activeTheme.Stroke
    rowStr.Transparency = 0.40

    local tit = Instance.new("TextLabel", row)
    tit.Size = UDim2.new(1, -110, 0, 18)
    tit.Position = UDim2.new(0, 12, 0, 7)
    tit.BackgroundTransparency = 1
    tit.Font = Enum.Font.GothamBold
    tit.TextSize = 12
    tit.TextColor3 = Color3.fromRGB(255, 255, 255)
    tit.TextXAlignment = Enum.TextXAlignment.Left
    tit.Text = tostring(title or "Action")

    local sub = Instance.new("TextLabel", row)
    sub.Size = UDim2.new(1, -110, 0, 20)
    sub.Position = UDim2.new(0, 12, 0, 25)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 9.5
    sub.TextColor3 = activeTheme.SubText
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.TextWrapped = true
    sub.Text = tostring(desc or "")

    local btn = Instance.new("TextButton", row)
    btn.AnchorPoint = Vector2.new(1, 0.5)
    btn.Size = UDim2.new(0, 86, 0, 28)
    btn.Position = UDim2.new(1, -10, 0.5, 0)
    btn.BackgroundColor3 = activeTheme.Accent
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = tostring(btnText or "Run")
    btn:SetAttribute("NoTrans", true)
    Utils:RoundCorner(btn, 999)
    Animations:AttachTactile(btn, ctx.Connections)

    table.insert(ctx.Connections, btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end))

    table.insert(ctx.State.themeSubscribers, function(th)
        row.BackgroundColor3 = th.RowBg
        rowStr.Color = th.Stroke
        sub.TextColor3 = th.SubText
        btn.BackgroundColor3 = th.Accent
    end)

    return {
        Instance = row,
        Button = btn
    }
end

function Components:CreateTextbox(ctx, title, desc, placeholder, defaultText, parent, order, callback)
    local Utils = ctx.Utils
    local activeTheme = ctx.ActiveTheme

    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 52)
    row.BackgroundColor3 = activeTheme.RowBg
    row.BackgroundTransparency = 0.22
    row.BorderSizePixel = 0
    row.LayoutOrder = order or 1
    Utils:RoundCorner(row, 10)

    local rowStr = Instance.new("UIStroke", row)
    rowStr.Thickness = 1
    rowStr.Color = activeTheme.Stroke
    rowStr.Transparency = 0.40

    local tit = Instance.new("TextLabel", row)
    tit.Size = UDim2.new(1, -148, 0, 18)
    tit.Position = UDim2.new(0, 12, 0, 7)
    tit.BackgroundTransparency = 1
    tit.Font = Enum.Font.GothamBold
    tit.TextSize = 12
    tit.TextColor3 = Color3.fromRGB(255, 255, 255)
    tit.TextXAlignment = Enum.TextXAlignment.Left
    tit.Text = tostring(title or "Input")

    local sub = Instance.new("TextLabel", row)
    sub.Size = UDim2.new(1, -148, 0, 20)
    sub.Position = UDim2.new(0, 12, 0, 25)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 9.5
    sub.TextColor3 = activeTheme.SubText
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.TextWrapped = true
    sub.Text = tostring(desc or "")

    local inp = Instance.new("TextBox", row)
    inp.AnchorPoint = Vector2.new(1, 0.5)
    inp.Size = UDim2.new(0, 128, 0, 28)
    inp.Position = UDim2.new(1, -10, 0.5, 0)
    inp.BackgroundColor3 = activeTheme.BoxBg
    inp.BackgroundTransparency = 0.12
    inp.BorderSizePixel = 0
    inp.Font = Enum.Font.GothamMedium
    inp.TextSize = 10.5
    inp.TextColor3 = Color3.fromRGB(255, 255, 255)
    inp.PlaceholderText = tostring(placeholder or "Enter text...")
    inp.PlaceholderColor3 = activeTheme.SubText
    inp.Text = tostring(defaultText or "")
    inp.ClearTextOnFocus = false
    inp:SetAttribute("NoTrans", true)
    Utils:RoundCorner(inp, 8)

    local inpStr = Instance.new("UIStroke", inp)
    inpStr.Thickness = 1
    inpStr.Color = activeTheme.Stroke
    inpStr.Transparency = 0.30
    inpStr:SetAttribute("NoTrans", true)

    table.insert(ctx.Connections, inp.Focused:Connect(function()
        inpStr.Color = ctx.ActiveTheme.Accent2
        inpStr.Transparency = 0.05
    end))

    table.insert(ctx.Connections, inp.FocusLost:Connect(function(enterPressed)
        inpStr.Color = ctx.ActiveTheme.Stroke
        inpStr.Transparency = 0.30
        if callback then callback(inp.Text, enterPressed) end
    end))

    table.insert(ctx.State.themeSubscribers, function(th)
        row.BackgroundColor3 = th.RowBg
        rowStr.Color = th.Stroke
        sub.TextColor3 = th.SubText
        inp.BackgroundColor3 = th.BoxBg
        inp.PlaceholderColor3 = th.SubText
        inpStr.Color = th.Stroke
    end)

    return {
        Instance = row,
        TextBox = inp,
        GetValue = function() return inp.Text end,
        SetValue = function(_, v) inp.Text = tostring(v or "") end
    }
end

function Components:CreateLabel(ctx, text, parent, order)
    local Utils = ctx.Utils
    local activeTheme = ctx.ActiveTheme

    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundColor3 = activeTheme.RowBg
    row.BackgroundTransparency = 0.35
    row.BorderSizePixel = 0
    row.LayoutOrder = order or 1
    Utils:RoundCorner(row, 8)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = tostring(text or "")

    table.insert(ctx.State.themeSubscribers, function(th)
        row.BackgroundColor3 = th.RowBg
    end)

    return {
        Instance = row,
        SetText = function(_, newText) lbl.Text = tostring(newText or "") end
    }
end

function Components:CreateSeparator(ctx, parent, order)
    local sep = Instance.new("Frame", parent)
    sep.Size = UDim2.new(1, -16, 0, 1)
    sep.BackgroundColor3 = ctx.ActiveTheme.Stroke
    sep.BackgroundTransparency = 0.55
    sep.BorderSizePixel = 0
    sep.LayoutOrder = order or 1
    sep:SetAttribute("NoTrans", true)

    table.insert(ctx.State.themeSubscribers, function(th)
        sep.BackgroundColor3 = th.Stroke
    end)

    return sep
end

return Components
