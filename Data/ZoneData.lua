-- OneWorldMap: Data/ZoneData.lua
-- Static database of Classic zone metadata: level ranges, gathering thresholds, and dungeon brackets.

OneWorldMap = OneWorldMap or {}
OneWorldMap.ZoneData = {}

local zoneDataByUiMapID = {
    [1429] = { -- Elwynn Forest
        name = "Elwynn Forest",
        minLevel = 1,
        maxLevel = 10,
        herbs = {
            { name = "Peacebloom", skill = 1 },
            { name = "Silverleaf", skill = 1 },
            { name = "Earthroot", skill = 15 },
        },
        ores = {
            { name = "Copper", skill = 1 },
        },
        fishing = 1,
        dungeons = {},
    },
    [1436] = { -- Westfall
        name = "Westfall",
        minLevel = 10,
        maxLevel = 20,
        herbs = {
            { name = "Mageroyal", skill = 50 },
            { name = "Briarthorn", skill = 70 },
        },
        ores = {
            { name = "Tin", skill = 65 },
            { name = "Silver", skill = 75 },
        },
        fishing = 55,
        dungeons = {
            { name = "The Deadmines", minLevel = 15, maxLevel = 23 },
        },
    },
    [1432] = { -- Redridge Mountains
        name = "Redridge Mountains",
        minLevel = 15,
        maxLevel = 25,
        herbs = {
            { name = "Mageroyal", skill = 50 },
            { name = "Briarthorn", skill = 70 },
            { name = "Bruiseweed", skill = 100 },
        },
        ores = {
            { name = "Tin", skill = 65 },
            { name = "Silver", skill = 75 },
            { name = "Iron", skill = 125 },
        },
        fishing = 75,
        dungeons = {},
    },
    [1431] = { -- Duskwood
        name = "Duskwood",
        minLevel = 18,
        maxLevel = 30,
        herbs = {
            { name = "Mageroyal", skill = 50 },
            { name = "Briarthorn", skill = 70 },
            { name = "Bruiseweed", skill = 100 },
            { name = "Kingsblood", skill = 125 },
        },
        ores = {
            { name = "Tin", skill = 65 },
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
        },
        fishing = 75,
        dungeons = {},
    },
    [1426] = { -- Dun Morogh
        name = "Dun Morogh",
        minLevel = 1,
        maxLevel = 10,
        herbs = {
            { name = "Peacebloom", skill = 1 },
            { name = "Silverleaf", skill = 1 },
            { name = "Earthroot", skill = 15 },
        },
        ores = {
            { name = "Copper", skill = 1 },
        },
        fishing = 1,
        dungeons = {
            { name = "Gnomeregan", minLevel = 29, maxLevel = 38 },
        },
    },
    [1438] = { -- Loch Modan
        name = "Loch Modan",
        minLevel = 10,
        maxLevel = 20,
        herbs = {
            { name = "Peacebloom", skill = 1 },
            { name = "Earthroot", skill = 15 },
            { name = "Mageroyal", skill = 50 },
            { name = "Briarthorn", skill = 70 },
        },
        ores = {
            { name = "Copper", skill = 1 },
            { name = "Tin", skill = 65 },
            { name = "Silver", skill = 75 },
        },
        fishing = 55,
        dungeons = {},
    },
    [1437] = { -- Wetlands
        name = "Wetlands",
        minLevel = 20,
        maxLevel = 30,
        herbs = {
            { name = "Kingsblood", skill = 125 },
            { name = "Grave Moss", skill = 120 },
            { name = "Wild Steelbloom", skill = 115 },
        },
        ores = {
            { name = "Tin", skill = 65 },
            { name = "Iron", skill = 125 },
            { name = "Silver", skill = 75 },
        },
        fishing = 105,
        dungeons = {},
    },
    [1420] = { -- Tirisfal Glades
        name = "Tirisfal Glades",
        minLevel = 1,
        maxLevel = 10,
        herbs = {
            { name = "Peacebloom", skill = 1 },
            { name = "Silverleaf", skill = 1 },
            { name = "Earthroot", skill = 15 },
        },
        ores = {
            { name = "Copper", skill = 1 },
        },
        fishing = 1,
        dungeons = {
            { name = "Scarlet Monastery", minLevel = 28, maxLevel = 45 },
        },
    },
    [1421] = { -- Silverpine Forest
        name = "Silverpine Forest",
        minLevel = 10,
        maxLevel = 20,
        herbs = {
            { name = "Peacebloom", skill = 1 },
            { name = "Earthroot", skill = 15 },
            { name = "Mageroyal", skill = 50 },
            { name = "Briarthorn", skill = 70 },
        },
        ores = {
            { name = "Copper", skill = 1 },
            { name = "Tin", skill = 65 },
            { name = "Silver", skill = 75 },
        },
        fishing = 55,
        dungeons = {
            { name = "Shadowfang Keep", minLevel = 22, maxLevel = 30 },
        },
    },
    [1424] = { -- Hillsbrad Foothills
        name = "Hillsbrad Foothills",
        minLevel = 20,
        maxLevel = 30,
        herbs = {
            { name = "Mageroyal", skill = 50 },
            { name = "Briarthorn", skill = 70 },
            { name = "Kingsblood", skill = 125 },
            { name = "Wild Steelbloom", skill = 115 },
        },
        ores = {
            { name = "Tin", skill = 65 },
            { name = "Iron", skill = 125 },
            { name = "Mithril", skill = 175 },
        },
        fishing = 105,
        dungeons = {},
    },
    [1434] = { -- Stranglethorn Vale
        name = "Stranglethorn Vale",
        minLevel = 30,
        maxLevel = 45,
        herbs = {
            { name = "Kingsblood", skill = 125 },
            { name = "Fadeleaf", skill = 160 },
            { name = "Goldthorn", skill = 170 },
            { name = "Khadgar's Whisker", skill = 185 },
        },
        ores = {
            { name = "Iron", skill = 125 },
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
        },
        fishing = 150,
        dungeons = {
            { name = "Zul'Gurub", minLevel = 60, maxLevel = 60 },
        },
    },
    [1411] = { -- Durotar
        name = "Durotar",
        minLevel = 1,
        maxLevel = 10,
        herbs = {
            { name = "Peacebloom", skill = 1 },
            { name = "Silverleaf", skill = 1 },
            { name = "Earthroot", skill = 15 },
        },
        ores = {
            { name = "Copper", skill = 1 },
        },
        fishing = 1,
        dungeons = {
            { name = "Ragefire Chasm", minLevel = 13, maxLevel = 18 },
        },
    },
    [1412] = { -- Mulgore
        name = "Mulgore",
        minLevel = 1,
        maxLevel = 10,
        herbs = {
            { name = "Peacebloom", skill = 1 },
            { name = "Silverleaf", skill = 1 },
            { name = "Earthroot", skill = 15 },
        },
        ores = {
            { name = "Copper", skill = 1 },
        },
        fishing = 1,
        dungeons = {},
    },
    [1413] = { -- The Barrens
        name = "The Barrens",
        minLevel = 10,
        maxLevel = 25,
        herbs = {
            { name = "Peacebloom", skill = 1 },
            { name = "Earthroot", skill = 15 },
            { name = "Mageroyal", skill = 50 },
            { name = "Briarthorn", skill = 70 },
            { name = "Bruiseweed", skill = 100 },
        },
        ores = {
            { name = "Copper", skill = 1 },
            { name = "Tin", skill = 65 },
            { name = "Silver", skill = 75 },
        },
        fishing = 55,
        dungeons = {
            { name = "Wailing Caverns", minLevel = 17, maxLevel = 24 },
            { name = "Razorfen Kraul", minLevel = 29, maxLevel = 38 },
            { name = "Razorfen Downs", minLevel = 37, maxLevel = 46 },
        },
    },
    [1439] = { -- Darkshore
        name = "Darkshore",
        minLevel = 10,
        maxLevel = 20,
        herbs = {
            { name = "Peacebloom", skill = 1 },
            { name = "Earthroot", skill = 15 },
            { name = "Mageroyal", skill = 50 },
            { name = "Briarthorn", skill = 70 },
        },
        ores = {
            { name = "Copper", skill = 1 },
            { name = "Tin", skill = 65 },
        },
        fishing = 55,
        dungeons = {},
    },
    [1440] = { -- Ashenvale
        name = "Ashenvale",
        minLevel = 18,
        maxLevel = 30,
        herbs = {
            { name = "Mageroyal", skill = 50 },
            { name = "Briarthorn", skill = 70 },
            { name = "Bruiseweed", skill = 100 },
            { name = "Kingsblood", skill = 125 },
            { name = "Wild Steelbloom", skill = 115 },
        },
        ores = {
            { name = "Tin", skill = 65 },
            { name = "Iron", skill = 125 },
        },
        fishing = 75,
        dungeons = {
            { name = "Blackfathom Deeps", minLevel = 24, maxLevel = 32 },
        },
    },
}

local zoneDataByName = {}
for mapID, data in pairs(zoneDataByUiMapID) do
    data.uiMapID = mapID
    zoneDataByName[data.name:lower()] = data
end

OneWorldMap.ZoneData.byID = zoneDataByUiMapID
OneWorldMap.ZoneData.byName = zoneDataByName

function OneWorldMap:GetZoneInfo(uiMapID, zoneName)
    if uiMapID and zoneDataByUiMapID[uiMapID] then
        return zoneDataByUiMapID[uiMapID]
    end
    if zoneName then
        local lower = zoneName:lower()
        if zoneDataByName[lower] then
            return zoneDataByName[lower]
        end
    end
    return nil
end
