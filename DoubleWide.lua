-- OneWorldMap: DoubleWide.lua
-- Quest frame layout engine: maintains QuestsFrame and DetailsFrame side-by-side in persistent dual columns,
-- locks the map canvas, repositions the tracking cog button, supports clean collapse, and extends panels full height.

OneWorldMap = OneWorldMap or {}
OneWorldMap.DoubleWide = {}

OneWorldMap:RegisterModule("DoubleWide", function(addon)
    OneWorldMap.DoubleWide:Init()
end)

function OneWorldMap.DoubleWide:Init()
    if not QuestMapFrame or not WorldMapFrame.ScrollContainer then
        local waiter = CreateFrame("Frame")
        waiter:RegisterEvent("ADDON_LOADED")
        waiter:SetScript("OnEvent", function(self, event, addonName)
            if QuestMapFrame and WorldMapFrame.ScrollContainer then
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
    local scrollContainer = wmFrame.ScrollContainer
    local qmFrame = QuestMapFrame
    local questsFrame = qmFrame and qmFrame.QuestsFrame
    local detailsFrame = qmFrame and qmFrame.DetailsFrame
    local questScroll = questsFrame and questsFrame.ScrollFrame

    if not questsFrame or not detailsFrame or not questScroll then return end

    -- 1. Cache fixed map canvas width
    local currentCanvasWidth = scrollContainer:GetWidth()
    self.canvasWidth = (currentCanvasWidth and currentCanvasWidth > 400 and currentCanvasWidth < 850) and currentCanvasWidth or 702

    -- 2. Prevent Blizzard from hiding the Quest List scrollframe when details open
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

    questScroll:HookScript("OnHide", function(self)
        if InCombatLockdown() then return end
        if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide and not self.allowHide then
            if detailsFrame:IsShown() then
                self:Show()
            end
        end
    end)

    -- 3. Hook Blizzard Show / Close details functions
    if type(QuestMapFrame_ShowQuestDetails) == "function" then
        hooksecurefunc("QuestMapFrame_ShowQuestDetails", function(questID)
            if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
                OneWorldMap.DoubleWide:ApplyDoubleWideLayout()
            end
        end)
    end

    if type(QuestMapFrame_CloseQuestDetails) == "function" then
        hooksecurefunc("QuestMapFrame_CloseQuestDetails", function()
            if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
                OneWorldMap.DoubleWide:ApplyDoubleWideLayout()
            end
        end)
    end

    if type(QuestMapFrame_ReturnFromQuestDetails) == "function" then
        hooksecurefunc("QuestMapFrame_ReturnFromQuestDetails", function()
            if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
                OneWorldMap.DoubleWide:ApplyDoubleWideLayout()
            end
        end)
    end

    detailsFrame:HookScript("OnShow", function()
        if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
            OneWorldMap.DoubleWide:ApplyDoubleWideLayout()
        end
    end)

    detailsFrame:HookScript("OnHide", function()
        if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
            OneWorldMap.DoubleWide:ApplyDoubleWideLayout()
        end
    end)

    -- Back button
    local backButton = (detailsFrame.BackFrame and detailsFrame.BackFrame.BackButton) or detailsFrame.BackButton
    if backButton then
        backButton:HookScript("OnClick", function()
            if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
                OneWorldMap.DoubleWide:ApplyDoubleWideLayout()
            end
        end)
    end

    -- 4. Hook QuestMapFrame show/hide (when user collapses or expands the quest log)
    qmFrame:HookScript("OnShow", function()
        OneWorldMap.DoubleWide:ApplyDoubleWideLayout()
    end)

    qmFrame:HookScript("OnHide", function()
        OneWorldMap.DoubleWide:ApplyDoubleWideLayout()
    end)

    if wmFrame.SetQuestLogPanelShown then
        hooksecurefunc(wmFrame, "SetQuestLogPanelShown", function()
            OneWorldMap.DoubleWide:ApplyDoubleWideLayout()
        end)
    end

    -- 5. Hook WorldMap OnShow to re-apply anchored layout
    wmFrame:HookScript("OnShow", function()
        OneWorldMap.DoubleWide:ApplyDoubleWideLayout()
    end)

    self:ApplyDoubleWideLayout()
end

function OneWorldMap.DoubleWide:ApplyDoubleWideLayout()
    if InCombatLockdown() then return end

    local wmFrame = WorldMapFrame
    local scrollContainer = wmFrame and wmFrame.ScrollContainer
    local qmFrame = QuestMapFrame
    if not wmFrame or not scrollContainer or not qmFrame then return end

    local questsFrame = qmFrame.QuestsFrame
    local detailsFrame = qmFrame.DetailsFrame
    local questScroll = questsFrame and questsFrame.ScrollFrame
    if not questsFrame or not detailsFrame or not questScroll then return end

    local cWidth = self.canvasWidth or 702
    local questListWidth = 330
    local detailsWidth = 330
    local gap = 8

    -- 1. Lock map canvas to the left
    scrollContainer:ClearAllPoints()
    scrollContainer:SetPoint("TOPLEFT", wmFrame, "TOPLEFT", 4, -68)
    scrollContainer:SetPoint("BOTTOMLEFT", wmFrame, "BOTTOMLEFT", 4, 4)
    scrollContainer:SetWidth(cWidth)

    if wmFrame.TitleCanvasSpacerFrame then
        wmFrame.TitleCanvasSpacerFrame:ClearAllPoints()
        wmFrame.TitleCanvasSpacerFrame:SetPoint("TOPLEFT", wmFrame, "TOPLEFT", 4, 0)
        wmFrame.TitleCanvasSpacerFrame:SetPoint("BOTTOMRIGHT", scrollContainer, "TOPRIGHT", 0, 0)
    end

    -- 2. Check if the Quest Log is collapsed by the user
    local isLogShown = qmFrame:IsShown()

    if not isLogShown then
        -- Quest list is collapsed! Shrink WorldMapFrame so border aligns flush with map canvas
        wmFrame:SetWidth(4 + cWidth + 4)
        return
    end

    -- 3. Extend QuestMapFrame full height from top border (y = -25) to bottom border (y = 3)
    qmFrame:ClearAllPoints()
    qmFrame:SetPoint("TOPLEFT", wmFrame, "TOPLEFT", 4 + cWidth, -25)
    qmFrame:SetPoint("BOTTOMLEFT", wmFrame, "BOTTOMLEFT", 4 + cWidth, 3)

    -- Anchor QuestsFrame cleanly inside QuestMapFrame with full 330px width
    questsFrame:ClearAllPoints()
    questsFrame:SetPoint("TOPLEFT", qmFrame, "TOPLEFT", 0, 0)
    questsFrame:SetPoint("BOTTOMLEFT", qmFrame, "BOTTOMLEFT", 0, 0)
    questsFrame:SetWidth(questListWidth)
    questsFrame:Show()

    -- Lock QuestScrollFrame with margin for scrollbar
    questScroll:ClearAllPoints()
    questScroll:SetPoint("TOPLEFT", questsFrame, "TOPLEFT", 0, -29)
    questScroll:SetPoint("BOTTOMRIGHT", questsFrame, "BOTTOMRIGHT", -24, 0)
    questScroll:Show()

    -- Lock QuestScrollFrame.ScrollBar strictly to the right edge of QuestsFrame
    if questScroll.ScrollBar then
        questScroll.ScrollBar:ClearAllPoints()
        questScroll.ScrollBar:SetPoint("TOPRIGHT", questsFrame, "TOPRIGHT", -4, -31)
        questScroll.ScrollBar:SetPoint("BOTTOMRIGHT", questsFrame, "BOTTOMRIGHT", -4, 4)
    end

    local isDetailsOpen = detailsFrame:IsShown()

    if isDetailsOpen and (OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide) then
        if self.adjusting then return end
        self.adjusting = true

        -- Double-wide: expand QuestMapFrame and WorldMapFrame to fit both 330px columns
        local totalQuestAreaWidth = questListWidth + gap + detailsWidth + 4
        qmFrame:SetWidth(totalQuestAreaWidth)
        wmFrame:SetWidth(4 + cWidth + totalQuestAreaWidth + 4)

        -- Anchor DetailsFrame side-by-side to the right of QuestsFrame, full height
        detailsFrame:ClearAllPoints()
        detailsFrame:SetPoint("TOPLEFT", questsFrame, "TOPRIGHT", gap, 0)
        detailsFrame:SetPoint("BOTTOMLEFT", questsFrame, "BOTTOMRIGHT", gap, 0)
        detailsFrame:SetWidth(detailsWidth)

        -- Lock DetailsFrame ScrollBar inside DetailsFrame
        local detailsScroll = detailsFrame.ScrollFrame or _G["QuestMapDetailsScrollFrame"]
        if detailsScroll and detailsScroll.ScrollBar then
            detailsScroll.ScrollBar:ClearAllPoints()
            detailsScroll.ScrollBar:SetPoint("TOPRIGHT", detailsFrame, "TOPRIGHT", -4, -48)
            detailsScroll.ScrollBar:SetPoint("BOTTOMRIGHT", detailsFrame, "BOTTOMRIGHT", -4, 28)
        end

        self.adjusting = false
    else
        if self.adjusting then return end
        self.adjusting = true

        -- Single-column width (List only, no details)
        local singleQuestAreaWidth = questListWidth
        qmFrame:SetWidth(singleQuestAreaWidth)
        wmFrame:SetWidth(4 + cWidth + singleQuestAreaWidth + 4)

        self.adjusting = false
    end
end

function OneWorldMap.DoubleWide:RefreshLayout()
    self:ApplyDoubleWideLayout()
end
