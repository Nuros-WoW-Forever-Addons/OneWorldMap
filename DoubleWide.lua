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
    local questListWidth = 306
    local detailsWidth = 308
    local gap = 2

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

    -- Anchor QuestsFrame cleanly inside QuestMapFrame
    questsFrame:ClearAllPoints()
    questsFrame:SetPoint("TOPLEFT", qmFrame, "TOPLEFT", 0, 0)
    questsFrame:SetPoint("BOTTOMLEFT", qmFrame, "BOTTOMLEFT", 0, 0)
    questsFrame:SetWidth(questListWidth)
    questsFrame:Show()

    -- Quest List scroll frame stops at y = 23 above the bottom to prevent colliding with the bottom border
    questScroll:ClearAllPoints()
    questScroll:SetPoint("TOPLEFT", questsFrame, "TOPLEFT", 0, -29)
    questScroll:SetPoint("BOTTOMRIGHT", questsFrame, "BOTTOMRIGHT", -18, 23)
    questScroll:Show()

    -- Hide any legacy gutter textures
    if questsFrame.ScrollGutterBg then
        questsFrame.ScrollGutterBg:Hide()
    end

    -- Quest List ScrollBar and authentic gray track background
    if questScroll.ScrollBar then
        questScroll.ScrollBar:ClearAllPoints()
        questScroll.ScrollBar:SetPoint("TOPLEFT", questScroll, "TOPRIGHT", 4, 0)
        questScroll.ScrollBar:SetPoint("BOTTOMLEFT", questScroll, "BOTTOMRIGHT", 4, 0)

        if not questScroll.ScrollBar.GutterBg then
            local bg = questScroll.ScrollBar:CreateTexture(nil, "BACKGROUND", nil, -1)
            questScroll.ScrollBar.GutterBg = bg
        end
        questScroll.ScrollBar.GutterBg:ClearAllPoints()
        questScroll.ScrollBar.GutterBg:SetPoint("TOPLEFT", questScroll.ScrollBar, "TOPLEFT", -2, 0)
        questScroll.ScrollBar.GutterBg:SetPoint("BOTTOMRIGHT", questScroll.ScrollBar, "BOTTOMRIGHT", 2, 0)
        questScroll.ScrollBar.GutterBg:SetColorTexture(0.20, 0.20, 0.22, 0.85)
        questScroll.ScrollBar.GutterBg:Show()
    end

    -- Cleanup legacy background textures
    if detailsFrame.BackingBg then
        detailsFrame.BackingBg:Hide()
    end
    if detailsFrame.ScrollGutterBg then
        detailsFrame.ScrollGutterBg:Hide()
    end

    local detailsScroll = detailsFrame.ScrollFrame or _G["QuestMapDetailsScrollFrame"]
    if detailsScroll and detailsScroll.ScrollBar and detailsScroll.ScrollBar.ScrollBarBg then
        detailsScroll.ScrollBar.ScrollBarBg:Hide()
    end

    local isDetailsOpen = detailsFrame:IsShown()

    if isDetailsOpen and (OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide) then
        if self.adjusting then return end
        self.adjusting = true

        -- Double-wide: expand QuestMapFrame and WorldMapFrame to fit 306px list + 308px details
        local totalQuestAreaWidth = questListWidth + gap + detailsWidth
        qmFrame:SetWidth(totalQuestAreaWidth)
        wmFrame:SetWidth(4 + cWidth + totalQuestAreaWidth + 4)

        -- Anchor DetailsFrame snugly next to QuestsFrame
        detailsFrame:ClearAllPoints()
        detailsFrame:SetPoint("TOPLEFT", questsFrame, "TOPRIGHT", gap, 0)
        detailsFrame:SetPoint("BOTTOMLEFT", questsFrame, "BOTTOMRIGHT", gap, 0)
        detailsFrame:SetWidth(detailsWidth)

        -- Details scroll frame stops at y = 23 above the bottom
        if detailsScroll then
            detailsScroll:ClearAllPoints()
            detailsScroll:SetPoint("TOPLEFT", detailsFrame, "TOPLEFT", 5, -43)
            detailsScroll:SetPoint("BOTTOMRIGHT", detailsFrame, "BOTTOMRIGHT", -18, 23)
        end

        -- Details ScrollBar and identical gray track background
        if detailsScroll and detailsScroll.ScrollBar then
            detailsScroll.ScrollBar:ClearAllPoints()
            detailsScroll.ScrollBar:SetPoint("TOPLEFT", detailsScroll, "TOPRIGHT", 4, 0)
            detailsScroll.ScrollBar:SetPoint("BOTTOMLEFT", detailsScroll, "BOTTOMRIGHT", 4, 0)

            if not detailsScroll.ScrollBar.GutterBg then
                local bg = detailsScroll.ScrollBar:CreateTexture(nil, "BACKGROUND", nil, -1)
                detailsScroll.ScrollBar.GutterBg = bg
            end
            detailsScroll.ScrollBar.GutterBg:ClearAllPoints()
            detailsScroll.ScrollBar.GutterBg:SetPoint("TOPLEFT", detailsScroll.ScrollBar, "TOPLEFT", -2, 0)
            detailsScroll.ScrollBar.GutterBg:SetPoint("BOTTOMRIGHT", detailsScroll.ScrollBar, "BOTTOMRIGHT", 2, 0)
            detailsScroll.ScrollBar.GutterBg:SetColorTexture(0.20, 0.20, 0.22, 0.85)
            detailsScroll.ScrollBar.GutterBg:Show()
        end

        self.adjusting = false
    else
        if self.adjusting then return end
        self.adjusting = true

        if detailsScroll and detailsScroll.ScrollBar and detailsScroll.ScrollBar.GutterBg then
            detailsScroll.ScrollBar.GutterBg:Hide()
        end

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
