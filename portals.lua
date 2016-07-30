Portals = LibStub("AceAddon-3.0"):NewAddon("Portals", "AceConsole-3.0", "AceEvent-3.0")
--local dewdrop = LibStub('Dewdrop-2.0', true)
local icon = LibStub('LibDBIcon-1.0')
local LibQTip = LibStub('LibQTip-1.0')


local addonName, addonTable = ...
local L = addonTable.L


local PortalsLDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(addonName, {
	type = "data source",
	text = L['P'],
	icon = "Interface\\Icons\\INV_Misc_Rune_06",
	OnEnter = function(self) Portals:OnEnter(self) end,
})


-- IDs of items usable for transportation
local items = {
    -- Dalaran rings
    40586,  -- Band of the Kirin Tor
    48954,  -- Etched Band of the Kirin Tor
    48955,  -- Etched Loop of the Kirin Tor
    48956,  -- Etched Ring of the Kirin Tor
    48957,  -- Etched Signet of the Kirin Tor
    45688,  -- Inscribed Band of the Kirin Tor
    45689,  -- Inscribed Loop of the Kirin Tor
    45690,  -- Inscribed Ring of the Kirin Tor
    45691,  -- Inscribed Signet of the Kirin Tor
    44934,  -- Loop of the Kirin Tor
    44935,  -- Ring of the Kirin Tor
    40585,  -- Signet of the Kirin Tor
    51560,  -- Runed Band of the Kirin Tor
    51558,  -- Runed Loop of the Kirin Tor
    51559,  -- Runed Ring of the Kirin Tor
    51557,  -- Runed Signet of the Kirin Tor
    -- Engineering Gadgets
    30542,  -- Dimensional Ripper - Area 52
    18984,  -- Dimensional Ripper - Everlook
    18986,  -- Ultrasafe Transporter: Gadgetzan
    30544,  -- Ultrasafe Transporter: Toshley's Station
    48933,  -- Wormhole Generator: Northrend
    87215,  -- Wormhole Generator: Pandaria
    112059, -- Wormhole Centrifuge
    -- Seasonal items
    37863,  -- Direbrew's Remote
    21711,  -- Lunar Festival Invitation
    -- Miscellaneous
    46874,  -- Argent Crusader's Tabard
    32757,  -- Blessed Medallion of Karabor
    35230,  -- Darnarian's Scroll of Teleportation
    50287,  -- Boots of the Bay
    52251,  -- Jaina's Locket
    43824,  -- The Schools of Arcane Magic - Mastery
    58487,  -- Potion of Deepholm
    65274,  -- Cloak of Coordination (Horde)
    65360,  -- Cloak of Coordination (Alliance)
    63378,  -- Hellscream's Reach Tabard
    63379,  -- Baradin's Wardens Tabard
    64457,  -- The Last Relic of Argus
    63206,  -- Wrap of Unity (Alliance)
    63207,  -- Wrap of Unity (Horde)
    63352,  -- Shroud of Cooperation (Alliance)
    63353,  -- Shroud of Cooperation (Horde)
    95050,  -- The Brassiest Knuckle (Horde)
    95051,  -- The Brassiest Knuckle (Alliance)
    95567,  -- Kirin Tor Beacon
    95568,  -- Sunreaver Beacon
    17690,  -- Frostwolf Insignia Rank 1 (Horde)
    17905,  -- Frostwolf Insignia Rank 2 (Horde)
    17906,  -- Frostwolf Insignia Rank 3 (Horde)
    17907,  -- Frostwolf Insignia Rank 4 (Horde)
    17908,  -- Frostwolf Insignia Rank 5 (Horde)
    17909,  -- Frostwolf Insignia Rank 6 (Horde)
    17691,  -- Stormpike Insignia Rank 1 (Alliance)
    17900,  -- Stormpike Insignia Rank 2 (Alliance)
    17901,  -- Stormpike Insignia Rank 3 (Alliance)
    17902,  -- Stormpike Insignia Rank 4 (Alliance)
    17903,  -- Stormpike Insignia Rank 5 (Alliance)
    17904,  -- Stormpike Insignia Rank 6 (Alliance)
    22631,  -- Atiesh, Greatstaff of the Guardian
    87548,  -- Lorewalker's Lodestone
    54452,  -- Ethereal Portal
    93672,  -- Dark Portal
    103678, -- Time-Lost Artifact
    110560, -- Garrison Hearthstone
    118662, -- Bladespire Relic
    118663, -- Relic of Karabor
    118907, -- Pit Fighter's Punching Ring
    128353, -- Admiral's Compass
    128502, -- Hunter's Seeking Crystal
    128503,  -- Master Hunter's Seeking Crystal
	136849	-- Nature's Beacon
}

-- IDs of items usable instead of hearthstone
local scrolls = {
    64488, -- The Innkeeper's Daughter
    28585, -- Ruby Slippers
    6948,  -- Hearthstone
    44315, -- Scroll of Recall III
    44314, -- Scroll of Recall II
    37118  -- Scroll of Recall
}

-- Gold Challenge portals
local challengeSpells = {
    { 131204, 'TRUE' }, -- Path of the Jade Serpent
    { 131205, 'TRUE' }, -- Path of the Stout Brew
    { 131206, 'TRUE' }, -- Path of the Shado-Pan
    { 131222, 'TRUE' }, -- Path of the Mogu King
    { 131225, 'TRUE' }, -- Path of the Setting Sun
    { 131231, 'TRUE' }, -- Path of the Scarlet Blade
    { 131229, 'TRUE' }, -- Path of the Scarlet Mitre
    { 131232, 'TRUE' }, -- Path of the Necromancer
    { 131228, 'TRUE' }, -- Path of the Black Ox
    { 159895, 'TRUE' }, -- Path of the Bloodmaul
    { 159896, 'TRUE' }, -- Path of the Iron Prow
    { 159897, 'TRUE' }, -- Path of the Vigilant
    { 159898, 'TRUE' }, -- Path of the Skies
    { 159899, 'TRUE' }, -- Path of the Crescent Moon
    { 159900, 'TRUE' }, -- Path of the Dark Rail	
    { 159901, 'TRUE' }, -- Path of the Verdant
    { 159902, 'TRUE' } -- Path of the Burning Mountain
}


local classPortals

local function SetupSpells()
    local spells = {
        Alliance = {
            { 3561, 'TP' },   -- Teleport:Stormwind
            { 3562, 'TP' },   -- Teleport:Ironforge
            { 3565, 'TP' },   -- Teleport:Darnassus
            { 32271, 'TP' },  -- Teleport:Exodar
            { 49359, 'TP' },  -- Teleport:Theramore
            { 33690, 'TP' },  -- Teleport:Shattrath
            { 53140, 'TP' },  -- Teleport:Dalaran
            { 88342, 'TP' },  -- Teleport:Tol Barad
            { 132621, 'TP' }, -- Teleport:Vale of Eternal Blossoms
            { 120145, 'TP' }, -- Teleport:Ancient Dalaran
            { 176248, 'TP' }, -- Teleport:StormShield
            { 10059, 'P' },   -- Portal:Stormwind
            { 11416, 'P' },   -- Portal:Ironforge
            { 11419, 'P' },   -- Portal:Darnassus
            { 32266, 'P' },   -- Portal:Exodar
            { 49360, 'P' },   -- Portal:Theramore
            { 33691, 'P' },   -- Portal:Shattrath
            { 53142, 'P' },   -- Portal:Dalaran
            { 88345, 'P' },   -- Portal:Tol Barad
            { 120146, 'P' },  -- Portal:Ancient Dalaran
            { 132620, 'P' },  -- Portal:Vale of Eternal Blossoms
            { 176246, 'P' }   -- Portal:StormShield
        },
        Horde = {
            { 3563, 'TP' },   -- Teleport:Undercity
            { 3566, 'TP' },   -- Teleport:Thunder Bluff
            { 3567, 'TP' },   -- Teleport:Orgrimmar
            { 32272, 'TP' },  -- Teleport:Silvermoon
            { 49358, 'TP' },  -- Teleport:Stonard
            { 35715, 'TP' },  -- Teleport:Shattrath
            { 53140, 'TP' },  -- Teleport:Dalaran
            { 88344, 'TP' },  -- Teleport:Tol Barad
            { 132627, 'TP' }, -- Teleport:Vale of Eternal Blossoms
            { 120145, 'TP' }, -- Teleport:Ancient Dalaran
            { 176242, 'TP' }, -- Teleport:Warspear
            { 11418, 'P' },   -- Portal:Undercity
            { 11420, 'P' },   -- Portal:Thunder Bluff
            { 11417, 'P' },   -- Portal:Orgrimmar
            { 32267, 'P' },   -- Portal:Silvermoon
            { 49361, 'P' },   -- Portal:Stonard
            { 35717, 'P' },   -- Portal:Shattrath
            { 53142, 'P' },   -- Portal:Dalaran
            { 88346, 'P' },   -- Portal:Tol Barad
            { 120146, 'P' },  -- Portal:Ancient Dalaran
            { 132626, 'P' },  -- Portal:Vale of Eternal Blossoms
            { 176244, 'P' }   -- Portal:Warspear
        }
    }

    local _, class = UnitClass('player')
    if class == 'MAGE' then
        classPortals = spells[select(1, UnitFactionGroup('player'))]
    elseif class == 'DEATHKNIGHT' then
        classPortals = {
            { 50977, 'TRUE' } -- Death Gate
        }
    elseif class == 'DRUID' then
        classPortals = {
            { 18960,  'TRUE' }, -- Teleport:Moonglade
            { 147420, 'TRUE' }  -- Teleport:One with Nature
        }
    elseif class == 'SHAMAN' then
        classPortals = {
            { 556, 'TRUE' } -- Astral Recall
        }
    elseif class == 'MONK' then
        classPortals = {
            { 126892, 'TRUE' }, -- Zen Pilgrimage
            { 126895, 'TRUE' }  -- Zen Pilgrimage: Return
        }
    else
        classPortals = {}
    end

 --   spells table wipe
 wipe(spells)
end



local function pairsByKeys(t)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a)

    local i = 0
    local iter = function()
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end

local function tconcat(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

function findSpell(spellName)
    local i = 1
    while true do
        local s = GetSpellBookItemName(i, BOOKTYPE_SPELL)
        if not s then
            break
        end

        if s == spellName then
            return i
        end

        i = i + 1
    end
end

-- returns true, if player has item with given ID in inventory or bags and it's not on cooldown
local function hasItem(itemID)
    local item, found, id
    -- scan inventory
    for slotId = 1, 19 do
        item = GetInventoryItemLink('player', slotId)
        if item then
            found, _, id = item:find('^|c%x+|Hitem:(%d+):.+')
            if found and tonumber(id) == itemID then
                if GetInventoryItemCooldown('player', slotId) ~= 0 then
                    return false
                else
                    return true
                end
            end
        end
    end
    -- scan bags
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            item = GetContainerItemLink(bag, slot)
            if item then
                found, _, id = item:find('^|c%x+|Hitem:(%d+):.+')
                if found and tonumber(id) == itemID then
                    if GetContainerItemCooldown(bag, slot) ~= 0 then
                        return false
                    else
                        return true
                    end
                end
            end
        end
    end
	-- check Toybox
	if PlayerHasToy(itemID) then
		if C_ToyBox.IsToyUsable(itemID) then
			local startTime, duration, cooldown
			startTime, duration = GetItemCooldown(itemID)
			cooldown = duration - (GetTime() - startTime)
			if not cooldown == 0 then
				return false
			else
				return true
			end
		else
			return false
		end
	end
	
    return false
end


local methods = {}

local function GenerateLinks(spells)
    local itemsGenerated = 0

    for _, unTransSpell in ipairs(spells) do
        if IsPlayerSpell(unTransSpell[1]) then
            local spell, _, spellIcon = GetSpellInfo(unTransSpell[1])
            local spellid = findSpell(spell)

            if spellid then
                methods[spell] = {
                    spellid = spellid,
                    text = spell,
                    spellIcon = spellIcon,
                    isPortal = unTransSpell[2] == 'P',
                    secure = {
                        type = 'spell',
                        spell = spell
                    }
                }
                itemsGenerated = itemsGenerated + 1
            end
        end
    end

    return itemsGenerated
end

function Portals:UpdateClassSpells()
    if not classPortals then
        SetupSpells()
    end

    if classPortals then
        return GenerateLinks(classPortals)
    end
end

function Portals:UpdateChallengeSpells()
    return GenerateLinks(challengeSpells)
end

local function UpdateIcon(icon)
    PortalsLDB.icon = icon
end


local function ShowHearthstone()
    local bindLoc = GetBindLocation()
    local secure, text, icon, name

	for i = 1, #scrolls do
        if hasItem(scrolls[i]) then
            name, _, _, _, _, _, _, _, _, icon = GetItemInfo(scrolls[i])
            text = L['INN'] .. ' ' .. bindLoc
            secure = {
                type = 'item',
                item = name
            }
            break
        end
    end

    if secure ~= nil then
        dewdrop:AddLine('text', text,
            'secure', secure,
            'icon', tostring(icon),
            'func', function() UpdateIcon(icon) end,
            'closeWhenClicked', true)
        dewdrop:AddLine()
    end
end

local function ShowOtherItems()
	for i = 1, #items do
        if hasItem(itemID[i]) then
            local name, _, quality, _, _, _, _, _, _, icon = GetItemInfo(itemID[i])
            local secure = {
                type = 'item',
                item = name
            }

            dewdrop:AddLine(
                'text', name,
                'textR', ITEM_QUALITY_COLORS[quality].r,
                'textG', ITEM_QUALITY_COLORS[quality].g,
                'textB', ITEM_QUALITY_COLORS[quality].b,
                'secure', secure,
                'icon', tostring(icon),
                'func', function() UpdateIcon(icon) end,
                'closeWhenClicked', true)
        end
    end
	dewdrop:AddLine()
end

--[[
local function UpdateMenu(level, value)
    if level == 1 then
        dewdrop:AddLine('text', 'Broker Portals',
            'isTitle', true)

        methods = {}
        local spells = Portals:UpdateClassSpells()
        if spells > 0 then
          dewdrop:AddLine()
        end
        local challengeSpells = Portals:UpdateChallengeSpells()
        if challengeSpells > 0 then
          dewdrop:AddLine()
        end

        local chatType = (UnitInRaid("player") and "RAID") or (GetNumGroupMembers() > 0 and "PARTY") or nil
        local announce = PortalsDB.announce
        for k, v in pairsByKeys(methods) do
            if v.secure and GetSpellCooldown(v.text) == 0 then
                dewdrop:AddLine(
                    'text', v.text,
                    'secure', v.secure,
                    'icon', tostring(v.spellIcon),
                    'func', function()
                        UpdateIcon(v.spellIcon)
                        if announce and v.isPortal and chatType then
                            SendChatMessage(L['ANNOUNCEMENT'] .. ' ' .. v.text, chatType)
                        end
                    end,
                    'closeWhenClicked', true)
            end
        end

        dewdrop:AddLine()

        ShowHearthstone()

        if PortalsDB.showItems then
            ShowOtherItems()
        end

        dewdrop:AddLine('text', L['OPTIONS'],
            'hasArrow', true,
            'value', 'options')

        dewdrop:AddLine('text', CLOSE,
            'tooltipTitle', CLOSE,
            'tooltipText', CLOSE_DESC,
            'closeWhenClicked', true)
    elseif level == 2 and value == 'options' then
        dewdrop:AddLine('text', L['SHOW_ITEMS'],
            'checked', PortalsDB.showItems,
            'func', function() PortalsDB.showItems = not PortalsDB.showItems end,
            'closeWhenClicked', true)
        dewdrop:AddLine('text', L['SHOW_ITEM_COOLDOWNS'],
            'checked', PortalsDB.showItemCooldowns,
            'func', function() PortalsDB.showItemCooldowns = not PortalsDB.showItemCooldowns end,
            'closeWhenClicked', true)
        dewdrop:AddLine('text', L['ATT_MINIMAP'],
            'checked', not PortalsDB.minimap.hide,
            'func', function() ToggleMinimap() end,
            'closeWhenClicked', true)
        dewdrop:AddLine('text', L['ANNOUNCE'],
            'checked', PortalsDB.announce,
            'func', function() PortalsDB.announce = not PortalsDB.announce end,
            'closeWhenClicked', true)
    end
end

]]--

--[[
		for i = 1, #PortalsItems do
		local itemID = PortalsItems.itemID[i],
			  Faction = PortalsItems.Faction[i],
			  Class = PortalsItems.Class[i],
			  TeleOrPort = PortalsItems.TeleOrPort[i],
			  isCMMOP = PortalsItems.isCMMOP[i],
			  isCMWOD = PortalsItems.isCMWOD[i],
			  isHearth = PortalsItems.isHearth[i]
]]--


function Portals:GetCooldown(start, duration)
	local timeRem = SecondsToTime(duration-(GetTime()-start))
	if (duration-(GetTime()-start)) < 60 then timeRem = SecondsToTime(duration-(GetTime()-start)) end
	return timeRem
end


function Portals:OnEnter(self)
if InCombatLockdown() then return end
local itemTooltip = LibQTip:Acquire("Portals_EntTooltip", 1, "LEFT") 
self.itemTooltip = itemTooltip
	if itemTooltip:IsShown() then
		LibQTip:Release(self.itemTooltip)
		self.itemTooltip = nil	
		for i = 1, #PortalsItems.itemID do
			local itemPortalsBTN = _G["Portals_brokerBtn"..i]
			if itemPortalsBTN then itemPortalsBTN:Hide() end
		end
	else
		itemTooltip:EnableMouse(true)
		itemTooltip:SetAutoHideDelay(0.5, self)
		itemTooltip:SmartAnchorTo(self)
		itemTooltip:Clear()
		
		itemTooltip:SetColumnLayout(2, "LEFT", "RIGHT")
		itemTooltip:AddHeader('Portals')
		itemTooltip:SetLineTextColor(1,0,0.7,1)
		itemTooltip:AddSeparator(1,0,0.5,1)
		itemTooltip:AddLine('Left-click menu items to use')
		itemTooltip:AddSeparator(1,0,0.5,1)
		local headerCount = itemTooltip:GetLineCount()
		local hearthBind = GetBindLocation()
		
		for i = 1, #PortalsItems.itemID do
			if GetItemCount(PortalsItems.itemID[i]) > 0 or PlayerHasToy(PortalsItems.itemID[i]) then
				if C_ToyBox.IsToyUsable(PortalsItems.itemID[i]) then				
					local start, duration = GetItemCooldown(PortalsItems.itemID[i])
					local itemName, _, itemQuality, _, _, _, _, _, _, itemIcon = GetItemInfo(PortalsItems.itemID[i])
					local r,g,b = ITEM_QUALITY_COLORS[itemQuality].r,ITEM_QUALITY_COLORS[itemQuality].g,ITEM_QUALITY_COLORS[itemQuality].b
					local numRow = itemTooltip:GetLineCount()+1
						if PortalsItems.isHearth[i] then
							itemTooltip:AddLine("|T"..itemIcon..":14:14:0:0:64:64:5:59:5:59|t "..itemName..": "..hearthBind)
							itemTooltip:SetLineTextColor(numRow,r,g,b,1)
						elseif start == 0 then 
							itemTooltip:AddLine("|T"..itemIcon..":14:14:0:0:64:64:5:59:5:59|t "..itemName)
							itemTooltip:SetLineTextColor(numRow,r,g,b,1)
						else
							local itemTime = Portals:GetCooldown(start, duration)
							itemTooltip:AddLine("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:14:14:0:0:64:64:5:59:5:59|t "..itemName, "("..itemTime..")")  
							itemTooltip:SetCellTextColor(numRow,1,0.5,0.5,0.5,1)
							itemTooltip:SetCellTextColor(numRow,2,1,1,0,1)
						end
	
	
					itemTooltip:SetLineScript(numRow, "OnEnter", function(tt)
						local itemPortalsBTN = _G["Portals_brokerBtn"..(numRow-headerCount)]
							if not itemPortalsBTN then
								itemPortalsBTN = CreateFrame("Button", "Portals_brokerBtn"..(numRow-headerCount), UIParent, "SecureActionButtonTemplate")
							end
						itemPortalsBTN:SetAttribute("type", "item")
						itemPortalsBTN:SetAttribute("item", itemName)
						itemPortalsBTN:SetFrameStrata(tt:GetFrameStrata())
						itemPortalsBTN:SetFrameLevel(tt:GetFrameLevel()+1)
						itemPortalsBTN:SetAllPoints(tt)
						itemPortalsBTN:Show()
						
						itemPortalsBTN:SetScript("OnEnter", function()
							local itemTooltip = LibQTip:Acquire("Portals_EntTooltip", 1, "LEFT")
								if itemTooltip:IsShown() then
									local start, duration = GetItemCooldown(PortalsItems.itemID[i])
									local itemTime = Portals:GetCooldown(start, duration)
										if PortalsItems.isHearth[i] then
											itemTooltip:SetCell(numRow, 1, "|T"..itemIcon..":14:14:0:0:64:64:5:59:5:59|t "..itemName..": "..hearthBind)
											itemTooltip:SetLineTextColor(numRow,1,1,0); itemPortalsBTN:RegisterForClicks("LeftButtonUp")
										elseif start == 0 or itemTime == "" then
											itemTooltip:SetCell(numRow, 1, "|T"..itemIcon..":14:14:0:0:64:64:5:59:5:59|t "..itemName)
											itemTooltip:SetLineTextColor(numRow,1,1,0); itemPortalsBTN:RegisterForClicks("LeftButtonUp")
										else 
											itemTooltip:SetCell(numRow, 1, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:14:14:0:0:64:64:5:59:5:59|t "..itemName)
											itemTooltip:SetCellTextColor(numRow,1,0.5,0.5,0.5,1); itemPortalsBTN:RegisterForClicks()
											itemTooltip:SetCell(numRow, 2, "("..itemTime..")")
											itemTooltip:SetCellTextColor(numRow,2,1,1,0,1); itemPortalsBTN:RegisterForClicks()
										end
								end 
						end)
						
						itemPortalsBTN:SetScript("OnLeave", function()
							local itemTooltip = LibQTip:Acquire("Portals_EntTooltip", 1, "LEFT")
								if itemTooltip:IsShown() then
									local start, duration = GetItemCooldown(PortalsItems.itemID[i])
									local itemTime = Portals:GetCooldown(start, duration)
										if PortalsItems.isHearth[i] then
											itemTooltip:SetCell(numRow, 1, "|T"..itemIcon..":14:14:0:0:64:64:5:59:5:59|t "..itemName..": "..hearthBind)
											itemTooltip:SetLineTextColor(numRow,r,g,b,1); itemPortalsBTN:RegisterForClicks("LeftButtonUp")
										elseif start == 0 or itemTime == "" then
											itemTooltip:SetCell(numRow, 1, "|T"..itemIcon..":14:14:0:0:64:64:5:59:5:59|t "..itemName)
											itemTooltip:SetLineTextColor(numRow,r,g,b,1); itemPortalsBTN:RegisterForClicks("LeftButtonUp")
										else 
											itemTooltip:SetCell(numRow, 1, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:14:14:0:0:64:64:5:59:5:59|t "..itemName)
											itemTooltip:SetCellTextColor(numRow,1,0.5,0.5,0.5,1); itemPortalsBTN:RegisterForClicks()
											itemTooltip:SetCell(numRow, 2, "("..itemTime..")")
											itemTooltip:SetCellTextColor(numRow,2,1,1,0,1); itemPortalsBTN:RegisterForClicks()
										end
								end
						end)	
					end, tt)	
				end
			end

		if IsPlayerSpell(PortalsItems.itemID[i]) then
		if UnitAura("player", "Zen Pilgrimage: Return") then
			PortalsItems.itemID[i] = 126895
		elseif PortalsItems.itemID[i] == 126895 then
			PortalsItems.itemID[i] = 126892
		end		
		local start, duration = GetSpellCooldown(PortalsItems.itemID[i])
		local spellName, _, spellIcon = GetSpellInfo(PortalsItems.itemID[i])
		local numSPRow = itemTooltip:GetLineCount()+1
						if PortalsItems.isHearth[i] then
							itemTooltip:AddLine("|T"..spellIcon..":14:14:0:0:64:64:5:59:5:59|t "..spellName..": "..hearthBind)
							itemTooltip:SetLineTextColor(numSPRow,1,1,1,1)
						elseif start == 0 then 
							itemTooltip:AddLine("|T"..spellIcon..":14:14:0:0:64:64:5:59:5:59|t "..spellName)
							itemTooltip:SetLineTextColor(numSPRow,1,1,1,1)
						else
							local spellTime = Portals:GetCooldown(start, duration)
							itemTooltip:AddLine("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:14:14:0:0:64:64:5:59:5:59|t "..spellName, "("..spellTime..")")  
							itemTooltip:SetCellTextColor(numSPRow,1,0.5,0.5,0.5,1)
							itemTooltip:SetCellTextColor(numSPRow,2,1,1,0,1)
						end
						
						
							itemTooltip:SetLineScript(numSPRow, "OnEnter", function(tdk)
						local itemPortalsBTN = _G["Portals_brokerBtn"..(numSPRow-headerCount)]
							if not itemPortalsBTN then
								itemPortalsBTN = CreateFrame("Button", "Portals_brokerBtn"..(numSPRow-headerCount), UIParent, "SecureActionButtonTemplate")
							end
						itemPortalsBTN:SetAttribute("type", "spell")
						itemPortalsBTN:SetAttribute("spell", spellName)
						itemPortalsBTN:SetFrameStrata(tdk:GetFrameStrata())
						itemPortalsBTN:SetFrameLevel(tdk:GetFrameLevel()+1)
						itemPortalsBTN:SetAllPoints(tdk)
						itemPortalsBTN:Show()
						
						itemPortalsBTN:SetScript("OnEnter", function()
							local itemTooltip = LibQTip:Acquire("Portals_EntTooltip", 1, "LEFT")
								if itemTooltip:IsShown() then
									local start, duration = GetSpellCooldown(PortalsItems.itemID[i])
									local spellTime = Portals:GetCooldown(start, duration)
										if PortalsItems.isHearth[i] then
											itemTooltip:SetCell(numSPRow, 1, "|T"..spellIcon..":14:14:0:0:64:64:5:59:5:59|t "..spellName..": "..hearthBind)
											itemTooltip:SetLineTextColor(numSPRow,1,1,0); itemPortalsBTN:RegisterForClicks("LeftButtonUp")
										elseif start == 0 or spellTime == "" then
											itemTooltip:SetCell(numSPRow, 1, "|T"..spellIcon..":14:14:0:0:64:64:5:59:5:59|t "..spellName)
											itemTooltip:SetLineTextColor(numSPRow,1,1,0); itemPortalsBTN:RegisterForClicks("LeftButtonUp")
										else
											itemTooltip:SetCell(numSPRow, 1, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:14:14:0:0:64:64:5:59:5:59|t "..spellName)
											itemTooltip:SetCellTextColor(numSPRow,1,0.5,0.5,0.5,1); itemPortalsBTN:RegisterForClicks()
											itemTooltip:SetCell(numSPRow, 2, "("..spellTime..")")
											itemTooltip:SetCellTextColor(numSPRow,2,1,1,0,1); itemPortalsBTN:RegisterForClicks()
										end
								end 
						end)
						
						itemPortalsBTN:SetScript("OnLeave", function()
							local itemTooltip = LibQTip:Acquire("Portals_EntTooltip", 1, "LEFT")
								if itemTooltip:IsShown() then
									local start, duration = GetSpellCooldown(PortalsItems.itemID[i])
									local spellTime = Portals:GetCooldown(start, duration)
										if PortalsItems.isHearth[i] then
											itemTooltip:SetCell(numSPRow, 1, "|T"..spellIcon..":14:14:0:0:64:64:5:59:5:59|t "..spellName..": "..hearthBind)
											itemTooltip:SetLineTextColor(numSPRow,1,1,1); itemPortalsBTN:RegisterForClicks("LeftButtonUp")
										elseif start == 0 or spellTime == "" then
											itemTooltip:SetCell(numSPRow, 1, "|T"..spellIcon..":14:14:0:0:64:64:5:59:5:59|t "..spellName)
											itemTooltip:SetLineTextColor(numSPRow,1,1,1,1); itemPortalsBTN:RegisterForClicks("LeftButtonUp")
										else
											itemTooltip:SetCell(numSPRow, 1, "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:14:14:0:0:64:64:5:59:5:59|t "..spellName)
											itemTooltip:SetCellTextColor(numSPRow,1,0.5,0.5,0.5,1); itemPortalsBTN:RegisterForClicks()
											itemTooltip:SetCell(numSPRow, 2, "("..spellTime..")")
											itemTooltip:SetCellTextColor(numSPRow,2,1,1,0,1); itemPortalsBTN:RegisterForClicks()
										end
								end
						end)	
					end, tdk)	
		end
				
		end

		itemTooltip:Show()
		itemTooltip.OnRelease = function()
			LibQTip:Release(itemTooltip)
			itemTooltip = nil
			for i = 1, #PortalsItems.itemID do
				local itemPortalsBTN = _G["Portals_brokerBtn"..i]
					if itemPortalsBTN then
						itemPortalsBTN:Hide()
					end
			end
		end
	end
end


--[[
local function Portals:OptionTooltip(self)

OptTooltip = LibQTip:Acquire("BrokerMountsTooltip2", 1, "LEFT") 
self.OptTooltip = OptTooltip

OptTooltip:SmartAnchorTo(self)
OptTooltip:Clear() 





if EntTooltip and EntTooltip:IsShown() then
	LibQTip:Release(self.OptTooltip)
	self.OptTooltip = nil
else
	OptTooltip:Show()
end

end
]]--



--[[
function PortalsLDB.OnClick(self, button)
   GameTooltip:Hide()
   GameTooltip:ClearAllPoints()
   if InCombatLockdown() then return end
    if button == 'RightButton' then
        dewdrop:Open(self, 'children', function(level, value) UpdateMenu(level, value) end)
    end
end


function PortalsLDB.OnTooltipShow(GameTooltip)


    GameTooltip:AddLine('Broker Portals')
    GameTooltip:AddDoubleLine(L['RCLICK'], L['SEE_SPELLS'], 0.9, 0.6, 0.2, 0.2, 1, 0.2)
	
    GameTooltip:AddLine(' ')
	
	if PortalsDB.showItems then
		
		for i = 1, #scrolls do
	        if GetItemCount(scrolls[i]) > 0 or PlayerHasToy(scrolls[i]) then
			    if C_ToyBox.IsToyUsable(scrolls[i]) then
				local start, duration = GetItemCooldown(scrolls[i])
				local _, _, hearthQuality, _, _, _, _, _, _, hearthIcon = GetItemInfo(scrolls[i])
				
					if not PortalsDB.showItemCooldowns then
						GameTooltip:AddLine("|T" .. hearthIcon .. ":16:16:0:0:64:64:5:59:5:59|t " .. L['HEARTHSTONE'] .. ': ' .. GetBindLocation(), ITEM_QUALITY_COLORS[hearthQuality].r, ITEM_QUALITY_COLORS[hearthQuality].g, ITEM_QUALITY_COLORS[hearthQuality].b)
					elseif start == 0 then
						GameTooltip:AddDoubleLine("|T" .. hearthIcon .. ":16:16:0:0:64:64:5:59:5:59|t " .. L['HEARTHSTONE'] .. ': ' .. GetBindLocation(), L['READY'], ITEM_QUALITY_COLORS[hearthQuality].r, ITEM_QUALITY_COLORS[hearthQuality].g, ITEM_QUALITY_COLORS[hearthQuality].b, 0.2, 1, 0.2) -- ready green					
					else
					    local scrollTime = Portals:GetCooldown(start, duration)
						GameTooltip:AddDoubleLine("|T" .. hearthIcon .. ":16:16:0:0:64:64:5:59:5:59|t " .. L['HEARTHSTONE'] .. ': ' .. GetBindLocation(), scrollTime, ITEM_QUALITY_COLORS[hearthQuality].r, ITEM_QUALITY_COLORS[hearthQuality].g, ITEM_QUALITY_COLORS[hearthQuality].b, 1, 1, 0.2) -- countdown yellow
					end	
			    end
 			end
		end
			
		for j = 1, #items do
    	    if GetItemCount(items[j]) > 0 or PlayerHasToy(items[j]) then
			    if C_ToyBox.IsToyUsable(items[j]) then
				local start, duration = GetItemCooldown(items[j])
				local itemName, _, itemQuality, _, _, _, _, _, _, itemIcon = GetItemInfo(items[j])
				
					if not PortalsDB.showItemCooldowns then
						GameTooltip:AddLine("|T" .. itemIcon .. ":16:16:0:0:64:64:5:59:5:59|t " .. itemName, ITEM_QUALITY_COLORS[itemQuality].r, ITEM_QUALITY_COLORS[itemQuality].g, ITEM_QUALITY_COLORS[itemQuality].b)
					elseif start == 0 then
						GameTooltip:AddDoubleLine("|T" .. itemIcon .. ":16:16:0:0:64:64:5:59:5:59|t " .. itemName, L['READY'], ITEM_QUALITY_COLORS[itemQuality].r, ITEM_QUALITY_COLORS[itemQuality].g, ITEM_QUALITY_COLORS[itemQuality].b, 0.2, 1, 0.2) -- ready green
					else
						local itemTime = Portals:GetCooldown(start, duration)
						GameTooltip:AddDoubleLine("|T" .. itemIcon .. ":16:16:0:0:64:64:5:59:5:59|t " .. itemName, itemTime, ITEM_QUALITY_COLORS[itemQuality].r, ITEM_QUALITY_COLORS[itemQuality].g, ITEM_QUALITY_COLORS[itemQuality].b, 1, 1, 0.2) -- countdown yellow
					end	
				end
 			end
		end
	

    GameTooltip:AddLine(' ')
	
		-- MOP CM Tooltip
		if IsPlayerSpell(131204) then
			local start, duration = GetItemCooldown(131204)
			local itemIcon = select(10, GetItemInfo(131204))
				
			if not PortalsDB.showItemCooldowns then
				GameTooltip:AddLine('Challenge Mode MoP', 0.9, 0.6, 0.2)
			elseif start == 0 then
				GameTooltip:AddDoubleLine('Challenge Mode MoP', L['READY'], 0.9, 0.6, 0.2, 0.2, 1, 0.2) -- ready green
			else
				local CMMOPTime = Portals:GetCooldown(start, duration)
				GameTooltip:AddDoubleLine('Challenge Mode MoP', CMMOPTime, 0.9, 0.6, 0.2, 1, 1, 0.2) -- countdown yellow
			end	
	
		elseif IsPlayerSpell(159898) then
	
		-- WOD CM Tooltip
			local start, duration = GetItemCooldown(159898)
			local itemIcon = select(10, GetItemInfo(159898))
				
			if not PortalsDB.showItemCooldowns then
				GameTooltip:AddLine('Challenge Mode WoD', 0.9, 0.6, 0.2)
			elseif start == 0 then
				GameTooltip:AddDoubleLine('Challenge Mode WoD', L['READY'], 0.9, 0.6, 0.2, 0.2, 1, 0.2) -- ready green
			else
				local CMWODTime = Portals:GetCooldown(start, duration)
				GameTooltip:AddDoubleLine('Challenge Mode WoD', CMWODTime, 0.9, 0.6, 0.2, 1, 1, 0.2) -- countdown yellow
			end	
		
		end
		
    end
	
end
]]--

local function ToggleMinimap()
    PortalsDB.minimap.hide = not PortalsDB.minimap.hide
    if PortalsDB.minimap.hide then
        icon:Hide('Broker_Portals')
    else
        icon:Show('Broker_Portals')
    end
end


-- slash command definition
SlashCmdList['BROKER_PORTALS'] = function() ToggleMinimap() end
SLASH_BROKER_PORTALS1 = '/portals'

function Portals:PLAYER_ENTERING_WORLD()
	if InCombatLockdown() then return end
    -- PortalsDB.minimap is there for smooth upgrade of SVs from old version
    if (not PortalsDB) or (PortalsDB.version == nil) then
        PortalsDB = {}
        PortalsDB.minimap = {}
        PortalsDB.minimap.hide = false
        PortalsDB.showItems = true
        PortalsDB.showItemCooldowns = true
        PortalsDB.announce = false
        PortalsDB.version = 4
    end

    -- upgrade from versions
    if PortalsDB.version == 3 then
        PortalsDB.announce = false
        PortalsDB.version = 4
    elseif PortalsDB.version == 2 then
        PortalsDB.showItemCooldowns = true
        PortalsDB.announce = false
        PortalsDB.version = 4
    elseif PortalsDB.version < 2 then
        PortalsDB.showItems = true
        PortalsDB.showItemCooldowns = true
        PortalsDB.announce = false
        PortalsDB.version = 4
    end

    if icon then
        icon:Register('Broker_Portals', PortalsLDB, PortalsDB.minimap)
    end
    self:UnregisterEvent('PLAYER_ENTERING_WORLD')
end

function Portals:SKILL_LINES_CHANGED()
    Portals:UpdateClassSpells()
    Portals:UpdateChallengeSpells()
	self:UnregisterEvent('SKILL_LINES_CHANGED')
end


function Portals:OnInitialize()
self:RegisterEvent("PLAYER_ENTERING_WORLD", "PLAYER_ENTERING_WORLD")
self:RegisterEvent("SKILL_LINES_CHANGED", "SKILL_LINES_CHANGED")

end