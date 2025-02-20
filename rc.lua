-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, 'luarocks.loader')
local os_capture = require('utils.capture')

local tag_count = 10

local advanced_tag_controls = require('advanced_tag_controls')
local brightness_widget = require('brightness-widget')
local batteryarc_widget = require('awesome-wm-widgets.batteryarc-widget.batteryarc')

-- Standard awesome library
local gears = require('gears')
local awful = require('awful')
require('awful.autofocus')

-- Widget and layout library
local wibox = require('wibox')

-- Theme handling library
local beautiful = require('beautiful')
local naughty = require('naughty')

local menubar = require('menubar')
local hotkeys_popup = require('awful.hotkeys_popup')

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require('awful.hotkeys_popup.keys')

local local_configs_ok, local_configs_or_err = pcall(require, 'local')
local local_configs
if local_configs_ok then
  local_configs = local_configs_or_err
else
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = 'Local configs not found',
    text = 'Create a file `local.lua` in the root of the `awesome` directory',
    timeout = 5,
  })
  local_configs = require('local_example')
  naughty.notify({
    preset = naughty.config.presets.normal,
    title = 'Using example local configs',
    text = 'Copy the `local.example.lua` to `local.lua` and modify it to your needs',
  })
end

-- define the awesome .config/ home
local AWESOME_HOME = '/home/' .. os.getenv('USER') .. '/.config/awesome'

-- start picom compositor
awful.spawn.with_shell(AWESOME_HOME .. '/picom.bash')

-- load the theme from theme.lua
local theme_prefix = require('theme')

-- load the theme file from the theme prefix defined in theme.lua
local theme_file_path = AWESOME_HOME .. '/themes/' .. theme_prefix .. '.lua'

-- Call the Bash script with the THEME as an argument
local verify_theme_result, std_out, std_err = os_capture(AWESOME_HOME .. '/verify_theme.bash ' .. theme_file_path)
local std_out_formatted = std_out ~= nil and std_out ~= '' and std_out or '--EMPTY--'
local std_err_formatted = std_err ~= nil and std_err ~= '' and std_err or '--EMPTY--'

-- load the base theme
local THEME = require('themes._base')

-- Theme verified and present. Set it up
if verify_theme_result then
  THEME = require('themes.' .. theme_prefix).setup(THEME)
else
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = 'Theme `' .. theme_prefix .. '` not found',
    text = 'Check if the theme exists in `'
      .. theme_file_path
      .. '`\n'
      .. '\n'
      .. 'std_out:\n'
      .. std_out_formatted
      .. '\n'
      .. 'std_err:\n'
      .. std_err_formatted,
  })
end

-- Apply theme to `beautiful`
beautiful.init(THEME)

-- setup some other beautiful configs
beautiful.useless_gap = 8
beautiful.notification_border_color = THEME.transparent

-- awesome-wm-widgets
local logout_popup = require('awesome-wm-widgets.logout-popup-widget.logout-popup')
local logout_menu_widget = require('awesome-wm-widgets.logout-menu-widget.logout-menu')
local volume_widget = require('awesome-wm-widgets.pactl-widget.volume')
local volume_widget_instance = volume_widget({
  mixer_cmd = nil,
  widget_type = 'arc',
  tooltip = true,
})

local calendar_widget = require('awesome-wm-widgets.calendar-widget.calendar')
local cw = calendar_widget({
  theme = 'dark',
  placement = 'top_right',
  start_sunday = true,
  radius = 4,
  previous_month_button = 4, -- scroll up
  next_month_button = 5, -- scroll down
})
local mytextclock = wibox.widget.textclock()
mytextclock:connect_signal('button::press', function(_, _, _, button)
  if button == 1 then cw.toggle() end
end)

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = 'Oops, there were errors during startup!',
    text = awesome.startup_errors,
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal('debug::error', function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = 'Oops, an error happened!',
      text = tostring(err),
    })
    in_error = false
  end)
end
-- }}}

-- This is used later as the default terminal and editor to run.
local terminal = 'alacritty'
local editor = os.getenv('EDITOR') or 'nvim'
local editor_cmd = terminal .. ' -e ' .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = 'Mod4'

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.fair,
  awful.layout.suit.tile,
  -- awful.layout.suit.floating,
  -- awful.layout.suit.tile.left,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  -- awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
  { 'hotkeys', function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { 'manual', terminal .. ' -e man awesome' },
  { 'edit config', editor_cmd .. ' ' .. awesome.conffile },
  { 'restart', awesome.restart },
  { 'quit', function() awesome.quit() end },
}

local mymainmenu = awful.menu({
  items = {
    { 'awesome', myawesomemenu, beautiful.awesome_icon },
    { 'open terminal', terminal, menubar.utils.lookup_icon('Alacritty') },
    { 'firefox', 'firefox', menubar.utils.lookup_icon('firefox') },
    { 'files', 'thunar', '/usr/share/icons/hicolor/128x128/apps/org.xfce.thunar.png' },
  },
})

-- local mylauncher = awful.widget.launcher({
--     image = beautiful.awesome_icon,
--     menu = mymainmenu
-- })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
--mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
--mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t) advanced_tag_controls.view_only(t) end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then client.focus:move_to_tag(t) end
  end),
  awful.button({}, 3, advanced_tag_controls.view_toggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then client.focus:toggle_tag(t) end
  end),
  awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
  awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end)
)

local tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal('request::activate', 'tasklist', { raise = true })
    end
  end),
  awful.button({}, 3, function() awful.menu.client_list({ theme = { width = 250 } }) end),
  awful.button({}, 4, function() awful.client.focus.byidx(-1) end),
  awful.button({}, 5, function() awful.client.focus.byidx(1) end)
)

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == 'function' then wallpaper = wallpaper(s) end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal('property::geometry', set_wallpaper)

local wallpaper_path = nil

if THEME.wallpaper_prefix then
  wallpaper_path = AWESOME_HOME .. '/wallpaper/' .. THEME.wallpaper_prefix .. '.jpg'

  local file = io.open(wallpaper_path, 'r')

  if file == nil then
    naughty.notify({
      preset = naughty.config.presets.critical,
      title = 'Error: wallpaper not found: `'
        .. THEME.wallpaper_prefix
        .. '` defined in `'
        .. theme_file_path
        .. '` not found',
      text = 'Check if the wallpaper exists in path: `' .. wallpaper_path .. '`',
    })
  else
    file:close() -- file only needs to be closed if it is not nil
  end
end

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  if wallpaper_path ~= nil then
    require('gears').wallpaper.maximized(wallpaper_path, s)
  else
    set_wallpaper(s)
  end

  local tag_name_generator = function(i) return ' ' .. i % tag_count .. ' ' end

  local tags = {}
  for i = 1, tag_count do
    tags[i] = tag_name_generator(i)
  end

  -- Each screen has its own tag table.
  awful.tag(tags, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(
    gears.table.join(
      awful.button({}, 1, function() awful.layout.inc(1) end),
      awful.button({}, 3, function() awful.layout.inc(-1) end),
      awful.button({}, 4, function() awful.layout.inc(-1) end),
      awful.button({}, 5, function() awful.layout.inc(1) end)
    )
  )
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist({
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
  })

  local WIBOX_HEIGHT = THEME.font_size * 2.5

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist({
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,

    style = {
      shape_border_width = 0,
      shape_border_color = beautiful.border_normal,
      shape = gears.shape.rectangle,
    },
    layout = {
      layout = wibox.layout.fixed.horizontal,
    },
    widget_template = {
      wibox.widget.base.make_widget(),
      create_callback = function(self, c, _, _) --luacheck: no unused args
        self:get_children_by_id('clienticon')[1].client = c
      end,
      layout = wibox.layout.align.vertical,
      forced_height = WIBOX_HEIGHT,
      {
        {
          {
            id = 'clienticon',
            widget = awful.widget.clienticon,
            halign = 'center',
            forced_height = WIBOX_HEIGHT,
            forced_width = WIBOX_HEIGHT,
          },
          top = 0,
          bottom = 0,
          left = 16,
          right = 16,
          halign = 'center',
          widget = wibox.container.margin,
          forced_height = WIBOX_HEIGHT,
        },
        halign = 'center',
        id = 'background_role',
        widget = wibox.container.background,
        forced_height = WIBOX_HEIGHT,
      },
    },
  })

  -- Create the wibox
  s.mywibox = awful.wibar({
    position = 'top',
    bg = '#00000000',
    -- bg = '#ff00ff',
    screen = s,
  })

  -- Add widgets to the wibox
  s.mywibox:setup({
    expand = 'none',
    layout = wibox.layout.align.horizontal,
    forced_height = WIBOX_HEIGHT,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      spacing = 16,
      logout_menu_widget(),
      s.mytaglist,
      s.mypromptbox,
    },
    s.mytasklist, -- Middle widget
    { -- Right widgets
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = 16,
        wibox.widget.systray(),
        local_configs.use_batteryarc_widget and batteryarc_widget({
          show_current_level = true,
          arc_thickness = 3,
        }),
        local_configs.use_brightness_widget and brightness_widget({
          step = 2,
        }),
        volume_widget_instance,
        mytextclock,
      },
      layout = wibox.layout.fixed.horizontal,
      widget = wibox.container.background,
      s.mylayoutbox,
    },
  })
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
  awful.button({}, 3, function() mymainmenu:toggle() end)
  -- awful.button({}, 4, awful.tag.viewnext),
  -- awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
local globalkeys = gears.table.join(
  awful.key({ modkey }, 's', hotkeys_popup.show_help, { description = 'show help', group = 'awesome' }),
  awful.key({ modkey }, 'Left', awful.tag.viewprev, { description = 'view previous', group = 'tag' }),
  awful.key({ modkey }, 'Right', awful.tag.viewnext, { description = 'view next', group = 'tag' }),
  awful.key({ modkey }, 'Escape', awful.tag.history.restore, { description = 'go back', group = 'tag' }),
  awful.key(
    { modkey },
    'j',
    function() awful.client.focus.byidx(-1) end,
    { description = 'focus next by index', group = 'client' }
  ),
  awful.key(
    { modkey },
    'k',
    function() awful.client.focus.byidx(1) end,
    { description = 'focus previous by index', group = 'client' }
  ),
  awful.key({ modkey }, 'w', function() mymainmenu:show() end, { description = 'show main menu', group = 'awesome' }),

  -- Layout manipulation
  awful.key(
    { modkey, 'Shift' },
    'j',
    function() awful.client.swap.byidx(-1) end,
    { description = 'swap with next client by index', group = 'client' }
  ),
  awful.key(
    { modkey, 'Shift' },
    'k',
    function() awful.client.swap.byidx(1) end,
    { description = 'swap with previous client by index', group = 'client' }
  ),
  awful.key(
    { modkey, 'Control' },
    'j',
    function() awful.screen.focus_relative(1) end,
    { description = 'focus the next screen', group = 'screen' }
  ),
  awful.key(
    { modkey, 'Control' },
    'k',
    function() awful.screen.focus_relative(-1) end,
    { description = 'focus the previous screen', group = 'screen' }
  ),
  awful.key({ modkey }, 'u', awful.client.urgent.jumpto, { description = 'jump to urgent client', group = 'client' }),
  awful.key({ modkey }, 'Tab', function()
    awful.client.focus.history.previous()
    if client.focus then client.focus:raise() end
  end, { description = 'go back', group = 'client' }),

  -- Standard program
  awful.key(
    { modkey },
    'Return',
    function() awful.spawn(terminal) end,
    { description = 'open a terminal', group = 'launcher' }
  ),
  awful.key({ modkey, 'Control' }, 'r', awesome.restart, { description = 'reload awesome', group = 'awesome' }),
  -- awful.key({ modkey, "Shift"   }, "q", awesome.quit,
  --           {description = "quit awesome", group = "awesome"}),

  awful.key(
    { modkey },
    'l',
    function() awful.tag.incmwfact(0.05) end,
    { description = 'increase master width factor', group = 'layout' }
  ),
  awful.key(
    { modkey },
    'h',
    function() awful.tag.incmwfact(-0.05) end,
    { description = 'decrease master width factor', group = 'layout' }
  ),
  awful.key(
    { modkey, 'Shift' },
    'h',
    function() awful.tag.incnmaster(1, nil, true) end,
    { description = 'increase the number of master clients', group = 'layout' }
  ),
  awful.key(
    { modkey, 'Shift' },
    'l',
    function() awful.tag.incnmaster(-1, nil, true) end,
    { description = 'decrease the number of master clients', group = 'layout' }
  ),
  awful.key(
    { modkey, 'Control' },
    'h',
    function() awful.tag.incncol(1, nil, true) end,
    { description = 'increase the number of columns', group = 'layout' }
  ),
  awful.key(
    { modkey, 'Control' },
    'l',
    function() awful.tag.incncol(-1, nil, true) end,
    { description = 'decrease the number of columns', group = 'layout' }
  ),
  awful.key({ modkey }, 'space', function() awful.layout.inc(1) end, { description = 'select next', group = 'layout' }),
  awful.key(
    { modkey, 'Shift' },
    'space',
    function() awful.layout.inc(-1) end,
    { description = 'select previous', group = 'layout' }
  ),

  awful.key({ modkey, 'Control' }, 'n', function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then c:emit_signal('request::activate', 'key.unminimize', { raise = true }) end
  end, { description = 'restore minimized', group = 'client' }),

  -- Prompt
  awful.key(
    { modkey },
    'r',
    function() awful.screen.focused().mypromptbox:run() end,
    { description = 'run prompt', group = 'launcher' }
  ),

  awful.key(
    { modkey },
    'x',
    function()
      awful.prompt.run({
        prompt = 'Run Lua code: ',
        textbox = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. '/history_eval',
      })
    end,
    { description = 'lua execute prompt', group = 'awesome' }
  ),
  -- Menubar
  awful.key({ modkey }, 'p', function() menubar.show() end, { description = 'show the menubar', group = 'launcher' }),

  -- logou popup | https://github.com/raven2cz/awesomewm-config/tree/master/awesome-wm-widgets/logout-popup-widget
  awful.key(
    { modkey },
    'F4',
    function() logout_popup.launch() end,
    { description = 'Show logout screen', group = 'custom' }
  ),

  -- volume-widget | https://github.com/raven2cz/awesomewm-config/tree/master/awesome-wm-widgets/volume-widget
  awful.key({ modkey }, '[', function() volume_widget:inc(5) end),
  awful.key({ modkey }, ']', function() volume_widget:dec(5) end),
  awful.key({ modkey }, '/', function() volume_widget:toggle() end),
  awful.key(
    { modkey },
    'F9',
    function() awful.spawn.with_shell('~/.config/polybar/scripts/backlight.sh --scroll-up') end
  ),
  awful.key(
    { modkey },
    'F8',
    function() awful.spawn.with_shell('~/.config/polybar/scripts/backlight.sh --scroll-down') end
  ),

  -- screenshot with custom script
  awful.key({ modkey }, 'Print', function() awful.spawn.with_shell('~/.local/bin/sshot') end),
  awful.key({ modkey, 'Control' }, 'Print', function() awful.spawn.with_shell('~/.local/bin/sshot select') end),

  -- advanced_tag_controls
  awful.key(
    { modkey, 'Shift' },
    'Escape',
    function() advanced_tag_controls.move_client_to_previous_tags(client, true) end,
    { description = 'Move focused client to previous active tag(s)', group = 'tag (advanced)' }
  ),

  awful.key(
    { modkey, 'Control' },
    'Escape',
    function() advanced_tag_controls.toggle_previous_tags() end,
    { description = 'Toggle visibility on previous active tag(s)', group = 'tag (advanced)' }
  ),

  awful.key(
    { modkey, 'Control', 'Shift' },
    'Escape',
    function() advanced_tag_controls.move_client_to_previous_tags(client, true) end,
    { description = 'Toggle focused client on previous active tag(s)', group = 'tag (advanced)' }
  ),

  -- todo: minimize all active clients on active tags (not minimized) and save to a list
  -- so that it is possible restore later with a single command

  awful.key(
    { modkey, 'Shift' },
    'q',
    function() advanced_tag_controls.close_active_clients_on_tags(awful.screen.focused().selected_tags) end,
    { description = 'Close all (not minimized) clients active only on focused tag', group = 'tag (advanced)' }
  )
)

local clientkeys = gears.table.join(
  awful.key({ modkey }, 'f', function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, { description = 'toggle fullscreen', group = 'client' }),
  awful.key({ modkey, 'Shift' }, 'c', function(c) c:kill() end, { description = 'close', group = 'client' }),
  awful.key(
    { modkey, 'Control' },
    'space',
    awful.client.floating.toggle,
    { description = 'toggle floating', group = 'client' }
  ),
  awful.key(
    { modkey, 'Control' },
    'Return',
    function(c) c:swap(awful.client.getmaster()) end,
    { description = 'move to master', group = 'client' }
  ),
  awful.key({ modkey }, 'o', function(c) c:move_to_screen() end, { description = 'move to screen', group = 'client' }),
  awful.key(
    { modkey },
    't',
    function(c) c.ontop = not c.ontop end,
    { description = 'toggle keep on top', group = 'client' }
  ),
  awful.key({ modkey }, 'n', function(c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
  end, { description = 'minimize', group = 'client' }),
  awful.key({ modkey }, 'm', function(c)
    c.maximized = not c.maximized
    c:raise()
  end, { description = '(un)maximize', group = 'client' }),
  -- awful.key({ modkey, "Control" }, "m",
  --     function (c)
  --         c.maximized_vertical = not c.maximized_vertical
  --         c:raise()
  --     end ,
  --     {description = "(un)maximize vertically", group = "client"}),
  -- awful.key({ modkey, "Shift"   }, "m",
  --     function (c)
  --         c.maximized_horizontal = not c.maximized_horizontal
  --         c:raise()
  --     end ,
  --     {description = "(un)maximize horizontally", group = "client"})
  awful.key({ modkey }, 'i', function(c)
    local inspect = require('inspect')
    naughty.notify({
      preset = naughty.config.presets.normal,
      title = 'name: ' .. c.name .. ' | class: ' .. c.class,
      text = table.concat({
        'name: ' .. c.name,
        'class: ' .. c.class,
        'instance: ' .. c.instance,
        'type: ' .. c.type,
        'leader: ' .. inspect(c.leader),
        'client: ' .. inspect(c.client),
        'group: ' .. inspect(c.group),
        'parent: ' .. inspect(c.parent),
        'transient_for: ' .. inspect(c.transient_for),
        'window: ' .. inspect(c.window),
        'width: ' .. inspect(c.width),
        'height: ' .. inspect(c.height),
        'border_width: ' .. inspect(c.border_width),
        'border_color: ' .. inspect(c.border_color),
        'shape: ' .. inspect(c.shape),
        'opacity: ' .. inspect(c.opacity),
        'focus: ' .. inspect(c.focus),
        'raise: ' .. inspect(c.raise),
        'keys: ' .. inspect(c.keys),
        'buttons: ' .. inspect(c.buttons),
        'screen: ' .. inspect(c.screen),
        'placement: ' .. inspect(c.placement),
      }, '\n'),
    })
  end, { description = 'toggle minimized', group = 'client' })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, tag_count do
  local tagIndex = i
  local tagKey = tagIndex - 1

  globalkeys = gears.table.join(
    globalkeys,

    -- View tag only.
    awful.key({ modkey }, '#' .. tagKey + tag_count, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[tagIndex]
      if tag then advanced_tag_controls.view_only(tag) end
    end, { description = 'view tag #' .. tagKey, group = 'tag' }),

    -- Toggle tag display.
    awful.key({ modkey, 'Control' }, '#' .. tagKey + tag_count, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[tagIndex]
      if tag then advanced_tag_controls.view_toggle(tag) end
    end, { description = 'toggle tag #' .. tagKey, group = 'tag' }),

    -- Move client to tag.
    awful.key({ modkey, 'Shift' }, '#' .. tagKey + tag_count, function()
      if client.focus then
        local tag = client.focus.screen.tags[tagIndex]
        if tag then client.focus:move_to_tag(tag) end
      end
    end, { description = 'move focused client to tag #' .. tagKey, group = 'tag' }),

    -- Toggle tag on focused client.
    awful.key({ modkey, 'Control', 'Shift' }, '#' .. tagKey + tag_count, function()
      if client.focus then
        local tag = client.focus.screen.tags[tagIndex]
        if tag then client.focus:toggle_tag(tag) end
      end
    end, { description = 'toggle focused client on tag #' .. tagKey, group = 'tag' })
  )
end

local clientbuttons = gears.table.join(
  awful.button({}, 1, function(c) c:emit_signal('request::activate', 'mouse_click', { raise = true }) end),
  awful.button({ modkey }, 1, function(c)
    c:emit_signal('request::activate', 'mouse_click', { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function(c)
    c:emit_signal('request::activate', 'mouse_click', { raise = true })
    awful.mouse.client.resize(c)
  end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = 0,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    },
  },

  -- Floating clients.
  {
    rule_any = {
      instance = {
        'DTA', -- Firefox addon DownThemAll.
        'copyq', -- Includes session name in class.
        'pinentry',
      },
      class = {
        'Arandr',
        'Blueman-manager',
        'Gpick',
        'Kruler',
        'MessageWin', -- kalarm.
        'Sxiv',
        'Tor Browser', -- Needs a fixed window size to avoid fingerprinting by screen size.
        'Wpa_gui',
        'veromix',
        'xtightvncviewer',
        'pavucontrol',
        'transmission',
      },

      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        'App',
        'Event Tester', -- xev.
      },
      role = {
        'AlarmWindow', -- Thunderbird's calendar.
        'ConfigManager', -- Thunderbird's about:config.
        'pop-up', -- e.g. Google Chrome's (detached) Developer Tools.
      },
    },
    properties = { floating = true },
  },

  -- Add titlebars to normal clients and dialogs
  {
    rule_any = { type = { 'normal', 'dialog' } },
    properties = { titlebars_enabled = true },
  },

  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- { rule = { class = "Firefox" },
  --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal('manage', function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

client.connect_signal('manage', function(c)
  local cairo = require('lgi').cairo
  local default_icon = AWESOME_HOME .. '/icons/arch256.png'
  if c and c.valid and not c.icon then
    local s = gears.surface(default_icon)
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, s:get_width(), s:get_height())
    local cr = cairo.Context(img)
    cr:set_source_surface(s, 0, 0)
    cr:paint()
    c.icon = img._native
  end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal('request::titlebars', function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({}, 1, function()
      c:emit_signal('request::activate', 'titlebar', { raise = true })
      awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
      c:emit_signal('request::activate', 'titlebar', { raise = true })
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c):setup({
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout = wibox.layout.fixed.horizontal,
    },
    { -- Middle
      { -- Title
        align = 'center',
        widget = awful.titlebar.widget.titlewidget(c),
      },
      buttons = buttons,
      layout = wibox.layout.flex.horizontal,
    },
    { -- Right
      layout = wibox.layout.fixed.horizontal(),
      awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.floatingbutton(c),
      -- awful.titlebar.widget.maximizedbutton(c),
      -- awful.titlebar.widget.stickybutton   (c),
      awful.titlebar.widget.closebutton(c),
    },
    layout = wibox.layout.align.horizontal,
  })
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
  'mouse::enter',
  function(c) c:emit_signal('request::activate', 'mouse_enter', { raise = false }) end
)
-- }}}
