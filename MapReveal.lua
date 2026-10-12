-- OneWorldMap: MapReveal.lua
-- Fog-of-War exploration reveal module for WoW Forever (Modern Retail/Classic engine).
-- Hooks MapExplorationPinMixin to render unexplored map tiles under a darkened, desaturated fog tint.

local OneWorldMap = OneWorldMap or {}
OneWorldMap.MapReveal = OneWorldMap.MapReveal or {}
local MapReveal = OneWorldMap.MapReveal

local mod, floor, ceil, tonumber = math.fmod, math.floor, math.ceil, tonumber
local ipairs, pairs = ipairs, pairs

local DEFAULT_FOG_COLOR = { r = 0.38, g = 0.38, b = 0.45 }
local DEFAULT_FOG_ALPHA = 0.65

local function Clamp(val, min, max)
    val = tonumber(val) or min
    if val < min then return min end
    if val > max then return max end
    return val
end

local function OnPinRefreshOverlays(pin, fullUpdate)
    if not pin or not pin.overlayTexturePool then return end

    -- Restore any active explored overlays to full saturation, brightness, and opacity
    for texture in pin.overlayTexturePool:EnumerateActive() do
        if texture.SetDesaturation then
            texture:SetDesaturation(0)
        end
        texture:SetVertexColor(1.0, 1.0, 1.0)
        texture:SetAlpha(1.0)
    end

    -- If Fog-of-War reveal is disabled in settings, do not acquire unexplored overlays
    local db = OneWorldMapDB and OneWorldMapDB.features
    if not db or not db.revealFogOfWar then
        return
    end

    local mapCanvas = pin:GetMap()
    local mapID = mapCanvas and mapCanvas:GetMapID()
    if not mapID then return end

    local artID = C_Map.GetMapArtID(mapID)
    if not artID or not OneWorldMap.FogData or not OneWorldMap.FogData[artID] then
        return
    end
    local data = OneWorldMap.FogData[artID]

    -- Build lookup of already-explored tiles for this map
    local exploredTilesKeyed = {}
    local exploredMapTextures = C_MapExplorationInfo.GetExploredMapTextures(mapID)
    if exploredMapTextures then
        for _, info in ipairs(exploredMapTextures) do
            local key = info.textureWidth * 2^39 + info.textureHeight * 2^26 + info.offsetX * 2^13 + info.offsetY
            exploredTilesKeyed[key] = true
        end
    end

    -- Query canvas layer sizing
    pin.layerIndex = mapCanvas:GetCanvasContainer():GetCurrentLayerIndex()
    local layers = C_Map.GetMapArtLayers(mapID)
    local layerInfo = layers and layers[pin.layerIndex]
    if not layerInfo then return end

    local TILE_SIZE_WIDTH = layerInfo.tileWidth
    local TILE_SIZE_HEIGHT = layerInfo.tileHeight
    if not TILE_SIZE_WIDTH or not TILE_SIZE_HEIGHT or TILE_SIZE_WIDTH <= 0 or TILE_SIZE_HEIGHT <= 0 then
        return
    end

    local fogColor = db.fogColor or DEFAULT_FOG_COLOR
    local r = Clamp(fogColor.r or DEFAULT_FOG_COLOR.r, 0.0, 1.0)
    local g = Clamp(fogColor.g or DEFAULT_FOG_COLOR.g, 0.0, 1.0)
    local b = Clamp(fogColor.b or DEFAULT_FOG_COLOR.b, 0.0, 1.0)
    local a = Clamp(db.fogAlpha or DEFAULT_FOG_ALPHA, 0.1, 1.0)

    local drawLayer, subLevel = pin.dataProvider:GetDrawLayer()
    local unexploredSubLevel = (subLevel or 0) - 1

    for key, files in pairs(data) do
        if not exploredTilesKeyed[key] then
            local width = mod(floor(key / 2^39), 2^13)
            local height = mod(floor(key / 2^26), 2^13)
            local offsetX = mod(floor(key / 2^13), 2^13)
            local offsetY = mod(key, 2^13)
            local fileDataIDs = { strsplit(",", files) }

            local numTexturesWide = ceil(width / TILE_SIZE_WIDTH)
            local numTexturesTall = ceil(height / TILE_SIZE_HEIGHT)

            local texturePixelWidth, textureFileWidth, texturePixelHeight, textureFileHeight
            for j = 1, numTexturesTall do
                if j < numTexturesTall then
                    texturePixelHeight = TILE_SIZE_HEIGHT
                    textureFileHeight = TILE_SIZE_HEIGHT
                else
                    texturePixelHeight = mod(height, TILE_SIZE_HEIGHT)
                    if texturePixelHeight == 0 then
                        texturePixelHeight = TILE_SIZE_HEIGHT
                    end
                    textureFileHeight = 16
                    while textureFileHeight < texturePixelHeight do
                        textureFileHeight = textureFileHeight * 2
                    end
                end

                for k = 1, numTexturesWide do
                    local texture = pin.overlayTexturePool:Acquire()
                    mapCanvas:AddMaskableTexture(texture)

                    if k < numTexturesWide then
                        texturePixelWidth = TILE_SIZE_WIDTH
                        textureFileWidth = TILE_SIZE_WIDTH
                    else
                        texturePixelWidth = mod(width, TILE_SIZE_WIDTH)
                        if texturePixelWidth == 0 then
                            texturePixelWidth = TILE_SIZE_WIDTH
                        end
                        textureFileWidth = 16
                        while textureFileWidth < texturePixelWidth do
                            textureFileWidth = textureFileWidth * 2
                        end
                    end

                    texture:SetWidth(texturePixelWidth)
                    texture:SetHeight(texturePixelHeight)
                    texture:SetTexCoord(0, texturePixelWidth / textureFileWidth, 0, texturePixelHeight / textureFileHeight)
                    texture:SetPoint("TOPLEFT", offsetX + (TILE_SIZE_WIDTH * (k - 1)), -(offsetY + (TILE_SIZE_HEIGHT * (j - 1))))

                    local fileID = tonumber(fileDataIDs[((j - 1) * numTexturesWide) + k])
                    if fileID then
                        texture:SetTexture(fileID, nil, nil, "TRILINEAR")
                    end

                    -- Apply Darkened Fog Tint: full desaturation + charcoal/slate vertex tint + alpha
                    if texture.SetDesaturation then
                        texture:SetDesaturation(1)
                    end
                    texture:SetVertexColor(r, g, b)
                    texture:SetAlpha(a)
                    texture:SetDrawLayer(drawLayer or "ARTWORK", unexploredSubLevel)
                    texture:Show()

                    if fullUpdate and pin.textureLoadGroup then
                        pin.textureLoadGroup:AddTexture(texture)
                    end
                end
            end
        end
    end
end

local function HookPin(pin)
    if pin and not pin.owmHooked then
        pin.owmHooked = true
        hooksecurefunc(pin, "RefreshOverlays", OnPinRefreshOverlays)
    end
end

local function ForEachExplorationPin(callback)
    if WorldMapFrame and WorldMapFrame.EnumeratePinsByTemplate then
        for pin in WorldMapFrame:EnumeratePinsByTemplate("MapExplorationPinTemplate") do
            callback(pin)
        end
    end
end

function MapReveal:Refresh()
    ForEachExplorationPin(function(pin)
        HookPin(pin)
        pin:RefreshOverlays(true)
    end)
end

function MapReveal:SetAlpha(alpha)
    alpha = Clamp(alpha, 0.1, 1.0)
    if OneWorldMapDB and OneWorldMapDB.features then
        OneWorldMapDB.features.fogAlpha = alpha
    end
    self:Refresh()
end

function MapReveal:SetColor(r, g, b)
    if OneWorldMapDB and OneWorldMapDB.features then
        OneWorldMapDB.features.fogColor = {
            r = Clamp(r, 0.0, 1.0),
            g = Clamp(g, 0.0, 1.0),
            b = Clamp(b, 0.0, 1.0),
        }
    end
    self:Refresh()
end

function MapReveal:SetPreset(name)
    name = (name or ""):lower()
    if name == "charcoal" or name == "default" then
        self:SetColor(0.38, 0.38, 0.45)
        self:SetAlpha(0.65)
    elseif name == "dark" then
        self:SetColor(0.22, 0.22, 0.25)
        self:SetAlpha(0.75)
    elseif name == "blue" or name == "mist" then
        self:SetColor(0.28, 0.35, 0.48)
        self:SetAlpha(0.65)
    elseif name == "sepia" then
        self:SetColor(0.45, 0.40, 0.32)
        self:SetAlpha(0.60)
    elseif name == "light" then
        self:SetColor(0.55, 0.55, 0.60)
        self:SetAlpha(0.45)
    else
        return false
    end
    return true
end

function MapReveal:SetEnabled(enabled)
    if OneWorldMapDB and OneWorldMapDB.features then
        OneWorldMapDB.features.revealFogOfWar = enabled and true or false
    end
    self:Refresh()
end

function MapReveal:Toggle()
    local current = OneWorldMapDB and OneWorldMapDB.features and OneWorldMapDB.features.revealFogOfWar
    self:SetEnabled(not current)
    return OneWorldMapDB.features.revealFogOfWar
end

function MapReveal.Init()
    -- Initialize defaults if missing
    if OneWorldMapDB and OneWorldMapDB.features then
        if OneWorldMapDB.features.revealFogOfWar == nil then
            OneWorldMapDB.features.revealFogOfWar = true
        end
        if OneWorldMapDB.features.fogAlpha == nil then
            OneWorldMapDB.features.fogAlpha = DEFAULT_FOG_ALPHA
        else
            OneWorldMapDB.features.fogAlpha = Clamp(OneWorldMapDB.features.fogAlpha, 0.1, 1.0)
        end
        if not OneWorldMapDB.features.fogColor then
            OneWorldMapDB.features.fogColor = CopyTable(DEFAULT_FOG_COLOR)
        end
    end

    -- Hook mixin so any pin dynamically instantiated is hooked
    if MapExplorationPinMixin and MapExplorationPinMixin.RefreshOverlays then
        hooksecurefunc(MapExplorationPinMixin, "RefreshOverlays", OnPinRefreshOverlays)
    end

    -- Hook existing pins
    ForEachExplorationPin(HookPin)
end

OneWorldMap:RegisterModule("MapReveal", MapReveal.Init)
