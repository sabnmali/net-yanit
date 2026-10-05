# claude.ai'ye yüklenecek skill paketini üretir: dist/net-yanit.zip
# Kullanım (repo kökünden):  powershell -ExecutionPolicy Bypass -File scripts/zip-olustur.ps1
# Not: Compress-Archive (PowerShell 5.1) zip içine "\" ile yol yazar; claude.ai bunu reddeder.
# Bu yüzden yollar elle "/" ile yazılıyor.
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
$root = Split-Path -Parent $PSScriptRoot
$src  = Join-Path $root 'claudeai\net-yanit'
$dist = Join-Path $root 'dist'
New-Item -ItemType Directory -Force -Path $dist | Out-Null
$zip  = Join-Path $dist 'net-yanit.zip'
if (Test-Path $zip) { Remove-Item $zip -Force }

$archive = [System.IO.Compression.ZipFile]::Open($zip, 'Create')
try {
  Get-ChildItem -Path $src -Recurse -File | ForEach-Object {
    $rel = $_.FullName.Substring($src.Length).TrimStart('\').Replace('\', '/')
    # Zip içinde klasör adı skill adıyla aynı olmalı: net-yanit/SKILL.md
    $entry = 'net-yanit/' + $rel
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $_.FullName, $entry) | Out-Null
  }
} finally { $archive.Dispose() }
Write-Output "Hazir: $zip"
