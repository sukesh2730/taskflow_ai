# Flutter Setup Guide for Building APK

## Quick Setup Steps

### 1. Install Flutter

1. Download Flutter SDK from: https://flutter.dev/docs/get-started/install/windows
2. Extract the zip file to `C:\flutter` (or your preferred location)
3. Add `C:\flutter\bin` to your system PATH:
   - Search for "Environment Variables" in Windows
   - Click "Environment Variables"
   - Under "System variables", find "Path" and click "Edit"
   - Click "New" and add `C:\flutter\bin`
   - Click "OK" on all dialogs

### 2. Verify Installation

Open a new Command Prompt and run:
```
flutter doctor
```

This will check your Flutter installation and show what else needs to be installed.

### 3. Install Android Build Tools

Flutter doctor will tell you if you need:
- Android SDK
- Android Studio (or just the command-line tools)
- Accept Android licenses: `flutter doctor --android-licenses`

### 4. Build Your APK

Once Flutter is installed and `flutter doctor` shows no critical errors, simply run:
```
BUILD_APK.bat
```

The APK will be created at:
```
taskflow_mobile\build\app\outputs\flutter-apk\app-release.apk
```

## Alternative: Use GitHub Actions

If you don't want to install Flutter locally, you can set up GitHub Actions to build the APK in the cloud. Let me know if you'd like me to create that workflow file.

## Troubleshooting

**"Flutter is not recognized"**
- Make sure you added Flutter to PATH
- Restart your terminal/command prompt after adding to PATH
- Verify with: `where flutter`

**Build fails with Android SDK errors**
- Run `flutter doctor` to see what's missing
- Accept Android licenses: `flutter doctor --android-licenses`
- Install Android SDK through Android Studio or command-line tools

**Out of memory during build**
- Close other applications
- Try building with: `flutter build apk --release --split-per-abi`
