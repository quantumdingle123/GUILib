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
