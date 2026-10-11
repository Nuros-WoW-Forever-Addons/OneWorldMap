-- OneWorldMap: Coordinates.lua
-- Throttled 10 Hz ticker bar displaying live Player and Cursor coordinates in a high-contrast pill box,
-- with automatic detection and suppression of default/unformatted coordinate readouts.

OneWorldMap = OneWorldMap or {}
OneWorldMap.Coordinates = {}

OneWorldMap:RegisterModule("Coordinates", function(addon)
    OneWorldMap.Coordinates:Init()
end)

function OneWorldMap.Coordinates:Init()
    local wmFrame = WorldMapFrame
    if not wmFrame then return end

    local canvas = wmFrame.ScrollContainer or _G["WorldMapButton"] or wmFrame
    self.canvas = canvas

    -- 1. Create the centered high-contrast pill box
    local pillBox = CreateFrame("Frame", "OneWorldMap_CoordsPillBox", canvas)
    self.frame = pillBox
    pillBox:SetPoint("BOTTOM", canvas, "BOTTOM", 0, 8)
    pillBox:SetSize(310, 22)
    pillBox:SetFrameStrata("HIGH")

    -- Black translucent background box
    local bg = pillBox:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(pillBox)
    bg:SetColorTexture(0, 0, 0, 0.70)
    self.bg = bg

    -- Border outline
    local border = pillBox:CreateTexture(nil, "BORDER")
    border:SetPoint("TOPLEFT", -1, 1)
    border:SetPoint("BOTTOMRIGHT", 1, -1)
    border:SetColorTexture(0.3, 0.3, 0.3, 0.6)

    -- Coordinate Text
    local text = pillBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    text:SetPoint("CENTER", pillBox, "CENTER", 0, 0)
    text:SetText("Player: --, -- | Cursor: --, --")
    self.text = text

    -- 2. Ticker logic
    self.updateInterval = 0.10 -- 10 Hz
    self.timeSinceLast = 0
    self.suppressAttempts = 0

    pillBox:SetScript("OnUpdate", function(f, elapsed)
        self.timeSinceLast = self.timeSinceLast + elapsed
        if self.timeSinceLast >= self.updateInterval then
            self.timeSinceLast = 0
            self:UpdateCoordinates()

            -- Periodically run suppression during the first 3 seconds of viewing to catch lazy inits
            if self.suppressAttempts < 30 then
                self.suppressAttempts = self.suppressAttempts + 1
                self:SuppressDefaultCoordinates()
            end
        end
    end)

    -- Run suppression on map open
    wmFrame:HookScript("OnShow", function()
        self.suppressAttempts = 0
        self:SuppressDefaultCoordinates()
    end)

    self:SuppressDefaultCoordinates()
    self:UpdateVisibility()
end

function OneWorldMap.Coordinates:SuppressDefaultCoordinates()
    -- Check common known global frames
    local knownFrames = {
        "WorldMapFrameCoordinates",
        "WorldMapCoordinates",
        "WorldMapPlayerCoords",
        "WorldMapCursorCoords",
        "WorldMapFrame_Coordinates",
        "CoordinatesFrame",
    }
    for _, name in ipairs(knownFrames) do
        local f = _G[name]
        if f and f ~= self.frame then
            f:SetAlpha(0)
            f:Hide()
            if f.SetScript then f:SetScript("OnUpdate", nil) end
            if not self.loggedFrames then self.loggedFrames = {} end
            if not self.loggedFrames[name] then
                self.loggedFrames[name] = true
                OneWorldMap:Log("Suppressed default coordinate frame: " .. name)
            end
        end
    end

    -- Deep scan of WorldMapFrame and ScrollContainer regions
    local function ScanContainer(container, depth)
        if not container or depth > 4 then return end

        local regions = { container:GetRegions() }
        for _, r in ipairs(regions) do
            if r:IsObjectType("FontString") and r ~= self.text then
                -- Exclude our own Sidebar coordinates
                local isSidebarText = OneWorldMap.Sidebar and (r == OneWorldMap.Sidebar.coordsBody)
                if not isSidebarText then
                    local txt = r:GetText()
                    if txt and (txt:find("Cursor") or txt:find("Player")) then
                        local identifier = r:GetName() or (container:GetName() and (container:GetName() .. ":FontString")) or "unnamed FontString"
                        if not self.loggedFrames then self.loggedFrames = {} end
                        if not self.loggedFrames[identifier] then
                            self.loggedFrames[identifier] = true
                            OneWorldMap:Log("Suppressed default coordinate display: " .. identifier)
                        end
                        r:SetAlpha(0)
                        r:Hide()
                        if not r.hookedByOneWorldMap then
                            r.hookedByOneWorldMap = true
                            hooksecurefunc(r, "SetText", function(s)
                                s:SetAlpha(0)
                                s:Hide()
                            end)
                        end
                    end
                end
            end
        end

        local children = { container:GetChildren() }
        for _, child in ipairs(children) do
            if child ~= self.frame and (not OneWorldMap.Sidebar or child ~= OneWorldMap.Sidebar.frame) then
                ScanContainer(child, depth + 1)
            end
        end
    end

    if WorldMapFrame then
        ScanContainer(WorldMapFrame, 1)
    end
    if WorldMapFrame and WorldMapFrame.ScrollContainer then
        ScanContainer(WorldMapFrame.ScrollContainer, 1)
    end
end

function OneWorldMap.Coordinates:UpdateCoordinates()
    local playerStr = "--, --"
    local cursorStr = "--, --"

    -- 1. Player Coordinates
    local uiMapID = nil
    if WorldMapFrame and WorldMapFrame.GetMapID then
        uiMapID = WorldMapFrame:GetMapID()
    elseif C_Map and C_Map.GetBestMapForUnit then
        uiMapID = C_Map.GetBestMapForUnit("player")
    end

    if C_Map and C_Map.GetPlayerMapPosition and uiMapID then
        local pos = C_Map.GetPlayerMapPosition(uiMapID, "player")
        if pos and pos.x and pos.y and (pos.x ~= 0 or pos.y ~= 0) then
            playerStr = string.format("%.1f, %.1f", pos.x * 100, pos.y * 100)
        end
    elseif GetPlayerMapPosition then
        local px, py = GetPlayerMapPosition("player")
        if px and py and (px ~= 0 or py ~= 0) then
            playerStr = string.format("%.1f, %.1f", px * 100, py * 100)
        end
    end

    -- 2. Cursor Coordinates
    local canvas = self.canvas
    if canvas and canvas:IsVisible() then
        local cx, cy = GetCursorPosition()
        local scale = canvas:GetEffectiveScale() or 1.0
        if scale > 0 then
            cx = cx / scale
            cy = cy / scale

            local left, bottom, width, height = canvas:GetRect()
            if left and bottom and width and height and width > 0 and height > 0 then
                local top = bottom + height
                if cx >= left and cx <= (left + width) and cy >= bottom and cy <= top then
                    local normX = (cx - left) / width * 100
                    local normY = (top - cy) / height * 100
                    cursorStr = string.format("%.1f, %.1f", normX, normY)
                end
            end
        end
    end

    -- Update pill box text
    if self.text then
        self.text:SetText(string.format("Player: %s | Cursor: %s", playerStr, cursorStr))
    end

end

function OneWorldMap.Coordinates:UpdateVisibility()
    if not self.frame then return end
    local isShown = not (OneWorldMapDB and OneWorldMapDB.features and OneWorldMapDB.features.showCoordinates == false)
    if isShown then
        self.frame:Show()
    else
        self.frame:Hide()
    end
end
