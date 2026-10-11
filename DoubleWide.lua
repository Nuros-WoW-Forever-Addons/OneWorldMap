-- OneWorldMap: DoubleWide.lua
-- Quest frame layout engine: maintains QuestsFrame and DetailsFrame side-by-side in persistent dual columns,
-- locks the map canvas so it never shifts or reveals wooden borders, and strictly constrains all scrollbars.

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

    -- 1. Cache and lock the map canvas width so it NEVER stretches or reveals wooden borders
    local currentCanvasWidth = scrollContainer:GetWidth()
    self.canvasWidth = (currentCanvasWidth and currentCanvasWidth > 400 and currentCanvasWidth < 850) and currentCanvasWidth or 702

    -- 2. Intercept QuestsFrame.ScrollFrame.Hide so the quest list never disappears
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

    -- 3. Hook Blizzard Show / Close functions
    if type(QuestMapFrame_ShowQuestDetails) == "function" then
        hooksecurefunc("QuestMapFrame_ShowQuestDetails", function(questID)
            if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
                OneWorldMap.DoubleWide:ApplyDoubleWideLayout(true)
            end
        end)
    end

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

    -- Back button
    local backButton = (detailsFrame.BackFrame and detailsFrame.BackFrame.BackButton) or detailsFrame.BackButton
    if backButton then
        backButton:HookScript("OnClick", function()
            if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide then
                OneWorldMap.DoubleWide:ApplyDoubleWideLayout(false)
            end
        end)
    end

    -- Hook WorldMap OnShow to re-apply anchored layout
    wmFrame:HookScript("OnShow", function()
        OneWorldMap.DoubleWide:LockCanvasAndLayout()
        OneWorldMap.DoubleWide:ApplyDoubleWideLayout(detailsFrame:IsShown())
    end)

    self:LockCanvasAndLayout()
    self:ApplyDoubleWideLayout(detailsFrame:IsShown())
end

function OneWorldMap.DoubleWide:LockCanvasAndLayout()
    if InCombatLockdown() then return end

    local wmFrame = WorldMapFrame
    local scrollContainer = wmFrame and wmFrame.ScrollContainer
    local qmFrame = QuestMapFrame
    if not scrollContainer or not qmFrame then return end

    local cWidth = self.canvasWidth or 702

    -- Lock map canvas to the left of WorldMapFrame with fixed width
    scrollContainer:ClearAllPoints()
    scrollContainer:SetPoint("TOPLEFT", wmFrame, "TOPLEFT", 4, -68)
    scrollContainer:SetPoint("BOTTOMLEFT", wmFrame, "BOTTOMLEFT", 4, 4)
    scrollContainer:SetWidth(cWidth)

    -- Constrain top TitleCanvasSpacerFrame so NavBar matches the canvas width
    if wmFrame.TitleCanvasSpacerFrame then
        wmFrame.TitleCanvasSpacerFrame:ClearAllPoints()
        wmFrame.TitleCanvasSpacerFrame:SetPoint("TOPLEFT", wmFrame, "TOPLEFT", 4, 0)
        wmFrame.TitleCanvasSpacerFrame:SetPoint("BOTTOMRIGHT", scrollContainer, "TOPRIGHT", 0, 0)
    end

    -- Anchor QuestMapFrame directly to the right edge of the map canvas
    qmFrame:ClearAllPoints()
    qmFrame:SetPoint("TOPLEFT", scrollContainer, "TOPRIGHT", 0, 0)
    qmFrame:SetPoint("BOTTOMLEFT", scrollContainer, "BOTTOMRIGHT", 0, 0)
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

    self:LockCanvasAndLayout()

    local cWidth = self.canvasWidth or 702
    local questListWidth = 300
    local detailsWidth = 308
    local gap = 8

    -- Always position QuestsFrame cleanly inside QuestMapFrame
    questsFrame:ClearAllPoints()
    questsFrame:SetPoint("TOPLEFT", qmFrame, "TOPLEFT", 0, 0)
    questsFrame:SetPoint("BOTTOMLEFT", qmFrame, "BOTTOMLEFT", 0, 0)
    questsFrame:SetWidth(questListWidth)
    questsFrame:Show()

    -- Lock QuestScrollFrame inside QuestsFrame with margin for scrollbar
    questScroll:ClearAllPoints()
    questScroll:SetPoint("TOPLEFT", questsFrame, "TOPLEFT", 0, -29)
    questScroll:SetPoint("BOTTOMRIGHT", questsFrame, "BOTTOMRIGHT", -24, 0)
    questScroll:Show()

    -- Lock QuestScrollFrame.ScrollBar strictly inside QuestsFrame
    if questScroll.ScrollBar then
        questScroll.ScrollBar:ClearAllPoints()
        questScroll.ScrollBar:SetPoint("TOPRIGHT", questsFrame, "TOPRIGHT", -4, -31)
        questScroll.ScrollBar:SetPoint("BOTTOMRIGHT", questsFrame, "BOTTOMRIGHT", -4, 4)
    end

    if isDetailsOpen and (OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide) then
        if self.adjusting then return end
        self.adjusting = true

        -- Expand QuestMapFrame to encompass both columns
        local totalQuestAreaWidth = questListWidth + gap + detailsWidth + 6
        qmFrame:SetWidth(totalQuestAreaWidth)

        -- Expand WorldMapFrame to the right only (anchored at TOPLEFT)
        wmFrame:SetWidth(4 + cWidth + totalQuestAreaWidth)

        -- Anchor DetailsFrame side-by-side to right of QuestsFrame
        detailsFrame:ClearAllPoints()
        detailsFrame:SetPoint("TOPLEFT", questsFrame, "TOPRIGHT", gap, 0)
        detailsFrame:SetPoint("BOTTOMLEFT", questsFrame, "BOTTOMRIGHT", gap, 0)
        detailsFrame:SetWidth(detailsWidth)

        -- Constrain DetailsFrame ScrollBar inside DetailsFrame panel
        local detailsScroll = detailsFrame.ScrollFrame or _G["QuestMapDetailsScrollFrame"]
        if detailsScroll and detailsScroll.ScrollBar then
            detailsScroll.ScrollBar:ClearAllPoints()
            detailsScroll.ScrollBar:SetPoint("TOPRIGHT", detailsFrame, "TOPRIGHT", -6, -48)
            detailsScroll.ScrollBar:SetPoint("BOTTOMRIGHT", detailsFrame, "BOTTOMRIGHT", -6, 28)
        end

        self.adjusting = false
    else
        if self.adjusting then return end
        self.adjusting = true

        -- Single-column width
        local singleQuestAreaWidth = 330
        qmFrame:SetWidth(singleQuestAreaWidth)
        wmFrame:SetWidth(4 + cWidth + singleQuestAreaWidth)

        self.adjusting = false
    end
end

function OneWorldMap.DoubleWide:RefreshLayout()
    local detailsFrame = QuestMapFrame and QuestMapFrame.DetailsFrame
    local isDetailsOpen = detailsFrame and detailsFrame:IsShown()
    self:ApplyDoubleWideLayout(isDetailsOpen)
end
