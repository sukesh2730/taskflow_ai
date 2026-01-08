@echo off
echo ========================================
echo Complete Setup and Build
echo ========================================
echo.
echo This will automatically:
echo 1. Install Android SDK
echo 2. Configure Flutter
echo 3. Accept all licenses
echo 4. Build your APK
echo.
echo This may take 10-15 minutes on first run.
echo.
echo Press Ctrl+C to cancel, or
pause

echo.
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%~dp0COMPLETE_SETUP_AND_BUILD.ps1"

echo.
pause
