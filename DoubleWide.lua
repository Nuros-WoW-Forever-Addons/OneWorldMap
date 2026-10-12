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
    -- Use secure post-hooks so Blizzard's original methods remain untouched and untainted.
    hooksecurefunc(questScroll, "Hide", function(self)
        if OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide and not self.allowHide then
            if detailsFrame:IsShown() then
                self:Show()
            end
        end
    end)

    hooksecurefunc(questsFrame, "Hide", function(self)
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
                if not questsFrame:IsShown() then
                    questsFrame:Show()
                end
                if not questScroll:IsShown() then
                    questScroll:Show()
                end
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
            if not questsFrame:IsShown() then
                questsFrame:Show()
            end
            if not questScroll:IsShown() then
                questScroll:Show()
            end
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

    -- 4. Pre-anchor DetailsFrame side-by-side so it is never positioned over QuestsFrame even in combat
    local panelWidth = 330
    detailsFrame:ClearAllPoints()
    detailsFrame:SetPoint("TOPLEFT", qmFrame, "TOPLEFT", panelWidth, 0)
    detailsFrame:SetPoint("BOTTOMLEFT", qmFrame, "BOTTOMLEFT", panelWidth, 0)
    detailsFrame:SetWidth(panelWidth)

    -- 5. Hook QuestMapFrame show/hide (when user collapses or expands the quest log)
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

    -- 6. Hook WorldMap OnShow to re-apply anchored layout
    wmFrame:HookScript("OnShow", function()
        OneWorldMap.DoubleWide:ApplyDoubleWideLayout()
    end)

    self:ApplyDoubleWideLayout()
end

function OneWorldMap.DoubleWide:ApplyDoubleWideLayout()

    local wmFrame = WorldMapFrame
    local scrollContainer = wmFrame and wmFrame.ScrollContainer
    local qmFrame = QuestMapFrame
    if not wmFrame or not scrollContainer or not qmFrame then return end

    local questsFrame = qmFrame.QuestsFrame
    local detailsFrame = qmFrame.DetailsFrame
    local questScroll = questsFrame and questsFrame.ScrollFrame
    if not questsFrame or not detailsFrame or not questScroll then return end

    local cWidth = self.canvasWidth or 702
    local panelWidth = 330 -- Default Blizzard QuestMapFrame panel width

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

    -- PANEL 1: Quest List (exact default 330px panel dimensions)
    questsFrame:ClearAllPoints()
    questsFrame:SetPoint("TOPLEFT", qmFrame, "TOPLEFT", 0, 0)
    questsFrame:SetPoint("BOTTOMLEFT", qmFrame, "BOTTOMLEFT", 0, 0)
    questsFrame:SetWidth(panelWidth)
    questsFrame:Show()

    -- Quest List scroll frame leaves exact 22px gutter for scrollbar and stops at y = 23 above bottom border
    questScroll:ClearAllPoints()
    questScroll:SetPoint("TOPLEFT", questsFrame, "TOPLEFT", 0, -29)
    questScroll:SetPoint("BOTTOMRIGHT", questsFrame, "BOTTOMRIGHT", -22, 23)
    questScroll:Show()

    -- Panel 1: 22px slate-gray scrollbar gutter background
    if not questsFrame.ScrollGutterBg then
        local bg = questsFrame:CreateTexture(nil, "BACKGROUND", nil, 1)
        questsFrame.ScrollGutterBg = bg
    end
    questsFrame.ScrollGutterBg:ClearAllPoints()
    questsFrame.ScrollGutterBg:SetPoint("TOPLEFT", questsFrame, "TOPRIGHT", -22, -29)
    questsFrame.ScrollGutterBg:SetPoint("BOTTOMRIGHT", questsFrame, "BOTTOMRIGHT", 0, 23)
    questsFrame.ScrollGutterBg:SetColorTexture(0.18, 0.18, 0.20, 0.95)
    questsFrame.ScrollGutterBg:Show()

    -- Panel 1: ScrollBar centered in the 22px gutter
    if questScroll.ScrollBar then
        questScroll.ScrollBar:ClearAllPoints()
        questScroll.ScrollBar:SetPoint("TOPLEFT", questScroll, "TOPRIGHT", 7, 2)
        questScroll.ScrollBar:SetPoint("BOTTOMLEFT", questScroll, "BOTTOMRIGHT", 7, -2)
        if questScroll.ScrollBar.GutterBg then
            questScroll.ScrollBar.GutterBg:Hide()
        end
    end

    -- Cleanup legacy background textures
    if detailsFrame.BackingBg then
        detailsFrame.BackingBg:Hide()
    end

    local detailsScroll = detailsFrame.ScrollFrame or _G["QuestMapDetailsScrollFrame"]
    if detailsScroll and detailsScroll.ScrollBar and detailsScroll.ScrollBar.ScrollBarBg then
        detailsScroll.ScrollBar.ScrollBarBg:Hide()
    end

    local isDetailsOpen = detailsFrame:IsShown()

    if isDetailsOpen and (OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide) then
        if self.adjusting then return end
        self.adjusting = true

        -- Additive double-wide: Panel 1 (330px) + Panel 2 (330px) = 660px
        local totalQuestAreaWidth = panelWidth * 2
        qmFrame:SetWidth(totalQuestAreaWidth)
        wmFrame:SetWidth(4 + cWidth + totalQuestAreaWidth + 4)

        -- PANEL 2: Quest Details (identically dimensioned 330px panel added to the right of Panel 1)
        detailsFrame:ClearAllPoints()
        detailsFrame:SetPoint("TOPLEFT", qmFrame, "TOPLEFT", panelWidth, 0)
        detailsFrame:SetPoint("BOTTOMLEFT", qmFrame, "BOTTOMLEFT", panelWidth, 0)
        detailsFrame:SetWidth(panelWidth)

        -- Constrain parchment background to 308px so it never bleeds behind the scrollbar
        if detailsFrame.Bg then
            detailsFrame.Bg:ClearAllPoints()
            detailsFrame.Bg:SetPoint("TOPLEFT", detailsFrame, "TOPLEFT", 0, 0)
            detailsFrame.Bg:SetPoint("BOTTOMRIGHT", detailsFrame, "BOTTOMRIGHT", -22, 0)
        end

        -- Details scroll frame leaves exact 22px gutter and stops at y = 23 above bottom buttons
        if detailsScroll then
            detailsScroll:ClearAllPoints()
            detailsScroll:SetPoint("TOPLEFT", detailsFrame, "TOPLEFT", 5, -43)
            detailsScroll:SetPoint("BOTTOMRIGHT", detailsFrame, "BOTTOMRIGHT", -22, 23)
        end

        -- Panel 2: 22px slate-gray scrollbar gutter background matching Panel 1 identically
        if not detailsFrame.ScrollGutterBg then
            local bg = detailsFrame:CreateTexture(nil, "BACKGROUND", nil, 1)
            detailsFrame.ScrollGutterBg = bg
        end
        detailsFrame.ScrollGutterBg:ClearAllPoints()
        detailsFrame.ScrollGutterBg:SetPoint("TOPLEFT", detailsFrame, "TOPRIGHT", -22, -43)
        detailsFrame.ScrollGutterBg:SetPoint("BOTTOMRIGHT", detailsFrame, "BOTTOMRIGHT", 0, 23)
        detailsFrame.ScrollGutterBg:SetColorTexture(0.18, 0.18, 0.20, 0.95)
        detailsFrame.ScrollGutterBg:Show()

        -- Panel 2: ScrollBar centered in the 22px gutter identically to Panel 1
        if detailsScroll and detailsScroll.ScrollBar then
            detailsScroll.ScrollBar:ClearAllPoints()
            detailsScroll.ScrollBar:SetPoint("TOPLEFT", detailsScroll, "TOPRIGHT", 7, 2)
            detailsScroll.ScrollBar:SetPoint("BOTTOMLEFT", detailsScroll, "BOTTOMRIGHT", 7, -2)
            if detailsScroll.ScrollBar.GutterBg then
                detailsScroll.ScrollBar.GutterBg:Hide()
            end
        end

        -- Constrain bottom action buttons to the 308px content width so they don't cover the gutter
        if detailsFrame.AbandonButton and detailsFrame.ShareButton and detailsFrame.TrackButton then
            detailsFrame.AbandonButton:ClearAllPoints()
            detailsFrame.AbandonButton:SetPoint("BOTTOMLEFT", detailsFrame, "BOTTOMLEFT", 4, 1)
            detailsFrame.AbandonButton:SetWidth(100)

            detailsFrame.ShareButton:ClearAllPoints()
            detailsFrame.ShareButton:SetPoint("LEFT", detailsFrame.AbandonButton, "RIGHT", 1, 0)
            detailsFrame.ShareButton:SetWidth(98)

            detailsFrame.TrackButton:ClearAllPoints()
            detailsFrame.TrackButton:SetPoint("LEFT", detailsFrame.ShareButton, "RIGHT", 1, 0)
            detailsFrame.TrackButton:SetWidth(100)
        end

        self.adjusting = false
    else
        if self.adjusting then return end
        self.adjusting = true

        if detailsFrame.ScrollGutterBg then
            detailsFrame.ScrollGutterBg:Hide()
        end

        -- Single-column width (List only, no details)
        qmFrame:SetWidth(panelWidth)
        wmFrame:SetWidth(4 + cWidth + panelWidth + 4)

        self.adjusting = false
    end
end

function OneWorldMap.DoubleWide:RefreshLayout()
    self:ApplyDoubleWideLayout()
end
