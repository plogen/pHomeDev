#!/usr/bin/env pwsh
# setup-windows.ps1 — Install and configure dev environment on Windows
# Run from the root of the pHomeDev repo:
#   .\setup-windows.ps1

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$REPO = $PSScriptRoot

# ── Scoop (user-scope package manager, no elevation needed) ──────────────────
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Scoop ..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","User") + ";" + $env:PATH
} else {
    Write-Host "Scoop already installed, skipping."
}

function Install-Scoop($package, $name, $bucket = $null) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
        if ($bucket) { scoop bucket add $bucket 2>$null }
        Write-Host "Installing $package (scoop) ..."
        scoop install $package
    } else {
        Write-Host "$name already installed, skipping."
    }
}

function Install-Winget($id, $name) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
        Write-Host "Installing $id (winget) ..."
        winget install --id $id --scope user --silent --accept-source-agreements --accept-package-agreements
    } else {
        Write-Host "$name already installed, skipping."
    }
}

# ── Tools ────────────────────────────────────────────────────────────────────
# wezterm and neovim only have machine-scope winget installers; use Scoop instead
Install-Scoop "wezterm" "wezterm" "extras"
Install-Scoop "neovim"  "nvim"
Install-Scoop "mingw"   "gcc"     # C compiler required by Neovim treesitter/LSP
Install-Winget "GitHub.cli" "gh"
Install-Winget "Git.Git"    "git"

# Nerd Font via Scoop nerd-fonts bucket (user-scoped, no elevation)
Write-Host "Installing JetBrainsMono Nerd Font (scoop) ..."
scoop bucket add nerd-fonts 2>$null
scoop install nerd-fonts/JetBrainsMono-NF 2>$null; $true

# Refresh PATH so new installs are visible
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("PATH","User")

# ── WezTerm config ────────────────────────────────────────────────────────────
$weztermCfg = "$env:USERPROFILE\.wezterm.lua"
$weztermSrc = Join-Path $REPO "wezterm\wezterm.lua"
if (Test-Path $weztermCfg) {
    Remove-Item $weztermCfg -Force
}
# Hard link (no admin required); edits in the repo are reflected immediately
New-Item -ItemType HardLink -Path $weztermCfg -Target $weztermSrc | Out-Null
Write-Host "WezTerm config -> $weztermCfg (hard link -> $weztermSrc)"

# ── Neovim config ─────────────────────────────────────────────────────────────
$nvimCfgDir = "$env:LOCALAPPDATA\nvim"
$nvimSrc    = Join-Path $REPO "nvim"
if (Test-Path $nvimCfgDir) {
    Write-Host "Backing up existing Neovim config to $nvimCfgDir.bak"
    if (Test-Path "$nvimCfgDir.bak") { Remove-Item "$nvimCfgDir.bak" -Recurse -Force }
    Move-Item $nvimCfgDir "$nvimCfgDir.bak" -Force
}
# Symlink so edits in the repo are reflected immediately
New-Item -ItemType Junction -Path $nvimCfgDir -Target $nvimSrc | Out-Null
Write-Host "Neovim config -> $nvimCfgDir (junction -> $nvimSrc)"

Write-Host ""
Write-Host "Done! Open WezTerm, then run 'nvim' to trigger LazyVim bootstrap."
