# Complete Setup and Build Script - Final Version
$ErrorActionPreference = "Continue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Complete Setup and Build" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$sdkRoot = "C:\Android"
$flutterPath = "C:\flutter\bin\flutter.bat"

# Check if Android SDK already exists
if (Test-Path "$sdkRoot\cmdline-tools\latest\bin\sdkmanager.bat") {
    Write-Host "Android SDK already installed!" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "STEP 1: Installing Android SDK..." -ForegroundColor Yellow
    
    $sdkUrl = "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"
    $zipPath = "$env:TEMP\android-cmdline-tools.zip"
    
    if (-not (Test-Path $sdkRoot)) {
        New-Item -ItemType Directory -Path $sdkRoot -Force | Out-Null
    }
    
    Write-Host "Downloading..." -ForegroundColor Gray
    try {
        Import-Module BitsTransfer
        Start-BitsTransfer -Source $sdkUrl -Destination $zipPath
    } catch {
        (New-Object System.Net.WebClient).DownloadFile($sdkUrl, $zipPath)
    }
    
    Write-Host "Extracting..." -ForegroundColor Gray
    $extractPath = "$env:TEMP\android-extract-$(Get-Random)"
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $extractPath)
    
    $latestPath = "$sdkRoot\cmdline-tools\latest"
    if (-not (Test-Path "$sdkRoot\cmdline-tools")) {
        New-Item -ItemType Directory -Path "$sdkRoot\cmdline-tools" -Force | Out-Null
    }
    
    if (Test-Path $latestPath) {
        Remove-Item -Path $latestPath -Recurse -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    }
    
    Move-Item -Path "$extractPath\cmdline-tools" -Destination $latestPath -Force
    Remove-Item -Path $extractPath -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
    
    Write-Host "Android SDK installed!" -ForegroundColor Green
    Write-Host ""
}

# Set environment variables
Write-Host "STEP 2: Configuring environment..." -ForegroundColor Yellow

$env:ANDROID_HOME = $sdkRoot
$env:ANDROID_SDK_ROOT = $sdkRoot

try {
    [Environment]::SetEnvironmentVariable("ANDROID_HOME", $sdkRoot, "Machine")
    [Environment]::SetEnvironmentVariable("ANDROID_SDK_ROOT", $sdkRoot, "Machine")
    
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $pathsToAdd = @(
        "$sdkRoot\cmdline-tools\latest\bin",
        "$sdkRoot\platform-tools",
        "$sdkRoot\build-tools\34.0.0",
        "C:\flutter\bin"
    )
    
    foreach ($pathToAdd in $pathsToAdd) {
        if ($currentPath -notlike "*$pathToAdd*") {
            $currentPath = "$currentPath;$pathToAdd"
        }
    }
    [Environment]::SetEnvironmentVariable("Path", $currentPath, "Machine")
} catch {
    Write-Host "Could not set system environment (may need admin)" -ForegroundColor Yellow
}

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "Environment configured!" -ForegroundColor Green
Write-Host ""

# Configure Flutter
Write-Host "STEP 3: Configuring Flutter..." -ForegroundColor Yellow
& $flutterPath config --android-sdk $sdkRoot 2>&1 | Out-Null
Write-Host "Flutter configured!" -ForegroundColor Green
Write-Host ""

# Install SDK packages
$sdkmanager = "$sdkRoot\cmdline-tools\latest\bin\sdkmanager.bat"

if (-not (Test-Path "$sdkRoot\platforms\android-34")) {
    Write-Host "STEP 4: Installing Android SDK packages..." -ForegroundColor Yellow
    Write-Host "This may take several minutes..." -ForegroundColor Gray
    
    & $sdkmanager --sdk_root=$sdkRoot "platform-tools" "platforms;android-34" "build-tools;34.0.0" 2>&1 | Out-Null
    
    Write-Host "SDK packages installed!" -ForegroundColor Green
    Write-Host ""
}

# Accept licenses
Write-Host "STEP 5: Accepting licenses..." -ForegroundColor Yellow
$licenses = "y`ny`ny`ny`ny`ny`ny`ny`ny`n"
$licenses | & $sdkmanager --sdk_root=$sdkRoot --licenses 2>&1 | Out-Null
Write-Host "Licenses accepted!" -ForegroundColor Green
Write-Host ""

# Build APK
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "STEP 6: Building APK..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Set-Location -Path "taskflow_mobile"

Write-Host "Cleaning..." -ForegroundColor Gray
& $flutterPath clean 2>&1 | Out-Null

Write-Host "Getting dependencies..." -ForegroundColor Gray
& $flutterPath pub get

Write-Host ""
Write-Host "Building release APK (this takes 5-10 minutes)..." -ForegroundColor Yellow
Write-Host ""

& $flutterPath build apk --release

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "SUCCESS!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    $apkPath = "build\app\outputs\flutter-apk\app-release.apk"
    if (Test-Path $apkPath) {
        $fullPath = (Resolve-Path $apkPath).Path
        $size = (Get-Item $apkPath).Length / 1MB
        
        Write-Host "APK built successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Location: $fullPath" -ForegroundColor White
        Write-Host "Size: $("{0:N2} MB" -f $size)" -ForegroundColor White
        Write-Host ""
        Write-Host "Transfer this file to your Android device and install it!" -ForegroundColor Cyan
    }
} else {
    Write-Host ""
    Write-Host "BUILD FAILED!" -ForegroundColor Red
}

Set-Location -Path ".."
Write-Host ""
pause
