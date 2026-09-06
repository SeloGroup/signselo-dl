<#
.SYNOPSIS
    SignSelo Native Agent Uninstaller for Windows
.DESCRIPTION
    Safely stops, uninstalls the Windows Service, and removes the installation directory.
.EXAMPLE
    irm https://raw.githubusercontent.com/SeloGroup/signselo-dl/main/windows/uninstall.ps1 | iex
#>

[CmdletBinding()]
param(
    [string]$InstallDir = "$env:ProgramFiles\SignSelo"
)

$ErrorActionPreference = "SilentlyContinue"

Write-Host "Uninstalling SignSelo Native Agent..." -ForegroundColor Yellow

$targetExe = Join-Path $InstallDir "SignSelo-Agent.exe"
if (Test-Path $targetExe) {
    & "$targetExe" service stop
    Start-Sleep -Seconds 1
    & "$targetExe" service uninstall
} else {
    Stop-Service -Name "SignSeloAgent" -Force
    sc.exe delete "SignSeloAgent"
}

Start-Sleep -Seconds 2

if (Test-Path $InstallDir) {
    Remove-Item -Path $InstallDir -Recurse -Force
}

Write-Host "SignSelo Native Agent has been completely removed from this system." -ForegroundColor Green
