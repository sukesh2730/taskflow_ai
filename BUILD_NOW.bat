@echo off
echo ========================================
echo Building TaskFlow APK
echo ========================================
echo.
echo This will complete setup and build your APK
echo Estimated time: 10-15 minutes
echo.
pause

PowerShell -NoProfile -ExecutionPolicy Bypass -File "%~dp0SETUP_AND_BUILD_FINAL.ps1"
pause
