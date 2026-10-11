# Changelog — OneWorldMap

All notable changes to **OneWorldMap** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.0.1] - 2026-10-11
### Added
- **Initial Addon Scaffolding**: Setup `OneWorldMap.toc` with multi-client interface targets (16001, 11200, 20400, 30300, 110000) and `OneWorldMapDB` SavedVariables.
- **Hybrid Shell Frame Architecture (`Shell.lua`)**: Clean custom outer frame shell encapsulating `WorldMapFrame`, supporting dragging, window repositioning, and movement fade.
- **DoubleWide Quest Log (`DoubleWide.lua`)**: Dual-pane quest layout decoupling `QuestMapFrame.DetailsFrame` to sit side-by-side with `QuestMapFrame.QuestsFrame`, eliminating the need to click back and forth.
- **Left Zone Metadata Sidebar (`Sidebar.lua`)**: Collapsible side drawer displaying zone level ranges, Herbalism/Mining/Fishing gathering thresholds, and local dungeon brackets with a `[ < ]` / `[ > ]` toggle.
- **Throttled Coordinates Bar (`Coordinates.lua`)**: 10 Hz ticker bar showing `Player: XX.X, YY.Y | Cursor: XX.X, YY.Y` with canvas bounds validation and dungeon nil-guards.
- **Static Zone Database (`Data/ZoneData.lua`)**: Baseline database mapping `uiMapID` to level ranges, gathering thresholds, and dungeon recommendations.
- **Slash Command Handler (`Core.lua`)**: Registered `/oneworldmap`, `/owm`, `/onemap`, and `/om` commands with `/owm reset`, `/owm sidebar`, `/owm coords`, and `/owm fade`.

### Fixed
- **Coordinate Redundancy & Default Suppression (`Coordinates.lua`)**: Added deep recursive detection and suppression of default unstyled coordinates (stacked cursor/player readout at bottom-left), ensuring only the preferred high-contrast black background pill box is shown.
- **DoubleWide Quest Persistence (`DoubleWide.lua`)**: Intercepted `QuestMapFrame.QuestsFrame.ScrollFrame.Hide` (the actual container holding quest headers and titles) to ensure the quest list stays visible side-by-side with details.
- **Scrollbar Anchoring & Bounds (`DoubleWide.lua`)**: Explicitly anchored and constrained `QuestMapDetailsScrollFrame.ScrollBar` within `DetailsFrame` bounds (`-8, -48` and `-8, 28`), preventing the scrollbar from floating off the panel.
- **Engine-Accurate Column Sizing (`DoubleWide.lua`)**: Adjusted column widths to match the native XML geometry (330 px list column + 308 px detail column) with safe base width caching.
- **Quest List Scrollbar Separation (`DoubleWide.lua`)**: Constrained `QuestScrollFrame` with a 24 px right margin and explicitly anchored `QuestScrollFrame.ScrollBar` at `TOPRIGHT, questsFrame, -4, -31` and `BOTTOMRIGHT, questsFrame, -4, 4`, preventing any overlap with the Details pane.
- **Canvas Lock & Left Edge Anchor (`DoubleWide.lua`, `Shell.lua`)**: Locked `WorldMapFrame.ScrollContainer` to `TOPLEFT, WorldMapFrame, 4, -68` with a fixed width, and anchored `WorldMapFrame` to its `TOPLEFT` screen position so that expanding width only grows outward to the right, preventing the map canvas from shifting and eliminating wooden border gaps.
- **Tracking Cog Repositioning (`DoubleWide.lua`)**: Re-anchored `WorldMapFrame.WorldMapTrackingOptionsButton` ("Show Quest Objectives" cog) to `LEFT, WorldMapFrame.NavBar, RIGHT, 6, -1`, keeping it on the navigation header and preventing it from overlapping the quest counter.
- **Clean Quest List Collapse (`DoubleWide.lua`)**: Hooked `WorldMapFrame.SetQuestLogPanelShown` and `QuestMapFrame` visibility so that collapsing the quest list shrinks `WorldMapFrame` to align flush against the right edge of the map canvas without leaving a blank grey void.
- **Full-Height Quest Panels (`DoubleWide.lua`)**: Re-anchored `QuestMapFrame` from `y = -25` down to `y = 3`, eliminating the top gap and extending both Quest List and Quest Details fully from the top border to the bottom border.
- **Authentic Bronze Frame (`Sidebar.lua`)**: Replaced the grey metal dialog box border with the authentic Blizzard bronze `NineSlice` border (`Dialog` layout) with warm bronze tint and dark fill matching `WorldMapFrame`.
- **Interior Title (`Sidebar.lua`)**: Removed the protruding `UI-DialogBox-Header` ribbon plate; placed a clean `"Zone Details"` gold title inside the frame at the top above the content table.
- **290 px Panel Width & SavedVariables Migration (`Sidebar.lua`, `Core.lua`)**: Increased sidebar default width to 290 px (inner content width 244 px) and added automatic SavedVariables migration to prevent old 180 px settings from clipping content, ensuring all item names and values display in full without truncation.
- **Centered Profession Headers (`Sidebar.lua`)**: Centered profession names (`Herbalism`, `Mining`, `Skinning`, `Fishing`, `Dungeons`, `<Zone Name>`) inside the grey bevel buttons and removed `-`/`+` prefixes.
- **Gold Triangle Arrow Collapse Button (`Sidebar.lua`)**: Replaced the text button with a gold/yellow triangle arrow button at the inner bottom-left corner of the map canvas, pointing RIGHT (`>`) to collapse the drawer and pointing LEFT (`<`) to expand.
- **Fish Species Database (`Data/ZoneData.lua`, `Sidebar.lua`)**: Cataloged local fish species and skill requirements for all Classic zones.
- **Coordinates De-duplication (`Sidebar.lua`, `Coordinates.lua`)**: Kept coordinates exclusively in the high-contrast black pill box on the map canvas.
