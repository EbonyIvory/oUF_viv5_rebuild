-----------------------------
-- |oUF_viv5
-- |rebuild by EbonyIvory
-----------------------------

local addon, ns = ...
  
local cfg = ns.cfg
local lib = ns.lib

-----------------------------
-- STYLE FUNCTIONS
-----------------------------
  
local bgMulti = 0.4


-- Hide Blizzard stuff
if cfg.hideRaidFrame then
    CompactRaidFrameManager:UnregisterAllEvents()
    CompactRaidFrameManager:Hide()
end

if cfg.hideRaidFrameContainer then 
    CompactRaidFrameContainer:UnregisterAllEvents()
    CompactRaidFrameContainer:Hide()
end

if cfg.hideBuffFrame then
    BuffFrame:Hide()
end

if cfg.hideWeaponEnchants then
    TemporaryEnchantFrame:Hide()
end
-- Hide Blizzard stuff End

-- Unit Frame Layout
UnitSpecific = {
    player = function(self)
        -- unit specifics
        self.unitType = "player"

        -- add frame
        lib.AddHealthBar(self)
        lib.AddPowerBar(self)
        lib.AddPortrait(self)
        lib.AddBorder(self)

        -- set frame size
        -- self:SetScale(cfg.frameScale)
        self:SetWidth(cfg.width.L)
        self:SetHeight(cfg.height.L)

        -- set frame default size
        self:SetAttribute('initial-height', cfg.height.L)
        self:SetAttribute('initial-width', cfg.width.L)	

        -- set status bar specifics
        self.Health:SetWidth(cfg.width.L * 0.7)
        self.Health:SetHeight(cfg.height.L)
        self.Health:SetPoint("RIGHT", self, "RIGHT", 0, 0)

        self.Power:SetWidth(cfg.width.L * 0.44)
        self.Power:SetHeight(cfg.powerBarHeight)
        self.Power:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", -2, 0)

        -- set portrait
        self.Portrait:SetWidth(cfg.width.L * 0.3)
        self.Portrait:SetHeight(cfg.height.L)
        self.Portrait:SetPoint("TOPRIGHT", self.Health, "TOPLEFT", 0, 0)

        -- add text
        lib.AddTextTags(self)

        -- add extra frame
        --lib.AddIcons(self)
        --lib.AddClassBar(self)

        -- Buffs and Debuffs
        if cfg.showPlayerBuffs then lib.AddBuffs(self, cfg.auras.BUFFPOSITIONS.player) end
        if cfg.showPlayerDebuffs then lib.AddDebuffs(self,cfg.auras.DEBUFFPOSITIONS.player) end
    end,
    
    target = function(self)
        -- unit specifics
        self.unitType = "target"

        -- add frame
        lib.AddHealthBar(self)
        lib.AddPowerBar(self)
        lib.AddPortrait(self)
        lib.AddBorder(self)

        -- set frame size
        -- self:SetScale(cfg.frameScale)
        self:SetWidth(cfg.width.L)
        self:SetHeight(cfg.height.L)

        -- set frame default size
        self:SetAttribute('initial-height', cfg.height.L)
        self:SetAttribute('initial-width', cfg.width.L)	

        -- set status bar specifics
        self.Health:SetWidth(cfg.width.L * 0.7)
        self.Health:SetHeight(cfg.height.L)
        self.Health:SetPoint("LEFT", self, "LEFT", 0, 0)

        self.Power:SetWidth(cfg.width.L * 0.44)
        self.Power:SetHeight(cfg.powerBarHeight)
        self.Power:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMLEFT", 2, 0)

        -- set portrait
        self.Portrait:SetWidth(cfg.width.L * 0.3)
        self.Portrait:SetHeight(cfg.height.L)
        self.Portrait:SetPoint("TOPLEFT", self.Health, "TOPRIGHT", 0, 0)

        -- add text
        lib.AddTextTags(self)

        -- add extra frame
        --lib.AddIcons(self)

        -- Buffs and Debuffs
        if cfg.showTargetBuffs then	lib.AddBuffs(self, cfg.auras.BUFFPOSITIONS.target) end
        if cfg.showTargetDebuffs then lib.AddDebuffs(self,cfg.auras.DEBUFFPOSITIONS.target) end
    end,
    
    pet = function(self)
        -- unit specifics
        self.unitType = "pet"

        -- add frame
        lib.AddHealthBar(self)
        lib.AddPowerBar(self)
        lib.AddBorder(self)

        -- set frame size
        -- self:SetScale(cfg.frameScale)
        self:SetWidth(cfg.width.S)
        self:SetHeight(cfg.height.S)

        -- set status bar specifics
        self.Health:SetWidth(cfg.width.S)
        self.Health:SetHeight(cfg.height.S)
        self.Health:SetPoint("LEFT", self, "LEFT", 0, 0)

        self.Power:SetWidth(cfg.width.S * 0.6)
        self.Power:SetHeight(cfg.powerBarHeight)
        self.Power:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMLEFT", 2, 0)

        -- set frame default size
        self:SetAttribute('initial-height', cfg.height.S)
        self:SetAttribute('initial-width', cfg.width.S)

        -- add text
        lib.AddTextTags(self)
    end,
    
    pettarget = function(self)
        -- unit specifics
        self.unitType = "pettarget"

        -- add frame
        lib.AddHealthBar(self)
        lib.AddPowerBar(self)
        lib.AddBorder(self)

        -- set frame default size
        self:SetAttribute('initial-height', cfg.height.S)
        self:SetAttribute('initial-width', cfg.width.S)
    end,
    
    targettarget = function(self)
        -- unit specifics
        self.unitType = "targettarget"

        -- add frame
        lib.AddHealthBar(self)
        lib.AddPowerBar(self)
        lib.AddBorder(self)

        -- set frame size
        -- self:SetScale(cfg.frameScale)
        self:SetWidth(cfg.width.S)
        self:SetHeight(cfg.height.S)

        -- set status bar specifics
        self.Health:SetWidth(cfg.width.S)
        self.Health:SetHeight(cfg.height.S)
        self.Health:SetPoint("RIGHT", self, "RIGHT", 0, 0)

        self.Power:SetWidth(cfg.width.S * 0.6)
        self.Power:SetHeight(cfg.powerBarHeight)
        self.Power:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", -2, 0)

        -- set frame default size
        self:SetAttribute('initial-height', cfg.height.S)
        self:SetAttribute('initial-width', cfg.width.S)

        -- add text
        lib.AddTextTags(self)
    end,
    
    focus = function(self)
        -- unit specifics
        self.unitType = "focus"

        -- add frame
        lib.AddHealthBar(self)
        lib.AddPowerBar(self)
        lib.AddPortrait(self)
        lib.AddBorder(self)

        -- set frame size
        -- self:SetScale(cfg.frameScale)
        self:SetWidth(cfg.width.L)
        self:SetHeight(cfg.height.L)

        -- set frame default size
        self:SetAttribute('initial-height', cfg.height.L)
        self:SetAttribute('initial-width', cfg.width.L)	

        -- set status bar specifics
        self.Health:SetWidth(cfg.width.L * 0.7)
        self.Health:SetHeight(cfg.height.L)
        self.Health:SetPoint("LEFT", self, "LEFT", 0, 0)

        self.Power:SetWidth(cfg.width.L * 0.44)
        self.Power:SetHeight(cfg.powerBarHeight)
        self.Power:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMLEFT", 2, 0)

        -- set portrait
        self.Portrait:SetWidth(cfg.width.L * 0.3)
        self.Portrait:SetHeight(cfg.height.L)
        self.Portrait:SetPoint("TOPLEFT", self.Health, "TOPRIGHT", 0, 0)

        -- add text
        --lib.AddTextTags(self)

        -- add extra frame
        --lib.AddIcons(self)

        -- Buffs and Debuffs
        if cfg.showTargetBuffs then	lib.AddBuffs(self, cfg.auras.BUFFPOSITIONS.target) end
        if cfg.showTargetDebuffs then lib.AddDebuffs(self,cfg.auras.DEBUFFPOSITIONS.target) end
    end,
    
    focustarget = function(self)
        -- unit specifics
        self.unitType = "targettarget"

        -- add frame
        lib.AddHealthBar(self)
        lib.AddPowerBar(self)
        lib.AddBorder(self)

        -- set frame default size
        self:SetAttribute('initial-height', cfg.height.S)
        self:SetAttribute('initial-width', cfg.width.S)
    end
}

local Style = function(self, unit)
    -- Shared layout code
    self:RegisterForClicks('AnyUp')
    self.menu = lib.menu
    self:SetAttribute("*type2", "menu")

    if UnitSpecific[unit] then
        return UnitSpecific[unit](self)
    end
end
-- Unit Frame Layout End


local RaidStyle = function(self, unit)
    self:RegisterForClicks('AnyUp')
    self.menu = menu
    self:SetAttribute("*type2", "menu")

    self.unitType = "raid"

    self.Range = {
        insideAlpha = 1,
        outsideAlpha = 0.3
    }

    --!! add status bar code here

    --!! frame set code here
    
end


local BossStyle = function(self, unit, isSingle)
    self:RegisterForClicks('AnyUp')
    self.menu = menu
    self:SetAttribute("*type2", "menu")

    self.unitType = "boss"

    --!! add status bar and settings code here
end


-----------------------------
-- SPAWN UNITS
-----------------------------

oUF:RegisterStyle('viv5', Style)
oUF:RegisterStyle('viv5Raid', RaidStyle)
oUF:RegisterStyle('viv5Boss', BossStyle)

oUF:Factory(function(self)
    -- Single Frames
    self:SetActiveStyle('viv5')

    self:Spawn('player'):SetPoint("BOTTOMRIGHT", UIParent, cfg.playerRelativePoint, cfg.playerX, cfg.playerY)
    self:Spawn('target'):SetPoint("BOTTOMLEFT", UIParent, cfg.targetRelativePoint, cfg.targetX, cfg.targetY)

    if cfg.showTot then
        self:Spawn('targettarget'):SetPoint("TOPRIGHT",oUF_viv5Target,"BOTTOMRIGHT", 0, -8)
    end
    if cfg.showPet then
        self:Spawn('pet'):SetPoint("TOPLEFT",oUF_viv5Player,"BOTTOMLEFT", 0, -8)
    end
    if cfg.showPetTarget then
        self:Spawn('pettarget'):SetPoint("BOTTOMRIGHT",oUF_viv5Player,"TOPRIGHT", 0, -8)
    end
    if cfg.showFocus then
        self:Spawn('focus'):SetPoint("BOTTOMLEFT",oUF_viv5Target,"TOPLEFT", 0, 36)
    end
    if cfg.showFocusTarget then
        self:Spawn('focustarget'):SetPoint("BOTTOMLEFT",oUF_viv5Target,"TOPLEFT", 0, 8)
    end

    if cfg.showRaid then
        self:SetActiveStyle('viv5Raid')
        local raid = oUF:SpawnHeader("oUF_Raid", nil, "custom [@raid26,exists] hide;show", 
		"showRaid", cfg.showRaid,  
		"showPlayer", true,
		"showSolo", cfg.raidShowSolo,
		"showParty", cfg.showParty,
		"xoffset", 9,
		"yOffset", 5,
		"groupFilter", "1,2,3,4,5",
		"groupBy", "GROUP",
		"groupingOrder", "1,2,3,4,5",
		"sortMethod", "INDEX",
		"maxColumns", "5",
		"unitsPerColumn", 5,
		"columnSpacing", 7,
		"point", "LEFT",
		"columnAnchorPoint", cfg.raidAnchorPoint,
		"oUF-initialConfigFunction", ([[
		self:SetWidth(%d)
		self:SetHeight(%d)
		]]):format(72, 28))
		raid:SetScale(cfg.raidScale)
		raid:SetPoint("BOTTOMLEFT", UIParent, cfg.raidRelativePoint, cfg.raidX, cfg.raidY)
		CompactRaidFrameContainer:Hide() 
		CompactRaidFrameManager:SetAlpha(0)

		local raid40 = oUF:SpawnHeader("oUF_Raid40", nil, "custom [@raid26,exists] show;hide", 
		"showRaid", cfg.showRaid,  
		"showPlayer", true,
		"showSolo", cfg.raidShowSolo,
		"showParty", cfg.showParty,
		"xoffset", 9,
		"yOffset", 5,
		"groupFilter", "1,2,3,4,5",
		"groupBy", "GROUP",
		"groupingOrder", "1,2,3,4,5",
		"sortMethod", "INDEX",
		"maxColumns", "8",
		"unitsPerColumn", 5,
		"columnSpacing", 7,
		"point", "LEFT",
		"columnAnchorPoint", cfg.raid40AnchorPoint,
		"oUF-initialConfigFunction", ([[
		self:SetWidth(%d)
		self:SetHeight(%d)
		]]):format(72, 28))
		raid40:SetScale(cfg.raidScale)
		raid40:SetPoint("TOPLEFT", UIParent, cfg.raid40RelativePoint, cfg.raid40X, cfg.raid40Y)
    end

    -- Boss frames
	if cfg.showBossFrames then
		self:SetActiveStyle('viv5Boss')
		local bossFrames = {}
		for i = 1, MAX_BOSS_FRAMES do
			local unit = self:Spawn('boss' .. i)
			if i > 1 then
				unit:SetPoint('BOTTOMLEFT', bossFrames[i - 1], 'TOPLEFT', 0, 8)
			else
				unit:SetPoint('BOTTOMLEFT', oUF_viv5Target, 'TOPRIGHT', 100, 90) 
			end
			bossFrames[i] = unit
		end
	end
end)
