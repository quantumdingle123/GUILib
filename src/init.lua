-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY - MODULE: init.lua ]
-- Main Modular Loader & Public Entry Point for the Syntaxis iOS GUI Library.
-- ==============================================================================

local SyntaxisLib = {
    Version = "2.2.0",
    RepoBaseUrl = "https://raw.githubusercontent.com/quantumdingle123/GUILib/main/src/"
}

local function loadModule(name)
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

function SyntaxisLib:CreateWindow(config)
    return self.Window:Create(self, config)
end

return SyntaxisLib
