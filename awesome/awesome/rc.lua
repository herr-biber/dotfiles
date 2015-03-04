-- check for awesome 3.5 onwards
version_major = tonumber(string.sub(awesome.version, 2, 2))
version_minor = tonumber(string.sub(awesome.version, 4, 4))
is_awesome_35 = (version_major == 3 and version_minor >= 5)

if not is_awesome_35 then 
    -- Standard awesome library
    local awful = require("awful")
    local autofocus = require("awful.autofocus")
    local rules = require("awful.rules")
    -- Theme handling library
    local beautiful = require("beautiful")
    -- Notification library
    local naughty = require("naughty")

    --if true then
    --naughty.notify({text = "bla" .. awesome.version})
    --end


    -- Load Debian menu entries
    local menu = require("debian.menu")
    local vicious = require("vicious")
    -- {{{ Variable definitions
    -- Themes define colours, icons, and wallpapers
    beautiful.init("/usr/share/awesome/themes/default/theme.lua")
    --beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")
    --beautiful.init("themes/nice-and-clean-theme/theme.lua")
    --beautiful.init("themes/tj-awesome-themes/Darklooks/theme.lua")
    --beautiful.init("themes/Darklooks/theme.lua")

    -- Override border colors
    beautiful.border_normal = "#555555"
    beautiful.border_width  = 2
    beautiful.border_focus  = "#cc0000"

    -- Mem widget
    memwidget = widget({ type = "textbox" })
    vicious.register(memwidget, vicious.widgets.mem, "M: $1% ", 13)

    -- Cpu widget
    cpuwidget = awful.widget.graph()
    cpuwidget:set_width(20)
    cpuwidget:set_background_color("#494B4F")
    cpuwidget:set_color("#FF5656")
    cpuwidget:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })
    vicious.register(cpuwidget, vicious.widgets.cpu, "$1")

    -- Vol widget
    volwidget = widget({ type = "textbox" })
    vicious.register(volwidget, vicious.widgets.volume, "V: $1% ", 2, "Master")

    -- Weather widget
    weatherwidget = widget({ type = "textbox" })
    vicious.register(weatherwidget, vicious.widgets.weather, 
        function (widget, args)
            return "T: " .. args["{tempc}"] .. " "
        end, 1200, "KLAX" )

    -- This is used later as the default terminal and editor to run.
    terminal = "urxvt"
    editor = os.getenv("EDITOR") or "editor"
    editor_cmd = terminal .. " -e " .. editor

    fileBrowser = "thunar"

    -- Default modkey.
    -- Usually, Mod4 is the key with a logo between Control and Alt.
    -- If you do not like this or do not have such a key,
    -- I suggest you to remap Mod4 to another key using xmodmap or other tools.
    -- However, you can use another modifier like Mod1, but it may interact with others.
    modkey = "Mod4"

    -- Table of layouts to cover with awful.layout.inc, order matters.
    layouts =
    {
        awful.layout.suit.floating,
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        awful.layout.suit.fair,
        awful.layout.suit.fair.horizontal,
        awful.layout.suit.spiral,
        awful.layout.suit.spiral.dwindle,
        awful.layout.suit.max,
        awful.layout.suit.max.fullscreen,
        awful.layout.suit.magnifier
    }

    -- {{{ Tags
    -- Define a tag table which will hold all screen tags.
    tags = {
        names  = { "browse", "✉", "mail", 4, 5, 6, 7, 8, 9 } ,
        layout = { awful.layout.suit.tile.bottom,
                   awful.layout.suit.fair,
                   awful.layout.suit.tile.bottom,
                   awful.layout.suit.tile,
                   awful.layout.suit.tile,
                   awful.layout.suit.tile,
                   awful.layout.suit.tile,
                   awful.layout.suit.tile,
                   awful.layout.suit.tile,
                 }
    }
    for s = 1, screen.count() do
     -- Each screen has its own tag table.
     tags[s] = awful.tag(tags.names, s, tags.layout)
    end
    -- }}}

    --for s = 1, screen.count() do
    --    -- Each screen has its own tag table.
    --    tags[s] = awful.tag({ "browse", "✉", "mail", 4, 5, 6, 7, 8, 9 }, s, layouts[1])
    --end
    -- }}}

    -- {{{ Menu
    -- Create a laucher widget and a main menu
    myawesomemenu = {
       { "manual", terminal .. " -e man awesome" },
       { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
       { "restart", awesome.restart },
       { "quit", awesome.quit }
    }

    mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                        { "Debian", debian.menu.Debian_menu.Debian },
                                        { "open terminal", terminal }
                                      }
                            })

    mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                         menu = mymainmenu })
    -- }}}

    -- {{{ Wibox
    -- Create a textclock widget
    mytextclock = awful.widget.textclock({ align = "right" })

    -- Create a systray
    mysystray = widget({ type = "systray" })

    -- Create a wibox for each screen and add it
    mywibox = {}
    mypromptbox = {}
    mylayoutbox = {}
    mytaglist = {}
    mytaglist.buttons = awful.util.table.join(
                        awful.button({ }, 1, awful.tag.viewonly),
                        awful.button({ modkey }, 1, awful.client.movetotag),
                        awful.button({ }, 3, awful.tag.viewtoggle),
                        awful.button({ modkey }, 3, awful.client.toggletag),
                        awful.button({ }, 4, awful.tag.viewnext),
                        awful.button({ }, 5, awful.tag.viewprev)
                        )
    mytasklist = {}
    mytasklist.buttons = awful.util.table.join(
                         awful.button({ }, 1, function (c)
                                                  if c == client.focus then
                                                      c.minimized = true
                                                  else
                                                      if not c:isvisible() then
                                                          awful.tag.viewonly(c:tags()[1])
                                                      end
                                                      -- This will also un-minimize
                                                      -- the client, if needed
                                                      client.focus = c
                                                      c:raise()
                                                  end
                                              end),
                         awful.button({ }, 3, function ()
                                                  if instance then
                                                      instance:hide()
                                                      instance = nil
                                                  else
                                                      instance = awful.menu.clients({ width=250 })
                                                  end
                                              end),
                         awful.button({ }, 4, function ()
                                                  awful.client.focus.byidx(1)
                                                  if client.focus then client.focus:raise() end
                                              end),
                         awful.button({ }, 5, function ()
                                                  awful.client.focus.byidx(-1)
                                                  if client.focus then client.focus:raise() end
                                              end))

    for s = 1, screen.count() do
        -- Create a promptbox for each screen
        mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
        -- Create an imagebox widget which will contains an icon indicating which layout we're using.
        -- We need one layoutbox per screen.
        mylayoutbox[s] = awful.widget.layoutbox(s)
        mylayoutbox[s]:buttons(awful.util.table.join(
                               awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                               awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                               awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                               awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
        -- Create a taglist widget
        mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

        -- Create a tasklist widget
        mytasklist[s] = awful.widget.tasklist(function(c)
                                                  return awful.widget.tasklist.label.currenttags(c, s)
                                              end, mytasklist.buttons)

        -- Create the wibox
        mywibox[s] = awful.wibox({ position = "bottom", screen = s })
        -- Add widgets to the wibox - order matters
        mywibox[s].widgets = {
            {
                mylauncher,
                mytaglist[s],
                mypromptbox[s],
                layout = awful.widget.layout.horizontal.leftright
            },
            mylayoutbox[s],
            mytextclock,
            memwidget,
            cpuwidget,
            volwidget,
            weatherwidget,
            s == 1 and mysystray or nil,
            mytasklist[s],
            layout = awful.widget.layout.horizontal.rightleft
        }
    end
    -- }}}

    -- {{{ Mouse bindings
    root.buttons(awful.util.table.join(
        awful.button({ }, 3, function () mymainmenu:toggle() end),
        awful.button({ }, 4, awful.tag.viewnext),
        awful.button({ }, 5, awful.tag.viewprev)
    ))
    -- }}}

    -- {{{ Key bindings
    globalkeys = awful.util.table.join(
        awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
        awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
        awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

        awful.key({ modkey,           }, "j",
            function ()
                awful.client.focus.byidx( 1)
                if client.focus then client.focus:raise() end
            end),
        awful.key({ "Mod1",           }, "Tab",
            function ()
                awful.client.focus.byidx( 1)
                if client.focus then client.focus:raise() end
            end),
            
        awful.key({ modkey,           }, "k",
            function ()
                awful.client.focus.byidx(-1)
                if client.focus then client.focus:raise() end
            end),
        awful.key({ "Mod1", "Shift"   }, "Tab",
            function ()
                awful.client.focus.byidx(-1)
                if client.focus then client.focus:raise() end
            end),

        awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

        -- Layout manipulation
        awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
        awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
        awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
        awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
        awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
        awful.key({ modkey,           }, "Tab",
            function ()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end),

        -- Standard program
        awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
        awful.key({ modkey,           }, "BackSpace", function () awful.util.spawn(fileBrowser) end),
        awful.key({ modkey, "Control" }, "r", awesome.restart),
        awful.key({ modkey, "Shift"   }, "q", awesome.quit),

        awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
        awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
        awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
        awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
        awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
        awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
        awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
        awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

        awful.key({ modkey, "Control" }, "n", awful.client.restore),
        awful.key({ modkey,           }, "F1",    function () awful.screen.focus(2) end),
        awful.key({ modkey,           }, "F2",    function () awful.screen.focus(1) end),

        -- Prompt
        awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
        awful.key({ "Mod1" },            "F2",    function () mypromptbox[mouse.screen]:run() end),

        awful.key({ "Mod1", "Control" }, "l",     function () os.execute("gnome-screensaver-command -l") end),
        awful.key({ modkey, "Control" }, "q",     function () awful.util.spawn("/usr/lib/indicator-session/gtk-logout-helper --logout") end),
        awful.key({ modkey, "Control" }, "w",     function () awful.util.spawn("/usr/lib/indicator-session/gtk-logout-helper --shutdown") end),
        awful.key({ modkey, "Control" }, "e",     function () awful.util.spawn("/usr/lib/indicator-session/gtk-logout-helper --restart") end),

        awful.key({ modkey }, "x",
                  function ()
                      awful.prompt.run({ prompt = "Run Lua code: " },
                      mypromptbox[mouse.screen].widget,
                      awful.util.eval, nil,
                      awful.util.getdir("cache") .. "/history_eval")
                  end),
                  
        awful.key({ }, "XF86AudioRaiseVolume", function ()
            awful.util.spawn("amixer set Master 5%+") end),
        awful.key({ }, "XF86AudioLowerVolume", function ()
            awful.util.spawn("amixer set Master 5%-") end),
        awful.key({ }, "XF86AudioMute", function ()
            awful.util.spawn("amixer sset Master toggle") end)
    )

    clientkeys = awful.util.table.join(
        awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
        awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
        awful.key({ "Mod1",           }, "F4",     function (c) c:kill()                         end),
        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
        awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
        awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
        awful.key({ modkey,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end),
        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c.maximized_vertical   = not c.maximized_vertical
            end)
    )

    -- Compute the maximum number of digit we need, limited to 9
    keynumber = 0
    for s = 1, screen.count() do
       keynumber = math.min(9, math.max(#tags[s], keynumber));
    end

    -- Bind all key numbers to tags.
    -- Be careful: we use keycodes to make it works on any keyboard layout.
    -- This should map on the top row of your keyboard, usually 1 to 9.
    for i = 1, keynumber do
        globalkeys = awful.util.table.join(globalkeys,
            awful.key({ modkey }, "#" .. i + 9,
                      function ()
                            local screen = mouse.screen
                            if tags[screen][i] then
                                awful.tag.viewonly(tags[screen][i])
                            end
                      end),
            awful.key({ modkey, "Control" }, "#" .. i + 9,
                      function ()
                          local screen = mouse.screen
                          if tags[screen][i] then
                              awful.tag.viewtoggle(tags[screen][i])
                          end
                      end),
            awful.key({ modkey, "Shift" }, "#" .. i + 9,
                      function ()
                          if client.focus and tags[client.focus.screen][i] then
                              awful.client.movetotag(tags[client.focus.screen][i])
                          end
                      end),
            awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                      function ()
                          if client.focus and tags[client.focus.screen][i] then
                              awful.client.toggletag(tags[client.focus.screen][i])
                          end
                      end))
    end

    clientbuttons = awful.util.table.join(
        awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
        awful.button({ modkey }, 1, awful.mouse.client.move),
        awful.button({ modkey }, 3, awful.mouse.client.resize))

    -- Set keys
    root.keys(globalkeys)
    -- }}}

    -- {{{ Rules
    awful.rules.rules = {
        -- All clients will match this rule.
        { rule = { },
          properties = { border_width = beautiful.border_width,
                         border_color = beautiful.border_normal,
                         focus = true,
                         keys = clientkeys,
                         buttons = clientbuttons,
                         size_hints_honor = false } },
        { rule = { class = "MPlayer" },
          properties = { floating = true } },
        { rule = { class = "pinentry" },
          properties = { floating = true } },
        { rule = { class = "Gimp" },
          properties = { floating = true } },
        -- Set Firefox to always map on tags number 2 of screen 1.
        -- { rule = { class = "Firefox" },
        --   properties = { tag = tags[1][2] } },
        { rule = { class = "Tilda" },
          properties = { floating = true} },
        { rule = { class = "Skype" },
          properties = { tag = tags[1][2],
                         floating = true } },
        { rule = { class = "Git-gui" },
          properties = { maximized_horizontal = true,
                         maximized_vertical   = true } },
        { rule = { class = "Git-citool" },
          properties = { maximized_horizontal = true,
                         maximized_vertical   = true } },
        { rule = { class = "Gitk" },
          properties = { maximized_horizontal = true,
                         maximized_vertical   = true } },
        { rule = { class = "Thunderbird" },
          properties = { tag = tags[1][3] } },
        { rule = { class = "VirtualBox" },
          properties = { tag = tags[1][9] } },
        { rule = { class = "associator" },
          properties = { tag = tags[1][5] } },
        { rule = { class = "Git-gui" },
          properties = { maximized_horizontal = true,
                         maximized_vertical   = true } },
        { rule = { class = "Git-citool" },
          properties = { maximized_horizontal = true,
                         maximized_vertical   = true } },
        { rule = { class = "Gitk" },
          properties = { maximized_horizontal = true,
                         maximized_vertical   = true } },
        { rule = { name = "Super Hexagon" },
          properties = { floating = true} },
        { rule = { instance = "TeamViewer.exe" },
          properties = { floating = true } },
        { rule = { class = "Exe"},
          properties = {floating = true} },
        { rule = { class = "Steam"}, 
          properties = {floating = true} },
        { rule = { class = "Stack.bin.x86"}, 
          properties = {floating = true} },
        { rule = { name = "File Operation Progress"}, -- thunar file operation progress
          properties = {floating = true} },
        { rule = { class = "Totalview", instance = "altVarWindow"},
          properties = {floating = true} },
        { rule = { class = "Totalview", instance = "RootWindow"},
          properties = {floating = true} },
    }
    -- }}}

    -- {{{ Signals
    -- Signal function to execute when a new client appears.
    client.add_signal("manage", function (c, startup)
        -- Add a titlebar
        -- awful.titlebar.add(c, { modkey = modkey })

        -- Enable sloppy focus
    --    c:add_signal("mouse::enter", function(c)
    --        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    --            and awful.client.focus.filter(c) then
    --            client.focus = c
    --        end
    --    end)

        if not startup then
            -- Set the windows at the slave,
            -- i.e. put it at the end of others instead of setting it master.
            -- awful.client.setslave(c)

            -- Put windows in a smart way, only if they does not set an initial position.
            if not c.size_hints.user_position and not c.size_hints.program_position then
                awful.placement.no_overlap(c)
                awful.placement.no_offscreen(c)
            end
        end
    end)


    client.add_signal("focus", 
        function(c) 
            if c.maximized_horizontal == true and c.maximized_vertical == true then
                c.border_width = 0
            else
                c.border_width = beautiful.border_width
            end
                
            c.border_color = beautiful.border_focus
        end)
    client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
    -- }}}

    -- os.execute("nm-applet &")
    os.execute("if ! ps -e | grep \"nm-applet\"; then exec nm-applet & fi")
    --os.execute("if ! ps -e | grep \"tilda\"; then exec tilda & fi")
    os.execute("gnome-settings-daemon &")
    os.execute("gnome-sound-applet &")
    --os.execute("bluetooth-applet &")
    os.execute("/home/markus/bin/setmode &")

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
else
    -- Standard awesome library
    local gears = require("gears")
    local awful = require("awful")
    awful.rules = require("awful.rules")
    require("awful.autofocus")
    -- Widget and layout library
    local wibox = require("wibox")
    -- Theme handling library
    local beautiful = require("beautiful")
    -- Notification library
    local naughty = require("naughty")
    local menubar = require("menubar")

    bashets = require("bashets/bashets")
    
   local APW = require("apw/widget")
    batterystatus = wibox.widget.textbox()
    bashets.register("/usr/bin/acpi -b | cut -d ' ' -f4 | cut -d ',' -f1", 
       {
           widget = batterystatus,
           update_time = 60, 
           separator = '|',
           format = "  B:$1" 
       })


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
                             text = err })
            in_error = false
        end)
    end
    -- }}}

    -- {{{ Variable definitions
    -- Themes define colours, icons, and wallpapers
    beautiful.init("/usr/share/awesome/themes/default/theme.lua")

    -- Override border colors
    beautiful.border_normal = "#555555"
    beautiful.border_width  = 2
    beautiful.border_focus  = "#cc0000"


    -- This is used later as the default terminal and editor to run.
    terminal = "urxvt"
    editor = os.getenv("EDITOR") or "nano"
    editor_cmd = terminal .. " -e " .. editor
    fileBrowser = "nemo"


    -- Default modkey.
    -- Usually, Mod4 is the key with a logo between Control and Alt.
    -- If you do not like this or do not have such a key,
    -- I suggest you to remap Mod4 to another key using xmodmap or other tools.
    -- However, you can use another modifier like Mod1, but it may interact with others.
    modkey = "Mod4"

    -- Table of layouts to cover with awful.layout.inc, order matters.
    local layouts =
    {
        awful.layout.suit.floating,
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        awful.layout.suit.fair,
        awful.layout.suit.fair.horizontal,
        awful.layout.suit.spiral,
        awful.layout.suit.spiral.dwindle,
        awful.layout.suit.max,
        awful.layout.suit.max.fullscreen,
        awful.layout.suit.magnifier
    }
    -- }}}

    -- {{{ Wallpaper
    if beautiful.wallpaper then
        for s = 1, screen.count() do
            gears.wallpaper.maximized(beautiful.wallpaper, s, true)
        end
    end
    -- }}}

    -- {{{ Tags
    -- Define a tag table which hold all screen tags.
    tags = {}
    for s = 1, screen.count() do
        -- Each screen has its own tag table.
        tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[2])
    end
    -- }}}

    -- {{{ Menu
    -- Create a laucher widget and a main menu
    myawesomemenu = {
       { "manual", terminal .. " -e man awesome" },
       { "edit config", editor_cmd .. " " .. awesome.conffile },
       { "restart", awesome.restart },
       { "quit", awesome.quit }
    }

    mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                        { "open terminal", terminal }
                                      }
                            })

    mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                         menu = mymainmenu })

    -- Menubar configuration
    menubar.utils.terminal = terminal -- Set the terminal for applications that require it
    -- }}}

    -- {{{ Wibox
    -- Create a textclock widget
    mytextclock = awful.widget.textclock()

    -- Create a wibox for each screen and add it
    mywibox = {}
    mypromptbox = {}
    mylayoutbox = {}
    mytaglist = {}
    mytaglist.buttons = awful.util.table.join(
                        awful.button({ }, 1, awful.tag.viewonly),
                        awful.button({ modkey }, 1, awful.client.movetotag),
                        awful.button({ }, 3, awful.tag.viewtoggle),
                        awful.button({ modkey }, 3, awful.client.toggletag),
                        awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                        awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                        )
    mytasklist = {}
    mytasklist.buttons = awful.util.table.join(
                         awful.button({ }, 1, function (c)
                                                  if c == client.focus then
                                                      c.minimized = true
                                                  else
                                                      -- Without this, the following
                                                      -- :isvisible() makes no sense
                                                      c.minimized = false
                                                      if not c:isvisible() then
                                                          awful.tag.viewonly(c:tags()[1])
                                                      end
                                                      -- This will also un-minimize
                                                      -- the client, if needed
                                                      client.focus = c
                                                      c:raise()
                                                  end
                                              end),
                         awful.button({ }, 3, function ()
                                                  if instance then
                                                      instance:hide()
                                                      instance = nil
                                                  else
                                                      instance = awful.menu.clients({ width=250 })
                                                  end
                                              end),
                         awful.button({ }, 4, function ()
                                                  awful.client.focus.byidx(1)
                                                  if client.focus then client.focus:raise() end
                                              end),
                         awful.button({ }, 5, function ()
                                                  awful.client.focus.byidx(-1)
                                                  if client.focus then client.focus:raise() end
                                              end))

    for s = 1, screen.count() do
        -- Create a promptbox for each screen
        mypromptbox[s] = awful.widget.prompt()
        -- Create an imagebox widget which will contains an icon indicating which layout we're using.
        -- We need one layoutbox per screen.
        mylayoutbox[s] = awful.widget.layoutbox(s)
        mylayoutbox[s]:buttons(awful.util.table.join(
                               awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                               awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                               awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                               awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
        -- Create a taglist widget
        mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

        -- Create a tasklist widget
        mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

        -- Create the wibox
        mywibox[s] = awful.wibox({ position = "bottom", screen = s })

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(mylauncher)
        left_layout:add(mytaglist[s])
        left_layout:add(mypromptbox[s])

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        if s == 1 then right_layout:add(wibox.widget.systray()) end
        right_layout:add(APW)
        right_layout:add(batterystatus)
        right_layout:add(mytextclock)
        right_layout:add(mylayoutbox[s])

        -- Now bring it all together (with the tasklist in the middle)
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_middle(mytasklist[s])
        layout:set_right(right_layout)

        mywibox[s]:set_widget(layout)
    end
    -- }}}

    -- {{{ Mouse bindings
    root.buttons(awful.util.table.join(
        awful.button({ }, 3, function () mymainmenu:toggle() end),
        awful.button({ }, 4, awful.tag.viewnext),
        awful.button({ }, 5, awful.tag.viewprev)
    ))
    -- }}}

    -- {{{ Key bindings
    globalkeys = awful.util.table.join(
        awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
        awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
        awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

        awful.key({ modkey,           }, "j",
            function ()
                awful.client.focus.byidx( 1)
                if client.focus then client.focus:raise() end
            end),
        awful.key({ "Mod1",           }, "Tab",
            function ()
                awful.client.focus.byidx( 1)
                if client.focus then client.focus:raise() end
            end),

        awful.key({ modkey,           }, "k",
            function ()
                awful.client.focus.byidx(-1)
                if client.focus then client.focus:raise() end
            end),
        awful.key({ "Mod1", "Shift"   }, "Tab",
            function ()
                awful.client.focus.byidx(-1)
                if client.focus then client.focus:raise() end
            end),

        awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

        -- Layout manipulation
        awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
        awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
        awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
        awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
        awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
        awful.key({ modkey,           }, "Tab",
            function ()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end),

        -- Standard program
        awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
        awful.key({ modkey,           }, "BackSpace", function () awful.util.spawn(fileBrowser) end),
        awful.key({ modkey, "Control" }, "r", awesome.restart),
        awful.key({ modkey, "Shift"   }, "q", awesome.quit),

        awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
        awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
        awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
        awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
        awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
        awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
        awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
        awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

        awful.key({ modkey, "Control" }, "n", awful.client.restore),

        -- Prompt
        awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
        awful.key({ "Mod1" },            "F2",    function () mypromptbox[mouse.screen]:run() end),

        awful.key({ modkey }, "x",
                  function ()
                      awful.prompt.run({ prompt = "Run Lua code: " },
                      mypromptbox[mouse.screen].widget,
                      awful.util.eval, nil,
                      awful.util.getdir("cache") .. "/history_eval")
                  end),
        -- Menubar
        awful.key({ modkey }, "p", function() menubar.show() end),
        awful.key({ }, "XF86AudioRaiseVolume",  APW.Up),
        awful.key({ }, "XF86AudioLowerVolume",  APW.Down),
        awful.key({ }, "XF86AudioMute",         APW.ToggleMute)
    )

    clientkeys = awful.util.table.join(
        awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
        awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
        awful.key({ "Mod1",           }, "F4",     function (c) c:kill()                         end),
        awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
        awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
        awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
        awful.key({ modkey,           }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end),
        awful.key({ modkey,           }, "m",
            function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c.maximized_vertical   = not c.maximized_vertical
            end)
    )

    -- Bind all key numbers to tags.
    -- Be careful: we use keycodes to make it works on any keyboard layout.
    -- This should map on the top row of your keyboard, usually 1 to 9.
    for i = 1, 9 do
        globalkeys = awful.util.table.join(globalkeys,
            awful.key({ modkey }, "#" .. i + 9,
                      function ()
                            local screen = mouse.screen
                            local tag = awful.tag.gettags(screen)[i]
                            if tag then
                               awful.tag.viewonly(tag)
                            end
                      end),
            awful.key({ modkey, "Control" }, "#" .. i + 9,
                      function ()
                          local screen = mouse.screen
                          local tag = awful.tag.gettags(screen)[i]
                          if tag then
                             awful.tag.viewtoggle(tag)
                          end
                      end),
            awful.key({ modkey, "Shift" }, "#" .. i + 9,
                      function ()
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if client.focus and tag then
                              awful.client.movetotag(tag)
                         end
                      end),
            awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                      function ()
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if client.focus and tag then
                              awful.client.toggletag(tag)
                          end
                      end))
    end

    clientbuttons = awful.util.table.join(
        awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
        awful.button({ modkey }, 1, awful.mouse.client.move),
        awful.button({ modkey }, 3, awful.mouse.client.resize))

    -- Set keys
    root.keys(globalkeys)
    -- }}}

    -- {{{ Rules
    awful.rules.rules = {
        -- All clients will match this rule.
        { rule = { },
          properties = { border_width = beautiful.border_width,
                         border_color = beautiful.border_normal,
                         focus = awful.client.focus.filter,
                         keys = clientkeys,
                         buttons = clientbuttons } },
        { rule = { class = "MPlayer" },
          properties = { floating = true } },
        { rule = { class = "pinentry" },
          properties = { floating = true } },
        { rule = { class = "Gimp" },
          properties = { floating = true } },
        { rule = { class = "Tilda" },
          properties = { floating = true} },
        { rule = { class = "Skype" },
          properties = { tag = tags[1][2],
                         floating = true } },
        { rule = { class = "Git-gui" },
          properties = { maximized_horizontal = true,
                         maximized_vertical   = true } },
        { rule = { class = "Git-citool" },
          properties = { maximized_horizontal = true,
                         maximized_vertical   = true } },
        { rule = { class = "Gitk" },
          properties = { maximized_horizontal = true,
                         maximized_vertical   = true } },
        { rule = { class = "Thunderbird" },
          properties = { tag = tags[1][3] } },
        { rule = { class = "VirtualBox" },
          properties = { tag = tags[1][9] } },
        { rule = { class = "associator" },
          properties = { tag = tags[1][5] } },
        { rule = { class = "Git-gui" },
          properties = { maximized_horizontal = true,
                         maximized_vertical   = true } },
        { rule = { class = "Git-citool" },
          properties = { maximized_horizontal = true,
                         maximized_vertical   = true } },
        { rule = { class = "Gitk" },
          properties = { maximized_horizontal = true,
                         maximized_vertical   = true } },
        { rule = { instance = "TeamViewer.exe" },
          properties = { floating = true } },
        { rule = { class = "Exe"},
          properties = {floating = true} },
        { rule = { name = "File Operation Progress"}, -- thunar file operation progress
          properties = {floating = true} },
        { rule = { class = "URxvt"},
          properties = { size_hints_honor = false} },
        { rule = { class = "Totalview", instance = "altVarWindow"},
          properties = {floating = true} },
        { rule = { class = "Totalview", instance = "RootWindow"},
          properties = {floating = true} },          
    }
    -- }}}

    -- {{{ Signals
    -- Signal function to execute when a new client appears.
    client.connect_signal("manage", function (c, startup)
        -- Enable sloppy focus
    --    c:connect_signal("mouse::enter", function(c)
    --        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    --            and awful.client.focus.filter(c) then
    --            client.focus = c
    --        end
    --    end)

        if not startup then
            -- Set the windows at the slave,
            -- i.e. put it at the end of others instead of setting it master.
            -- awful.client.setslave(c)

            -- Put windows in a smart way, only if they does not set an initial position.
            if not c.size_hints.user_position and not c.size_hints.program_position then
                awful.placement.no_overlap(c)
                awful.placement.no_offscreen(c)
            end
        end

        local titlebars_enabled = false
        if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
            -- buttons for the titlebar
            local buttons = awful.util.table.join(
                    awful.button({ }, 1, function()
                        client.focus = c
                        c:raise()
                        awful.mouse.client.move(c)
                    end),
                    awful.button({ }, 3, function()
                        client.focus = c
                        c:raise()
                        awful.mouse.client.resize(c)
                    end)
                    )

            -- Widgets that are aligned to the left
            local left_layout = wibox.layout.fixed.horizontal()
            left_layout:add(awful.titlebar.widget.iconwidget(c))
            left_layout:buttons(buttons)

            -- Widgets that are aligned to the right
            local right_layout = wibox.layout.fixed.horizontal()
            right_layout:add(awful.titlebar.widget.floatingbutton(c))
            right_layout:add(awful.titlebar.widget.maximizedbutton(c))
            right_layout:add(awful.titlebar.widget.stickybutton(c))
            right_layout:add(awful.titlebar.widget.ontopbutton(c))
            right_layout:add(awful.titlebar.widget.closebutton(c))

            -- The title goes in the middle
            local middle_layout = wibox.layout.flex.horizontal()
            local title = awful.titlebar.widget.titlewidget(c)
            title:set_align("center")
            middle_layout:add(title)
            middle_layout:buttons(buttons)

            -- Now bring it all together
            local layout = wibox.layout.align.horizontal()
            layout:set_left(left_layout)
            layout:set_right(right_layout)
            layout:set_middle(middle_layout)

            awful.titlebar(c):set_widget(layout)
        end
    end)

    client.connect_signal("focus", 
        function(c) 
            if c.maximized_horizontal == true and c.maximized_vertical == true then
                c.border_width = 0
            else
                c.border_width = beautiful.border_width
            end

            c.border_color = beautiful.border_focus 
       end)
    client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
    -- }}}

end
