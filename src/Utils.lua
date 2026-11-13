-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY - MODULE: Utils.lua ]
-- Provides instance helpers, corner/gradient builders, drag logic, and cleanup tracking.
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")

local Utils = {}

function Utils:ElevateIdentity(level)
    local setId = setthreadidentity or set_thread_identity
    if type(setId) == "function" then
        pcall(setId, level or 7)
    end
end

function Utils:SafeParent(inst, parent)
    if not inst then return false end
    local ok = pcall(function()
        inst.Parent = parent
    end)
    return ok
end

function Utils:ProtectGui(gui)
    if not gui then return end
    pcall(function()
        gui:SetAttribute("SyntaxisInstance", true)
    end)
    if typeof(syn) == "table" and typeof(syn.protect_gui) == "function" then
        pcall(syn.protect_gui, gui)
    elseif typeof(protectgui) == "function" then
        pcall(protectgui, gui)
    end
end

function Utils:GetSafeParent()
    if RunService:IsStudio() then
        local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
        return lp:WaitForChild("PlayerGui")
    end

    local safeContainer = nil
    if typeof(gethui) == "function" then
        local ok, res = pcall(gethui)
        if ok and typeof(res) == "Instance" then safeContainer = res end
    end
    if not safeContainer then
        pcall(function()
            local cg = game:GetService("CoreGui")
            if cg and typeof(cg) == "Instance" then safeContainer = cg end
        end)
    end
    if not safeContainer then
        local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
        safeContainer = lp:WaitForChild("PlayerGui")
    end
    return safeContainer
end

function Utils:RoundCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
    return c
end

function Utils:MakeGradient(parent, rotation)
    local g = Instance.new("UIGradient")
    g.Rotation = rotation or 0
    g.Parent = parent
    return g
end

function Utils:MakeDraggable(handle, target, connList)
    if not handle or not target then return end
    handle.Active = true

    local dragging = false
    local dragStart = nil
    local startPos = nil

    local function update(input)
        local delta = input.Position - dragStart
        target.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    local c1 = handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position

            local inputEndedConn
            inputEndedConn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if inputEndedConn then inputEndedConn:Disconnect() end
                end
            end)
            if connList then table.insert(connList, inputEndedConn) end
        end
    end)

    local c2 = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    local c3 = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    if connList then
        table.insert(connList, c1)
        table.insert(connList, c2)
        table.insert(connList, c3)
    end
end

function Utils:BindSliderDrag(handles, track, connList, onDrag, onEnd)
    if type(handles) ~= "table" then
        handles = { handles }
    end

    local dragging = false
    local dragInputType = nil
    local activeTouch = nil
    local touchScroll = nil
    local touchScrollWasEnabled = nil
    local activeStateConn = nil

    local function disconnectStateConn()
        if activeStateConn then
            pcall(function() activeStateConn:Disconnect() end)
            activeStateConn = nil
        end
    end

    local function finishDrag()
        disconnectStateConn()
        if not dragging then return end
        dragging = false
        dragInputType = nil
        activeTouch = nil
        if touchScroll and touchScroll.Parent and touchScrollWasEnabled ~= nil then
            touchScroll.ScrollingEnabled = touchScrollWasEnabled
        end
        touchScroll = nil
        touchScrollWasEnabled = nil
        if onEnd then onEnd() end
    end

    local function startDrag(input)
        if not track or not track.Parent then return end
        local uType = input.UserInputType
        if uType ~= Enum.UserInputType.MouseButton1 and uType ~= Enum.UserInputType.Touch then
            return
        end
        if dragging then return end

        dragging = true
        dragInputType = uType
        activeTouch = (uType == Enum.UserInputType.Touch) and input or nil

        if uType == Enum.UserInputType.Touch then
            local scrl = track:FindFirstAncestorOfClass("ScrollingFrame")
            if scrl then
                touchScroll = scrl
                touchScrollWasEnabled = scrl.ScrollingEnabled
                scrl.ScrollingEnabled = false
            end
        end

        if onDrag then onDrag(input.Position) end

        disconnectStateConn()
        activeStateConn = input.Changed:Connect(function()
            if not track or not track.Parent or input.UserInputState == Enum.UserInputState.End or input.UserInputState == Enum.UserInputState.Cancel then
                finishDrag()
            elseif dragging and uType == Enum.UserInputType.Touch and input == activeTouch and input.UserInputState == Enum.UserInputState.Change then
                if onDrag then onDrag(input.Position) end
            end
        end)
    end

    for _, handle in ipairs(handles) do
        if handle then
            local cBegan = handle.InputBegan:Connect(startDrag)
            if connList then table.insert(connList, cBegan) end
        end
    end

    local cMove = UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if not track or not track.Parent then
            finishDrag()
            return
        end
        if dragInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement then
            if onDrag then onDrag(input.Position) end
        elseif dragInputType == Enum.UserInputType.Touch and input == activeTouch then
            if onDrag then onDrag(input.Position) end
        end
    end)

    local cEnd = UserInputService.InputEnded:Connect(function(input)
        if not dragging then return end
        if dragInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseButton1 then
            finishDrag()
        elseif dragInputType == Enum.UserInputType.Touch and input == activeTouch then
            finishDrag()
        end
    end)

    local cFocus = UserInputService.WindowFocusReleased:Connect(function()
        finishDrag()
    end)

    local cCleanup = {
        Disconnect = function()
            finishDrag()
        end
    }

    if connList then
        table.insert(connList, cMove)
        table.insert(connList, cEnd)
        table.insert(connList, cFocus)
        table.insert(connList, cCleanup)
    end
end

local TABULAR_FONT_ASSET = "rbxasset://fonts/families/RobotoMono.json"

function Utils:ApplyTabularFont(label, weight, fallbackFont)
    if not label then return nil end
    local enumFont = fallbackFont or Enum.Font.RobotoMono
    label.Font = enumFont
    local ok, fontFace = pcall(function()
        return Font.new(TABULAR_FONT_ASSET, weight or Enum.FontWeight.Bold)
    end)
    if ok and fontFace then
        pcall(function() label.FontFace = fontFace end)
        return fontFace
    end
    return nil
end

function Utils:MeasureTextWidth(text, textSize, fontFace, fallbackEnumFont)
    if fontFace then
        local ok, bounds = pcall(function()
            local params = Instance.new("GetTextBoundsParams")
            params.Text = tostring(text or "")
            params.Font = fontFace
            params.Size = textSize
            params.Width = 2000
            return TextService:GetTextBoundsAsync(params)
        end)
        if ok and bounds then
            return bounds.X
        end
    end
    local okFallback, sz = pcall(function()
        return TextService:GetTextSize(
            tostring(text or ""),
            textSize,
            fallbackEnumFont or Enum.Font.RobotoMono,
            Vector2.new(2000, 200)
        )
    end)
    if okFallback and sz then
        return sz.X
    end
    return #tostring(text or "") * math.ceil(textSize * 0.6)
end

function Utils:RoundToDecimals(v, decimals)
    v = tonumber(v) or 0
    decimals = math.max(0, tonumber(decimals) or 0)
    if decimals == 0 then
        local rounded = v >= 0 and math.floor(v + 0.5) or math.ceil(v - 0.5)
        if rounded == 0 then rounded = 0 end
        return rounded
    end
    local scale = 10 ^ decimals
    local scaled = v * scale
    local rounded = (scaled >= 0 and math.floor(scaled + 0.5) or math.ceil(scaled - 0.5)) / scale
    if math.abs(rounded) < (0.5 / scale) then rounded = 0 end
    return rounded
end

function Utils:CreateNumericFormatter(minVal, maxVal, increment, suffix, opts)
    opts = opts or {}
    minVal = tonumber(minVal) or 0
    maxVal = tonumber(maxVal) or 100
    increment = math.abs(tonumber(increment) or 1)
    if increment <= 0 then increment = 1 end
    suffix = tostring(suffix or "")

    local function countDecimals(num)
        local s = string.format("%.6f", math.abs(num))
        s = string.gsub(s, "0+$", "")
        local dot = string.find(s, ".", 1, true)
        if not dot then return 0 end
        return #s - dot
    end

    local decimals = math.min(4, math.max(
        countDecimals(increment),
        countDecimals(minVal),
        countDecimals(maxVal)
    ))

    local utilsSelf = self
    local function formatValue(v)
        local rounded = utilsSelf:RoundToDecimals(v, decimals)
        if decimals == 0 then
            return tostring(rounded) .. suffix
        end
        return string.format("%." .. tostring(decimals) .. "f", rounded) .. suffix
    end

    local maxAbsInt = math.floor(math.max(math.abs(minVal), math.abs(maxVal)) + 1e-6)
    local maxIntDigits = math.max(1, #tostring(maxAbsInt))
    local hasSign = (minVal < 0 or maxVal < 0)
    local sampleText = (hasSign and "-" or "")
        .. string.rep("8", maxIntDigits)
        .. (decimals > 0 and ("." .. string.rep("8", decimals)) or "")
        .. suffix

    local textSize = opts.TextSize or 12
    local weight = opts.Weight or Enum.FontWeight.Bold
    local padding = opts.Padding or 4

    local okFace, fontFace = pcall(function()
        return Font.new(TABULAR_FONT_ASSET, weight)
    end)
    if not okFace then fontFace = nil end

    local measuredW = self:MeasureTextWidth(sampleText, textSize, fontFace, Enum.Font.RobotoMono)
    local reservedW = math.max(16, math.ceil(measuredW) + padding)

    return {
        Decimals = decimals,
        HasSign = hasSign,
        MaxIntDigits = maxIntDigits,
        MaxLength = #sampleText,
        SampleText = sampleText,
        ReservedWidth = reservedW,
        FontFace = fontFace,
        Format = formatValue
    }
end

return Utils
