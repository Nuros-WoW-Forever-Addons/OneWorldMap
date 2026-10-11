-- OneWorldMap: Shell.lua
-- Outer frame manager: movable positioning, scale persistence, and movement fade controller.

OneWorldMap = OneWorldMap or {}
OneWorldMap.Shell = {}

OneWorldMap:RegisterModule("Shell", function(addon)
    OneWorldMap.Shell:Init()
end)

function OneWorldMap.Shell:Init()
    self:ConfigureWorldMapFrame()
    self:SetupMovementFade()
    self:RestorePosition()
end

function OneWorldMap.Shell:ConfigureWorldMapFrame()
    local frame = WorldMapFrame
    if not frame then return end

    frame:SetMovable(true)
    frame:SetClampedToScreen(true)

    -- Identify the drag handle across client versions
    local dragHandle = nil
    if frame.BorderFrame and frame.BorderFrame.TitleContainer then
        dragHandle = frame.BorderFrame.TitleContainer
    elseif _G["WorldMapTitleButton"] then
        dragHandle = _G["WorldMapTitleButton"]
    else
        dragHandle = frame
    end

    if dragHandle and dragHandle ~= frame then
        dragHandle:EnableMouse(true)
        dragHandle:RegisterForDrag("LeftButton")
        dragHandle:HookScript("OnMouseDown", function()
            if not InCombatLockdown() and not (OneWorldMapDB.window and OneWorldMapDB.window.isLocked) then
                frame:StartMoving()
                frame.isMoving = true
            end
        end)
        dragHandle:HookScript("OnMouseUp", function()
            if frame.isMoving then
                frame:StopMovingOrSizing()
                frame.isMoving = false
                OneWorldMap.Shell:SavePosition()
            end
        end)
    end

    -- Hook OnShow to restore coordinates
    frame:HookScript("OnShow", function()
        OneWorldMap.Shell:RestorePosition()
    end)
end

function OneWorldMap.Shell:SavePosition()
    local frame = WorldMapFrame
    if not frame then return end

    local left = frame:GetLeft()
    local top = frame:GetTop()
    if left and top then
        OneWorldMapDB.window = OneWorldMapDB.window or {}
        OneWorldMapDB.window.point = "TOPLEFT"
        OneWorldMapDB.window.xOffset = left
        OneWorldMapDB.window.yOffset = top
    end
end

function OneWorldMap.Shell:RestorePosition()
    if InCombatLockdown() then return end
    local frame = WorldMapFrame
    if not frame then return end

    local cfg = OneWorldMapDB and OneWorldMapDB.window
    if cfg and cfg.xOffset and cfg.yOffset and cfg.point == "TOPLEFT" then
        frame:ClearAllPoints()
        frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", cfg.xOffset, cfg.yOffset)
    else
        -- If center or uninitialized, center then convert to TOPLEFT so width changes only grow to the right
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        local left = frame:GetLeft()
        local top = frame:GetTop()
        if left and top then
            frame:ClearAllPoints()
            frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
            OneWorldMapDB.window = OneWorldMapDB.window or {}
            OneWorldMapDB.window.point = "TOPLEFT"
            OneWorldMapDB.window.xOffset = left
            OneWorldMapDB.window.yOffset = top
        end
    end

    if cfg and cfg.scale and cfg.scale > 0 then
        frame:SetScale(cfg.scale)
    end
end

function OneWorldMap.Shell:ResetPosition()
    if InCombatLockdown() then return end
    local frame = WorldMapFrame
    if not frame then return end

    frame:ClearAllPoints()
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetScale(1.0)

    OneWorldMapDB.window = OneWorldMapDB.window or {}
    OneWorldMapDB.window.point = "CENTER"
    OneWorldMapDB.window.xOffset = 0
    OneWorldMapDB.window.yOffset = 0
    OneWorldMapDB.window.scale = 1.0
end

function OneWorldMap.Shell:SetupMovementFade()
    local frame = WorldMapFrame
    if not frame then return end

    local isMoving = false
    local isHovered = false

    local function ApplyAlpha()
        if not (OneWorldMapDB and OneWorldMapDB.ergonomics and OneWorldMapDB.ergonomics.fadeOnMove) then
            frame:SetAlpha(1.0)
            return
        end

        local movingAlpha = (OneWorldMapDB.ergonomics.movingAlpha) or 0.35
        local restoredAlpha = (OneWorldMapDB.ergonomics.restoredAlpha) or 1.0

        if isMoving and not isHovered then
            frame:SetAlpha(movingAlpha)
        else
            frame:SetAlpha(restoredAlpha)
        end
    end

    local fadeWatcher = CreateFrame("Frame", "OneWorldMap_FadeWatcher", UIParent)
    fadeWatcher:RegisterEvent("PLAYER_STARTED_MOVING")
    fadeWatcher:RegisterEvent("PLAYER_STOPPED_MOVING")

    fadeWatcher:SetScript("OnEvent", function(self, event)
        if event == "PLAYER_STARTED_MOVING" then
            isMoving = true
        elseif event == "PLAYER_STOPPED_MOVING" then
            isMoving = false
        end
        if frame:IsShown() then
            ApplyAlpha()
        end
    end)

    frame:HookScript("OnEnter", function()
        isHovered = true
        if frame:IsShown() then
            ApplyAlpha()
        end
    end)

    frame:HookScript("OnLeave", function()
        isHovered = false
        if frame:IsShown() then
            ApplyAlpha()
        end
    end)
end
