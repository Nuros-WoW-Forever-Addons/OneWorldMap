-- OneWorldMap: Sidebar.lua
-- Left metadata drawer panel displaying zone level ranges, gathering minimums, fishing, and dungeons.

OneWorldMap = OneWorldMap or {}
OneWorldMap.Sidebar = {}

OneWorldMap:RegisterModule("Sidebar", function(addon)
    OneWorldMap.Sidebar:Init()
end)

function OneWorldMap.Sidebar:Init()
    local wmFrame = WorldMapFrame
    if not wmFrame then return end

    local width = (OneWorldMapDB and OneWorldMapDB.sidebar and OneWorldMapDB.sidebar.width) or 180

    -- Create sidebar frame
    local frame = CreateFrame("Frame", "OneWorldMap_SidebarFrame", wmFrame, BackdropTemplateMixin and "BackdropTemplate")
    self.frame = frame
    frame:SetWidth(width)
    frame:SetPoint("TOPRIGHT", wmFrame, "TOPLEFT", 0, 0)
    frame:SetPoint("BOTTOMRIGHT", wmFrame, "BOTTOMLEFT", 0, 0)

    -- Backdrop
    if frame.SetBackdrop then
        frame:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = false,
            edgeSize = 14,
            insets = { left = 3, right = 3, top = 3, bottom = 3 },
        })
        frame:SetBackdropColor(0.08, 0.08, 0.10, 0.90)
        frame:SetBackdropBorderColor(0.6, 0.6, 0.6, 0.8)
    end

    -- Scroll / content container
    local content = CreateFrame("Frame", nil, frame)
    self.content = content
    content:SetAllPoints(frame)

    -- Title: Zone Metadata
    local title = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    title:SetPoint("TOP", content, "TOP", 0, -12)
    title:SetText("Zone Metadata")
    title:SetTextColor(1.0, 0.82, 0.0) -- Gold
    self.title = title

    -- Title separator line
    local sep = content:CreateTexture(nil, "ARTWORK")
    sep:SetHeight(1)
    sep:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -15, -6)
    sep:SetPoint("TOPRIGHT", title, "BOTTOMRIGHT", 15, -6)
    sep:SetColorTexture(0.5, 0.5, 0.5, 0.5)

    -- Zone Name & Bracket
    local zoneHeader = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    zoneHeader:SetPoint("TOP", sep, "BOTTOM", 0, -10)
    zoneHeader:SetTextColor(0.9, 0.8, 0.5)
    self.zoneHeader = zoneHeader

    -- Gathering Header
    local gatheringTitle = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    gatheringTitle:SetPoint("TOPLEFT", content, "TOPLEFT", 12, -75)
    gatheringTitle:SetText("Gathering")
    gatheringTitle:SetTextColor(1.0, 0.82, 0.0)

    -- Gathering Body
    local gatheringBody = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    gatheringBody:SetPoint("TOPLEFT", gatheringTitle, "BOTTOMLEFT", 4, -4)
    gatheringBody:SetPoint("RIGHT", content, "RIGHT", -10, 0)
    gatheringBody:SetJustifyH("LEFT")
    self.gatheringBody = gatheringBody

    -- Dungeon Header
    local dungeonTitle = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    dungeonTitle:SetPoint("TOPLEFT", content, "TOPLEFT", 12, -220)
    dungeonTitle:SetText("Dungeon:")
    dungeonTitle:SetTextColor(1.0, 0.82, 0.0)
    self.dungeonTitle = dungeonTitle

    -- Dungeon Body
    local dungeonBody = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    dungeonBody:SetPoint("TOPLEFT", dungeonTitle, "BOTTOMLEFT", 4, -4)
    dungeonBody:SetPoint("RIGHT", content, "RIGHT", -10, 0)
    dungeonBody:SetJustifyH("LEFT")
    self.dungeonBody = dungeonBody

    -- Sidebar coordinates text at the bottom of the drawer
    local coordsHeader = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    coordsHeader:SetPoint("BOTTOMLEFT", content, "BOTTOMLEFT", 12, 50)
    coordsHeader:SetText("Coordinates:")
    coordsHeader:SetTextColor(1.0, 0.82, 0.0)

    local coordsBody = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    coordsBody:SetPoint("TOPLEFT", coordsHeader, "BOTTOMLEFT", 4, -4)
    coordsBody:SetJustifyH("LEFT")
    coordsBody:SetText("Player: --, --\nCursor: --, --")
    self.coordsBody = coordsBody

    -- Collapse / Expand Chevron Button
    local toggleBtn = CreateFrame("Button", "OneWorldMap_SidebarToggleBtn", wmFrame, "UIPanelButtonTemplate")
    self.toggleBtn = toggleBtn
    toggleBtn:SetSize(22, 22)
    toggleBtn:SetPoint("BOTTOMLEFT", wmFrame, "BOTTOMLEFT", 4, 4)
    toggleBtn:SetText("<")
    toggleBtn:SetScript("OnClick", function()
        OneWorldMapDB.sidebar.collapsed = not OneWorldMapDB.sidebar.collapsed
        OneWorldMap.Sidebar:UpdateState()
    end)

    -- Hook WorldMap updates
    wmFrame:HookScript("OnShow", function()
        OneWorldMap.Sidebar:UpdateZoneData()
        OneWorldMap.Sidebar:UpdateState()
    end)

    if wmFrame.OnMapChanged then
        hooksecurefunc(wmFrame, "OnMapChanged", function()
            OneWorldMap.Sidebar:UpdateZoneData()
        end)
    end

    -- Event listener for area changes
    local eventWatcher = CreateFrame("Frame")
    eventWatcher:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    eventWatcher:RegisterEvent("ZONE_CHANGED")
    eventWatcher:RegisterEvent("ZONE_CHANGED_INDOORS")
    eventWatcher:SetScript("OnEvent", function()
        if wmFrame:IsShown() then
            OneWorldMap.Sidebar:UpdateZoneData()
        end
    end)

    self:UpdateState()
    self:UpdateZoneData()
end

function OneWorldMap.Sidebar:UpdateZoneData()
    local wmFrame = WorldMapFrame
    if not wmFrame or not self.frame then return end

    local uiMapID = nil
    if wmFrame.GetMapID then
        uiMapID = wmFrame:GetMapID()
    elseif C_Map and C_Map.GetBestMapForUnit then
        uiMapID = C_Map.GetBestMapForUnit("player")
    end

    local zoneName = GetZoneText and GetZoneText()
    local info = OneWorldMap:GetZoneInfo(uiMapID, zoneName)

    if info then
        self.zoneHeader:SetText(string.format("%s (%d-%d)", info.name, info.minLevel or 1, info.maxLevel or 60))

        -- Gathering string
        local gText = ""
        if info.herbs and #info.herbs > 0 then
            gText = gText .. "|cffffffffHerb:|r\n"
            for _, herb in ipairs(info.herbs) do
                gText = gText .. string.format("  %s %d\n", herb.name, herb.skill)
            end
        end

        if info.ores and #info.ores > 0 then
            gText = gText .. "|cffffffffOre:|r\n"
            for _, ore in ipairs(info.ores) do
                gText = gText .. string.format("  %s %d\n", ore.name, ore.skill)
            end
        end

        if info.fishing then
            gText = gText .. string.format("|cffffffffFishing:|r %d+\n", info.fishing)
        end

        self.gatheringBody:SetText(gText ~= "" and gText or "|cff888888None|r")

        -- Dungeon string
        if info.dungeons and #info.dungeons > 0 then
            local dText = ""
            for _, dun in ipairs(info.dungeons) do
                dText = dText .. string.format("%s\n(%d-%d)\n", dun.name, dun.minLevel, dun.maxLevel)
            end
            self.dungeonTitle:Show()
            self.dungeonBody:SetText(dText)
        else
            self.dungeonTitle:Hide()
            self.dungeonBody:SetText("")
        end
    else
        local currentName = zoneName or (uiMapID and ("Zone " .. tostring(uiMapID))) or "Unknown Zone"
        self.zoneHeader:SetText(currentName)
        self.gatheringBody:SetText("|cff888888No gathering data|r")
        self.dungeonTitle:Hide()
        self.dungeonBody:SetText("")
    end
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
        self:UpdateZoneData()
    end
end

function OneWorldMap.Sidebar:UpdateCoordsText(playerText, cursorText)
    if self.coordsBody and self.frame:IsShown() then
        self.coordsBody:SetText(string.format("Player %s\nCursor: %s", playerText or "--, --", cursorText or "--, --"))
    end
end
