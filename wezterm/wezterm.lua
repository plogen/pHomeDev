local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ─── Shell ───────────────────────────────────────────────────────────────────
-- Use PowerShell as default shell (enables cd across drives, better scripting)
config.default_prog = { "pwsh.exe", "-NoLogo" }

-- ─── Appearance ──────────────────────────────────────────────────────────────
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrains Mono", { weight = "Regular" })
config.font_size = 13.0
config.window_background_opacity = 0.97
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false

-- ─── Window ──────────────────────────────────────────────────────────────────
config.window_padding = { left = 8, right = 8, top = 6, bottom = 6 }
config.initial_cols = 220
config.initial_rows = 50

-- ─── Keys ────────────────────────────────────────────────────────────────────
-- Leader key: CTRL+A (like tmux)
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1500 }

config.keys = {
  -- ── Splits ──
  { key = "|", mods = "LEADER",       action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "-", mods = "LEADER",       action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "x", mods = "LEADER",       action = wezterm.action.CloseCurrentPane({ confirm = false }) },

  -- ── Pane navigation (LEADER + hjkl) ──
  { key = "h", mods = "LEADER",       action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER",       action = wezterm.action.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER",       action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER",       action = wezterm.action.ActivatePaneDirection("Right") },

  -- ── Pane resize (LEADER + arrow keys) ──
  { key = "LeftArrow",  mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
  { key = "DownArrow",  mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
  { key = "UpArrow",    mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
  { key = "RightArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },

  -- ── Tabs ──
  { key = "c", mods = "LEADER",       action = wezterm.action.SpawnTab("CurrentPaneDomain") },
  { key = "n", mods = "LEADER",       action = wezterm.action.ActivateTabRelative(1) },
  { key = "p", mods = "LEADER",       action = wezterm.action.ActivateTabRelative(-1) },
  { key = "w", mods = "LEADER",       action = wezterm.action.ShowTabNavigator },

  -- ── Copy / Paste ──
  { key = "c", mods = "CTRL|SHIFT",   action = wezterm.action.CopyTo("Clipboard") },
  { key = "v", mods = "CTRL|SHIFT",   action = wezterm.action.PasteFrom("Clipboard") },

  -- ── Search ──
  { key = "f", mods = "CTRL|SHIFT",   action = wezterm.action.Search({ CaseInSensitiveString = "" }) },

  -- ── Zoom active pane ──
  { key = "z", mods = "LEADER",       action = wezterm.action.TogglePaneZoomState },

  -- ── Rename tab ──
  {
    key = "r", mods = "LEADER",
    action = wezterm.action.PromptInputLine({
      description = "Rename tab:",
      action = wezterm.action_callback(function(window, _, line)
        if line then window:active_tab():set_title(line) end
      end),
    }),
  },
}

-- ─── Mouse ───────────────────────────────────────────────────────────────────
config.mouse_bindings = {
  { event = { Up = { streak = 1, button = "Left" } }, mods = "CTRL",
    action = wezterm.action.OpenLinkAtMouseCursor },
}

return config
