-- OneWorldMap: OptionsUI.lua
-- Graphical Configuration Panel for OneWorldMap.
-- Supports both standalone movable window (/owm) and Blizzard Options -> AddOns menu.

local OneWorldMap = OneWorldMap or {}
OneWorldMap.OptionsUI = {}
local OptionsUI = OneWorldMap.OptionsUI

local standaloneFrame = nil
local blizzardCategoryPanel = nil
local uiContentFrame = nil

local backdropTemplate = BackdropTemplateMixin and "BackdropTemplate" or nil

local function ApplyBackdrop(target, backdropInfo)
    if not target then return end
    if BackdropTemplateMixin and not target.SetBackdrop then
        Mixin(target, BackdropTemplateMixin)
    end
    if target.SetBackdrop then
        target:SetBackdrop(backdropInfo)
    end
end

-------------------------------------------------------------------------------
-- Widget Creators
-------------------------------------------------------------------------------

local function CreateButton(parent, labelText, width, height, onClick)
    local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    btn:SetSize(width or 120, height or 24)
    btn:SetText(labelText)
    if onClick then
        btn:SetScript("OnClick", onClick)
    end
    return btn
end

local function CreateCheckbox(parent, labelText, getValue, setValue, onChange)
    local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    cb:SetSize(24, 24)
    if not cb.text then
        cb.text = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlightLeft")
        cb.text:SetPoint("LEFT", cb, "RIGHT", 5, 0)
    end
    cb.text:SetText(labelText)

    cb.getValue = getValue
    cb:SetScript("OnShow", function(self)
        self:SetChecked(getValue())
    end)
    cb:SetScript("OnClick", function(self)
        local val = self:GetChecked()
        setValue(val)
        if onChange then onChange(val) end
    end)
    return cb
end

local function CreateSubLabel(parent, text, isSmall)
    local fs = parent:CreateFontString(nil, "OVERLAY", isSmall and "GameFontDisableSmall" or "GameFontHighlightSmall")
    fs:SetText(text)
    fs:SetJustifyH("LEFT")
    return fs
end

local function CreateSectionBanner(parent, titleText)
    local banner = CreateFrame("Frame", nil, parent)
    banner:SetSize(470, 24)

    local bg = banner:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(banner)
    if bg.SetColorTexture then
        bg:SetColorTexture(0.08, 0.14, 0.22, 0.85)
    end

    local title = banner:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2")
    title:SetPoint("LEFT", banner, "LEFT", 8, 0)
    title:SetText("|cffffd100" .. titleText .. "|r")

    return banner
end

local function CreateStepper(parent, minVal, maxVal, step, getter, setter, formatStr, onChange)
    local container = CreateFrame("Frame", nil, parent)
    container:SetSize(160, 22)

    local btnMinus = CreateButton(container, "-", 22, 20, nil)
    btnMinus:SetPoint("LEFT", container, "LEFT", 0, 0)

    local valText = container:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    valText:SetPoint("CENTER", container, "CENTER", 0, 0)

    local btnPlus = CreateButton(container, "+", 22, 20, nil)
    btnPlus:SetPoint("RIGHT", container, "RIGHT", 0, 0)

    local function UpdateVal(newVal)
        newVal = math.max(minVal, math.min(maxVal, newVal))
        newVal = math.floor((newVal / step) + 0.5) * step
        setter(newVal)
        valText:SetText("|cff00ccff" .. string.format(formatStr, newVal) .. "|r")
        if onChange then onChange(newVal) end
    end

    btnMinus:SetScript("OnClick", function()
        UpdateVal(getter() - step)
    end)

    btnPlus:SetScript("OnClick", function()
        UpdateVal(getter() + step)
    end)

    container.getter = getter
    container.UpdateVal = UpdateVal
    container.formatStr = formatStr
    container.valText = valText

    container:SetScript("OnShow", function()
        local current = getter() or minVal
        valText:SetText("|cff00ccff" .. string.format(formatStr, current) .. "|r")
    end)

    return container
end

-------------------------------------------------------------------------------
-- UI Content Builder (Dual-parented across Standalone & Blizzard panels)
-------------------------------------------------------------------------------

local function GetOrCreateUIContent()
    if uiContentFrame then return uiContentFrame end

    local content = CreateFrame("Frame", "OneWorldMapOptionsContent", UIParent)
    content:SetSize(470, 720)
    content.controls = {}

    local y = -8

    -- SECTION: Window & Geometry
    local bannerWindow = CreateSectionBanner(content, "Map Window & Scaling")
    bannerWindow:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
    y = y - 30

    local cbLock = CreateCheckbox(content, "Lock Map Window Position (Prevent Dragging)", function()
        return (OneWorldMapDB and OneWorldMapDB.window and OneWorldMapDB.window.isLocked) or false
    end, function(val)
        OneWorldMapDB.window = OneWorldMapDB.window or {}
        OneWorldMapDB.window.isLocked = val
    end)
    cbLock:SetPoint("TOPLEFT", content, "TOPLEFT", 10, y)
    table.insert(content.controls, cbLock)
    y = y - 28

    local lblScale = CreateSubLabel(content, "Window Scale:")
    lblScale:SetPoint("TOPLEFT", content, "TOPLEFT", 14, y - 2)

    local stepperScale = CreateStepper(content, 0.70, 1.30, 0.05, function()
        return (OneWorldMapDB and OneWorldMapDB.window and OneWorldMapDB.window.scale) or 1.0
    end, function(val)
        if OneWorldMap.Shell and OneWorldMap.Shell.SetScale then
            OneWorldMap.Shell:SetScale(val)
        else
            OneWorldMapDB.window = OneWorldMapDB.window or {}
            OneWorldMapDB.window.scale = val
        end
    end, "%.2fx")
    stepperScale:SetPoint("LEFT", lblScale, "RIGHT", 20, 0)
    table.insert(content.controls, stepperScale)

    local btnResetPos = CreateButton(content, "Reset Position & Scale", 170, 22, function()
        if OneWorldMap.Shell and OneWorldMap.Shell.ResetPosition then
            OneWorldMap.Shell:ResetPosition()
        end
        OptionsUI:RefreshUI()
        OneWorldMap:Log("Window position and scale reset to default.")
    end)
    btnResetPos:SetPoint("LEFT", stepperScale, "RIGHT", 14, 0)
    y = y - 34

    -- SECTION: DoubleWide Quest Log
    local bannerDW = CreateSectionBanner(content, "DoubleWide Quest Log")
    bannerDW:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
    y = y - 30

    local cbDoubleWide = CreateCheckbox(content, "Enable DoubleWide Side-by-Side Quest Log", function()
        return (OneWorldMapDB and OneWorldMapDB.questLog and OneWorldMapDB.questLog.doubleWide) ~= false
    end, function(val)
        OneWorldMapDB.questLog = OneWorldMapDB.questLog or {}
        OneWorldMapDB.questLog.doubleWide = val
        if OneWorldMap.DoubleWide and OneWorldMap.DoubleWide.RefreshLayout then
            OneWorldMap.DoubleWide:RefreshLayout()
        end
    end)
    cbDoubleWide:SetPoint("TOPLEFT", content, "TOPLEFT", 10, y)
    table.insert(content.controls, cbDoubleWide)
    y = y - 22

    local subDW = CreateSubLabel(content, "Displays Quest Details in a dedicated panel side-by-side with the Quest List.", true)
    subDW:SetPoint("TOPLEFT", content, "TOPLEFT", 36, y)
    y = y - 28

    -- SECTION: Zone Metadata Sidebar
    local bannerSidebar = CreateSectionBanner(content, "Zone Metadata Sidebar")
    bannerSidebar:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
    y = y - 30

    local cbSidebar = CreateCheckbox(content, "Show Zone Metadata Sidebar (Left Drawer)", function()
        return not (OneWorldMapDB and OneWorldMapDB.sidebar and OneWorldMapDB.sidebar.collapsed)
    end, function(val)
        OneWorldMapDB.sidebar = OneWorldMapDB.sidebar or {}
        OneWorldMapDB.sidebar.collapsed = not val
        if OneWorldMap.Sidebar and OneWorldMap.Sidebar.UpdateState then
            OneWorldMap.Sidebar:UpdateState()
        end
    end)
    cbSidebar:SetPoint("TOPLEFT", content, "TOPLEFT", 10, y)
    table.insert(content.controls, cbSidebar)
    y = y - 24

    local lblWidth = CreateSubLabel(content, "Sidebar Width:")
    lblWidth:SetPoint("TOPLEFT", content, "TOPLEFT", 14, y - 2)

    local stepperWidth = CreateStepper(content, 240, 360, 10, function()
        return (OneWorldMapDB and OneWorldMapDB.sidebar and OneWorldMapDB.sidebar.width) or 290
    end, function(val)
        OneWorldMapDB.sidebar = OneWorldMapDB.sidebar or {}
        OneWorldMapDB.sidebar.width = val
        if OneWorldMap.Sidebar and OneWorldMap.Sidebar.UpdateState then
            OneWorldMap.Sidebar:UpdateState()
        end
    end, "%d px")
    stepperWidth:SetPoint("LEFT", lblWidth, "RIGHT", 14, 0)
    table.insert(content.controls, stepperWidth)
    y = y - 26

    local subSB = CreateSubLabel(content, "Surfaces zone level ranges, gathering node thresholds, and local dungeon brackets.", true)
    subSB:SetPoint("TOPLEFT", content, "TOPLEFT", 14, y)
    y = y - 28

    -- SECTION: Live Coordinates
    local bannerCoords = CreateSectionBanner(content, "Live Coordinates Display")
    bannerCoords:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
    y = y - 30

    local cbCoords = CreateCheckbox(content, "Show Live Coordinates Bar on Map Canvas", function()
        return (OneWorldMapDB and OneWorldMapDB.features and OneWorldMapDB.features.showCoordinates) ~= false
    end, function(val)
        OneWorldMapDB.features = OneWorldMapDB.features or {}
        OneWorldMapDB.features.showCoordinates = val
        if OneWorldMap.Coordinates and OneWorldMap.Coordinates.UpdateVisibility then
            OneWorldMap.Coordinates:UpdateVisibility()
        end
    end)
    cbCoords:SetPoint("TOPLEFT", content, "TOPLEFT", 10, y)
    table.insert(content.controls, cbCoords)
    y = y - 22

    local subCoords = CreateSubLabel(content, "Displays high-contrast Player & Cursor coordinates at the bottom of the map.", true)
    subCoords:SetPoint("TOPLEFT", content, "TOPLEFT", 36, y)
    y = y - 28

    -- SECTION: Movement Ergonomics
    local bannerFade = CreateSectionBanner(content, "Movement Ergonomics")
    bannerFade:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
    y = y - 30

    local cbFade = CreateCheckbox(content, "Fade Map While Moving", function()
        return (OneWorldMapDB and OneWorldMapDB.ergonomics and OneWorldMapDB.ergonomics.fadeOnMove) ~= false
    end, function(val)
        OneWorldMapDB.ergonomics = OneWorldMapDB.ergonomics or {}
        OneWorldMapDB.ergonomics.fadeOnMove = val
    end)
    cbFade:SetPoint("TOPLEFT", content, "TOPLEFT", 10, y)
    table.insert(content.controls, cbFade)
    y = y - 24

    local lblFadeAlpha = CreateSubLabel(content, "Moving Opacity:")
    lblFadeAlpha:SetPoint("TOPLEFT", content, "TOPLEFT", 14, y - 2)

    local stepperFadeAlpha = CreateStepper(content, 0.10, 0.90, 0.05, function()
        return (OneWorldMapDB and OneWorldMapDB.ergonomics and OneWorldMapDB.ergonomics.movingAlpha) or 0.35
    end, function(val)
        OneWorldMapDB.ergonomics = OneWorldMapDB.ergonomics or {}
        OneWorldMapDB.ergonomics.movingAlpha = val
    end, "%.0f%%")
    stepperFadeAlpha:SetPoint("LEFT", lblFadeAlpha, "RIGHT", 14, 0)
    table.insert(content.controls, stepperFadeAlpha)
    y = y - 26

    local subFade = CreateSubLabel(content, "Reduces map opacity while your character is in motion to improve situational awareness.", true)
    subFade:SetPoint("TOPLEFT", content, "TOPLEFT", 14, y)
    y = y - 28

    -- SECTION: Fog-of-War Exploration Reveal
    local bannerFog = CreateSectionBanner(content, "Fog-of-War Exploration Reveal")
    bannerFog:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
    y = y - 30

    local cbFog = CreateCheckbox(content, "Enable Fog-of-War Exploration Reveal", function()
        return (OneWorldMapDB and OneWorldMapDB.features and OneWorldMapDB.features.revealFogOfWar) ~= false
    end, function(val)
        if OneWorldMap.MapReveal and OneWorldMap.MapReveal.SetEnabled then
            OneWorldMap.MapReveal:SetEnabled(val)
        else
            OneWorldMapDB.features = OneWorldMapDB.features or {}
            OneWorldMapDB.features.revealFogOfWar = val
        end
    end)
    cbFog:SetPoint("TOPLEFT", content, "TOPLEFT", 10, y)
    table.insert(content.controls, cbFog)
    y = y - 24

    local lblFogAlpha = CreateSubLabel(content, "Fog Shading Opacity:")
    lblFogAlpha:SetPoint("TOPLEFT", content, "TOPLEFT", 14, y - 2)

    local stepperFogAlpha = CreateStepper(content, 0.20, 1.00, 0.05, function()
        return (OneWorldMapDB and OneWorldMapDB.features and OneWorldMapDB.features.fogAlpha) or 0.65
    end, function(val)
        if OneWorldMap.MapReveal and OneWorldMap.MapReveal.SetAlpha then
            OneWorldMap.MapReveal:SetAlpha(val)
        else
            OneWorldMapDB.features = OneWorldMapDB.features or {}
            OneWorldMapDB.features.fogAlpha = val
        end
    end, "%.0f%%")
    stepperFogAlpha:SetPoint("LEFT", lblFogAlpha, "RIGHT", 14, 0)
    table.insert(content.controls, stepperFogAlpha)
    y = y - 30

    local lblPresets = CreateSubLabel(content, "Fog Tint Presets:")
    lblPresets:SetPoint("TOPLEFT", content, "TOPLEFT", 14, y)
    y = y - 22

    local presets = {
        { name = "Charcoal", key = "charcoal" },
        { name = "Dark", key = "dark" },
        { name = "Blue Mist", key = "blue" },
        { name = "Sepia", key = "sepia" },
        { name = "Light", key = "light" },
    }

    local xOfs = 14
    for _, p in ipairs(presets) do
        local btn = CreateButton(content, p.name, 82, 22, function()
            if OneWorldMap.MapReveal and OneWorldMap.MapReveal.SetPreset then
                OneWorldMap.MapReveal:SetPreset(p.key)
            end
            OptionsUI:RefreshUI()
            OneWorldMap:Log("Applied Fog preset: " .. p.name)
        end)
        btn:SetPoint("TOPLEFT", content, "TOPLEFT", xOfs, y)
        xOfs = xOfs + 88
    end
    y = y - 28

    local subFog = CreateSubLabel(content, "Shrouds unexplored zones under desaturated fog while keeping roads and topography visible.", true)
    subFog:SetPoint("TOPLEFT", content, "TOPLEFT", 14, y)
    y = y - 24

    content:SetHeight(math.abs(y) + 20)
    uiContentFrame = content
    return content
end

-------------------------------------------------------------------------------
-- Refresh UI Controls
-------------------------------------------------------------------------------

function OptionsUI:RefreshUI()
    if not uiContentFrame or not uiContentFrame.controls then return end
    for _, control in ipairs(uiContentFrame.controls) do
        if control.getValue and control.SetChecked then
            control:SetChecked(control.getValue())
        elseif control.getter and control.valText and control.formatStr then
            local current = control.getter()
            control.valText:SetText("|cff00ccff" .. string.format(control.formatStr, current) .. "|r")
        end
    end
end

-------------------------------------------------------------------------------
-- Standalone Window Builder
-------------------------------------------------------------------------------

local function BuildStandaloneWindow()
    if standaloneFrame then return standaloneFrame end

    standaloneFrame = CreateFrame("Frame", "OneWorldMapOptionsFrame", UIParent, backdropTemplate)
    standaloneFrame:SetSize(540, 640)
    standaloneFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    standaloneFrame:SetMovable(true)
    standaloneFrame:EnableMouse(true)
    standaloneFrame:RegisterForDrag("LeftButton")
    standaloneFrame:SetScript("OnDragStart", standaloneFrame.StartMoving)
    standaloneFrame:SetScript("OnDragStop", standaloneFrame.StopMovingOrSizing)
    standaloneFrame:SetFrameStrata("DIALOG")

    -- Backdrop border & dark styling
    ApplyBackdrop(standaloneFrame, {
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\DialogFrame\\UI-DialogFrame-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 5, right = 5, top = 5, bottom = 5 }
    })
    if standaloneFrame.SetBackdropColor then
        standaloneFrame:SetBackdropColor(0.04, 0.05, 0.09, 0.94)
        standaloneFrame:SetBackdropBorderColor(0.3, 0.85, 1.0, 0.90) -- Bright cyan outline
    end

    -- Deep slate background
    local bgTex = standaloneFrame:CreateTexture(nil, "BACKGROUND", nil, -7)
    bgTex:SetAllPoints(standaloneFrame)
    if bgTex.SetColorTexture then
        bgTex:SetColorTexture(0.03, 0.04, 0.08, 0.95)
    end

    -- Header Panel Bar
    local headerBar = standaloneFrame:CreateTexture(nil, "ARTWORK")
    headerBar:SetPoint("TOPLEFT", standaloneFrame, "TOPLEFT", 6, -6)
    headerBar:SetPoint("TOPRIGHT", standaloneFrame, "TOPRIGHT", -6, -6)
    headerBar:SetHeight(32)
    if headerBar.SetColorTexture then
        headerBar:SetColorTexture(0.08, 0.14, 0.22, 0.95)
    end

    -- Header Icon
    local headerIcon = standaloneFrame:CreateTexture(nil, "OVERLAY")
    headerIcon:SetSize(22, 22)
    headerIcon:SetPoint("LEFT", headerBar, "LEFT", 8, 0)
    headerIcon:SetTexture("Interface\\Icons\\inv_misc_map02")

    -- Title Header Text
    local title = standaloneFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalMed3")
    title:SetPoint("LEFT", headerIcon, "RIGHT", 8, 0)
    title:SetText("|cff00ccffOneWorldMap|r  |cffffd100Settings Panel|r  |cff888888(v0.0.1)|r")

    -- Close Button (X)
    local closeBtn = CreateFrame("Button", nil, standaloneFrame, "UIPanelCloseButton")
    closeBtn:SetPoint("RIGHT", headerBar, "RIGHT", -2, 0)
    closeBtn:SetScript("OnClick", function()
        standaloneFrame:Hide()
    end)

    -- Inset Box Frame
    local insetBox = CreateFrame("Frame", nil, standaloneFrame, backdropTemplate)
    insetBox:SetPoint("TOPLEFT", standaloneFrame, "TOPLEFT", 10, -42)
    insetBox:SetPoint("BOTTOMRIGHT", standaloneFrame, "BOTTOMRIGHT", -10, 44)
    ApplyBackdrop(insetBox, {
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    if insetBox.SetBackdropColor then
        insetBox:SetBackdropColor(0.02, 0.03, 0.06, 0.70)
        insetBox:SetBackdropBorderColor(0.2, 0.4, 0.6, 0.6)
    end

    -- ESC Key Support
    if UISpecialFrames then
        table.insert(UISpecialFrames, "OneWorldMapOptionsFrame")
    end

    -- Scroll Frame
    local scrollFrame = CreateFrame("ScrollFrame", "OneWorldMapOptionsScrollFrame", insetBox, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", insetBox, "TOPLEFT", 6, -6)
    scrollFrame:SetPoint("BOTTOMRIGHT", insetBox, "BOTTOMRIGHT", -26, 6)
    standaloneFrame.scrollFrame = scrollFrame

    standaloneFrame:SetScript("OnShow", function()
        if InterfaceOptionsFrame and InterfaceOptionsFrame:IsShown() then
            HideUIPanel(InterfaceOptionsFrame)
        end
        if SettingsPanel and SettingsPanel:IsShown() then
            HideUIPanel(SettingsPanel)
        end

        local content = GetOrCreateUIContent()
        content:SetParent(scrollFrame)
        scrollFrame:SetScrollChild(content)
        content:Show()
        OptionsUI:RefreshUI()
    end)

    -- Reset Defaults Button (Bottom-Left)
    local btnReset = CreateButton(standaloneFrame, "Reset All Defaults", 140, 24, function()
        OneWorldMapDB = nil
        if OneWorldMap.InitializeDB then
            OneWorldMap.InitializeDB()
        end
        if OneWorldMap.Shell and OneWorldMap.Shell.ResetPosition then
            OneWorldMap.Shell:ResetPosition()
        end
        if OneWorldMap.DoubleWide and OneWorldMap.DoubleWide.RefreshLayout then
            OneWorldMap.DoubleWide:RefreshLayout()
        end
        if OneWorldMap.Sidebar and OneWorldMap.Sidebar.UpdateState then
            OneWorldMap.Sidebar:UpdateState()
        end
        if OneWorldMap.Coordinates and OneWorldMap.Coordinates.UpdateVisibility then
            OneWorldMap.Coordinates:UpdateVisibility()
        end
        if OneWorldMap.MapReveal and OneWorldMap.MapReveal.Refresh then
            OneWorldMap.MapReveal:Refresh()
        end
        OptionsUI:RefreshUI()
        OneWorldMap:Log("All settings have been reset to default values.")
    end)
    btnReset:SetPoint("BOTTOMLEFT", standaloneFrame, "BOTTOMLEFT", 15, 12)

    -- Close Button (Bottom-Right)
    local btnClose = CreateButton(standaloneFrame, "Close", 100, 24, function()
        standaloneFrame:Hide()
    end)
    btnClose:SetPoint("BOTTOMRIGHT", standaloneFrame, "BOTTOMRIGHT", -15, 12)

    standaloneFrame:Hide()
    return standaloneFrame
end

-------------------------------------------------------------------------------
-- Blizzard Options -> AddOns Category Registration
-------------------------------------------------------------------------------

local function RegisterBlizzardCategory()
    if blizzardCategoryPanel then return blizzardCategoryPanel end

    blizzardCategoryPanel = CreateFrame("Frame", "OneWorldMapBlizzardCategory", UIParent)
    blizzardCategoryPanel.name = "OneWorldMap"

    local icon = blizzardCategoryPanel:CreateTexture(nil, "ARTWORK")
    icon:SetSize(28, 28)
    icon:SetPoint("TOPLEFT", blizzardCategoryPanel, "TOPLEFT", 16, -16)
    icon:SetTexture("Interface\\Icons\\inv_misc_map02")

    local title = blizzardCategoryPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalMed3")
    title:SetPoint("LEFT", icon, "RIGHT", 10, 0)
    title:SetText("|cff00ccffOneWorldMap|r  |cffffd100Map & Quest Log Options|r  |cff888888(v0.0.1)|r")

    local btnPopOut = CreateButton(blizzardCategoryPanel, "Open OneWorldMap Settings Window", 250, 26, function()
        if InterfaceOptionsFrame and InterfaceOptionsFrame:IsShown() then
            HideUIPanel(InterfaceOptionsFrame)
        end
        if SettingsPanel and SettingsPanel:IsShown() then
            HideUIPanel(SettingsPanel)
        end
        OneWorldMap:ShowStandaloneUI()
    end)
    btnPopOut:SetPoint("TOPLEFT", icon, "BOTTOMLEFT", 0, -12)

    local hintText = blizzardCategoryPanel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    hintText:SetPoint("LEFT", btnPopOut, "RIGHT", 10, 0)
    hintText:SetText("(Opens independent floating settings window)")

    local scrollFrame = CreateFrame("ScrollFrame", "OneWorldMapBlizzardScrollFrame", blizzardCategoryPanel, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", blizzardCategoryPanel, "TOPLEFT", 10, -85)
    scrollFrame:SetPoint("BOTTOMRIGHT", blizzardCategoryPanel, "BOTTOMRIGHT", -26, 10)
    blizzardCategoryPanel.scrollFrame = scrollFrame

    local content = GetOrCreateUIContent()
    content:SetParent(scrollFrame)
    scrollFrame:SetScrollChild(content)
    content:Show()
    OptionsUI:RefreshUI()

    blizzardCategoryPanel:SetScript("OnShow", function()
        if standaloneFrame and standaloneFrame:IsShown() then
            standaloneFrame:Hide()
        end

        local c = GetOrCreateUIContent()
        c:SetParent(scrollFrame)
        scrollFrame:SetScrollChild(c)
        c:Show()
        OptionsUI:RefreshUI()
    end)

    -- Register category across Classic and Modern WoW 10.x/11.x
    if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
        local category = Settings.RegisterCanvasLayoutCategory(blizzardCategoryPanel, "OneWorldMap")
        if category and category.SetIcon then
            pcall(function() category:SetIcon("Interface\\Icons\\inv_misc_map02") end)
        end
        Settings.RegisterAddOnCategory(category)
        blizzardCategoryPanel.categoryID = category:GetID()
    elseif InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(blizzardCategoryPanel)
    end

    return blizzardCategoryPanel
end

-------------------------------------------------------------------------------
-- Public API
-------------------------------------------------------------------------------

function OneWorldMap:ShowStandaloneUI()
    local win = BuildStandaloneWindow()
    if not win:IsShown() then
        win:Show()
    end
end

function OneWorldMap:ToggleOptionsUI()
    local win = BuildStandaloneWindow()
    if win:IsShown() then
        win:Hide()
    else
        win:Show()
    end
end

function OptionsUI:Init()
    RegisterBlizzardCategory()
end

OneWorldMap:RegisterModule("OptionsUI", function()
    OptionsUI:Init()
end)
