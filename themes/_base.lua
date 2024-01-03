local beautiful = require('beautiful')
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local THEME = {}

THEME.base.colors.white = '#cccccc'
THEME.base.colors.transparent = '#00000000'
THEME.base.colors.primary = "#555555"
THEME.base.colors.secondary = "#333333"
THEME.base.colors.tertiary = "#111111"

THEME.font_size = 8
THEME.font = "sans " .. THEME.font_size

THEME.useless_gap   = dpi(0)
THEME.border_width  = dpi(0)

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
THEME.bg_focus = THEME.base.colors.primary
THEME.bg_normal = THEME.base.colors.secondary
THEME.bg_minimize = THEME.base.colors.tertiary
THEME.taglist_fg_empty = THEME.base.colors.transparent
THEME.tooltip_bg_color = THEME.base.colors.transparent

-- Generate taglist squares:
THEME.taglist_square_size = dpi(THEME.font_size / 5 * 4)

-- require("naughty").notify({
--     preset = require("naughty").config.presets.critical,
--     title = "THEME.taglist_square_size",
--     text = tostring(THEME.taglist_square_size)
-- })

THEME.taglist_squares_sel = theme_assets.taglist_squares_sel(
    THEME.taglist_square_size,
    THEME.base.colors.white
)
THEME.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    THEME.taglist_square_size,
    THEME.base.colors.white
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
THEME.menu_submenu_icon = themes_path.."default/submenu.png"
THEME.menu_height = dpi(3 * THEME.font_size)
THEME.menu_width  = dpi(16 * THEME.font_size)

-- Define the image to load
THEME.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
THEME.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

THEME.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
THEME.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

THEME.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
THEME.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
THEME.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
THEME.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

THEME.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
THEME.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
THEME.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
THEME.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

THEME.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
THEME.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
THEME.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
THEME.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

THEME.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
THEME.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
THEME.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
THEME.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

THEME.wallpaper = themes_path.."default/background.png"

-- You can use your own layout icons like this:
THEME.layout_fairh = themes_path.."default/layouts/fairhw.png"
THEME.layout_fairv = themes_path.."default/layouts/fairvw.png"
THEME.layout_floating  = themes_path.."default/layouts/floatingw.png"
THEME.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
THEME.layout_max = themes_path.."default/layouts/maxw.png"
THEME.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
THEME.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
THEME.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
THEME.layout_tile = themes_path.."default/layouts/tilew.png"
THEME.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
THEME.layout_spiral  = themes_path.."default/layouts/spiralw.png"
THEME.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
THEME.layout_cornernw = themes_path.."default/layouts/cornernww.png"
THEME.layout_cornerne = themes_path.."default/layouts/cornernew.png"
THEME.layout_cornersw = themes_path.."default/layouts/cornersww.png"
THEME.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
THEME.awesome_icon = theme_assets.awesome_icon(
    THEME.menu_height,
    THEME.bg_focus,
    THEME.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
THEME.icon_theme = nil

return THEME
