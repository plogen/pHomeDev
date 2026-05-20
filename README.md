# pHomeDev

Personal development environment configuration and setup scripts.

## Stack

| Tool | Purpose |
|---|---|
| [WezTerm](https://wezfurlong.org/wezterm/) | Terminal emulator — tabs, splits, Lua config |
| [Neovim](https://neovim.io/) + [LazyVim](https://lazyvim.org/) | Editor — LSP, plugins, Lua config |
| [JetBrainsMono Nerd Font](https://www.nerdfonts.com/) | Font with icons |

Theme: **Catppuccin Mocha** across all tools.

---

## Quick Setup

### Windows

```powershell
git clone https://github.com/plogen/pHomeDev.git
cd pHomeDev
.\setup-windows.ps1
```

### Linux

```bash
git clone https://github.com/plogen/pHomeDev.git
cd pHomeDev
bash setup-linux.sh
```

Both scripts install missing tools, copy/symlink WezTerm config, and link the Neovim config directory.
Open WezTerm, then run `nvim` — LazyVim bootstraps all plugins on first launch.

---

## Key Bindings

### WezTerm — Leader key: `Ctrl+A`

| Binding | Action |
|---|---|
| `Ctrl+A \|` | Split pane horizontally |
| `Ctrl+A -` | Split pane vertically |
| `Ctrl+A h/j/k/l` | Navigate panes |
| `Ctrl+A ←/↓/↑/→` | Resize pane |
| `Ctrl+A c` | New tab |
| `Ctrl+A n/p` | Next / previous tab |
| `Ctrl+A w` | Tab navigator |
| `Ctrl+A z` | Zoom / unzoom pane |
| `Ctrl+A x` | Close pane |
| `Ctrl+A r` | Rename tab |
| `Ctrl+Shift+C/V` | Copy / Paste |

### Neovim (LazyVim defaults + custom)

| Binding | Action |
|---|---|
| `Ctrl+h/j/k/l` | Navigate splits |
| `Ctrl+↑/↓/←/→` | Resize splits |
| `Tab` / `Shift+Tab` | Next / previous buffer |
| `<Space>w` | Save |
| `<Space>q` | Quit |
| `<Space>mp` | Toggle Markdown render |

---

## Repository Layout

```
pHomeDev/
├── wezterm/
│   └── wezterm.lua          # WezTerm config (Lua)
├── nvim/
│   ├── init.lua             # Entry point
│   └── lua/
│       ├── config/
│       │   ├── lazy.lua     # lazy.nvim bootstrap + LazyVim
│       │   ├── options.lua  # Neovim options
│       │   └── keymaps.lua  # Custom keymaps
│       └── plugins/
│           ├── colorscheme.lua  # Catppuccin Mocha
│           └── markdown.lua     # render-markdown.nvim
├── setup-windows.ps1        # Windows installer + config linker
├── setup-linux.sh           # Linux installer + config linker
└── README.md
```

---

## Tools

### GitHub CLI (`gh`)

Installed via [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/):

```powershell
winget install --id GitHub.cli --silent --accept-source-agreements --accept-package-agreements
```

Authenticate after install:

```powershell
gh auth login
```

Or with an existing token:

```powershell
"<your-token>" | gh auth login --with-token
```

Official docs: https://cli.github.com/manual/
