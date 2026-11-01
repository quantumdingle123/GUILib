-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY v2.0.0 - STANDALONE REUSABLE MODULE BUNDLE ]
-- Repository: https://github.com/quantumdingle123/GUILib
-- Architecture: Modular (Themes, Animations, Utils, Modals, Components, Panels, Window)
-- ==============================================================================

local SyntaxisLib = {
    Version = "2.0.0",
    RepoBaseUrl = "https://raw.githubusercontent.com/quantumdingle123/GUILib/main/src/"
}

SyntaxisLib._Preloaded = {
    Themes = function()
-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY - MODULE: Themes.lua ]
-- Manages color palettes, gradients, and surface materials for all built-in themes.
-- ==============================================================================

local Themes = {}

Themes.Palettes = {
    Sapphire = { 
        Name = "Sapphire",
        Main = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 58, 110)), 
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 78, 142)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(54, 102, 178))
        }, 
        Topbar = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 74, 134)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(58, 104, 178))
        },
        Button = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(52, 96, 162)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(72, 126, 202))
        },
        ButtonHover = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(72, 128, 204)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(98, 158, 238))
        },
        CardBg = Color3.fromRGB(30, 60, 112), 
        RowBg = Color3.fromRGB(22, 46, 88),
        BoxBg = Color3.fromRGB(36, 72, 130),
        DropBg = Color3.fromRGB(20, 42, 82),
        SwitchOff = Color3.fromRGB(18, 34, 64),
        Accent = Color3.fromRGB(64, 168, 255),
        Accent2 = Color3.fromRGB(160, 224, 255),
        Text = Color3.fromRGB(255, 255, 255), 
        SubText = Color3.fromRGB(205, 228, 252), 
        Stroke = Color3.fromRGB(120, 178, 242),
        GlassRim = Color3.fromRGB(215, 238, 255)
    },
    Emerald = { 
        Name = "Emerald",
        Main = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 72, 46)), 
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(32, 98, 62)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(46, 128, 82))
        }, 
        Topbar = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 88, 56)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(48, 128, 84))
        },
        Button = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(46, 132, 84)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(64, 166, 108))
        },
        ButtonHover = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(64, 172, 114)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(92, 210, 142))
        },
        CardBg = Color3.fromRGB(26, 78, 50), 
        RowBg = Color3.fromRGB(18, 58, 38),
        BoxBg = Color3.fromRGB(34, 96, 62),
        DropBg = Color3.fromRGB(16, 52, 34),
        SwitchOff = Color3.fromRGB(14, 44, 28),
        Accent = Color3.fromRGB(64, 232, 142),
        Accent2 = Color3.fromRGB(165, 255, 212),
        Text = Color3.fromRGB(255, 255, 255), 
        SubText = Color3.fromRGB(205, 245, 222), 
        Stroke = Color3.fromRGB(112, 212, 158),
        GlassRim = Color3.fromRGB(215, 255, 232)
    },
    Ruby = { 
        Name = "Ruby",
        Main = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(78, 24, 36)), 
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(106, 32, 48)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(136, 44, 64))
        }, 
        Topbar = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(92, 28, 42)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(134, 44, 62))
        },
        Button = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 48, 66)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 64, 84))
        },
        ButtonHover = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(176, 66, 86)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(214, 92, 112))
        },
        CardBg = Color3.fromRGB(82, 26, 38), 
        RowBg = Color3.fromRGB(62, 18, 28),
        BoxBg = Color3.fromRGB(98, 32, 46),
        DropBg = Color3.fromRGB(54, 16, 26),
        SwitchOff = Color3.fromRGB(44, 12, 20),
        Accent = Color3.fromRGB(255, 96, 118),
        Accent2 = Color3.fromRGB(255, 182, 194), 
        Text = Color3.fromRGB(255, 255, 255), 
        SubText = Color3.fromRGB(248, 208, 216), 
        Stroke = Color3.fromRGB(218, 114, 132),
        GlassRim = Color3.fromRGB(255, 220, 226)
    },
    Amethyst = { 
        Name = "Amethyst",
        Main = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(56, 28, 90)), 
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(76, 40, 120)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(102, 54, 154))
        }, 
        Topbar = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(68, 34, 108)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(98, 52, 148))
        },
        Button = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(98, 54, 152)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 72, 188))
        },
        ButtonHover = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 74, 192)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(166, 102, 228))
        },
        CardBg = Color3.fromRGB(60, 32, 98), 
        RowBg = Color3.fromRGB(44, 22, 74),
        BoxBg = Color3.fromRGB(74, 40, 118),
        DropBg = Color3.fromRGB(38, 20, 66),
        SwitchOff = Color3.fromRGB(32, 16, 56),
        Accent = Color3.fromRGB(192, 116, 255),
        Accent2 = Color3.fromRGB(230, 188, 255), 
        Text = Color3.fromRGB(255, 255, 255), 
        SubText = Color3.fromRGB(228, 208, 250), 
        Stroke = Color3.fromRGB(168, 118, 224),
        GlassRim = Color3.fromRGB(238, 220, 255)
    },
    Midnight = { 
        Name = "Midnight",
        Main = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 42, 58)), 
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(46, 56, 78)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(62, 74, 100))
        }, 
        Topbar = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(42, 52, 72)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 72, 98))
        },
        Button = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(58, 70, 96)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(78, 92, 122))
        },
        ButtonHover = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 94, 126)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(104, 120, 156))
        },
        CardBg = Color3.fromRGB(40, 48, 68), 
        RowBg = Color3.fromRGB(28, 34, 50),
        BoxBg = Color3.fromRGB(48, 58, 82),
        DropBg = Color3.fromRGB(24, 30, 44),
        SwitchOff = Color3.fromRGB(20, 24, 36),
        Accent = Color3.fromRGB(135, 180, 240),
        Accent2 = Color3.fromRGB(205, 228, 255), 
        Text = Color3.fromRGB(255, 255, 255), 
        SubText = Color3.fromRGB(208, 220, 238), 
        Stroke = Color3.fromRGB(122, 138, 172),
        GlassRim = Color3.fromRGB(230, 238, 255)
    }
}

function Themes:Get(name)
    return self.Palettes[name] or self.Palettes.Sapphire
end

function Themes:Register(name, palette)
    if type(name) == "string" and type(palette) == "table" then
        self.Palettes[name] = palette
    end
end

return Themes

    end,
    Animations = function()
-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY - MODULE: Animations.lua ]
-- Provides standardized iOS-inspired spring & easing transitions and tactile press effects.
-- ==============================================================================

local TweenService = game:GetService("TweenService")

local Animations = {}

Animations.Fast = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
Animations.Drop = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
Animations.Spring = TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
Animations.Smooth = TweenInfo.new(0.26, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
Animations.iOSSpring = TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

function Animations:Tween(obj, info, props)
    local tw = TweenService:Create(obj, info or self.Smooth, props)
    tw:Play()
    return tw
end

function Animations:AttachTactile(btn, connList)
    local origSize = btn.Size
    local c1 = btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:Tween(btn, self.Fast, {
                Size = UDim2.new(
                    origSize.X.Scale * 0.96,
                    origSize.X.Offset * 0.96,
                    origSize.Y.Scale * 0.96,
                    origSize.Y.Offset * 0.96
                )
            })
        end
    end)
    local c2 = btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:Tween(btn, self.Spring, { Size = origSize })
        end
    end)
    if connList then
        table.insert(connList, c1)
        table.insert(connList, c2)
    end
end

return Animations

    end,
    Utils = function()
-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY - MODULE: Utils.lua ]
-- Provides instance helpers, corner/gradient builders, drag logic, and cleanup tracking.
-- ==============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Utils = {}

function Utils:GetSafeParent()
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
    local dragging = false
    local dragStart = nil
    local startPos = nil

    local c1 = handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position

            local changedConn
            local endedConn

            changedConn = UserInputService.InputChanged:Connect(function(moveInput)
                if dragging and (moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch) then
                    local delta = moveInput.Position - dragStart
                    target.Position = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
                end
            end)

            endedConn = UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                    if changedConn then changedConn:Disconnect() end
                    if endedConn then endedConn:Disconnect() end
                end
            end)

            if connList then
                table.insert(connList, changedConn)
                table.insert(connList, endedConn)
            end
        end
    end)
    if connList then table.insert(connList, c1) end
end

return Utils

    end,
    Modals = function()
-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY - MODULE: Modals.lua ]
-- Provides warning alerts, Discord community modal, and toast notifications.
-- ==============================================================================

local Modals = {}

function Modals:ShowWarning(ctx, title, text)
    local mainUI = ctx.ScreenGui
    local activeTheme = ctx.ActiveTheme
    local Animations = ctx.Animations
    local Utils = ctx.Utils

    local existing = mainUI:FindFirstChild("WarningModalCard")
    if existing then existing:Destroy() end

    local card = Instance.new("Frame", mainUI)
    card.Name = "WarningModalCard"
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.Size = UDim2.fromOffset(0, 0)
    card.BackgroundColor3 = activeTheme.CardBg
    card.BackgroundTransparency = 0.06
    card.BorderSizePixel = 0
    card.ZIndex = 500
    card.ClipsDescendants = true
    Utils:RoundCorner(card, 20)

    local cardStr = Instance.new("UIStroke", card)
    cardStr.Thickness = 1.3
    cardStr.Color = Color3.fromRGB(255, 185, 65)
    cardStr.Transparency = 0.15

    local tit = Instance.new("TextLabel", card)
    tit.Size = UDim2.new(1, -24, 0, 26)
    tit.Position = UDim2.new(0, 12, 0, 16)
    tit.BackgroundTransparency = 1
    tit.Font = Enum.Font.GothamBold
    tit.TextSize = 15
    tit.TextColor3 = Color3.fromRGB(255, 205, 75)
    tit.TextXAlignment = Enum.TextXAlignment.Center
    tit.Text = tostring(title or "Warning")

    local desc = Instance.new("TextLabel", card)
    desc.Size = UDim2.new(1, -32, 0, 48)
    desc.Position = UDim2.new(0, 16, 0, 46)
    desc.BackgroundTransparency = 1
    desc.Font = Enum.Font.GothamMedium
    desc.TextSize = 12
    desc.TextColor3 = Color3.fromRGB(245, 248, 255)
    desc.TextWrapped = true
    desc.Text = tostring(text or "")

    local okBtn = Instance.new("TextButton", card)
    okBtn.Size = UDim2.new(0, 110, 0, 34)
    okBtn.Position = UDim2.new(0.5, -55, 1, -48)
    okBtn.BackgroundColor3 = activeTheme.Accent
    okBtn.Font = Enum.Font.GothamBold
    okBtn.TextSize = 13
    okBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    okBtn.Text = "Dismiss"
    Utils:RoundCorner(okBtn, 17)
    Animations:AttachTactile(okBtn, ctx.Connections)

    Animations:Tween(card, Animations.iOSSpring, { Size = UDim2.fromOffset(360, 165) })

    okBtn.MouseButton1Click:Connect(function()
        local tw = Animations:Tween(card, Animations.Fast, { Size = UDim2.fromOffset(0, 0) })
        tw.Completed:Connect(function()
            card:Destroy()
        end)
    end)
end

function Modals:ShowDiscord(ctx, inviteUrl)
    local mainUI = ctx.ScreenGui
    local activeTheme = ctx.ActiveTheme
    local Animations = ctx.Animations
    local Utils = ctx.Utils
    local url = inviteUrl or "https://discord.gg/DHVH8qbkkE"

    local existing = mainUI:FindFirstChild("DiscordModalCard")
    if existing then existing:Destroy() end

    local card = Instance.new("Frame", mainUI)
    card.Name = "DiscordModalCard"
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.Size = UDim2.fromOffset(0, 0)
    card.BackgroundColor3 = activeTheme.CardBg
    card.BackgroundTransparency = 0.06
    card.BorderSizePixel = 0
    card.ZIndex = 500
    card.ClipsDescendants = true
    Utils:RoundCorner(card, 22)

    local cardStr = Instance.new("UIStroke", card)
    cardStr.Thickness = 1.4
    cardStr.Color = activeTheme.Stroke
    cardStr.Transparency = 0.20

    local tit = Instance.new("TextLabel", card)
    tit.Size = UDim2.new(1, -24, 0, 26)
    tit.Position = UDim2.new(0, 12, 0, 18)
    tit.BackgroundTransparency = 1
    tit.Font = Enum.Font.GothamBold
    tit.TextSize = 16
    tit.TextColor3 = Color3.fromRGB(255, 255, 255)
    tit.Text = "Community Discord"

    local desc = Instance.new("TextLabel", card)
    desc.Size = UDim2.new(1, -32, 0, 44)
    desc.Position = UDim2.new(0, 16, 0, 48)
    desc.BackgroundTransparency = 1
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 12
    desc.TextColor3 = Color3.fromRGB(230, 238, 255)
    desc.TextWrapped = true
    desc.Text = "Get the latest script updates, configuration tips, and support by joining our Discord server."

    local joinBtn = Instance.new("TextButton", card)
    joinBtn.Size = UDim2.new(0, 125, 0, 36)
    joinBtn.Position = UDim2.new(0.5, -135, 1, -52)
    joinBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    joinBtn.Font = Enum.Font.GothamBold
    joinBtn.TextSize = 13
    joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    joinBtn.Text = "Copy Invite"
    Utils:RoundCorner(joinBtn, 18)
    Animations:AttachTactile(joinBtn, ctx.Connections)

    local noBtn = Instance.new("TextButton", card)
    noBtn.Size = UDim2.new(0, 125, 0, 36)
    noBtn.Position = UDim2.new(0.5, 10, 1, -52)
    noBtn.BackgroundColor3 = activeTheme.RowBg
    noBtn.Font = Enum.Font.GothamMedium
    noBtn.TextSize = 13
    noBtn.TextColor3 = Color3.fromRGB(240, 245, 255)
    noBtn.Text = "Not Now"
    Utils:RoundCorner(noBtn, 18)
    Animations:AttachTactile(noBtn, ctx.Connections)

    Animations:Tween(card, Animations.iOSSpring, { Size = UDim2.fromOffset(380, 175) })

    joinBtn.MouseButton1Click:Connect(function()
        local copy = setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if copy then pcall(copy, url) end
        joinBtn.Text = "Copied!"
        task.delay(0.5, function()
            local tw = Animations:Tween(card, Animations.Fast, { Size = UDim2.fromOffset(0, 0) })
            tw.Completed:Connect(function() card:Destroy() end)
        end)
    end)

    noBtn.MouseButton1Click:Connect(function()
        local tw = Animations:Tween(card, Animations.Fast, { Size = UDim2.fromOffset(0, 0) })
        tw.Completed:Connect(function() card:Destroy() end)
    end)
end

function Modals:Notify(ctx, opts)
    opts = opts or {}
    local mainUI = ctx.ScreenGui
    local activeTheme = ctx.ActiveTheme
    local Animations = ctx.Animations
    local Utils = ctx.Utils

    local holder = mainUI:FindFirstChild("SyntaxisToastHolder")
    if not holder then
        holder = Instance.new("Frame", mainUI)
        holder.Name = "SyntaxisToastHolder"
        holder.AnchorPoint = Vector2.new(1, 1)
        holder.Position = UDim2.new(1, -16, 1, -16)
        holder.Size = UDim2.new(0, 260, 1, -32)
        holder.BackgroundTransparency = 1
        holder.ZIndex = 450
        local lay = Instance.new("UIListLayout", holder)
        lay.VerticalAlignment = Enum.VerticalAlignment.Bottom
        lay.HorizontalAlignment = Enum.HorizontalAlignment.Right
        lay.Padding = UDim.new(0, 8)
    end

    local toast = Instance.new("Frame", holder)
    toast.Size = UDim2.new(1, 0, 0, 0)
    toast.BackgroundColor3 = activeTheme.CardBg
    toast.BackgroundTransparency = 0.08
    toast.BorderSizePixel = 0
    toast.ClipsDescendants = true
    Utils:RoundCorner(toast, 14)

    local st = Instance.new("UIStroke", toast)
    st.Thickness = 1.2
    st.Color = activeTheme.Accent
    st.Transparency = 0.25

    local tLbl = Instance.new("TextLabel", toast)
    tLbl.Size = UDim2.new(1, -20, 0, 18)
    tLbl.Position = UDim2.new(0, 10, 0, 8)
    tLbl.BackgroundTransparency = 1
    tLbl.Font = Enum.Font.GothamBold
    tLbl.TextSize = 12
    tLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Text = tostring(opts.Title or "Syntaxis")

    local cLbl = Instance.new("TextLabel", toast)
    cLbl.Size = UDim2.new(1, -20, 0, 24)
    cLbl.Position = UDim2.new(0, 10, 0, 26)
    cLbl.BackgroundTransparency = 1
    cLbl.Font = Enum.Font.Gotham
    cLbl.TextSize = 10.5
    cLbl.TextColor3 = activeTheme.SubText
    cLbl.TextXAlignment = Enum.TextXAlignment.Left
    cLbl.TextWrapped = true
    cLbl.Text = tostring(opts.Content or "")

    Animations:Tween(toast, Animations.Smooth, { Size = UDim2.new(1, 0, 0, 56) })
    task.delay(tonumber(opts.Duration) or 3, function()
        if toast and toast.Parent then
            local tw = Animations:Tween(toast, Animations.Fast, { Size = UDim2.new(1, 0, 0, 0) })
            tw.Completed:Connect(function()
                if toast then toast:Destroy() end
            end)
        end
    end)
end

return Modals

    end,
    Components = function()
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

    end,
    Panels = function()
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

    table.insert(ctx.State.themeSubscribers, function()
        if priorityPg.Visible then renderPriorityPanel() end
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

    end,
    Window = function()
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

    end
}

SyntaxisLib.Themes = SyntaxisLib._Preloaded.Themes()
SyntaxisLib.Animations = SyntaxisLib._Preloaded.Animations()
SyntaxisLib.Utils = SyntaxisLib._Preloaded.Utils()
SyntaxisLib.Modals = SyntaxisLib._Preloaded.Modals()
SyntaxisLib.Components = SyntaxisLib._Preloaded.Components()
SyntaxisLib.Panels = SyntaxisLib._Preloaded.Panels()
SyntaxisLib.Window = SyntaxisLib._Preloaded.Window()

function SyntaxisLib:CreateWindow(config)
    return self.Window:Create(self, config)
end

return SyntaxisLib
