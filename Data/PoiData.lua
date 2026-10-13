-- OneWorldMap: Data/PoiData.lua
-- Comprehensive database of Point-of-Interest (POI) locations across Classic & WoW Forever:
-- Flight Masters, Quest Givers, Banks, Class & Profession Trainers, General Vendors, and Repair Vendors.

OneWorldMap = OneWorldMap or {}
OneWorldMap.PoiData = {}

-- POI Types:
-- "flight"        : Flight Master (Gryphon / Wyvern / Bat / Hippogryph)
-- "quest"         : Quest Giver (Yellow '!' or Low-level '!')
-- "bank"          : Bank vault / Banker
-- "trainerClass"  : Class Trainer (Warrior, Paladin, Hunter, Rogue, Priest, Shaman, Mage, Warlock, Druid)
-- "trainerProf"   : Profession Trainer (Alchemy, Blacksmithing, Engineering, Mining, Tailoring, etc.)
-- "vendor"        : General Merchant / Supplies (Bag icon)
-- "vendorRepair"  : Blacksmith / Armorer with Repair capability (Anvil icon)

local poiByMapID = {
    -- =========================================================================
    -- CAPITAL CITIES
    -- =========================================================================

    -- Stormwind City (1453)
    [1453] = {
        -- Flight Masters
        { type = "flight", x = 0.706, y = 0.733, name = "Dungar Longdrink", title = "Gryphon Master", faction = "Alliance" },

        -- Banks
        { type = "bank", x = 0.625, y = 0.722, name = "Stormwind Counting House", title = "Trade District Bank", faction = "Alliance" },
        { type = "bank", x = 0.635, y = 0.380, name = "Dwarven District Bank", title = "Dwarven District Bank", faction = "Alliance" },

        -- Quest Givers
        { type = "quest", x = 0.798, y = 0.382, name = "Highlord Bolvar Fordragon", title = "The Dragonkin Threat", level = 60, reqLevel = 54, faction = "Alliance" },
        { type = "quest", x = 0.665, y = 0.748, name = "General Marcus Jonathan", title = "The City Guard", level = 10, reqLevel = 5, faction = "Alliance" },
        { type = "quest", x = 0.765, y = 0.298, name = "Major Samuelson", title = "Stormwind Defense", level = 25, reqLevel = 18, faction = "Alliance" },
        { type = "quest", x = 0.395, y = 0.280, name = "Arthur the Faithful", title = "Tome of Divinity", level = 12, reqLevel = 10, faction = "Alliance" },
        { type = "quest", x = 0.522, y = 0.125, name = "Grimand Elmore", title = "Elmore's Task", level = 15, reqLevel = 10, faction = "Alliance" },
        { type = "quest", x = 0.552, y = 0.548, name = "Brother Kristoff", title = "Investigate the Echoes", level = 18, reqLevel = 14, faction = "Alliance" },
        { type = "quest", x = 0.405, y = 0.655, name = "Count Remington Ridgewell", title = "The Missing Diplomat", level = 32, reqLevel = 28, faction = "Alliance" },
        { type = "quest", x = 0.685, y = 0.812, name = "Daphne Stilwell", title = "Defending the Farm", level = 20, reqLevel = 15, faction = "Alliance" },
        { type = "quest", x = 0.392, y = 0.842, name = "Gakin the Darkbinder", title = "The Summoning", level = 20, reqLevel = 20, faction = "Alliance" },

        -- Class Trainers
        { type = "trainerClass", x = 0.785, y = 0.535, name = "Lyria Du Lac", title = "Warrior Trainer", sub = "Old Town" },
        { type = "trainerClass", x = 0.385, y = 0.265, name = "Lord Grayson Shadowbreaker", title = "Paladin Trainer", sub = "Cathedral of Light" },
        { type = "trainerClass", x = 0.615, y = 0.155, name = "Einris Brightspear", title = "Hunter Trainer", sub = "Dwarven District" },
        { type = "trainerClass", x = 0.755, y = 0.605, name = "Ian Drake", title = "Rogue Trainer", sub = "SI:7 Headquarters" },
        { type = "trainerClass", x = 0.388, y = 0.255, name = "High Priestess Laurena", title = "Priest Trainer", sub = "Cathedral of Light" },
        { type = "trainerClass", x = 0.495, y = 0.865, name = "Elissa Dumas", title = "Mage Trainer", sub = "Mage Sanctuary" },
        { type = "trainerClass", x = 0.395, y = 0.845, name = "Demisette Cloos", title = "Warlock Trainer", sub = "The Slaughtered Lamb" },

        -- Profession Trainers
        { type = "trainerProf", x = 0.555, y = 0.858, name = "Lilyna", title = "Alchemy Trainer", sub = "Mage Quarter" },
        { type = "trainerProf", x = 0.518, y = 0.125, name = "Therum Deepforge", title = "Blacksmithing Trainer", sub = "Dwarven District" },
        { type = "trainerProf", x = 0.530, y = 0.742, name = "Lucan Cordell", title = "Enchanting Trainer", sub = "Mage Quarter" },
        { type = "trainerProf", x = 0.548, y = 0.082, name = "Lilliam Sparkspindle", title = "Engineering Trainer", sub = "Dwarven District" },
        { type = "trainerProf", x = 0.550, y = 0.860, name = "Tannysa", title = "Herbalism Trainer", sub = "Mage Quarter" },
        { type = "trainerProf", x = 0.685, y = 0.445, name = "Simon Tanner", title = "Leatherworking Trainer", sub = "Old Town" },
        { type = "trainerProf", x = 0.535, y = 0.165, name = "Gelman Stonehand", title = "Mining Trainer", sub = "Dwarven District" },
        { type = "trainerProf", x = 0.682, y = 0.448, name = "Helene Peltskinner", title = "Skinning Trainer", sub = "Old Town" },
        { type = "trainerProf", x = 0.435, y = 0.745, name = "Georgio Bolero", title = "Tailoring Trainer", sub = "Mage Quarter" },
        { type = "trainerProf", x = 0.775, y = 0.535, name = "Stephen Ryback", title = "Cooking Trainer", sub = "Old Town" },
        { type = "trainerProf", x = 0.380, y = 0.285, name = "Shaina Fuller", title = "First Aid Trainer", sub = "Cathedral of Light" },
        { type = "trainerProf", x = 0.605, y = 0.685, name = "Arnold Leland", title = "Fishing Trainer", sub = "Canals" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.585, y = 0.575, name = "Corina Steele", title = "Weaponsmith & Repairs", sub = "Trade District" },
        { type = "vendorRepair", x = 0.550, y = 0.075, name = "Billibub Cogspinner", title = "Engineering & Repairs", sub = "Dwarven District" },
        { type = "vendorRepair", x = 0.615, y = 0.365, name = "Marda Weller", title = "Armorer & Repairs", sub = "Dwarven District" },
        { type = "vendorRepair", x = 0.795, y = 0.565, name = "Gunther Arcanus", title = "Weapons & Repairs", sub = "Old Town" },
        { type = "vendor", x = 0.655, y = 0.705, name = "Brog Hamfist", title = "General Goods", sub = "Trade District" },
        { type = "vendor", x = 0.540, y = 0.650, name = "Roberto Pudill", title = "Trade Supplies", sub = "Canals" },
        { type = "vendor", x = 0.415, y = 0.765, name = "Kylanna Windwhisper", title = "Herbal & Reagent Supplies", sub = "Mage Quarter" },
    },

    -- Ironforge (1455)
    [1455] = {
        -- Flight Masters
        { type = "flight", x = 0.555, y = 0.478, name = "Gryphon Master", title = "Gryphon Master", faction = "Alliance" },

        -- Banks
        { type = "bank", x = 0.395, y = 0.625, name = "Ironforge Bank", title = "The Commons Bank", faction = "Alliance" },

        -- Quest Givers
        { type = "quest", x = 0.405, y = 0.545, name = "King Magni Bronzebeard", title = "The High Seat", level = 60, reqLevel = 50, faction = "Alliance" },
        { type = "quest", x = 0.695, y = 0.495, name = "High Tinker Mekkatorque", title = "Gnomeregan Reclamation", level = 30, reqLevel = 25, faction = "Alliance" },
        { type = "quest", x = 0.765, y = 0.115, name = "Historian Karnik", title = "The Lost Tablets", level = 40, reqLevel = 35, faction = "Alliance" },
        { type = "quest", x = 0.395, y = 0.545, name = "Senator Mehr Stonehallow", title = "Dark Iron Threat", level = 22, reqLevel = 18, faction = "Alliance" },
        { type = "quest", x = 0.715, y = 0.135, name = "Prospector Stormpike", title = "Ironband's Excavation", level = 18, reqLevel = 12, faction = "Alliance" },

        -- Class Trainers
        { type = "trainerClass", x = 0.615, y = 0.895, name = "Kelstrun Stonebreaker", title = "Warrior Trainer", sub = "Hall of Arms" },
        { type = "trainerClass", x = 0.235, y = 0.085, name = "Brandur Ironhammer", title = "Paladin Trainer", sub = "High Seat" },
        { type = "trainerClass", x = 0.715, y = 0.875, name = "Daera Brightspear", title = "Hunter Trainer", sub = "Hall of Arms" },
        { type = "trainerClass", x = 0.515, y = 0.145, name = "Hulfdan Blackbeard", title = "Rogue Trainer", sub = "Forlorn Cavern" },
        { type = "trainerClass", x = 0.255, y = 0.085, name = "Tink Brightbolt", title = "Priest Trainer", sub = "Mystic Ward" },
        { type = "trainerClass", x = 0.265, y = 0.095, name = "Bink", title = "Mage Trainer", sub = "Mystic Ward" },
        { type = "trainerClass", x = 0.525, y = 0.125, name = "Alexander Calder", title = "Warlock Trainer", sub = "Forlorn Cavern" },

        -- Profession Trainers
        { type = "trainerProf", x = 0.665, y = 0.445, name = "Tanaika", title = "Alchemy Trainer", sub = "The Great Forge" },
        { type = "trainerProf", x = 0.495, y = 0.445, name = "Bengus Deepforge", title = "Blacksmithing Trainer", sub = "The Great Forge" },
        { type = "trainerProf", x = 0.605, y = 0.445, name = "Gimble Thistlefuzz", title = "Enchanting Trainer", sub = "The Great Forge" },
        { type = "trainerProf", x = 0.685, y = 0.435, name = "Springspindle Fizzlegear", title = "Engineering Trainer", sub = "The Great Forge" },
        { type = "trainerProf", x = 0.675, y = 0.455, name = "Reyna Stonebranch", title = "Herbalism Trainer", sub = "The Great Forge" },
        { type = "trainerProf", x = 0.395, y = 0.335, name = "Fimble Finespindle", title = "Leatherworking Trainer", sub = "The Great Forge" },
        { type = "trainerProf", x = 0.505, y = 0.265, name = "Geofram Bouldertoe", title = "Mining Trainer", sub = "The Great Forge" },
        { type = "trainerProf", x = 0.485, y = 0.065, name = "Grimnur Stonebrand", title = "Fishing Trainer", sub = "Forlorn Cavern" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.485, y = 0.425, name = "Brikk Keencraft", title = "Blacksmith & Repairs", sub = "The Great Forge" },
        { type = "vendorRepair", x = 0.415, y = 0.665, name = "Thurgrum Deepforge", title = "Armorer & Repairs", sub = "The Commons" },
        { type = "vendor", x = 0.355, y = 0.655, name = "Soolie Berryfizz", title = "General Goods", sub = "The Commons" },
        { type = "vendor", x = 0.285, y = 0.145, name = "Barim Jurgen", title = "Reagents & Alchemy Supplies", sub = "Mystic Ward" },
    },

    -- Orgrimmar (1454)
    [1454] = {
        -- Flight Masters
        { type = "flight", x = 0.452, y = 0.638, name = "Doras", title = "Wind Rider Master", faction = "Horde" },

        -- Banks
        { type = "bank", x = 0.505, y = 0.695, name = "Orgrimmar Bank", title = "Valley of Strength Bank", faction = "Horde" },
        { type = "bank", x = 0.695, y = 0.415, name = "Honor Bank", title = "Valley of Honor Bank", faction = "Horde" },

        -- Quest Givers
        { type = "quest", x = 0.392, y = 0.378, name = "Thrall", title = "Warchief of the Horde", level = 60, reqLevel = 50, faction = "Horde" },
        { type = "quest", x = 0.495, y = 0.685, name = "High Overlord Saurfang", title = "Defender of Orgrimmar", level = 60, reqLevel = 55, faction = "Horde" },
        { type = "quest", x = 0.795, y = 0.315, name = "Shenthul", title = "The Shattered Hand", level = 16, reqLevel = 10, faction = "Horde" },
        { type = "quest", x = 0.495, y = 0.505, name = "Neeru Fireblade", title = "Hidden Enemies", level = 15, reqLevel = 9, faction = "Horde" },
        { type = "quest", x = 0.555, y = 0.365, name = "Keldran", title = "Finding the Flaw", level = 18, reqLevel = 14, faction = "Horde" },
        { type = "quest", x = 0.582, y = 0.542, name = "Eitrigg", title = "Blackrock Spire Intel", level = 58, reqLevel = 55, faction = "Horde" },

        -- Class Trainers
        { type = "trainerClass", x = 0.785, y = 0.315, name = "Grezz Ragefist", title = "Warrior Trainer", sub = "Valley of Honor" },
        { type = "trainerClass", x = 0.685, y = 0.385, name = "Ormak Grimshot", title = "Hunter Trainer", sub = "Valley of Honor" },
        { type = "trainerClass", x = 0.435, y = 0.535, name = "Gest", title = "Rogue Trainer", sub = "Cleft of Shadow" },
        { type = "trainerClass", x = 0.355, y = 0.705, name = "Ur'kyo", title = "Priest Trainer", sub = "Valley of Spirits" },
        { type = "trainerClass", x = 0.385, y = 0.365, name = "Kardris Dreamseeker", title = "Shaman Trainer", sub = "Valley of Wisdom" },
        { type = "trainerClass", x = 0.375, y = 0.355, name = "Turak Runetotem", title = "Druid Trainer", sub = "Valley of Wisdom" },
        { type = "trainerClass", x = 0.405, y = 0.815, name = "Pephredo", title = "Mage Trainer", sub = "Valley of Spirits" },
        { type = "trainerClass", x = 0.465, y = 0.565, name = "Zevrost", title = "Warlock Trainer", sub = "Cleft of Shadow" },

        -- Profession Trainers
        { type = "trainerProf", x = 0.565, y = 0.335, name = "Yelmak", title = "Alchemy Trainer", sub = "The Drag" },
        { type = "trainerProf", x = 0.815, y = 0.345, name = "Saru Steelfury", title = "Blacksmithing Trainer", sub = "Valley of Honor" },
        { type = "trainerProf", x = 0.555, y = 0.565, name = "Godan", title = "Enchanting Trainer", sub = "The Drag" },
        { type = "trainerProf", x = 0.755, y = 0.255, name = "Nogg", title = "Engineering Trainer", sub = "Valley of Honor" },
        { type = "trainerProf", x = 0.555, y = 0.395, name = "Jandi", title = "Herbalism Trainer", sub = "The Drag" },
        { type = "trainerProf", x = 0.625, y = 0.455, name = "Karolek", title = "Leatherworking Trainer", sub = "The Drag" },
        { type = "trainerProf", x = 0.765, y = 0.365, name = "Makaru", title = "Mining Trainer", sub = "Valley of Honor" },
        { type = "trainerProf", x = 0.685, y = 0.415, name = "Lumbricker", title = "Fishing Trainer", sub = "Valley of Honor" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.795, y = 0.325, name = "Kiro", title = "Armorer & Repairs", sub = "Valley of Honor" },
        { type = "vendorRepair", x = 0.465, y = 0.785, name = "Sana", title = "Weaponsmith & Repairs", sub = "Valley of Strength" },
        { type = "vendor", x = 0.565, y = 0.665, name = "Gotus", title = "General Goods", sub = "Valley of Strength" },
        { type = "vendor", x = 0.545, y = 0.435, name = "Brakkar", title = "Trade Supplies", sub = "The Drag" },
    },

    -- Thunder Bluff (1456)
    [1456] = {
        -- Flight Masters
        { type = "flight", x = 0.470, y = 0.498, name = "Tal", title = "Wind Rider Master", faction = "Horde" },

        -- Banks
        { type = "bank", x = 0.465, y = 0.605, name = "Thunder Bluff Bank", title = "Lower Rise Bank", faction = "Horde" },

        -- Quest Givers
        { type = "quest", x = 0.605, y = 0.515, name = "Cairne Bloodhoof", title = "High Chieftain", level = 60, reqLevel = 50, faction = "Horde" },
        { type = "quest", x = 0.705, y = 0.315, name = "Magatha Grimtotem", title = "Elder of the Grimtotem", level = 35, reqLevel = 28, faction = "Horde" },
        { type = "quest", x = 0.455, y = 0.555, name = "Eyanna Proudstrider", title = "The Venture Co.", level = 18, reqLevel = 14, faction = "Horde" },

        -- Class Trainers
        { type = "trainerClass", x = 0.545, y = 0.285, name = "Karn Stonehoof", title = "Warrior Trainer", sub = "Lower Rise" },
        { type = "trainerClass", x = 0.585, y = 0.815, name = "Urek Thunderhorn", title = "Hunter Trainer", sub = "Hunter Rise" },
        { type = "trainerClass", x = 0.765, y = 0.305, name = "Beram Skychaser", title = "Shaman Trainer", sub = "Elder Rise" },
        { type = "trainerClass", x = 0.775, y = 0.285, name = "Turak Runetotem", title = "Druid Trainer", sub = "Elder Rise" },
        { type = "trainerClass", x = 0.235, y = 0.215, name = "Ursula Deline", title = "Mage Trainer", sub = "Pools of Vision" },

        -- Profession Trainers
        { type = "trainerProf", x = 0.405, y = 0.545, name = "Una", title = "Leatherworking Trainer", sub = "Central Rise" },
        { type = "trainerProf", x = 0.565, y = 0.335, name = "Karn Stonehoof", title = "Blacksmithing Trainer", sub = "Lower Rise" },
        { type = "trainerProf", x = 0.465, y = 0.335, name = "Brek Stonehoof", title = "Mining Trainer", sub = "Lower Rise" },
        { type = "trainerProf", x = 0.565, y = 0.475, name = "Kah Mistrunner", title = "Fishing Trainer", sub = "Central Rise" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.535, y = 0.365, name = "Moorat Longstrider", title = "Armorer & Repairs", sub = "Lower Rise" },
        { type = "vendor", x = 0.435, y = 0.595, name = "Vunna", title = "General Goods", sub = "Central Rise" },
    },

    -- Darnassus (1457)
    [1457] = {
        -- Flight Masters
        { type = "flight", x = 0.365, y = 0.495, name = "Vesprystus", title = "Hippogryph Master", faction = "Alliance" },

        -- Banks
        { type = "bank", x = 0.425, y = 0.425, name = "Bank of Darnassus", title = "Temple Gardens Bank", faction = "Alliance" },

        -- Quest Givers
        { type = "quest", x = 0.355, y = 0.085, name = "Archdruid Fandral Staghelm", title = "Archdruid of Darnassus", level = 60, reqLevel = 50, faction = "Alliance" },
        { type = "quest", x = 0.405, y = 0.795, name = "Tyrande Whisperwind", title = "High Priestess of Elune", level = 60, reqLevel = 50, faction = "Alliance" },
        { type = "quest", x = 0.635, y = 0.725, name = "Raedon Duskstrider", title = "Darnassus Sentinel", level = 15, reqLevel = 10, faction = "Alliance" },

        -- Class Trainers
        { type = "trainerClass", x = 0.625, y = 0.145, name = "Dazalar", title = "Warrior Trainer", sub = "Warrior's Terrace" },
        { type = "trainerClass", x = 0.605, y = 0.165, name = "Jocaste", title = "Hunter Trainer", sub = "Warrior's Terrace" },
        { type = "trainerClass", x = 0.355, y = 0.125, name = "Mathrengyl Bearwalker", title = "Druid Trainer", sub = "Cenarion Enclave" },
        { type = "trainerClass", x = 0.415, y = 0.835, name = "Astarii Starseeker", title = "Priest Trainer", sub = "Temple of the Moon" },
        { type = "trainerClass", x = 0.645, y = 0.225, name = "Syurna", title = "Rogue Trainer", sub = "Warrior's Terrace" },

        -- Profession Trainers
        { type = "trainerProf", x = 0.555, y = 0.525, name = "Ainethil", title = "Alchemy Trainer", sub = "Craftsmen's Terrace" },
        { type = "trainerProf", x = 0.525, y = 0.125, name = "Telonis", title = "Leatherworking Trainer", sub = "Craftsmen's Terrace" },
        { type = "trainerProf", x = 0.565, y = 0.605, name = "Astaia", title = "Fishing Trainer", sub = "Temple Gardens" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.615, y = 0.185, name = "Elynna", title = "Armorer & Repairs", sub = "Warrior's Terrace" },
        { type = "vendor", x = 0.585, y = 0.545, name = "Landria", title = "General Goods", sub = "Craftsmen's Terrace" },
    },

    -- Undercity (1458)
    [1458] = {
        -- Flight Masters
        { type = "flight", x = 0.635, y = 0.485, name = "Michael Garrett", title = "Bat Handler", faction = "Horde" },

        -- Banks
        { type = "bank", x = 0.665, y = 0.445, name = "Undercity Bank", title = "Central Ring Bank", faction = "Horde" },

        -- Quest Givers
        { type = "quest", x = 0.582, y = 0.925, name = "Lady Sylvanas Windrunner", title = "Banshee Queen", level = 60, reqLevel = 50, faction = "Horde" },
        { type = "quest", x = 0.565, y = 0.922, name = "Varimathras", title = "Dreadlord", level = 60, reqLevel = 55, faction = "Horde" },
        { type = "quest", x = 0.855, y = 0.155, name = "Bethor Iceshard", title = "The Scarlet Crusade", level = 30, reqLevel = 24, faction = "Horde" },

        -- Class Trainers
        { type = "trainerClass", x = 0.465, y = 0.285, name = "Christoph Walker", title = "Warrior Trainer", sub = "War Quarter" },
        { type = "trainerClass", x = 0.765, y = 0.745, name = "Miles Dexter", title = "Rogue Trainer", sub = "Rogues' Quarter" },
        { type = "trainerClass", x = 0.845, y = 0.165, name = "Pierce Shackleton", title = "Mage Trainer", sub = "Magic Quarter" },
        { type = "trainerClass", x = 0.865, y = 0.185, name = "Father Cobb", title = "Priest Trainer", sub = "Magic Quarter" },
        { type = "trainerClass", x = 0.835, y = 0.255, name = "Richard Kerwin", title = "Warlock Trainer", sub = "Magic Quarter" },

        -- Profession Trainers
        { type = "trainerProf", x = 0.555, y = 0.715, name = "Doctor Herbert Halsey", title = "Alchemy Trainer", sub = "The Apothecarium" },
        { type = "trainerProf", x = 0.695, y = 0.385, name = "James Van Brunt", title = "Blacksmithing Trainer", sub = "War Quarter" },
        { type = "trainerProf", x = 0.765, y = 0.365, name = "Brom Killian", title = "Mining Trainer", sub = "War Quarter" },
        { type = "trainerProf", x = 0.685, y = 0.415, name = "Armand Cromwell", title = "Fishing Trainer", sub = "Canals" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.615, y = 0.315, name = "Gordon Wendham", title = "Armorer & Repairs", sub = "War Quarter" },
        { type = "vendor", x = 0.635, y = 0.385, name = "Abigail Shiel", title = "General Goods", sub = "Trade Quarter" },
    },

    -- =========================================================================
    -- EASTERN KINGDOMS ZONES
    -- =========================================================================

    -- Elwynn Forest (1429)
    [1429] = {
        -- Flight Masters
        -- (Uses Stormwind Gates or local flight connections)

        -- Quest Givers
        { type = "quest", x = 0.425, y = 0.655, name = "Marshal Dughan", title = "The Fargodeep Mine", level = 7, reqLevel = 4, faction = "Alliance" },
        { type = "quest", x = 0.485, y = 0.415, name = "Marshal McBride", title = "A Threat Within", level = 1, reqLevel = 1, faction = "Alliance" },
        { type = "quest", x = 0.482, y = 0.428, name = "Deputy Willem", title = "Kobold Camp Cleanup", level = 3, reqLevel = 1, faction = "Alliance" },
        { type = "quest", x = 0.835, y = 0.665, name = "Supervisor Raelen", title = "A Bundle of Wood", level = 9, reqLevel = 5, faction = "Alliance" },
        { type = "quest", x = 0.345, y = 0.845, name = "Remen Brokk", title = "Protect the Frontier", level = 10, reqLevel = 6, faction = "Alliance" },

        -- Class Trainers
        { type = "trainerClass", x = 0.425, y = 0.672, name = "Lyria Du Lac", title = "Warrior Trainer", sub = "Goldshire" },
        { type = "trainerClass", x = 0.428, y = 0.668, name = "Brother Wilhelm", title = "Paladin Trainer", sub = "Goldshire" },
        { type = "trainerClass", x = 0.422, y = 0.662, name = "Keryn Sylvius", title = "Rogue Trainer", sub = "Goldshire" },
        { type = "trainerClass", x = 0.420, y = 0.658, name = "Priestess Josetta", title = "Priest Trainer", sub = "Goldshire" },
        { type = "trainerClass", x = 0.418, y = 0.655, name = "Zaldimar Wefhellt", title = "Mage Trainer", sub = "Goldshire" },
        { type = "trainerClass", x = 0.485, y = 0.418, name = "Brother Danil", title = "Paladin Trainer", sub = "Northshire" },

        -- Profession Trainers
        { type = "trainerProf", x = 0.425, y = 0.675, name = "Tomas", title = "Cooking Trainer", sub = "Goldshire" },
        { type = "trainerProf", x = 0.415, y = 0.665, name = "Lee Brown", title = "Fishing Trainer", sub = "Goldshire" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.435, y = 0.658, name = "Smith Argus", title = "Blacksmith & Repairs", sub = "Goldshire" },
        { type = "vendorRepair", x = 0.845, y = 0.665, name = "Terry Palin", title = "Bowyer & Repairs", sub = "Eastvale Logging Camp" },
        { type = "vendorRepair", x = 0.482, y = 0.415, name = "Brother Sammuel", title = "Armorer & Repairs", sub = "Northshire" },
        { type = "vendor", x = 0.415, y = 0.655, name = "Tharynn Bouden", title = "General Goods", sub = "Goldshire" },
        { type = "vendor", x = 0.480, y = 0.418, name = "Godric Rothgar", title = "General Goods", sub = "Northshire" },
    },

    -- Westfall (1436)
    [1436] = {
        -- Flight Masters
        { type = "flight", x = 0.565, y = 0.525, name = "Thor", title = "Gryphon Master", faction = "Alliance" },

        -- Quest Givers
        { type = "quest", x = 0.562, y = 0.475, name = "Gryan Stoutmantle", title = "The People's Militia", level = 14, reqLevel = 9, faction = "Alliance" },
        { type = "quest", x = 0.565, y = 0.472, name = "Captain Danuvin", title = "Patrolling Westfall", level = 15, reqLevel = 10, faction = "Alliance" },
        { type = "quest", x = 0.560, y = 0.315, name = "Farmer Saldean", title = "The Killing Fields", level = 12, reqLevel = 8, faction = "Alliance" },
        { type = "quest", x = 0.425, y = 0.675, name = "Defias Informant", title = "The Defias Brotherhood", level = 18, reqLevel = 14, faction = "Alliance" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.565, y = 0.478, name = "William MacGregor", title = "Bowyer & Repairs", sub = "Sentinel Hill" },
        { type = "vendor", x = 0.562, y = 0.485, name = "Gina MacGregor", title = "General Supplies", sub = "Sentinel Hill" },
    },

    -- Redridge Mountains (1433)
    [1433] = {
        -- Flight Masters
        { type = "flight", x = 0.305, y = 0.595, name = "Ariena Stormfeather", title = "Gryphon Master", faction = "Alliance" },

        -- Quest Givers
        { type = "quest", x = 0.295, y = 0.445, name = "Magistrate Solomon", title = "Encroaching Gnolls", level = 18, reqLevel = 14, faction = "Alliance" },
        { type = "quest", x = 0.325, y = 0.485, name = "Deputy Feldon", title = "Redridge Goulash", level = 16, reqLevel = 12, faction = "Alliance" },
        { type = "quest", x = 0.335, y = 0.535, name = "Bailor Stonehand", title = "Underbelly Scales", level = 20, reqLevel = 15, faction = "Alliance" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.285, y = 0.415, name = "Zaldon Tenter", title = "Weaponsmith & Repairs", sub = "Lakeshire" },
        { type = "vendor", x = 0.315, y = 0.465, name = "Barkeep Durnan", title = "Innkeeper & Food", sub = "Lakeshire" },
    },

    -- Duskwood (1431)
    [1431] = {
        -- Flight Masters
        { type = "flight", x = 0.775, y = 0.445, name = "Felicia Maline", title = "Gryphon Master", faction = "Alliance" },

        -- Quest Givers
        { type = "quest", x = 0.735, y = 0.445, name = "Mayor Ello Ebonlocke", title = "The Hermit", level = 20, reqLevel = 15, faction = "Alliance" },
        { type = "quest", x = 0.738, y = 0.435, name = "Commander Althea Ebonlocke", title = "Night Watch", level = 22, reqLevel = 18, faction = "Alliance" },
        { type = "quest", x = 0.725, y = 0.465, name = "Madame Eva", title = "The Legend of Stalvan", level = 28, reqLevel = 22, faction = "Alliance" },
        { type = "quest", x = 0.285, y = 0.315, name = "Abercrombie", title = "The Hermit's Task", level = 25, reqLevel = 20, faction = "Alliance" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.745, y = 0.485, name = "Viktori Prasun", title = "Armorer & Repairs", sub = "Darkshire" },
        { type = "vendor", x = 0.735, y = 0.455, name = "Mabel Solaj", title = "General Goods", sub = "Darkshire" },
    },

    -- Loch Modan (1432)
    [1432] = {
        -- Flight Masters
        { type = "flight", x = 0.338, y = 0.508, name = "Thorgrum Borrelson", title = "Gryphon Master", faction = "Alliance" },

        -- Quest Givers
        { type = "quest", x = 0.345, y = 0.475, name = "Mountaineer Stormpike", title = "The Trogg Threat", level = 14, reqLevel = 10, faction = "Alliance" },
        { type = "quest", x = 0.355, y = 0.485, name = "Brock Stoneseeker", title = "Excavation Progress", level = 16, reqLevel = 12, faction = "Alliance" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.348, y = 0.495, name = "Moran Bronzeplow", title = "Blacksmith & Repairs", sub = "Thelsamar" },
        { type = "vendor", x = 0.342, y = 0.465, name = "Yarr Hammerstone", title = "General Goods", sub = "Thelsamar" },
    },

    -- Dun Morogh (1426)
    [1426] = {
        -- Quest Givers
        { type = "quest", x = 0.465, y = 0.535, name = "Senator Barin Redstone", title = "A Refugee's Quandary", level = 6, reqLevel = 3, faction = "Alliance" },
        { type = "quest", x = 0.285, y = 0.755, name = "Jorik Kerridan", title = "Dwarven Outpost", level = 1, reqLevel = 1, faction = "Alliance" },
        { type = "quest", x = 0.695, y = 0.565, name = "Senir Whitebeard", title = "The Lost Pilot", level = 10, reqLevel = 6, faction = "Alliance" },

        -- Class Trainers
        { type = "trainerClass", x = 0.465, y = 0.525, name = "Thorgas Grimson", title = "Warrior Trainer", sub = "Kharanos" },
        { type = "trainerClass", x = 0.468, y = 0.528, name = "Bromos Grummner", title = "Paladin Trainer", sub = "Kharanos" },
        { type = "trainerClass", x = 0.472, y = 0.532, name = "Grif Wildheart", title = "Hunter Trainer", sub = "Kharanos" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.455, y = 0.525, name = "Frann Roag", title = "Blacksmith & Repairs", sub = "Kharanos" },
        { type = "vendor", x = 0.462, y = 0.515, name = "Tharek Blackstone", title = "General Goods", sub = "Kharanos" },
    },

    -- Wetlands (1437)
    [1437] = {
        -- Flight Masters
        { type = "flight", x = 0.095, y = 0.595, name = "Shellei Brondir", title = "Gryphon Master", faction = "Alliance" },

        -- Quest Givers
        { type = "quest", x = 0.105, y = 0.605, name = "Captain Stoutfist", title = "Defending Menethil", level = 22, reqLevel = 18, faction = "Alliance" },
        { type = "quest", x = 0.115, y = 0.585, name = "Vincent Hyal", title = "The Greenwarden", level = 25, reqLevel = 20, faction = "Alliance" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.102, y = 0.575, name = "Brak Durnad", title = "Armorer & Repairs", sub = "Menethil Harbor" },
        { type = "vendor", x = 0.092, y = 0.612, name = "Krazek", title = "General Merchant", sub = "Menethil Harbor" },
    },

    -- Hillsbrad Foothills (1424)
    [1424] = {
        -- Flight Masters
        { type = "flight", x = 0.495, y = 0.525, name = "Darla Harris", title = "Gryphon Master", faction = "Alliance" },
        { type = "flight", x = 0.602, y = 0.185, name = "Zarise", title = "Bat Handler", faction = "Horde" },

        -- Quest Givers
        { type = "quest", x = 0.498, y = 0.545, name = "Magistrate Burnside", title = "The Syndicate Menace", level = 26, reqLevel = 22, faction = "Alliance" },
        { type = "quest", x = 0.615, y = 0.205, name = "High Executor Darthalia", title = "Battle of Hillsbrad", level = 28, reqLevel = 22, faction = "Horde" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.505, y = 0.515, name = "Craig Nollan", title = "Armorer & Repairs", sub = "Southshore" },
        { type = "vendorRepair", x = 0.605, y = 0.195, name = "Ott", title = "Blacksmith & Repairs", sub = "Tarren Mill" },
        { type = "vendor", x = 0.492, y = 0.535, name = "Lindea Rabonne", title = "General Goods", sub = "Southshore" },
    },

    -- Stranglethorn Vale (1434)
    [1434] = {
        -- Flight Masters
        { type = "flight", x = 0.275, y = 0.778, name = "Gorkas", title = "Wind Rider Master", faction = "Horde" },
        { type = "flight", x = 0.272, y = 0.772, name = "Grent Amaranth", title = "Gryphon Master", faction = "Alliance" },
        { type = "flight", x = 0.375, y = 0.035, name = "Narianna", title = "Gryphon Master", faction = "Alliance" },
        { type = "flight", x = 0.325, y = 0.295, name = "Thorkaf Dragoneye", title = "Wind Rider Master", faction = "Horde" },

        -- Banks
        { type = "bank", x = 0.275, y = 0.772, name = "Booty Bay Bank", title = "Steamwheedle Bank", faction = "Neutral" },

        -- Quest Givers
        { type = "quest", x = 0.272, y = 0.768, name = "Baron Revilgaz", title = "The Bloodsail Buccaneers", level = 40, reqLevel = 35, faction = "Neutral" },
        { type = "quest", x = 0.355, y = 0.105, name = "Hemet Nesingwary Jr.", title = "Master of the Hunt", level = 33, reqLevel = 28, faction = "Neutral" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.285, y = 0.765, name = "Vharr", title = "Armorer & Repairs", sub = "Booty Bay" },
        { type = "vendor", x = 0.275, y = 0.785, name = "Crank Fizzlebub", title = "General Supplies", sub = "Booty Bay" },
    },

    -- =========================================================================
    -- KALIMDOR ZONES
    -- =========================================================================

    -- Durotar (1411)
    [1411] = {
        -- Quest Givers
        { type = "quest", x = 0.525, y = 0.435, name = "Gar'Thok", title = "Break a Few Eggs", level = 8, reqLevel = 5, faction = "Horde" },
        { type = "quest", x = 0.445, y = 0.685, name = "Kaltunk", title = "Your Place in the World", level = 1, reqLevel = 1, faction = "Horde" },
        { type = "quest", x = 0.565, y = 0.745, name = "Master Gadrin", title = "Zalazane", level = 10, reqLevel = 7, faction = "Horde" },

        -- Class Trainers
        { type = "trainerClass", x = 0.528, y = 0.428, name = "Tarshaw Jaggedscar", title = "Warrior Trainer", sub = "Razor Hill" },
        { type = "trainerClass", x = 0.532, y = 0.432, name = "Thorg'izun", title = "Hunter Trainer", sub = "Razor Hill" },
        { type = "trainerClass", x = 0.522, y = 0.422, name = "Kaplak", title = "Rogue Trainer", sub = "Razor Hill" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.522, y = 0.445, name = "Barl", title = "Blacksmith & Repairs", sub = "Razor Hill" },
        { type = "vendor", x = 0.530, y = 0.438, name = "Ghrawt", title = "General Goods", sub = "Razor Hill" },
    },

    -- The Barrens (1413)
    [1413] = {
        -- Flight Masters
        { type = "flight", x = 0.515, y = 0.305, name = "Devrak", title = "Wind Rider Master", faction = "Horde" },
        { type = "flight", x = 0.445, y = 0.592, name = "Omusa Thunderhorn", title = "Wind Rider Master", faction = "Horde" },
        { type = "flight", x = 0.632, y = 0.372, name = "Bragok", title = "Wind Rider Master", faction = "Neutral" },

        -- Banks
        { type = "bank", x = 0.625, y = 0.365, name = "Ratchet Bank", title = "Steamwheedle Bank", faction = "Neutral" },

        -- Quest Givers
        { type = "quest", x = 0.522, y = 0.298, name = "Sergra Darkthorn", title = "The Plainstrider Menace", level = 12, reqLevel = 8, faction = "Horde" },
        { type = "quest", x = 0.525, y = 0.315, name = "Mankrik", title = "Lost in Battle", level = 18, reqLevel = 14, faction = "Horde" },
        { type = "quest", x = 0.625, y = 0.375, name = "Gazlowe", title = "Southsea Freebooters", level = 15, reqLevel = 10, faction = "Neutral" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.518, y = 0.295, name = "Arak", title = "Armorer & Repairs", sub = "The Crossroads" },
        { type = "vendorRepair", x = 0.628, y = 0.368, name = "Mahu", title = "Engineer & Repairs", sub = "Ratchet" },
        { type = "vendor", x = 0.512, y = 0.308, name = "Kinar", title = "General Supplies", sub = "The Crossroads" },
    },

    -- Mulgore (1412)
    [1412] = {
        -- Quest Givers
        { type = "quest", x = 0.475, y = 0.605, name = "Baine Bloodhoof", title = "The Ravaged Caravan", level = 8, reqLevel = 4, faction = "Horde" },
        { type = "quest", x = 0.445, y = 0.765, name = "Chief Hawkwind", title = "The Hunt Begins", level = 1, reqLevel = 1, faction = "Horde" },

        -- Class Trainers
        { type = "trainerClass", x = 0.472, y = 0.612, name = "Krang Stonehoof", title = "Warrior Trainer", sub = "Bloodhoof Village" },
        { type = "trainerClass", x = 0.478, y = 0.615, name = "Yaw Sharpmane", title = "Hunter Trainer", sub = "Bloodhoof Village" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.475, y = 0.595, name = "Genn", title = "Armorer & Repairs", sub = "Bloodhoof Village" },
        { type = "vendor", x = 0.468, y = 0.602, name = "Harant", title = "General Goods", sub = "Bloodhoof Village" },
    },

    -- Ashenvale (1440)
    [1440] = {
        -- Flight Masters
        { type = "flight", x = 0.345, y = 0.485, name = "Daelyshia", title = "Hippogryph Master", faction = "Alliance" },
        { type = "flight", x = 0.732, y = 0.655, name = "Vhul", title = "Wind Rider Master", faction = "Horde" },

        -- Quest Givers
        { type = "quest", x = 0.365, y = 0.495, name = "Raene Wolfrunner", title = "Raene's Cleansing", level = 25, reqLevel = 20, faction = "Alliance" },
        { type = "quest", x = 0.735, y = 0.645, name = "Mastok Wrilehiss", title = "Warsong Supplies", level = 27, reqLevel = 22, faction = "Horde" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.355, y = 0.515, name = "Maldan", title = "Armorer & Repairs", sub = "Astranaar" },
        { type = "vendorRepair", x = 0.725, y = 0.642, name = "Gharash", title = "Armorer & Repairs", sub = "Splintertree Post" },
    },

    -- Tanaris (1446)
    [1446] = {
        -- Flight Masters
        { type = "flight", x = 0.512, y = 0.275, name = "Bera Stonehammer", title = "Gryphon Master", faction = "Alliance" },
        { type = "flight", x = 0.515, y = 0.285, name = "Bulkrek Ragefist", title = "Wind Rider Master", faction = "Horde" },

        -- Banks
        { type = "bank", x = 0.515, y = 0.265, name = "Gadgetzan Bank", title = "Steamwheedle Bank", faction = "Neutral" },

        -- Quest Givers
        { type = "quest", x = 0.525, y = 0.278, name = "Chief Engineer Bilgewhizzle", title = "WANTED: Caliph Scorpidsting", level = 46, reqLevel = 40, faction = "Neutral" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.522, y = 0.285, name = "Krinkle Goodsteel", title = "Blacksmith & Repairs", sub = "Gadgetzan" },
        { type = "vendor", x = 0.518, y = 0.268, name = "Bliztik", title = "General Supplies", sub = "Gadgetzan" },
    },

    -- =========================================================================
    -- WOW FOREVER CUSTOM ZONES
    -- =========================================================================

    -- Zephras Isle (2521)
    [2521] = {
        -- Flight Masters
        { type = "flight", x = 0.525, y = 0.485, name = "Aeris Windrunner", title = "Skyborne Flight Master", faction = "Alliance" },

        -- Quest Givers
        { type = "quest", x = 0.515, y = 0.475, name = "High Windseer Zephra", title = "The Breath of Life", level = 3, reqLevel = 1, faction = "Alliance" },
        { type = "quest", x = 0.535, y = 0.515, name = "Cloudstrider Kael", title = "Calming the Zephyrs", level = 6, reqLevel = 3, faction = "Alliance" },

        -- Class & Profession Trainers
        { type = "trainerClass", x = 0.510, y = 0.490, name = "Zephras Champion", title = "Skyborne Class Trainer", sub = "Skyborne Sanctuary" },
        { type = "trainerProf", x = 0.540, y = 0.480, name = "Aero Craftsman", title = "Skyborne Artisan", sub = "Skyborne Sanctuary" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.518, y = 0.482, name = "Skyforge Smith", title = "Smith & Repairs", sub = "Skyborne Sanctuary" },
        { type = "vendor", x = 0.522, y = 0.478, name = "Cloud Goods", title = "General Supplies", sub = "Skyborne Sanctuary" },
    },

    -- Riverglades (2548)
    [2548] = {
        -- Flight Masters
        { type = "flight", x = 0.465, y = 0.525, name = "Riverwatch Postmaster", title = "River Flight Master", faction = "Neutral" },

        -- Quest Givers
        { type = "quest", x = 0.455, y = 0.515, name = "Commander Riverwatch", title = "Securing the Crossing", level = 34, reqLevel = 30, faction = "Neutral" },
        { type = "quest", x = 0.475, y = 0.535, name = "Scout Krol'dok", title = "Threat of the Stronghold", level = 40, reqLevel = 38, faction = "Neutral" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.460, y = 0.520, name = "Riverwatch Smith", title = "Smith & Repairs", sub = "Riverwatch Outpost" },
        { type = "vendor", x = 0.468, y = 0.530, name = "River Outfitter", title = "General Goods", sub = "Riverwatch Outpost" },
    },

    -- Mount Hyjal (2482)
    [2482] = {
        -- Flight Masters
        { type = "flight", x = 0.585, y = 0.265, name = "Nordrassil Flight Master", title = "Hyjal Hippogryph Master", faction = "Neutral" },

        -- Quest Givers
        { type = "quest", x = 0.575, y = 0.255, name = "Keeper of the Grove", title = "Roots of the World Tree", level = 60, reqLevel = 58, faction = "Neutral" },
        { type = "quest", x = 0.595, y = 0.275, name = "Archdruid of the Claw", title = "Awakening Barrow Deeps", level = 60, reqLevel = 60, faction = "Neutral" },

        -- Vendors & Repair
        { type = "vendorRepair", x = 0.580, y = 0.260, name = "Nordrassil Armorer", title = "Armorer & Repairs", sub = "Nordrassil Encampment" },
        { type = "vendor", x = 0.588, y = 0.270, name = "Cenarion Provisioner", title = "General Supplies", sub = "Nordrassil Encampment" },
    },
}

OneWorldMap.PoiData.byMapID = poiByMapID

function OneWorldMap:GetPoisForMap(uiMapID)
    if not uiMapID then return nil end
    return poiByMapID[uiMapID]
end
