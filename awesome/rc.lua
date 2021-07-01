-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
-- modkey = "Mod4"
-- 
-- modkey or mod4 = super key
local modkey       = "Mod4"
local altkey       = "Mod1"
local ctlkey      = "Control"


-- personal variables
--change these variables if you want
local browser1          = "brave"
local browser2          = "firefox"
local editor            = os.getenv("EDITOR") or "vim"
local editorgui         = "emacs"
local filemanager       = "thunar"
local mailclient        = "evolution"
local mediaplayer       = "vlc"
local terminal          = "alacritty"
local virtualmachine    = "virt-manager"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile.left,
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
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
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "arandr", "arandr" },
   { "Emacs", "emacs" },
   { "Lock", "betterlockscreen -l dimblur" },
   { "Terminal", terminal },
   { "Log out", function() awesome.quit() end },
   { "Sleep", "systemctl suspend" },
   { "Restart", "systemctl reboot" },
   { "Shutdown", "systemctl poweroff" },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },}})

-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                      menu = mymainmenu })

-- Menubar configuration
-- menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

--local function set_wallpaper(s)
--    -- Wallpaper
--    if beautiful.wallpaper then
--       local wallpaper = beautiful.wallpaper
--       -- If wallpaper is a function, call it with the screen
--        if type(wallpaper) == "function" then
--            wallpaper = wallpaper(s)
--        end
--        gears.wallpaper.maximized(wallpaper, s, true)
--    end
--end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
--screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    -- set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({  "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, bg = beautiful.bg_normal .. "80" })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            -- s.systray = wibox.widget.systray(),
            -- s.systray.visible = true,
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(

    -- {{{ Personal keybindings
    awful.key({ }, "F12", function () awful.util.spawn( "xfce4-terminal --drop-down" ) end,
        {description = "Dropdown Terminal" , group = "Hotkeys"}),

    -- Modkey + Function Keys
    awful.key({ modkey }, "F1", function () awful.util.spawn( browser2 ) end,
        {description = "Firefox", group = "Hotkeys"}),
    awful.key({ modkey }, "F2", function () awful.util.spawn( editorgui ) end,
        {description = "Emacs" , group = "Hotkeys" }),
    awful.key({ modkey }, "F3", function() awful.util.spawn("nitrogen") end,
        {description = "Wallpapers", group = "Hotkeys"}),
    awful.key({ modkey }, "F4", function () awful.util.spawn( "gimp" ) end,
        {description = "Gimp" , group = "Hotkeys" }),
    awful.key({ modkey }, "F6", function () awful.util.spawn( "spotify" ) end,
        {description = "Spotify" , group = "Hotkeys" }),
    awful.key({ modkey }, "F7", function () awful.util.spawn( "virt-manager" ) end,
        {description = "Virt-Manager" , group = "Hotkeys" }),
    awful.key({ modkey }, "F8", function () awful.util.spawn( filemanager ) end,
        {description = "Thunar" , group = "Hotkeys" }),
    awful.key({ modkey }, "F9", function () awful.util.spawn( mailclient ) end,
        {description = "Evolution" , group = "Hotkeys" }),
    awful.key({ modkey }, "F10", function () awful.util.spawn( mediaplayer ) end,
        {description = "VLC" , group = "Hotkeys" }),

    -- Hotkeys
    awful.key({ modkey,           }, "a", function () awful.spawn(terminal) end,
              {description = "Alacritty", group = "Hotkeys"}),
    awful.key({ modkey            }, "b", function () awful.util.spawn( browser1 ) end,
        {description = "Brave", group = "Hotkeys"}),
    awful.key({ modkey            }, "r", function () awful.util.spawn( "rofi -show drun" ) end, 
              {description = "rofi" , group = "Hotkeys" }),
    awful.key({ modkey            }, "v", function () awful.util.spawn( "pavucontrol" ) end,
              {description = "PulseAudio Control", group = "Hotkeys"}),
    awful.key({ modkey1           }, "Print", function () awful.util.spawn( "xfce4-screenshooter" ) end,
              {description = "Xfce Screenshot", group = "Hotkeys"}),
    
    -- Awesome Keys
    awful.key({ modkey           }, "s",      hotkeys_popup.show_help,
              {description="Show Help", group="Awesome"}),
    awful.key({ modkey, ctlkey   }, "r", awesome.restart,
              {description = "Reload Awesome WM", group = "Awesome"}),
    awful.key({ modkey, ctlkey   }, "q", awesome.quit,
              {description = "Quit Awesome WM", group = "Awesome"}),

    -- Tag Keys
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "Move 1 Tag Left", group = "Tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "Move 1 Tag Right", group = "Tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "Go Back to Previous Tag", group = "Tag"}),

    -- Window Movement
    awful.key({ modkey, "Shift"   }, "Left", function () awful.client.swap.byidx(  1)    end,
              {description = "Swap with Next Window", group = "Windows"}),
    awful.key({ modkey, "Shift"   }, "Right", function () awful.client.swap.byidx( -1)    end,
              {description = "Swap with Previous Window", group = "Windows"}),
    awful.key({ modkey, "Shift"   }, "u", awful.client.urgent.jumpto,
              {description = "Goto Urgent Window", group = "Windows"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "Go Back to Previous Window", group = "Windows"}),
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus Restored Window
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "Restore Minimized Window", group = "Windows"}),
    
    -- Screen Movement
    awful.key({ modkey,           }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "Focus Next Screen", group = "Screen"}),
    awful.key({ modkey,           }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "Focus Previous Screen", group = "Screen"}),

    -- Layout
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "Increase Master Width Factor", group = "Layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "Decrease Master Width Factor", group = "Layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "Select Next Layout", group = "Layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "Select Previous Layout", group = "Layout"}),

    -- Run Prompts
    awful.key({ modkey            }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Lua >",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "Lua Execute Prompt", group = "Prompts"}),

    -- Menubar
    awful.key({ modkey            }, "p", function() menubar.show() end,
              {description = "Show the Menubar", group = "Menubar"}),

    -- Show/Hide Wibox
    awful.key({ modkey }, "w", 
        function ()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        {description = "Toggle Wibox", group = "Awesome"}),
    
    -- On the fly useless gaps change
    awful.key({ altkey, ctlkey }, "j", function () lain.util.useless_gaps_resize(1) end,
              {description = "Increment Useless Gaps", group = "Layout"}),
    awful.key({ altkey, ctlkey }, "h", function () lain.util.useless_gaps_resize(-1) end,
              {description = "Decrement Useless Gaps", group = "Layout"}),

    -- Brightness
    awful.key({ }, "XF86MonBrightnessUp", function () os.execute("xbacklight -inc 10") end,
              {description = "+10%", group = "Hotkeys"}),
    awful.key({ }, "XF86MonBrightnessDown", function () os.execute("xbacklight -dec 10") end,
              {description = "-10%", group = "Hotkeys"}),

    -- ALSA volume control
    awful.key({ }, "XF86AudioRaiseVolume",
        function ()
            os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
            beautiful.volume.update()
        end),
    awful.key({ }, "XF86AudioLowerVolume",
        function ()
            os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
            beautiful.volume.update()
        end),
    awful.key({ }, "XF86AudioMute",
        function ()
            os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
            beautiful.volume.update()
        end),
    awful.key({ modkey1, "Shift" }, "m",
        function ()
            os.execute(string.format("amixer -q set %s 100%%", beautiful.volume.channel))
            beautiful.volume.update()
        end),
    awful.key({ modkey1, "Shift" }, "0",
        function ()
            os.execute(string.format("amixer -q set %s 0%%", beautiful.volume.channel))
            beautiful.volume.update()
        end),

    --Media keys supported by vlc, spotify, audacious, xmm2, ...
    --awful.key({}, "XF86AudioPlay", function() awful.util.spawn("playerctl play-pause", false) end),
    --awful.key({}, "XF86AudioNext", function() awful.util.spawn("playerctl next", false) end),
    --awful.key({}, "XF86AudioPrev", function() awful.util.spawn("playerctl previous", false) end),
    --awful.key({}, "XF86AudioStop", function() awful.util.spawn("playerctl stop", false) end),

    --Media keys supported by mpd.
    awful.key({}, "XF86AudioPlay", function () awful.util.spawn("mpc toggle") end, 
              {description = "Play", group = "Media"}),
    awful.key({}, "XF86AudioNext", function () awful.util.spawn("mpc next") end, 
              {description = "Next", group = "Media"}),
    awful.key({}, "XF86AudioPrev", function () awful.util.spawn("mpc prev") end, 
              {description = "Previous", group = "Media"}),
    awful.key({}, "XF86AudioStop", function () awful.util.spawn("mpc stop") end, 
              {description = "Stop", group = "Media"})

)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "Toggle Window Fullscreen", group = "Windows"}),
    awful.key({ modkey, ctlkey   }, "c",      function (c) c:kill()                         end,
              {description = "Close Window", group = "Windows"}),
    awful.key({ modkey, ctlkey   }, "f",  awful.client.floating.toggle                     ,
              {description = "Toggle Window Floating", group = "Windows"}),
    awful.key({ modkey, ctlkey   }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "Move to Master", group = "Windows"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "Move to Screen", group = "Windows"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "Toggle Window Pin", group = "Windows"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "Minimize", group = "Windows"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "UnMaximize", group = "Windows"}),

    awful.key({ modkey, ctlkey    }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "UnMaximize vertically", group = "Windows"}),

    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "UnMaximize horizontally", group = "Windows"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "View Tag #"..i, group = "Tag"}),
        -- Toggle tag display.
        awful.key({ modkey, ctlkey  }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "Toggle Tag #" .. i, group = "Tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "Move Focused Window to Tag #"..i, group = "Tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, ctlkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "Toggle Focused Window on Tag #" .. i, group = "Tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
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
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Autostart applications
awful.spawn.with_shell("picom -b --config  $HOME/.config/picom.conf")
awful.spawn.with_shell("nitrogen --restore")
