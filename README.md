# Syntaxis GUI Library (`SyntaxisLib`) v2.3.0

A modular, reusable iOS / Liquid Glass UI library for Roblox Luau scripts. Designed to separate visual architecture, splash loading screens, component rendering, animations, tactile button interactions, and theme state from main automation scripts.

---

## What's New in v2.3.0

- 🧊 **Centered Monolith Loading Screen (`Loader.lua`)**: Enable seamlessly via `ShowLoader = true` in `SyntaxisLib:CreateWindow(config)` or construct standalone via `SyntaxisLib:CreateLoader(config)`. Features an iOS-style `Lighting.BlurEffect` depth backdrop, full-bleed dark scrim, emblem badge, tabular percentage telemetry, and a zero-teleport morph directly into the main window and `ToggleOrb`.
- 🎨 **8 Built-In Themes & Live Animated `Rainbow` (`Themes.lua`, `Window.lua`)**: Expands the palette selector to a non-scrolling `2 × 4` grid of un-mixed full-bleed swatches (`Sapphire`, `Emerald`, `Ruby`, `Amethyst`, `Midnight`, `Amber`, `Obsidian`, and live-cycling `Rainbow`) with active outline stroke and left accent indicator.
- 🔢 **Stabilized Tabular Numerals & Layout Reservation (`Utils.lua`)**: `Utils:ApplyTabularFont` (`RobotoMono`) paired with `Utils:CreateNumericFormatter` pre-computes fixed `ReservedWidth` from `[min, max, increment, suffix]` ranges so live scaling readouts, transparency percentages, and loader progress never jitter or push neighboring labels.
- ✨ **Interaction & Layout Refinements**: Crisp vector `X` search clear button, continuous pointer/touch slider dragging (`Utils:BindSliderDrag`), non-clipping textbox placeholders, cleanly anchored floating dropdown menus, and symmetric rounding (`Utils:RoundToDecimals`) across negative and fractional slider ranges.

### Included from v2.2.0
- 🔍 **Default Header Search Bar**: Live filtering across categories with auto-expansion and `Window:SetSearch` / `Window:ClearSearch` / `Window:GetSearch`.
- 🛡️ **Anti-Cheat Camouflage**: Safe container detection (`syn.protect_gui` / `protectgui` / `gethui()`) with randomized anonymous GUI naming (`G_<hex>`) and automatic prior-instance cleanup on re-execution.
- ⌨️ **Tactile Keybind Controls**: Interactive listening badges (`[ ... ]`), spring confirmation (`Animations.iOSSpring`), `Escape`/`Backspace`/`Delete` unbinding, and real-time in-game keypress reflection.

---

## Architecture & Module Structure

```text
GUILib/
├── SyntaxisLib.lua         # Modular public entrypoint (v2.3.0) loading src/ modules with automatic retry
├── standalone_test.lua     # Standalone verification & showcase script
├── README.md               # Developer documentation & API reference
└── src/                    # Modular source files
    ├── init.lua            # Modular loader entrypoint, version metadata, & ShowLoader orchestration
    ├── Loader.lua          # Centered Monolith splash screen, iOS Blur backdrop, & window morph
    ├── Themes.lua          # 8 iOS Liquid Glass palettes (Sapphire, Emerald, Ruby, Amethyst, Midnight, Amber, Obsidian, Rainbow)
    ├── Animations.lua      # TweenService presets & tactile button scale feedback
    ├── Utils.lua           # Safe GUI parenting, UICorner, UIGradient, multi-device slider drag, & tabular numeric formatters
    ├── Modals.lua          # Warning modals, Discord invite modal, & toast notifications
    ├── Components.lua      # Categories, Toggles, Sliders, Dropdowns, Multi-Dropdowns, Buttons, Textboxes, Keybinds, Labels, Separators
    ├── Panels.lua          # Dynamic Task Priority panel & live Steal Panel list view (with live Rainbow sync)
    └── Window.lua          # Main window frame, sidebar navigation, search bar, 2x4 theme grid, transparency engine, & cleanup
```

---

## Quick Start

### Loading the Library

```lua
local SyntaxisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/quantumdingle123/GUILib/main/SyntaxisLib.lua"))()
```

### Creating a Window (with Centered Monolith Loader), Tabs, Categories, and Controls

```lua
local Window = SyntaxisLib:CreateWindow({
    Title = "Syntaxis",
    GameName = "My Game",
    GuiName = "SyntaxHubGUI",
    Theme = "Sapphire",
    ShowLoader = true,          -- Optional: plays Centered Monolith splash & morphs into Window
    LoaderDuration = 2.8,
    LoaderBlur = true,
    State = State,              -- Optional shared state table
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

-- Add a Slider (tabular numerals & range-reserved readout)
CatSteal:CreateSlider("Min Scale", "Minimum size multiplier", 1, 10, 1, 0.5, function(value)
    print("Min Scale:", value)
end)

-- Add Settings Tab (2x4 Theme Grid + Transparency Slider)
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

## Component & Loader API Reference

| Method | Description | Return Object Methods |
| :--- | :--- | :--- |
| `SyntaxisLib:CreateWindow(config)` | Creates the main UI window (supports `ShowLoader`, `GameName`, `Theme`, `LoaderDuration`, `LoaderBlur`, `LoaderBlurSize`, `LoaderSteps`, `MorphToWindow`) | Window instance |
| `SyntaxisLib:CreateLoader(config)` | Standalone Centered Monolith loader with iOS `BlurEffect` scrim | `:SetProgress(ratio, status, stepLabel)`, `:OnComplete(fn)`, `:Dismiss(cb)` |
| `Window:CreateTab(name, title)` | Creates a sidebar tab and scrollable page | `:CreateCategory(title, defaultOpen, order)` |
| `Category:CreateToggle(title, desc, default, callback)` | High-contrast iOS switch control | `:GetValue()`, `:SetValue(bool, fireCallback)` |
| `Category:CreateKeybind(title, desc, defaultKey, callback, order)` | Tactile keybind badge with listening mode, spring confirm, Esc unbind, & live gameplay reflection | `:GetKey()`, `:SetKey(keyCode, fireCallback)`, `:OnPress(fn)`, `Button`, `Instance` |
| `Category:CreateSlider(title, desc, min, max, default, step, callback)` | Continuous drag/touch slider with tabular value alignment & signed/decimal snapping | `:GetValue()`, `:SetValue(num, fireCallback)` |
| `Category:CreateDropdown(title, desc, items, default, callback)` | Floating overlay single-select menu | `:GetValue()`, `:SetValue(str, fireCallback)`, `:Refresh(items)` |
| `Category:CreateMultiDropdown(title, desc, items, defaultMap, callback)` | Floating overlay multi-select menu | `:GetValue()`, `:SetValue(map, fireCallback)` |
| `Category:CreateButton(title, desc, btnText, callback)` | Pill-shaped action button with tactile scale | `Instance`, `Button` |
| `Category:CreateTextbox(title, desc, placeholder, default, callback)` | Styled input field with focus glow | `:GetValue()`, `:SetValue(str)` |
| `Category:CreateLabel(text)` | Informational text card | `:SetText(str)` |
| `Category:CreateSeparator()` | Subtle horizontal divider line | `Frame` |
| `Window:CreatePriorityTab(name, title, opts)` | Dynamic reorderable task priority list | `:Render()` |
| `Window:CreateStealPanelTab(name, title, opts)` | Dynamic sortable item scanner panel | `:Render()` |
| `Window:CreateSettingsTab(name, title, opts)` | Built-in 8-theme `2 × 4` selector & transparency slider | `Page`, `Index` |
| `Window:SetTheme(themeName)` / `Window:GetActiveTheme()` | Switches or inspects the active theme palette (supports animated `Rainbow`) | — |
| `Window:SetTransparency(percent)` | Sets glass card transparency percentage (`0–100`) | — |
| `Window:SetSearch(query)` / `ClearSearch()` / `GetSearch()` | Programmatically filters, clears, or queries the search bar | `string` (for `GetSearch`) |
| `Window:ShowWarningModal(title, text)` | Displays an iOS alert modal | — |
| `Window:ShowDiscordModal(inviteUrl)` | Displays the Discord community modal | — |
| `Window:Notify({ Title, Content, Duration })` | Displays a bottom-right toast notification | — |
| `Window:Destroy()` | Disconnects all events, stops Rainbow heartbeat, and destroys the GUI | — |

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

- **Setting Mode**: Clicking the badge initiates micro-scale press (`0.92x`), glows the border (`Accent2`), pulses into `[ ... ]` listening mode, and upon catching a key, snaps with an energetic `Animations.iOSSpring` expansion (`1.08x` -> `1.0x`) and color flash.
- **Unbinding**: Pressing `Escape`, `Backspace`, or `Delete` resets the bind to `None` (`Enum.KeyCode.Unknown`).
- **Live Reflection**: Pressing the physical key during gameplay visually compresses the badge on screen in real time.

---

## Standalone Testing

To test the GUI library independently (including the Centered Monolith loader, 8 themes, search clear, floating dropdowns, sliders, and mock panels):

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/quantumdingle123/GUILib/main/standalone_test.lua"))()
```
