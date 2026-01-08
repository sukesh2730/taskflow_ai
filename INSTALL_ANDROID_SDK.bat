@echo off
echo ========================================
echo Android SDK Installer
echo ========================================
echo.
echo This will install Android SDK command-line tools
echo Installation location: C:\Android
echo.
echo You will need to accept Android licenses during installation
echo.
echo Press Ctrl+C to cancel, or
pause

echo.
echo Running installer...
echo.

PowerShell -NoProfile -ExecutionPolicy Bypass -File "%~dp0INSTALL_ANDROID_SDK.ps1"

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
