$ErrorActionPreference = "SilentlyContinue"

function Get-RegValue {
    param(
        [string]$Key,
        [string]$Value
    )

    try {
        return (Get-ItemProperty -LiteralPath $Key -Name $Value).$Value
    }
    catch {
        return $null
    }
}


# ------------------------------------------------------------
# Arma 3
# ------------------------------------------------------------

$Arma3Path = Get-RegValue `
    "HKLM:\SOFTWARE\WOW6432Node\bohemia interactive\arma 3" `
    "main"

if (-not $Arma3Path) {
    $Arma3Path = Get-RegValue `
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 107410" `
        "InstallLocation"
}


# ------------------------------------------------------------
# Arma 3 Tools
# ------------------------------------------------------------

$Arma3ToolsPath = Get-RegValue `
    "HKCU:\SOFTWARE\bohemia interactive\arma 3 tools" `
    "path"

if (-not $Arma3ToolsPath) {
    $Arma3ToolsPath = Get-RegValue `
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 233800" `
        "InstallLocation"
}


# ------------------------------------------------------------
# Tools
# ------------------------------------------------------------

if ($Arma3ToolsPath) {
    $AddonBuilder = Join-Path $Arma3ToolsPath "AddonBuilder\AddonBuilder.exe"
    $CfgConvert   = Join-Path $Arma3ToolsPath "CfgConvert\CfgConvert.exe"
    $FileBank     = Join-Path $Arma3ToolsPath "FileBank\FileBank.exe"
    $DSSignFile   = Join-Path $Arma3ToolsPath "DSSignFile\DSSignFile.exe"
}
else {
    $AddonBuilder = $null
    $CfgConvert   = $null
    $FileBank     = $null
    $DSSignFile   = $null
}


# ------------------------------------------------------------
# Print
# ------------------------------------------------------------

Write-Host ""
Write-Host "Arma 3:"
Write-Host "  $Arma3Path"

Write-Host ""
Write-Host "Arma 3 Tools:"
Write-Host "  $Arma3ToolsPath"

Write-Host ""
Write-Host "Addon Builder:"
Write-Host "  $AddonBuilder"

Write-Host ""
Write-Host "CfgConvert:"
Write-Host "  $CfgConvert"

Write-Host ""
Write-Host "FileBank:"
Write-Host "  $FileBank"

Write-Host ""
Write-Host "DSSignFile:"
Write-Host "  $DSSignFile"

Write-Host ""