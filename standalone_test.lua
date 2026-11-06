-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY v2.0.0 - STANDALONE VERIFICATION & DEMO SCRIPT ]
-- Repository: https://github.com/tenobarillas-ship-it/Testing
-- Purpose: Standalone test environment verifying all modules, components,
--          callbacks, themes, floating dropdowns, dynamic panels, and cleanup.
-- ==============================================================================

local SyntaxisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/quantumdingle123/GUILib/main/SyntaxisLib.lua"))()

-- Mock State for testing Priority & Steal Panel without any game-specific backend
local DemoState = {
    themeName = "Sapphire",
    priorityList = {
        "Automation Steal",
        "Halloween Event 2026",
        "Automation Treadmill",
        "Enchanted / Bloom Event",
        "Automation Upgrades"
    },
    targetedSpecificUid = nil,
    activeStealButtons = {},
    spSortChoice = "Value (Money/s)",
    spSortIndex = 1
}

local MockEggs = {
    { Uid = "egg_1", Name = "Celestial Dragon Egg", Rarity = "Divine", Rank = 8, Value = 1250000, Scale = 4.50, Area = "Mythic" },
    { Uid = "egg_2", Name = "Abyssal Leviathan Egg", Rarity = "Godly", Rank = 7, Value = 480000, Scale = 3.25, Area = "Secret1" },
    { Uid = "egg_3", Name = "Solar Phoenix Egg", Rarity = "Mythic", Rank = 6, Value = 95000, Scale = 2.10, Area = "Lava" },
    { Uid = "egg_4", Name = "Frost Wyrm Egg", Rarity = "Legendary", Rank = 5, Value = 24000, Scale = 1.75, Area = "Ice" }
}

local function FormatMoney(num)
    if num >= 1e6 then return string.format("$%.2fM/s", num / 1e6) end
    if num >= 1e3 then return string.format("$%.1fK/s", num / 1e3) end
    return "$" .. tostring(num) .. "/s"
end

-- 1. Create Main Window
local Window = SyntaxisLib:CreateWindow({
    Title = "Syntaxis",
    GuiName = "SyntaxHubGUI_Test",
    Theme = DemoState.themeName,
    State = DemoState,
    OnThemeChanged = function(themeName)
        print("[SyntaxisTest] Theme switched to:", themeName)
    end
})

-- 2. Create Farm Tab & Categories
local FarmTab = Window:CreateTab("Farm", "Farm")

local CatSteal = FarmTab:CreateCategory("Automation Steal", true, 1)

local TglAutoSteal = CatSteal:CreateToggle(
    "Auto Steal",
    "Steal high-tier eggs & drop at your base",
    false,
    function(val)
        print("[SyntaxisTest] Auto Steal:", val)
        Window:Notify({
            Title = "Auto Steal",
            Content = val and "Enabled Auto Steal" or "Disabled Auto Steal",
            Duration = 2
        })
    end
)

local TglFastSteal = CatSteal:CreateToggle(
    "Fast Steal",
    "Instant proximity prompt triggers",
    true,
    function(val)
        print("[SyntaxisTest] Fast Steal:", val)
    end
)

local MddAreas = CatSteal:CreateMultiDropdown(
    "Target Areas",
    "Select conveyor zones to scan",
    { "All", "Mythic", "Cave", "Desert", "Ice", "Lava", "Secret1", "Secret2" },
    { ["All"] = true },
    function(selectedMap)
        local keys = {}
        for k, v in pairs(selectedMap) do
            if v then table.insert(keys, k) end
        end
        print("[SyntaxisTest] Target Areas:", table.concat(keys, ", "))
    end
)

local DdRarity = CatSteal:CreateDropdown(
    "Min Rarity",
    "Minimum egg rarity tier to steal",
    { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Godly", "Divine" },
    "Mythic",
    function(selected)
        print("[SyntaxisTest] Min Rarity:", selected)
    end
)

local SldScale = CatSteal:CreateSlider(
    "Min Scale",
    "Minimum egg size multiplier",
    1, 10, 1, 0.5,
    function(val)
        print("[SyntaxisTest] Min Scale:", val)
    end
)

-- Second Category testing Buttons, Textboxes, Labels, and Separators
local CatControls = FarmTab:CreateCategory("Component Showcase", false, 2)

local LblStatus = CatControls:CreateLabel("Status: Ready for interaction")
CatControls:CreateSeparator()

CatControls:CreateTextbox(
    "Custom Webhook",
    "Optional notification endpoint",
    "https://discord.com/api/...",
    "",
    function(text)
        LblStatus:SetText("Webhook updated: " .. (#text > 0 and "Configured" or "Empty"))
    end
)


CatControls:CreateKeybind(
    "Toggle Menu Keybind",
    "Press this key to open or close the GUI",
    Enum.KeyCode.RightControl,
    function(key, isPressed)
        if isPressed then
            print("[SyntaxisTest] Keybind pressed in-game:", tostring(key))
            Window:Notify({
                Title = "Keybind Fired",
                Content = "Triggered: " .. tostring(key.Name or key),
                Duration = 1.5
            })
        else
            print("[SyntaxisTest] Keybind changed to:", tostring(key))
            LblStatus:SetText("Keybind updated: " .. tostring(key.Name or key))
        end
    end
)

CatControls:CreateButton(
    "Test Warning Modal",
    "Trigger the iOS Liquid Glass warning dialog",
    "Trigger",
    function()
        Window:ShowWarningModal(
            "Configuration Notice",
            "This is a standalone test of the Syntaxis iOS Liquid Glass warning modal."
        )
    end
)

CatControls:CreateButton(
    "Test Discord Modal",
    "Trigger the Discord invite prompt",
    "Open",
    function()
        Window:ShowDiscordModal("https://discord.gg/syntaxis")
    end
)

-- 3. Create Priority Tab
local PriorityTab = Window:CreatePriorityTab("Priority", "Task Priority", {
    GetList = function()
        return DemoState.priorityList
    end,
    OnMoveUp = function(index)
        local temp = DemoState.priorityList[index - 1]
        DemoState.priorityList[index - 1] = DemoState.priorityList[index]
        DemoState.priorityList[index] = temp
    end,
    OnMoveDown = function(index)
        local temp = DemoState.priorityList[index + 1]
        DemoState.priorityList[index + 1] = DemoState.priorityList[index]
        DemoState.priorityList[index] = temp
    end
})

-- 4. Create Steal Panel Tab
local StealPanelTab = Window:CreateStealPanelTab("Steal Panel", "Steal Panel", {
    FormatValue = FormatMoney,
    GetItems = function()
        return MockEggs
    end,
    OnSelectItem = function(item, actBtn)
        local activeTheme = Window:GetActiveTheme()
        if DemoState.targetedSpecificUid == item.Uid then
            DemoState.targetedSpecificUid = nil
            actBtn.BackgroundColor3 = activeTheme.Accent
            actBtn.Text = "Steal"
        else
            if DemoState.targetedSpecificUid and DemoState.activeStealButtons[DemoState.targetedSpecificUid] then
                local prevBtn = DemoState.activeStealButtons[DemoState.targetedSpecificUid]
                prevBtn.BackgroundColor3 = activeTheme.Accent
                prevBtn.Text = "Steal"
            end
            DemoState.targetedSpecificUid = item.Uid
            actBtn.BackgroundColor3 = Color3.fromRGB(240, 65, 60)
            actBtn.Text = "Stop Steal"
        end
    end
})

-- 5. Create Settings Tab
local SettingsTab = Window:CreateSettingsTab("Settings", "Settings", {
    OnThemeSelected = function(themeName)
        DemoState.themeName = themeName
    end,
    OnTransparencyChanged = function(val)
        print("[SyntaxisTest] Transparency:", val .. "%")
    end
})

-- 6. Finalize Window Initialization
Window:Initialize()
print("[SyntaxisTest] SyntaxisLib v" .. tostring(SyntaxisLib.Version) .. " loaded and verified!")
return Window
