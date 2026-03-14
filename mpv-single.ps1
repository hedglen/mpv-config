# mpv-single.ps1
# Single-instance launcher for mpv.
# If mpv is already running (pipe exists), sends the file to it.
# Otherwise starts a new mpv instance.
# Usage: mpv-single.ps1 "C:\path\to\file.mkv"

param([string]$FilePath)

$mpvExe = Join-Path $PSScriptRoot "..\mpv.exe"
if (-not (Test-Path $mpvExe)) {
    $mpvExe = Join-Path $PSScriptRoot "mpv.exe"
}

function Send-ToMpv {
    param([string]$path)
    try {
        $pipe = New-Object System.IO.Pipes.NamedPipeClientStream(
            ".", "mpvsocket",
            [System.IO.Pipes.PipeDirection]::InOut,
            [System.IO.Pipes.PipeOptions]::None)
        $pipe.Connect(400)
        $writer = New-Object System.IO.StreamWriter($pipe)
        $writer.AutoFlush = $true
        $escaped = $path -replace '\\', '/' -replace '"', '\"'
        $writer.WriteLine("{`"command`":[`"loadfile`",`"$escaped`"]}")
        Start-Sleep -Milliseconds 100
        $writer.Close()
        $pipe.Close()
        return $true
    } catch {
        return $false
    }
}

if ($FilePath -and (Send-ToMpv $FilePath)) {
    exit 0
}

if ($FilePath) {
    Start-Process $mpvExe -ArgumentList "`"$FilePath`""
} else {
    Start-Process $mpvExe
}
