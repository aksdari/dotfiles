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
config.window_background_opacity = 0.9
config.macos_window_background_blur = 10
local PADDING = { left = 8, right = 8, top = 8, bottom = 8 }
config.window_padding = PADDING
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false

-- tmux is the multiplexer, so wezterm's own tab bar is dead weight — and with
-- it gone the padding maths below has no variable-height chrome to account for.
config.enable_tab_bar = false

-- ── Behaviour ───────────────────────────────────────────────────────────────
config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.audible_bell = "Disabled"
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500
config.send_composed_key_when_left_alt_is_pressed = false -- left alt = meta
config.send_composed_key_when_right_alt_is_pressed = true -- right alt = accents
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

-- ── Close the gap under the last row ────────────────────────────────────────
-- Aerospace sizes the window in pixels, so its height is almost never an exact
-- multiple of the cell height. wezterm draws padding + whole rows and leaves
-- the remainder unpainted, which at 0.7 opacity reads as a strip of desktop
-- below the tmux status line.
--
-- Fix: hand the remainder to the bottom padding. Padding is painted, so the
-- strip disappears. This converges after one pass — adding `extra` to the
-- padding makes the usable height an exact multiple of the cell height, so the
-- next event computes extra = 0 and changes nothing.
--
-- `window_content_alignment` would be the tidy way to do this, but it needs a
-- nightly build; the stable cask is still 20240203.
local function absorb_leftover_pixels(window, pane)
  if window == nil or pane == nil then
    return
  end

  -- With a split, the active pane is only part of the window and the maths
  -- below would over-pad wildly.
  local tab = window:active_tab()
  if tab == nil or #tab:panes() > 1 then
    return
  end

  local win = window:get_dimensions()
  local content = pane:get_dimensions()
  if win == nil or content == nil or win.pixel_height == 0 or content.pixel_height == 0 then
    return
  end

  local extra = win.pixel_height - content.pixel_height - PADDING.top - PADDING.bottom
  if extra < 0 then
    extra = 0
  end

  local overrides = window:get_config_overrides() or {}
  local wanted = PADDING.bottom + extra
  if overrides.window_padding ~= nil and overrides.window_padding.bottom == wanted then
    return -- already settled; setting it again would loop
  end

  overrides.window_padding = {
    left = PADDING.left,
    right = PADDING.right,
    top = PADDING.top,
    bottom = wanted,
  }
  window:set_config_overrides(overrides)
end

wezterm.on("window-resized", absorb_leftover_pixels)
wezterm.on("window-config-reloaded", absorb_leftover_pixels)

return config
