# mpv-config

Personal mpv configuration for Windows — tuned for an **LG UltraGear 34GP83A-B** (3440×1440 @ 160Hz, DisplayHDR 400) with an **NVIDIA RTX 3070 Ti**.

## Features

- **Vulkan renderer** with nvdec hardware decoding
- **Auto upscaling** based on source resolution:
  - ≤720p → FSRCNNX x2 56-16-4-1 (CNN upscaling)
  - 1080p → SSimDownscaler + FSRCNNX (overshoots then corrects)
  - 1440p+ → no shader (already at or above native)
- **HDR auto-switching** — detects PQ/HLG/BT.2020 content and toggles Windows HDR on/off automatically
- **uosc** modern UI with right-click context menu
- **Anime4K** shaders available for animated content (Ctrl+2)
- Vivid, punchy picture without oversaturation
- Full **Corsair Scimitar** 12-button side panel layout

## Quick Install

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/hedglen/mpv-config/master/install.ps1 | iex
```

This will:
1. Download the latest mpv build (shinchiro x86_64)
2. Download yt-dlp (streaming support)
3. Download HdrSwitcher (Windows HDR toggle)
4. Clone this config as `portable_config` inside the mpv directory
5. Create a desktop shortcut and add mpv to your PATH

**Requires:** [7-Zip](https://7-zip.org) and [Git](https://git-scm.com) to be installed first.

## Manual Install

1. Download mpv from [shinchiro's builds](https://github.com/shinchiro/mpv-winbuild-cmake/releases)
2. Extract to e.g. `C:\mpv`
3. Clone this repo into `C:\mpv\portable_config`:
   ```
   git clone https://github.com/hedglen/mpv-config.git C:\mpv\portable_config
   ```
4. Download [yt-dlp.exe](https://github.com/yt-dlp/yt-dlp/releases/latest) into `C:\mpv`
5. Done — run `mpv.exe`

## Key Bindings

### Mouse
| Input | Action |
|-------|--------|
| Left click | Play / Pause |
| Middle click | Exit |
| Right click | Menu |
| Scroll up/down | Volume ±2 |

### Corsair Scimitar Side Buttons
Map buttons 1–12 to **F13–F24** in iCUE (Keyboard action, no modifier).

| Button | Key | Action |
|--------|-----|--------|
| 1 | F13 | Toggle fullscreen |
| 2 | F14 | Previous file |
| 3 | F15 | Next file |
| 4 | F16 | Open favorites |
| 4 + Ctrl | Ctrl+F16 | Add to favorites |
| 5 | F17 | Frame step back |
| 6 | F18 | Frame step forward |
| 7 | F19 | Mute |
| 8 | F20 | A-B loop reset |
| 9 | F21 | A-B mark A |
| 10 | F22 | Boss key (pause + minimize) |
| 11 | F23 | Loop file toggle |
| 12 | F24 | A-B mark B |

### Shader Shortcuts
| Key | Action |
|-----|--------|
| Ctrl+1 | FSRCNNX (live-action) |
| Ctrl+2 | Anime4K (animation) |
| Ctrl+3 | SSimDownscaler + FSRCNNX (highest quality) |
| Ctrl+4 | Built-in sharp scaling |
| Ctrl+0 | No shaders (basic) |

### HDR
| Key | Action |
|-----|--------|
| H | Manual HDR toggle |

### Color / Picture
| Key | Action |
|-----|--------|
| 1 / 2 | Brightness +/− |
| 3 / 4 | Contrast +/− |
| 5 / 6 | Saturation +/− |
| 7 / 8 | Gamma +/− |
| 9 | Maximum vibrancy preset |
| 0 | Neutral reset |

## Scripts

| Script | Description |
|--------|-------------|
| `hdr-auto.lua` | Auto-detects HDR content and toggles Windows HDR |
| `ab-loop-manager.lua` | Separate A, B, and reset bindings for A-B loop |
| `favorites.lua` | Save and load a favorites playlist |
| `boss-key.lua` | Pause + minimize with one button |
| `copy-time.lua` | Copy current timestamp to clipboard |
| `mpv-gif.lua` | Create GIFs from video clips |

## Hardware this config is tuned for

| Component | Spec |
|-----------|------|
| Monitor | LG UltraGear 34GP83A-B (3440×1440 @ 160Hz, DisplayHDR 400) |
| GPU | NVIDIA RTX 3070 Ti (8GB VRAM, Ampere) |
| RAM | 32GB |
| OS | Windows 11 |
