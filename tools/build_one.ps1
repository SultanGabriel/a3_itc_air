
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Module,

    [string]$ModFolder = "@itc_air_dev"
)

$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

function Get-RegistryValue {
    param(
        [string]$Path,
        [string]$Name
    )

    try {
        return (Get-ItemProperty -LiteralPath $Path -Name $Name -ErrorAction Stop).$Name
    }
    catch {
        return $null
    }
}

function Find-Arma3Path {
    $Candidates = @(
        @{ Path = "HKLM:\SOFTWARE\WOW6432Node\bohemia interactive\arma 3"; Name = "main" },
        @{ Path = "HKLM:\SOFTWARE\bohemia interactive\arma 3"; Name = "main" },
        @{ Path = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 107410"; Name = "InstallLocation" },
        @{ Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 107410"; Name = "InstallLocation" }
    )

    foreach ($Candidate in $Candidates) {
        $Path = Get-RegistryValue $Candidate.Path $Candidate.Name
        if ($Path -and (Test-Path -LiteralPath (Join-Path $Path "arma3_x64.exe"))) {
            return $Path
        }
    }

    throw "Could not find the Arma 3 installation path."
}

function Find-Arma3ToolsPath {
    $Candidates = @(
        @{ Path = "HKCU:\SOFTWARE\bohemia interactive\arma 3 tools"; Name = "path" },
        @{ Path = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 233800"; Name = "InstallLocation" },
        @{ Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 233800"; Name = "InstallLocation" }
    )

    foreach ($Candidate in $Candidates) {
        $Path = Get-RegistryValue $Candidate.Path $Candidate.Name
        if ($Path -and (Test-Path -LiteralPath (Join-Path $Path "AddonBuilder\AddonBuilder.exe"))) {
            return $Path
        }
    }

    throw "Could not find Arma 3 Tools / AddonBuilder.exe."
}

# Resolve module either as an absolute path or relative to the repository root.
if ([System.IO.Path]::IsPathRooted($Module)) {
    $ModulePath = (Resolve-Path -LiteralPath $Module).Path
}
else {
    $ModulePath = (Resolve-Path -LiteralPath (Join-Path $RepoRoot $Module)).Path
}

if (-not (Test-Path -LiteralPath $ModulePath -PathType Container)) {
    throw "Module does not exist: $ModulePath"
}

$ModuleName = Split-Path -Leaf $ModulePath

if ($ModuleName -notlike "itc_air*") {
    throw "Refusing to build '$ModuleName'. Module name must start with 'itc_air'."
}

if (-not (Test-Path -LiteralPath (Join-Path $ModulePath "config.cpp"))) {
    throw "Module has no config.cpp: $ModulePath"
}

$Arma3Path      = Find-Arma3Path
$Arma3ToolsPath = Find-Arma3ToolsPath
$AddonBuilder   = Join-Path $Arma3ToolsPath "AddonBuilder\AddonBuilder.exe"
$OutputPath     = Join-Path $Arma3Path "$ModFolder\addons"
# output to build/@itc_air_dev/addons instead of @itc_air_dev/addons to avoid issues with Steam Workshop and Arma 3 Launcher
# $OutputPath     = Join-Path $RepoRoot  "$ModFolder\addons"


$TempRoot       = Join-Path $PSScriptRoot ".buildtmp"
$TempOutput     = Join-Path $TempRoot $ModuleName
$BuiltPbo       = Join-Path $TempOutput "$ModuleName.pbo"
$TargetPbo      = Join-Path $OutputPath "$ModuleName.pbo"

New-Item -ItemType Directory -Force -Path $OutputPath | Out-Null

if (Test-Path -LiteralPath $TempOutput) {
    Remove-Item -LiteralPath $TempOutput -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $TempOutput | Out-Null

Write-Host "BUILD  $ModuleName"
Write-Host "  Source : $ModulePath"
Write-Host "  Prefix : $ModuleName"
Write-Host "  Output : $TargetPbo"

# Include file lives beside this script
$IncludeFile = Join-Path $PSScriptRoot "addonbuilder_include.txt"

$Arguments = @(
    $ModulePath,
    $TempOutput,
    "-packonly",
    "-clear",
    "-prefix=$ModuleName",
    "-project=$RepoRoot",
    "-include=$IncludeFile"
)

& $AddonBuilder @Arguments

if ($LASTEXITCODE -ne 0) {
    throw "Addon Builder failed for $ModuleName with exit code $LASTEXITCODE."
}

if (-not (Test-Path -LiteralPath $BuiltPbo)) {
    throw "Addon Builder returned success, but no PBO was produced: $BuiltPbo"
}

# Replace the installed dev PBO only after the new build succeeded.
Copy-Item -LiteralPath $BuiltPbo -Destination $TargetPbo -Force

Write-Host "  Installed: $TargetPbo"
Write-Host ""

Write-Host "OK     $ModuleName"
