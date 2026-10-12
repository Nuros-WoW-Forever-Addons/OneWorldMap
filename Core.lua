-- OneWorldMap: Core.lua
-- Addon lifecycle, database management, module loader, and slash commands.

OneWorldMap = OneWorldMap or {}

local defaults = {
    window = {
        point = "CENTER",
        xOffset = 0,
        yOffset = 0,
        scale = 1.0,
        isLocked = false,
    },
    sidebar = {
        collapsed = false,
        width = 290,
        collapsedHeaders = {},
    },
    questLog = {
        doubleWide = true,
    },
    ergonomics = {
        fadeOnMove = true,
        movingAlpha = 0.35,
        restoredAlpha = 1.0,
    },
    features = {
        showCoordinates = true,
        showFlightMasters = true,
        revealFogOfWar = true,
        fogAlpha = 0.65,
        fogColor = { r = 0.38, g = 0.38, b = 0.45 },
    },
}

OneWorldMap.modules = {}

function OneWorldMap:RegisterModule(name, initFunc)
    table.insert(self.modules, { name = name, init = initFunc })
end

local function InitializeDB()
    if not OneWorldMapDB then
        OneWorldMapDB = CopyTable(defaults)
    else
        for k, v in pairs(defaults) do
            if type(v) == "table" then
                OneWorldMapDB[k] = OneWorldMapDB[k] or {}
                for subk, subv in pairs(v) do
                    if OneWorldMapDB[k][subk] == nil then
                        OneWorldMapDB[k][subk] = subv
                    end
                end
            else
                if OneWorldMapDB[k] == nil then
                    OneWorldMapDB[k] = v
                end
            end
        end
    end
    if OneWorldMapDB and OneWorldMapDB.sidebar then
        if not OneWorldMapDB.sidebar.width or OneWorldMapDB.sidebar.width < 290 then
            OneWorldMapDB.sidebar.width = 290
        end
    end
    if OneWorldMapDB and OneWorldMapDB.features then
        if not OneWorldMapDB.features.fogColor or (OneWorldMapDB.features.fogColor.r == 1 and OneWorldMapDB.features.fogColor.g == 1 and OneWorldMapDB.features.fogColor.b == 1) then
            OneWorldMapDB.features.fogColor = { r = 0.38, g = 0.38, b = 0.45 }
        end
        if OneWorldMapDB.features.fogAlpha == 0.50 then
            OneWorldMapDB.features.fogAlpha = 0.65
        end
    end
    OneWorldMap.db = OneWorldMapDB
end

function OneWorldMap:Log(msg)
    local prefix = "|cff00ccff[OneWorldMap]|r "
    print(prefix .. tostring(msg))
    if _G.OneSwatter and _G.OneSwatter.LogDebug then
        _G.OneSwatter:LogDebug("OneWorldMap", tostring(msg))
    end
end

local function OnEvent(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "OneWorldMap" then
        InitializeDB()
        OneWorldMap:Log("v0.0.1 loaded. Type /owm for commands.")
    elseif event == "PLAYER_LOGIN" then
        for _, mod in ipairs(OneWorldMap.modules) do
            if type(mod.init) == "function" then
                local success, err = pcall(mod.init, OneWorldMap)
                if not success then
                    OneWorldMap:Log("Error initializing module " .. mod.name .. ": " .. tostring(err))
                end
            end
        end
    end
end

local function SlashCommandHandler(msg)
    msg = msg and msg:trim() or ""
    local cmd, arg = msg:match("^(%S*)%s*(.-)$")
    cmd = cmd and cmd:lower() or ""

    if cmd == "reset" then
        OneWorldMapDB.window.point = defaults.window.point
        OneWorldMapDB.window.xOffset = defaults.window.xOffset
        OneWorldMapDB.window.yOffset = defaults.window.yOffset
        OneWorldMapDB.window.scale = defaults.window.scale
        if OneWorldMap.Shell and OneWorldMap.Shell.ResetPosition then
            OneWorldMap.Shell:ResetPosition()
        end
        OneWorldMap:Log("Window position and scale reset to default.")
    elseif cmd == "sidebar" then
        OneWorldMapDB.sidebar.collapsed = not OneWorldMapDB.sidebar.collapsed
        if OneWorldMap.Sidebar and OneWorldMap.Sidebar.UpdateState then
            OneWorldMap.Sidebar:UpdateState()
        end
        OneWorldMap:Log("Sidebar collapsed: " .. tostring(OneWorldMapDB.sidebar.collapsed))
    elseif cmd == "coords" then
        OneWorldMapDB.features.showCoordinates = not OneWorldMapDB.features.showCoordinates
        if OneWorldMap.Coordinates and OneWorldMap.Coordinates.UpdateVisibility then
            OneWorldMap.Coordinates:UpdateVisibility()
        end
        OneWorldMap:Log("Coordinates display: " .. tostring(OneWorldMapDB.features.showCoordinates))
    elseif cmd == "doublewide" then
        OneWorldMapDB.questLog.doubleWide = not OneWorldMapDB.questLog.doubleWide
        if OneWorldMap.DoubleWide and OneWorldMap.DoubleWide.RefreshLayout then
            OneWorldMap.DoubleWide:RefreshLayout()
        end
        OneWorldMap:Log("DoubleWide Quest Log: " .. tostring(OneWorldMapDB.questLog.doubleWide))
    elseif cmd == "fade" then
        OneWorldMapDB.ergonomics.fadeOnMove = not OneWorldMapDB.ergonomics.fadeOnMove
        OneWorldMap:Log("Movement fade: " .. tostring(OneWorldMapDB.ergonomics.fadeOnMove))
    elseif cmd == "fog" then
        if OneWorldMap.MapReveal and OneWorldMap.MapReveal.Toggle then
            local state = OneWorldMap.MapReveal:Toggle()
            OneWorldMap:Log("Fog-of-War reveal: " .. tostring(state))
        else
            OneWorldMapDB.features.revealFogOfWar = not OneWorldMapDB.features.revealFogOfWar
            OneWorldMap:Log("Fog-of-War reveal: " .. tostring(OneWorldMapDB.features.revealFogOfWar))
        end
    elseif cmd == "fogalpha" then
        local alpha = tonumber(arg)
        if alpha and OneWorldMap.MapReveal and OneWorldMap.MapReveal.SetAlpha then
            OneWorldMap.MapReveal:SetAlpha(alpha)
            OneWorldMap:Log("Fog-of-War alpha set to: " .. tostring(OneWorldMapDB.features.fogAlpha))
        else
            OneWorldMap:Log("Current Fog-of-War alpha: " .. tostring(OneWorldMapDB.features.fogAlpha or 0.65) .. " (Usage: /owm fogalpha 0.1-1.0)")
        end
    elseif cmd == "fogpreset" then
        local preset = arg and arg:trim()
        if preset and preset ~= "" and OneWorldMap.MapReveal and OneWorldMap.MapReveal.SetPreset then
            local ok = OneWorldMap.MapReveal:SetPreset(preset)
            if ok then
                OneWorldMap:Log("Fog-of-War preset applied: " .. preset)
            else
                OneWorldMap:Log("Unknown preset '" .. preset .. "'. Available: charcoal, dark, blue, sepia, light")
            end
        else
            OneWorldMap:Log("Available Fog presets: charcoal, dark, blue, sepia, light (Usage: /owm fogpreset <name>)")
        end
    elseif cmd == "fogcolor" then
        local r, g, b = arg:match("^(%S+)%s+(%S+)%s+(%S+)$")
        r, g, b = tonumber(r), tonumber(g), tonumber(b)
        if r and g and b and OneWorldMap.MapReveal and OneWorldMap.MapReveal.SetColor then
            OneWorldMap.MapReveal:SetColor(r, g, b)
            OneWorldMap:Log(string.format("Fog-of-War color set to: %.2f, %.2f, %.2f", r, g, b))
        else
            local fc = OneWorldMapDB.features.fogColor or { r = 0.38, g = 0.38, b = 0.45 }
            OneWorldMap:Log(string.format("Current Fog color: %.2f, %.2f, %.2f (Usage: /owm fogcolor r g b, 0.0-1.0)", fc.r, fc.g, fc.b))
        end
    else
        print("|cff00ccff[OneWorldMap]|r Available commands:")
        print("  |cffffd100/owm reset|r — Reset map window position and scale")
        print("  |cffffd100/owm sidebar|r — Toggle left metadata sidebar")
        print("  |cffffd100/owm coords|r — Toggle live coordinates bar")
        print("  |cffffd100/owm doublewide|r — Toggle DoubleWide quest log")
        print("  |cffffd100/owm fade|r — Toggle movement fade")
        print("  |cffffd100/owm fog|r — Toggle Fog-of-War exploration reveal")
        print("  |cffffd100/owm fogalpha <0.1-1.0>|r — Adjust Fog-of-War opacity")
        print("  |cffffd100/owm fogpreset <name>|r — Apply fog tint preset (charcoal, dark, blue, sepia, light)")
        print("  |cffffd100/owm fogcolor <r g b>|r — Custom fog tint RGB (0.0 - 1.0)")
    end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", OnEvent)

SLASH_ONEWORLDMAP1 = "/oneworldmap"
SLASH_ONEWORLDMAP2 = "/owm"
SLASH_ONEWORLDMAP3 = "/onemap"
SLASH_ONEWORLDMAP4 = "/om"
SlashCmdList["ONEWORLDMAP"] = SlashCommandHandler
