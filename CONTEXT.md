# AI Context & Living Specification — OneWorldMap

---

## 🎯 Overview & Scope

- **Addon Name**: OneWorldMap
- **Current Version**: 0.0.1-dev
- **Suite**: Part of the **OneSuite** family
- **GitHub Repository**:
  - Exists: FALSE
  - URL: https://github.com/Nuros-WoW-Forever-Addons/OneWorldMap
  *(Initialize with Exists: FALSE until first commit/push)*
- **Branching Policy**: All new features must be developed on a branch != `main` (active branch: `dev`)
- **Live Sync Path**: `/Applications/World of Warcraft/_classic_beta_/Interface/AddOns/OneWorldMap/`
- **Rollback Target**: Initial repository scaffold commit
- **Release Package**: `.github/workflows/package.yml` generates `OneWorldMap-latest.zip` on push to `main`
- **Target WoW Runtimes**: WoW Forever Beta (v1.60.1 / Interface 16001), Vanilla 1.12 (`11200`), Turtle WoW 1.16, Modern Classic Engines
- **Primary Goal**: Deliver a modular, non-destructive **Hybrid Shell** replacement for the default WorldMap frame. Preserves native quest POI blobs, pin data providers, and third-party markers while expanding the UI with an external collapsible Left Zone Metadata Panel, persistent DoubleWide Quest Log side-by-side layout, Fog-of-War terrain reveal, and interior cave/dungeon reference tooling.

---

## 📐 Layout & Spatial Topology

The addon utilizes an expanded 4-column layout anchored around the untouched native map canvas. Panels expand outward without shrinking the main map viewport[span_10](start_span)[span_10](end_span)[span_11](start_span)[span_11](end_span):
Use provided DoubleQuestPaneRender.png as a layout reference view.  Replace Player Coordinates in that view with the OneMap version of Player Coordinates : Cursor Coordinates.

---

## 🏗️ Architecture & Component Map

### File Structure
- `OneWorldMap.toc`: Addon manifest, load order, SavedVariables declaration (`OneWorldMapDB`), optional dependencies (`OneSwatter`, `OnePanelUtils`).
- `Core.lua`: Addon initialization, lifecycle hooks (`PLAYER_LOGIN`, `ADDON_LOADED`), slash command dispatcher (`/oneworldmap`, `/owm`, `/onemap`, `/om`).
- `Shell.lua`: Outer frame manager. Detaches/hides Blizzard `BorderFrame` artwork, manages movable/resizable backdrop, handles movement fade, and restores saved window positioning.
- `DoubleWide.lua`: Quest frame layout engine. Decouples `QuestMapFrame.DetailsFrame` from overlapping `QuestMapFrame.QuestsFrame`, anchoring them side-by-side in persistent dual columns while hiding the redundant `< Back` button.
- `Sidebar.lua`: Left metadata drawer frame. Houses zone level brackets, gathering node thresholds, fishing requirements, and dungeon entrance listings with a bottom-left `[ < ]` toggle button.
- `MapReveal.lua`: Fog-of-War exploration provider using `MapCanvasDataProviderMixin` to draw desaturated, semi-transparent un-shrouded terrain tiles beneath quest objective blobs.
- `Pins.lua`: Navigation pins engine for Flight Masters (Horde, Alliance, Neutral) and dungeon entrance POIs with tooltip brackets.
- `Coordinates.lua`: Throttled 10 Hz ticker bar displaying live `Player: XX.X, YY.Y | Cursor: XX.X, YY.Y` with canvas bounds validation.
- `Interiors.lua`: Sub-zone and `areaID` heuristic detection for expansive caves/barrows, rendering a `[Cave/Dungeon Overlay]` toggle button for interior map switching.
- `Data/ZoneData.lua`: Static database table indexed by `uiMapID` containing level ranges, gathering minimums, fishing thresholds, and cave map definitions.

### Global State & Database Schema (`OneWorldMapDB`)
```lua
OneWorldMapDB = {
    profile = {
        window = {
            point = "CENTER",
            xOffset = 0,
            yOffset = 0,
            scale = 1.0,
            isLocked = false,
        },
        sidebar = {
            collapsed = false,
            width = 220,
        },
        questLog = {
            doubleWide = true,
            autoCollapseOnMapZoom = false,
        },
        ergonomics = {
            fadeOnMove = true,
            movingAlpha = 0.35,
            restoredAlpha = 1.0,
        },
        features = {
            revealFogOfWar = true,
            fogAlpha = 0.50,
            showCoordinates = true,
            showFlightMasters = true,
            showDungeonPins = true,
            detectCaves = true,
        },
    }
}
🔄 AI Development Cycle & Handoff Protocol
When picking up development on this addon:
Orientation: Read CONTEXT.md (this file) to verify current state, architectural layout, and active backlog items.
Implementation: Execute changes. For code refactoring or boilerplate, delegate to qwen2.5-coder:32b via the local gx10_ollama MCP server as mandated by user rules.
Verification: Verify in-game syntax and test using /om or /onemap commands. Ensure native Blizzard quest pins, POI blobs, and clicks do not throw Lua taints during combat transitions.
Handoff Update:
Move completed tasks from Upcoming Backlog to Recent Completed Work.
If user-facing features or commands changed, update README.md and append a new section in CHANGELOG.md.
Document newly discovered backlog items or engine edge cases in Upcoming Backlog.
✅ Recent Completed Work (Latest Spins)
Spin 0.0.1-dev (Scaffold & Core Map Functionality)
- Addon Structure: Created `OneWorldMap.toc`, `Core.lua`, and `Data/ZoneData.lua` baseline.
- Shell Frame & Positioning Engine (`Shell.lua`): Movable WorldMapFrame with position/scale persistence (`OneWorldMapDB.window`) and non-intrusive movement fade.
- DoubleWide Quest Log Module (`DoubleWide.lua`): Anchored `QuestMapFrame.DetailsFrame` side-by-side with `QuestMapFrame.QuestsFrame`, maintaining quest list visibility while reviewing details.
- Left Metadata Panel (`Sidebar.lua`): Collapsible left drawer showing zone level brackets, gathering node thresholds (Herbalism, Mining, Fishing), and dungeon brackets with a `[ < ]` / `[ > ]` toggle chevron.
- Dual Coordinate Bar (`Coordinates.lua`): 10 Hz throttled ticker on bottom canvas and sidebar with canvas bounds checking and dungeon nil-guards.
- DoubleWide Quest Log Symmetry & Gutter Refinements (`DoubleWide.lua`): Identical 330 px column widths, matching 22 px scrollbar gutters, pre-anchored combat-safe frames with zero taint delays.
- Fog-of-War Exploration Reveal (`MapReveal.lua`, `Data/FogDataForever.lua`, `Data/FogDataStandard.lua`): Unexplored map exploration reveal module for modern Retail/Classic engine (11.x, Interface 16001). Unexplored map terrain is displayed with configurable opacity (default 50% / `fogAlpha = 0.50`) beneath native pins and quest objective blobs, showing roads, topography, and boundaries seamlessly without combat taint. Includes full tile database coverage for all 45 Classic zones, custom WoW Forever zones (Zephras Isle, Riverglades, Mount Hyjal, Shen'dralas), and standard fallback maps.
- Graphical Options Panel (`OptionsUI.lua`): Standalone floating configuration panel (`/owm`, movable, ESC-closable) and Blizzard AddOns category (`Game Menu -> Options -> AddOns -> OneWorldMap`) with pop-out support, real-time checkboxes, steppers, presets, and live settings synchronization.
- Workspace Tooling: Registered `OneWorldMap` in `sync-live.sh` and `rollback-live.sh`.

📋 Living Roadmap & Upcoming Backlog (Next Spins)
Priority 1: High Priority (Immediate Next Spin)
[ ] Live in-game verification on WoW Forever Beta (Interface 16001).
[ ] Flight Master & Dungeon Pins (`Pins.lua`):
    Custom canvas pins for Flight Masters (Horde, Alliance, Neutral) and dungeon entrance POIs with tooltip brackets.
[ ] Cave & Barrow Detection (`Interiors.lua`):
    Subzone detection with `[Cave/Dungeon Overlay]` toggle button for interior maps.

Priority 2: Medium Priority (Core Additions & Integrations)
[ ] OneSwatter & OnePanel Integration:
    Hook into OneSwatter debug logging and expose settings tab inside OnePanel.
[ ] Custom Map Theme Styling:
    Dark slate / signature OneSuite border styling matching `DoubleQuestPaneRender.png`.

🧪 Testing & Verification Guide
Shell Movement: Drag the title bar to move the map. Reload UI (/reload) and verify the window restores to the exact saved coordinates.
DoubleWide Quest Selection: Open the map, click any quest in the list. Verify that the Quest List remains fully visible while Quest Details render immediately to its right. Confirm selecting another quest updates the details pane without list jumping.
Sidebar Collapse: Click the bottom-left [ < ] chevron button. Confirm the metadata panel slides/snaps closed and the outer window width recalculates smoothly without shifting canvas coordinates.
Movement Fade: Open map, start walking forward. Confirm map alpha dims to 0.35. Stop walking, confirm alpha smoothly returns to 1.0.
Combat Safety: Open map while entering combat. Confirm no Lua interface taints occur on secure action bars or quest tracker buttons.
⚠️ Technical Constraints & Engine Gotchas
Canvas Re-parenting vs. Wrapping: Do not unparent WorldMapFrame itself from UIParent, as this breaks Blizzard's core UIPanelTemplates and map event routing. Instead, hide WorldMapFrame.BorderFrame and let OneMapShell act as the visual container and positioning driver.
Instance Player Coordinates: C_Map.GetPlayerMapPosition returns nil inside instances. Coordinate tickers and pin overlays must include strict nil-guards (if not x then coordsText:SetText("Player: --, --") end) to prevent Lua errors when entering dungeons.
Hardware Action Restrictions: Clicking quest items directly inside the Details panel requires secure interaction templates; do not re-template or disrupt QuestMapFrame.DetailsFrame.RewardsFrame buttons.