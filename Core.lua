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
        width = 180,
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
    else
        print("|cff00ccff[OneWorldMap]|r Available commands:")
        print("  |cffffd100/owm reset|r — Reset map window position and scale")
        print("  |cffffd100/owm sidebar|r — Toggle left metadata sidebar")
        print("  |cffffd100/owm coords|r — Toggle live coordinates bar")
        print("  |cffffd100/owm doublewide|r — Toggle DoubleWide quest log")
        print("  |cffffd100/owm fade|r — Toggle movement fade")
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
