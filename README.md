# Syntaxis GUI Library (`SyntaxisLib`) v2.2.0

A modular, reusable iOS / Liquid Glass UI library for Roblox Luau scripts. Designed to separate visual architecture, component rendering, animations, tactile button interactions, and theme state from main automation scripts.

---

## What's New in v2.2.0

- 🔍 **Default Header Search Bar**: Automatically appears in the window top bar with zero extra configuration. Filters all component cards across categories in real time, auto-expands matching categories, and includes smooth clear (`✕`) functionality.
- 🛡️ **Anti-Cheat Camouflage**: ScreenGui instances are protected against anti-cheat scanners using `syn.protect_gui` / `protectgui` / `gethui()` and randomized anonymous instance names (e.g. `G_a3f8c12b`). Existing instances are safely tracked and destroyed on script re-execution.
- ⌨️ **Tactile Keybind Controls**: Category keybind badges with listening state (`[ ... ]`), energetic iOS spring confirmation (`1.08x` $\rightarrow$ `1.0x`), `Escape` unbinding, and real-time physical keypress reflection during gameplay.

---

## Architecture & Module Structure

```text
GUILib/
├── SyntaxisLib.lua         # Single-request bundled distribution for fast executor loading
├── standalone_test.lua     # Standalone verification & showcase script
├── README.md               # Developer documentation & API reference
└── src/                    # Modular source files
    ├── init.lua            # Modular loader entrypoint
    ├── Themes.lua          # 5 iOS Liquid Glass color palettes (Sapphire, Amethyst, Ruby, Emerald, Gold)
    ├── Animations.lua      # TweenService presets & tactile button scale feedback
    ├── Utils.lua           # Safe GUI container parenting, UICorner, UIGradient, & touch/mouse drag engine
    ├── Modals.lua          # Warning modals, Discord invite modal, & toast notifications
    ├── Components.lua      # Categories, Toggles, Sliders, Dropdowns, Multi-Dropdowns, Buttons, Textboxes, Keybinds, Labels, Separators
    ├── Panels.lua          # Dynamic Task Priority panel & live Steal Panel list view
    └── Window.lua          # Main window frame, sidebar navigation, theme engine, transparency engine, & cleanup
```

---

## Quick Start

### Loading the Library

```lua
local SyntaxisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/quantumdingle123/GUILib/main/SyntaxisLib.lua"))()
```

### Creating a Window, Tabs, Categories, and Controls

```lua
local Window = SyntaxisLib:CreateWindow({
    Title = "Syntaxis",
    GuiName = "SyntaxHubGUI",
    Theme = "Sapphire",
    State = State, -- Optional shared state table
    OnThemeChanged = function(themeName, themePalette)
        activeTheme = themePalette
    end
})

-- Create a standard scrollable Tab
local FarmTab = Window:CreateTab("Farm", "Farm")

-- Create an expandable Category
local CatSteal = FarmTab:CreateCategory("Automation Steal", true, 1)

-- Add a Toggle
CatSteal:CreateToggle("Auto Steal", "Steal eggs & drop at your base", false, function(state)
    print("Auto Steal:", state)
end)

-- Add a Keybind (with tactile spring animations & live in-game keypress reflection)
CatSteal:CreateKeybind("Menu Keybind", "Press key to toggle GUI", Enum.KeyCode.RightControl, function(key, isPressed)
    if isPressed then
        Window:SetVisible(not Window.MainFrame.Visible)
    else
        print("Keybind bound to:", key)
    end
end)

-- Add a Multi-Select Floating Dropdown
CatSteal:CreateMultiDropdown("Target Areas", "Select conveyor zones", {
    "All", "Forest", "Lake", "Desert", "Snow", "Titan Temple"
}, { ["All"] = true }, function(selectedMap)
    print("Updated Target Areas", selectedMap)
end)

-- Add a Single-Select Floating Dropdown
CatSteal:CreateDropdown("Min Rarity", "Minimum rarity tier", {
    "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Divine"
}, "Mythic", function(choice)
    print("Selected Rarity:", choice)
end)

-- Add a Slider
CatSteal:CreateSlider("Min Scale", "Minimum size multiplier", 1, 10, 1, 0.5, function(value)
    print("Min Scale:", value)
end)

-- Add Settings Tab (Theme Grid + Transparency Slider)
Window:CreateSettingsTab("Settings", "Settings", {
    OnThemeSelected = function(themeName)
        print("Saved theme:", themeName)
    end,
    OnTransparencyChanged = function(percent)
        print("Saved transparency:", percent)
    end
})

-- Initialize default tab, theme, and transparency
Window:Initialize()
```

---

## Component API Reference

| Method | Description | Return Object Methods |
| :--- | :--- | :--- |
| `Window:CreateTab(name, title)` | Creates a sidebar tab and scrollable page | `:CreateCategory(title, defaultOpen, order)` |
| `Category:CreateToggle(title, desc, default, callback)` | High-contrast iOS switch control | `:GetValue()`, `:SetValue(bool, fireCallback)` |
| `Category:CreateKeybind(title, desc, defaultKey, callback, order)` | Tactile keybind badge with listening mode, spring confirm, Esc unbind, & live gameplay reflection | `:GetKey()`, `:SetKey(keyCode, fireCallback)`, `:OnPress(fn)`, `Button`, `Instance` |
| `Category:CreateSlider(title, desc, min, max, default, step, callback)` | Smooth drag/touch slider | `:GetValue()`, `:SetValue(num, fireCallback)` |
| `Category:CreateDropdown(title, desc, items, default, callback)` | Floating overlay single-select menu | `:GetValue()`, `:SetValue(str, fireCallback)`, `:Refresh(items)` |
| `Category:CreateMultiDropdown(title, desc, items, defaultMap, callback)` | Floating overlay multi-select menu | `:GetValue()`, `:SetValue(map, fireCallback)` |
| `Category:CreateButton(title, desc, btnText, callback)` | Pill-shaped action button with tactile scale | `Instance`, `Button` |
| `Category:CreateTextbox(title, desc, placeholder, default, callback)` | Styled input field with focus glow | `:GetValue()`, `:SetValue(str)` |
| `Category:CreateLabel(text)` | Informational text card | `:SetText(str)` |
| `Category:CreateSeparator()` | Subtle horizontal divider line | `Frame` |
| `Window:CreatePriorityTab(name, title, opts)` | Dynamic reorderable task priority list | `:Render()` |
| `Window:CreateStealPanelTab(name, title, opts)` | Dynamic sortable item scanner panel | `:Render()` |
| `Window:CreateSettingsTab(name, title, opts)` | Built-in theme selector & transparency slider | `Page`, `Index` |
| `Window:SetSearch(query)` | Programmatically filters component cards by query string | — |
| `Window:ClearSearch()` | Resets the search bar and restores all cards | — |
| `Window:GetSearch()` | Returns the active search query text | `string` |
| `Window:ShowWarningModal(title, text)` | Displays an iOS alert modal | — |
| `Window:ShowDiscordModal(inviteUrl)` | Displays the Discord community modal | — |
| `Window:Notify({ Title, Content, Duration })` | Displays a bottom-right toast notification | — |
| `Window:Destroy()` | Disconnects all events and destroys the GUI | — |

### Keybind Details & Callback Signatures

The `Category:CreateKeybind` callback receives two arguments:
```lua
Category:CreateKeybind("Fly Mode", "Toggle fly in-game", Enum.KeyCode.F, function(key, isPressed)
    if isPressed then
        -- Triggered during active gameplay when user presses the key
        print("Player pressed physical key:", key.Name)
    else
        -- Triggered when player changes the binding in GUI
        print("Player rebound key to:", key.Name)
    end
end)
```

- **Setting Mode**: Clicking the badge initiates micro-scale press (`0.92x`), glows the border (`Accent2`), pulses into `[ ... ]` listening mode, and upon catching a key, snaps with an energetic `Animations.iOSSpring` expansion (`1.08x` $\rightarrow$ `1.0x`) and color flash.
- **Unbinding**: Pressing `Escape`, `Backspace`, or `Delete` resets the bind to `None` (`Enum.KeyCode.Unknown`).
- **Live Reflection**: Pressing the physical key during gameplay visually compresses the badge on screen in real time.

---

## Standalone Testing

To test the GUI library independently with all components, tactile feedback, and mock panels:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/quantumdingle123/GUILib/main/standalone_test.lua"))()
```
