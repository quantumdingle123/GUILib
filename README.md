# Syntaxis GUI Library (`SyntaxisLib`) v2.0.0

A modular, reusable iOS / Liquid Glass UI library for Roblox Luau scripts. Designed to separate visual architecture, component rendering, animations, and theme state from main automation scripts.

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
    ├── Components.lua      # Categories, Toggles, Sliders, Floating Dropdowns, Multi-Dropdowns, Buttons, Textboxes, Labels, Separators
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

-- Add a Multi-Select Floating Dropdown
CatSteal:CreateMultiDropdown("Target Areas", "Select conveyor zones", {
    "All", "Mythic", "Cave", "Desert", "Ice", "Lava"
}, { ["All"] = true }, function(selectedMap)
    print("Updated Target Areas", selectedMap)
end)

-- Add a Single-Select Floating Dropdown
CatSteal:CreateDropdown("Min Rarity", "Minimum rarity tier", {
    "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Godly", "Divine"
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
| `Category:CreateSlider(title, desc, min, max, default, step, callback)` | Smooth drag/touch slider | `:GetValue()`, `:SetValue(num, fireCallback)` |
| `Category:CreateDropdown(title, desc, items, default, callback)` | Floating overlay single-select menu | `:GetValue()`, `:SetValue(str, fireCallback)`, `:Refresh(items)` |
| `Category:CreateMultiDropdown(title, desc, items, defaultMap, callback)` | Floating overlay multi-select menu | `:GetValue()`, `:SetValue(map, fireCallback)` |
| `Category:CreateButton(title, desc, btnText, callback)` | Pill-shaped action button | `Instance`, `Button` |
| `Category:CreateTextbox(title, desc, placeholder, default, callback)` | Styled input field | `:GetValue()`, `:SetValue(str)` |
| `Category:CreateLabel(text)` | Informational text card | `:SetText(str)` |
| `Category:CreateSeparator()` | Subtle horizontal divider | `Frame` |
| `Window:CreatePriorityTab(name, title, opts)` | Dynamic reorderable task priority list | `:Render()` |
| `Window:CreateStealPanelTab(name, title, opts)` | Dynamic sortable item scanner panel | `:Render()` |
| `Window:CreateSettingsTab(name, title, opts)` | Built-in theme selector & transparency slider | `Page`, `Index` |
| `Window:ShowWarningModal(title, text)` | Displays an iOS alert modal | — |
| `Window:ShowDiscordModal(inviteUrl)` | Displays the Discord community modal | — |
| `Window:Notify({ Title, Content, Duration })` | Displays a bottom-right toast notification | — |
| `Window:Destroy()` | Disconnects all events and destroys the GUI | — |

---

## Standalone Testing

To test the GUI library independently without any game script:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/quantumdingle123/GUILib/main/standalone_test.lua"))()
```
