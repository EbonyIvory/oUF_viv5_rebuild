-----------------------------
-- |oUF_viv5
-- |rebuild by EbonyIvory
-----------------------------

local addon, ns = ...
local cfg = ns.cfg

-----------------------------
-- TAGS
-----------------------------

local CoolNumber = function(num)
    if num >= 1e6 then
        return ("%.1fm"):format(num / 1e6)
    elseif num >= 1e3 then
        return ("%.1fk"):format(num / 1e3)
    else
        return ("%d"):format(num)
    end
end


local ColorHex = function(r, g, b)
    if r then
        if (type(r) == 'table') then
            if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
        end
        return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
    end
end

local Utf8Sub = function(string, i, dots)
    local bytes = string:len()
    if (bytes <= i) then
        return string
    else
        local len, pos = 0, 1
        while(pos <= bytes) do
            -- len = len + 1
            local c = string:byte(pos)
            if (c > 0 and c <= 127) then
                pos = pos + 1
                len = len + 1
            elseif (c >= 192 and c <= 223) then
                pos = pos + 2
                len = len + 1
            elseif (c >= 224 and c <= 239) then
                pos = pos + 3
                len = len + 2
            elseif (c >= 240 and c <= 247) then
                pos = pos + 4
                len = len + 2
            end
            if (len >= i * 2 -1) then break end
        end

        if (len >= i * 2 - 1 and pos <= bytes) then
            return string:sub(1, pos - 1)..(dots and '...' or '')
        else
            return string
        end
    end
end


oUF.Tags["viv5:shortname"] = function(unit)
    local name = UnitName(unit)
    return Utf8Sub(name, 6, true)
end
oUF.TagEvents["viv5:shortname"] = 'UNIT_NAME_UPDATE'

oUF.Tags["viv5:hp"] = function(unit) 
    if UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) then
        return oUF.Tags["viv5:DDG"](unit)
    else
        local min, max = UnitHealth(unit), UnitHealthMax(unit)
        
        if min~=max then 
            return "|cFFFFAAAA"..CoolNumber(min).."|r/"..CoolNumber(max)
        else
            return CoolNumber(max)
        end
    end
end
oUF.TagEvents["viv5:hp"] = "UNIT_HEALTH"


oUF.Tags["viv5:perhp"] = function(unit)
    local per = oUF.Tags["perhp"](unit).."%" or 0
    local min, max = UnitHealth(unit), UnitHealthMax(unit)
    if min == max then
        per = ""
    end
    return per
end
oUF.TagEvents["viv5:perhp"] = "UNIT_HEALTH"


oUF.Tags["viv5:raidhp"]  = function(unit) 
    if UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) then
        return oUF.Tags["viv5:DDG"](unit)
    else
        local per = oUF.Tags["perhp"](unit).."%" or 0
        return per
    end
end
oUF.TagEvents["viv5:raidhp"] = "UNIT_HEALTH"


oUF.Tags["viv5:color"] = function(unit, r)
    local _, class = UnitClass(unit)
    local reaction = UnitReaction(unit, "player")
    
    if UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) then
        return "|cffA0A0A0"
    elseif (UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) then
        return ColorHex(oUF.colors.tapped)
    elseif (UnitIsPlayer(unit)) then
        return ColorHex(oUF.colors.class[class])
    elseif reaction then
        return ColorHex(oUF.colors.reaction[reaction])
    else
        return ColorHex(1, 1, 1)
    end
end
oUF.TagEvents["viv5:color"] = "UNIT_REACTION UNIT_HEALTH UNIT_HAPPINESS"


oUF.Tags["viv5:afkdnd"] = function(unit) 
    return UnitIsAFK(unit) and "|cffCFCFCF <afk>|r" or UnitIsDND(unit) and "|cffCFCFCF <dnd>|r" or ""
end
oUF.TagEvents["viv5:afkdnd"] = "PLAYER_FLAGS_CHANGED"


oUF.Tags["viv5:DDG"] = function(unit)
    if UnitIsDead(unit) then
        return "|cffCFCFCF Dead|r"
    elseif UnitIsGhost(unit) then
        return "|cffCFCFCF Ghost|r"
    elseif not UnitIsConnected(unit) then
        return "|cffCFCFCF Offline|r"
    end
end
oUF.TagEvents["viv5:DDG"] = "UNIT_HEALTH"


oUF.Tags["viv5:power"]  = function(unit) 
    --local min, max = UnitPower(unit), UnitPowerMax(unit)
    --if min~=max then 
    --    return CoolNumber(min).."/"..CoolNumber(max)
    --else
    --    return CoolNumber(max)
    --end
    local min = UnitPower(unit)
    return CoolNumber(min)
end
oUF.TagEvents["viv5:power"] = "UNIT_POWER UNIT_MAXPOWER"


-- ComboPoints
oUF.Tags["viv5:cp"] = function(unit)
    local cp, str        
    if(UnitExists'vehicle') then
        cp = GetComboPoints('vehicle', 'target')
    else
        cp = GetComboPoints('player', 'target')
    end

    if (cp == 1) then
        str = string.format("|cff69e80c%d|r",cp)
    elseif cp == 2 then
        str = string.format("|cffb2e80c%d|r",cp)
    elseif cp == 3 then
        str = string.format("|cffffd800%d|r",cp) 
    elseif cp == 4 then
        str = string.format("|cffffba00%d|r",cp) 
    elseif cp == 5 then
        str = string.format("|cfff10b0b%d|r",cp)
    end
    
    return str
end
oUF.TagEvents["viv5:cp"] = "UNIT_COMBO_POINTS PLAYER_TARGET_CHANGED"


-- Deadly Poison Tracker
function hasUnitDebuff(unit, name)
    local _, _, _, count, _, _, _, caster = UnitDebuff(unit, name)
    if (count and caster == 'player') then return count end
end

oUF.Tags["viv5:dp"] = function(unit)

    local Spell = "Deadly Poison" or GetSpellInfo(43233)
    local ct = hasUnitDebuff(unit, Spell)
    local cp = GetComboPoints('player', 'target')
    
    if cp > 0 then
        if (not ct) then
            str = ""
        elseif (ct == 1) then
            str = string.format("|cffc1e79f%d|r",ct)
        elseif ct == 2 then
            str = string.format("|cfface678%d|r",ct)
        elseif ct == 3 then
            str = string.format("|cff9de65c%d|r",ct) 
        elseif ct == 4 then
            str = string.format("|cff8be739%d|r",ct) 
        elseif ct == 5 then
            str = string.format("|cff90ff00%d|r",ct)
        end
    else
        str = ""
    end
    
    return str
end
oUF.TagEvents["viv5:dp"] = "UNIT_COMBO_POINTS PLAYER_TARGET_CHANGED UNIT_AURA"


-- Level
oUF.Tags["viv5:level"] = function(unit)
    
    local c = UnitClassification(unit)
    local l = UnitLevel(unit)
    local d = GetQuestDifficultyColor(l)
    
    local str = l
        
    if l <= 0 then l = "??" end
    
    if c == "worldboss" then
        str = string.format("|cff%02x%02x%02xBoss|r ",250,20,0)
    elseif c == "eliterare" then
        str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR+|r ",d.r*255,d.g*255,d.b*255,l)
    elseif c == "elite" then
        str = string.format("|cff%02x%02x%02x%s+|r ",d.r*255,d.g*255,d.b*255,l)
    elseif c == "rare" then
        str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r ",d.r*255,d.g*255,d.b*255,l)
    else
        if not UnitIsConnected(unit) then
            str = "??"
        else
            if UnitIsPlayer(unit) then
                str = string.format("|cff%02x%02x%02x%s|r ",d.r*255,d.g*255,d.b*255,l)
            elseif UnitPlayerControlled(unit) then
                str = string.format("|cff%02x%02x%02x%s|r ",d.r*255,d.g*255,d.b*255,l)
            else
                str = string.format("|cff%02x%02x%02x%s|r ",d.r*255,d.g*255,d.b*255,l)
            end
        end        
    end
    
    return str
end
oUF.TagEvents["viv5:level"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"
