# Flutter Auto-Installer for Windows
# Run this script as Administrator

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Flutter Auto-Installer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$flutterVersion = "3.24.5"
$flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_$flutterVersion-stable.zip"
$installPath = "C:\flutter"
$zipPath = "$env:TEMP\flutter.zip"

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "WARNING: Not running as Administrator" -ForegroundColor Yellow
    Write-Host "You may need to manually add Flutter to PATH" -ForegroundColor Yellow
    Write-Host ""
}

# Check if Flutter already exists
if (Test-Path "$installPath\bin\flutter.bat") {
    Write-Host "Flutter is already installed at $installPath" -ForegroundColor Green
    & "$installPath\bin\flutter.bat" --version
    Write-Host ""
    $response = Read-Host "Do you want to reinstall? (y/n)"
    if ($response -ne "y") {
        exit 0
    }
}

# Download Flutter
Write-Host "Downloading Flutter SDK..." -ForegroundColor Yellow
Write-Host "URL: $flutterUrl" -ForegroundColor Gray
Write-Host "This may take several minutes (approx 1GB download)..." -ForegroundColor Gray
Write-Host ""

try {
    # Use BITS transfer for better download handling
    Import-Module BitsTransfer
    Start-BitsTransfer -Source $flutterUrl -Destination $zipPath -Description "Downloading Flutter SDK"
} catch {
    Write-Host "BITS transfer failed, trying WebClient..." -ForegroundColor Yellow
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($flutterUrl, $zipPath)
}

Write-Host "Download complete!" -ForegroundColor Green
Write-Host ""

# Extract Flutter
Write-Host "Extracting Flutter to $installPath..." -ForegroundColor Yellow

if (Test-Path $installPath) {
    Write-Host "Removing existing Flutter installation..." -ForegroundColor Yellow
    Remove-Item -Path $installPath -Recurse -Force
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, "C:\")

Write-Host "Extraction complete!" -ForegroundColor Green
Write-Host ""

# Add to PATH
Write-Host "Adding Flutter to PATH..." -ForegroundColor Yellow

$flutterBinPath = "$installPath\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

if ($currentPath -notlike "*$flutterBinPath*") {
    if ($isAdmin) {
        try {
            [Environment]::SetEnvironmentVariable(
                "Path",
                "$currentPath;$flutterBinPath",
                "Machine"
            )
            Write-Host "Flutter added to system PATH!" -ForegroundColor Green
        } catch {
            Write-Host "Could not add to system PATH automatically" -ForegroundColor Yellow
            Write-Host "Please add manually: $flutterBinPath" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Cannot modify system PATH without Administrator privileges" -ForegroundColor Yellow
        Write-Host "Please add manually: $flutterBinPath" -ForegroundColor Yellow
    }
} else {
    Write-Host "Flutter is already in PATH" -ForegroundColor Green
}

Write-Host ""

# Refresh environment
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Clean up
Write-Host "Cleaning up..." -ForegroundColor Yellow
Remove-Item $zipPath -Force

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Flutter Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Run flutter doctor
Write-Host "Running Flutter Doctor..." -ForegroundColor Yellow
Write-Host ""
& "$installPath\bin\flutter.bat" doctor

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "1. Close and reopen your terminal/command prompt" -ForegroundColor White
Write-Host "2. Run: flutter doctor --android-licenses" -ForegroundColor White
Write-Host "3. Run: BUILD_APK.bat to build your app" -ForegroundColor White
Write-Host ""
Write-Host "If 'flutter' command is not found, you may need to:" -ForegroundColor Yellow
Write-Host "- Restart your computer" -ForegroundColor Yellow
Write-Host "- Manually add to PATH: $flutterBinPath" -ForegroundColor Yellow
Write-Host ""

pause
