-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY - MODULE: init.lua ]
-- Main Modular Loader & Public Entry Point for the Syntaxis GUI Library.
-- ==============================================================================

local SyntaxisLib = {
    Version = "2.3.0",
    RepoBaseUrl = "https://raw.githubusercontent.com/quantumdingle123/GUILib/main/src/"
}

local function loadModule(name)
    if script and script:FindFirstChild(name) then
        return require(script:FindFirstChild(name))
    end
    if SyntaxisLib._Preloaded and SyntaxisLib._Preloaded[name] then
        return SyntaxisLib._Preloaded[name]()
    end
    local url = SyntaxisLib.RepoBaseUrl .. name .. ".lua"
    local src = game:HttpGet(url)
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
        local loader = self:CreateLoader({
            Title = config.Title or "Syntaxis",
            GameName = config.GameName or config.Subtitle or "tungtung",
            Theme = config.Theme or "Sapphire",
            Icon = config.Icon or "rbxassetid://71471996876777",
            Duration = config.LoaderDuration or 2.2,
            Steps = config.LoaderSteps
        })

        local winConfig = {}
        for k, v in pairs(config) do winConfig[k] = v end
        winConfig.ShowLoader = false

        local window = self.Window:Create(self, winConfig)
        if window and window.MainFrame then
            window.MainFrame.Visible = false
        end
        if window and window.Toggle then
            window.Toggle.Visible = false
        end

        loader:OnComplete(function()
            if window and window.MainFrame then
                window.MainFrame.Visible = true
            end
            if window and window.Toggle then
                window.Toggle.Visible = true
            end
        end)

        return window
    else
        return self.Window:Create(self, config)
    end
end

return SyntaxisLib
