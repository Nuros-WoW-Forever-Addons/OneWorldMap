-- OneWorldMap: DoubleWide.lua
-- Quest frame layout engine: decouples DetailsFrame and positions it side-by-side with QuestsFrame.

OneWorldMap = OneWorldMap or {}
OneWorldMap.DoubleWide = {}

OneWorldMap:RegisterModule("DoubleWide", function(addon)
    OneWorldMap.DoubleWide:Init()
end)

function OneWorldMap.DoubleWide:Init()
    if not QuestMapFrame then
        -- Wait for QuestMapFrame if not yet loaded
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, addonName)
            if QuestMapFrame then
                self:UnregisterEvent("ADDON_LOADED")
                OneWorldMap.DoubleWide:SetupLayout()
            end
        end)
        return
    end

    self:SetupLayout()
end

function OneWorldMap.DoubleWide:SetupLayout()
    if self.isInitialized then return end
    self.isInitialized = true

    if not QuestMapFrame or not QuestMapFrame.DetailsFrame or not QuestMapFrame.QuestsFrame then
        return
    end

    self:ApplyAnchors()

    -- Post-hook QuestMapFrame_ShowQuestDetails so QuestsFrame remains visible
    if type(QuestMapFrame_ShowQuestDetails) == "function" then
        hooksecurefunc("QuestMapFrame_ShowQuestDetails", function()
            if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
                OneWorldMap.DoubleWide:ApplyAnchors()
                QuestMapFrame.QuestsFrame:Show()
                if QuestMapFrame.DetailsFrame and QuestMapFrame.DetailsFrame.BackButton then
                    QuestMapFrame.DetailsFrame.BackButton:Hide()
                end
                OneWorldMap.DoubleWide:UpdateFrameWidth(true)
            end
        end)
    end

    -- Hook close / return
    local closeFn = QuestMapFrame_CloseQuestDetails or QuestMapFrame_HideQuestDetails
    if type(closeFn) == "function" then
        local fnName = QuestMapFrame_CloseQuestDetails and "QuestMapFrame_CloseQuestDetails" or "QuestMapFrame_HideQuestDetails"
        hooksecurefunc(fnName, function()
            if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
                OneWorldMap.DoubleWide:UpdateFrameWidth(false)
            end
        end)
    end

    QuestMapFrame.DetailsFrame:HookScript("OnShow", function()
        if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
            OneWorldMap.DoubleWide:ApplyAnchors()
            QuestMapFrame.QuestsFrame:Show()
            if QuestMapFrame.DetailsFrame.BackButton then
                QuestMapFrame.DetailsFrame.BackButton:Hide()
            end
            OneWorldMap.DoubleWide:UpdateFrameWidth(true)
        end
    end)

    QuestMapFrame.DetailsFrame:HookScript("OnHide", function()
        if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
            OneWorldMap.DoubleWide:UpdateFrameWidth(false)
        end
    end)
end

function OneWorldMap.DoubleWide:ApplyAnchors()
    if not (OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide) then
        return
    end

    local details = QuestMapFrame and QuestMapFrame.DetailsFrame
    local quests = QuestMapFrame and QuestMapFrame.QuestsFrame
    if not details or not quests then return end

    if self.reanchoring then return end
    self.reanchoring = true

    details:ClearAllPoints()
    details:SetPoint("TOPLEFT", quests, "TOPRIGHT", 2, 0)
    details:SetPoint("BOTTOMLEFT", quests, "BOTTOMRIGHT", 2, 0)

    if details.BackButton then
        details.BackButton:Hide()
    end

    self.reanchoring = false
end

function OneWorldMap.DoubleWide:UpdateFrameWidth(detailsShown)
    if InCombatLockdown() then return end
    local wmFrame = WorldMapFrame
    if not wmFrame then return end

    -- Base standard width of map + quest frame is ~1024 or ~700 depending on view
    -- When details are opened side-by-side, expand outer frame to comfortably accommodate both panes
    if detailsShown and (OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide) then
        local detailsWidth = (QuestMapFrame.DetailsFrame and QuestMapFrame.DetailsFrame:GetWidth()) or 280
        local baseWidth = wmFrame.baseWidth or wmFrame:GetWidth()
        if not wmFrame.baseWidth then
            wmFrame.baseWidth = baseWidth
        end
        wmFrame:SetWidth(wmFrame.baseWidth + detailsWidth + 10)
    else
        if wmFrame.baseWidth then
            wmFrame:SetWidth(wmFrame.baseWidth)
        end
    end
end

function OneWorldMap.DoubleWide:RefreshLayout()
    if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
        self:ApplyAnchors()
        if QuestMapFrame and QuestMapFrame.selectedQuestID then
            if QuestMapFrame_ShowQuestDetails then
                QuestMapFrame_ShowQuestDetails(QuestMapFrame.selectedQuestID)
            end
        end
    else
        if QuestMapFrame and QuestMapFrame.DetailsFrame then
            QuestMapFrame.DetailsFrame:ClearAllPoints()
            QuestMapFrame.DetailsFrame:SetPoint("TOPLEFT", QuestMapFrame, "TOPLEFT", 0, 0)
            QuestMapFrame.DetailsFrame:SetPoint("BOTTOMRIGHT", QuestMapFrame, "BOTTOMRIGHT", 0, 0)
            if QuestMapFrame.DetailsFrame.BackButton then
                QuestMapFrame.DetailsFrame.BackButton:Show()
            end
        end
        self:UpdateFrameWidth(false)
    end
end
