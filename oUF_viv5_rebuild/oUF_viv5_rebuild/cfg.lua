-----------------------------
-- |oUF_viv5
-- |rebuild by EbonyIvory
-----------------------------

-----------------------------
-- INIT
-----------------------------

local addon, ns = ...
local cfg = CreateFrame("Frame")

local mediaFolder = "Interface\\AddOns\\oUF_viv5_rebuild\\media\\"

-----------------------------
-- CONFIG
-----------------------------

-- Show/hide frames:
cfg.showTot = true -- show target of target frame
cfg.showTotot = true -- show target of target of target frame
cfg.showPet = true -- show pet frame
cfg.showPetTarget = true -- show pet frame
cfg.showFocus = true -- show focus frame
cfg.showFocusTarget = false -- show focus target frame
cfg.showBossFrames = false    -- Show boss frames

cfg.showParty = false -- show party frames (shown as 5man raid)
cfg.showRaid = false -- show raid frames
cfg.raidShowSolo = false -- show raid frames even when solo
cfg.raidShowAllGroups = false -- show raid groups 6, 7 and 8 (more than 25man raid)

-- Show/hide Blizzard Stuff
cfg.hideBuffFrame = false -- hide Blizzard's default buff frame (best to keep it on until you can cancel buffs in oUF again)
cfg.hideWeaponEnchants = false -- hide Blizzard's default temporary weapon enchants frame (best to keep it on until you can cancel buffs in oUF again)
cfg.hideRaidFrame = true -- hide Blizzard's default raid frames
cfg.hideRaidFrameContainer = true -- hide Blizzard's default raid container (that frame with the role check button, colored ground marks, etc)

-- Frame positioning 
cfg.playerX = -150 -- Player frame's x-offset position from the relative point of the screen
cfg.playerY = 300 -- Player frame's y-offset position from the relative point of the screen
cfg.playerRelativePoint = "BOTTOM" -- Player frame's reference point of the screen used for X and Y offsets. Possible values are: "TOP"/"BOTTOM"/"LEFT"/"RIGHT"/"CENTER"/"TOPLEFT"/"ROPRIGHT"/"BOTTOMLEFT"/"BOTTOMRIGHT"
cfg.targetX = -cfg.playerX -- Target frame's x-offset position from the relative point of the screen
cfg.targetY = cfg.playerY -- Target frame's y-offset position from the relative point of the screen
cfg.targetRelativePoint = "BOTTOM" -- Target frame's reference point of the screen used for X and Y offsets. Possible values are: "TOP"/"BOTTOM"/"LEFT"/"RIGHT"/"CENTER"/"TOPLEFT"/"ROPRIGHT"/"BOTTOMLEFT"/"BOTTOMRIGHT"
cfg.raidX = 10 -- Raid/Party x-offset position from the relative point of the screen
cfg.raidY = -180 -- Raid/Party y-offset position from the relative point of the screen
cfg.raid40X = 10 -- 40man Raid/Party x-offset position from the relative point of the screen
cfg.raid40Y = -10 -- 40man Raid/Party y-offset position from the relative point of the screen
cfg.raidRelativePoint = "TOPLEFT" -- Raid/Party's reference point of the screen used for X and Y offsets. Possible values are: "TOP"/"BOTTOM"/"LEFT"/"RIGHT"/"CENTER"/"TOPLEFT"/"ROPRIGHT"/"BOTTOMLEFT"/"BOTTOMRIGHT"
cfg.raidAnchorPoint = "TOP" -- Defines the raid's anchor point. "BOTTOM" will make the raid groups grow upwards, "TOP" will grow downwards.
cfg.raid40RelativePoint = "TOPLEFT" -- 40man Raid/Party's reference point of the screen used for X and Y offsets. Possible values are: "TOP"/"BOTTOM"/"LEFT"/"RIGHT"/"CENTER"/"TOPLEFT"/"ROPRIGHT"/"BOTTOMLEFT"/"BOTTOMRIGHT"
cfg.raid40AnchorPoint = "TOP" -- Defines 40man raid's anchor point. "BOTTOM" will make the raid groups grow upwards, "TOP" will grow downwards.

-- Misc frame settings
cfg.raidScale = 1 -- scale factor for raid frames
cfg.frameScale = 1 -- scale factor for all other frames
cfg.classBar = false    -- show player class bar
cfg.Castbars = false -- use built-in castbars

-- Plugins
cfg.ShowIncHeals = false    -- Show incoming heals in player and raid frames
cfg.smoothHealth = true     -- Smooth healthbar updates
cfg.smoothPower = true      -- Smooth powerbar updates
cfg.enableDebuffHighlight = false -- Edable Highlighting of dispellable debuffs
cfg.showAuraWatch = false -- Show specific class buffs on raid frames
cfg.showRaidDebuffs = false -- Show important debuff icons on raid frames
cfg.ThreatBar = false
cfg.Reputation = false
cfg.AltPowerBar = false
cfg.Experience = false

-- Auras
cfg.showPlayerBuffs = false
cfg.showPlayerDebuffs = false

cfg.showTargetBuffs = false
cfg.showTargetDebuffs = false

cfg.showPetBuffs = false
cfg.showPetDebuffs = false

cfg.showFocusBuffs = false
cfg.showFocusDebuffs = false

cfg.showBossBuffs = false

-- viv5 org cfg
-- SETUP --
cfg.showPlayerName = false

cfg.mainColor = {80/255, 64/255, 77/255}        -- mainly used for healthbar
cfg.sndColor = {208/255, 172/255, 146/255}      -- font color, ...
cfg.trdColor = {220/255, 220/255, 220/255}      -- castbar, buff/debuff borders

cfg.hpTex = mediaFolder.."dA"                   -- health bar texture
cfg.ppTex = mediaFolder.."dQ"                   -- power bar texture
cfg.auraTex = mediaFolder.."dBBorderG"          -- border texture for buffs/debuffs

cfg.glowTex = mediaFolder.."glowTex"            -- HP border texture (also used for threat highlight) -- glowTex, glowTex2, glowTex3, glowTex4 (thin > thicker)
cfg.glowTex2 = mediaFolder.."glowTex2"          -- PP border texture (also used for debuff highlight) -- glowTex, glowTex2, glowTex3, glowTex4 (thin > thicker) 
    
cfg.nameFont = mediaFolder.."fzwbks.TTF"
cfg.numbFont = mediaFolder.."QuadrantaRegular.ttf"
cfg.nameFS = 12
cfg.numbFS = 14 
cfg.fontF = "THINOUTLINE"           -- cfg.fontF = nil

cfg.useCBFT = false                 -- oUF Combat Feedback support
cfg.usePlayerAuras = true           -- show/hide playerauras (replace blizzards auras)
cfg.filterTargetDebuffs = false     -- filter target's debuffs to only show debuffs applied by the player (true)
cfg.useIconGlow = true              -- show glow around buffs and debuffs
cfg.pAlpha = 0.0                    -- player, focus, target portrait alpha (transparency), 0 = hidden
cfg.PpAlpha = 0.0                   -- party portrait alpha (transparency), 0 = hidden

cfg.useCastbar = false              -- show/hide player, target, focus castbar
cfg.useSpellIcon = false            -- show/hide castbar spellicon
cfg.useCastTime = true              -- show/hide casttime (requires useSpellIcon = true)
cfg.useDKrunes = true               -- show/hide DeathKnight runes

cfg.useArenaFrames = false          -- show/hide arena frames

cfg.numberZZZ = 1                   -- 0 will display 18400k as 18k, 1 = 18.4k, ....

-- scale some frames
cfg.playerScale = 1.0       -- player, player pet
cfg.targetScale = 1.0       -- target, ToT
cfg.focusScale = 1.0        -- focus, focus target
cfg.arenaScale = 1.0        -- arena, arena ToT
cfg.raidScale = 1.0         -- raid, party

-- weapon enchant's position
cfg.weapEnchantAnchor = "TOPRIGHT"
cfg.weapEnchant_X = -60
cfg.weapEnchant_Y = -2

-- initial frame size
cfg.height = {
    ["L"] = 35,     -- player, target, focus
    ["M"] = 26,     -- arena, MT, ...
    ["S"] = 22,     -- ToT, FocusTarget, pet
    ["R"] = 32      -- raid, party
} 

cfg.width = {
    ["L"] = 255,    -- player, target, focus
    ["M"] = 128,    -- arena, MT, ...
    ["S"] = 124,    -- ToT, FocusTarget, pet
    ["R"] = 70,     -- raid, party
}

cfg.powerBarHeight = 6

-----------------------------
-- HANDOVER
-----------------------------

ns.cfg = cfg
