<#
.SYNOPSIS
    Synchronize build artifacts from SignSelo core repository to SignSelo-DL release repo.
.DESCRIPTION
    Copies latest binaries, packages zip files, updates checksums, and stages git release.
#>

[CmdletBinding()]
param(
    [string]$CoreRepoDir = "d:\Developnet\SignSelo.Com",
    [string]$ReleaseRepoDir = "d:\Developnet\signselo-dl"
)

$ErrorActionPreference = "Stop"

Write-Host "Syncing release artifacts..." -ForegroundColor Cyan

$srcExe = Join-Path $CoreRepoDir "api\bin\SignSelo-Agent.exe"
$srcZip = Join-Path $CoreRepoDir "api\bin\SignSelo-Agent-v3.0.0-win64.zip"

if (Test-Path $srcExe) {
    Copy-Item $srcExe (Join-Path $ReleaseRepoDir "windows\SignSelo-Agent.exe") -Force
    Write-Host "Copied: SignSelo-Agent.exe" -ForegroundColor Green
}

if (Test-Path $srcZip) {
    Copy-Item $srcZip (Join-Path $ReleaseRepoDir "windows\SignSelo-Agent-v3.0.0-win64.zip") -Force
    Write-Host "Copied: SignSelo-Agent-v3.0.0-win64.zip" -ForegroundColor Green
}

# Update CHECKSUMS.sha256
$hashes = @()
Get-ChildItem -Path (Join-Path $ReleaseRepoDir "windows") -File | ForEach-Object {
    $h = Get-FileHash -Algorithm SHA256 $_.FullName
    $rel = "windows/" + $_.Name
    $hashes += "$($h.Hash.ToLower())  $rel"
}

$checksumFile = Join-Path $ReleaseRepoDir "CHECKSUMS.sha256"
$header = "# SignSelo Distribution Hub SHA-256 Checksums`n# Format: <sha256-hash>  <relative-path>`n`n"
Set-Content -Path $checksumFile -Value ($header + ($hashes -join "`n")) -Encoding UTF8
Write-Host "Updated CHECKSUMS.sha256" -ForegroundColor Green
