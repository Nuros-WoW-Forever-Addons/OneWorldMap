-- OneWorldMap: Data/ZoneData.lua
-- Database of Classic & WoW Forever zone metadata: level ranges, gathering thresholds (Herbs, Ore, Skinning, Fish), and dungeon brackets.

OneWorldMap = OneWorldMap or {}
OneWorldMap.ZoneData = {}

local zoneDataByUiMapID = {
    -- =========================================================================
    -- CAPITAL CITIES
    -- =========================================================================
    [1453] = { -- Stormwind City
        name = "Stormwind City",
        isCity = true,
        herbs = {},
        ores = {},
        skins = {},
        fish = {
            { name = "Raw Brilliant Smallfish", skill = 1 },
            { name = "Raw Longjaw Mud Snapper", skill = 50 },
            { name = "Raw Bristle Whisker Catfish", skill = 100 },
        },
        fishing = 1,
        dungeons = {
            { name = "The Stockade", minLevel = 22, maxLevel = 30 },
        },
    },
    [1454] = { -- Orgrimmar
        name = "Orgrimmar",
        isCity = true,
        herbs = {},
        ores = {},
        skins = {},
        fish = {
            { name = "Raw Brilliant Smallfish", skill = 1 },
            { name = "Raw Longjaw Mud Snapper", skill = 50 },
            { name = "Raw Bristle Whisker Catfish", skill = 100 },
        },
        fishing = 1,
        dungeons = {
            { name = "Ragefire Chasm", minLevel = 13, maxLevel = 18 },
        },
    },
    [1455] = { -- Ironforge
        name = "Ironforge",
        isCity = true,
        herbs = {},
        ores = {},
        skins = {},
        fish = {
            { name = "Raw Brilliant Smallfish", skill = 1 },
            { name = "Raw Longjaw Mud Snapper", skill = 50 },
        },
        fishing = 1,
        dungeons = {},
    },
    [1456] = { -- Thunder Bluff
        name = "Thunder Bluff",
        isCity = true,
        herbs = {},
        ores = {},
        skins = {},
        fish = {
            { name = "Raw Brilliant Smallfish", skill = 1 },
            { name = "Raw Longjaw Mud Snapper", skill = 50 },
            { name = "Raw Bristle Whisker Catfish", skill = 100 },
        },
        fishing = 1,
        dungeons = {},
    },
    [1457] = { -- Darnassus
        name = "Darnassus",
        isCity = true,
        herbs = {},
        ores = {},
        skins = {},
        fish = {
            { name = "Raw Brilliant Smallfish", skill = 1 },
            { name = "Raw Longjaw Mud Snapper", skill = 50 },
        },
        fishing = 1,
        dungeons = {},
    },
    [1458] = { -- Undercity
        name = "Undercity",
        isCity = true,
        herbs = {},
        ores = {},
        skins = {},
        fish = {
            { name = "Raw Brilliant Smallfish", skill = 1 },
            { name = "Raw Longjaw Mud Snapper", skill = 50 },
            { name = "Raw Bristle Whisker Catfish", skill = 100 },
        },
        fishing = 1,
        dungeons = {},
    },

    -- =========================================================================
    -- EASTERN KINGDOMS
    -- =========================================================================
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
        skins = {
            { name = "Ruined Leather Scraps", skill = 1 },
            { name = "Light Leather", skill = 1 },
        },
        fish = {
            { name = "Raw Brilliant Smallfish", skill = 1 },
            { name = "Raw Longjaw Mud Snapper", skill = 50 },
        },
        fishing = 1,
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
        skins = {
            { name = "Ruined Leather Scraps", skill = 1 },
            { name = "Light Leather", skill = 1 },
        },
        fish = {
            { name = "Raw Brilliant Smallfish", skill = 1 },
            { name = "Raw Longjaw Mud Snapper", skill = 50 },
        },
        fishing = 1,
        dungeons = {
            { name = "Gnomeregan", minLevel = 29, maxLevel = 38 },
        },
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
        skins = {
            { name = "Ruined Leather Scraps", skill = 1 },
            { name = "Light Leather", skill = 1 },
        },
        fish = {
            { name = "Raw Brilliant Smallfish", skill = 1 },
            { name = "Raw Longjaw Mud Snapper", skill = 50 },
        },
        fishing = 1,
        dungeons = {
            { name = "Scarlet Monastery", minLevel = 28, maxLevel = 45 },
        },
    },
    [1436] = { -- Westfall
        name = "Westfall",
        minLevel = 10,
        maxLevel = 20,
        herbs = {
            { name = "Peacebloom", skill = 1 },
            { name = "Silverleaf", skill = 1 },
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
        skins = {
            { name = "Light Leather", skill = 1 },
            { name = "Light Hide", skill = 1 },
            { name = "Medium Leather", skill = 75 },
        },
        fish = {
            { name = "Raw Slitherskin Mackerel", skill = 1 },
            { name = "Raw Rainbow Fin Albacore", skill = 50 },
            { name = "Oily Blackmouth", skill = 100 },
            { name = "Firefin Snapper", skill = 100 },
        },
        fishing = 55,
        dungeons = {
            { name = "The Deadmines", minLevel = 17, maxLevel = 24 },
        },
    },
    [1432] = { -- Loch Modan
        name = "Loch Modan",
        minLevel = 10,
        maxLevel = 20,
        herbs = {
            { name = "Peacebloom", skill = 1 },
            { name = "Silverleaf", skill = 1 },
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
        skins = {
            { name = "Light Leather", skill = 1 },
            { name = "Light Hide", skill = 1 },
            { name = "Medium Leather", skill = 75 },
        },
        fish = {
            { name = "Raw Loch Frenzy", skill = 50 },
            { name = "Raw Longjaw Mud Snapper", skill = 50 },
            { name = "Raw Bristle Whisker Catfish", skill = 100 },
        },
        fishing = 20,
        dungeons = {},
    },
    [1421] = { -- Silverpine Forest
        name = "Silverpine Forest",
        minLevel = 10,
        maxLevel = 20,
        herbs = {
            { name = "Peacebloom", skill = 1 },
            { name = "Silverleaf", skill = 1 },
            { name = "Earthroot", skill = 15 },
            { name = "Mageroyal", skill = 50 },
            { name = "Briarthorn", skill = 70 },
            { name = "Stranglekelp", skill = 85 },
            { name = "Bruiseweed", skill = 100 },
        },
        ores = {
            { name = "Copper", skill = 1 },
            { name = "Tin", skill = 65 },
            { name = "Silver", skill = 75 },
        },
        skins = {
            { name = "Light Leather", skill = 1 },
            { name = "Light Hide", skill = 1 },
            { name = "Medium Leather", skill = 75 },
        },
        fish = {
            { name = "Raw Slitherskin Mackerel", skill = 1 },
            { name = "Raw Rainbow Fin Albacore", skill = 50 },
            { name = "Oily Blackmouth", skill = 100 },
        },
        fishing = 20,
        dungeons = {
            { name = "Shadowfang Keep", minLevel = 22, maxLevel = 30 },
        },
    },
    [1433] = { -- Redridge Mountains
        name = "Redridge Mountains",
        minLevel = 15,
        maxLevel = 25,
        herbs = {
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
        skins = {
            { name = "Light Leather", skill = 1 },
            { name = "Medium Leather", skill = 75 },
            { name = "Medium Hide", skill = 100 },
        },
        fish = {
            { name = "Raw Longjaw Mud Snapper", skill = 50 },
            { name = "Raw Bristle Whisker Catfish", skill = 100 },
        },
        fishing = 55,
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
            { name = "Wild Steelbloom", skill = 115 },
            { name = "Grave Moss", skill = 120 },
            { name = "Kingsblood", skill = 125 },
        },
        ores = {
            { name = "Copper", skill = 1 },
            { name = "Tin", skill = 65 },
            { name = "Silver", skill = 75 },
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
        },
        skins = {
            { name = "Medium Leather", skill = 75 },
            { name = "Medium Hide", skill = 100 },
            { name = "Heavy Leather", skill = 150 },
        },
        fish = {
            { name = "Raw Bristle Whisker Catfish", skill = 100 },
            { name = "Raw Mithril Head Trout", skill = 175 },
        },
        fishing = 55,
        dungeons = {},
    },
    [1437] = { -- Wetlands
        name = "Wetlands",
        minLevel = 20,
        maxLevel = 30,
        herbs = {
            { name = "Mageroyal", skill = 50 },
            { name = "Briarthorn", skill = 70 },
            { name = "Stranglekelp", skill = 85 },
            { name = "Bruiseweed", skill = 100 },
            { name = "Wild Steelbloom", skill = 115 },
            { name = "Grave Moss", skill = 120 },
            { name = "Kingsblood", skill = 125 },
            { name = "Liferoot", skill = 150 },
        },
        ores = {
            { name = "Copper", skill = 1 },
            { name = "Tin", skill = 65 },
            { name = "Silver", skill = 75 },
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
        },
        skins = {
            { name = "Medium Leather", skill = 75 },
            { name = "Medium Hide", skill = 100 },
            { name = "Heavy Leather", skill = 150 },
        },
        fish = {
            { name = "Raw Bristle Whisker Catfish", skill = 100 },
            { name = "Raw Mithril Head Trout", skill = 175 },
            { name = "Oily Blackmouth", skill = 100 },
            { name = "Firefin Snapper", skill = 100 },
        },
        fishing = 55,
        dungeons = {},
    },
    [1424] = { -- Hillsbrad Foothills
        name = "Hillsbrad Foothills",
        minLevel = 20,
        maxLevel = 30,
        herbs = {
            { name = "Mageroyal", skill = 50 },
            { name = "Briarthorn", skill = 70 },
            { name = "Stranglekelp", skill = 85 },
            { name = "Bruiseweed", skill = 100 },
            { name = "Wild Steelbloom", skill = 115 },
            { name = "Kingsblood", skill = 125 },
            { name = "Liferoot", skill = 150 },
        },
        ores = {
            { name = "Copper", skill = 1 },
            { name = "Tin", skill = 65 },
            { name = "Silver", skill = 75 },
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
        },
        skins = {
            { name = "Medium Leather", skill = 75 },
            { name = "Medium Hide", skill = 100 },
            { name = "Heavy Leather", skill = 150 },
        },
        fish = {
            { name = "Raw Bristle Whisker Catfish", skill = 100 },
            { name = "Raw Mithril Head Trout", skill = 175 },
            { name = "Oily Blackmouth", skill = 100 },
            { name = "Firefin Snapper", skill = 100 },
        },
        fishing = 55,
        dungeons = {},
    },
    [1416] = { -- Alterac Mountains
        name = "Alterac Mountains",
        minLevel = 30,
        maxLevel = 40,
        herbs = {
            { name = "Stranglekelp", skill = 85 },
            { name = "Bruiseweed", skill = 100 },
            { name = "Wild Steelbloom", skill = 115 },
            { name = "Grave Moss", skill = 120 },
            { name = "Kingsblood", skill = 125 },
            { name = "Liferoot", skill = 150 },
            { name = "Fadeleaf", skill = 160 },
            { name = "Goldthorn", skill = 170 },
            { name = "Khadgar's Whisker", skill = 185 },
            { name = "Wintersbite", skill = 195 },
        },
        ores = {
            { name = "Tin", skill = 65 },
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
        },
        skins = {
            { name = "Heavy Leather", skill = 150 },
            { name = "Heavy Hide", skill = 150 },
            { name = "Thick Leather", skill = 200 },
        },
        fish = {
            { name = "Raw Bristle Whisker Catfish", skill = 100 },
            { name = "Raw Mithril Head Trout", skill = 175 },
        },
        fishing = 130,
        dungeons = {},
    },
    [1417] = { -- Arathi Highlands
        name = "Arathi Highlands",
        minLevel = 30,
        maxLevel = 40,
        herbs = {
            { name = "Stranglekelp", skill = 85 },
            { name = "Bruiseweed", skill = 100 },
            { name = "Wild Steelbloom", skill = 115 },
            { name = "Grave Moss", skill = 120 },
            { name = "Kingsblood", skill = 125 },
            { name = "Liferoot", skill = 150 },
            { name = "Fadeleaf", skill = 160 },
            { name = "Goldthorn", skill = 170 },
            { name = "Khadgar's Whisker", skill = 185 },
        },
        ores = {
            { name = "Tin", skill = 65 },
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
        },
        skins = {
            { name = "Heavy Leather", skill = 150 },
            { name = "Heavy Hide", skill = 150 },
            { name = "Thick Leather", skill = 200 },
        },
        fish = {
            { name = "Raw Bristle Whisker Catfish", skill = 100 },
            { name = "Raw Mithril Head Trout", skill = 175 },
            { name = "Oily Blackmouth", skill = 100 },
            { name = "Firefin Snapper", skill = 100 },
        },
        fishing = 130,
        dungeons = {},
    },
    [1434] = { -- Stranglethorn Vale
        name = "Stranglethorn Vale",
        minLevel = 30,
        maxLevel = 45,
        herbs = {
            { name = "Stranglekelp", skill = 85 },
            { name = "Wild Steelbloom", skill = 115 },
            { name = "Kingsblood", skill = 125 },
            { name = "Liferoot", skill = 150 },
            { name = "Fadeleaf", skill = 160 },
            { name = "Goldthorn", skill = 170 },
            { name = "Khadgar's Whisker", skill = 185 },
            { name = "Purple Lotus", skill = 210 },
        },
        ores = {
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
        },
        skins = {
            { name = "Medium Leather", skill = 75 },
            { name = "Heavy Leather", skill = 150 },
            { name = "Heavy Hide", skill = 150 },
            { name = "Thick Leather", skill = 200 },
            { name = "Thick Hide", skill = 200 },
        },
        fish = {
            { name = "Raw Mithril Head Trout", skill = 175 },
            { name = "Raw Spotted Yellowtail", skill = 225 },
            { name = "Raw Rockscale Cod", skill = 175 },
            { name = "Oily Blackmouth", skill = 100 },
            { name = "Firefin Snapper", skill = 100 },
        },
        fishing = 130,
        dungeons = {
            { name = "Zul'Gurub", minLevel = 60, maxLevel = 60 },
        },
    },
    [1418] = { -- Badlands
        name = "Badlands",
        minLevel = 35,
        maxLevel = 45,
        herbs = {
            { name = "Wild Steelbloom", skill = 115 },
            { name = "Kingsblood", skill = 125 },
            { name = "Fadeleaf", skill = 160 },
            { name = "Goldthorn", skill = 170 },
            { name = "Khadgar's Whisker", skill = 185 },
            { name = "Firebloom", skill = 205 },
            { name = "Purple Lotus", skill = 210 },
        },
        ores = {
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
        },
        skins = {
            { name = "Heavy Leather", skill = 150 },
            { name = "Heavy Hide", skill = 150 },
            { name = "Thick Leather", skill = 200 },
            { name = "Thick Hide", skill = 200 },
        },
        fish = {},
        dungeons = {
            { name = "Uldaman", minLevel = 41, maxLevel = 51 },
        },
    },
    [1435] = { -- Swamp of Sorrows
        name = "Swamp of Sorrows",
        minLevel = 35,
        maxLevel = 45,
        herbs = {
            { name = "Stranglekelp", skill = 85 },
            { name = "Kingsblood", skill = 125 },
            { name = "Fadeleaf", skill = 160 },
            { name = "Goldthorn", skill = 170 },
            { name = "Khadgar's Whisker", skill = 185 },
            { name = "Blindweed", skill = 235 },
        },
        ores = {
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
        },
        skins = {
            { name = "Heavy Leather", skill = 150 },
            { name = "Thick Leather", skill = 200 },
            { name = "Thick Hide", skill = 200 },
        },
        fish = {
            { name = "Raw Bristle Whisker Catfish", skill = 100 },
            { name = "Raw Mithril Head Trout", skill = 175 },
            { name = "Raw Spotted Yellowtail", skill = 225 },
        },
        fishing = 130,
        dungeons = {
            { name = "The Temple of Atal'Hakkar", minLevel = 50, maxLevel = 56 },
        },
    },
    [1425] = { -- The Hinterlands
        name = "The Hinterlands",
        minLevel = 40,
        maxLevel = 50,
        herbs = {
            { name = "Stranglekelp", skill = 85 },
            { name = "Liferoot", skill = 150 },
            { name = "Fadeleaf", skill = 160 },
            { name = "Goldthorn", skill = 170 },
            { name = "Khadgar's Whisker", skill = 185 },
            { name = "Purple Lotus", skill = 210 },
            { name = "Sungrass", skill = 230 },
            { name = "Ghost Mushroom", skill = 245 },
            { name = "Golden Sansam", skill = 260 },
        },
        ores = {
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
        },
        skins = {
            { name = "Thick Leather", skill = 200 },
            { name = "Thick Hide", skill = 200 },
            { name = "Rugged Leather", skill = 250 },
        },
        fish = {
            { name = "Raw Mithril Head Trout", skill = 175 },
            { name = "Raw Spotted Yellowtail", skill = 225 },
            { name = "Winter Squid", skill = 225 },
        },
        fishing = 205,
        dungeons = {},
    },
    [1427] = { -- Searing Gorge
        name = "Searing Gorge",
        minLevel = 43,
        maxLevel = 50,
        herbs = {
            { name = "Firebloom", skill = 205 },
        },
        ores = {
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
            { name = "Dark Iron", skill = 230 },
            { name = "Small Thorium", skill = 245 },
        },
        skins = {
            { name = "Thick Leather", skill = 200 },
            { name = "Thick Hide", skill = 200 },
            { name = "Rugged Leather", skill = 250 },
        },
        fish = {},
        dungeons = {
            { name = "Blackrock Depths", minLevel = 52, maxLevel = 60 },
            { name = "Blackrock Spire", minLevel = 55, maxLevel = 60 },
            { name = "Molten Core", minLevel = 60, maxLevel = 60 },
            { name = "Blackwing Lair", minLevel = 60, maxLevel = 60 },
        },
    },
    [1419] = { -- Blasted Lands
        name = "Blasted Lands",
        minLevel = 45,
        maxLevel = 55,
        herbs = {
            { name = "Goldthorn", skill = 170 },
            { name = "Firebloom", skill = 205 },
            { name = "Sungrass", skill = 230 },
            { name = "Gromsblood", skill = 250 },
        },
        ores = {
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
            { name = "Small Thorium", skill = 245 },
        },
        skins = {
            { name = "Thick Leather", skill = 200 },
            { name = "Rugged Leather", skill = 250 },
            { name = "Rugged Hide", skill = 250 },
        },
        fish = {},
        dungeons = {},
    },
    [1428] = { -- Burning Steppes
        name = "Burning Steppes",
        minLevel = 50,
        maxLevel = 58,
        herbs = {
            { name = "Sungrass", skill = 230 },
            { name = "Golden Sansam", skill = 260 },
            { name = "Dreamfoil", skill = 270 },
            { name = "Mountain Silversage", skill = 280 },
            { name = "Black Lotus", skill = 300 },
        },
        ores = {
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
            { name = "Dark Iron", skill = 230 },
            { name = "Small Thorium", skill = 245 },
            { name = "Rich Thorium", skill = 275 },
        },
        skins = {
            { name = "Thick Leather", skill = 200 },
            { name = "Rugged Leather", skill = 250 },
            { name = "Rugged Hide", skill = 250 },
        },
        fish = {},
        dungeons = {
            { name = "Blackrock Depths", minLevel = 52, maxLevel = 60 },
            { name = "Blackrock Spire", minLevel = 55, maxLevel = 60 },
            { name = "Molten Core", minLevel = 60, maxLevel = 60 },
            { name = "Blackwing Lair", minLevel = 60, maxLevel = 60 },
        },
    },
    [1422] = { -- Western Plaguelands
        name = "Western Plaguelands",
        minLevel = 51,
        maxLevel = 58,
        herbs = {
            { name = "Arthas' Tears", skill = 220 },
            { name = "Sungrass", skill = 230 },
            { name = "Dreamfoil", skill = 270 },
            { name = "Mountain Silversage", skill = 280 },
            { name = "Plaguebloom", skill = 285 },
        },
        ores = {
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
            { name = "Small Thorium", skill = 245 },
            { name = "Rich Thorium", skill = 275 },
        },
        skins = {
            { name = "Thick Leather", skill = 200 },
            { name = "Rugged Leather", skill = 250 },
            { name = "Rugged Hide", skill = 250 },
        },
        fish = {
            { name = "Raw Mithril Head Trout", skill = 175 },
            { name = "Raw Redgill", skill = 225 },
        },
        fishing = 205,
        dungeons = {
            { name = "Scholomance", minLevel = 58, maxLevel = 60 },
        },
    },
    [1423] = { -- Eastern Plaguelands
        name = "Eastern Plaguelands",
        minLevel = 53,
        maxLevel = 60,
        herbs = {
            { name = "Arthas' Tears", skill = 220 },
            { name = "Sungrass", skill = 230 },
            { name = "Golden Sansam", skill = 260 },
            { name = "Dreamfoil", skill = 270 },
            { name = "Mountain Silversage", skill = 280 },
            { name = "Plaguebloom", skill = 285 },
            { name = "Black Lotus", skill = 300 },
        },
        ores = {
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
            { name = "Small Thorium", skill = 245 },
            { name = "Rich Thorium", skill = 275 },
        },
        skins = {
            { name = "Rugged Leather", skill = 250 },
            { name = "Rugged Hide", skill = 250 },
        },
        fish = {
            { name = "Raw Redgill", skill = 225 },
            { name = "Raw Whitescale Salmon", skill = 250 },
        },
        fishing = 330,
        dungeons = {
            { name = "Stratholme", minLevel = 58, maxLevel = 60 },
            { name = "Naxxramas", minLevel = 60, maxLevel = 60 },
        },
    },
    [1430] = { -- Deadwind Pass
        name = "Deadwind Pass",
        minLevel = 55,
        maxLevel = 60,
        herbs = {},
        ores = {
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
            { name = "Small Thorium", skill = 245 },
        },
        skins = {
            { name = "Rugged Leather", skill = 250 },
        },
        fish = {
            { name = "Raw Whitescale Salmon", skill = 250 },
        },
        fishing = 330,
        dungeons = {},
    },
    [1459] = { -- Alterac Valley
        name = "Alterac Valley",
        minLevel = 51,
        maxLevel = 60,
        herbs = {
            { name = "Wintersbite", skill = 195 },
            { name = "Mountain Silversage", skill = 280 },
            { name = "Icecap", skill = 290 },
            { name = "Black Lotus", skill = 300 },
        },
        ores = {
            { name = "Iron", skill = 125 },
            { name = "Mithril", skill = 175 },
            { name = "Small Thorium", skill = 245 },
            { name = "Rich Thorium", skill = 275 },
        },
        skins = {
            { name = "Rugged Leather", skill = 250 },
        },
        fish = {},
        dungeons = {},
    },

    -- =========================================================================
    -- KALIMDOR
    -- =========================================================================
    [1411] = { -- Durotar
        name = "Durotar",
        minLevel = 1,
        maxLevel = 10,
        herbs = {
            { name = "Peacebloom", skill = 1 },
            { name = "Silverleaf", skill = 1 },
            { name = "Earthroot", skill = 15 },
            { name = "Mageroyal", skill = 50 },
        },
        ores = {
            { name = "Copper", skill = 1 },
        },
        skins = {
            { name = "Ruined Leather Scraps", skill = 1 },
            { name = "Light Leather", skill = 1 },
        },
        fish = {
            { name = "Raw Slitherskin Mackerel", skill = 1 },
            { name = "Raw Brilliant Smallfish", skill = 1 },
            { name = "Raw Longjaw Mud Snapper", skill = 50 },
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
        skins = {
            { name = "Ruined Leather Scraps", skill = 1 },
            { name = "Light Leather", skill = 1 },
        },
        fish = {
            { name = "Raw Brilliant Smallfish", skill = 1 },
            { name = "Raw Longjaw Mud Snapper", skill = 50 },
        },
        fishing = 1,
        dungeons = {},
    },
    [1438] = { -- Teldrassil
        name = "Teldrassil",
        minLevel = 1,
        maxLevel = 10,
        herbs = {
            { name = "Peacebloom", skill = 1 },
            { name = "Silverleaf", skill = 1 },
            { name = "Earthroot", skill = 15 },
        },
        ores = {},
        skins = {
            { name = "Ruined Leather Scraps", skill = 1 },
            { name = "Light Leather", skill = 1 },
        },
        fish = {
            { name = "Raw Brilliant Smallfish", skill = 1 },
            { name = "Raw Slitherskin Mackerel", skill = 1 },
            { name = "Raw Longjaw Mud Snapper", skill = 50 },
        },
        fishing = 1,
        dungeons = {},
    },
    [1439] = { -- Darkshore
        name = "Darkshore",
        minLevel = 10,
        maxLevel = 20,
        herbs = {
            { name = "Peacebloom", skill = 1 },
            { name = "Silverleaf", skill = 1 },
            { name = "Earthroot", skill = 15 },
            { name = "Mageroyal", skill = 50 },
            { name = "Briarthorn", skill = 70 },
            { name = "Stranglekelp", skill = 85 },
            { name = "Bruiseweed", skill = 100 },
        },
        ores = {
            { name = "Copper", skill = 1 },
            { name = "Tin", skill = 65 },
            { name = "Silver", skill = 75 },
        },
        skins = {
            { name = "Light Leather", skill = 1 },
            { name = "Light Hide", skill = 1 },
            { name = "Medium Leather", skill = 75 },
        },
        fish = {
            { name = "Raw Slitherskin Mackerel", skill = 1 },
            { name = "Raw Rainbow Fin Albacore", skill = 50 },
            { name = "Oily Blackmouth", skill = 100 },
        },
        fishing = 20,
        dungeons = {},
    },
    [1413] = { -- The Barrens
        name = "The Barrens",
        minLevel = 10,
        maxLevel = 25,
        herbs = {
            { name = "Peacebloom", skill = 1 },
            { name = "Silverleaf", skill = 1 },
            { name = "Earthroot", skill = 15 },
            { name = "Mageroyal", skill = 50 },
            { name = "Briarthorn", skill = 70 },
            { name = "Stranglekelp", skill = 85 },
            { name = "Bruiseweed", skill = 100 },
            { name = "Wild Steelbloom", skill = 115 },
            { name = "Kingsblood", skill = 125 },
        },
        ores = {
            { name = "Copper", skill = 1 },
            { name = "Tin", skill = 65 },
            { name = "Silver", skill = 75 },
            { name = "Iron", skill = 125 },
        },
        skins = {
            { name = "Light Leather", skill = 1 },
            { name = "Light Hide", skill = 1 },
            { name = "Medium Leather", skill = 75 },
            { name = "Medium Hide", skill = 100 },
        },
        fish = {
            { name = "Deviate Fish", skill = 1 },
            { name = "Raw Longjaw Mud Snapper", skill = 50 },
            { name = "Raw Bristle Whisker Catfish", skill = 100 },
            { name = "Oily Blackmouth", skill = 100 },
        },
        fishing = 20,
        dungeons = {
            { name = "Wailing Caverns", minLevel = 17, maxLevel = 24 },
            { name = "Razorfen Kraul", minLevel = 29, maxLevel = 38 },
            { name = "Razorfen Downs", minLevel = 37, maxLevel = 46 },
        },
    },
    [1442] = { -- Stonetalon Mountains
        name = "Stonetalon Mountains",
        minLevel = 15,
        maxLevel = 27,
        herbs = {
            { name = "Mageroyal", skill = 50 },
            { name = "Briarthorn", skill = 70 },
            { name = "Bruiseweed", skill = 100 },
            { name = "Wild Steelbloom", skill = 115 },
            { name = "Kingsblood", skill = 125 },
        },
        ores = {
            { name = "Copper", skill = 1 },
            { name = "Tin", skill = 65 },
            { name = "Silver", skill = 75 },
            { name = "Iron", skill = 125 },
            { name = "Mithril", skill = 175 },
        },
        skins = {
            { name = "Light Leather", skill = 1 },
            { name = "Medium Leather", skill = 75 },
            { name = "Medium Hide", skill = 100 },
            { name = "Heavy Leather", skill = 150 },
        },
        fish = {
            { name = "Raw Bristle Whisker Catfish", skill = 100 },
            { name = "Raw Mithril Head Trout", skill = 175 },
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
            { name = "Stranglekelp", skill = 85 },
            { name = "Bruiseweed", skill = 100 },
            { name = "Wild Steelbloom", skill = 115 },
            { name = "Kingsblood", skill = 125 },
            { name = "Liferoot", skill = 150 },
        },
        ores = {
            { name = "Copper", skill = 1 },
            { name = "Tin", skill = 65 },
            { name = "Silver", skill = 75 },
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
        },
        skins = {
            { name = "Medium Leather", skill = 75 },
            { name = "Medium Hide", skill = 100 },
            { name = "Heavy Leather", skill = 150 },
        },
        fish = {
            { name = "Raw Bristle Whisker Catfish", skill = 100 },
            { name = "Raw Mithril Head Trout", skill = 175 },
            { name = "Oily Blackmouth", skill = 100 },
        },
        fishing = 55,
        dungeons = {
            { name = "Blackfathom Deeps", minLevel = 24, maxLevel = 32 },
        },
    },
    [1441] = { -- Thousand Needles
        name = "Thousand Needles",
        minLevel = 25,
        maxLevel = 35,
        herbs = {
            { name = "Bruiseweed", skill = 100 },
            { name = "Wild Steelbloom", skill = 115 },
            { name = "Kingsblood", skill = 125 },
            { name = "Purple Lotus", skill = 210 },
        },
        ores = {
            { name = "Copper", skill = 1 },
            { name = "Tin", skill = 65 },
            { name = "Silver", skill = 75 },
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
        },
        skins = {
            { name = "Medium Leather", skill = 75 },
            { name = "Heavy Leather", skill = 150 },
            { name = "Heavy Hide", skill = 150 },
            { name = "Thick Leather", skill = 200 },
        },
        fish = {
            { name = "Raw Bristle Whisker Catfish", skill = 100 },
            { name = "Raw Mithril Head Trout", skill = 175 },
        },
        fishing = 130,
        dungeons = {},
    },
    [1443] = { -- Desolace
        name = "Desolace",
        minLevel = 30,
        maxLevel = 40,
        herbs = {
            { name = "Stranglekelp", skill = 85 },
            { name = "Bruiseweed", skill = 100 },
            { name = "Wild Steelbloom", skill = 115 },
            { name = "Grave Moss", skill = 120 },
            { name = "Kingsblood", skill = 125 },
            { name = "Liferoot", skill = 150 },
            { name = "Gromsblood", skill = 250 },
        },
        ores = {
            { name = "Copper", skill = 1 },
            { name = "Tin", skill = 65 },
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
        },
        skins = {
            { name = "Heavy Leather", skill = 150 },
            { name = "Heavy Hide", skill = 150 },
            { name = "Thick Leather", skill = 200 },
        },
        fish = {
            { name = "Raw Mithril Head Trout", skill = 175 },
            { name = "Oily Blackmouth", skill = 100 },
            { name = "Firefin Snapper", skill = 100 },
        },
        fishing = 130,
        dungeons = {
            { name = "Maraudon", minLevel = 45, maxLevel = 52 },
        },
    },
    [1445] = { -- Dustwallow Marsh
        name = "Dustwallow Marsh",
        minLevel = 35,
        maxLevel = 45,
        herbs = {
            { name = "Stranglekelp", skill = 85 },
            { name = "Kingsblood", skill = 125 },
            { name = "Liferoot", skill = 150 },
            { name = "Fadeleaf", skill = 160 },
            { name = "Goldthorn", skill = 170 },
            { name = "Khadgar's Whisker", skill = 185 },
        },
        ores = {
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
        },
        skins = {
            { name = "Heavy Leather", skill = 150 },
            { name = "Thick Leather", skill = 200 },
            { name = "Thick Hide", skill = 200 },
        },
        fish = {
            { name = "Raw Mithril Head Trout", skill = 175 },
            { name = "Raw Spotted Yellowtail", skill = 225 },
            { name = "Oily Blackmouth", skill = 100 },
            { name = "Firefin Snapper", skill = 100 },
        },
        fishing = 130,
        dungeons = {
            { name = "Onyxia's Lair", minLevel = 60, maxLevel = 60 },
        },
    },
    [1444] = { -- Feralas
        name = "Feralas",
        minLevel = 40,
        maxLevel = 50,
        herbs = {
            { name = "Stranglekelp", skill = 85 },
            { name = "Liferoot", skill = 150 },
            { name = "Goldthorn", skill = 170 },
            { name = "Khadgar's Whisker", skill = 185 },
            { name = "Purple Lotus", skill = 210 },
            { name = "Sungrass", skill = 230 },
            { name = "Golden Sansam", skill = 260 },
        },
        ores = {
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
            { name = "Small Thorium", skill = 245 },
        },
        skins = {
            { name = "Thick Leather", skill = 200 },
            { name = "Thick Hide", skill = 200 },
            { name = "Rugged Leather", skill = 250 },
            { name = "Rugged Hide", skill = 250 },
        },
        fish = {
            { name = "Raw Mithril Head Trout", skill = 175 },
            { name = "Raw Redgill", skill = 225 },
            { name = "Raw Spotted Yellowtail", skill = 225 },
        },
        fishing = 205,
        dungeons = {
            { name = "Dire Maul", minLevel = 55, maxLevel = 60 },
        },
    },
    [1446] = { -- Tanaris
        name = "Tanaris",
        minLevel = 40,
        maxLevel = 50,
        herbs = {
            { name = "Stranglekelp", skill = 85 },
            { name = "Firebloom", skill = 205 },
            { name = "Purple Lotus", skill = 210 },
        },
        ores = {
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
            { name = "Small Thorium", skill = 245 },
        },
        skins = {
            { name = "Thick Leather", skill = 200 },
            { name = "Thick Hide", skill = 200 },
            { name = "Rugged Leather", skill = 250 },
        },
        fish = {
            { name = "Raw Spotted Yellowtail", skill = 225 },
            { name = "Raw Glossy Mightfish", skill = 225 },
            { name = "Firefin Snapper", skill = 100 },
            { name = "Stonescale Eel", skill = 250 },
        },
        fishing = 205,
        dungeons = {
            { name = "Zul'Farrak", minLevel = 44, maxLevel = 54 },
        },
    },
    [1447] = { -- Azshara
        name = "Azshara",
        minLevel = 45,
        maxLevel = 55,
        herbs = {
            { name = "Stranglekelp", skill = 85 },
            { name = "Goldthorn", skill = 170 },
            { name = "Khadgar's Whisker", skill = 185 },
            { name = "Purple Lotus", skill = 210 },
            { name = "Sungrass", skill = 230 },
            { name = "Golden Sansam", skill = 260 },
            { name = "Dreamfoil", skill = 270 },
            { name = "Mountain Silversage", skill = 280 },
        },
        ores = {
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
            { name = "Small Thorium", skill = 245 },
            { name = "Rich Thorium", skill = 275 },
        },
        skins = {
            { name = "Thick Leather", skill = 200 },
            { name = "Rugged Leather", skill = 250 },
            { name = "Rugged Hide", skill = 250 },
        },
        fish = {
            { name = "Raw Spotted Yellowtail", skill = 225 },
            { name = "Winter Squid", skill = 225 },
            { name = "Stonescale Eel", skill = 250 },
        },
        fishing = 205,
        dungeons = {},
    },
    [1448] = { -- Felwood
        name = "Felwood",
        minLevel = 48,
        maxLevel = 55,
        herbs = {
            { name = "Arthas' Tears", skill = 220 },
            { name = "Sungrass", skill = 230 },
            { name = "Gromsblood", skill = 250 },
            { name = "Golden Sansam", skill = 260 },
            { name = "Dreamfoil", skill = 270 },
            { name = "Mountain Silversage", skill = 280 },
            { name = "Plaguebloom", skill = 285 },
        },
        ores = {
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
            { name = "Small Thorium", skill = 245 },
        },
        skins = {
            { name = "Thick Leather", skill = 200 },
            { name = "Rugged Leather", skill = 250 },
            { name = "Rugged Hide", skill = 250 },
        },
        fish = {
            { name = "Raw Redgill", skill = 225 },
            { name = "Raw Nightfin Snapper", skill = 250 },
        },
        fishing = 205,
        dungeons = {},
    },
    [1449] = { -- Un'Goro Crater
        name = "Un'Goro Crater",
        minLevel = 48,
        maxLevel = 55,
        herbs = {
            { name = "Sungrass", skill = 230 },
            { name = "Blindweed", skill = 235 },
            { name = "Golden Sansam", skill = 260 },
            { name = "Dreamfoil", skill = 270 },
            { name = "Mountain Silversage", skill = 280 },
        },
        ores = {
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
            { name = "Small Thorium", skill = 245 },
            { name = "Rich Thorium", skill = 275 },
        },
        skins = {
            { name = "Thick Leather", skill = 200 },
            { name = "Rugged Leather", skill = 250 },
            { name = "Rugged Hide", skill = 250 },
            { name = "Devilsaur Leather", skill = 270 },
        },
        fish = {
            { name = "Raw Redgill", skill = 225 },
            { name = "Raw Nightfin Snapper", skill = 250 },
        },
        fishing = 205,
        dungeons = {},
    },
    [1450] = { -- Moonglade
        name = "Moonglade",
        minLevel = 1,
        maxLevel = 60,
        herbs = {},
        ores = {},
        skins = {},
        fish = {
            { name = "Raw Redgill", skill = 225 },
            { name = "Raw Nightfin Snapper", skill = 250 },
            { name = "Raw Sunscale Salmon", skill = 250 },
        },
        fishing = 205,
        dungeons = {},
    },
    [1451] = { -- Silithus
        name = "Silithus",
        minLevel = 55,
        maxLevel = 60,
        herbs = {
            { name = "Sungrass", skill = 230 },
            { name = "Golden Sansam", skill = 260 },
            { name = "Dreamfoil", skill = 270 },
            { name = "Mountain Silversage", skill = 280 },
            { name = "Black Lotus", skill = 300 },
        },
        ores = {
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
            { name = "Small Thorium", skill = 245 },
            { name = "Rich Thorium", skill = 275 },
        },
        skins = {
            { name = "Rugged Leather", skill = 250 },
            { name = "Rugged Hide", skill = 250 },
        },
        fish = {},
        dungeons = {
            { name = "Ruins of Ahn'Qiraj", minLevel = 60, maxLevel = 60 },
            { name = "Temple of Ahn'Qiraj", minLevel = 60, maxLevel = 60 },
        },
    },
    [1452] = { -- Winterspring
        name = "Winterspring",
        minLevel = 53,
        maxLevel = 60,
        herbs = {
            { name = "Mountain Silversage", skill = 280 },
            { name = "Icecap", skill = 290 },
            { name = "Black Lotus", skill = 300 },
        },
        ores = {
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
            { name = "Small Thorium", skill = 245 },
            { name = "Rich Thorium", skill = 275 },
        },
        skins = {
            { name = "Rugged Leather", skill = 250 },
            { name = "Rugged Hide", skill = 250 },
        },
        fish = {
            { name = "Raw Whitescale Salmon", skill = 250 },
            { name = "Raw Nightfin Snapper", skill = 250 },
        },
        fishing = 330,
        dungeons = {},
    },

    -- =========================================================================
    -- WOW FOREVER CUSTOM ZONES
    -- =========================================================================
    [2482] = { -- Mount Hyjal
        name = "Mount Hyjal",
        minLevel = 58,
        maxLevel = 60,
        herbs = {
            { name = "Golden Sansam", skill = 260 },
            { name = "Dreamfoil", skill = 270 },
            { name = "Mountain Silversage", skill = 280 },
            { name = "Icecap", skill = 290 },
            { name = "Black Lotus", skill = 300 },
        },
        ores = {
            { name = "Small Thorium", skill = 245 },
            { name = "Rich Thorium", skill = 275 },
        },
        skins = {
            { name = "Rugged Leather", skill = 250 },
            { name = "Rugged Hide", skill = 250 },
        },
        fish = {
            { name = "Raw Whitescale Salmon", skill = 250 },
            { name = "Raw Nightfin Snapper", skill = 250 },
        },
        fishing = 330,
        dungeons = {},
    },
    [2521] = { -- Zephras Isle
        name = "Zephras Isle",
        minLevel = 25,
        maxLevel = 35,
        herbs = {
            { name = "Stranglekelp", skill = 85 },
            { name = "Bruiseweed", skill = 100 },
            { name = "Wild Steelbloom", skill = 115 },
            { name = "Kingsblood", skill = 125 },
            { name = "Liferoot", skill = 150 },
        },
        ores = {
            { name = "Tin", skill = 65 },
            { name = "Silver", skill = 75 },
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
        },
        skins = {
            { name = "Medium Leather", skill = 75 },
            { name = "Heavy Leather", skill = 150 },
        },
        fish = {
            { name = "Raw Mithril Head Trout", skill = 175 },
            { name = "Oily Blackmouth", skill = 100 },
            { name = "Firefin Snapper", skill = 100 },
        },
        fishing = 130,
        dungeons = {},
    },
    [2548] = { -- Riverglades
        name = "Riverglades",
        minLevel = 30,
        maxLevel = 40,
        herbs = {
            { name = "Wild Steelbloom", skill = 115 },
            { name = "Kingsblood", skill = 125 },
            { name = "Liferoot", skill = 150 },
            { name = "Fadeleaf", skill = 160 },
            { name = "Goldthorn", skill = 170 },
        },
        ores = {
            { name = "Iron", skill = 125 },
            { name = "Gold", skill = 155 },
            { name = "Mithril", skill = 175 },
        },
        skins = {
            { name = "Heavy Leather", skill = 150 },
            { name = "Thick Leather", skill = 200 },
        },
        fish = {
            { name = "Raw Bristle Whisker Catfish", skill = 100 },
            { name = "Raw Mithril Head Trout", skill = 175 },
        },
        fishing = 130,
        dungeons = {},
    },
    [2652] = { -- Shen'dralas
        name = "Shen'dralas",
        minLevel = 45,
        maxLevel = 55,
        herbs = {
            { name = "Purple Lotus", skill = 210 },
            { name = "Sungrass", skill = 230 },
            { name = "Ghost Mushroom", skill = 245 },
            { name = "Golden Sansam", skill = 260 },
            { name = "Dreamfoil", skill = 270 },
        },
        ores = {
            { name = "Mithril", skill = 175 },
            { name = "Truesilver", skill = 230 },
            { name = "Small Thorium", skill = 245 },
        },
        skins = {
            { name = "Thick Leather", skill = 200 },
            { name = "Rugged Leather", skill = 250 },
        },
        fish = {
            { name = "Raw Redgill", skill = 225 },
            { name = "Raw Nightfin Snapper", skill = 250 },
        },
        fishing = 205,
        dungeons = {},
    },
}

local zoneDataByName = {}
for mapID, data in pairs(zoneDataByUiMapID) do
    data.uiMapID = mapID
    zoneDataByName[data.name:lower()] = data
end

-- Additional name aliases (e.g. "Stormwind" -> "Stormwind City")
zoneDataByName["stormwind"] = zoneDataByUiMapID[1453]
zoneDataByName["the stockade"] = zoneDataByUiMapID[1453]
zoneDataByName["barrens"] = zoneDataByUiMapID[1413]
zoneDataByName["hinterlands"] = zoneDataByUiMapID[1425]
zoneDataByName["sunken temple"] = zoneDataByUiMapID[1435]

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
