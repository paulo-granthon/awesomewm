local theme_assets = require("beautiful.theme_assets")

local M = {}

function M.setup(theme)
    theme.wallpaper_prefix = 's_cobalt'

    local primary = "#4e7ef3"
    local secondary = "#1c3589"
    local tertiary = "#07153b"

    theme.bg_focus      = primary
    theme.bg_normal     = secondary .. "c0"
    theme.bg_minimize   = tertiary
    theme.bg_systray    = secondary
    theme.bg_urgent     = "#dfff13"

    theme.fg_focus      = theme.base.colors.black
    theme.fg_normal     = theme.base.colors.white
    theme.fg_minimize   = "#bbbbbb"
    theme.fg_urgent     = "#ff00ff"

    theme.border_normal = "#00000000"
    theme.border_focus  = "#535d6c"
    theme.border_marked = "#91231c"

    theme.tasklist_bg_focus = primary
    theme.tasklist_bg_normal = secondary

    theme.taglist_fg_focus = theme.base.colors.white
    theme.taglist_bg_focus = primary
    theme.taglist_fg_occupied = primary
    theme.taglist_bg_occupied = secondary .. "60"
    theme.taglist_fg_empty = primary

    theme.tooltip_bg_color = secondary

    theme.prompt_bg = tertiary
    theme.prompt_fg = theme.bg_focus

    theme.hotkeys_modifiers_fg = primary
    theme.hotkeys_bg = tertiary .. "dd"

    theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
        theme.taglist_square_size, theme.fg_normal
    )
    theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
        theme.taglist_square_size, theme.fg_normal
    )

    return theme
end

return M
