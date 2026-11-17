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
    local target = tonumber(level) or 7
    local getId = (type(getthreadidentity) == "function" and getthreadidentity)
        or (type(get_thread_identity) == "function" and get_thread_identity)
        or (syn ~= nil and type(syn) == "table" and type(syn.get_thread_identity) == "function" and syn.get_thread_identity)
    if getId then
        local ok, cur = pcall(getId)
        if ok and type(cur) == "number" and cur >= target then
            return true
        end
    end

    local function trySet(fn)
        if type(fn) == "function" then
            return pcall(fn, target)
        end
        return false
    end

    if trySet(setthreadidentity) then return true end
    if trySet(set_thread_identity) then return true end
    if trySet(setidentity) then return true end
    if syn ~= nil and type(syn) == "table" and trySet(syn.set_thread_identity) then
        return true
    end
    return false
end

function Utils:SafeParent(inst, parent)
    if not inst then return false end
    local ok = pcall(function()
        inst.Parent = parent
    end)
    return ok
end

function Utils:ProtectGui(gui)
    if not gui or typeof(gui) ~= "Instance" then return end
    pcall(function()
        gui:SetAttribute("SyntaxisInstance", true)
    end)
    if syn ~= nil and type(syn) == "table" and type(syn.protect_gui) == "function" then
        pcall(syn.protect_gui, gui)
    elseif type(protectgui) == "function" then
        pcall(protectgui, gui)
    elseif type(protect_gui) == "function" then
        pcall(protect_gui, gui)
    end
end

function Utils:GetHiddenGui()
    local function tryFn(fn)
        if type(fn) == "function" then
            local ok, res = pcall(fn)
            if ok and typeof(res) == "Instance" then
                return res
            end
        end
        return nil
    end

    return tryFn(gethui)
        or tryFn(get_hidden_gui)
        or tryFn(get_hidden_ui)
        or tryFn(hiddenUI)
end

local function resolvePlayerGui(waitTimeout)
    local lp = Players.LocalPlayer
    if not lp and waitTimeout and waitTimeout > 0 then
        pcall(function()
            lp = Players.PlayerAdded:Wait()
        end)
    end
    if not lp then return nil end
    local okExisting, existing = pcall(function()
        return lp:FindFirstChildOfClass("PlayerGui")
    end)
    if okExisting and existing then
        return existing
    end
    if waitTimeout and waitTimeout > 0 then
        local okWait, waited = pcall(function()
            return lp:WaitForChild("PlayerGui", waitTimeout)
        end)
        if okWait and typeof(waited) == "Instance" then
            return waited
        end
    end
    return nil
end

function Utils:GetCleanupContainers(preferredParent)
    local list = {}
    local seen = {}
    local function add(inst)
        if inst and typeof(inst) == "Instance" and not seen[inst] then
            seen[inst] = true
            table.insert(list, inst)
        end
    end

    if typeof(preferredParent) == "Instance" then
        add(preferredParent)
    end
    add(self:GetHiddenGui())
    pcall(function()
        local cg = game:GetService("CoreGui")
        add(cg)
    end)
    add(resolvePlayerGui(0))
    return list
end

function Utils:SafeParentScreenGui(gui, preferredParent)
    if not gui or typeof(gui) ~= "Instance" then
        return false, "Invalid ScreenGui instance"
    end
    self:ElevateIdentity(7)

    local function isAttached(container)
        local okParent, isMatch = pcall(function()
            return gui.Parent == container
        end)
        local okDesc, isDesc = pcall(function()
            return gui:IsDescendantOf(game)
        end)
        return (okParent and isMatch) or (okDesc and isDesc)
    end

    local function tryContainer(container, shouldProtect)
        if not container or typeof(container) ~= "Instance" then
            return false
        end
        if shouldProtect then
            self:ProtectGui(gui)
        else
            pcall(function()
                gui:SetAttribute("SyntaxisInstance", true)
            end)
        end
        local ok = pcall(function()
            gui.Parent = container
        end)
        if not ok then
            return false
        end
        return isAttached(container)
    end

    local okCg, cg = pcall(function()
        return game:GetService("CoreGui")
    end)

    if typeof(preferredParent) == "Instance" then
        local protectPreferred = (okCg and typeof(cg) == "Instance" and preferredParent == cg)
        if tryContainer(preferredParent, protectPreferred) then
            return true, preferredParent
        end
    end

    if RunService:IsStudio() then
        local pg = resolvePlayerGui(10)
        if pg and tryContainer(pg, false) then
            return true, pg
        end
        return false, "Studio PlayerGui unavailable"
    end

    local hui = self:GetHiddenGui()
    if hui and tryContainer(hui, false) then
        return true, hui
    end

    if okCg and typeof(cg) == "Instance" and tryContainer(cg, true) then
        return true, cg
    end

    local pg = resolvePlayerGui(10)
    if pg and tryContainer(pg, false) then
        return true, pg
    end

    return false, "No writable UI container available"
end

function Utils:GetSafeParent()
    self:ElevateIdentity(7)

    if RunService:IsStudio() then
        local pg = resolvePlayerGui(10)
        if pg then return pg end
    end

    local hui = self:GetHiddenGui()
    if hui then
        return hui
    end

    local okCg, cg = pcall(function()
        return game:GetService("CoreGui")
    end)
    if okCg and typeof(cg) == "Instance" then
        local canWrite = false
        pcall(function()
            local probe = Instance.new("Folder")
            probe.Name = "_SyntaxisProbe"
            probe.Parent = cg
            canWrite = (probe.Parent == cg) or probe:IsDescendantOf(game)
            probe:Destroy()
        end)
        if canWrite then
            return cg
        end
    end

    return resolvePlayerGui(10)
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
    local enumFont = fallbackFont
    if not enumFont then
        pcall(function() enumFont = Enum.Font.RobotoMono end)
    end
    if enumFont then
        pcall(function() label.Font = enumFont end)
    end
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
    local str = tostring(text or "")
    local clampedSize = math.clamp(math.floor(tonumber(textSize) or 12), 1, 100)
    local ok, sz = pcall(function()
        return TextService:GetTextSize(
            str,
            clampedSize,
            fallbackEnumFont or Enum.Font.RobotoMono,
            Vector2.new(2000, 200)
        )
    end)
    if ok and sz then
        return sz.X
    end
    return #str * math.ceil(clampedSize * 0.6)
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
    local weight = opts.Weight
    if not weight then
        pcall(function() weight = Enum.FontWeight.Bold end)
    end
    local padding = opts.Padding or 4

    local okFace, fontFace = pcall(function()
        return Font.new(TABULAR_FONT_ASSET, weight or Enum.FontWeight.Bold)
    end)
    if not okFace then fontFace = nil end

    local fallbackEnum = nil
    pcall(function() fallbackEnum = Enum.Font.RobotoMono end)
    local measuredW = self:MeasureTextWidth(sampleText, textSize, fontFace, fallbackEnum)
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
