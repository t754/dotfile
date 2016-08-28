--  rc.lua
--  custom initialization for awesome windowmanager 3.5.x
--
 -- Copyright (C) 2012, 2013 by Togan Muftuoglu <toganm@opensuse.org>
 -- Copyright (C) 2015 by Sorokin Alexei <sor.alexei@meowr.ru>
 -- This program is free software; you can redistribute it and/or
 -- modify it under the terms of the GNU General Public License as
 -- published by the Free Software Foundation; either version 2, or (at
 -- your option) any later version.

 -- This program is distributed in the hope that it will be useful, but
 -- WITHOUT ANY WARRANTY; without even the implied warranty of
 -- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 -- General Public License for more details.

 -- You should have received a copy of the GNU General Public License
 -- along with GNU Emacs; see the file COPYING.  If not, write to the
 -- Free Software Foundation, Inc.,  51 Franklin Street, Fifth Floor,
 -- Boston, MA 02110-1301 USA


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

-- Freedesktop integration
--require("freedesktop.menu")
--require("freedesktop.desktop")
-- calendar functions

-- Extra widgets
local vicious = require("vicious")
-- to create shortcuts help screen
local keydoc = require("keydoc")
local ror = require("aweror")


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
-- Themes define colours, icons, font and wallpapers.
-- Use personal theme if existing else goto default
do
    local user_theme, ut
    user_theme = awful.util.getdir("config") .. "/themes/theme.lua"
    ut = io.open(user_theme)
    if ut then
        io.close(ut)
        beautiful.init(user_theme)
    else
        print("Personal theme doesn't exist, falling back to openSUSE")
        beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")
    end
end

-- This is used later as the default terminal and editor to run.
terminal = "xfce4-terminal"
editor = os.getenv("EDITOR") or os.getenv("VISUAL") or "vi"
editor_cmd = terminal .. " -e " .. editor

menubar.utils.terminal = terminal

--- Themes define colours, icons, and wallpapers
--- beautiful.init("/usr/share/awesome/themes/sky/theme.lua")

--revelation.init()
-- ------------ --
-- テーマの改造 --
-- ------------ --
myfont = "Ricty 18"
awesome.font          = myfont
theme.font          = myfont
beautiful.font          = myfont
naughty.config.defaults.font = myfont
theme.menu_height           = 32
theme.menu_width            = 200

menubar.font          = "Ricty 18"
menubar.cache_entries = true
menubar.show_categories = tr

menubar.menu_gen.all_menu_dirs = { "/usr/share/applications/", "/usr/local/share/applications", "~/.local/share/applications" }
modkey = "Mod4"
menubar.geometry = {
   height = 32
}
-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier
}
-- Get active outputs
local function outputs()
   local outputs = {}
   local xrandr = io.popen("xrandr -q")
   if xrandr then
      for line in xrandr:lines() do
	 output = line:match("^([%w-]+) connected ")
	 if output then
	    outputs[#outputs + 1] = output
	 end
      end
      xrandr:close()
   end

   return outputs
end

local function arrange(out)
   -- We need to enumerate all the way to combinate output. We assume
   -- we want only an horizontal layout.
   local choices  = {}
   local previous = { {} }
   for i = 1, #out do
      -- Find all permutation of length `i`: we take the permutation
      -- of length `i-1` and for each of them, we create new
      -- permutations by adding each output at the end of it if it is
      -- not already present.
      local new = {}
      for _, p in pairs(previous) do
	 for _, o in pairs(out) do
	    if not awful.util.table.hasitem(p, o) then
	       new[#new + 1] = awful.util.table.join(p, {o})
	    end
	 end
      end
      choices = awful.util.table.join(choices, new)
      previous = new
   end

   return choices
end

-- Build available choices
local function menu()
   local menu = {}
   local out = outputs()
   local choices = arrange(out)

   for _, choice in pairs(choices) do
      local cmd = "xrandr"
      -- Enabled outputs
      for i, o in pairs(choice) do
	 cmd = cmd .. " --output " .. o .. " --auto"
	 if i > 1 then
	    cmd = cmd .. " --right-of " .. choice[i-1]
	 end
      end
      -- Disabled outputs
      for _, o in pairs(out) do
	 if not awful.util.table.hasitem(choice, o) then
	    cmd = cmd .. " --output " .. o .. " --off"
	 end
      end

      local label = ""
      if #choice == 1 then
	 label = 'Only <span weight="bold">' .. choice[1] .. '</span>'
      else
	 for i, o in pairs(choice) do
	    if i > 1 then label = label .. " + " end
	    label = label .. '<span weight="bold">' .. o .. '</span>'
	 end
      end

      menu[#menu + 1] = { label,
			  cmd,
                          "/usr/share/icons/Tango/32x32/devices/display.png"}
   end

   return menu
end


-- Display xrandr notifications from choices
local state = { iterator = nil,
		timer = nil,
		cid = nil }

function unpack (t, i)
   i = i or 1
   if t[i] ~= nil then
      return t[i], unpack(t, i + 1)
   end
end


local function xrandr()
   -- Stop any previous timer
   if state.timer then
      state.timer:stop()
      state.timer = nil
   end

   -- Build the list of choices
   if not state.iterator then
      state.iterator = awful.util.table.iterate(menu(),
                                                function() return true end)
   end

   -- Select one and display the appropriate notification
   local next  = state.iterator()
   local label, action, icon
   if not next then
      label, icon = "Keep the current configuration", "/usr/share/icons/Tango/32x32/devices/display.png"
      state.iterator = nil
   else
      label, action, icon = unpack(next)
   end
   state.cid = naughty.notify({ text = label,
                                icon = icon,
                                timeout = 4,
                                screen = mouse.screen, -- Important, not all screens may be visible
                                font = "Free Sans 18",
                                replaces_id = state.cid }).id

   -- Setup the timer
   state.timer = timer { timeout = 4 }
   state.timer:connect_signal("timeout",
                              function()
                                 state.timer:stop()
                                 state.timer = nil
                                 state.iterator = nil
                                 if action then
                                    awful.util.spawn(action, false)
                                 end
   end)
   state.timer:start()
end

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

-- tagsnames={ "📝", "🌐", "📃"
--             ,"4", "💻","🎵"
--             ,"7","📛","🔑"}

for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
  mysystem_menu = {
      { 'Lock Screen',     'light-locker-command --lock', menubar.utils.lookup_icon('system-lock-screen') },
      { 'Logout',           awesome.quit,                 menubar.utils.lookup_icon('system-log-out')     },
      { 'Reboot System',   'systemctl reboot',            menubar.utils.lookup_icon('reboot-notifier')    },
      { 'Shutdown System', 'systemctl poweroff',          menubar.utils.lookup_icon('system-shutdown')    }
   }

  myawesome_menu = {
     { 'Restart Awesome', awesome.restart, menubar.utils.lookup_icon('gtk-refresh') },
     { "Edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua", menubar.utils.lookup_icon('package_settings') },
     { "manual", terminal .. " -e man awesome" }
  }

  top_menu = {
     --{ 'Applications', freedesktop.menu.new(), menubar.utils.lookup_icon('start-here') },
     { 'Awesome',      myawesome_menu,         beautiful.awesome_icon                  },
     { 'System',       mysystem_menu,          menubar.utils.lookup_icon('system')     },
     { 'Terminal',     menubar.utils.terminal, menubar.utils.lookup_icon('terminal')   }
  }

mymainmenu = awful.menu.new({ items = top_menu, width = 150 })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Desktop icons
--for s = 1, screen.count() do
--   freedesktop.desktop.add_applications_icons({screen = s, showlabels = true})
--   freedesktop.desktop.add_dirs_and_files_icons({screen = s, showlabels = true})
--end

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- We need spacer and separator between the widgets
spacer = wibox.widget.textbox()
separator = wibox.widget.textbox()
spacer:set_text(" ")
separator:set_text("|")

-- Create a textclock widget
-- mytextclock = awful.widget.textclock("%m/%d%a-%H:%M")
datewidget = wibox.widget.textbox()
datewidget:set_font(myfont)
vicious.register(datewidget, vicious.widgets.date, "%m-%d(%a)%H:%M", 29)

cputempwidget = wibox.widget.textbox()
cputempwidget:set_font(myfont)
vicious.register(cputempwidget, vicious.widgets.thermal, "$1℃", 7, { "coretemp.0/hwmon/hwmon0/", "core"})

cpuwidget = awful.widget.graph()

cpuwidget:set_width(50)
cpuwidget:set_background_color("#494B4F")
cpuwidget:set_color("#AECF96")
vicious.register(cpuwidget, vicious.widgets.cpu, "$1",0.3)

mybattery = wibox.widget.textbox()
vicious.register(mybattery, function(format, warg)
    local args = vicious.widgets.bat(format, warg)
    if args[2] < (100 / 3)  then
       args['{color}'] = 'red'
    elseif args[2] < (2 * 100 / 3) then
       args['{color}'] = 'yellow'
    else
       args['{color}'] = 'blue'
    end
    return args
end, '<span foreground="${color}">bat: $2% $3h</span>', 10, 'BAT0')



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
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
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
    mywibox[s] = awful.wibox({ position = "top", screen = s ,height = theme.menu_height})

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(datewidget)
    right_layout:add(separator)
    -- right_layout:add(spacer)

    right_layout:add(cputempwidget)
    -- right_layout:add(spacer)
    right_layout:add(separator)
    right_layout:add(spacer)

    right_layout:add(cpuwidget)
    right_layout:add(spacer)
    right_layout:add(separator)
    right_layout:add(spacer)

    right_layout:add(mybattery)
    right_layout:add(spacer)
    right_layout:add(separator)
    right_layout:add(spacer)


    -- right_layout:add(separator)
    -- right_layout:add(spacer)

    -- right_layout:add(wifi)
    -- right_layout:add(spacer)
    -- right_layout:add(separator)
    -- right_layout:add(spacer)

    -- right_layout:add(myweatherwidget)
    -- right_layout:add(spacer)
    -- right_layout:add(separator)
    -- right_layout:add(spacer)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- these are needed by the keydoc a better solution would be to place them in theme.lua
-- but leaving them here also provides a mean to change the colours here ;)

   beautiful.fg_widget_value="green"
   beautiful.fg_widget_clock="gold"
   beautiful.fg_widget_value_important="red"


-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
   keydoc.group("Global Keys"),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,"Previous Tag" ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,"Next tag" ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,"Clear Choice"),
    awful.key({modkey,}, "F1",keydoc.display,"Display Keymap Menu"),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end,"Raise focus"),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,"Show menu"),

    -- Layout manipulation
    keydoc.group("Layout manipulation"),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,"Swap with next window"),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,"Swap with previous window "),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,"Relative focus increase" ),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,"Relative focus decrease"),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,"Jump to window "),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,"Cycle windows or windows style"),

    -- Standard program
    keydoc.group("Standard Programs"),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(terminal) end,"Open terminal"),
    awful.key({ modkey, "Control" }, "r", awesome.restart,"Restart awesome"),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,"Quit awesome"),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end,"Increase window size"),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end,"Decrease window size"),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end,"Increase master"),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end,"Decrease master"),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end,"Increase column"),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end,"Decrease column"),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end,"Cycle layout style forward"),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end,"Cycle layout style reverse"),
    awful.key({ modkey, "Control" }, "n", awful.client.restore,"Client restore"),
    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end,"Run command"),
    -- this function below will enable ssh login as long as the remote host is defined in $HOME/.ssh/config
    -- else by give the remote host name at the prompt which will also work
    awful.key({ modkey,           }, "s",
              function ()
                  awful.prompt.run({ prompt = "ssh: " },
                  mypromptbox[mouse.screen].widget,
                  function(h) awful.util.spawn(terminal .. " -e slogin " .. h) end,
                  function(cmd, cur_pos, ncomp)
                      -- get hosts and hostnames
                      local hosts = {}
                      f = io.popen("sed 's/#.*//;/[ \\t]*Host\\(Name\\)\\?[ \\t]\\+/!d;s///;/[*?]/d' " .. os.getenv("HOME") .. "/.ssh/config | sort")
                      for host in f:lines() do
                          table.insert(hosts, host)
                      end
                      f:close()
                      -- abort completion under certain circumstances
                      if cur_pos ~= #cmd + 1 and cmd:sub(cur_pos, cur_pos) ~= " " then
                          return cmd, cur_pos
                      end
                      -- match
                      local matches = {}
                      table.foreach(hosts, function(x)
                          if hosts[x]:find("^" .. cmd:sub(1, cur_pos):gsub('[-]', '[-]')) then
                              table.insert(matches, hosts[x])
                          end
                      end)
                      -- if there are no matches
                      if #matches == 0 then
                          return cmd, cur_pos
                      end
                      -- cycle
                      while ncomp > #matches do
                          ncomp = ncomp - #matches
                      end
                      -- return match and position
                      return matches[ncomp], #matches[ncomp] + 1
                  end,
                  awful.util.getdir("cache") .. "/ssh_history")
              end,"SSH login"),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end,"Run lua command"),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
   keydoc.group("Window management"),
   awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end,"Toggle fullscreen"),
   awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,"Kill window"),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,"Toggle floating"    ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,"Swap to master"),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen,"Move to screen" ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = true end,"Minimize client"),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end,"Maximize client"),
   awful.key({ modkey,  }, "i",
      function ()

         awful.prompt.run({ prompt = "variable name: " },
            mypromptbox[mouse.screen].widget,
            function (var) awful.util.eval("dbg(".. var ..")") end,
			nil,
			awful.util.getdir("cache") .. "/history_eval")
   end,"debug dump")

)

globalkeys = awful.util.table.join(
   globalkeys,
   awful.key({ modkey,           }, "e", xrandr))

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
globalkeys = awful.util.table.join(globalkeys, ror.genkeys(modkey))
for i = 1, 9 do
   globalkeys = awful.util.table.join(
      globalkeys,
      awful.key({ modkey }, "#" .. i + 9,
         function ()
            local screen = mouse.screen
            local tag = awful.tag.gettags(screen)[i]
            if tag then
               awful.tag.viewonly(tag)
            end
      end,"move tag (num)"),
      awful.key({ modkey, "Control" }, "#" .. i + 9,
         function ()
            local screen = mouse.screen
            local tag = awful.tag.gettags(screen)[i]
            if tag then
               awful.tag.viewtoggle(tag)
            end
      end,"view mix tag (num)"),
      awful.key({ modkey, "Shift" }, "#" .. i + 9,
             function ()
            local tag = awful.tag.gettags(client.focus.screen)[i]
            if client.focus and tag then
               awful.client.movetotag(tag)
            end
      end,"move window to (num)tag"),
      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
         function ()
            local tag = awful.tag.gettags(client.focus.screen)[i]
            if client.focus and tag then
               awful.client.toggletag(tag)
            end
      end,"copy window to (num)tag")
   )

end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

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
                     buttons = clientbuttons } },
    -- to fix youtube fullscreen problems if still seeing bottom bar
    -- for chromium change "plugin-container" to "exe"

    { rule = { instance = "plugin-container" },
      properties = { floating = true } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Keepassx" },
      properties = { tag = tags[1][9] } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "VirtualBox" },
     except = { name = "Oracle VM VirtualBox Manager" },
     properties = { tag = tags[1][4] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

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

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
