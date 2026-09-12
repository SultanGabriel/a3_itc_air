# RUN CMD: .\tools\build.ps1 -AddonBuilder "S:\SteamLibrary\steamapps\common\Arma 3 Tools\AddonBuilder\AddonBuilder.exe"

param(
    [Parameter(Mandatory = $true)]
    [string]$AddonBuilder
)

$ErrorActionPreference = "Stop"

# ------------------------------------------------------------
# Paths
# ------------------------------------------------------------

$RepoRoot = (Resolve-Path "$PSScriptRoot\..").Path

# build outside repo
$RepoParent = Split-Path $RepoRoot -Parent
$BuildRoot  = Join-Path $RepoParent "build"

$ModRoot    = Join-Path $BuildRoot "@itc_air_dev"
$AddonsDir  = Join-Path $ModRoot "addons"
$TempRoot   = Join-Path $BuildRoot "_temp"

# Include file lives beside this script
$IncludeFile = Join-Path $PSScriptRoot "addonbuilder_include.txt"


# ------------------------------------------------------------
# Validate
# ------------------------------------------------------------

if (-not (Test-Path $AddonBuilder)) {
    throw "AddonBuilder.exe not found: $AddonBuilder"
}

if (-not (Test-Path $IncludeFile)) {
    throw "Include file not found: $IncludeFile"
}

New-Item -ItemType Directory -Force $AddonsDir | Out-Null
New-Item -ItemType Directory -Force $TempRoot  | Out-Null


# ------------------------------------------------------------
# Find addons
#
# An addon is any direct child folder containing config.cpp
# ------------------------------------------------------------

$AddonFolders = @(
    Get-ChildItem `
        -Path $RepoRoot `
        -Directory |
    Where-Object {
        Test-Path (Join-Path $_.FullName "config.cpp")
    } |
    Sort-Object Name
)

if ($AddonFolders.Count -eq 0) {
    throw "No addon folders containing config.cpp found."
}


Write-Host ""
Write-Host "ITC Air development build"
Write-Host "========================="
Write-Host ""
Write-Host "Repository:"
Write-Host "  $RepoRoot"
Write-Host ""
Write-Host "Output:"
Write-Host "  $ModRoot"
Write-Host ""
Write-Host "Found $($AddonFolders.Count) addons:"
Write-Host ""

foreach ($Addon in $AddonFolders) {
    Write-Host "  $($Addon.Name)"
}

Write-Host ""


# ------------------------------------------------------------
# Clean old build
# ------------------------------------------------------------

Get-ChildItem `
    -Path $AddonsDir `
    -Filter "*.pbo" `
    -File `
    -ErrorAction SilentlyContinue |
    Remove-Item -Force


# ------------------------------------------------------------
# Build every addon
# ------------------------------------------------------------

$Built = @()
$Failed = @()

foreach ($Addon in $AddonFolders) {

    $Name   = $Addon.Name
    $Source = $Addon.FullName

    $OutputPbo = Join-Path $AddonsDir ""
    $TempDir   = Join-Path $TempRoot $Name

    # Ensure this addon gets a completely clean temp directory
    Remove-Item `
        -Path $TempDir `
        -Recurse `
        -Force `
        -ErrorAction SilentlyContinue

    New-Item `
        -ItemType Directory `
        -Force `
        -Path $TempDir |
        Out-Null


    Write-Host ""
    Write-Host "----------------------------------------"
    Write-Host "Building: $Name"
    Write-Host "Source:   $Source"
    Write-Host "Prefix:   $Name"
    Write-Host "Output:   $OutputPbo"
    Write-Host "----------------------------------------"
    Write-Host ""


    # IMPORTANT:
    #
    # Each addon gets its OWN prefix.
    #
    # itc_air_sys_fcs.pbo -> prefix itc_air_sys_fcs
    # itc_air_mfd.pbo     -> prefix itc_air_mfd
    # itc_air.pbo         -> prefix itc_air
    #
    # This matches paths used throughout the configs.

    & $AddonBuilder `
        $Source `
        $OutputPbo `
        "-packonly" `
        "-clear" `
        "-temp=$TempDir" `
        "-project=$Source" `
        "-prefix=$Name" `
        "-include=$IncludeFile"


    # AddonBuilder has been observed not to reliably communicate
    # failure through the process exit code, so verify the file.
    if (Test-Path $OutputPbo) {

        $Pbo = Get-Item $OutputPbo

        Write-Host ""
        Write-Host "OK: $Name"
        Write-Host "    $([math]::Round($Pbo.Length / 1KB, 1)) KB"

        $Built += $Name

    }
    else {

        Write-Host ""
        Write-Host "FAILED: $Name"

        $Failed += $Name
    }
}


# ------------------------------------------------------------
# Summary
# ------------------------------------------------------------

Write-Host ""
Write-Host ""
Write-Host "========================================"
Write-Host "Build summary"
Write-Host "========================================"
Write-Host ""

Write-Host "Built: $($Built.Count)"

foreach ($Name in $Built) {
    Write-Host "  OK  $Name"
}

if ($Failed.Count -gt 0) {

    Write-Host ""
    Write-Host "Failed: $($Failed.Count)"

    foreach ($Name in $Failed) {
        Write-Host "  ERR $Name"
    }

    throw "$($Failed.Count) addon(s) failed to build."
}

Write-Host ""
Write-Host "All addons built successfully."
Write-Host ""
Write-Host "Local mod:"
Write-Host "  $ModRoot"
Write-Host ""