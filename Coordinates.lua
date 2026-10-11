-- OneWorldMap: Coordinates.lua
-- Throttled 10 Hz ticker bar displaying live Player and Cursor coordinates with bounds checking and nil guards.

OneWorldMap = OneWorldMap or {}
OneWorldMap.Coordinates = {}

OneWorldMap:RegisterModule("Coordinates", function(addon)
    OneWorldMap.Coordinates:Init()
end)

function OneWorldMap.Coordinates:Init()
    local wmFrame = WorldMapFrame
    if not wmFrame then return end

    local canvas = wmFrame.ScrollContainer or _G["WorldMapButton"] or wmFrame

    local frame = CreateFrame("Frame", "OneWorldMap_CoordsFrame", canvas)
    self.frame = frame
    self.canvas = canvas
    frame:SetPoint("BOTTOM", canvas, "BOTTOM", 0, 8)
    frame:SetSize(320, 20)

    -- Background pill for readability over map art
    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(frame)
    bg:SetColorTexture(0, 0, 0, 0.6)
    self.bg = bg

    local text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    text:SetPoint("CENTER", frame, "CENTER", 0, 0)
    text:SetText("Player: --, -- | Cursor: --, --")
    self.text = text

    self.updateInterval = 0.10 -- 10 Hz
    self.timeSinceLast = 0

    frame:SetScript("OnUpdate", function(f, elapsed)
        self.timeSinceLast = self.timeSinceLast + elapsed
        if self.timeSinceLast >= self.updateInterval then
            self.timeSinceLast = 0
            self:UpdateCoordinates()
        end
    end)

    self:UpdateVisibility()
end

function OneWorldMap.Coordinates:UpdateCoordinates()
    local playerStr = "--, --"
    local cursorStr = "--, --"

    -- 1. Calculate Player Coordinates
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

    -- 2. Calculate Cursor Coordinates
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

    -- Update ticker bar
    if self.text then
        self.text:SetText(string.format("Player: %s | Cursor: %s", playerStr, cursorStr))
    end

    -- Pass coordinates to Sidebar if available
    if OneWorldMap.Sidebar and OneWorldMap.Sidebar.UpdateCoordsText then
        OneWorldMap.Sidebar:UpdateCoordsText(playerStr, cursorStr)
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
