local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ── Appearance ──────────────────────────────────────────────────────────────
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font_with_fallback({
  { family = "MesloLGS Nerd Font Mono", weight = "Regular" },
  "Apple Color Emoji",
})
config.font_size = 13
config.line_height = 1.05

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.7
config.macos_window_background_blur = 10
config.window_padding = { left = 8, right = 8, top = 8, bottom = 0 }
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false

-- tmux owns multiplexing, so the tab bar only shows up when it has something to say.
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

-- ── Behaviour ───────────────────────────────────────────────────────────────
config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.audible_bell = "Disabled"
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500
config.send_composed_key_when_left_alt_is_pressed = false  -- left alt = meta
config.send_composed_key_when_right_alt_is_pressed = true  -- right alt = accents
config.check_for_updates = false

-- ── Keys ────────────────────────────────────────────────────────────────────
-- Deliberately sparse: anything pane- or tab-shaped belongs to tmux.
config.keys = {
  { key = "Enter", mods = "CMD", action = wezterm.action.ToggleFullScreen },
  { key = "k", mods = "CMD", action = wezterm.action.ClearScrollback("ScrollbackAndViewport") },
  { key = "0", mods = "CMD", action = wezterm.action.ResetFontSize },

  -- macOS line editing: the terminal has no idea what Cmd means, so translate
  -- these into the control codes readline and zsh already understand.
  { key = "Backspace", mods = "CMD", action = wezterm.action.SendKey({ key = "u", mods = "CTRL" }) },
  { key = "Backspace", mods = "OPT", action = wezterm.action.SendKey({ key = "w", mods = "CTRL" }) },
  { key = "LeftArrow", mods = "CMD", action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },
  { key = "RightArrow", mods = "CMD", action = wezterm.action.SendKey({ key = "e", mods = "CTRL" }) },
  { key = "LeftArrow", mods = "OPT", action = wezterm.action.SendKey({ key = "b", mods = "ALT" }) },
  { key = "RightArrow", mods = "OPT", action = wezterm.action.SendKey({ key = "f", mods = "ALT" }) },
  {
    key = "f",
    mods = "CMD",
    action = wezterm.action.Search({ CaseInSensitiveString = "" }),
  },
}

return config
