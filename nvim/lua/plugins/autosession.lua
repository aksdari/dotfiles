return {
  {
    "rmagatti/auto-session",
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      log_level = "info",
      auto_session_enabled = true,
      auto_save_enabled = true,
      auto_restore_enabled = true,
    },
  },
}
