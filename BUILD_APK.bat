@echo off
echo ========================================
echo Building TaskFlow Mobile Release APK
echo ========================================
echo.

cd taskflow_mobile

echo Checking Flutter installation...
flutter --version
if errorlevel 1 (
    echo.
    echo ERROR: Flutter is not installed or not in PATH
    echo.
    echo Please install Flutter from: https://flutter.dev/docs/get-started/install/windows
    echo Then add flutter\bin to your system PATH
    echo.
    pause
    exit /b 1
)

echo.
echo Cleaning previous builds...
flutter clean

echo.
echo Getting dependencies...
flutter pub get

echo.
echo Building release APK...
flutter build apk --release

if errorlevel 1 (
    echo.
    echo ERROR: Build failed!
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo BUILD SUCCESSFUL!
echo ========================================
echo.
echo APK Location: taskflow_mobile\build\app\outputs\flutter-apk\app-release.apk
echo.
echo You can now install this APK on your Android device.
echo.
pause
