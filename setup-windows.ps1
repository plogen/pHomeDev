#!/usr/bin/env pwsh
# setup-windows.ps1 — Install and configure dev environment on Windows
# Run from the root of the pHomeDev repo:
#   .\setup-windows.ps1

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$REPO = $PSScriptRoot

function Install-IfMissing($id, $name) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
        Write-Host "Installing $id ..."
        winget install --id $id --silent --accept-source-agreements --accept-package-agreements
    } else {
        Write-Host "$name already installed, skipping."
    }
}

# ── Tools ────────────────────────────────────────────────────────────────────
Install-IfMissing "wez.wezterm"       "wezterm"
Install-IfMissing "Neovim.Neovim"     "nvim"
Install-IfMissing "GitHub.cli"        "gh"
Install-IfMissing "Git.Git"           "git"
# Nerd Font for icons (JetBrainsMono Nerd Font) — no CLI to check, always attempt
Write-Host "Installing JetBrainsMono Nerd Font (skipped if already present by winget) ..."
winget install --id DEVCOM.JetBrainsMonoNerdFont --silent --accept-source-agreements --accept-package-agreements 2>$null; $true

# Refresh PATH so new installs are visible
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("PATH","User")

# ── WezTerm config ────────────────────────────────────────────────────────────
$weztermCfg = "$env:USERPROFILE\.wezterm.lua"
$weztermSrc = Join-Path $REPO "wezterm\wezterm.lua"
if (Test-Path $weztermCfg) {
    Write-Host "Backing up existing WezTerm config to $weztermCfg.bak"
    Copy-Item $weztermCfg "$weztermCfg.bak" -Force
}
Copy-Item $weztermSrc $weztermCfg -Force
Write-Host "WezTerm config -> $weztermCfg"

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
