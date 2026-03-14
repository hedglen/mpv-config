# =============================================================================
#  mpv-config installer
#  Downloads mpv, yt-dlp, and this config to your system.
#  Run from PowerShell as Administrator (recommended) or normal user.
# =============================================================================

param(
    [string]$InstallDir = "C:\mpv"
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"   # speeds up Invoke-WebRequest

function Info  { param($m) Write-Host "[*] $m" -ForegroundColor Cyan }
function OK    { param($m) Write-Host "[+] $m" -ForegroundColor Green }
function Fatal { param($m) Write-Host "[!] $m" -ForegroundColor Red; exit 1 }

$configDir = "$InstallDir\portable_config"

# -----------------------------------------------------------------------------
# 1. Create install directory
# -----------------------------------------------------------------------------
Info "Installing to $InstallDir"
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

# -----------------------------------------------------------------------------
# 2. Download mpv (shinchiro Windows builds — latest stable)
# -----------------------------------------------------------------------------
Info "Fetching latest mpv release..."
$mpvApi = Invoke-RestMethod "https://api.github.com/repos/shinchiro/mpv-winbuild-cmake/releases/latest"
$mpvAsset = $mpvApi.assets | Where-Object { $_.name -match "mpv-x86_64-\d+-git.*\.7z$" } | Select-Object -First 1
if (-not $mpvAsset) { Fatal "Could not find mpv x86_64 release asset." }

$mpvZip = "$env:TEMP\mpv-latest.7z"
Info "Downloading $($mpvAsset.name)..."
Invoke-WebRequest -Uri $mpvAsset.browser_download_url -OutFile $mpvZip

# Extract with 7-Zip
$sevenZip = @("C:\Program Files\7-Zip\7z.exe","C:\Program Files (x86)\7-Zip\7z.exe") | Where-Object { Test-Path $_ } | Select-Object -First 1
if ($sevenZip) {
    Info "Extracting mpv..."
    & $sevenZip x $mpvZip -o"$InstallDir" -y | Out-Null
} else {
    Fatal "7-Zip not found. Please install 7-Zip from https://7-zip.org, then re-run this script."
}
OK "mpv extracted to $InstallDir"

# -----------------------------------------------------------------------------
# 3. Download yt-dlp
# -----------------------------------------------------------------------------
Info "Downloading yt-dlp..."
Invoke-WebRequest -Uri "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" -OutFile "$InstallDir\yt-dlp.exe"
OK "yt-dlp downloaded"

# -----------------------------------------------------------------------------
# 4. Clone config repo into portable_config (must come before HdrSwitcher copy)
# -----------------------------------------------------------------------------
if (Test-Path "$configDir\.git") {
    Info "Config already cloned — pulling latest..."
    git -C $configDir pull
} else {
    Info "Cloning mpv config..."
    if (Get-Command git -ErrorAction SilentlyContinue) {
        git clone "https://github.com/hedglen/mpv-config.git" $configDir
    } else {
        Fatal "git not found. Install Git from https://git-scm.com then re-run."
    }
}
OK "Config installed to $configDir"

# -----------------------------------------------------------------------------
# 5. Download ffmpeg (needed for chapter saving and other tools)
# -----------------------------------------------------------------------------
Info "Downloading ffmpeg..."
try {
    $ffmpegUrl = "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"
    $ffmpegZip = "$env:TEMP\ffmpeg.zip"
    Invoke-WebRequest -Uri $ffmpegUrl -OutFile $ffmpegZip
    Expand-Archive -Path $ffmpegZip -DestinationPath "$env:TEMP\ffmpeg_tmp" -Force
    $ffmpegExe = Get-ChildItem "$env:TEMP\ffmpeg_tmp" -Recurse -Filter "ffmpeg.exe" | Select-Object -First 1
    if ($ffmpegExe) {
        Copy-Item $ffmpegExe.FullName "$InstallDir\ffmpeg.exe" -Force
        OK "ffmpeg installed"
    }
    Remove-Item $ffmpegZip -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\ffmpeg_tmp" -Recurse -Force -ErrorAction SilentlyContinue
} catch {
    Write-Host "[~] ffmpeg download failed — get it from https://ffmpeg.org/download.html and place ffmpeg.exe in $InstallDir" -ForegroundColor Yellow
}

# -----------------------------------------------------------------------------
# 6. Download HdrSwitcher into portable_config
# -----------------------------------------------------------------------------
Info "Downloading HdrSwitcher..."
try {
    $hdrApi   = Invoke-RestMethod "https://api.github.com/repos/Vaiz/HdrSwitcher/releases/latest"
    $hdrAsset = $hdrApi.assets | Where-Object { $_.name -eq "HdrSwitcher.zip" } | Select-Object -First 1
    if ($hdrAsset) {
        $hdrZip = "$env:TEMP\HdrSwitcher.zip"
        Invoke-WebRequest -Uri $hdrAsset.browser_download_url -OutFile $hdrZip
        Expand-Archive -Path $hdrZip -DestinationPath "$env:TEMP\HdrSwitcher" -Force
        Copy-Item "$env:TEMP\HdrSwitcher\HdrSwitcher.exe" "$configDir\hdrswitch.exe" -Force
        OK "HdrSwitcher installed as hdrswitch.exe"
    } else {
        Write-Host "[~] HdrSwitcher not found — get it from https://github.com/Vaiz/HdrSwitcher/releases and place it as hdrswitch.exe in $configDir" -ForegroundColor Yellow
    }
} catch {
    Write-Host "[~] HdrSwitcher download failed — get it from https://github.com/Vaiz/HdrSwitcher/releases and place it as hdrswitch.exe in $configDir" -ForegroundColor Yellow
}

# -----------------------------------------------------------------------------
# 7. Create desktop shortcut
# -----------------------------------------------------------------------------
Info "Creating desktop shortcut..."
$mpvExe = Get-ChildItem "$InstallDir" -Filter "mpv.exe" -Recurse | Select-Object -First 1
if ($mpvExe) {
    $shell    = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut("$env:USERPROFILE\Desktop\mpv.lnk")
    $shortcut.TargetPath       = $mpvExe.FullName
    $shortcut.WorkingDirectory = $mpvExe.DirectoryName
    $shortcut.Save()
    OK "Desktop shortcut created"
}

# -----------------------------------------------------------------------------
# 8. Add mpv to user PATH
# -----------------------------------------------------------------------------
if ($mpvExe) {
    $mpvDir     = $mpvExe.DirectoryName
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($currentPath -notlike "*$mpvDir*") {
        [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$mpvDir", "User")
        OK "Added mpv to user PATH (restart terminal to take effect)"
    }
}

Write-Host ""
OK "Done! mpv is installed at $InstallDir"
Write-Host "    Config: $configDir" -ForegroundColor Gray
if ($mpvExe) { Write-Host "    Run:    $($mpvExe.FullName)" -ForegroundColor Gray }
