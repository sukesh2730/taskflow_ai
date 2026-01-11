@echo off
echo ========================================
echo Android SDK Quick Setup for TaskFlow
echo ========================================
echo.

echo This script will help you set up Android SDK for building the APK.
echo.
echo OPTION 1: Install Android Studio (Recommended)
echo   - Download from: https://developer.android.com/studio
echo   - Install and let it download Android SDK automatically
echo   - Then run: flutter doctor --android-licenses
echo.
echo OPTION 2: Install Command Line Tools Only
echo   - Download from: https://developer.android.com/studio#command-tools
echo   - Extract to C:\Android\cmdline-tools\latest
echo   - Run: sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
echo.
echo OPTION 3: Use GitHub Actions (No local setup needed!)
echo   - Push code to GitHub
echo   - Go to Actions tab
echo   - Run "Build Android APK" workflow
echo   - Download APK from Artifacts
echo.

echo Current Status:
echo ---------------
flutter doctor
echo.

echo What would you like to do?
echo 1. Open Android Studio download page
echo 2. Open Command Line Tools download page
echo 3. Check current Flutter doctor status
echo 4. Exit
echo.

set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" (
    start https://developer.android.com/studio
    echo Opening Android Studio download page...
)
if "%choice%"=="2" (
    start https://developer.android.com/studio#command-tools
    echo Opening Command Line Tools download page...
)
if "%choice%"=="3" (
    flutter doctor -v
)

echo.
echo After installing Android SDK, run: BUILD_FINAL_APK.bat
pause
