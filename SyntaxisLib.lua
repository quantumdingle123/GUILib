-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY v2.3.0 - PUBLIC ENTRYPOINT ]
-- Repository: https://github.com/quantumdingle123/GUILib
-- Architecture: Modular (Themes, Animations, Utils, Modals, Components, Panels, Window, Loader, StatusBar)
-- ==============================================================================

local SyntaxisLib = {
    Version = "2.3.0",
    RepoBaseUrl = "https://raw.githubusercontent.com/quantumdingle123/GUILib/main/src/"
}

local function isValidSource(body)
    if type(body) ~= "string" then
        return false
    end
    local trimmed = body:match("^%s*(.-)%s*$")
    if not trimmed or #trimmed == 0 then
        return false
    end
    if trimmed == "404: Not Found" or trimmed:sub(1, 1) == "<" then
        return false
    end
    return true
end

local function getRequestFunction()
    if type(request) == "function" then return request end
    if type(http_request) == "function" then return http_request end
    if syn ~= nil and type(syn) == "table" and type(syn.request) == "function" then
        return syn.request
    end
    if http ~= nil and type(http) == "table" and type(http.request) == "function" then
        return http.request
    end
    return nil
end

local function fetchRemoteSource(url)
    local lastErr = "Unknown HTTP error"
    local reqFn = getRequestFunction()

    for attempt = 1, 3 do
        local okGet, resGet = pcall(function()
            return game:HttpGet(url)
        end)
        if okGet and isValidSource(resGet) then
            return resGet
        elseif not okGet then
            lastErr = resGet
        elseif type(resGet) == "string" then
            lastErr = "Invalid HttpGet body (" .. tostring(#resGet) .. " bytes)"
        end

        local okAsync, resAsync = pcall(function()
            return game:HttpGetAsync(url)
        end)
        if okAsync and isValidSource(resAsync) then
            return resAsync
        elseif not okAsync and lastErr == "Unknown HTTP error" then
            lastErr = resAsync
        end

        if reqFn then
            local okReq, resReq = pcall(reqFn, { Url = url, Method = "GET" })
            if okReq and type(resReq) == "table" then
                local statusOk = (resReq.StatusCode == nil or resReq.StatusCode == 200)
                local successOk = (resReq.Success == nil or resReq.Success == true)
                if statusOk and successOk and isValidSource(resReq.Body) then
                    return resReq.Body
                elseif resReq.StatusCode ~= nil then
                    lastErr = "HTTP " .. tostring(resReq.StatusCode)
                end
            elseif not okReq then
                lastErr = resReq
            end
        end

        if attempt < 3 then
            task.wait(0.2 * attempt)
        end
    end

    local msg = "[SyntaxisLib] Failed to download module (" .. tostring(url) .. "): " .. tostring(lastErr)
    warn(msg)
    error(msg)
end

local function loadModule(name)
    if typeof(script) == "Instance" then
        local okChild, child = pcall(function()
            return script:FindFirstChild(name)
        end)
        if okChild and child then
            return require(child)
        end
    end
    if SyntaxisLib._Preloaded and SyntaxisLib._Preloaded[name] then
        return SyntaxisLib._Preloaded[name]()
    end
    if type(loadstring) ~= "function" then
        local msg = "[SyntaxisLib] Executor does not expose loadstring() needed to load module " .. tostring(name)
        warn(msg)
        error(msg)
    end
    local url = SyntaxisLib.RepoBaseUrl .. name .. ".lua"
    local src = fetchRemoteSource(url)
    local okCompile, fn, err = pcall(loadstring, src, "=SyntaxisLib." .. tostring(name))
    if not okCompile then
        okCompile, fn, err = pcall(loadstring, src)
    end
    if not okCompile or type(fn) ~= "function" then
        local msg = "[SyntaxisLib] Failed to compile module " .. tostring(name) .. ": " .. tostring(err or fn)
        warn(msg)
        error(msg)
    end
    local mod = fn()
    if mod == nil then
        local msg = "[SyntaxisLib] Module " .. tostring(name) .. " returned nil"
        warn(msg)
        error(msg)
    end
    return mod
end

SyntaxisLib.Themes = loadModule("Themes")
SyntaxisLib.Animations = loadModule("Animations")
SyntaxisLib.Utils = loadModule("Utils")
SyntaxisLib.Modals = loadModule("Modals")
SyntaxisLib.Components = loadModule("Components")
SyntaxisLib.Panels = loadModule("Panels")
SyntaxisLib.Window = loadModule("Window")
SyntaxisLib.Loader = loadModule("Loader")
local okStatusBar, statusBarMod = pcall(loadModule, "StatusBar")
if okStatusBar and statusBarMod then
    SyntaxisLib.StatusBar = statusBarMod
elseif not okStatusBar then
    warn("[SyntaxisLib] Optional module StatusBar unavailable: " .. tostring(statusBarMod))
end

function SyntaxisLib:CreateLoader(config)
    return self.Loader.new(self, config)
end

function SyntaxisLib:CreateWindow(config)
    config = config or {}
    if self.Utils and self.Utils.ElevateIdentity then
        self.Utils:ElevateIdentity(7)
    end
    if config.ShowLoader then
        local winConfig = {}
        for k, v in pairs(config) do winConfig[k] = v end
        winConfig.ShowLoader = false
        winConfig._DeferInitialBlur = true

        local window = self.Window:Create(self, winConfig)
        if window and window.MainFrame then
            window.MainFrame.Visible = false
        end
        local toggleOrb = window and (window.ToggleOrb or window.Toggle)
        local toggleOrbSize = toggleOrb and toggleOrb.Size or UDim2.new(0, 52, 0, 52)
        if toggleOrb then
            toggleOrb.Visible = false
        end
        local wantsStatusBar = (config.StatusBar ~= false) and (config.StatusBarVisible ~= false)
        if window and type(window.SetStatusBarVisible) == "function" then
            window:SetStatusBarVisible(false)
        end

        local targetBlurSize = math.clamp(tonumber(config.BackgroundBlurSize) or 16, 0, 56)
        local wantsWindowBlur = (config.BackgroundBlur ~= false and targetBlurSize > 0)
        local rawDuration = config.LoaderDuration or 3.2
        local loaderDuration = math.max(1.0, rawDuration)
        local revealed = false
        local function revealWindow(forceCleanupLoader)
            if revealed then return end
            revealed = true
            local active = window and (window._ActiveLoader or (window.Context and window.Context.ActiveLoader))
            local preservedBlur = (not forceCleanupLoader) and (active ~= nil and active._hadPreservedMorphBlur == true)
            if window then
                window._ActiveLoader = nil
                if window.Context then
                    window.Context.ActiveLoader = nil
                end
            end
            if forceCleanupLoader and active and type(active.Destroy) == "function" then
                pcall(function() active:Destroy() end)
            end
            if not window or (window.Context and not window.Context.IsAlive) then
                if window and type(window._CompleteDeferredBlur) == "function" then
                    pcall(function() window:_CompleteDeferredBlur(false) end)
                end
                return
            end
            if window.MainFrame and window.MainFrame.Parent then
                window.MainFrame.Visible = true
            end
            if toggleOrb and toggleOrb.Parent then
                toggleOrb.Visible = true
            end
            if wantsStatusBar and type(window.SetStatusBarVisible) == "function" then
                pcall(function() window:SetStatusBarVisible(true) end)
            end
            if type(window._CompleteDeferredBlur) == "function" then
                pcall(function() window:_CompleteDeferredBlur(preservedBlur) end)
            end
        end

        local okLoader, loaderOrErr = pcall(function()
            return self:CreateLoader({
                Title = config.Title or "Syntaxis",
                GameName = config.GameName or config.Subtitle or "tungtung",
                Theme = config.Theme or "Sapphire",
                Icon = config.Icon or "rbxassetid://71471996876777",
                Layout = config.LoaderLayout or "B",
                Duration = rawDuration,
                Steps = config.LoaderSteps,
                BlurEnabled = (config.LoaderBlur ~= false),
                BlurSize = config.LoaderBlurSize or 20,
                BlurParent = config.BlurParent,
                PreserveBlurOnReveal = wantsWindowBlur,
                TargetBlurSize = targetBlurSize,
                BackdropTransparency = config.LoaderBackdropTransparency or 0.74,
                MorphToWindow = (config.MorphToWindow ~= false),
                IgnoreGuiInset = (window and window.ScreenGui and window.ScreenGui.IgnoreGuiInset) or false,
                MorphPosition = (window and window.MainFrame and window.MainFrame.Position) or UDim2.new(0.5, 0, 0.5, 0),
                MorphSize = (window and window.MainFrame and window.MainFrame.Size) or config.Size or UDim2.new(0, 510, 0, 345),
                TargetFrame = window and window.MainFrame,
                ToggleOrb = toggleOrb,
                ToggleOrbSize = toggleOrbSize,
                Parent = config.Parent
            })
        end)

        if not okLoader or not loaderOrErr then
            warn("[SyntaxisLib] Loader fallback active: " .. tostring(loaderOrErr))
            revealWindow(false)
            return window
        end

        local loader = loaderOrErr
        window._ActiveLoader = loader
        if window.Context then
            window.Context.ActiveLoader = loader
        end

        loader:OnComplete(function()
            revealWindow(false)
        end)

        task.delay(loaderDuration + 3.0, function()
            if not revealed then
                if window and window.Context and window.Context.IsAlive and window.ScreenGui and window.ScreenGui.Parent then
                    warn("[SyntaxisLib] Loader timed out; revealing window directly.")
                    revealWindow(true)
                else
                    revealed = true
                    local active = window and (window._ActiveLoader or (window.Context and window.Context.ActiveLoader))
                    if active and type(active.Destroy) == "function" then
                        pcall(function() active:Destroy() end)
                    end
                end
            end
        end)

        return window
    else
        return self.Window:Create(self, config)
    end
end

return SyntaxisLib
