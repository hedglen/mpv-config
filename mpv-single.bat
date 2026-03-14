@echo off
powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "%~dp0mpv-single.ps1" "%~1"
