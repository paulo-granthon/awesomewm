local theme_assets = require("beautiful.theme_assets")

local M = {}

function M.setup(theme)
    theme.wallpaper_prefix = 'm_gkbp'

    local primary = "#163b34"
    local secondary = "#89786D"
    local tertiary = "#020211"

    local secondary_translucent = secondary .. "99"
    local tertiary_translucent = tertiary.. "a0"

    theme.base.colors.off_white = '#d6d1ca'
    theme.base.colors.black = '#070b10'

    theme.bg_focus      = primary
    theme.bg_normal     = secondary_translucent
    theme.bg_minimize   = tertiary_translucent
    theme.bg_systray    = secondary_translucent
    theme.bg_urgent     = "#dfff13"

    theme.fg_focus      = theme.base.colors.off_white
    theme.fg_normal     = theme.base.colors.white
    theme.fg_minimize   = "#bbbbbb"
    theme.fg_urgent     = "#ff00ff"

    theme.border_normal = "#00000000"
    theme.border_focus  = "#535d6c"
    theme.border_marked = "#91231c"

    theme.tasklist_bg_focus = primary
    theme.tasklist_bg_normal = secondary_translucent
    theme.tasklist_bg_minimize = tertiary_translucent

    theme.taglist_fg_focus = theme.base.colors.white
    theme.taglist_bg_focus = primary
    theme.taglist_fg_occupied = theme.base.colors.off_white
    theme.taglist_bg_occupied = secondary_translucent
    theme.taglist_fg_empty = secondary_translucent

    theme.tooltip_bg_color = secondary .. '99'

    theme.prompt_bg = primary
    theme.prompt_fg = theme.base.colors.white

    theme.hotkeys_modifiers_fg = secondary
    theme.hotkeys_bg = tertiary .. "77"

    theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
        theme.taglist_square_size, theme.fg_normal
    )
    theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
        theme.taglist_square_size, theme.fg_normal
    )

    return theme
end

return M
