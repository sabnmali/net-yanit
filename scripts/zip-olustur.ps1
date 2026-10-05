# claude.ai'ye yüklenecek skill paketini üretir: dist/net-yanit.zip
# Kullanım (repo kökünden):  powershell -ExecutionPolicy Bypass -File scripts/zip-olustur.ps1
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$src  = Join-Path $root 'claudeai\net-yanit'
$dist = Join-Path $root 'dist'
New-Item -ItemType Directory -Force -Path $dist | Out-Null
$zip  = Join-Path $dist 'net-yanit.zip'
if (Test-Path $zip) { Remove-Item $zip -Force }
# Zip içinde klasör adı skill adıyla aynı olmalı: net-yanit/SKILL.md
Compress-Archive -Path $src -DestinationPath $zip
Write-Output "Hazır: $zip"
