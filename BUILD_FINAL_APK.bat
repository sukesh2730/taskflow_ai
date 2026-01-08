@echo off
echo ========================================
echo Building TaskFlow AI v1.1.0
echo With Voice, Timer, Dark Mode, Export
echo ========================================
echo.

cd taskflow_mobile

echo Step 1: Getting dependencies...
call flutter pub get

if errorlevel 1 (
    echo.
    echo ERROR: Failed to get dependencies
    echo Make sure Flutter is installed and in PATH
    pause
    exit /b 1
)

echo.
echo Step 2: Building release APK...
echo This may take 5-10 minutes...
echo.

call flutter build apk --release

if errorlevel 1 (
    echo.
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo BUILD SUCCESSFUL!
echo ========================================
echo.
echo APK Location:
echo taskflow_mobile\build\app\outputs\flutter-apk\app-release.apk
echo.
echo Features included:
echo - Voice Input (AI-powered)
echo - Focus Timer (Pomodoro)
echo - Dark Mode
echo - Data Backup/Export
echo.
echo Install this APK on your Android device!
echo.
pause
