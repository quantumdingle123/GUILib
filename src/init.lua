-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY - MODULE: init.lua ]
-- Main Modular Loader & Public Entry Point for the Syntaxis GUI Library.
-- ==============================================================================

local SyntaxisLib = {
    Version = "2.3.0",
    RepoBaseUrl = "https://raw.githubusercontent.com/quantumdingle123/GUILib/main/src/"
}

local function fetchRemoteSource(url)
    local lastErr
    for attempt = 1, 2 do
        local ok, res = pcall(function()
            return game:HttpGet(url)
        end)
        if ok and type(res) == "string" and #res > 0 then
            return res
        end
        lastErr = res
        if attempt < 2 then
            task.wait(0.15)
        end
    end
    error("[SyntaxisLib] Failed to download module (" .. tostring(url) .. "): " .. tostring(lastErr))
end

local function loadModule(name)
    if script and script:FindFirstChild(name) then
        return require(script:FindFirstChild(name))
    end
    if SyntaxisLib._Preloaded and SyntaxisLib._Preloaded[name] then
        return SyntaxisLib._Preloaded[name]()
    end
    local url = SyntaxisLib.RepoBaseUrl .. name .. ".lua"
    local src = fetchRemoteSource(url)
    local fn, err = loadstring(src, "SyntaxisLib." .. name)
    if not fn then
        error("[SyntaxisLib] Failed to compile module " .. tostring(name) .. ": " .. tostring(err))
    end
    return fn()
end

SyntaxisLib.Themes = loadModule("Themes")
SyntaxisLib.Animations = loadModule("Animations")
SyntaxisLib.Utils = loadModule("Utils")
SyntaxisLib.Modals = loadModule("Modals")
SyntaxisLib.Components = loadModule("Components")
SyntaxisLib.Panels = loadModule("Panels")
SyntaxisLib.Window = loadModule("Window")
SyntaxisLib.Loader = loadModule("Loader")

function SyntaxisLib:CreateLoader(config)
    return self.Loader.new(self, config)
end

function SyntaxisLib:CreateWindow(config)
    config = config or {}
    if config.ShowLoader then
        local winConfig = {}
        for k, v in pairs(config) do winConfig[k] = v end
        winConfig.ShowLoader = false

        local window = self.Window:Create(self, winConfig)
        if window and window.MainFrame then
            window.MainFrame.Visible = false
        end
        local toggleOrb = window and (window.ToggleOrb or window.Toggle)
        local toggleOrbSize = toggleOrb and toggleOrb.Size or UDim2.new(0, 52, 0, 52)
        if toggleOrb then
            toggleOrb.Visible = false
        end

        local loader = self:CreateLoader({
            Title = config.Title or "Syntaxis",
            GameName = config.GameName or config.Subtitle or "tungtung",
            Theme = config.Theme or "Sapphire",
            Icon = config.Icon or "rbxassetid://71471996876777",
            Layout = config.LoaderLayout or "B",
            Duration = config.LoaderDuration or 3.2,
            Steps = config.LoaderSteps,
            BlurEnabled = (config.LoaderBlur ~= false),
            BlurSize = config.LoaderBlurSize or 20,
            BackdropTransparency = config.LoaderBackdropTransparency or 0.74,
            MorphToWindow = (config.MorphToWindow ~= false),
            IgnoreGuiInset = (window and window.ScreenGui and window.ScreenGui.IgnoreGuiInset) or false,
            MorphPosition = (window and window.MainFrame and window.MainFrame.Position) or UDim2.new(0.5, 0, 0.5, 0),
            MorphSize = (window and window.MainFrame and window.MainFrame.Size) or config.Size or UDim2.new(0, 510, 0, 345),
            TargetFrame = window and window.MainFrame,
            ToggleOrb = toggleOrb,
            ToggleOrbSize = toggleOrbSize
        })

        window._ActiveLoader = loader
        if window.Context then
            window.Context.ActiveLoader = loader
        end

        loader:OnComplete(function()
            if window then
                window._ActiveLoader = nil
                if window.Context then
                    window.Context.ActiveLoader = nil
                end
            end
            if not window or (window.Context and not window.Context.IsAlive) then
                return
            end
            if window.MainFrame and window.MainFrame.Parent then
                window.MainFrame.Visible = true
            end
            if toggleOrb and toggleOrb.Parent then
                toggleOrb.Visible = true
            end
        end)

        return window
    else
        return self.Window:Create(self, config)
    end
end

return SyntaxisLib
