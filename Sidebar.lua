-- OneWorldMap: Sidebar.lua
-- Left metadata drawer panel styled with authentic Blizzard bronze borders matching WorldMapFrame/GameMenu,
-- OnePanel_Character grey button headers with centered profession titles, wide untruncated data rows,
-- and a gold/yellow triangle arrow collapse toggle button.

OneWorldMap = OneWorldMap or {}
OneWorldMap.Sidebar = {}

OneWorldMap:RegisterModule("Sidebar", function(addon)
    OneWorldMap.Sidebar:Init()
end)

local BTN_DISABLED_UP   = "Interface\\Buttons\\UI-Panel-Button-Disabled"
local BTN_DISABLED_DOWN = "Interface\\Buttons\\UI-Panel-Button-Disabled-Down"
local BTN_HIGHLIGHT     = "Interface\\Buttons\\UI-Panel-Button-Highlight"

local function StyleButtonAsGrey(btn)
    if not btn or btn.isStyledAsGrey then return end
    btn.isStyledAsGrey = true

    -- Hide default button template textures if present
    local btnName = btn.GetName and btn:GetName()
    local oldLeft = btn.Left or (btnName and _G[btnName .. "Left"])
    local oldMiddle = btn.Middle or (btnName and _G[btnName .. "Middle"])
    local oldRight = btn.Right or (btnName and _G[btnName .. "Right"])
    if oldLeft then oldLeft:Hide() end
    if oldMiddle then oldMiddle:Hide() end
    if oldRight then oldRight:Hide() end

    local left = btn:CreateTexture(nil, "BACKGROUND")
    left:SetSize(12, 22)
    left:SetPoint("TOPLEFT", btn, "TOPLEFT", 0, 0)
    left:SetPoint("BOTTOMLEFT", btn, "BOTTOMLEFT", 0, 0)
    left:SetTexture(BTN_DISABLED_UP)
    left:SetTexCoord(0, 0.09375, 0, 0.6875)

    local right = btn:CreateTexture(nil, "BACKGROUND")
    right:SetSize(12, 22)
    right:SetPoint("TOPRIGHT", btn, "TOPRIGHT", 0, 0)
    right:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 0, 0)
    right:SetTexture(BTN_DISABLED_UP)
    right:SetTexCoord(0.53125, 0.625, 0, 0.6875)

    local middle = btn:CreateTexture(nil, "BACKGROUND")
    middle:SetPoint("TOPLEFT", left, "TOPRIGHT", 0, 0)
    middle:SetPoint("BOTTOMRIGHT", right, "BOTTOMLEFT", 0, 0)
    middle:SetTexture(BTN_DISABLED_UP)
    middle:SetTexCoord(0.09375, 0.53125, 0, 0.6875)

    local hlLeft = btn:CreateTexture(nil, "HIGHLIGHT")
    hlLeft:SetSize(12, 22)
    hlLeft:SetPoint("TOPLEFT", btn, "TOPLEFT", 0, 0)
    hlLeft:SetPoint("BOTTOMLEFT", btn, "BOTTOMLEFT", 0, 0)
    hlLeft:SetTexture(BTN_HIGHLIGHT)
    hlLeft:SetTexCoord(0, 0.09375, 0, 0.6875)
    hlLeft:SetBlendMode("ADD")

    local hlRight = btn:CreateTexture(nil, "HIGHLIGHT")
    hlRight:SetSize(12, 22)
    hlRight:SetPoint("TOPRIGHT", btn, "TOPRIGHT", 0, 0)
    hlRight:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 0, 0)
    hlRight:SetTexture(BTN_HIGHLIGHT)
    hlRight:SetTexCoord(0.53125, 0.625, 0, 0.6875)
    hlRight:SetBlendMode("ADD")

    local hlMid = btn:CreateTexture(nil, "HIGHLIGHT")
    hlMid:SetPoint("TOPLEFT", hlLeft, "TOPRIGHT", 0, 0)
    hlMid:SetPoint("BOTTOMRIGHT", hlRight, "BOTTOMLEFT", 0, 0)
    hlMid:SetTexture(BTN_HIGHLIGHT)
    hlMid:SetTexCoord(0.09375, 0.53125, 0, 0.6875)
    hlMid:SetBlendMode("ADD")

    btn:HookScript("OnMouseDown", function()
        left:SetTexture(BTN_DISABLED_DOWN)
        middle:SetTexture(BTN_DISABLED_DOWN)
        right:SetTexture(BTN_DISABLED_DOWN)
    end)
    btn:HookScript("OnMouseUp", function()
        left:SetTexture(BTN_DISABLED_UP)
        middle:SetTexture(BTN_DISABLED_UP)
        right:SetTexture(BTN_DISABLED_UP)
    end)

    if btn.SetPushedTextOffset then
        btn:SetPushedTextOffset(1, -1)
    end
end

function OneWorldMap.Sidebar:Init()
    local wmFrame = WorldMapFrame
    if not wmFrame then return end

    local width = math.max(290, (OneWorldMapDB and OneWorldMapDB.sidebar and OneWorldMapDB.sidebar.width) or 290)
    if OneWorldMapDB and OneWorldMapDB.sidebar then
        OneWorldMapDB.sidebar.width = width
    end

    -- 1. Create sidebar container frame anchored solidly to WorldMapFrame
    local frame = CreateFrame("Frame", "OneWorldMap_SidebarFrame", wmFrame, BackdropTemplateMixin and "BackdropTemplate")
    self.frame = frame
    frame:SetWidth(width)
    frame:ClearAllPoints()
    frame:SetPoint("TOPRIGHT", wmFrame, "TOPLEFT", 0, 0)
    frame:SetPoint("BOTTOMRIGHT", wmFrame, "BOTTOMLEFT", 0, 0)
    frame:SetFrameStrata(wmFrame:GetFrameStrata())
    frame:SetFrameLevel(wmFrame:GetFrameLevel() + 1)

    -- Dark background fill
    local bg = frame:CreateTexture(nil, "BACKGROUND", nil, -5)
    bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, -6)
    bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 6)
    bg:SetColorTexture(0.08, 0.08, 0.09, 0.95)
    frame.Bg = bg

    -- Authentic Blizzard Bronze border: try child NineSlice with Dialog layout, fallback to bronze Backdrop
    local borderChild = CreateFrame("Frame", nil, frame, "NineSlicePanelTemplate")
    borderChild:SetAllPoints(frame)
    frame.BorderChild = borderChild
    local nineSliceLoaded = false
    if NineSliceUtil and NineSliceUtil.ApplyLayout then
        local ok = pcall(NineSliceUtil.ApplyLayout, borderChild, "Dialog")
        nineSliceLoaded = ok and borderChild.NineSlice and (borderChild.NineSlice.TopLeftCorner ~= nil)
    end

    if not nineSliceLoaded and frame.SetBackdrop then
        frame:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true,
            tileSize = 32,
            edgeSize = 32,
            insets = { left = 11, right = 12, top = 12, bottom = 11 },
        })
        frame:SetBackdropColor(0.08, 0.08, 0.09, 0.95)
        frame:SetBackdropBorderColor(0.78, 0.60, 0.30, 1.0) -- Authentic Blizzard bronze/gold tint
    end

    -- Clean interior title (inside frame at the top)
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    title:SetPoint("TOP", frame, "TOP", 0, -14)
    title:SetText("Zone Details")
    title:SetTextColor(1.0, 0.82, 0.0) -- Gold
    self.title = title

    -- 2. Scrollable Table Container
    local scrollFrame = CreateFrame("ScrollFrame", "OneWorldMap_SidebarScrollFrame", frame, "UIPanelScrollFrameTemplate")
    self.scrollFrame = scrollFrame
    scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 14, -38)
    scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -32, 14)

    local scrollChild = CreateFrame("Frame", "OneWorldMap_SidebarScrollChild", scrollFrame)
    scrollChild:SetWidth(width - 46)
    scrollChild:SetHeight(200)
    scrollFrame:SetScrollChild(scrollChild)
    self.scrollChild = scrollChild

    self.elements = {}

    -- 3. Authentic Blizzard SpellBook Page Arrow Toggle Button at inner bottom-left of map canvas
    -- Points RIGHT to collapse into map, points LEFT to expand outward
    local canvas = wmFrame.ScrollContainer or wmFrame
    local toggleBtn = CreateFrame("Button", "OneWorldMap_SidebarToggleBtn", canvas)
    self.toggleBtn = toggleBtn
    toggleBtn:SetSize(26, 26)
    toggleBtn:SetPoint("BOTTOMLEFT", canvas, "BOTTOMLEFT", 6, 6)
    toggleBtn:SetFrameLevel(canvas:GetFrameLevel() + 20)

    local hl = toggleBtn:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints()
    hl:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
    hl:SetBlendMode("ADD")

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

    -- 4. Hook Events
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

function OneWorldMap.Sidebar:UpdateToggleArrow()
    if not self.toggleBtn then return end
    local isCollapsed = OneWorldMapDB and OneWorldMapDB.sidebar and OneWorldMapDB.sidebar.collapsed

    -- Points RIGHT to collapse into map, points LEFT to expand outward
    if isCollapsed then
        -- Collapsed -> arrow points LEFT (<) to expand drawer
        self.toggleBtn:SetNormalTexture("Interface\\Buttons\\UI-SpellBookIcon-PrevPage-Up")
        self.toggleBtn:SetPushedTexture("Interface\\Buttons\\UI-SpellBookIcon-PrevPage-Down")
        self.toggleBtn:SetDisabledTexture("Interface\\Buttons\\UI-SpellBookIcon-PrevPage-Disabled")
    else
        -- Open -> arrow points RIGHT (>) to collapse drawer
        self.toggleBtn:SetNormalTexture("Interface\\Buttons\\UI-SpellBookIcon-NextPage-Up")
        self.toggleBtn:SetPushedTexture("Interface\\Buttons\\UI-SpellBookIcon-NextPage-Down")
        self.toggleBtn:SetDisabledTexture("Interface\\Buttons\\UI-SpellBookIcon-NextPage-Disabled")
    end
end

function OneWorldMap.Sidebar:UpdateState()
    local wmFrame = WorldMapFrame
    if not wmFrame or not self.frame then return end

    local width = math.max(290, (OneWorldMapDB and OneWorldMapDB.sidebar and OneWorldMapDB.sidebar.width) or 290)
    self.frame:SetWidth(width)

    -- Re-assert anchor points to guarantee solid docking
    self.frame:ClearAllPoints()
    self.frame:SetPoint("TOPRIGHT", wmFrame, "TOPLEFT", 0, 0)
    self.frame:SetPoint("BOTTOMRIGHT", wmFrame, "BOTTOMLEFT", 0, 0)

    local isCollapsed = OneWorldMapDB and OneWorldMapDB.sidebar and OneWorldMapDB.sidebar.collapsed
    if isCollapsed then
        self.frame:Hide()
    else
        self.frame:Show()
        self:RefreshTable()
    end
    self:UpdateToggleArrow()
end

local function GetOrCreateHeaderButton(parent, elements, index)
    local btn = elements[index]
    if not btn or btn.elementType ~= "header" then
        btn = CreateFrame("Button", nil, parent)
        btn.elementType = "header"
        StyleButtonAsGrey(btn)

        local fontStr = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        fontStr:SetPoint("LEFT", btn, "LEFT", 8, 0)
        fontStr:SetPoint("RIGHT", btn, "RIGHT", -8, 0)
        fontStr:SetJustifyH("CENTER")
        btn.Text = fontStr

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

        local val = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightRight")
        val:SetPoint("RIGHT", row, "RIGHT", -8, 0)
        val:SetJustifyH("RIGHT")
        row.val = val

        local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        label:SetPoint("LEFT", row, "LEFT", 8, 0)
        label:SetPoint("RIGHT", val, "LEFT", -6, 0)
        label:SetJustifyH("LEFT")
        label:SetWordWrap(false)
        row.label = label

        elements[index] = row
    end
    row:Show()
    return row
end

function OneWorldMap.Sidebar:RefreshTable()
    local wmFrame = WorldMapFrame
    if not wmFrame or not self.frame or not self.scrollChild then return end

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

    local width = math.max(290, (OneWorldMapDB and OneWorldMapDB.sidebar and OneWorldMapDB.sidebar.width) or 290)
    self.frame:SetWidth(width)
    local contentWidth = width - 46
    self.scrollChild:SetWidth(contentWidth)

    local elIdx = 1
    local yOffset = -4

    -- Helper to add a grey button header with centered text (no - or +)
    local function AddCategoryHeader(key, titleText)
        local isCollapsed = collapsedHeaders[key] == true
        local btn = GetOrCreateHeaderButton(self.scrollChild, self.elements, elIdx)
        elIdx = elIdx + 1

        btn:ClearAllPoints()
        btn:SetSize(contentWidth, 22)
        btn:SetPoint("TOPLEFT", self.scrollChild, "TOPLEFT", 0, yOffset)

        btn.Text:SetText(titleText)

        btn:SetScript("OnClick", function()
            collapsedHeaders[key] = not collapsedHeaders[key]
            OneWorldMap.Sidebar:RefreshTable()
        end)

        yOffset = yOffset - 25
        return not isCollapsed
    end

    -- Helper to add an alternating data row with ample space
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
        -- 1. Zone Info Header (Centered Zone Name)
        local isZoneExpanded = AddCategoryHeader("zone", info.name)
        if isZoneExpanded then
            dataRowCounter = 0
            if info.isCity then
                AddDataRow("Zone Type", "Capital City")
            else
                AddDataRow("Level Range", string.format("%d - %d", info.minLevel or 1, info.maxLevel or 60))
            end
        end

        -- 2. Herbalism Header
        local isHerbsExpanded = AddCategoryHeader("herbs", "Herbalism")
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

        -- 3. Mining Header
        local isOreExpanded = AddCategoryHeader("ore", "Mining")
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

        -- 4. Skinning Header
        local isSkinExpanded = AddCategoryHeader("skin", "Skinning")
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

        -- 5. Fishing Header
        local isFishExpanded = AddCategoryHeader("fish", "Fishing")
        if isFishExpanded then
            dataRowCounter = 0
            if info.fish and #info.fish > 0 then
                for _, f in ipairs(info.fish) do
                    AddDataRow(f.name, tostring(f.skill))
                end
            elseif info.fishing then
                AddDataRow("Minimum Skill", tostring(info.fishing) .. "+")
            else
                AddDataRow("None", "", true)
            end
        end

        -- 6. Dungeons Header
        if info.dungeons and #info.dungeons > 0 then
            local isDungExpanded = AddCategoryHeader("dungeons", "Dungeons")
            if isDungExpanded then
                dataRowCounter = 0
                for _, dun in ipairs(info.dungeons) do
                    AddDataRow(dun.name, string.format("%d - %d", dun.minLevel, dun.maxLevel))
                end
            end
        end
    else
        -- Uncataloged zone
        local currentName = zoneName or (uiMapID and ("Zone " .. tostring(uiMapID))) or "Unknown Zone"
        AddCategoryHeader("zone", currentName)
        dataRowCounter = 0
        AddDataRow("No gathering data", "", true)
    end

    self.scrollChild:SetHeight(math.abs(yOffset) + 20)
end
