-----------------------------
-- |oUF_viv5
-- |rebuild by EbonyIvory
-----------------------------

-----------------------------
-- INIT
-----------------------------

local addon, ns = ...
local cfg = ns.cfg
local lib = CreateFrame("Frame")  

local playerClass = select(2, UnitClass("player"))

-----------------------------
-- FUNCTIONS
-----------------------------
-- Gen Font String
local GenFontString = function(object, name, size, outline)
    local fs = object:CreateFontString(nil, "ARTWORK")
    fs:SetFont(name, size, outline)
    fs:SetShadowColor(0, 0, 0, 0.5)
    fs:SetShadowOffset(0, -0)
    return fs
end

-- Menus
local dropdown = CreateFrame("Frame", "MyAddOnUnitDropDownMenu", UIParent, "UIDropDownMenuTemplate")

UIDropDownMenu_Initialize(
    dropdown, 
    function(self)
        local unit = self:GetParent().unit
        if not unit then return end

        local menu, name, id
        if UnitIsUnit(unit, "player") then
            menu = "SELF"
        elseif UnitIsUnit(unit, "vehicle") then
            menu = "VEHICLE"
        elseif UnitIsUnit(unit, "pet") then
            menu = "PET"
        elseif UnitIsPlayer(unit) then
            id = UnitInRaid(unit)
            if id then
                menu = "RAID_PLAYER"
                name = GetRaidRosterInfo(id)
            elseif UnitInParty(unit) then
                menu = "PARTY"
            else
                menu = "PLAYER"
            end
        else
            menu = "TARGET"
            name = RAID_TARGET_ICON
        end
        if menu then
            UnitPopup_ShowMenu(self, menu, unit, name, id)
        end
    end, 
    "MENU")

lib.menu = function(self)
    dropdown:SetParent(self)
    ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)
end

--remove focus from menu list
do 
    for k,v in pairs(UnitPopupMenus) do
        for x,y in pairs(UnitPopupMenus[k]) do
            if y == "SET_FOCUS" then
                table.remove(UnitPopupMenus[k], x)
            elseif y == "CLEAR_FOCUS" then
                table.remove(UnitPopupMenus[k], x)
            end
        end
    end
end

-- Menus End

-- Create Glow Frame Function
lib.AddBorder = function(self, size)
    self.Border = CreateFrame("Frame", nil, self)
    self.Border:SetPoint("TOPLEFT", self, "TOPLEFT", -size, size)
    self.Border:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", size, -size)
    self.Border:SetBackdrop({edgeFile = cfg.glowTex, edgeSize = size, insets = {left = size, right = size, top = size, bottom = size}})
    self.Border:SetBackdropColor(0, 0, 0, 0)
    self.Border:SetBackdropBorderColor(0, 0, 0, 1)
end

-- Create Shadow
lib.AddShadow = function(object, texture, size)
    local Shadow = CreateFrame("Frame", nil, object)
    Shadow:SetPoint("TOPLEFT", -size, size)
    Shadow:SetPoint("BOTTOMRIGHT", size, -size)
    Shadow:SetBackdrop({edgeFile = texture, edgeSize = size})
    Shadow:SetBackdropBorderColor(0, 0, 0, 0.8)
    return Shadow
end

-- HealthBar CALLBACK function
local PostUpdateHealth = function(Health, unit, min, max)
    local bDisconnected = not UnitIsConnected(unit)
    local bDead = UnitisDead(unit)
    local bGhost = UnitIsGhost(unit)

    if bDisconnected or bDead or bGhost then
        Health:SetValue(max)
    else
        Health:SetValue(min)
        if (unit == "vehicle") then
            Health:SetStatusBarColor(22/255, 106/255, 44/255)
        end
    end
end

-- PowerBar CALLBACK function
local PostUpdatePower = function(Power, unit, min, max)
    local bDisconnected = not UnitIsConnected(unit)
    local bDead = UnitIsDead(unit)
    local bGhost = UnitIsGhost(unit)

    if bDisconnected or bDead or bGhost then
        Power:SetValue(max)
    end

    -- hide target's power bar for npcs without power
    if unit == "target" then
        if (UnitIsPlayer("target")) then
            Power:Show()
            Power.Shadow:Show()
        else
            if (UnitPowerType("target") ~= 0) then
                Power:Hide()
                Power.Shadow:Hide()
            end
        end
    end
end

-- Create HealthBar Frame Function
lib.AddHealthBar = function(self)
    local hp = CreateFrame("StatusBar", nil, self)
    hp:SetStatusBarTexture(cfg.hpTex)
    hp:SetAlpha(1.0)
    hp.colorClass = true    
    hp.colorClassNPC = true
    hp.frequentUpdates = true
    
    self.Health = hp    -- bind to self.Health

    hp.bg = hp:CreateTexture(nil, "BORDER")
    hp.bg:SetAllPoints(hp)
    hp.bg:SetTexture(cfg.hpTex)
    hp.bg:SetAlpha(0.2)
    hp.bg:SetVertexColor(cfg.trdColor[1], cfg.trdColor[2], cfg.trdColor[3])
    
    if self.unitType == "raid" then
        self.Health.PostUpdate = PostUpdateHealth
    else
        self.Health.Smooth = cfg.smoothHealth
    end
end

-- Create PowerBar Frame Function
lib.AddPowerBar = function(self)
    local pp = CreateFrame("StatusBar", nil, self)
    pp:SetHeight(6)
    pp:SetStatusBarTexture(cfg.ppTex)
    pp:SetStatusBarColor(cfg.mainColor[1], cfg.mainColor[2], cfg.mainColor[3])
    pp:SetAlpha(1.0)
    pp:SetFrameLevel(14)
    
    pp.frequentUpdate = true
    
    self.Power = pp     -- bind to self.Power
    
    pp.bg = pp:CreateTexture(nil, "BORDER")
    pp.bg:SetAllPoints(pp)
    pp.bg:SetTexture(cfg.ppTex)
    pp.bg:SetAlpha(0.2)
    pp.bg:SetVertexColor(cfg.trdColor[1], cfg.trdColor[2], cfg.trdColor[3])
    
    pp.Shadow = lib.AddShadow(pp, cfg.glowTex2, 3)
    --pp.Border = CreateFrame("Frame", nil, pp)
    --pp.Border:SetPoint("TOPLEFT", pp, "TOPLEFT", -5, 5)
    --pp.Border:SetPoint("BOTTOMRIGHT", pp, "BOTTOMRIGHT", 5, -5)
    --pp.Border:SetBackdrop{edgeFile = cfg.glowTex2, edgeSize = 5, insets = {left = 3, right = 3, top = 3, bottom = 3}}
    --pp.Border:SetBackdropColor(0, 0, 0, 0)
    --pp.Border:SetBackdropBorderColor(0, 0, 0, 0.8)
    
    self.Power.PostUpdate = PostUpdatePower
    self.Power.Smooth = cfg.smoothPower
end

-- Create Portrait Frame Function
lib.AddPortrait = function(self)
    local portrait = CreateFrame("PlayerModel", nil, self)
    portrait:SetAlpha(1.0)
    
    portrait.bg = CreateFrame("Frame", nil, self)
    portrait.bg:SetPoint("TOPLEFT", portrait, "TOPLEFT", -0, 0)
    portrait.bg:SetPoint("BOTTOMRIGHT", portrait, "BOTTOMRIGHT", 0, -0)
    portrait.bg:SetBackdrop({bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], insets = {top = -1, bottom = -1, left = -1, right = -1}})
    portrait.bg:SetBackdropColor(0, 0, 0, 0.7)
    portrait.bg:SetBackdropBorderColor(0, 0, 0)
    
    self.Portrait = portrait
    
    -- attempt to hide portraits when not available
    --if (not UnitExists(self.unit) or not UnitIsConnected(self.unit) or not UnitIsVisible(self.unit)) then
    --    self.Portrait:SetAlpha(0)
    --else
    --    self.Portrait:SetAlpha(0.8)
    --end
    self.Portrait:SetAlpha(0.8)
end

-- Create Tag Text Frame Function
lib.AddTextTags = function(self)
    if self.unitType == "player" then
        local hp = GenFontString(self.Health, cfg.numbFont, cfg.numbFS * 1.6, cfg.fontF)
        hp:SetTextColor(cfg.sndColor[1], cfg.sndColor[2], cfg.sndColor[3])
        self:Tag(hp, "[viv5:hp]")
        hp:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 0)

        local perhp = GenFontString(self.Health, cfg.numbFont, cfg.numbFS, cfg.fontF)
        perhp:SetTextColor(cfg.sndColor[1], cfg.sndColor[2], cfg.sndColor[3])
        self:Tag(perhp, "[viv5:perhp]")
        perhp:SetPoint("TOPRIGHT", self.Health, "TOPRIGHT", -1, -1)

        local pp = GenFontString(self.Power, cfg.numbFont, cfg.numbFS * 0.8, cfg.fontF)
        pp:SetTextColor(cfg.sndColor[1], cfg.sndColor[2], cfg.sndColor[3])
        self:Tag(pp, "[viv5:power]")
        pp:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMLEFT", 1, 0)

        if cfg.showPlayerName then
            local name = GenFontString(self, cfg.nameFont, cfg.nameFS, cfg.fontF)
            self:Tag(name, "[viv5:afkdnd][viv5:color][viv5:shortname]")
            name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
        end

    elseif self.unitType == "target" then
        local hp = GenFontString(self.Health, cfg.numbFont, cfg.numbFS * 1.6, cfg.fontF)
        hp:SetTextColor(cfg.sndColor[1], cfg.sndColor[2], cfg.sndColor[3])
        self:Tag(hp, "[viv5:hp]")
        hp:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 0)

        local perhp = GenFontString(self.Health, cfg.numbFont, cfg.numbFS, cfg.fontF)
        perhp:SetTextColor(cfg.sndColor[1], cfg.sndColor[2], cfg.sndColor[3])
        self:Tag(perhp, "[viv5:perhp]")
        perhp:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 1, -1)

        local pp = GenFontString(self.Power, cfg.numbFont, cfg.numbFS * 0.8, cfg.fontF)
        pp:SetTextColor(cfg.sndColor[1], cfg.sndColor[2], cfg.sndColor[3])
        self:Tag(pp, "[viv5:power]")
        pp:SetPoint("BOTTOMRIGHT",self.Health, "BOTTOMRIGHT", -1, 0)

        local name = GenFontString(self, cfg.nameFont, cfg.nameFS, cfg.fontF)
        self:Tag(name, "[viv5:level][viv5:color][viv5:shortname][viv5:afkdnd]")
        name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)

    elseif self.unitType == "pet" or self.unitType == "pettarget" then
        local hp = GenFontString(self.Health, cfg.numbFont, cfg.numbFS * 0.8, cfg.fontF)
        hp:SetTextColor(cfg.sndColor[1], cfg.sndColor[2], cfg.sndColor[3])
        self:Tag(hp, "[viv5:hp]")
        hp:SetPoint("TOPRIGHT", self.Health, "TOPRIGHT", -1, -1)

        local name = GenFontString(self, cfg.nameFont, cfg.nameFS, cfg.fontF)
        self:Tag(name, "[viv5:color][viv5:shortname]")
        name:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -2)

    elseif self.unitType == "targettarget" or self.unitType == "targettargettarget" or self.unitType == "focustarget" then
        local hp = GenFontString(self.Health, cfg.numbFont, cfg.numbFS * 0.8, cfg.fontF)
        hp:SetTextColor(cfg.sndColor[1], cfg.sndColor[2], cfg.sndColor[3])
        self:Tag(hp, "[viv5:hp]")
        hp:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 1, -1)

        local name = GenFontString(self, cfg.nameFont, cfg.nameFS, cfg.fontF)
        self:Tag(name, "[viv5:color][viv5:shortname]")
        name:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -2)

    end
end

-- Create Class Bar Frame Function
lib.AddClassBar = function(self)
    if playerClass == "DEATHKNIGHT" then
        local Runes = CreateFrame("Frame")
        for i = 1, 6 do
            local Rune = CreateFrame("StatusBar", nil, self)
            Rune:SetStatusBarTexture(cfg.hpTex)
            Rune.Shadow = lib.AddShadow(Rune, cfg.glowTex2, 3)
            Rune.BG = Rune:CreateTexture(nil, "BACKGROUND")
            Rune.BG:SetAllPoints()
            Rune.BG:SetTexture(cfg.hpTex)
            Rune.BG:SetVertexColor(0.1, 0.1, 0.1)
            Runes[i] = Rune
        end
        for i = 1, 6 do
            Runes[i]:SetSize((self:GetWidth() - 15) / 6, 5)
            if i == 1 then
                Runes[i]:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)
            else
                Runes[i]:SetPoint("LEFT", Runes[i - 1], "RIGHT", 3, 0)
            end
        end
        self.Runes = Runes
    end

    if playerClass == "PALADIN" then
        local HolyPower = CreateFrame("Frame")
        for i = 1, 3 do
            local HolyShard = CreateFrame("StatusBar", nil, self)
            HolyShard:SetStatusBarTexture(cfg.hpTex)
            HolyShard:SetStatusBarColor(0.9, 0.95, 0.33)        
            HolyShard.Shadow = lib.AddShadow(HolyShard, cfg.glowTex2, 3)
            HolyPower[i] = HolyShard
        end
        for i = 1, 3 do
            HolyPower[i]:SetSize((self:GetWidth() - 6) / 3, 5)
            if i == 1 then
                HolyPower[i]:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)
            else
                HolyPower[i]:SetPoint("LEFT", HolyPower[i - 1], "RIGHT", 3, 0)
            end
        end
        self.HolyPower = HolyPower
        self.HolyPower.Override = function(self, event, unit, powerType)
            if self.unit ~= unit or (powerType and powerType ~= "HOLY_POWER")then return end
            for i = 1, MAX_HOLY_POWER do
                if i <= UnitPower(unit, SPELL_POWER_HOLY_POWER) then
                    self.HolyPower[i]:SetAlpha(1)
                else
                    self.HolyPower[i]:SetAlpha(0.3)
                end
            end
        end
    end

    if playerClass == "WARLOCK" then
        local SoulShards = CreateFrame("Frame")
        for i = 1, 3 do
            local SoulShard = CreateFrame("StatusBar", nil, self)
            SoulShard:SetStatusBarTexture(cfg.hpTex)
            SoulShard:SetStatusBarColor(0.44, 0.35, 1)
            SoulShard.Shadow = lib.AddShadow(SoulShard, cfg.glowTex2, 3)
            SoulShards[i] = SoulShard
        end
        for i = 1, 3 do
            SoulShards[i]:SetSize((self:GetWidth() - 6) / 3, 5)
            if i == 1 then
                SoulShards[i]:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)
            else
                SoulShards[i]:SetPoint("LEFT", SoulShards[i-1], "RIGHT", 3, 0)
            end
        end
        self.SoulShards = SoulShards
        self.SoulShards.Override = function(self, event, unit, powerType)
            if self.unit ~= unit or (powerType and powerType ~= "SOUL_SHARDS") then return end
            for i = 1, SHARD_BAR_NUM_SHARDS do
                if i <= UnitPower(unit, SPELL_POWER_SOUL_SHARDS) then
                    self.SoulShards[i]:SetAlpha(1)
                else
                    self.SoulShards[i]:SetAlpha(0.3)
                end
            end
        end
    end

    if playerClass == "DRUID" then
        local EclipseBar = CreateFrame("Frame", nil, self)
        EclipseBar:SetSize(self:GetWidth(), 5)
        EclipseBar:SetPoint("TOP", self, "BOTTOM", 0, -4)
        EclipseBar.Shadow = lib.AddShadow(EclipseBar, cfg.glowTex2, 3)
        EclipseBar.BG = EclipseBar:CreateTexture(nil, "BACKGROUND")
        EclipseBar.BG:SetTexture(cfg.hpTex)
        EclipseBar.BG:SetVertexColor(1, 1, 0.13)
        EclipseBar.BG:SetAllPoints()
        EclipseBar.LunarBar = CreateFrame("StatusBar", nil, EclipseBar)
        EclipseBar.LunarBar:SetStatusBarTexture(cfg.hpTex)
        EclipseBar.LunarBar:SetStatusBarColor(0, 0.1, 0.7)
        EclipseBar.LunarBar:SetAllPoints()
        EclipseBar.Text = S.MakeFontString(EclipseBar, 9)
        EclipseBar.Text:SetPoint("LEFT", EclipseBar.LunarBar:GetStatusBarTexture(), "RIGHT", -1, 0)
        self:Tag(EclipseBar.Text, "[pereclipse]")
        self.EclipseBar = EclipseBar
    end

    if playerClass == "SHAMAN" then
        local Totems = CreateFrame("Frame", nil, self)
        for i = 1, 4 do
            local Totem = CreateFrame("StatusBar", nil, self)
            Totem:SetStatusBarTexture(cfg.hpTex)
            Totem:SetStatusBarColor(unpack(oUF.colors.totems[i]))
            Totem.BG = Totem:CreateTexture(nil, "BACKGROUND")
            Totem.BG:SetAllPoints()
            Totem.BG:SetTexture(cfg.hpTex)
            Totem.BG:SetVertexColor(0.1, 0.1, 0.1)    
            Totem.Shadow = lib.AddShadow(Totem, cfg.glowTex2, 3)
            Totems[i] = Totem
        end
        for i = 1, 4 do
            Totems[i]:SetSize((self:GetWidth() - 9 ) / 4, 5)
            if i == 1 then
                Totems[i]:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)
            else
                Totems[i]:SetPoint("LEFT", Totems[i - 1], "RIGHT", 3, 0)
            end    
        end
        self.Totems = Totems
        self.Totems.PostUpdate = function(self, slot, haveTotem, name, start, duration)
            local Totem = self[slot]
            Totem:SetMinMaxValues(0, duration)
            Totem:SetScript("OnUpdate", haveTotem and function(self) self:SetValue(GetTotemTimeLeft(slot)) end or nil)
        end
    end

    if playerClass == "ROGUE" or playerClass == "DRUID" then    
        local CPoints = CreateFrame("Frame", nil, self)    
        for i = 1, MAX_COMBO_POINTS do
            local CPoint = CreateFrame("StatusBar", nil, self)
            CPoint:SetStatusBarTexture(cfg.hpTex)
            CPoint:SetStatusBarColor(1, 0.9, 0)                
            CPoint.Shadow = lib.AddShadow(CPoint, cfg.glowTex2, 3)
            CPoints[i] = CPoint
        end
        for i = 1, 5 do
            CPoints[i]:SetSize((self:GetWidth() / 5) - 5, 5)
            if i == 1 then
                CPoints[i]:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)
            else
                CPoints[i]:SetPoint("LEFT", CPoints[i - 1], "RIGHT", 6, 0)
            end
        end
        self.CPoints = CPoints
        self.CPoints.unit = "player"
    end
end



-- hand the lib to the namespace for further usage...this is awesome because you can reuse functions in any of your layout files
ns.lib = lib
