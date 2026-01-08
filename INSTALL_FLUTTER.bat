@echo off
echo ========================================
echo Flutter Auto-Installer
echo ========================================
echo.
echo This will download and install Flutter SDK
echo Installation location: C:\flutter
echo Download size: ~1GB
echo.
echo Press Ctrl+C to cancel, or
pause

echo.
echo Running PowerShell installer...
echo.

PowerShell -NoProfile -ExecutionPolicy Bypass -File "%~dp0INSTALL_FLUTTER.ps1"

if errorlevel 1 (
    echo.
    echo Installation failed!
    echo.
    pause
    exit /b 1
)

echo.
echo Installation complete!
pause
