-- ==============================================================================
-- [ SYNTAXIS GUI LIBRARY - MODULE: Themes.lua ]
-- Manages color palettes, gradients, and surface materials for all built-in themes.
-- ==============================================================================

local Themes = {}

Themes.Palettes = {
    Sapphire = { 
        Name = "Sapphire",
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
    }
}

function Themes:Get(name)
    return self.Palettes[name] or self.Palettes.Sapphire
end

function Themes:Register(name, palette)
    if type(name) == "string" and type(palette) == "table" then
        self.Palettes[name] = palette
    end
end

return Themes
