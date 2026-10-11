-- OneWorldMap: Sidebar.lua
-- Left metadata drawer panel displaying zone level ranges, gathering minimums (Herbs, Ore, Skinning, Fishing),
-- and dungeon brackets in an alternating-row table layout matching OnePanel_Character stats,
-- styled in the native Blizzard bronze frame with collapsible headers and an inner map canvas toggle button.

OneWorldMap = OneWorldMap or {}
OneWorldMap.Sidebar = {}

OneWorldMap:RegisterModule("Sidebar", function(addon)
    OneWorldMap.Sidebar:Init()
end)

function OneWorldMap.Sidebar:Init()
    local wmFrame = WorldMapFrame
    if not wmFrame then return end

    local width = (OneWorldMapDB and OneWorldMapDB.sidebar and OneWorldMapDB.sidebar.width) or 210

    -- 1. Create sidebar frame using native Blizzard bronze ButtonFrameTemplate (with fallback)
    local frame = nil
    local ok = pcall(function()
        frame = CreateFrame("Frame", "OneWorldMap_SidebarFrame", wmFrame, "ButtonFrameTemplate")
    end)
    if not ok or not frame then
        frame = CreateFrame("Frame", "OneWorldMap_SidebarFrame", wmFrame, BackdropTemplateMixin and "BackdropTemplate")
        if frame.SetBackdrop then
            frame:SetBackdrop({
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
                tile = true,
                tileSize = 32,
                edgeSize = 24,
                insets = { left = 8, right = 8, top = 8, bottom = 8 },
            })
            frame:SetBackdropColor(1, 1, 1, 1)
            frame:SetBackdropBorderColor(1, 1, 1, 1)
        end
    end

    self.frame = frame
    frame:SetWidth(width)
    frame:SetPoint("TOPRIGHT", wmFrame, "TOPLEFT", 0, 0)
    frame:SetPoint("BOTTOMRIGHT", wmFrame, "BOTTOMLEFT", 0, 0)

    -- Window Title Text
    if frame.TitleText then
        frame.TitleText:SetText("Zone Details")
    else
        local title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        title:SetPoint("TOP", frame, "TOP", 0, -8)
        title:SetText("Zone Details")
        frame.TitleText = title
    end

    -- Hook native CloseButton to collapse drawer
    if frame.CloseButton then
        frame.CloseButton:SetScript("OnClick", function()
            if OneWorldMapDB and OneWorldMapDB.sidebar then
                OneWorldMapDB.sidebar.collapsed = true
            end
            OneWorldMap.Sidebar:UpdateState()
        end)
    end

    -- 2. Inner Content & ScrollFrame (anchored inside Inset or frame)
    local inset = frame.Inset or frame
    local scrollFrame = CreateFrame("ScrollFrame", "OneWorldMap_SidebarScrollFrame", inset, "UIPanelScrollFrameTemplate")
    self.scrollFrame = scrollFrame
    scrollFrame:SetPoint("TOPLEFT", inset, "TOPLEFT", 6, -6)
    scrollFrame:SetPoint("BOTTOMRIGHT", inset, "BOTTOMRIGHT", -26, 6)

    local scrollChild = CreateFrame("Frame", "OneWorldMap_SidebarScrollChild", scrollFrame)
    scrollChild:SetWidth(width - 36)
    scrollChild:SetHeight(200)
    scrollFrame:SetScrollChild(scrollChild)
    self.scrollChild = scrollChild

    self.elements = {}

    -- 3. Map Canvas Collapse / Expand Toggle Button
    -- Anchored at the inner bottom-left corner of the map canvas
    local canvas = wmFrame.ScrollContainer or wmFrame
    local toggleBtn = CreateFrame("Button", "OneWorldMap_SidebarToggleBtn", canvas, "UIPanelButtonTemplate")
    self.toggleBtn = toggleBtn
    toggleBtn:SetSize(24, 24)
    toggleBtn:SetPoint("BOTTOMLEFT", canvas, "BOTTOMLEFT", 6, 6)
    toggleBtn:SetFrameLevel(canvas:GetFrameLevel() + 20)
    toggleBtn:SetText("<")

    toggleBtn:SetScript("OnClick", function()
        if OneWorldMapDB and OneWorldMapDB.sidebar then
            OneWorldMapDB.sidebar.collapsed = not OneWorldMapDB.sidebar.collapsed
        end
        OneWorldMap.Sidebar:UpdateState()
    end)

    toggleBtn:SetScript("OnEnter", function(btn)
        local isCollapsed = OneWorldMapDB and OneWorldMapDB.sidebar and OneWorldMapDB.sidebar.collapsed
        GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
        GameTooltip:SetText(isCollapsed and "Expand Zone Details" or "Collapse Zone Details")
        GameTooltip:Show()
    end)
    toggleBtn:SetScript("OnLeave", GameTooltip_Hide)

    -- 4. Hook WorldMap & Area Change Events
    wmFrame:HookScript("OnShow", function()
        OneWorldMap.Sidebar:UpdateState()
        OneWorldMap.Sidebar:RefreshTable()
    end)

    if wmFrame.OnMapChanged then
        hooksecurefunc(wmFrame, "OnMapChanged", function()
            OneWorldMap.Sidebar:RefreshTable()
        end)
    end

    local eventWatcher = CreateFrame("Frame")
    eventWatcher:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    eventWatcher:RegisterEvent("ZONE_CHANGED")
    eventWatcher:RegisterEvent("ZONE_CHANGED_INDOORS")
    eventWatcher:SetScript("OnEvent", function()
        if wmFrame:IsShown() then
            OneWorldMap.Sidebar:RefreshTable()
        end
    end)

    self:UpdateState()
    self:RefreshTable()
end

function OneWorldMap.Sidebar:UpdateState()
    local isCollapsed = OneWorldMapDB and OneWorldMapDB.sidebar and OneWorldMapDB.sidebar.collapsed
    if isCollapsed then
        self.frame:Hide()
        if self.toggleBtn then
            self.toggleBtn:SetText(">")
        end
    else
        self.frame:Show()
        if self.toggleBtn then
            self.toggleBtn:SetText("<")
        end
        self:RefreshTable()
    end
end

local function GetOrCreateHeaderButton(parent, elements, index)
    local btn = elements[index]
    if not btn or btn.elementType ~= "header" then
        btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
        btn.elementType = "header"
        elements[index] = btn
    end
    btn:Show()
    return btn
end

local function GetOrCreateDataRow(parent, elements, index)
    local row = elements[index]
    if not row or row.elementType ~= "row" then
        row = CreateFrame("Frame", nil, parent)
        row.elementType = "row"

        local bg = row:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(row)
        row.bg = bg

        local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        label:SetPoint("LEFT", row, "LEFT", 6, 0)
        label:SetJustifyH("LEFT")
        row.label = label

        local val = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightRight")
        val:SetPoint("RIGHT", row, "RIGHT", -6, 0)
        val:SetJustifyH("RIGHT")
        row.val = val

        elements[index] = row
    end
    row:Show()
    return row
end

function OneWorldMap.Sidebar:RefreshTable()
    local wmFrame = WorldMapFrame
    if not wmFrame or not self.frame or not self.scrollChild then return end

    -- Hide all existing elements before rebuild
    for _, el in ipairs(self.elements) do
        el:Hide()
    end

    local uiMapID = nil
    if wmFrame.GetMapID then
        uiMapID = wmFrame:GetMapID()
    elseif C_Map and C_Map.GetBestMapForUnit then
        uiMapID = C_Map.GetBestMapForUnit("player")
    end

    local mapInfo = (C_Map and uiMapID and C_Map.GetMapInfo) and C_Map.GetMapInfo(uiMapID)
    local zoneName = (mapInfo and mapInfo.name) or (GetZoneText and GetZoneText())

    local info = OneWorldMap:GetZoneInfo(uiMapID, zoneName)
    local collapsedHeaders = (OneWorldMapDB and OneWorldMapDB.sidebar and OneWorldMapDB.sidebar.collapsedHeaders) or {}
    if OneWorldMapDB and OneWorldMapDB.sidebar and not OneWorldMapDB.sidebar.collapsedHeaders then
        OneWorldMapDB.sidebar.collapsedHeaders = collapsedHeaders
    end

    local elIdx = 1
    local yOffset = -4
    local contentWidth = self.scrollFrame:GetWidth() or 174
    if contentWidth < 100 then contentWidth = 174 end

    -- Helper to add a collapsible category header button
    local function AddCategoryHeader(key, titleText)
        local isCollapsed = collapsedHeaders[key] == true
        local btn = GetOrCreateHeaderButton(self.scrollChild, self.elements, elIdx)
        elIdx = elIdx + 1

        btn:ClearAllPoints()
        btn:SetSize(contentWidth, 22)
        btn:SetPoint("TOPLEFT", self.scrollChild, "TOPLEFT", 0, yOffset)
        btn:SetText((isCollapsed and "[+] " or "[-] ") .. titleText)

        btn:SetScript("OnClick", function()
            collapsedHeaders[key] = not collapsedHeaders[key]
            OneWorldMap.Sidebar:RefreshTable()
        end)

        yOffset = yOffset - 24
        return not isCollapsed
    end

    -- Helper to add an alternating data row
    local dataRowCounter = 0
    local function AddDataRow(labelStr, valStr, isMuted)
        dataRowCounter = dataRowCounter + 1
        local row = GetOrCreateDataRow(self.scrollChild, self.elements, elIdx)
        elIdx = elIdx + 1

        row:ClearAllPoints()
        row:SetSize(contentWidth, 20)
        row:SetPoint("TOPLEFT", self.scrollChild, "TOPLEFT", 0, yOffset)

        if dataRowCounter % 2 == 1 then
            row.bg:SetColorTexture(0.12, 0.12, 0.12, 0.5)
        else
            row.bg:SetColorTexture(0, 0, 0, 0)
        end

        if isMuted then
            row.label:SetText("|cff888888" .. (labelStr or "") .. "|r")
        else
            row.label:SetText("|cffffd100" .. (labelStr or "") .. "|r")
        end

        row.val:SetText(valStr or "")

        yOffset = yOffset - 20
    end

    if info then
        -- 1. Zone Info (Title Header & Level Bracket)
        local isZoneExpanded = AddCategoryHeader("zone", info.name)
        if isZoneExpanded then
            dataRowCounter = 0
            AddDataRow("Level Range", string.format("%d - %d", info.minLevel or 1, info.maxLevel or 60))
        end

        -- 2. Herbs Category
        local isHerbsExpanded = AddCategoryHeader("herbs", "Herbs:")
        if isHerbsExpanded then
            dataRowCounter = 0
            if info.herbs and #info.herbs > 0 then
                for _, herb in ipairs(info.herbs) do
                    AddDataRow(herb.name, tostring(herb.skill))
                end
            else
                AddDataRow("None", "", true)
            end
        end

        -- 3. Ore Category
        local isOreExpanded = AddCategoryHeader("ore", "Ore:")
        if isOreExpanded then
            dataRowCounter = 0
            if info.ores and #info.ores > 0 then
                for _, ore in ipairs(info.ores) do
                    AddDataRow(ore.name, tostring(ore.skill))
                end
            else
                AddDataRow("None", "", true)
            end
        end

        -- 4. Skinning Category
        local isSkinExpanded = AddCategoryHeader("skin", "Skin:")
        if isSkinExpanded then
            dataRowCounter = 0
            if info.skins and #info.skins > 0 then
                for _, skin in ipairs(info.skins) do
                    AddDataRow(skin.name, tostring(skin.skill))
                end
            else
                AddDataRow("None", "", true)
            end
        end

        -- 5. Fishing Category
        local isFishExpanded = AddCategoryHeader("fish", "Fish:")
        if isFishExpanded then
            dataRowCounter = 0
            if info.fishing then
                AddDataRow("Minimum Skill", tostring(info.fishing) .. "+")
            else
                AddDataRow("None", "", true)
            end
        end

        -- 6. Dungeons Category
        if info.dungeons and #info.dungeons > 0 then
            local isDungExpanded = AddCategoryHeader("dungeons", "Dungeons:")
            if isDungExpanded then
                dataRowCounter = 0
                for _, dun in ipairs(info.dungeons) do
                    AddDataRow(dun.name, string.format("%d - %d", dun.minLevel, dun.maxLevel))
                end
            end
        end
    else
        -- Unrecognized / non-cataloged zone
        local currentName = zoneName or (uiMapID and ("Zone " .. tostring(uiMapID))) or "Unknown Zone"
        AddCategoryHeader("zone", currentName)
        dataRowCounter = 0
        AddDataRow("No gathering data", "", true)
    end

    self.scrollChild:SetHeight(math.abs(yOffset) + 20)
end
