-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY - MODULE: Themes.lua ]
-- Manages color palettes, gradients, and surface materials for all built-in themes.
-- ==============================================================================

local Themes = {}

Themes.Order = { "Sapphire", "Emerald", "Ruby", "Amethyst", "Midnight", "Amber", "Obsidian", "Rainbow" }

Themes.Palettes = {
    Sapphire = { 
        Name = "Sapphire",
        Order = 1,
        Main = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 58, 110)), 
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 78, 142)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(54, 102, 178))
        }, 
        Topbar = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 74, 134)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(58, 104, 178))
        },
        Button = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(52, 96, 162)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(72, 126, 202))
        },
        ButtonHover = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(72, 128, 204)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(98, 158, 238))
        },
        CardBg = Color3.fromRGB(30, 60, 112), 
        RowBg = Color3.fromRGB(22, 46, 88),
        BoxBg = Color3.fromRGB(36, 72, 130),
        DropBg = Color3.fromRGB(20, 42, 82),
        SwitchOff = Color3.fromRGB(18, 34, 64),
        Accent = Color3.fromRGB(64, 168, 255),
        Accent2 = Color3.fromRGB(160, 224, 255),
        Text = Color3.fromRGB(255, 255, 255), 
        SubText = Color3.fromRGB(205, 228, 252), 
        Stroke = Color3.fromRGB(120, 178, 242),
        GlassRim = Color3.fromRGB(215, 238, 255)
    },
    Emerald = { 
        Name = "Emerald",
        Order = 2,
        Main = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 72, 46)), 
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(32, 98, 62)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(46, 128, 82))
        }, 
        Topbar = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 88, 56)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(48, 128, 84))
        },
        Button = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(46, 132, 84)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(64, 166, 108))
        },
        ButtonHover = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(64, 172, 114)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(92, 210, 142))
        },
        CardBg = Color3.fromRGB(26, 78, 50), 
        RowBg = Color3.fromRGB(18, 58, 38),
        BoxBg = Color3.fromRGB(34, 96, 62),
        DropBg = Color3.fromRGB(16, 52, 34),
        SwitchOff = Color3.fromRGB(14, 44, 28),
        Accent = Color3.fromRGB(64, 232, 142),
        Accent2 = Color3.fromRGB(165, 255, 212),
        Text = Color3.fromRGB(255, 255, 255), 
        SubText = Color3.fromRGB(205, 245, 222), 
        Stroke = Color3.fromRGB(112, 212, 158),
        GlassRim = Color3.fromRGB(215, 255, 232)
    },
    Ruby = { 
        Name = "Ruby",
        Order = 3,
        Main = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(78, 24, 36)), 
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(106, 32, 48)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(136, 44, 64))
        }, 
        Topbar = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(92, 28, 42)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(134, 44, 62))
        },
        Button = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 48, 66)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 64, 84))
        },
        ButtonHover = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(176, 66, 86)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(214, 92, 112))
        },
        CardBg = Color3.fromRGB(82, 26, 38), 
        RowBg = Color3.fromRGB(62, 18, 28),
        BoxBg = Color3.fromRGB(98, 32, 46),
        DropBg = Color3.fromRGB(54, 16, 26),
        SwitchOff = Color3.fromRGB(44, 12, 20),
        Accent = Color3.fromRGB(255, 96, 118),
        Accent2 = Color3.fromRGB(255, 182, 194), 
        Text = Color3.fromRGB(255, 255, 255), 
        SubText = Color3.fromRGB(248, 208, 216), 
        Stroke = Color3.fromRGB(218, 114, 132),
        GlassRim = Color3.fromRGB(255, 220, 226)
    },
    Amethyst = { 
        Name = "Amethyst",
        Order = 4,
        Main = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(56, 28, 90)), 
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(76, 40, 120)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(102, 54, 154))
        }, 
        Topbar = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(68, 34, 108)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(98, 52, 148))
        },
        Button = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(98, 54, 152)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 72, 188))
        },
        ButtonHover = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 74, 192)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(166, 102, 228))
        },
        CardBg = Color3.fromRGB(60, 32, 98), 
        RowBg = Color3.fromRGB(44, 22, 74),
        BoxBg = Color3.fromRGB(74, 40, 118),
        DropBg = Color3.fromRGB(38, 20, 66),
        SwitchOff = Color3.fromRGB(32, 16, 56),
        Accent = Color3.fromRGB(192, 116, 255),
        Accent2 = Color3.fromRGB(230, 188, 255), 
        Text = Color3.fromRGB(255, 255, 255), 
        SubText = Color3.fromRGB(228, 208, 250), 
        Stroke = Color3.fromRGB(168, 118, 224),
        GlassRim = Color3.fromRGB(238, 220, 255)
    },
    Midnight = { 
        Name = "Midnight",
        Order = 5,
        Main = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 42, 58)), 
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(46, 56, 78)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(62, 74, 100))
        }, 
        Topbar = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(42, 52, 72)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 72, 98))
        },
        Button = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(58, 70, 96)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(78, 92, 122))
        },
        ButtonHover = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 94, 126)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(104, 120, 156))
        },
        CardBg = Color3.fromRGB(40, 48, 68), 
        RowBg = Color3.fromRGB(28, 34, 50),
        BoxBg = Color3.fromRGB(48, 58, 82),
        DropBg = Color3.fromRGB(24, 30, 44),
        SwitchOff = Color3.fromRGB(20, 24, 36),
        Accent = Color3.fromRGB(135, 180, 240),
        Accent2 = Color3.fromRGB(205, 228, 255), 
        Text = Color3.fromRGB(255, 255, 255), 
        SubText = Color3.fromRGB(208, 220, 238), 
        Stroke = Color3.fromRGB(122, 138, 172),
        GlassRim = Color3.fromRGB(230, 238, 255)
    },
    Amber = {
        Name = "Amber",
        Order = 6,
        Main = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(78, 42, 12)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(108, 58, 16)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(142, 78, 22))
        },
        Topbar = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(92, 50, 14)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(136, 74, 20))
        },
        Button = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(146, 82, 24)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(184, 108, 32))
        },
        ButtonHover = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(188, 112, 34)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(224, 144, 54))
        },
        CardBg = Color3.fromRGB(84, 46, 16),
        RowBg = Color3.fromRGB(62, 34, 12),
        BoxBg = Color3.fromRGB(98, 56, 20),
        DropBg = Color3.fromRGB(54, 30, 10),
        SwitchOff = Color3.fromRGB(44, 24, 8),
        Accent = Color3.fromRGB(255, 178, 48),
        Accent2 = Color3.fromRGB(255, 226, 142),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(250, 226, 186),
        Stroke = Color3.fromRGB(218, 152, 72),
        GlassRim = Color3.fromRGB(255, 236, 198)
    },
    Obsidian = {
        Name = "Obsidian",
        Order = 7,
        Main = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 22, 26)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(28, 31, 37)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 44, 52))
        },
        Topbar = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 27, 32)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(36, 40, 48))
        },
        Button = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(46, 50, 60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(64, 70, 84))
        },
        ButtonHover = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(66, 72, 86)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(88, 96, 114))
        },
        CardBg = Color3.fromRGB(28, 31, 38),
        RowBg = Color3.fromRGB(20, 22, 28),
        BoxBg = Color3.fromRGB(36, 40, 48),
        DropBg = Color3.fromRGB(17, 19, 24),
        SwitchOff = Color3.fromRGB(14, 15, 20),
        Accent = Color3.fromRGB(96, 106, 126),
        Accent2 = Color3.fromRGB(138, 150, 174),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(196, 204, 218),
        Stroke = Color3.fromRGB(98, 106, 124),
        GlassRim = Color3.fromRGB(228, 234, 244)
    },
    Rainbow = {
        Name = "Rainbow",
        Order = 8,
        IsRainbow = true,
        Preview = ColorSequence.new{
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(168, 42, 68)),
            ColorSequenceKeypoint.new(0.25, Color3.fromRGB(178, 92, 28)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(32, 134, 82)),
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(36, 108, 184)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(122, 50, 174))
        },
        Main = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(96, 34, 64)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(36, 86, 132)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(92, 42, 138))
        },
        Topbar = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(108, 38, 72)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(48, 98, 152))
        },
        Button = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(118, 48, 138)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(46, 118, 186))
        },
        ButtonHover = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(148, 66, 172)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(68, 146, 222))
        },
        CardBg = Color3.fromRGB(26, 28, 42),
        RowBg = Color3.fromRGB(20, 22, 34),
        BoxBg = Color3.fromRGB(32, 36, 54),
        DropBg = Color3.fromRGB(17, 19, 30),
        SwitchOff = Color3.fromRGB(15, 17, 26),
        Accent = Color3.fromRGB(255, 96, 168),
        Accent2 = Color3.fromRGB(136, 226, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(224, 228, 246),
        Stroke = Color3.fromRGB(168, 152, 236),
        GlassRim = Color3.fromRGB(242, 236, 255)
    }
}

function Themes:GetRainbowSnapshot(phase)
    local base = self.Palettes.Rainbow
    local h0 = (tonumber(phase) or 0) % 1
    local h1 = (h0 + 0.16) % 1
    local h2 = (h0 + 0.34) % 1

    return {
        Name = "Rainbow",
        IsRainbow = true,
        Preview = base.Preview,
        Main = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromHSV(h0, 0.62, 0.48)),
            ColorSequenceKeypoint.new(0.5, Color3.fromHSV(h1, 0.60, 0.52)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(h2, 0.62, 0.54))
        },
        Topbar = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromHSV(h0, 0.64, 0.54)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(h2, 0.62, 0.58))
        },
        Button = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromHSV(h0, 0.68, 0.68)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(h1, 0.66, 0.72))
        },
        ButtonHover = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromHSV(h0, 0.64, 0.84)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(h1, 0.62, 0.88))
        },
        CardBg = base.CardBg,
        RowBg = base.RowBg,
        BoxBg = base.BoxBg,
        DropBg = base.DropBg,
        SwitchOff = base.SwitchOff,
        Accent = Color3.fromHSV(h0, 0.72, 0.98),
        Accent2 = Color3.fromHSV(h1, 0.45, 1.00),
        Text = base.Text,
        SubText = base.SubText,
        Stroke = Color3.fromHSV((h0 + 0.08) % 1, 0.50, 0.92),
        GlassRim = Color3.fromHSV((h0 + 0.12) % 1, 0.25, 1.00)
    }
end

function Themes:GetOrderedNames()
    local list = {}
    local seen = {}
    for _, name in ipairs(self.Order) do
        if self.Palettes[name] then
            table.insert(list, name)
            seen[name] = true
        end
    end
    for name in pairs(self.Palettes) do
        if not seen[name] then
            table.insert(list, name)
        end
    end
    return list
end

function Themes:Get(name)
    return self.Palettes[name] or self.Palettes.Sapphire
end

function Themes:Register(name, palette)
    if type(name) == "string" and type(palette) == "table" then
        self.Palettes[name] = palette
    end
end

return Themes