[CmdletBinding()]
param(
    [switch]$Force,
    [string]$ModFolder = "@itc_air_dev"
)

$ErrorActionPreference = "Stop"

$RepoRoot   = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$BuildOne   = Join-Path $PSScriptRoot "build_one.ps1"
$CachePath  = Join-Path $PSScriptRoot ".buildcache.json"

if (-not (Test-Path -LiteralPath $BuildOne)) {
    throw "Missing build script: $BuildOne"
}

function Get-ModuleHash {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ModulePath
    )

    $ModuleRoot = (Resolve-Path -LiteralPath $ModulePath).Path

    $Files = Get-ChildItem -LiteralPath $ModuleRoot -File -Recurse |
        Sort-Object FullName

    # Hash the relative path and the SHA-256 of every file.
    # This detects changed, added, deleted, and renamed files.
    $Entries = foreach ($File in $Files) {
        $RelativePath = $File.FullName.Substring($ModuleRoot.Length).TrimStart('\', '/')
        $RelativePath = $RelativePath.Replace('\', '/')
        $FileHash = (Get-FileHash -LiteralPath $File.FullName -Algorithm SHA256).Hash

        "$RelativePath|$FileHash"
    }

    $Text = $Entries -join "`n"
    $Bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
    $Sha256 = [System.Security.Cryptography.SHA256]::Create()

    try {
        $HashBytes = $Sha256.ComputeHash($Bytes)
        return ([System.BitConverter]::ToString($HashBytes)).Replace("-", "")
    }
    finally {
        $Sha256.Dispose()
    }
}

function Read-BuildCache {
    $Cache = @{}

    if (-not (Test-Path -LiteralPath $CachePath)) {
        return $Cache
    }

    try {
        $Data = Get-Content -LiteralPath $CachePath -Raw | ConvertFrom-Json

        foreach ($Entry in @($Data.modules)) {
            if ($null -ne $Entry.name -and $null -ne $Entry.hash) {
                $Cache[$Entry.name] = $Entry.hash
            }
        }
    }
    catch {
        Write-Warning "Could not read build cache. A full incremental rebuild will be required."
    }

    return $Cache
}

function Write-BuildCache {
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$Cache
    )

    $Modules = @(
        foreach ($Name in ($Cache.Keys | Sort-Object)) {
            [PSCustomObject]@{
                name = $Name
                hash = $Cache[$Name]
            }
        }
    )

    $Data = [PSCustomObject]@{
        version = 1
        modules = $Modules
    }

    $Data |
        ConvertTo-Json -Depth 4 |
        Set-Content -LiteralPath $CachePath -Encoding UTF8
}

$Modules = @(
    Get-ChildItem -LiteralPath $RepoRoot -Directory |
        Where-Object { $_.Name -like "itc_air*" } |
        Sort-Object Name
)

if ($Modules.Count -eq 0) {
    throw "No top-level itc_air* modules found in $RepoRoot"
}

$Cache = Read-BuildCache
$CurrentModuleNames = @($Modules | ForEach-Object { $_.Name })

Write-Host ""
Write-Host "ITC Air incremental build"
Write-Host "Repository: $RepoRoot"
Write-Host "Modules:    $($Modules.Count)"
Write-Host ""

# Report modules that were in the previous build cache but no longer exist.
foreach ($CachedName in ($Cache.Keys | Sort-Object)) {
    if ($CachedName -notin $CurrentModuleNames) {
        Write-Host "REMOVED $CachedName  (source missing; PBO is not deleted)"
    }
}

$ChangedModules = @()
$CurrentHashes = @{}

foreach ($Module in $Modules) {
    $Hash = Get-ModuleHash -ModulePath $Module.FullName
    $CurrentHashes[$Module.Name] = $Hash

    if ($Force) {
        Write-Host "FORCE   $($Module.Name)"
        $ChangedModules += $Module
        continue
    }

    if (-not $Cache.ContainsKey($Module.Name)) {
        Write-Host "NEW     $($Module.Name)"
        $ChangedModules += $Module
        continue
    }

    if ($Cache[$Module.Name] -ne $Hash) {
        Write-Host "CHANGED $($Module.Name)"
        $ChangedModules += $Module
        continue
    }

    Write-Host "OK      $($Module.Name)"
}

Write-Host ""

if ($ChangedModules.Count -eq 0) {
    Write-Host "Nothing to build."
    return
}

Write-Host "$($ChangedModules.Count) module(s) need a build."
Write-Host ""

$FailedModules = @()

foreach ($Module in $ChangedModules) {
    try {
        & $BuildOne -Module $Module.FullName -ModFolder $ModFolder

        # Only store the new hash after the build completed successfully.
        $Cache[$Module.Name] = $CurrentHashes[$Module.Name]
        Write-BuildCache -Cache $Cache
    }
    catch {
        $FailedModules += $Module.Name
        Write-Host "FAILED $($Module.Name)"
        Write-Host "  $($_.Exception.Message)"
    }

    Write-Host ""
}

if ($FailedModules.Count -gt 0) {
    throw "Build failed for: $($FailedModules -join ', ')"
}

Write-Host "Build complete."
