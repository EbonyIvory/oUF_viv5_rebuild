-----------------------------
-- |oUF_viv5
-- |rebuild by Celsuis
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

UIDropDownMenu_Initialize(dropdown, function(self)
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
end, "MENU")

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
            Power.Border:Show()
        else
            if (UnitPowerType("target") ~= 0) then
                Power:Hide()
                Power.Border:Hide()
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
    
    pp.Border = CreateFrame("Frame", nil, pp)
    pp.Border:SetPoint("TOPLEFT", pp, "TOPLEFT", -5, 5)
    pp.Border:SetPoint("BOTTOMRIGHT", pp, "BOTTOMRIGHT", 5, -5)
    pp.Border:SetBackdrop{edgeFile = cfg.glowTex2, edgeSize = 5, insets = {left = 3, right = 3, top = 3, bottom = 3}}
    pp.Border:SetBackdropColor(0, 0, 0, 0.8)
    pp.Border:SetBackdropBorderColor(0, 0, 0)
    
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

-- Create Glow Frame Function
lib.AddBorder = function(self)
    self.Border = CreateFrame("Frame", nil, self)
    self.Border:SetPoint("TOPLEFT", self, "TOPLEFT", -5, 5)
    self.Border:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 5, -5)
    self.Border:SetBackdrop({edgeFile = cfg.glowTex2, edgeSize = 5, insets = {left = 3, right = 3, top = 3, bottom = 3}})
    self.Border:SetBackdropColor(0, 0, 0, 0.8)
    self.Border:SetBackdropBorderColor(0, 0, 0)
end

lib.AddTextTags = function(self)
    local hp = GenFontString(self.Health, cfg.numbFont, cfg.numbFS * 1.6, cfg.fontF)
    hp:SetTextColor(cfg.sndColor[1], cfg.sndColor[2], cfg.sndColor[3])
    self:Tag(hp, "[viv5:hp]")

    local perhp = GenFontString(self.Health, cfg.numbFont, cfg.numbFS, cfg.fontF)
    perhp:SetTextColor(cfg.sndColor[1], cfg.sndColor[2], cfg.sndColor[3])
    self:Tag(perhp, "[viv5:perhp]")

    local pp = GenFontString(self.Power, cfg.numbFont, cfg.numbFS * 0.8, cfg.fontF)
    pp:SetTextColor(cfg.sndColor[1], cfg.sndColor[2], cfg.sndColor[3])
    self:Tag(pp, "[viv5:power]")

    local name = GenFontString(self, cfg.nameFont, cfg.nameFS, cfg.fontF)
    self:Tag(name, "[viv5:afkdnd][viv5:color][viv5:shortname]")

    if self.unitType == "player" then
        hp:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 0)
        perhp:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 1, -1)
        pp:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMLEFT", 1, 0)
        name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
    end
end


--hand the lib to the namespace for further usage...this is awesome because you can reuse functions in any of your layout files
ns.lib = lib
