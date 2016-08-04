

    -- http://www.wowinterface.com/downloads/info23917-PowerHungry.html

    local BACKDROP = {
        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
        tiled = false,
        insets = {left = -3, right = -3, top = -3, bottom = -3}
    }

    local r, g, b = 103/255, 103/255, 103/255
    local items = {
        [127999] = 10,  -- Shard of Potentiation (old)
        [128000] = 25,  -- Crystal of Ensoulment (x?)
        [128021] = 25,  -- Scroll of Enlightenment (x?)
        [128022] = 10,  -- Treasured Coin (x?)
        [128026] = 150, -- Trembling Phylactery (x?)
        [130144] = 50,  -- Crystallized Fey Darter Egg
        [130149] = 100, -- Carved Smolderhide Figurines
        [130152] = 50,  -- Condensed Light of Elune
        [130153] = 100, -- Godafoss Essence
        [130159] = 100, -- Ravencrest Shield
        [130160] = 100, -- Vial of Pure Moonrest Water
        [130165] = 75,  -- Heathrow Keepsake
        [131728] = 75,  -- Urn of Malgalor's Blood
        [131751] = 75,  -- Glinting Star of An'she
        [131753] = 75,  -- Prayers to the Earthmother
        [131758] = 50,  -- Oversized Acorn
        [131763] = 75,  -- Great Eagle Feather
        [131778] = 50,  -- Woodcarved Rabbit
        [131784] = 50,  -- Left Half of a Locket
        [131785] = 50,  -- Right Half of a Locket
        [131789] = 75,  -- Handmade Mobile
        [131795] = 100, -- Beaded Bracelet
        [131802] = 100, -- Offering to An'she
        [131808] = 100, -- Engraved Armlet
        [132361] = 50,  -- Petrified Arkhana
        [132897] = 75,  -- Mandate of the Valkyra
        [132923] = 50,  -- Hrydshal Etching
        [132950] = 75,  -- Ornate Idol of Helya
        [134118] = 150, -- Cluster of Potentiation (x?)
        [134133] = 150, -- Jewel of Brilliance (x?)
        [138726] = 10,  -- Shard of Potentiation (new)
        [138732] = 10,  -- History of the Blade
        [138781] = 75,  -- History of the Aeons
        [138782] = 250, -- History of the Ages
        [138783] = 20,  -- Glittering Memento
        [138784] = 100, -- Questor's Glory
        [138785] = 50,  -- Adventurer's Resounding Glory
        [138786] = 25,  -- Talisman of Victory
        [138812] = 25,  -- Adventurer's Wisdom
        [138813] = 25,  -- Adventurer's Resounding Renown
        [138814] = 15,  -- Adventurer's Renown
        [138816] = 25,  -- Adventurer's Glory
        [138839] = 20,  -- Valiant's Glory
        [138864] = 5,   -- Skirmisher's Glory
        [138865] = 10,  -- Gladiator's Triumph
        [138880] = 15,  -- Soldier's Determination
        [138881] = 30,  -- Soldier's Glory
        [138885] = 50,  -- Treasure of the Ages
        [138886] = 150, -- Glory of the Gladiator
        [139413] = 200, -- Greater Questor's Glory
        [139506] = 300, -- Glory of the Order
        [139507] = 20,  -- Cracked Insignia
        [139508] = 20,  -- Dried Worldtree Seeds
        [139509] = 40,  -- Worldtree Bloom
        [139510] = 80,  -- Ancient Druidic Carving
        [139511] = 40,  -- Hallowed Runestone
        [139512] = 80,  -- Sigilstone of Tribute
        [139608] = 20,  -- Brittle Spelltome
        [139609] = 40,  -- Depleted Cadet's Wand
        [139610] = 80,  -- Musty Azsharan Grimore
        [139611] = 20,  -- Primitive Roggtotem
        [139612] = 40,  -- Highmountain Mystic's Totem
        [139613] = 80,  -- Curio of Neltharion
        [139614] = 20,  -- Azsharan Manapearl
        [139615] = 40,  -- Untapped Mana Gem
        [139616] = 80,  -- Dropper of Nightwell Liquid
        [139617] = 80,  -- Ancient Warden Manacles
        [140176] = 25,  -- Accolade of Victory
        [140237] = 100, -- Iadreth's Enchanted Birthstone
        [140238] = 100, -- Scavenged Felstone
        [140241] = 100, -- Enchanted Moonfall Text
        [140244] = 100, -- Jandvick Jarl's Pendant Stone
        [140247] = 100, -- Mornath's Enchanted Statue
        [140250] = 150, -- Ingested Legion Stabilizer
        [140251] = 100, -- Purified Satyr Totem
        [140252] = 100, -- Tel'anor Ancestral Tablet
        [140254] = 150, -- The Seawarden's Beacon
        [140255] = 100, -- Enchanted Nightborne Coin
        [140304] = 50,  -- Activated Essence
        [140305] = 100, -- Brimming Essence
        [140306] = 50,  -- Mark of the Valorous
        [140307] = 300, -- Heart of Zin-Azshari
        [140310] = 5,   -- Crude Statuette
        [140322] = 20,  -- Trainer's Insight
        [140349] = 50,  -- Crystalline Ambervale Seed
        [140372] = 25,  -- Ancient Artificer's Manipulator
        [140381] = 25,  -- Jandvick Jarl's Ring, and Finger
        [140384] = 25,  -- Azsharan Court Scepter
        [140386] = 25,  -- Inquisitor's Shadow Orb
        [140388] = 25,  -- Falanaar Gemstone
        [140396] = 25,  -- Friendly Brawler's Wager
        [140409] = 200, -- Tome of Dimensional Awareness
        [140410] = 150, -- Mark of the Rogues
        [140421] = 200, -- Ancient Qiraji Artifact
        [140422] = 150, -- Moonglow Idol
        [140444] = 250, -- Dream Tear
        [140445] = 250, -- Arcfruit
        [140517] = 300, -- Glory of the Order
        [140685] = 25,  -- Enchanted Sunrunner Kidney
        [140847] = 150, -- Ancient Workshop Focusing Crystal
        [141023] = 20,  -- Seal of Victory
        [141024] = 20,  -- Seal of Leadership
        [141393] = 100, -- Onyx Arrowhead
    }

    local bu = CreateFrame('Button', 'modArtifactConsumable', UIParent, 'SecureActionButtonTemplate')
    bu:SetPoint('TOPLEFT', Minimap, 'BOTTOMLEFT', 0, -73)
    bu:SetSize(16, 16)
    bu:SetFrameLevel(10)
    bu:SetAttribute('type', 'item')
    bu:SetBackdrop(BACKDROP)
    bu:SetBackdropColor(0, 0, 0)
    bu:Hide()

    bu.t = bu:CreateTexture()
    bu.t:SetTexCoord(.1, .9, .1, .9)
    bu.t:SetAllPoints()

    bu.cd = CreateFrame('Cooldown', nil, bu, 'CooldownFrameTemplate')
    bu.cd:SetAllPoints()

    bu.text = bu:CreateFontString(nil, 'OVERLAY')
    bu.text:SetPoint('RIGHT', bu, 'LEFT', -6, 0)
    bu.text:SetFont(STANDARD_TEXT_FONT, 10, 'OUTLINE')

    local cooldown = function()
        if bu.id then
            local start, cd = GetItemCooldown(bu.id)
            bu.cd:SetCooldown(start, cd)
        end
    end

    local hide = function()
        bu.id = nil
        bu:SetAttribute('item', nil)
        bu:Hide()
        bu.t:SetTexture''
        bu.text:SetText''
    end

    local show = function(id, pi)
        bu.id = id
        bu:SetAttribute('item', 'item:'..id)
        bu:Show()
        bu.t:SetTexture(GetItemIcon(id))
        bu.text:SetText(string.format('%d Artifact Power <', pi))
    end

    local scan = function()
        local id, pi
        hide()
        for i = 0, 4 do
            for j = 1, GetContainerNumSlots(i) do
                id = GetContainerItemID(i, j)
                pi = items[id]
                if pi then show(id, pi) break end
            end
        end
    end

    bu:SetScript('OnEnter', function()
        GameTooltip:SetOwner(bu, 'ANCHOR_TOP')
        if bu.id then GameTooltip:SetItemByID(bu.id) end
    end)

    bu:SetScript('OnLeave', function() GameTooltip:Hide() end)

    local f = CreateFrame'Frame'
    f:RegisterEvent'BAG_UPDATE_COOLDOWN'
    f:RegisterEvent'SPELL_UPDATE_COOLDOWN'
    f:RegisterEvent'BAG_UPDATE_DELAYED'
    f:RegisterEvent'PLAYER_REGEN_ENABLED'
    f:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)

    function f:BAG_UPDATE_COOLDOWN()   cooldown() end
    function f:SPELL_UPDATE_COOLDOWN() cooldown() end
    function f:BAG_UPDATE_DELAYED()
        if InCombatLockdown() then
            f:RegisterEvent'PLAYER_REGEN_ENABLED'
        else
            scan()
        end
    end
    function f:PLAYER_REGEN_ENABLED()
        scan()
        f:UnregisterEvent'PLAYER_REGEN_ENABLED'
    end


    --
