local db = {
	settings = {
		-- statusbar
		statusbar = {
			size = 5,
			point = "RIGHT",
			gradients = true,
		},
		frame = {
			size = 30,
			scale = 1,
			point = "RIGHT",
			xOffset = 5,
			yOffset = -5,
			columnSpacing = 6,
			columnMax = 1,
			columnAnchorPoint = "RIGHT",
		},
	},
}

local itemdb = { [29370] = true, [44014] = true, }
local spelldb = {}

local addon = CreateFrame'Frame'

function addon:parseSpellBook(type)
	if spellbook == BOOKTYPE_SPELL then wipe(spelldb) end
	local i = 1
	while true do
		local skilltype, id = GetSpellBookItemInfo(i, type)
		local name = GetSpellBookItemName(i, type)
		local next = GetSpellBookItemName(i + 1, type)
		if not name then break end
		if name ~= next and skilltype == "SPELL" and type == BOOKTYPE_SPELL and not IsPassiveSpell(i, type) then
			spelldb[id] = true
		end
		i = i + 1
	end
end

function addon:LEARNED_SPELL_IN_TAB()
	addon:parseSpellBook(BOOKTYPE_SPELL)
	addon:parseSpellBook(BOOKTYPE_PET)
end

function addon:PLAYER_LOGIN()
	self.group = self.display:RegisterGroup('lovelycd', 'RIGHT', Minimap, 'RIGHT', -86, -25)

	for k, v in pairs(db.settings) do
		self.group[k] = v
	end

	self.group:SetBackdropColor(0, 0, 0)
	self.group:SetBackdropBorderColor(0, 0, 0)
	self.group:SetHeight(18 * 3)
	self.group:SetWidth(18 * 2)

	addon:LEARNED_SPELL_IN_TAB()
end

function addon:SPELL_UPDATE_COOLDOWN()
	for name, obj in pairs(spelldb) do
		local startTime, duration, enabled = GetSpellCooldown(name)
		if enabled == 1 and duration > 1.5 then
			self.group:RegisterBar(name, startTime, duration, GetSpellTexture(name), 0, 1, 0)
		elseif enabled == 1 then
			self.group:UnregisterBar(name)
		end
	end
end

function addon:BAG_UPDATE_COOLDOWN()
	for item, obj in pairs(itemdb) do
		local startTime, duration, enabled = GetItemCooldown(item)
		if enabled == 1 then
			self.group:RegisterBar(item, startTime, duration, select(10, GetItemInfo(item)), 0, 1, 0)
		end
	end
end

addon:SetScript('OnEvent', function(self, event, ...) self[event](self, event, ...) end)
addon:RegisterEvent'PLAYER_LOGIN'
addon:RegisterEvent'LEARNED_SPELL_IN_TAB'
addon:RegisterEvent'SPELL_UPDATE_COOLDOWN'
addon:RegisterEvent'BAG_UPDATE_COOLDOWN'

_G.lovelycd = addon
