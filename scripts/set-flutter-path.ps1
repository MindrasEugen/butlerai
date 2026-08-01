# PowerShell script to set Flutter path
# Usage: .\scripts\set-flutter-path.ps1

$flutterPath = "C:\src\flutter\flutter\bin"

# Add to PATH if not already present
if ($env:PATH -notlike "*$flutterPath*") {
    $env:PATH = "$flutterPath;$env:PATH"
    Write-Host "✅ Flutter path added to PATH: $flutterPath"
} else {
    Write-Host "ℹ Flutter path already in PATH"
}

# Verify
flutter --version
