# Android SDK Command-Line Tools Installer
# This installs only what's needed to build APKs (no Android Studio required)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Android SDK Installer (Command-Line)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$sdkUrl = "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"
$sdkRoot = "C:\Android"
$cmdlineToolsPath = "$sdkRoot\cmdline-tools"
$zipPath = "$env:TEMP\android-cmdline-tools.zip"

# Create directories
Write-Host "Creating Android SDK directory..." -ForegroundColor Yellow
if (-not (Test-Path $sdkRoot)) {
    New-Item -ItemType Directory -Path $sdkRoot -Force | Out-Null
}
if (-not (Test-Path $cmdlineToolsPath)) {
    New-Item -ItemType Directory -Path $cmdlineToolsPath -Force | Out-Null
}

# Download command-line tools
Write-Host "Downloading Android Command-Line Tools..." -ForegroundColor Yellow
Write-Host "This may take a few minutes..." -ForegroundColor Gray
Write-Host ""

try {
    Import-Module BitsTransfer
    Start-BitsTransfer -Source $sdkUrl -Destination $zipPath -Description "Downloading Android SDK"
} catch {
    Write-Host "BITS transfer failed, trying WebClient..." -ForegroundColor Yellow
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($sdkUrl, $zipPath)
}

Write-Host "Download complete!" -ForegroundColor Green
Write-Host ""

# Extract
Write-Host "Extracting Android SDK..." -ForegroundColor Yellow
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, "$cmdlineToolsPath\temp")

# Move to correct location (cmdline-tools/latest/)
$latestPath = "$cmdlineToolsPath\latest"
if (Test-Path $latestPath) {
    Remove-Item -Path $latestPath -Recurse -Force
}
Move-Item -Path "$cmdlineToolsPath\temp\cmdline-tools" -Destination $latestPath

# Clean up temp
Remove-Item -Path "$cmdlineToolsPath\temp" -Recurse -Force
Remove-Item $zipPath -Force

Write-Host "Extraction complete!" -ForegroundColor Green
Write-Host ""

# Set environment variables
Write-Host "Setting environment variables..." -ForegroundColor Yellow

$env:ANDROID_HOME = $sdkRoot
$env:ANDROID_SDK_ROOT = $sdkRoot

# Add to system environment
[Environment]::SetEnvironmentVariable("ANDROID_HOME", $sdkRoot, "Machine")
[Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", $sdkRoot, "Machine")

# Add to PATH
$pathsToAdd = @(
    "$sdkRoot\cmdline-tools\latest\bin",
    "$sdkRoot\platform-tools",
    "$sdkRoot\build-tools\34.0.0"
)

$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
foreach ($pathToAdd in $pathsToAdd) {
    if ($currentPath -notlike "*$pathToAdd*") {
        $currentPath = "$currentPath;$pathToAdd"
    }
}
[Environment]::SetEnvironmentVariable("Path", $currentPath, "Machine")

Write-Host "Environment variables set!" -ForegroundColor Green
Write-Host ""

# Refresh environment for current session
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Configure Flutter to use this SDK
Write-Host "Configuring Flutter..." -ForegroundColor Yellow
& C:\flutter\bin\flutter.bat config --android-sdk $sdkRoot

Write-Host ""
Write-Host "Installing required SDK packages..." -ForegroundColor Yellow
Write-Host "This will download platform-tools, build-tools, and Android platform..." -ForegroundColor Gray
Write-Host ""

# Accept licenses first
$sdkmanager = "$latestPath\bin\sdkmanager.bat"

# Install required packages
& $sdkmanager --sdk_root=$sdkRoot "platform-tools" "platforms;android-34" "build-tools;34.0.0"

Write-Host ""
Write-Host "Accepting Android licenses..." -ForegroundColor Yellow
Write-Host "You'll need to type 'y' and press Enter for each license..." -ForegroundColor Gray
Write-Host ""

# Accept licenses
& $sdkmanager --sdk_root=$sdkRoot --licenses

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Android SDK Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "SDK Location: $sdkRoot" -ForegroundColor White
Write-Host ""
Write-Host "Running Flutter Doctor..." -ForegroundColor Yellow
Write-Host ""

& C:\flutter\bin\flutter.bat doctor

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "1. Close and reopen your terminal" -ForegroundColor White
Write-Host "2. Run: BUILD_APK.bat" -ForegroundColor White
Write-Host ""

pause
