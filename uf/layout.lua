
--[[-------------------------------------------------------------------------
  Trond A Ekseth grants anyone the right to use this work for any purpose,
  without any conditions, unless such conditions are required by law.
---------------------------------------------------------------------------]]

local name, addon = ...

local _, CLASS = UnitClass'player'
local TEXTURE = [[Interface\AddOns\lovelyui\art\statusbar.tga]]
local BACKDROP = {
	bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
	tiled = false,
	insets = {left = -1, right = -1, top = -1, bottom = -1}
}
local noop = function() return end
local x

local HealthThresholds = {
	WARLOCK = .2,
	ROGUE = .35,
}

do
	local pcolor = oUF.colors.power
	pcolor.MANA[1], pcolor.MANA[2], pcolor.MANA[3] = 0, .3, 1
	pcolor.RUNIC_POWER[1], pcolor.RUNIC_POWER[2], pcolor.RUNIC_POWER[3] = .8, 0, 1

	local rcolor = oUF.colors.reaction
	rcolor[1][1], rcolor[1][2], rcolor[1][3] = 1, .2, .2 -- Hated
	rcolor[2][1], rcolor[2][2], rcolor[2][3] = 1, .2, .2 -- Hostile
	rcolor[3][1], rcolor[3][2], rcolor[3][3] = 1, .6, .2 -- Unfriendly
	rcolor[4][1], rcolor[4][2], rcolor[4][3] = 1, .8, .1 -- Neutral
	rcolor[5][1], rcolor[5][2], rcolor[5][3] = .4, 1, .2 -- Friendly
	rcolor[6][1], rcolor[6][2], rcolor[6][3] = .4, 1, .3 -- Honored
	rcolor[7][1], rcolor[7][2], rcolor[7][3] = .3, 1, .4 -- Revered
	rcolor[8][1], rcolor[8][2], rcolor[8][3] = .3, 1, .5 -- Exalted
end

local updateName = function(self, event, unit)
	if(self.unit == unit) then
		local r, g, b, t
		if UnitIsTapDenied(unit) or not UnitIsConnected(unit) then
			r, g, b = .6, .6, .6
		elseif(UnitIsPlayer(unit)) then
			local _, class = UnitClass(unit)
			t = self.colors.class[class]
		else
			t = self.colors.reaction[UnitReaction(unit, 'player')]
		end

		if(t) then
			r, g, b = t[1], t[2], t[3]
		end

		if(r) then
			self.Name:SetTextColor(r, g, b)
		end
	end
end

local death = function(parent, unit, show, ghost)
	if not UnitIsUnit(unit, 'target') or not parent.Dead then return end
	if show then
		for _, v in pairs({parent.Health, parent.Power, parent.Background}) do v:Hide() end
		parent.Dead:Show()
	else
		for _, v in pairs({parent.Health, parent.Power, parent.Background}) do v:Show() end
		parent.Dead:Hide()
	end
	if ghost then
		parent.Dead.icon:SetTexture[[Interface\Icons\spell_holy_guardianspirit]]
	else
		parent.Dead.icon:SetTexture[[Interface\Icons\ability_creature_cursed_02]]
	end
end

local PostUpdateHealth = function(Health, unit, min, max)
	if(UnitIsDead(unit)) then
		death(Health:GetParent(), unit, true, false)
		Health:SetValue(0)
	elseif(UnitIsGhost(unit)) then
		death(Health:GetParent(), unit, true, true)
		Health:SetValue(0)
	else
		death(Health:GetParent(), unit, false, false)
	end

	return updateName(Health:GetParent(), 'PostUpdateHealth', unit)
end

local PostCastStart = function(Castbar, unit, spell, spellrank)
	Castbar:GetParent().Name:SetText('×' .. spell)
	if Castbar.text then Castbar.text:SetText('— '..spell) end
	local v  = Castbar:GetParent().Health.value
	local _, _, _, _, x2 = v:GetParent():GetPoint()
	if unit:sub(1, 6) == 'player' and not InCombatLockdown() then
		local f  = CreateFrame'Frame'
		f:SetScript('OnUpdate', function()
			local _, _, _, _, x3 = v:GetPoint()
			if x3 <= (x[5] + 22) then
				v:ClearAllPoints()
				v:SetPoint(x[1], x[2], x[4], x3 + 2)
				f:RegisterEvent'PLAYER_REGEN_DISABLED'
				f:SetScript('OnEvent', function()
					v:ClearAllPoints()
					v:SetPoint(x[1], x[2], x[4], x[5])
					f:UnregisterAllEvents()
				end)
			else
				f:SetScript('OnUpdate', nil)
			end
		end)
	end
end

local PostCastStop = function(Castbar, unit)
	local name
	local frame = Castbar:GetParent().Name
	if unit:sub(1, 4) == 'boss' then
		-- And people complain about Lua's lack for full regexp support.
		name = UnitName(unit):gsub('(%u)%S* %l*%s*', '%1 ')
	else
		name = UnitName(unit)
	end
	frame:SetText(name)

	if Castbar.text then Castbar.text:SetText'' end

		-- sliding animation
	local active = false
	local offset = -18
	local slideGroup = frame:CreateAnimationGroup'SlidingFrame'

	local slide = slideGroup:CreateAnimation'Translation'
	slide:SetDuration(.22)
	slide:SetOffset(offset, 0)
	slide:SetSmoothing'OUT'
	slide:SetScript('OnPlay', function()
		frame:ClearAllPoints()
		frame:SetPoint('LEFT', Castbar:GetParent(), 'RIGHT', 45, 7)
 	end)
	slide:SetScript('OnFinished', function()
		active = false
		frame:ClearAllPoints()
		frame:SetPoint('LEFT', Castbar:GetParent(), 'RIGHT', 25, 7)
		slideGroup:Stop()
	end)

	local fade = slideGroup:CreateAnimation'Alpha'
	fade:SetFromAlpha(0)
	fade:SetToAlpha(1)
    fade:SetDuration(.5)
    fade:SetSmoothing'OUT'

	if not active then
		active = true
		slideGroup:Play()
	end

	local v  = Castbar:GetParent().Health.value
	local _, _, _, _, x2 = v:GetParent():GetPoint()
	if unit:sub(1, 6) == 'player' and math.floor(x2 + .5) == 155 then
		local f  = CreateFrame'Frame'
		f:SetScript('OnUpdate', function()
			local _, _, _, _, x3 = v:GetPoint()
			if x3 >= x[5] then
				v:ClearAllPoints()
				v:SetPoint(x[1], x[2], x[3], x[4], x3 - 2)
			else
				f:SetScript('OnUpdate', nil)
			end
		end)
	end
end

local PostCastStopUpdate = function(self, event, unit)
	if(unit ~= self.unit) then return end
	return PostCastStop(self.Castbar, unit)
end

local auraElement = { target = 'Debuffs' }

local PostCreateIcon = function(element, icon)
	icon.name = icon:CreateFontString(nil, 'OVERLAY')
	icon.name:SetPoint'LEFT'
	icon.name:SetFont('Fonts\\ARIALN.ttf', 11)
	icon.name:SetTextColor(1, 1, 1)
	icon.name:SetShadowOffset(1, -1)
	icon.name:SetShadowColor(0, 0, 0, 1)
	icon.name:SetJustifyH'LEFT'

	icon.icon:SetTexCoord(.1, .9, .1, .9)

	icon.duration = icon:CreateFontString(nil, 'OVERLAY')
	icon.duration:SetPoint('RIGHT', icon.name, 'LEFT', -2, 0)
	icon.duration:SetFont('Fonts\\ARIALN.ttf', 9)
	icon.duration:SetTextColor(1, 1, 1)
	icon.duration:SetShadowOffset(1, -1)
	icon.duration:SetShadowColor(0, 0, 0, 1)
	icon.duration:SetJustifyH'LEFT'

	icon.count:ClearAllPoints()
	icon.count:SetPoint('LEFT', icon.name, 'RIGHT', 6, 0)
	icon.count:SetFont('Fonts\\ARIALN.ttf', 11)
	icon.count:SetTextColor(1, 1, 1)
	icon.count:SetShadowOffset(1, -1)
	icon.count:SetShadowColor(0, 0, 0, 1)
end

local auratime_OnUpdate = function(icon, elapsed, name)
	local t = icon.timeLeft - elapsed
	icon.duration:SetFormattedText(SecondsToTimeAbbrev(t))
	icon.timeLeft = t
end

local PostUpdateIcon = function(icons, unit, icon, index, offset, filter, isDebuff)
	local name, _, _, count, dtype, duration, expirationTime = UnitAura(unit, index, icon.filter)

	if name then icon.name:SetText('— '..name) end

	icon.icon:SetAlpha(0)

	if count > 0 then
		local number = icon.count:GetText()
		if number then icon.count:SetText('— '..number) end
	end

	if duration > 0 and duration < 330 then
		icon.timeLeft = expirationTime - GetTime()
		icon:SetScript('OnUpdate', function(self, elapsed)
			auratime_OnUpdate(self, elapsed, name)
		end)
	else
		icon:SetScript('OnUpdate', nil)
		icon.name:SetText('— '..name)
	end

	if icon.filter == 'HARMFUL' then
		local colour = DebuffTypeColor[debuffType or 'none']
		icon.name:SetTextColor(colour.r*1.4, colour.g*1.4, colour.b*1.4)
		icon.duration:SetTextColor(colour.r*1.4, colour.g*1.4, colour.b*1.4)
	elseif UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		local colour = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
		icon.name:SetTextColor(colour.r, colour.g, colour.b)
		icon.duration:SetTextColor(colour.r, colour.g, colour.b)
	else
		bar:SetStatusBarColor(1, .2, .2)
	end
end

local PostUpdateGapIcon = function(Auras, unit, icon, visibleBuffs)
	if  Auras.currentGap then
		Auras.currentGap.Border:Show()
	end

	icon.Border:Hide()
	Auras.currentGap = icon
end

local PostUpdatePower = function(Power, unit, min, max)
	if unit == 'party' then print'lol' return end
	local frame = Power:GetParent()
	if(
		min == 0 or max == 0 or not UnitIsConnected(unit) or
		UnitIsDead(unit) or UnitIsGhost(unit)
	) then
		Power:Hide()
		frame:SetHeight(6)
	else
		Power:Show()
		frame:SetHeight(15)
	end
end

local RAID_TARGET_UPDATE = function(self, event)
	local index = GetRaidTargetIndex(self.unit)
	if  index then
		self.RIcon:SetText(ICON_LIST[index]..'23|t')
		if self.Leader and self.Leader:IsShown() then self.Leader:Hide() end
	else
		self.RIcon:SetText()
		if self.Leader and UnitIsGroupLeader(self.unit) then self.Leader:Show() end
	end
end

local AddAuraElement = function(frame, unit, isSingle)
	local auraElementForUnit = auraElement[unit]
	local BUFF_HEIGHT = 16
	local BUFF_SPACING = 1
	local MAX_NUM_BUFFS = 10
	if auraElementForUnit then
		local Auras = CreateFrame('Frame', nil, frame)
		Auras:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOM', -180, 280)
		Auras:SetWidth(BUFF_HEIGHT + BUFF_SPACING)
		Auras:SetHeight(1)

		Auras['initialAnchor'] = 'BOTTOMLEFT'
		Auras['growth-y'] = 'UP'
		Auras['spacing-y'] = BUFF_SPACING
		Auras['num'] = MAX_NUM_BUFFS
		Auras['size'] = BUFF_HEIGHT

		Auras.disableCooldown = true

		Auras.PostCreateIcon = PostCreateIcon
		Auras.PostUpdateIcon = PostUpdateIcon
		Auras.CustomFilter = addon.CustomAuraFilter[unit]

		Auras:RegisterEvent'PLAYER_REGEN_DISABLED'
		Auras:RegisterEvent'PLAYER_REGEN_ENABLED'
		Auras:SetScript('OnEvent', function(self, event)
			if event == 'PLAYER_REGEN_DISABLED' then
				Auras:ClearAllPoints()
				Auras:SetPoint('CENTER', _G['lovelyui_container'], -180, 5)
			else
				Auras:ClearAllPoints()
				Auras:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOM', -180, 280)
			end
		end)

		frame[auraElementForUnit] = Auras
	end
end

local Shared = function(self, unit, isSingle)
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self:RegisterForClicks'AnyUp'

	local name = self:CreateFontString(nil, 'OVERLAY')
	name:SetPoint('LEFT', self, 'RIGHT', 18, 8)
	name:SetJustifyH'LEFT'
	name:SetFont('Fonts\\skurri.ttf', 14)
	name:SetShadowOffset(1, -1.25)
	name:SetShadowColor(0, 0, 0, 1)
	name:SetTextColor(1, 1, 1)

	self.Name = name

	local Health = CreateFrame('StatusBar', nil, self)
	Health:SetHeight(6)
	Health:SetStatusBarTexture(TEXTURE)
	Health:SetStatusBarColor(.25, .25, .25)

	Health.frequentUpdates = true
	Health.colorTapping = true
	Health.colorClass = true
	Health.colorReaction = true

	Health:SetPoint'TOP'
	Health:SetPoint'LEFT'
	Health:SetPoint'RIGHT'

	self.Health = Health

	local HBG = Health:CreateTexture(nil, 'BORDER')
	HBG:SetAllPoints()
	HBG:SetTexture(.15, .15, .15)

	local Background = CreateFrame('Frame', nil, self)
	Background:SetPoint('TOPLEFT', -2, 2)
	Background:SetPoint('BOTTOMRIGHT', 2, -2)
	Background:SetBackdrop(BACKDROP)
	Background:SetBackdropColor(0, 0, 0, 1)

	self.Background = Background

	local HealthPoints = self:CreateFontString(nil, 'OVERLAY')
	HealthPoints:SetPoint('LEFT', self, 'RIGHT', 25, -10)
	HealthPoints:SetFont('Fonts\\ARIALN.ttf', 11)
	HealthPoints:SetTextColor(1, 1, 1)
	HealthPoints:SetShadowOffset(1, -1)
    HealthPoints:SetShadowColor(0, 0, 0, 1)
	HealthPoints:SetJustifyH'LEFT'

	self:Tag(HealthPoints, '[|cffc41f3b>dead<|r][|cff999999>offline<|r][mod:health]')

	Health.value = HealthPoints

	local Power = CreateFrame('StatusBar', nil, self)

	if isSingle then
		Power:SetHeight(6)
		Power:SetStatusBarTexture(TEXTURE)

		Power.frequentUpdates = true
		Power.colorPower = true

		Power:SetPoint'LEFT'
		Power:SetPoint'RIGHT'
		Power:SetPoint('TOP', Health, 'BOTTOM', 0, -3)

		self.Power = Power

		local PBG = Power:CreateTexture(nil, 'BORDER')
		PBG:SetAllPoints()
		PBG:SetTexture(.15, .15, .15)

		local Background = Power:CreateTexture(nil, 'BORDER')
		Background:SetTexture(0, 0, 0, .4)
		Background:SetAllPoints()

		local PowerPoints = Power:CreateFontString(nil, 'OVERLAY')
		PowerPoints:SetPoint('LEFT', HealthPoints, 'RIGHT', 0, 0)
		PowerPoints:SetFont('Fonts\\ARIALN.ttf', 11)
		PowerPoints:SetShadowOffset(1, -1)
	    PowerPoints:SetShadowColor(0, 0, 0, 1)
		PowerPoints:SetJustifyH'LEFT'
		PowerPoints:SetTextColor(1, 1, 1)
		self:Tag(PowerPoints, '[  —   >mod:power]')

		Power.value = PowerPoints
	end

	local Castbar = CreateFrame('StatusBar', nil, self)
	Castbar:SetStatusBarTexture(TEXTURE)
	Castbar:SetStatusBarColor(1, .25, .35, .5)
	Castbar:SetAllPoints(Health)
	Castbar:SetToplevel(true)

	self.Castbar = Castbar

	local MasterLooter = self:CreateTexture(nil, 'OVERLAY')
	MasterLooter:SetHeight(16)
	MasterLooter:SetWidth(16)
	MasterLooter:SetPoint('LEFT', Leader, 'RIGHT')

	self.MasterLooter = MasterLooter

	local RaidIcon = Health:CreateFontString(nil, 'OVERLAY')
	RaidIcon:SetPoint('LEFT', 2, 4)
	RaidIcon:SetJustifyH'LEFT'
	RaidIcon:SetFontObject(GameFontNormalSmall)
	RaidIcon:SetTextColor(1, 1, 1)

	self.RIcon = RaidIcon
	self:RegisterEvent('RAID_TARGET_UPDATE', RAID_TARGET_UPDATE)
	table.insert(self.__elements, RAID_TARGET_UPDATE)

	AddAuraElement(self, unit, isSingle)

	if isSingle then self:SetSize(100, 6) end

	self:RegisterEvent('UNIT_NAME_UPDATE', PostCastStopUpdate)
	table.insert(self.__elements, PostCastStopUpdate)

	Castbar.PostChannelStart = PostCastStart
	Castbar.PostCastStart = PostCastStart

	Castbar.PostCastStop = PostCastStop
	Castbar.PostChannelStop = PostCastStop

	Health.PostUpdate = PostUpdateHealth
	if isSingle then Power.PostUpdate = PostUpdatePower end
end

local UnitSpecific = {
	player = function(self, ...)
		Shared(self, ...)
		local colour = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[CLASS]

		self:SetScript('OnClick', function(self, bu) if bu ~= 'RightButton' then ToggleCharacter'PaperDollFrame' end end)
		self:ClearAllPoints()
		self:SetParent(_G['bar_bu1'])
		self:SetPoint('TOPLEFT', _G['bar_bu1'])
		self:SetPoint('BOTTOMRIGHT', _G['bar_bu1'])

		local Health = self.Health
		Health:SetStatusBarTexture''

		Health.value:SetParent(_G['lovelyui_container'])
		Health.value:ClearAllPoints()
		Health.value:SetPoint('CENTER', _G['lovelyui_container'], -30, -3)
		Health.value:SetFont('Fonts\\ARIALN.ttf', 18)
		x = {Health.value:GetPoint()}

		local Power = self.Power
		Power:SetStatusBarTexture''

		local Background = self.Background
		Background:SetBackdrop(nil)

		local RaidIcon = self.RIcon
		RaidIcon:SetFont(STANDARD_TEXT_FONT, 7)
		RaidIcon:ClearAllPoints()
		RaidIcon:SetPoint('TOP', 0, 8)

		local PowerPoints = self.Power.value
		PowerPoints:ClearAllPoints()
		PowerPoints:SetPoint('LEFT', Health.value, 'RIGHT', 0, -2)
		if CLASS == 'WARLOCK' then
			self:Tag(PowerPoints, '[  —   >mod:power][  —  >soulshards]')
		elseif CLASS == 'ROGUE' then
			self:Tag(PowerPoints, '[  —   >mod:power][  —  >cpoints]')
		end

		local AltPowerBar = CreateFrame('StatusBar', nil, self)
		AltPowerBar:SetHeight(3)
		AltPowerBar:SetStatusBarTexture(TEXTURE)
		AltPowerBar:SetStatusBarColor(1, 1, 1)

		local Castbar = self.Castbar
		Castbar:ClearAllPoints()
		Castbar:SetPoint('BOTTOM', UIParent, -1, 162)
		Castbar:SetSize(100, 5)
		Castbar:SetStatusBarColor(colour.r*1.4, colour.g*1.4, colour.b*1.4, 1)

		Castbar.bg = CreateFrame('Frame', nil, Castbar)
		Castbar.bg:SetPoint('TOPLEFT', -2, 2)
		Castbar.bg:SetPoint('BOTTOMRIGHT', 2, -2)
		Castbar.bg:SetBackdrop(BACKDROP)
		Castbar.bg:SetBackdropColor(0, 0, 0, 1)
		Castbar.bg:SetFrameLevel(0)

		Castbar.text = Castbar:CreateFontString(nil, 'ARTWORK')
		Castbar.text:SetPoint('LEFT', Castbar, 'RIGHT', 25, 0)
		Castbar.text:SetFont([[Fonts\ARIALN.ttf]], 11)
		Castbar.text:SetShadowOffset(1, -1)
	    Castbar.text:SetShadowColor(0, 0, 0, 1)

		self.Name:Hide()

		self.ClassIcons = ClassIcons
	end,

	target = function(self, ...)
		Shared(self, ...)

		local Dead = CreateFrame('Frame', nil, self)
		Dead:SetSize(28, 28)
		Dead:SetPoint('TOPRIGHT', self, 3, 10)
		Dead:SetBackdrop(BACKDROP)
		Dead:SetBackdropColor(0, 0, 0)
		Dead:Hide()
		self.Dead = Dead

		Dead.icon = Dead:CreateTexture(nil, 'OVERLAY')
		Dead.icon:SetSize(32, 32)
		Dead.icon:SetTexture[[Interface\Icons\spell_holy_guardianspirit]]
		Dead.icon:SetTexCoord(.1, .9, .1, .9)
		Dead.icon:SetPoint('TOPLEFT', 2, -2)
		Dead.icon:SetPoint('BOTTOMRIGHT', -2, 2)
	end,

	boss = function(self, ...)
		Shared(self, ...)

		self:Tag(self.Health.value, '[perhp] | [mod:health]')

		-- Disable the power value, it isn't really importent.
		self:Untag(self.Power.value)
		self.Name:Hide()
		self.Health.value:Hide()
		self.Power.value:Hide()

		self:SetHeight(6)
		self:SetWidth(36)
	end,
}
UnitSpecific.focus = UnitSpecific.target

do
	local range = {
		insideAlpha = 1,
		outsideAlpha = .5,
	}

	UnitSpecific.party = function(self, ...)
		Shared(self, ...)

		local Health, Power, RaidIcon = self.Health, self.Power, self.RIcon

		Health:SetHeight(5)

		local Leader = self.Health:CreateTexture(nil, 'OVERLAY')
		Leader:SetHeight(16)
		Leader:SetWidth(16)
		Leader:SetPoint('BOTTOM', Health, 'TOP', 0, -5)

		RaidIcon:ClearAllPoints()
		RaidIcon:SetFont(STANDARD_TEXT_FONT, 7)
		RaidIcon:SetPoint('CENTER', 0, 5)
		RaidIcon:SetJustifyH'LEFT'

		self.Leader = Leader

		--local LFDRole = self:CreateTexture(nil, 'OVERLAY')
		--LFDRole:SetSize(6, 6)
		--LFDRole:SetPoint('RIGHT', self, 'LEFT', -3, 0)

		self.Name:Hide()
		self.Health.value:Hide()

		self.LFDRole = LFDRole
		self.Range = range
	end
end

oUF:RegisterStyle('mod', Shared)
for unit, layout in next, UnitSpecific do
	-- Capitalize the unit name, so it looks better.
	oUF:RegisterStyle('mod - ' .. unit:gsub('^%l', string.upper), layout)
end

-- A small helper to change the style into a unit specific, if it exists.
local spawnHelper = function(self, unit, ...)
	if(UnitSpecific[unit]) then
		self:SetActiveStyle('mod - ' .. unit:gsub('^%l', string.upper))
	elseif(UnitSpecific[unit:match('%D+')]) then -- boss1 -> boss
		self:SetActiveStyle('mod - ' .. unit:match('%D+'):gsub('^%l', string.upper))
	else
		self:SetActiveStyle'mod'
	end

	local object = self:Spawn(unit)
	object:SetPoint(...)
	return object
end

oUF:Factory(function(self)
	local base = 200
	local offset = -350

	spawnHelper(self, 'player', 'TOP', 0, 0)
	spawnHelper(self, 'target', 'BOTTOM', 0, 130)

	for n = 1, MAX_BOSS_FRAMES or 5 do
		spawnHelper(self, 'boss'..n, 'CENTER', -((offset + 89)/1.5) + (39*n), -base + (52 * 2))
	end

	self:SetActiveStyle'mod - Party'
	local party = self:SpawnHeader(
		nil, nil, 'raid,party,solo',
		'showRaid',          true,
		'showParty',         true,
		'showPlayer',        true,
		'showSolo',          false,
		'xOffset',           3,
		'yOffset',           3,
		'groupFilter',       '1,2,3,4,5',
    	'groupingOrder',     '1,2,3,4,5',
    	'groupBy',           'GROUP',
		'sortMethod',        'NAME',
    	'maxColumns',        5,
    	'unitsPerColumn',    5,
    	'columnSpacing',     3,
		'point',             'LEFT',
		'columnAnchorPoint', 'TOP',
		'oUF-initialConfigFunction', [[
			self:SetHeight(5)
			self:SetWidth(36)
		]]
	)
	party:SetPoint('BOTTOM', -(offset/1.5) - 60, base + (40 * 3) - 10)
end)

SlashCmdList['TP'] = function()
	for _, obj in pairs(oUF.objects) do
        if(obj.unit) then
            obj.oldunit = obj.unit
            obj.unit = 'player'
            obj:SetAttribute('unit', 'player')
        end
    end
end
SLASH_TP1 = '/tp'
