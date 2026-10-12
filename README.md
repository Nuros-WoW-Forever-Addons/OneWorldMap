# OneWorldMap

**OneWorldMap** is a modular, non-destructive hybrid shell replacement for the World of Warcraft World Map frame. It expands the interface with a collapsible Left Zone Metadata drawer, a persistent side-by-side DoubleWide Quest Log, a real-time Player and Cursor coordinates bar, and window ergonomics—all while preserving Blizzard's native quest POI blobs, pin providers, and third-party map blips.

Part of the **OneSuite** family of addons.

---

## 🚀 Features

- 📜 **DoubleWide Quest Log**: Decouples quest details from overlapping the quest list. Select any quest and review objectives, descriptions, and rewards immediately to the right while maintaining the full quest index visible.
- 🗺️ **Collapsible Zone Metadata Drawer**: Anchored to the left edge of the map frame. Automatically surfaces current zone level brackets, gathering node requirements (Herbalism, Mining, Fishing), and local dungeon level ranges, with a quick `[ < ]` toggle button.
- 📍 **Dual Real-Time Coordinates**: High-efficiency 10 Hz throttled ticker displaying `Player: XX.X, YY.Y | Cursor: XX.X, YY.Y` with canvas bounds safety and instance protection.
- 🪟 **Movable & Resizable Hybrid Shell**: Detaches from rigid screen constraints. Drag anywhere on the header to move, and scale freely with settings saved across sessions in `OneWorldMapDB`.
- 🌫️ **Fog-of-War Exploration Reveal**: Renders undiscovered map terrain at a customizable opacity (default 50%), revealing roads, rivers, terrain features, and topography beneath native pins and quest blobs. Includes full database support for Classic and custom WoW Forever zones.
- 🛡️ **Zero-Taint Architecture**: Preserves Blizzard's protected action mechanics and core map event pipeline without replacing or breaking `WorldMapFrame`.

---

## 🛠️ Installation

Copy the `OneWorldMap` directory into your World of Warcraft `Interface/AddOns/` directory:

```text
World of Warcraft/Interface/AddOns/OneWorldMap/
├── OneWorldMap.toc
├── Core.lua
├── Shell.lua
├── DoubleWide.lua
├── Sidebar.lua
├── Coordinates.lua
├── Data/
│   └── ZoneData.lua
├── README.md
├── CHANGELOG.md
└── CONTEXT.md
```

Then start or reload World of Warcraft (`/reload`).

---

## 💻 Slash Commands

| Command | Description |
|---|---|
| `/owm` or `/oneworldmap` | Toggle OneWorldMap / show command help |
| `/owm reset` | Reset map window position and scale to center default |
| `/owm sidebar` | Toggle left zone metadata panel collapse state |
| `/owm coords` | Toggle coordinate display on or off |
| `/owm doublewide` | Toggle DoubleWide quest log layout mode |
| `/owm fade` | Toggle movement fading on or off |
| `/owm fog` | Toggle Fog-of-War exploration reveal |
| `/owm fogalpha <0.1-1.0>` | Set Fog-of-War reveal opacity (default: 0.50) |

---

For detailed version history and release notes, see [CHANGELOG.md](CHANGELOG.md).
