-- OneWorldMap: DoubleWide.lua
-- Quest frame layout engine: maintains QuestsFrame and DetailsFrame side-by-side in persistent dual columns.

OneWorldMap = OneWorldMap or {}
OneWorldMap.DoubleWide = {}

OneWorldMap:RegisterModule("DoubleWide", function(addon)
    OneWorldMap.DoubleWide:Init()
end)

function OneWorldMap.DoubleWide:Init()
    if not QuestMapFrame then
        local waiter = CreateFrame("Frame")
        waiter:RegisterEvent("ADDON_LOADED")
        waiter:SetScript("OnEvent", function(self, event, addonName)
            if QuestMapFrame then
                self:UnregisterEvent("ADDON_LOADED")
                OneWorldMap.DoubleWide:Init()
            end
        end)
        return
    end

    self:SetupLayout()
end

function OneWorldMap.DoubleWide:SetupLayout()
    if self.isInitialized then return end
    self.isInitialized = true

    local wmFrame = WorldMapFrame
    local qmFrame = QuestMapFrame
    local questsFrame = qmFrame and qmFrame.QuestsFrame
    local detailsFrame = qmFrame and qmFrame.DetailsFrame

    if not questsFrame or not detailsFrame then return end

    -- Intercept QuestsFrame.Hide to keep the quest list visible when details are open
    local origQuestsHide = questsFrame.Hide
    questsFrame.Hide = function(self)
        if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide and not self.allowHide then
            if detailsFrame:IsShown() then
                return
            end
        end
        origQuestsHide(self)
    end

    -- Hook OnHide as an extra safety measure against Blizzard update scripts
    questsFrame:HookScript("OnHide", function(self)
        if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide and not self.allowHide then
            if detailsFrame:IsShown() then
                self:Show()
                self:SetAlpha(1.0)
            end
        end
    end)

    -- Hook QuestMapFrame_ShowQuestDetails
    if type(QuestMapFrame_ShowQuestDetails) == "function" then
        hooksecurefunc("QuestMapFrame_ShowQuestDetails", function(questID)
            if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
                OneWorldMap.DoubleWide:ApplyDoubleWideLayout(true)
            end
        end)
    end

    -- Hook Close Details
    local closeFnName = (type(QuestMapFrame_CloseQuestDetails) == "function" and "QuestMapFrame_CloseQuestDetails")
        or (type(QuestMapFrame_HideQuestDetails) == "function" and "QuestMapFrame_HideQuestDetails")
    if closeFnName then
        hooksecurefunc(closeFnName, function()
            if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
                OneWorldMap.DoubleWide:ApplyDoubleWideLayout(false)
            end
        end)
    end

    -- Hook DetailsFrame OnShow and OnHide
    detailsFrame:HookScript("OnShow", function()
        if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
            OneWorldMap.DoubleWide:ApplyDoubleWideLayout(true)
        end
    end)

    detailsFrame:HookScript("OnHide", function()
        if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
            OneWorldMap.DoubleWide:ApplyDoubleWideLayout(false)
        end
    end)

    -- Handle Back button click
    if detailsFrame.BackButton then
        detailsFrame.BackButton:HookScript("OnClick", function()
            if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
                OneWorldMap.DoubleWide:ApplyDoubleWideLayout(false)
            end
        end)
    end

    -- Initial check if details already open
    if detailsFrame:IsShown() and OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
        self:ApplyDoubleWideLayout(true)
    end
end

function OneWorldMap.DoubleWide:ApplyDoubleWideLayout(isDetailsOpen)
    if InCombatLockdown() then return end

    local wmFrame = WorldMapFrame
    local qmFrame = QuestMapFrame
    if not wmFrame or not qmFrame then return end

    local questsFrame = qmFrame.QuestsFrame
    local detailsFrame = qmFrame.DetailsFrame
    if not questsFrame or not detailsFrame then return end

    if not wmFrame.baseWidth then
        wmFrame.baseWidth = wmFrame:GetWidth()
    end
    if not qmFrame.baseWidth then
        qmFrame.baseWidth = qmFrame:GetWidth()
    end

    local singleWidth = qmFrame.baseWidth or 284
    local detailsWidth = singleWidth

    if isDetailsOpen and (OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide) then
        if self.adjusting then return end
        self.adjusting = true

        -- 1. Expand QuestMapFrame to encompass both columns
        qmFrame:SetWidth(singleWidth + detailsWidth)

        -- 2. Expand WorldMapFrame to accommodate the second column
        wmFrame:SetWidth(wmFrame.baseWidth + detailsWidth)

        -- 3. Position QuestsFrame on the left side of QuestMapFrame
        questsFrame:ClearAllPoints()
        questsFrame:SetPoint("TOPLEFT", qmFrame, "TOPLEFT", 0, 0)
        questsFrame:SetPoint("BOTTOMLEFT", qmFrame, "BOTTOMLEFT", 0, 0)
        questsFrame:SetWidth(singleWidth)
        questsFrame:Show()
        questsFrame:SetAlpha(1.0)

        -- 4. Position DetailsFrame directly to the right of QuestsFrame
        detailsFrame:ClearAllPoints()
        detailsFrame:SetPoint("TOPLEFT", questsFrame, "TOPRIGHT", 0, 0)
        detailsFrame:SetPoint("BOTTOMLEFT", questsFrame, "BOTTOMRIGHT", 0, 0)
        detailsFrame:SetWidth(detailsWidth)

        self.adjusting = false
    else
        if self.adjusting then return end
        self.adjusting = true

        -- Restore to single width
        qmFrame:SetWidth(singleWidth)
        if wmFrame.baseWidth then
            wmFrame:SetWidth(wmFrame.baseWidth)
        end

        questsFrame:ClearAllPoints()
        questsFrame:SetPoint("TOPLEFT", qmFrame, "TOPLEFT", 0, 0)
        questsFrame:SetPoint("BOTTOMRIGHT", qmFrame, "BOTTOMRIGHT", 0, 0)
        questsFrame:SetWidth(singleWidth)
        questsFrame:Show()
        questsFrame:SetAlpha(1.0)

        self.adjusting = false
    end
end

function OneWorldMap.DoubleWide:RefreshLayout()
    local detailsFrame = QuestMapFrame and QuestMapFrame.DetailsFrame
    local isDetailsOpen = detailsFrame and detailsFrame:IsShown()
    self:ApplyDoubleWideLayout(isDetailsOpen)
end
