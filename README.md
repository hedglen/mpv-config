# mpv-config

> Personal mpv configuration for Windows — tuned for an **LG UltraGear 34GP83A-B** (3440×1440 @ 160Hz, DisplayHDR 400) with an **NVIDIA RTX 3070 Ti**. Built for quality, control, and daily use.

---

## ⚡ Quick Install

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/hedglen/mpv-config/master/install.ps1 | iex
```

**Requires:** [7-Zip](https://7-zip.org) and [Git](https://git-scm.com) installed first.

The installer will:
- Download the latest mpv build (shinchiro x86_64)
- Download yt-dlp (stream YouTube, Twitch, etc.)
- Download HdrSwitcher (Windows HDR toggling)
- Clone this config as `portable_config` inside the mpv folder
- Create a desktop shortcut and add mpv to your PATH

---

## 🔧 Manual Install

1. Download mpv from [shinchiro's builds](https://github.com/shinchiro/mpv-winbuild-cmake/releases) and extract to `C:\mpv`
2. Clone this repo:
   ```
   git clone https://github.com/hedglen/mpv-config.git C:\mpv\portable_config
   ```
3. Download [yt-dlp.exe](https://github.com/yt-dlp/yt-dlp/releases/latest) into `C:\mpv`
4. Download [HdrSwitcher.zip](https://github.com/Vaiz/HdrSwitcher/releases/latest), extract, and copy `HdrSwitcher.exe` into `C:\mpv\portable_config` as `hdrswitch.exe`
5. Run `mpv-single.bat` for single-instance mode, or `mpv.exe` directly

---

## ✨ Features

### Picture Quality
- **Vulkan renderer** with nvdec hardware decoding
- **Auto upscaling** by source resolution:
  - ≤720p → FSRCNNX x2 56-16-4-1 (CNN upscaling)
  - 1080p → SSimDownscaler + FSRCNNX (precision downscale then correct)
  - 1440p+ → no shader (native or above)
- **Anime4K** shaders for animated content
- Vivid, punchy SDR picture (tuned brightness, contrast, saturation)
- **Deband filter** toggle for banding artifacts
- **Gamut mapping** set to `auto` for accurate wide-color content

### HDR
- **Auto HDR switching** — detects PQ/HLG/BT.2020 content and toggles Windows HDR on/off automatically
- Equalizer resets when HDR is active (prevents color mangling)
- Restores SDR picture settings when HDR content ends
- Works seamlessly with single-instance file switching
- Manual override and status display

### Workflow
- **Single-instance mode** — opening a new file loads it into the existing window
- **Window memory** — remembers size and position between every session
- **Volume memory** — volume and mute state persist between sessions
- **Auto-load folder** — opening any video queues up the entire folder as a playlist
- **Favorites** — save, load, and manage a personal playlist
- **Chapter editor** — add chapter markers while playing and save them into the file
- **Clip export** — mark in/out points and export clips with ffmpeg (no re-encode)
- **Boss key** — instantly pause and minimize
- **A/B loop** — independently mark A, B, and reset points
- **SponsorBlock** — skip sponsor segments automatically
- **GIF creation** — mark start/end and export animated GIFs
- **yt-dlp** — stream from YouTube, Twitch, and hundreds of other sites
- **Audio normalization** — dynamic volume leveling for inconsistent content

### UI
- **uosc** — modern interface with timeline, controls, and right-click context menu
- **Neon purple** theme
- **Seek bar thumbnails** — hover to preview any frame
- **Playlist manager** — visual playlist browser

---

## 🖱️ Mouse Controls

| Input | Action |
|-------|--------|
| Left click | Play / Pause |
| Middle click | Quit |
| Right click | Context menu |
| Scroll up/down | Volume ±2 |

---

## 🎮 Corsair Scimitar Side Buttons

Map buttons 1–12 to **F13–F24** in iCUE (Keyboard action, no modifier).

```
┌─────────────┬──────────────┬──────────────┐
│ 1: Fullscr  │  2: Prev File│  3: Next File│
├─────────────┼──────────────┼──────────────┤
│ 4: Favs     │  5: Frame ◀  │  6: Frame ▶  │
├─────────────┼──────────────┼──────────────┤
│ 7: Mute     │  8: A-B Reset│  9: A-B Mark A│
├─────────────┼──────────────┼──────────────┤
│ 10: Boss Key│ 11: Loop     │ 12: A-B Mark B│
└─────────────┴──────────────┴──────────────┘
```

| Button | Key | Action |
|--------|-----|--------|
| 1 | F13 | Toggle fullscreen |
| 2 | F14 | Previous file |
| 2 + Ctrl | Ctrl+F14 | Previous chapter |
| 3 | F15 | Next file |
| 3 + Ctrl | Ctrl+F15 | Next chapter |
| 4 | F16 | Open favorites playlist |
| 4 + Ctrl | Ctrl+F16 | Add current file to favorites |
| 4 + Alt | Alt+F16 | Remove from favorites |
| 5 | F17 | Frame step back |
| 6 | F18 | Frame step forward |
| 7 | F19 | Mute |
| 8 | F20 | A-B loop reset |
| 9 | F21 | A-B mark A |
| 10 | F22 | Boss key (pause + minimize) |
| 11 | F23 | Loop file toggle |
| 12 | F24 | A-B mark B |

---

## ⌨️ Keyboard Shortcuts

### Playback
| Key | Action |
|-----|--------|
| `Space` | Play / Pause |
| `←` / `→` | Seek ±5s |
| `Shift+←` / `Shift+→` | Seek ±60s |
| `Ctrl+←` / `Ctrl+→` | Seek ±5min |
| `,` / `.` | Frame step back / forward |
| `[` / `]` | Speed ×0.9 / ×1.1 |
| `<` / `>` | Half / double speed |
| `Backspace` | Reset speed |
| `q` | Quit and save position |
| `Q` | Force quit |

### Picture & Color
| Key | Action |
|-----|--------|
| `1` / `2` | Brightness +/− |
| `3` / `4` | Contrast +/− |
| `5` / `6` | Saturation +/− |
| `7` / `8` | Gamma +/− |
| `9` | Maximum vibrancy preset |
| `0` | Neutral reset |
| `d` | Toggle deband filter |
| `D` | Toggle deinterlace |
| `C` | Cycle aspect ratio (16:9 → 21:9 → 4:3 → 2.35:1) |

### HDR
| Key | Action |
|-----|--------|
| `H` | Manual HDR toggle |
| `h` | Show HDR status (gamma, primaries, state) |

### Shaders
| Key | Action |
|-----|--------|
| `Ctrl+1` | FSRCNNX x2 56 — best for live-action |
| `Ctrl+2` | Anime4K — best for animation |
| `Ctrl+3` | SSimDownscaler + FSRCNNX — highest quality |
| `Ctrl+4` | Built-in sharp scaling |
| `Ctrl+0` | No shaders |

### Chapters
| Key | Action |
|-----|--------|
| `t` | Add chapter at current position |
| `T` | Save all chapters to file |
| `Ctrl+F14` | Previous chapter |
| `Ctrl+F15` | Next chapter |

### Clip Export
| Key | Action |
|-----|--------|
| `Ctrl+I` | Set clip IN point |
| `Ctrl+O` | Set clip OUT point |
| `Ctrl+E` | Export clip (stream copy, no re-encode) |
| `Ctrl+P` | Show current IN/OUT status |

### Audio
| Key | Action |
|-----|--------|
| `↑` / `↓` | Volume ±2 |
| `Ctrl+↑` / `Ctrl+↓` | Volume ±10 |
| `m` | Mute |
| `a` / `A` | Cycle audio tracks |
| `x` / `X` | Audio delay ±50ms |
| `Ctrl+X` | Reset audio delay |
| `Alt+N` | Toggle audio normalization (dynaudnorm) |

### Subtitles
| Key | Action |
|-----|--------|
| `s` / `S` | Cycle subtitle tracks |
| `v` | Toggle subtitle visibility |
| `Shift+G` / `Shift+F` | Subtitle size +/− |
| `z` / `Z` | Subtitle delay ±50ms |
| `Ctrl+Z` | Reset subtitle delay |

### Screenshots
| Key | Action |
|-----|--------|
| `F12` | High-quality screenshot |
| `Ctrl+S` | Video-only screenshot |
| `Ctrl+Alt+S` | Window screenshot |

### GIF Creation
| Key | Action |
|-----|--------|
| `b` | Set GIF start point |
| `B` | Set GIF end point |
| `Ctrl+B` | Export GIF |
| `Ctrl+Shift+B` | Export GIF with subtitles |

### Window
| Key | Action |
|-----|--------|
| `f` | Toggle fullscreen |
| `k` | Toggle always on top |
| `Alt+1–4` | Window scale 50% / 100% / 150% / 200% |
| `Alt+R` | Toggle 21:9 ultrawide crop |
| `i` | Stats overlay |

### Utilities
| Key | Action |
|-----|--------|
| `Ctrl+C` | Copy timestamp to clipboard |
| `Ctrl+T` | Seek to typed timestamp |
| `Alt+B` | Toggle SponsorBlock |
| `c` | Cycle audio visualizer |
| `Ctrl+L` | Open playlist manager |
| `F1` | Show playlist |
| `F2` | Show track list |
| `F3` | Show chapter list |

---

## 📜 Scripts

| Script | Description |
|--------|-------------|
| `hdr-auto.lua` | Auto-detects HDR content, toggles Windows HDR, resets equalizer |
| `chapter-editor.lua` | Add chapter markers while playing and save them to the file via ffmpeg |
| `clip-export.lua` | Mark in/out points and export clips without re-encoding |
| `autoload.lua` | Automatically queues all videos in the same folder as a playlist |
| `favorites.lua` | Save, load, and manage a personal favorites playlist |
| `ab-loop-manager.lua` | Independent A, B, and reset bindings for A-B loop |
| `boss-key.lua` | Pause and minimize instantly |
| `audio-normalize.lua` | Toggle dynamic audio normalization (dynaudnorm) |
| `remember-volume.lua` | Persists volume and mute state between sessions |
| `save-geometry.lua` | Remembers window size and position between sessions |
| `sponsorblock-minimal.lua` | Skips sponsor segments via SponsorBlock API |
| `playlistmanager.lua` | Visual playlist browser |
| `thumbfast.lua` | Seek bar thumbnail preview |
| `copy-time.lua` | Copy current timestamp to clipboard |
| `mpv-gif.lua` | Export animated GIFs from video clips |
| `audio_visualizer.lua` | Audio spectrum visualizer |
| `seek-to.lua` | Seek to a typed timestamp |

---

## 🖥️ Hardware

| Component | Spec |
|-----------|------|
| Monitor | LG UltraGear 34GP83A-B — 3440×1440 @ 160Hz, DisplayHDR 400, G-SYNC |
| GPU | NVIDIA RTX 3070 Ti — 8GB VRAM, Ampere |
| RAM | 32GB |
| OS | Windows 11 |

---

## 🔁 Single-Instance Setup

To make clicking a video file always open in the existing mpv window:

1. Set **`mpv-single.bat`** as the default program for your video file types
2. It connects to mpv's named pipe (`\\.\pipe\mpvsocket`) and sends a `loadfile` command
3. Falls back to launching a new mpv instance if none is running
