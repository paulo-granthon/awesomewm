local theme_assets = require('beautiful.theme_assets')

local M = {}

function M.setup(theme)
  theme.wallpaper_prefix = 'green'

  local primary = '#0d7f0a'
  local secondary = '#000000'
  local tertiary = '#4f4f51'

  theme.bg_focus = primary .. 'ef'
  theme.bg_normal = secondary .. '92'
  theme.bg_minimize = tertiary
  theme.bg_systray = theme.bg_normal
  theme.bg_urgent = '#ff0000'

  theme.fg_normal = '#cccccc'
  theme.fg_focus = '#ffffff'
  theme.fg_minimize = '#bbbbbb'
  theme.fg_urgent = '#ff13df'

  theme.border_normal = '#000000'
  theme.border_focus = '#535d6c'
  theme.border_marked = '#91231c'

  theme.tasklist_bg_focus = primary
  theme.tasklist_bg_normal = secondary .. 'cc'

  theme.hotkeys_modifiers_fg = primary
  theme.hotkeys_bg = tertiary .. 'dd'

  theme.taglist_squares_sel = theme_assets.taglist_squares_sel(theme.taglist_square_size, theme.fg_normal)
  theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(theme.taglist_square_size, theme.fg_normal)

  return theme
end

return M
