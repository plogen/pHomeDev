#!/usr/bin/env bash
# setup-linux.sh — Install and configure dev environment on Linux
# Run from the root of the pHomeDev repo:
#   bash setup-linux.sh

set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Detect package manager ────────────────────────────────────────────────────
if command -v apt-get &>/dev/null; then
    PM="apt"
elif command -v dnf &>/dev/null; then
    PM="dnf"
elif command -v pacman &>/dev/null; then
    PM="pacman"
elif command -v brew &>/dev/null; then
    PM="brew"
else
    echo "Unsupported package manager. Install Neovim and WezTerm manually." >&2
    exit 1
fi

install_pkg() {
    case "$PM" in
        apt)    sudo apt-get install -y "$@" ;;
        dnf)    sudo dnf install -y "$@" ;;
        pacman) sudo pacman -S --noconfirm "$@" ;;
        brew)   brew install "$@" ;;
    esac
}

# ── Tools ─────────────────────────────────────────────────────────────────────
echo "==> Installing Neovim ..."
if ! command -v nvim &>/dev/null; then
    case "$PM" in
        apt)
            sudo add-apt-repository ppa:neovim-ppa/unstable -y
            sudo apt-get update
            install_pkg neovim ;;
        dnf)    install_pkg neovim ;;
        pacman) install_pkg neovim ;;
        brew)   brew install neovim ;;
    esac
else
    echo "nvim already installed, skipping."
fi

echo "==> Installing WezTerm ..."
if ! command -v wezterm &>/dev/null; then
    case "$PM" in
        apt)
            curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor \
                -o /usr/share/keyrings/wezterm-fury.gpg
            echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' \
                | sudo tee /etc/apt/sources.list.d/wezterm.list
            sudo apt-get update
            install_pkg wezterm ;;
        dnf)
            sudo dnf copr enable wez/wezterm -y
            install_pkg wezterm ;;
        pacman) install_pkg wezterm ;;
        brew)   brew install --cask wezterm ;;
    esac
else
    echo "wezterm already installed, skipping."
fi

echo "==> Installing GitHub CLI ..."
if ! command -v gh &>/dev/null; then
    case "$PM" in
        apt)
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
                | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list
            sudo apt-get update
            install_pkg gh ;;
        dnf)    install_pkg gh ;;
        pacman) install_pkg github-cli ;;
        brew)   brew install gh ;;
    esac
else
    echo "gh already installed, skipping."
fi

echo "==> Installing JetBrainsMono Nerd Font ..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
if ! fc-list | grep -qi "JetBrainsMono"; then
    curl -fLo /tmp/JetBrainsMono.zip \
        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -q /tmp/JetBrainsMono.zip -d "$FONT_DIR/JetBrainsMono"
    fc-cache -fv
else
    echo "JetBrainsMono Nerd Font already installed, skipping."
fi

# ── WezTerm config ─────────────────────────────────────────────────────────────
WEZTERM_CFG="$HOME/.wezterm.lua"
if [[ -f "$WEZTERM_CFG" ]]; then
    echo "Backing up existing WezTerm config to $WEZTERM_CFG.bak"
    cp "$WEZTERM_CFG" "$WEZTERM_CFG.bak"
fi
ln -sf "$REPO/wezterm/wezterm.lua" "$WEZTERM_CFG"
echo "WezTerm config -> $WEZTERM_CFG (symlink)"

# ── Neovim config ─────────────────────────────────────────────────────────────
NVIM_CFG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
if [[ -d "$NVIM_CFG_DIR" && ! -L "$NVIM_CFG_DIR" ]]; then
    echo "Backing up existing Neovim config to $NVIM_CFG_DIR.bak"
    mv "$NVIM_CFG_DIR" "$NVIM_CFG_DIR.bak"
fi
ln -sfn "$REPO/nvim" "$NVIM_CFG_DIR"
echo "Neovim config -> $NVIM_CFG_DIR (symlink)"

echo ""
echo "Done! Open WezTerm, then run 'nvim' to trigger LazyVim bootstrap."
