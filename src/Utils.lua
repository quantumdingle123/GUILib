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
    handle.Active = true

    local dragging = false
    local dragStart = nil
    local startPos = nil

    local function update(input)
        if not dragging or not dragStart or not startPos then return end
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
            dragStart = nil
            startPos = nil
        end
    end)

    if connList then
        table.insert(connList, c1)
        table.insert(connList, c2)
        table.insert(connList, c3)
    end
end

return Utils
