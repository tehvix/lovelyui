

                            -- chat
                            -- obble


        -- snap the chat to a default position when logging in
        -- default is toggled OFF
    local chatposi = false

        -- chat position
        -- 'chatposi' must be true for this to work
    local chatXY = {'BOTTOMLEFT', ActionButton1, 'BOTTOMLEFT', 5, 225}

    local type, gsub, time, floor,  _ = type, _G.string.gsub, time, math.floor, _
    local chat_alpha = DEFAULT_CHATFRAME_ALPHA
    local BACKDROP = {
        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
        tiled = false,
        edgeFile = 'Interface\\Buttons\\WHITE8x8', edgeSize = 3,
        insets = {left = -1, right = -1, top = -1, bottom = -1}
    }


        -- TYPEFACE
    ChatFontNormal:SetFont('Fonts\\ARIALN.ttf', 13)
    ChatFontNormal:SetShadowOffset(2, -1.4)
    ChatFontNormal:SetShadowColor(0, 0, 0, 1)


        -- SLASH COMMANDS
        -- reload ui
    SLASH_RELOADUI1 = '/rl'
    SlashCmdList.RELOADUI = ReloadUI

        -- framestack
    SLASH_FSTACK1 = '/fs'
    SlashCmdList.FSTACK = function(msg)
        UIParentLoadAddOn('Blizzard_DebugTools')
        FrameStackTooltip_Toggle()
    end

        -- event trace
    SLASH_ETTRACE1 = '/et'
    SlashCmdList.ETTRACE = function(msg)
        UIParentLoadAddOn('Blizzard_DebugTools')
        EventTraceFrame_HandleSlashCmd(msg)
    end

        -- clear chat
    SLASH_CLEAR_CHAT1 = '/clear'
    SlashCmdList.CLEAR_CHAT = function()
        for i = 1, NUM_CHAT_WINDOWS do _G[format('ChatFrame%d', i)]:Clear() end
    end

    -- UI options list
     SLASH_UIFORM1 = '/ui'
    SlashCmdList.UIFORM = function(msg)
        DEFAULT_CHAT_FRAME:AddMessage('|cff01DFD7Lovely UI:|r', 254/255, 193/255, 192/255)
    end


        -- FRAME FADE TIMES/ALPHA LEVELS
    DEFAULT_CHATFRAME_ALPHA = .25
    CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
    CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
    CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
    CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 0
    CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
    CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
    CHAT_FRAME_FADE_OUT_TIME = .1
    CHAT_FRAME_FADE_TIME = .1
    CHAT_TAB_HIDE_DELAY = 1


        -- MORE FONT SIZE MENU OPTIONS
    CHAT_FONT_HEIGHTS = {
        [1] = 8,
        [2] = 9,
        [3] = 10,
        [4] = 11,
        [5] = 12,
        [6] = 13,
        [7] = 14,
        [8] = 15,
        [9] = 16,
        [10] = 17,
        [11] = 18,
        [12] = 19,
        [13] = 20,
    }


        -- STRING SUBS
        -- flags
    CHAT_FLAG_AFK = '/AFK/ '
    CHAT_FLAG_DND = '/DND/ '
    CHAT_FLAG_GM = '/GM/ '

        -- channels
    CHAT_GUILD_GET = '/|Hchannel:Guild|hG|h/ %s:\32'
    CHAT_OFFICER_GET = '/|Hchannel:o|hO|h/ %s:\32'
    CHAT_RAID_GET = '/|Hchannel:raid|hR|h/ %s:\32'
    CHAT_RAID_WARNING_GET = '/RW/ %s:\32'
    CHAT_RAID_LEADER_GET = '/|Hchannel:raid|hR-L|h/ %s:\32'
    CHAT_INSTANCE_CHAT_GET = '/|Hchannel:INSTANCE_CHAT|hIns|h/ %s:\32'
    CHAT_INSTANCE_CHAT_LEADER_GET = '/|Hchannel:INSTANCE_CHAT|hI-L|h/ %s:\32'
    CHAT_BATTLEGROUND_GET = '/|Hchannel:Battleground|hBG|h/ %s:\32'
    CHAT_BATTLEGROUND_LEADER_GET = '/|Hchannel:Battleground|hB-L|h/ %s:\32'
    CHAT_PARTY_GET = '/|Hchannel:party|hP|h/ %s:\32'
    CHAT_PARTY_GUIDE_GET = '/|Hchannel:party|hDG|h/ %s:\32'
    CHAT_MONSTER_PARTY_GET = '/|Hchannel:raid|hR|h/ %s:\32'

        -- ca$h values
        -- this is a global change, affects lootframe etc. too.
    _G.GOLD_AMOUNT = '|cffffffff%d|r|TInterface\\MONEYFRAME\\UI-GoldIcon:14:14:2:0|t'
    _G.SILVER_AMOUNT = '|cffffffff%d|r|TInterface\\MONEYFRAME\\UI-SilverIcon:14:14:2:0|t'
    _G.COPPER_AMOUNT = '|cffffffff%d|r|TInterface\\MONEYFRAME\\UI-CopperIcon:14:14:2:0|t'

        -- shorten some chat events
    local chatevents = {
        CHAT_MSG_AFK = {
            -- empty tables like this mean messages will not fire
            -- useful for spammy/pointless chat messages
        },
        CHAT_MSG_CHANNEL_JOIN = {
        },
        CHAT_MSG_COMBAT_FACTION_CHANGE = {
            ['Reputation with (.+) increased by (.+).'] = '> %2 %1 rep.',
            ['You are now (.+) with (.+).'] = '%2 standing is now %1.',
        },
        CHAT_MSG_COMBAT_XP_GAIN = {
            ['(.+) dies, you gain (.+) experience. %(%+(.+)exp Rested bonus%)'] = '> %2 (+%3) xp from %1.',
            ['(.+) dies, you gain (.+) experience.'] = '> %2 xp from %1.',
            ['You gain (.+) experience.'] = '> %1 xp.',
        },
        CHAT_MSG_CURRENCY = {
            ['You receive currency: (.+)%.'] = '> %1.',
            ['You\'ve lost (.+)%.'] = '- %1.',
        },
        CHAT_MSG_GUILD_ACHIEVEMENT = {
            ['(.+) has earned the achievement (.+)!'] = '%1 achieved %2.',
        },
        CHAT_MSG_ACHIEVEMENT = {
            ['(.+) has earned the achievement (.+)!'] = '%1 achieved %2.',
        },
        CHAT_MSG_LOOT = {
            ['You receive item: (.+)%.'] = '> %1.',
            ['You receive loot: (.+)%.'] = '> %1.',
            ['You receive bonus loot: (.+)%.'] = '> bonus %1.',
            ['You create: (.+)%.'] = '> %1.',
            ['You are refunded: (.+)%.'] = '> %1.',
            ['You have selected (.+) for: (.+)'] = 'Selected %1 for %2.',
            ['Received item: (.+)%.'] = '> %1.',
            ['(.+) receives item: (.+)%.'] = '> %2 for %1.',
            ['(.+) receives loot: (.+)%.'] = '> %2 for %1.',
            ['(.+) receives bonus loot: (.+)%.'] = '> bonus %2 for %1.',
            ['(.+) creates: (.+)%.'] = '> %2 for %1.',
            ['(.+) was disenchanted for loot by (.+).'] = '%2 disenchanted %1.',
        },
        CHAT_MSG_SKILL = {
            ['Your skill in (.+) has increased to (.+).'] = '%1 lvl %2.'
        },
        CHAT_MSG_SYSTEM = {
            ['Received (.+), (.+).'] = '> %1, %2.',
            ['Received (.+).'] = '> %1.',
            ['Received (.+) of item: (.+).'] = '> %2x%1.',
            ['(.+) is now your follower.'] = '> follower %1.',
            ['(.+) completed.'] = '- Quest |cfff86256%1|r.',
            ['Quest accepted: (.+)'] = '> Quest |cfff86256%1|r.',
            ['Received item: (.+)%.'] = '> %1.',
            ['Experience gained: (.+).'] = '> %1 xp.',
            ['(.+) has come online.'] = '|cff40fb40%1|r logged on.',
            ['(.+) has gone offline.'] = '|cff40fb40%1|r logged off.',
            ['You are now Busy: in combat'] = '> Combat.',
            ['You are no longer marked Busy.'] = '- Combat.',
            ['Discovered (.+): (.+) experience gained'] = '> %2 xp, found %1.',
            ['You are now (.+) with (.+).'] = '> %2 faction, now %1.',
            ['Quest Accepted (.+)'] = '> quest |cfff86256%1|r.',
            ['You are now Away: AFK'] = '> AFK.',
            ['You are no longer Away.'] = '- AFK.',
            ['You are no longer rested.'] = '- Rested.',
            ['You don\'t meet the requirements for that quest.'] = '|cffff000!|r Quest requirements not met.',
            ['(.+) has joined the raid group.'] = '> Raider |cffff7d00%1|r.',
            ['(.+) has left the raid group.'] = '- Raider |cffff7d00%1|r.',
            ['You have earned the title \'(.+)\'.'] = '> Title %1.',
        },
        CHAT_MSG_TRADESKILLS = {
            ['(.+) creates (.+).'] = '%1 |cffffff00->|r %2.',
        },
    }

        -- implement event subs
    for event, eventFilters in pairs(chatevents) do
        ChatFrame_AddMessageEventFilter(event, function(frame, event, message, ...)
            for k, v in pairs(eventFilters) do
                -- print('trying', k, 'with', v..'.')

                if message:match(k) then
                    -- print(k, 'is a match.')
                    message = message:gsub(k, v)
                    return nil, message, ...
                end
            end
                -- event/string finder, as long as an event is registered in the table
                -- this will return all messages fired by it.

            -- print(event, ':', message..'.')
            -- return nil, message, ...
        end)
    end

        -- implement general chat string subs
    local AddMessage = ChatFrame1.AddMessage
    local function FCF_AddMessage(self, text, ...)
        if type(text)=='string' then
            local _, size = self:GetFont()
            local iconsize = 10
            size = floor(size + .5)

            if text:find(' |T') then                                    -- sharpen & resize icons
                text = gsub(text, '(:12:12)', ':'..iconsize..':'..iconsize..':0:0:64:64:5:59:5:59')
            end

            text = gsub(text, '(|HBNplayer.-|h)%[(.-)%]|h', '%1%2|h')	-- battlenet player name
            text = gsub(text, '(|Hplayer.-|h)%[(.-)%]|h', '%1%2|h')		-- player name
            text = gsub(text, '%[(%d0?)%. (.-)%]', '/%1/')				-- globals channels: [1. trade] > /1./
            text = gsub(text, 'Guild Message of the Day:', '/GMOTD/')	-- message of the day
            text = gsub(text, 'To (|HBNplayer.+|h):', '%1 >')    		-- whisper to bnet
            text = gsub(text, 'To (|Hplayer.+|h):', '%1 >')				-- whisper to
            text = gsub(text, ' whispers:', ' <')						-- whisper from
            text = gsub(text, 'Joined Channel:', '>')					-- channel join
            text = gsub(text, 'Left Channel:', '- ')					-- channel left
            text = gsub(text, 'Changed Channel:', '>')					-- channel change
            text = gsub(text, '|H(.-)|h%[(.-)%]|h', '|H%1|h%2|h')		-- strip brackets off've items iilinks style
            text = '— '..text											-- add an em to each line
        end
        return AddMessage(self, text, ...)
    end


        -- FLAVOUR TEXT
        -- http://eu.battle.net/wow/en/forum/topic/12286978621
    ForceGossip = function() return true end

        -- INFO MESSAGES TO CHAT + HIDE ERROR SPAM
    UIErrorsFrame:UnregisterEvent'UI_ERROR_MESSAGE'
    UIErrorsFrame:SetScript('OnEvent', function(self, event, ...)
        local a1, a2, a3, a4 = ...
        if event == 'SYSMSG' then
            ChatFrame1:AddMessage(a1, a2, a3, a4, 1)
        elseif event =='UI_INFO_MESSAGE' then
            ChatFrame1:AddMessage(a2, 1.0, 1, 0, 1)
        end
    end)


        -- RESPOSITION
    if chatposi then
        local ChatFrameN = CreateFrame('Frame', nil, UIParent)
        ChatFrameN:RegisterEvent'PLAYER_ENTERING_WORLD'
        ChatFrameN:SetScript('OnEvent', function()
            ChatFrame1:ClearAllPoints()
            ChatFrame1:SetPoint(chatXY[1], chatXY[2], chatXY[3], chatXY[4], chatXY[5])
            ChatFrame1:SetUserPlaced(true)
        end)
    end


        -- CLASS COLOURED NAMES
    for k, v in pairs(CHAT_CONFIG_CHAT_LEFT) do
        ToggleChatColorNamesByClassGroup(true, v.type)
    end
    for i = 1, 15 do
        ToggleChatColorNamesByClassGroup(true, 'CHANNEL'..i)
    end


        -- HIDE BUTTONS
    if FriendsMicroButton:IsShown() then
        FriendsMicroButton:SetAlpha(0)
        FriendsMicroButton:EnableMouse(false)
        FriendsMicroButton:UnregisterAllEvents()
    end

    if ChatFrameMenuButton:IsShown() then
        ChatFrameMenuButton:SetAlpha(0)
        ChatFrameMenuButton:EnableMouse(false)
    end

    hooksecurefunc('FloatingChatFrame_OnMouseScroll', function(self, direction)
        local buttonBottom = _G[self:GetName() .. 'ButtonFrameBottomButton']
        if self:AtBottom() then
            buttonBottom:Hide()
        else
            buttonBottom:Show()
            buttonBottom:SetAlpha(1)
        end
    end)


        -- TABS
    --[[local function SkinTab(self)
        local chat = _G[self]
        local tab = _G[self..'Tab']
        hooksecurefunc(tab, 'Show', function()
            if not tab.wasShown then
                if chat:IsMouseOver() then
                    tab:SetAlpha(CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA)
                else
                    tab:SetAlpha(CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA)
                end
                tab.wasShown = true
            end
        end)
    end ]]


        -- EDITBOX
        -- this just hides it when in the default IM mode
        for i = 1, NUM_CHAT_WINDOWS do
            local editBox = _G[('ChatFrame%d'):format(i)..'EditBox']
            editBox:Hide()
            editBox:HookScript('OnEditFocusLost', function(self)
                self:Hide()
            end)
             editBox:HookScript('OnEditFocusGained', function(self)
                self:Show()
            end)
        end


        -- BORDER
    local chatbgskin = CreateFrame'Frame'
    chatbgskin:SetFrameStrata'LOW'
    chatbgskin:Hide()

    local function BGborder(object)
        if object:IsShown() then
            chatbgskin:Show()
            chatbgskin:SetBackdrop(BACKDROP)
            chatbgskin:SetBackdropColor(0, 0, 0, 0)
            chatbgskin:SetBackdropBorderColor(0 , 0 , 0, chat_alpha*2)
            chatbgskin:SetAllPoints(object)
        end
    end

        -- skin on mouseover
        -- ToDo: also implement for those weirdos who have a chat bg all the time
        -- there's an FCF setalpha event but it has weird issues with parenting in hooks
    hooksecurefunc('FCF_FadeInChatFrame', function(self)
        local frameName = self:GetName()
        local object = _G[frameName..'Background']
        BGborder(object)
    end)

    hooksecurefunc('FCF_FadeOutChatFrame', function(self)
        local frameName = self:GetName()
        local object = _G[frameName..'Background']
        if object:IsShown() then
            chatbgskin:Hide()
        end
    end)

        -- TABS
    local function SkinTab(self)
        local chat = _G[self]

            -- hide textures
        local tab = _G[self..'Tab']
        for i = 1, select('#', tab:GetRegions()) do
            local texture = select(i, tab:GetRegions())
            if texture and texture:GetObjectType() == 'Texture' then
                texture:SetTexture(nil)
            end
        end

            -- text
        local tabText = _G[self..'TabText']
        tabText:SetJustifyH'CENTER'
        tabText:SetWidth(40)
        tabText:SetFont(STANDARD_TEXT_FONT, 13)
        tabText:SetShadowOffset(1.5, -1)
        tabText:SetShadowColor(0, 0, 0, 1)
        tabText:SetDrawLayer('OVERLAY', 7)


            -- move tab text
        local a = {tabText:GetPoint()}
        tabText:SetPoint(a[1], a[2], a[3], a[4], 2)

            -- move the tabs dock
        -- GENERAL_CHAT_DOCK:ClearAllPoints()
        -- GENERAL_CHAT_DOCK:SetPoint('TOPLEFT', ChatFrame1, 0, 22)
        -- GENERAL_CHAT_DOCK:SetWidth(ChatFrame1:GetWidth())

            -- glow
        local tabGlow = _G[self..'TabGlow']
        hooksecurefunc(tabGlow, 'Show', function()
            tabText:SetTextColor(247/255, 155/255, 181/255, CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA)
        end)

        hooksecurefunc(tabGlow, 'Hide', function()
            tabText:SetTextColor(1, 1, 1)
        end)

            -- mouseover
        tab:SetScript('OnEnter', function()
            tabText:SetTextColor(247/255, 155/255, 181/255, CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA)
        end)

        tab:SetScript('OnLeave', function()
            local aNofication = tabGlow:IsShown()
            local r, g, b
            if _G[self] == SELECTED_CHAT_FRAME and chat.isDocked then
                r, g, b = 255/255, 209/255, 0
            elseif aNofication then
                r, g, b = 247/255, 155/255, 181/255
            else
                r, g, b = 1, 1, 1
            end
            tabText:SetTextColor(r, g, b)
        end)

            -- updates
        hooksecurefunc('FCFDock_UpdateTabs', function()
            if not tab.wasShown then
                local aNofication = tabGlow:IsShown()

                if chat:IsMouseOver() then
                    tab:SetAlpha(CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA)
                else
                    tab:SetAlpha(CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA)
                end

                local r, g, b
                if _G[self]==SELECTED_CHAT_FRAME and chat.isDocked then
                    r, g, b = 255/255, 209/255, 0
                elseif aNofication then
                    r, g, b = 247/255, 155/255, 181/255
                else
                    r, g, b = 1, 1, 1
                end
                tabText:SetTextColor(r, g, b)
                tab.wasShown = true
            end
        end)
    end


        -- STYLE CHAT
        -- + edit box
    local function StyleChat(self)
        local chat = _G[self]

            -- boundaries
        chat:SetShadowOffset(1, -1)
        chat:SetClampedToScreen(false)
        chat:SetClampRectInsets(0, 0, 0, 0)
        chat:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
        chat:SetMinResize(150, 25)

            -- implement tab modification
        SkinTab(self)

            -- implement custom chat strings
        if self~='ChatFrame2' then
            chat.AddMessage = FCF_AddMessage
        end

            -- hide scroll up
        local buttonUp = _G[self..'ButtonFrameUpButton']
        buttonUp:SetAlpha(0)
        buttonUp:EnableMouse(false)

            -- hide scroll down
        local buttonDown = _G[self..'ButtonFrameDownButton']
        buttonDown:SetAlpha(0)
        buttonDown:EnableMouse(false)

            -- hide scroll bottom
            -- and reposition ready if it's reshown
        local buttonBottom = _G[self..'ButtonFrameBottomButton']
        buttonBottom:Hide()
        buttonBottom:ClearAllPoints()
        buttonBottom:SetPoint('RIGHT', chat, 'BOTTOMLEFT', -10, 12)
        buttonBottom:HookScript('OnClick', function(self)
            self:Hide()
        end)

            -- hide the weird extra background for now non-existent buttons
        for _, texture in pairs({
            'ButtonFrameBackground',
            'ButtonFrameTopLeftTexture',
            'ButtonFrameBottomLeftTexture',
            'ButtonFrameTopRightTexture',
            'ButtonFrameBottomRightTexture',
            'ButtonFrameLeftTexture',
            'ButtonFrameRightTexture',
            'ButtonFrameBottomTexture',
            'ButtonFrameTopTexture',
        }) do
            _G[self..texture]:SetTexture(nil)
        end

            -- edit box
        local editbox = _G[self..'EditBox']
        local header = _G[self..'EditBoxHeader']
        local suffix = _G[self..'EditBoxHeaderSuffix']
        local focusleft = _G[self..'EditBoxFocusLeft']
        local focusright = _G[self..'EditBoxFocusRight']
        local focusmid = _G[self..'EditBoxFocusMid']
		local editleft  = _G[self..'EditBoxLeft']
		local editright = _G[self..'EditBoxRight']
		local editmid  = _G[self..'EditBoxMid']

        editbox:SetHeight(20)
        editbox:SetAltArrowKeyMode(false)
        editbox:SetFont(STANDARD_TEXT_FONT, 11)
        editbox:SetTextInsets(11 + header:GetWidth() + (suffix:IsShown() and suffix:GetWidth() or 0), 11, 0, 0)
        editbox:SetBackdrop(BACKDROP)
        editbox:SetBackdropColor(0 , 0 , 0, chat_alpha)
        editbox:SetBackdropBorderColor(0 , 0 , 0, chat_alpha*2)
        editbox:ClearAllPoints()
        editbox:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', -2, -12)
        editbox:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 2, -12)

        header:SetFont(STANDARD_TEXT_FONT, 10)
        suffix:SetFont(STANDARD_TEXT_FONT, 10)

        focusleft:SetAlpha(0)
        focusright:SetAlpha(0)
        focusmid:SetAlpha(0)
        editleft:SetAlpha(0)
        editright:SetAlpha(0)
        editmid:SetAlpha(0)
    end


        -- HAX
        -- fix buggy bottoms with a more vigorous hook
        -- otherwise cinematics/world map make the scroll2bottom button visible again.
    hooksecurefunc('ChatFrame_OnUpdate', function(self)
        local buttonBottom = _G[self:GetName()..'ButtonFrameBottomButton']
        if self:AtBottom() and buttonBottom:IsShown() then
            buttonBottom:Hide()
        end
    end)


        -- IMPLEMENT
    local function StyleTheChat()
            -- make chat windows transparent
        for i = 1, NUM_CHAT_WINDOWS do
            SetChatWindowAlpha(i, 0)
        end

            -- style
        for _, v in pairs(CHAT_FRAMES) do
            local chat = _G[v]
            if chat and not chat.styled then
                StyleChat(chat:GetName())

                local convButton = _G[chat:GetName()..'ConversationButton']
                if convButton then
                    convButton:SetAlpha(0)
                    convButton:EnableMouse(false)
                end

                local chatMinimize = _G[chat:GetName()..'ButtonFrameMinimizeButton']
                if chatMinimize then
                    chatMinimize:SetAlpha(0)
                    chatMinimize:EnableMouse(0)
                end
                chat.styled = true
            end
        end
    end

    hooksecurefunc('FCF_OpenTemporaryWindow', StyleTheChat)
    StyleTheChat()
