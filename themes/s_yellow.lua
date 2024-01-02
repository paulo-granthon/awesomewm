local theme_assets = require("beautiful.theme_assets")

local M = {}

function M.setup(theme)
    theme.wallpaper = 's_yellow'

    local primary = "#a9520c"
    local secondary = "#948f19"
    local tertiary = "#361b01"

    theme.bg_focus      = primary
    theme.bg_normal     = secondary .. "aa"
    theme.bg_minimize   = tertiary
    theme.bg_systray    = secondary
    theme.bg_urgent     = "#ff00ff"

    theme.fg_normal     = "#ffffff"
    theme.fg_focus      = tertiary
    theme.fg_minimize   = "#bbbbbb"
    theme.fg_urgent     = "#dfff13"

    theme.border_normal = "#00000000"
    theme.border_focus  = "#535d6c"
    theme.border_marked = "#91231c"

    theme.tasklist_bg_focus = primary
    theme.tasklist_bg_normal = secondary .. "cc"

    theme.taglist_fg_focus = tertiary
    theme.taglist_bg_focus = primary
    theme.taglist_fg_empty = "#804925"
    theme.taglist_fg_occupied = secondary

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
