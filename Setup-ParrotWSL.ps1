# ==============================================================================
# Setup-ParrotWSL.ps1
# Run this from PowerShell before anything else.
# Detects Parrot WSL, installs it if missing, clones the toolkit into Linux
# home, then drops you straight in ready to run the installer.
# ==============================================================================

$ErrorActionPreference = "SilentlyContinue"

$REPO_URL  = "https://github.com/NewLouwa/WSL-Parrot-Security.git"
$REPO_NAME = "WSL-Parrot-Security"

function Write-OK   { Write-Host "[+] $args" -ForegroundColor Green }
function Write-Warn { Write-Host "[!] $args" -ForegroundColor Yellow }
function Write-Info { Write-Host "[*] $args" -ForegroundColor Cyan }

Write-Host ""
Write-Info "Parrot WSL Setup"
Write-Info "================"
Write-Host ""

# Check if Parrot is already installed
# wsl --list outputs UTF-16 LE with null bytes between chars - strip them first
$oldEncoding = [Console]::OutputEncoding
[Console]::OutputEncoding = [System.Text.Encoding]::Unicode
$distros = wsl --list --quiet 2>$null
[Console]::OutputEncoding = $oldEncoding
$distros = $distros | ForEach-Object { $_ -replace "`0","" } | Where-Object { $_ -ne "" }
$parrot  = ($distros | Where-Object { $_ -match 'parrot' } | Select-Object -First 1)

if (-not $parrot) {
    Write-Warn "Parrot WSL not found."
    Write-Host ""
    Write-Info "Opening the Parrot download page..."
    Start-Process "https://www.parrotsec.org/download/?version=wsl"
    Write-Host ""
    Write-Host "  Follow these steps:" -ForegroundColor White
    Write-Host ""
    Write-Host "  1. On the page that just opened, click:" -ForegroundColor White
    Write-Host "     'Windows Subsystem for Linux (WSL) - Lightweight base system'" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  2. Once downloaded, double-click the file." -ForegroundColor White
    Write-Host "     Windows will import it automatically." -ForegroundColor White
    Write-Host ""
    Write-Host "  3. Run this script again - it will handle the rest." -ForegroundColor White
    Write-Host ""
    exit 0
}

$distroName = $parrot.Trim()
Write-OK "Parrot WSL found: $distroName"
Write-Host ""

# Check if toolkit already cloned in WSL home
# Use test -d and $LASTEXITCODE to avoid && / || which PowerShell 5.1 misparses
wsl -d $distroName -- test -d "~/$REPO_NAME"
$alreadyCloned = ($LASTEXITCODE -eq 0)

# Fix sudo hostname warning before anything else runs
# Adds the WSL hostname to /etc/hosts so sudo doesn't complain
wsl -d $distroName -- bash -c "HN=`$(hostname); grep -q `"`$HN`" /etc/hosts 2>/dev/null || echo `"127.0.0.1 `$HN`" | tee -a /etc/hosts > /dev/null"
Write-OK "Hostname fix applied (/etc/hosts)"

if (-not $alreadyCloned) {
    Write-Info "Cloning toolkit into Linux home (not /mnt/c - Linux filesystem only)..."
    wsl -d $distroName -- bash -c "cd ~; git clone --depth 1 $REPO_URL"
    Write-OK "Cloned to ~/$REPO_NAME"
} else {
    Write-OK "Toolkit already at ~/$REPO_NAME"
    Write-Info "Pulling latest..."
    wsl -d $distroName -- bash -c "cd ~/$REPO_NAME; git pull --ff-only"
}

Write-Host ""
Write-OK "Opening Parrot in your home directory."
Write-Host ""
Write-Host "  Run this to install everything:" -ForegroundColor White
Write-Host "  sudo bash $REPO_NAME/install-toolkit.sh" -ForegroundColor Cyan
Write-Host ""

wsl -d $distroName --cd "~"
