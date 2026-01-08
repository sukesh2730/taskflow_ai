# Complete Setup and Build Script
# This will install Android SDK and build the APK automatically

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Complete Setup and Build" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$sdkUrl = "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"
$sdkRoot = "C:\Android"
$cmdlineToolsPath = "$sdkRoot\cmdline-tools"
$zipPath = "$env:TEMP\android-cmdline-tools.zip"

# Step 1: Install Android SDK
Write-Host "STEP 1: Installing Android SDK..." -ForegroundColor Yellow
Write-Host ""

if (-not (Test-Path $sdkRoot)) {
    New-Item -ItemType Directory -Path $sdkRoot -Force | Out-Null
}
if (-not (Test-Path $cmdlineToolsPath)) {
    New-Item -ItemType Directory -Path $cmdlineToolsPath -Force | Out-Null
}

Write-Host "Downloading Android Command-Line Tools..." -ForegroundColor Gray
try {
    Import-Module BitsTransfer
    Start-BitsTransfer -Source $sdkUrl -Destination $zipPath -Description "Downloading Android SDK"
} catch {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($sdkUrl, $zipPath)
}

Write-Host "Extracting..." -ForegroundColor Gray

# Clean up any existing temp folder
$tempPath = "$cmdlineToolsPath\temp"
if (Test-Path $tempPath) {
    Remove-Item -Path $tempPath -Recurse -Force
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $tempPath)

$latestPath = "$cmdlineToolsPath\latest"
if (Test-Path $latestPath) {
    Remove-Item -Path $latestPath -Recurse -Force
}
Move-Item -Path "$tempPath\cmdline-tools" -Destination $latestPath
Remove-Item -Path $tempPath -Recurse -Force
Remove-Item $zipPath -Force

Write-Host "Android SDK extracted!" -ForegroundColor Green
Write-Host ""

# Step 2: Set environment variables
Write-Host "STEP 2: Configuring environment..." -ForegroundColor Yellow

$env:ANDROID_HOME = $sdkRoot
$env:ANDROID_SDK_ROOT = $sdkRoot

[Environment]::SetEnvironmentVariable("ANDROID_HOME", $sdkRoot, "Machine")
[Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", $sdkRoot, "Machine")

$pathsToAdd = @(
    "$sdkRoot\cmdline-tools\latest\bin",
    "$sdkRoot\platform-tools",
    "$sdkRoot\build-tools\34.0.0",
    "C:\flutter\bin"
)

$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
foreach ($pathToAdd in $pathsToAdd) {
    if ($currentPath -notlike "*$pathToAdd*") {
        $currentPath = "$currentPath;$pathToAdd"
    }
}
[Environment]::SetEnvironmentVariable("Path", $currentPath, "Machine")

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "Environment configured!" -ForegroundColor Green
Write-Host ""

# Step 3: Configure Flutter
Write-Host "STEP 3: Configuring Flutter..." -ForegroundColor Yellow
& C:\flutter\bin\flutter.bat config --android-sdk $sdkRoot
Write-Host ""

# Step 4: Install SDK packages
Write-Host "STEP 4: Installing Android SDK packages..." -ForegroundColor Yellow
Write-Host "This may take several minutes..." -ForegroundColor Gray
Write-Host ""

$sdkmanager = "$latestPath\bin\sdkmanager.bat"

# Install packages silently
& $sdkmanager --sdk_root=$sdkRoot "platform-tools" "platforms;android-34" "build-tools;34.0.0" 2>&1 | Out-Null

Write-Host "SDK packages installed!" -ForegroundColor Green
Write-Host ""

# Step 5: Accept licenses automatically
Write-Host "STEP 5: Accepting Android licenses..." -ForegroundColor Yellow

$licenses = "y`ny`ny`ny`ny`ny`ny`ny`ny`n"
$licenses | & $sdkmanager --sdk_root=$sdkRoot --licenses 2>&1 | Out-Null

Write-Host "Licenses accepted!" -ForegroundColor Green
Write-Host ""

# Step 6: Build APK
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "STEP 6: Building APK..." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location -Path "taskflow_mobile"

Write-Host "Cleaning previous builds..." -ForegroundColor Gray
& C:\flutter\bin\flutter.bat clean 2>&1 | Out-Null

Write-Host "Getting dependencies..." -ForegroundColor Gray
& C:\flutter\bin\flutter.bat pub get

Write-Host ""
Write-Host "Building release APK..." -ForegroundColor Yellow
Write-Host "This will take several minutes on first build..." -ForegroundColor Gray
Write-Host ""

& C:\flutter\bin\flutter.bat build apk --release

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "BUILD SUCCESSFUL!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "APK Location:" -ForegroundColor White
    Write-Host "taskflow_mobile\build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor Green
    Write-Host ""
    Write-Host "File size:" -ForegroundColor White
    $apkPath = "build\app\outputs\flutter-apk\app-release.apk"
    if (Test-Path $apkPath) {
        $size = (Get-Item $apkPath).Length / 1MB
        Write-Host ("{0:N2} MB" -f $size) -ForegroundColor Green
    }
    Write-Host ""
    Write-Host "You can now install this APK on your Android device!" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "BUILD FAILED!" -ForegroundColor Red
    Write-Host "Check the error messages above." -ForegroundColor Yellow
}

Set-Location -Path ".."

Write-Host ""
pause
