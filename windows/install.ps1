<#
.SYNOPSIS
    SignSelo Native Agent Automated Installer for Windows (x64)
.DESCRIPTION
    Installs SignSelo Next-Gen Standalone Smart Card & eID Agent as a background Windows Service.
    Zero-Extension Architecture (No Chrome Extension or Java runtime required).
.EXAMPLE
    irm https://raw.githubusercontent.com/SeloGroup/signselo-dl/main/windows/install.ps1 | iex
#>

[CmdletBinding()]
param(
    [string]$InstallDir = "$env:ProgramFiles\SignSelo",
    [string]$HubUrl = "https://signselo.com",
    [switch]$NoService
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  SignSelo Native Agent v3.0 - Enterprise Setup" -ForegroundColor Cyan
Write-Host "  Selo Group Systems Architecture (c) 2026" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# Verify Administrative Privileges
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Warning "Administrative privileges required. Relaunching elevated..."
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"& { [ScriptBlock]::Create((irm 'https://raw.githubusercontent.com/SeloGroup/signselo-dl/main/windows/install.ps1')) }`""
    exit
}

# Create Installation Directory
if (-not (Test-Path $InstallDir)) {
    Write-Host "[1/5] Creating directory: $InstallDir" -ForegroundColor Green
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

# Stop existing service if running
$existingService = Get-Service -Name "SignSeloAgent" -ErrorAction SilentlyContinue
if ($existingService -and $existingService.Status -eq 'Running') {
    Write-Host "[2/5] Stopping active SignSeloAgent service..." -ForegroundColor Yellow
    Stop-Service -Name "SignSeloAgent" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
}

# Download or Copy Binary
$targetExe = Join-Path $InstallDir "SignSelo-Agent.exe"
Write-Host "[3/5] Deploying SignSelo-Agent.exe..." -ForegroundColor Green

$downloadUrl = "https://raw.githubusercontent.com/SeloGroup/signselo-dl/main/windows/SignSelo-Agent.exe"
try {
    # Check if local file exists alongside the script (offline package)
    $localExe = Join-Path $PSScriptRoot "SignSelo-Agent.exe"
    if (Test-Path $localExe) {
        Copy-Item -Path $localExe -Destination $targetExe -Force
    } else {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $targetExe -UseBasicParsing
    }
} catch {
    Write-Error "Failed to acquire SignSelo-Agent.exe: $_"
    exit 1
}

# Generate Configuration
$configPath = Join-Path $InstallDir "config.toml"
if (-not (Test-Path $configPath)) {
    Write-Host "[4/5] Generating config.toml..." -ForegroundColor Green
    $configContent = @"
[agent]
name = "$env:COMPUTERNAME-SignSelo"
ws_url = "$HubUrl/api/connector/stream"
reconnect_interval_secs = 5
max_reconnect_interval_secs = 60
ping_interval_secs = 30

[card]
auto_detect = true
pnp_interval_ms = 1000

[security]
tls_verify = true
"@
    Set-Content -Path $configPath -Value $configContent -Encoding UTF8
}

# Service Management
if (-not $NoService) {
    Write-Host "[5/5] Registering and Starting Windows Service..." -ForegroundColor Green
    
    # Use native CLI service command
    & "$targetExe" service install
    Start-Sleep -Milliseconds 500
    & "$targetExe" service start
    Start-Sleep -Seconds 1
    
    $svc = Get-Service -Name "SignSeloAgent" -ErrorAction SilentlyContinue
    if ($svc -and $svc.Status -eq 'Running') {
        Write-Host "==========================================================" -ForegroundColor Green
        Write-Host "  SUCCESS: SignSelo Agent is active as a Windows Service!" -ForegroundColor Green
        Write-Host "  Binary:  $targetExe" -ForegroundColor Gray
        Write-Host "  Config:  $configPath" -ForegroundColor Gray
        Write-Host "  Status:  Running (Automatic Startup)" -ForegroundColor Green
        Write-Host "==========================================================" -ForegroundColor Green
    } else {
        Write-Warning "Service was installed but status is not 'Running'. Attempting manual start..."
        Start-Service -Name "SignSeloAgent" -ErrorAction SilentlyContinue
    }
} else {
    Write-Host "Agent installed in standalone mode. Run: $targetExe" -ForegroundColor Cyan
}
