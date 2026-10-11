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
