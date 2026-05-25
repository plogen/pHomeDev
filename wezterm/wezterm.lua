local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ─── Plugin: Command Palette ──────────────────────────────────────────────────
-- LEADER+Space  → fuzzy-searchable cheatsheet of your own keybindings
-- CTRL+SHIFT+P  → WezTerm built-in action launcher (frecency-ranked)
local cmdpicker = wezterm.plugin.require("https://github.com/abidibo/wezterm-cmdpicker")

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

-- ─── Smart pane navigation ───────────────────────────────────────────────────
-- CTRL+hjkl navigates WezTerm panes, but forwards the key to Neovim when it
-- is the active process so that Neovim can handle its own splits first.
-- Neovim is configured to fall back to `wezterm cli` when it is at an edge,
-- completing the round-trip without any separate leader sequence.

local function is_vim(pane)
  local proc = pane:get_foreground_process_info()
  if not proc then return false end
  return proc.name:lower():match("n?vim") ~= nil
end

local nav_dirs = { h = "Left", j = "Down", k = "Up", l = "Right" }

local function smart_nav_action(key)
  return wezterm.action_callback(function(win, pane)
    if is_vim(pane) then
      -- Let Neovim handle it; Neovim will call back via `wezterm cli` if at an edge
      win:perform_action({ SendKey = { key = key, mods = "CTRL" } }, pane)
    else
      win:perform_action({ ActivatePaneDirection = nav_dirs[key] }, pane)
    end
  end)
end

-- ─── Keys ────────────────────────────────────────────────────────────────────
-- Leader key: CTRL+A (like tmux)
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1500 }

-- All bindings registered through cmdpicker so they appear in LEADER+Space palette
cmdpicker.add_keys(config, {
  -- ── Splits ──
  { key = "|", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }), desc = "Split pane right" },
  { key = "-", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),   desc = "Split pane down" },
  { key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = false }),             desc = "Close pane" },

  -- ── Pane navigation — CTRL+hjkl (seamless with Neovim splits) ──
  { key = "h", mods = "CTRL", action = smart_nav_action("h"), desc = "Navigate pane/split left" },
  { key = "j", mods = "CTRL", action = smart_nav_action("j"), desc = "Navigate pane/split down" },
  { key = "k", mods = "CTRL", action = smart_nav_action("k"), desc = "Navigate pane/split up" },
  { key = "l", mods = "CTRL", action = smart_nav_action("l"), desc = "Navigate pane/split right" },

  -- ── Pane resize (LEADER + arrow keys) ──
  { key = "LeftArrow",  mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Left",  5 }), desc = "Resize pane left" },
  { key = "DownArrow",  mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Down",  5 }), desc = "Resize pane down" },
  { key = "UpArrow",    mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Up",    5 }), desc = "Resize pane up" },
  { key = "RightArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Right", 5 }), desc = "Resize pane right" },

  -- ── Tabs ──
  { key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain"),      desc = "New tab" },
  { key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1),             desc = "Next tab" },
  { key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1),            desc = "Previous tab" },
  { key = "w", mods = "LEADER", action = wezterm.action.ShowTabNavigator,                   desc = "Tab navigator" },
  { key = "q", mods = "LEADER", action = wezterm.action.CloseCurrentTab({ confirm = false }), desc = "Close tab" },

  -- ── New line (PSReadLine multi-line input) ──
  { key = "Enter", mods = "SHIFT", action = wezterm.action.SendString("\n"), desc = "Insert newline (multi-line input)" },

  -- ── Copy / Paste ──
  { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard"),    desc = "Copy to clipboard" },
  { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard"), desc = "Paste from clipboard" },

  -- ── Search ──
  { key = "f", mods = "CTRL|SHIFT", action = wezterm.action.Search({ CaseInSensitiveString = "" }), desc = "Search in pane" },

  -- ── Zoom active pane ──
  { key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState, desc = "Zoom/unzoom pane" },

  -- ── Rename tab ──
  {
    key = "r", mods = "LEADER",
    action = wezterm.action.PromptInputLine({
      description = "Rename tab:",
      action = wezterm.action_callback(function(window, _, line)
        if line then window:active_tab():set_title(line) end
      end),
    }),
    desc = "Rename tab",
  },

  -- ── Palettes ──
  { key = "P", mods = "CTRL|SHIFT", action = wezterm.action.ActivateCommandPalette, desc = "WezTerm built-in command palette" },
})

-- ─── Mouse ───────────────────────────────────────────────────────────────────
config.mouse_bindings = {
  { event = { Up = { streak = 1, button = "Left" } }, mods = "CTRL",
    action = wezterm.action.OpenLinkAtMouseCursor },
}

-- ─── Command Palette trigger — must be called last ───────────────────────────
cmdpicker.apply_to_config(config, {
  key              = " ",
  mods             = "LEADER",
  title            = "Command Palette",
  fuzzy            = true,
  fuzzy_description = "Search: ",
  include_defaults = false,
})

return config
