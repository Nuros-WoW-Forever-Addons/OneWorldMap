-- OneWorldMap: Pins.lua
-- Custom canvas Point-of-Interest (POI) pins provider for WorldMapFrame:
-- Flight Masters, Quest Givers (with low-level quest filtering), Banks,
-- Class & Profession Trainers, and Vendors (General bag icon vs Repair anvil icon).

local OneWorldMap = OneWorldMap or {}
OneWorldMap.Pins = OneWorldMap.Pins or {}

local Pins = OneWorldMap.Pins

-- Texture definitions
local PIN_TEXTURES = {
    flight = "Interface\\Minimap\\Tracking\\FlightMaster",
    questNormal = "Interface\\GossipFrame\\AvailableQuestIcon",
    questLowLevel = "Interface\\Minimap\\Tracking\\TrivialQuests",
    bank = "Interface\\Minimap\\Tracking\\Banker",
    trainerClass = "Interface\\Minimap\\Tracking\\Class",
    trainerProf = "Interface\\Minimap\\Tracking\\Profession",
    vendor = "Interface\\Buttons\\Button-Backpack-Up",
    vendorRepair = "Interface\\Minimap\\Tracking\\Repair",
}

-- Pin Frame Management (Canvas-Anchored)
local activePins = {}
local pinPool = {}

local function OnPinEnter(self)
    local data = self.poiData
    if not data then return end

    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")

    -- Title
    local titleText = data.name or data.title or "Point of Interest"
    if data.type == "quest" and data.title then
        titleText = string.format("[%d] %s", data.level or 1, data.title)
    end
    GameTooltip:SetText(titleText, 1.0, 0.82, 0.0, 1.0, true)

    -- Subtitle / Details
    if data.type == "flight" then
        local factionColor = "|cff00ff00"
        if data.faction == "Horde" then
            factionColor = "|cffff3333"
        elseif data.faction == "Alliance" then
            factionColor = "|cff3399ff"
        end
        GameTooltip:AddLine(factionColor .. (data.title or "Flight Master") .. "|r")
        if data.faction then
            GameTooltip:AddLine("|cff888888Faction: " .. data.faction .. "|r")
        end

    elseif data.type == "quest" then
        if data.name then
            GameTooltip:AddLine("|cffffd100Quest Giver: |r" .. data.name)
        end
        local reqLvl = data.reqLevel or 1
        local sugLvl = data.level or reqLvl
        GameTooltip:AddLine(string.format("|cff888888Requires Level %d (Suggested %d)|r", reqLvl, sugLvl))
        local playerLvl = UnitLevel("player") or 1
        if playerLvl >= sugLvl + 10 then
            GameTooltip:AddLine("|cffaaaaaa(Low Level Quest)|r")
        end

    elseif data.type == "bank" then
        GameTooltip:AddLine("|cff00ffffBank Vault / Banker|r")
        if data.title and data.title ~= data.name then
            GameTooltip:AddLine("|cff888888" .. data.title .. "|r")
        end

    elseif data.type == "trainerClass" then
        GameTooltip:AddLine("|cffffaa00" .. (data.title or "Class Trainer") .. "|r")
        if data.sub then
            GameTooltip:AddLine("|cff888888" .. data.sub .. "|r")
        end

    elseif data.type == "trainerProf" then
        GameTooltip:AddLine("|cff00ff88" .. (data.title or "Profession Trainer") .. "|r")
        if data.sub then
            GameTooltip:AddLine("|cff888888" .. data.sub .. "|r")
        end

    elseif data.type == "vendorRepair" then
        GameTooltip:AddLine("|cff00ff00Merchant & Repairs|r")
        if data.title and data.title ~= data.name then
            GameTooltip:AddLine("|cff888888" .. data.title .. "|r")
        end

    elseif data.type == "vendor" then
        GameTooltip:AddLine("|cffffffffGeneral Goods Merchant|r")
        if data.title and data.title ~= data.name then
            GameTooltip:AddLine("|cff888888" .. data.title .. "|r")
        end
    end

    GameTooltip:Show()
end

local function OnPinLeave(self)
    GameTooltip:Hide()
end

local function CreatePinFrame(canvas)
    local pin = CreateFrame("Button", nil, canvas)
    pin:SetSize(18, 18)
    pin:SetFrameStrata("HIGH")
    pin:SetFrameLevel(canvas:GetFrameLevel() + 25)

    -- Icon
    local icon = pin:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints(pin)
    pin.Icon = icon

    -- Highlight Glow
    local hl = pin:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints(pin)
    hl:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    hl:SetBlendMode("ADD")
    pin.Highlight = hl

    pin:SetScript("OnEnter", OnPinEnter)
    pin:SetScript("OnLeave", OnPinLeave)

    return pin
end

local function AcquirePin(canvas)
    local pin = table.remove(pinPool)
    if not pin then
        pin = CreatePinFrame(canvas)
    end
    pin:SetParent(canvas)
    pin:Show()
    table.insert(activePins, pin)
    return pin
end

function Pins:ReleaseAllPins()
    for _, pin in ipairs(activePins) do
        pin:Hide()
        pin:ClearAllPoints()
        pin.poiData = nil
        table.insert(pinPool, pin)
    end
    table.wipe(activePins)
end

function Pins:UpdatePositions()
    local wm = WorldMapFrame
    if not wm or not wm:IsShown() then return end
    local canvas = wm:GetCanvas()
    if not canvas then return end

    local cWidth = canvas:GetWidth()
    local cHeight = canvas:GetHeight()
    if not cWidth or not cHeight or cWidth <= 0 or cHeight <= 0 then return end

    for _, pin in ipairs(activePins) do
        if pin.normX and pin.normY then
            pin:ClearAllPoints()
            pin:SetPoint("CENTER", canvas, "TOPLEFT", pin.normX * cWidth, -pin.normY * cHeight)
        end
    end
end

-- Check whether a POI type is enabled in settings
function Pins:IsPoiTypeEnabled(poiType)
    local db = OneWorldMapDB and OneWorldMapDB.features
    if not db then return true end

    if poiType == "flight" then
        return db.showFlightMasters ~= false
    elseif poiType == "quest" then
        return db.showQuestGivers ~= false
    elseif poiType == "bank" then
        return db.showBanks ~= false
    elseif poiType == "trainerClass" or poiType == "trainerProf" then
        return db.showTrainers ~= false
    elseif poiType == "vendor" then
        return db.showVendors ~= false
    elseif poiType == "vendorRepair" then
        return db.showRepairVendors ~= false
    end

    return true
end

-- Filter check for low level quests
function Pins:ShouldShowQuest(data)
    if data.type ~= "quest" then return true end

    -- Check if quest was already completed
    if data.questID and C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted and C_QuestLog.IsQuestFlaggedCompleted(data.questID) then
        return false
    end

    -- Check if quest is already in progress in quest log
    if data.questID and C_QuestLog and C_QuestLog.GetLogIndexForQuestID and C_QuestLog.GetLogIndexForQuestID(data.questID) then
        return false
    end

    local playerLevel = UnitLevel("player") or 1
    local questLevel = data.level or 1
    local reqLevel = data.reqLevel or 1

    -- If player doesn't meet minimum level requirement, hide
    if playerLevel < reqLevel then
        return false
    end

    -- Check if it is considered low level (10+ levels below player)
    local isLowLevel = (playerLevel >= questLevel + 10)
    data.isLowLevel = isLowLevel

    if isLowLevel then
        -- Check if player has tracking enabled for low level / trivial quests
        local isTrackingLow = (C_Minimap and C_Minimap.IsTrackingHiddenQuests and C_Minimap.IsTrackingHiddenQuests())
        local dbShowLow = (OneWorldMapDB and OneWorldMapDB.features and OneWorldMapDB.features.showLowLevelQuests)
        if not isTrackingLow and not dbShowLow then
            return false
        end
    end

    return true
end

function Pins:Refresh()
    self:ReleaseAllPins()

    local wm = WorldMapFrame
    if not wm or not wm:IsShown() then return end
    local canvas = wm:GetCanvas()
    if not canvas then return end

    local mapID = wm:GetMapID()
    if not mapID then return end

    local feat = (OneWorldMapDB and OneWorldMapDB.features) or {}
    local isTrackingTrivial = (C_Minimap and C_Minimap.IsTrackingHiddenQuests and C_Minimap.IsTrackingHiddenQuests()) or false
    local allowLowLevel = (feat.showLowLevelQuests == true) or isTrackingTrivial

    local existingPositions = {}
    local existingQuestIDs = {}

    -- 1. Dynamically merge live quest offers from WoW client APIs (C_QuestLine & C_TaskQuest)
    -- This ensures any new, modified, or custom quests in WoW Forever are discovered in real time.
    if self:IsPoiTypeEnabled("quest") then
        if C_QuestLine and C_QuestLine.GetAvailableQuestLines then
            local okQL, questLines = pcall(C_QuestLine.GetAvailableQuestLines, mapID)
            if okQL and type(questLines) == "table" then
                for _, qInfo in ipairs(questLines) do
                    local qID = qInfo.questID
                    local isCompleted = C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted and C_QuestLog.IsQuestFlaggedCompleted(qID)
                    local isTrivial = qInfo.isHidden or (C_QuestLog and C_QuestLog.IsQuestTrivial and C_QuestLog.IsQuestTrivial(qID))

                    if not isCompleted and (not isTrivial or allowLowLevel) then
                        local nx, ny = qInfo.x, qInfo.y
                        if nx and ny and nx > 0 and ny > 0 then
                            local posKey = string.format("%.2f_%.2f", nx, ny)
                            if not existingPositions[posKey] then
                                local qTitle = qInfo.questName or (C_QuestLog and C_QuestLog.GetTitleForQuestID and C_QuestLog.GetTitleForQuestID(qID)) or "Available Quest"
                                local pin = AcquirePin(canvas)
                                pin.poiData = {
                                    type = "quest",
                                    name = qTitle,
                                    title = qTitle,
                                    questID = qID,
                                    isLowLevel = isTrivial,
                                    faction = "Neutral",
                                }
                                pin.normX = nx
                                pin.normY = ny

                                if isTrivial then
                                    pin.Icon:SetTexture(PIN_TEXTURES.questLowLevel)
                                    pin.Icon:SetAlpha(0.70)
                                    pin:SetSize(16, 16)
                                else
                                    pin.Icon:SetTexture(PIN_TEXTURES.questNormal)
                                    pin.Icon:SetAlpha(1.0)
                                    pin:SetSize(18, 18)
                                end

                                existingPositions[posKey] = true
                                if qID then existingQuestIDs[qID] = true end
                            end
                        end
                    end
                end
            end
        end

        if C_TaskQuest and C_TaskQuest.GetQuestsForPlayerByMapID then
            local okTQ, taskQuests = pcall(C_TaskQuest.GetQuestsForPlayerByMapID, mapID)
            if okTQ and type(taskQuests) == "table" then
                for _, tInfo in ipairs(taskQuests) do
                    local qID = tInfo.questId or tInfo.questID
                    local isCompleted = C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted and C_QuestLog.IsQuestFlaggedCompleted(qID)
                    local isTrivial = C_QuestLog and C_QuestLog.IsQuestTrivial and C_QuestLog.IsQuestTrivial(qID)

                    if not isCompleted and (not isTrivial or allowLowLevel) then
                        local nx, ny = tInfo.x, tInfo.y
                        if nx and ny and nx > 0 and ny > 0 then
                            local posKey = string.format("%.2f_%.2f", nx, ny)
                            if not existingPositions[posKey] and (not qID or not existingQuestIDs[qID]) then
                                local qTitle = (C_TaskQuest.GetQuestInfoByQuestID and C_TaskQuest.GetQuestInfoByQuestID(qID)) or
                                              (C_QuestLog and C_QuestLog.GetTitleForQuestID and C_QuestLog.GetTitleForQuestID(qID)) or "Available Task"
                                local pin = AcquirePin(canvas)
                                pin.poiData = {
                                    type = "quest",
                                    name = qTitle,
                                    title = qTitle,
                                    questID = qID,
                                    isLowLevel = isTrivial,
                                    faction = "Neutral",
                                }
                                pin.normX = nx
                                pin.normY = ny

                                if isTrivial then
                                    pin.Icon:SetTexture(PIN_TEXTURES.questLowLevel)
                                    pin.Icon:SetAlpha(0.70)
                                    pin:SetSize(16, 16)
                                else
                                    pin.Icon:SetTexture(PIN_TEXTURES.questNormal)
                                    pin.Icon:SetAlpha(1.0)
                                    pin:SetSize(18, 18)
                                end

                                existingPositions[posKey] = true
                                if qID then existingQuestIDs[qID] = true end
                            end
                        end
                    end
                end
            end
        end
    end

    -- 2. Load curated POIs from OneWorldMap.PoiData (Cities, hubs, banks, trainers, vendors, starter quests)
    local pois = OneWorldMap:GetPoisForMap(mapID)
    if pois and #pois > 0 then
        for _, poi in ipairs(pois) do
            if self:IsPoiTypeEnabled(poi.type) and self:ShouldShowQuest(poi) then
                local posKey = string.format("%.2f_%.2f", poi.x, poi.y)
                local isDuplicateQuest = (poi.type == "quest") and (existingPositions[posKey] or (poi.questID and existingQuestIDs[poi.questID]))

                if not isDuplicateQuest then
                    local pin = AcquirePin(canvas)
                    pin.poiData = poi
                    pin.normX = poi.x
                    pin.normY = poi.y

                    -- Set Texture and Size
                    if poi.type == "quest" then
                        if poi.isLowLevel then
                            pin.Icon:SetTexture(PIN_TEXTURES.questLowLevel)
                            pin.Icon:SetAlpha(0.70)
                            pin:SetSize(16, 16)
                        else
                            pin.Icon:SetTexture(PIN_TEXTURES.questNormal)
                            pin.Icon:SetAlpha(1.0)
                            pin:SetSize(18, 18)
                        end
                    elseif poi.type == "vendor" then
                        pin.Icon:SetTexture(PIN_TEXTURES.vendor)
                        pin.Icon:SetAlpha(0.95)
                        pin:SetSize(16, 16)
                    elseif poi.type == "vendorRepair" then
                        pin.Icon:SetTexture(PIN_TEXTURES.vendorRepair)
                        pin.Icon:SetAlpha(1.0)
                        pin:SetSize(18, 18)
                    elseif poi.type == "bank" then
                        pin.Icon:SetTexture(PIN_TEXTURES.bank)
                        pin.Icon:SetAlpha(1.0)
                        pin:SetSize(18, 18)
                    elseif poi.type == "trainerClass" then
                        pin.Icon:SetTexture(PIN_TEXTURES.trainerClass)
                        pin.Icon:SetAlpha(1.0)
                        pin:SetSize(17, 17)
                    elseif poi.type == "trainerProf" then
                        pin.Icon:SetTexture(PIN_TEXTURES.trainerProf)
                        pin.Icon:SetAlpha(1.0)
                        pin:SetSize(17, 17)
                    elseif poi.type == "flight" then
                        pin.Icon:SetTexture(PIN_TEXTURES.flight)
                        pin.Icon:SetAlpha(1.0)
                        pin:SetSize(19, 19)
                    else
                        pin.Icon:SetTexture("Interface\\Minimap\\Tracking\\None")
                        pin.Icon:SetAlpha(0.8)
                        pin:SetSize(16, 16)
                    end

                    existingPositions[posKey] = true
                end
            end
        end
    end

    -- 3. Dynamically merge live Taxi Nodes from C_TaxiMap if available
    if self:IsPoiTypeEnabled("flight") and C_TaxiMap and C_TaxiMap.GetTaxiNodesForMap and C_TaxiMap.ShouldMapShowTaxiNodes then
        local okShow, shouldShow = pcall(C_TaxiMap.ShouldMapShowTaxiNodes, mapID)
        if okShow and shouldShow then
            local okNodes, taxiNodes = pcall(C_TaxiMap.GetTaxiNodesForMap, mapID)
            if okNodes and type(taxiNodes) == "table" then
                for _, node in ipairs(taxiNodes) do
                    if node.position then
                        local nx, ny = node.position.x, node.position.y
                        local posKey = string.format("%.2f_%.2f", nx, ny)
                        if not existingPositions[posKey] then
                            local pin = AcquirePin(canvas)
                            pin.poiData = {
                                type = "flight",
                                name = node.name or "Flight Master",
                                title = "Flight Master",
                                faction = (node.faction == Enum.FlightPathFaction.Horde and "Horde") or
                                          (node.faction == Enum.FlightPathFaction.Alliance and "Alliance") or "Neutral",
                            }
                            pin.normX = nx
                            pin.normY = ny
                            pin.Icon:SetTexture(PIN_TEXTURES.flight)
                            pin.Icon:SetAlpha(1.0)
                            pin:SetSize(19, 19)
                            existingPositions[posKey] = true
                        end
                    end
                end
            end
        end
    end

    self:UpdatePositions()
end

function Pins:Init()
    local wm = WorldMapFrame
    if not wm then return end

    -- Hook map display changes & request live quest lines from server
    local function OnMapUpdated()
        local currentMapID = wm:GetMapID()
        if currentMapID and C_QuestLine and C_QuestLine.RequestQuestLinesForMap then
            pcall(C_QuestLine.RequestQuestLinesForMap, currentMapID)
        end
        Pins:Refresh()
    end

    hooksecurefunc(wm, "OnMapChanged", OnMapUpdated)

    if wm.SetMapID then
        hooksecurefunc(wm, "SetMapID", OnMapUpdated)
    end

    if wm.RefreshAllDataProviders then
        hooksecurefunc(wm, "RefreshAllDataProviders", function()
            Pins:Refresh()
        end)
    end

    -- Hook canvas container zooming / panning to update pin positions smoothly
    local scrollContainer = wm:GetCanvasContainer()
    if scrollContainer then
        if scrollContainer.SetScale then
            hooksecurefunc(scrollContainer, "SetScale", function()
                Pins:UpdatePositions()
            end)
        end
        if scrollContainer.SetZoom then
            hooksecurefunc(scrollContainer, "SetZoom", function()
                Pins:UpdatePositions()
            end)
        end
        if scrollContainer.SetPan then
            hooksecurefunc(scrollContainer, "SetPan", function()
                Pins:UpdatePositions()
            end)
        end
    end

    -- Register relevant game events for dynamic refresh
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
    eventFrame:RegisterEvent("QUEST_ACCEPTED")
    eventFrame:RegisterEvent("QUEST_TURNED_IN")
    eventFrame:RegisterEvent("QUEST_LOG_UPDATE")
    eventFrame:RegisterEvent("QUESTLINE_UPDATE")
    eventFrame:RegisterEvent("CVAR_UPDATE")
    eventFrame:RegisterEvent("MINIMAP_UPDATE_TRACKING")
    eventFrame:SetScript("OnEvent", function(self, event, ...)
        if wm:IsShown() then
            Pins:Refresh()
        end
    end)

    -- Initial load
    if wm:IsShown() then
        Pins:Refresh()
    end
end

-- Expose to global namespace
OneWorldMap.Pins = Pins

OneWorldMap:RegisterModule("Pins", function()
    Pins:Init()
end)
