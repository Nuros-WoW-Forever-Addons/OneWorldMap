-- OneWorldMap: DoubleWide.lua
-- Quest frame layout engine: maintains QuestsFrame and DetailsFrame side-by-side in persistent dual columns,
-- preventing QuestsFrame.ScrollFrame from being hidden and constraining the details scrollbar.

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

    self:SetupHooks()
end

function OneWorldMap.DoubleWide:SetupHooks()
    if self.isInitialized then return end
    self.isInitialized = true

    local qmFrame = QuestMapFrame
    local questsFrame = qmFrame and qmFrame.QuestsFrame
    local detailsFrame = qmFrame and qmFrame.DetailsFrame
    local questScroll = questsFrame and questsFrame.ScrollFrame

    if not questsFrame or not detailsFrame or not questScroll then return end

    -- 1. Intercept QuestsFrame.ScrollFrame.Hide to prevent Blizzard line 1077 from hiding the quest list
    local origScrollHide = questScroll.Hide
    questScroll.Hide = function(self)
        if InCombatLockdown() then return origScrollHide(self) end
        if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide and not self.allowHide then
            if detailsFrame:IsShown() then
                return
            end
        end
        origScrollHide(self)
    end

    -- Also intercept questsFrame.Hide
    local origQuestsHide = questsFrame.Hide
    questsFrame.Hide = function(self)
        if InCombatLockdown() then return origQuestsHide(self) end
        if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide and not self.allowHide then
            if detailsFrame:IsShown() then
                return
            end
        end
        origQuestsHide(self)
    end

    -- Safety OnHide hook
    questScroll:HookScript("OnHide", function(self)
        if InCombatLockdown() then return end
        if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide and not self.allowHide then
            if detailsFrame:IsShown() then
                self:Show()
            end
        end
    end)

    -- 2. Hook QuestMapFrame_ShowQuestDetails to apply DoubleWide side-by-side layout
    if type(QuestMapFrame_ShowQuestDetails) == "function" then
        hooksecurefunc("QuestMapFrame_ShowQuestDetails", function(questID)
            if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
                OneWorldMap.DoubleWide:ApplyDoubleWideLayout(true)
            end
        end)
    end

    -- 3. Hook Close / Return functions
    if type(QuestMapFrame_CloseQuestDetails) == "function" then
        hooksecurefunc("QuestMapFrame_CloseQuestDetails", function()
            if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
                OneWorldMap.DoubleWide:ApplyDoubleWideLayout(false)
            end
        end)
    end

    if type(QuestMapFrame_ReturnFromQuestDetails) == "function" then
        hooksecurefunc("QuestMapFrame_ReturnFromQuestDetails", function()
            if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
                OneWorldMap.DoubleWide:ApplyDoubleWideLayout(false)
            end
        end)
    end

    -- 4. Hook DetailsFrame OnShow and OnHide
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

    -- 5. Handle Back button click
    local backButton = (detailsFrame.BackFrame and detailsFrame.BackFrame.BackButton) or detailsFrame.BackButton
    if backButton then
        backButton:HookScript("OnClick", function()
            if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
                OneWorldMap.DoubleWide:ApplyDoubleWideLayout(false)
            end
        end)
    end

    -- Initial state check
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
    local questScroll = questsFrame and questsFrame.ScrollFrame
    if not questsFrame or not detailsFrame or not questScroll then return end

    local singleWidth = 330
    local detailsWidth = 308

    if isDetailsOpen and (OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide) then
        if self.adjusting then return end
        self.adjusting = true

        -- Store base width of WorldMapFrame once before expanding
        if not self.isExpanded then
            self.baseWorldMapWidth = wmFrame:GetWidth()
            wmFrame:SetWidth(self.baseWorldMapWidth + detailsWidth + 4)
            self.isExpanded = true
        end

        -- Expand QuestMapFrame container
        qmFrame:SetWidth(singleWidth + detailsWidth + 4)

        -- Keep quest list (and its scroll frame) visible
        questsFrame:Show()
        questScroll:Show()

        -- Anchor QuestsFrame cleanly to left of QuestMapFrame
        questsFrame:ClearAllPoints()
        questsFrame:SetPoint("TOPLEFT", qmFrame, "TOPLEFT", 0, 0)
        questsFrame:SetPoint("BOTTOMLEFT", qmFrame, "BOTTOMLEFT", 0, 0)
        questsFrame:SetWidth(singleWidth)

        -- Anchor DetailsFrame side-by-side to right of QuestsFrame
        detailsFrame:ClearAllPoints()
        detailsFrame:SetPoint("TOPLEFT", questsFrame, "TOPRIGHT", 4, 0)
        detailsFrame:SetPoint("BOTTOMLEFT", questsFrame, "BOTTOMRIGHT", 4, 0)
        detailsFrame:SetWidth(detailsWidth)

        -- Constrain DetailsFrame ScrollBar so it never moves off the panel
        local detailsScroll = detailsFrame.ScrollFrame or _G["QuestMapDetailsScrollFrame"]
        if detailsScroll and detailsScroll.ScrollBar then
            detailsScroll.ScrollBar:ClearAllPoints()
            detailsScroll.ScrollBar:SetPoint("TOPRIGHT", detailsFrame, "TOPRIGHT", -8, -48)
            detailsScroll.ScrollBar:SetPoint("BOTTOMRIGHT", detailsFrame, "BOTTOMRIGHT", -8, 28)
        end

        self.adjusting = false
    else
        if self.adjusting then return end
        self.adjusting = true

        -- Restore WorldMapFrame width
        if self.isExpanded and self.baseWorldMapWidth then
            wmFrame:SetWidth(self.baseWorldMapWidth)
            self.isExpanded = false
        end

        -- Restore QuestMapFrame width
        qmFrame:SetWidth(singleWidth)

        -- Restore QuestsFrame anchors to Blizzard default
        questsFrame:ClearAllPoints()
        if qmFrame.ContentsAnchor then
            questsFrame:SetPoint("TOPLEFT", qmFrame.ContentsAnchor, "TOPLEFT", 0, 0)
            questsFrame:SetPoint("BOTTOMRIGHT", qmFrame.ContentsAnchor, "BOTTOMRIGHT", -22, 0)
        else
            questsFrame:SetPoint("TOPLEFT", qmFrame, "TOPLEFT", 0, 0)
            questsFrame:SetPoint("BOTTOMRIGHT", qmFrame, "BOTTOMRIGHT", -22, 0)
        end

        questsFrame:Show()
        questScroll:Show()

        self.adjusting = false
    end
end

function OneWorldMap.DoubleWide:RefreshLayout()
    local detailsFrame = QuestMapFrame and QuestMapFrame.DetailsFrame
    local isDetailsOpen = detailsFrame and detailsFrame:IsShown()
    self:ApplyDoubleWideLayout(isDetailsOpen)
end
