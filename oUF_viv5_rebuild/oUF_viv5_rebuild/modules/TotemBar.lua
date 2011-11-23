--[[
	oUF_boring_totembar
	-tecu
	
	notes:
		oUF_TotemBar by Arthur Guerard didn't work for me so this is my 
		attempt to make my own.  i did not copy his code, but i did make an 
		effort for the functionality to be similar to his mod as well as the 
		default oUF runebar.  
		
	features:
		the following features are supported.  all are optional except:
		
		.TotemBar[x], which must be a frame.  
		.TotemBar itself can be a frame or table, so long as the index x, 
			which will be an integer in the range [1,4], points to a frame.
		
		.TotemBar.Destroy
			-- bool: if true will enable right-click totem destruction
		.TotemBar.UpdateColors
			-- bool: if true, will color .StatusBar and .bg
		.TotemBar.AbbreviateNames
			-- bool: if true, the totem name in the .Text element will be 
			-- abbreviated, e.g. 'Totem of Wrath' -> 'ToW'
		
		.TotemBar[x]
			-- frame: frame for totem x
		.TotemBar[x].StatusBar
			-- statusbar: statusbar for totem x
		.TotemBar[x].StatusBar.Reverse
			-- bool: if true, .StatusBar will fill as time runs out instead 
			-- of deplete
		.TotemBar[x].Icon
			-- texture: icon texture for totem x
		.TotemBar[x].Time
			-- font string: time left of totem x
		.TotemBar[x].Text
			-- font string: name of totem x
		.TotemBar[x].bg
			-- texture: will be colored if present
		.TotemBar[x].bg.multiplier
			-- number:0-1: multiplier for the bg color
	
	(a really ugly) example:
		-- w and h are locals that describe the width and height of the unit frame
		if unit == "player" and class == "SHAMAN" then
			local width = (w + 4) / 4 - 4
			local height = width + 8
		
			local TotemBar = CreateFrame("Frame", nil, self)
			TotemBar:SetPoint("TOP", self, "BOTTOM", 0, -4)
			TotemBar:SetWidth(w)
			TotemBar:SetHeight(height)
		
			TotemBar.Destroy = true
			TotemBar.UpdateColors = true
			TotemBar.AbbreviateNames = true
		
			for i = 1, 4 do
				local t = CreateFrame("Frame", nil, TotemBar)
				t:SetPoint("LEFT", (i - 1) * (width + 4), 0)
				t:SetWidth(width)
				t:SetHeight(height)
			
				local bar = CreateFrame("StatusBar", nil, t)
				bar:SetWidth(width)
				bar:SetPoint"BOTTOM"
				bar:SetHeight(8)
				t.StatusBar = bar
			
				local icon = t:CreateTexture(nil, "ARTWORK")
				icon:SetPoint"TOP"
				icon:SetWidth(width)
				icon:SetHeight(width)
				icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
				t.Icon = icon
			
				local time = t:CreateFontString(nil, "OVERLAY")
				time:SetPoint("BOTTOM", 0, 12)
				time:SetFontObject"GameFontNormal"
				t.Time = time
			
				local text = t:CreateFontString(nil, "OVERLAY")
				text:SetPoint("TOP", t, "BOTTOM", 0, -4)
				text:SetFontObject"GameFontNormal"
				t.Text = text
			
			
				t.bg = t:CreateTexture(nil, "BACKGROUND")
				t.bg:SetAllPoints()
				t.bg:SetTexture(1, 1, 1)
				t.bg.multiplier = 0.2
			
				TotemBar[i] = t
			end
			self.TotemBar = TotemBar
		end
]]


if select(2, UnitClass'player') ~= 'SHAMAN' then return end
if not oUF then print'oUF_boring_totembar: error: oUF not found' return end


-- these globals are used in OnUpdate
local GetTotemTimeLeft = GetTotemTimeLeft
local SecondsToTimeAbbrev = SecondsToTimeAbbrev
-- this one isn't but whatever
local GetTotemInfo = GetTotemInfo


-- default totem colors
-- from Interface/BUTTONS/UI-TotemBar.blp
oUF.colors.totems = {
	{ 181/255, 073/255, 033/255 }, -- fire
	{ 074/255, 142/255, 041/255 }, -- earth
	{ 057/255, 146/255, 181/255 }, -- water
	{ 132/255, 056/255, 231/255 }  -- air
}


-- wtf
local priorities = SHAMAN_TOTEM_PRIORITIES
local map = {}
for k, v in pairs(priorities) do
	map[v] = k
end 


-- totem name abbreviations
local abbrev = setmetatable({}, { __index = function(t, k)
	if k then
		local str = string.gsub(k, '(%w)%w*%s*', '%1')
		rawset(t, k, str)
		return str
	end
end })


-- on_click if .Destroy is true
local on_click = function(self)
	if IsShiftKeyDown() then
		for i = 1, 4 do DestroyTotem(i) end
	else
		DestroyTotem(self.__slot)
	end
end


-- on_update for totem frames
-- default UI shows/hides buttons based on PLAYER_TOTEM_UPDATE, OnUpdate should
-- only need to update the display.
local HOLD = 0.2
local on_update = function(self, elapsed)
	self.__waited = self.__waited + elapsed
	if self.__waited >= HOLD then
		local timeleft = GetTotemTimeLeft(self.__slot)
		if timeleft then
			if self.StatusBar then
				self.StatusBar:SetValue(self.StatusBar.__reverse * timeleft)
			end
			if self.Time then
				self.Time:SetFormattedText(SecondsToTimeAbbrev(timeleft))
			end
		else
			if self.StatusBar then
				self.StatusBar:SetValue(0)
			end
			if self.Time then
				self.Time:SetText''
			end
		end
		self.__waited = 0
	end
end


-- event:
-- PLAYER_TOTEM_UPDATE
local PLAYER_TOTEM_UPDATE = function(self, event, slot)
	local tb = self.TotemBar
	local totem = tb[ map[slot] ]
	local dongs, name, start, duration, icon = GetTotemInfo(slot)
	
	if duration > 0 then
		local c = self.colors.totems[slot]
		local r, g, b = c[1], c[2], c[3]
		local start_updating = false
		
		totem.__waited = HOLD
		
		if tb.UpdateColors and totem.bg then
			local mu = totem.bg.multiplier or 1
			totem.bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
		
		if totem.StatusBar then
			if totem.StatusBar.Reverse then
				totem.StatusBar:SetMinMaxValues(-duration, 0)
			else
				totem.StatusBar:SetMinMaxValues(0, duration)
			end
			if tb.UpdateColors then
				totem.StatusBar:SetStatusBarColor(r, g, b)
			end
			start_updating = true
		end
		
		if totem.Icon then
			totem.Icon:SetTexture(icon)
		end
		
		if totem.Time then
			totem.Time:SetFormattedText(SecondsToTimeAbbrev(duration))
			start_updating = true
		end
		
		if totem.Text then
			if tb.AbbreviateNames then
				totem.Text:SetText(abbrev[name])
			else
				totem.Text:SetText(name)
			end
		end
		
		if start_updating then
			totem:SetScript('OnUpdate', on_update)
		end
		totem:Show()
	else
		totem:SetScript('OnUpdate', nil)
		totem:Hide()
	end
end


-- update
local update = function(self, event)
	local tb = self.TotemBar
	if tb then
		for i = 1, 4 do
			PLAYER_TOTEM_UPDATE(self, event, i)
		end
	end
end


-- enable
local enable = function(self, unit)
	if self.unit ~= unit or unit ~= 'player' then return end
	
	local tb = self.TotemBar
	if tb then
		for i = 1, 4 do
			local totem = tb[i]
			local slot = priorities[i]
			
			totem.__slot = slot
			
			-- set up statusbar
			local bar = totem.StatusBar
			if bar then 
				if not bar:GetStatusBarTexture() then
					bar:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
				end
				if bar.Reverse then
					bar.__reverse = -1
				else
					bar.__reverse = 1
				end
			end
			
			-- check if we want to destroy on right click:
			if tb.Destroy then
				local butt = CreateFrame('Button', nil, totem)
				butt:SetAllPoints(totem)
				butt:RegisterForClicks'RightButtonUp'
				butt:SetScript('OnClick', on_click)
				butt.__slot = slot
			end
			
			totem:Hide()
		end
		self:RegisterEvent('PLAYER_TOTEM_UPDATE', PLAYER_TOTEM_UPDATE)
		
		-- whoops
		return true
	end
end


-- disable
local disable = function(self)
	if self.TotemBar then
		self:UnregisterEvent('PLAYER_TOTEM_UPDATE', PLAYER_TOTEM_UPDATE)
	end
end

oUF:AddElement('TotemBar', update, enable, disable)
