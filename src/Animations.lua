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
