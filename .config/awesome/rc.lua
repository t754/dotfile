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
local menubar = require("menubar")

-- Freedesktop integration
--require("freedesktop.menu")
--require("freedesktop.desktop")
-- calendar functions

-- Extra widgets
local vicious = require("vicious")
-- to create shortcuts help screen

local ror = require("aweror")
local hotkeys_popup = require("awful.hotkeys_popup").widget


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)

-- Handle runtime errors after startup
do
   local in_error = false
   awesome.connect_signal("debug::error", function (err)
                             -- Make sure we don't go into an endless error loop
                             if in_error then return end
                             in_error = true
                             awful.util.spawn('notify-send -u critical "Oops, an error happened!"  "' .. err .. '"')
                             in_error = false
   end)
end
function my_notify(title,a)
   awful.util.spawn('notify-send -u critical "' .. title .. '"  "' .. gears.debug.dump_return(a) .. '"')
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


local theme = beautiful.get()
-- This is used later as the default terminal and editor to run.

terminal = "alacritty"
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


theme.menu_height           = 32
theme.menu_width            = 200
theme.border_width          = 2
theme.border_focus  = "#FFFF00"
menubar.font          = myfont
menubar.cache_entries = true
menubar.show_categories = false
menubar.menu_gen.all_menu_dirs = { "/usr/share/applications/", "/usr/local/share/applications/", "~/.local/share/applications/" , "/var/lib/snapd/desktop/applications/"}
modkey = "Mod4"
menubar.geometry = {
   height = 32
}
-- Table of layouts to cover with awful.layout.inc, order matters.



awful.layout.layouts = {
   awful.layout.suit.tile.right,
   awful.layout.suit.corner.nw,
   awful.layout.suit.tile.bottom,
   awful.layout.suit.max,
}

local function client_menu_toggle_fn()
   local instance = nil
   return function ()
      if instance and instance.wibox.visible then
         instance:hide()
         instance = nil
      else
         instance = awful.menu.clients({ theme = { width = 250 } })
      end
   end
end

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
      label, icon = "Keep the current configuration", "/usr/share/icons/"
      state.iterator = nil
   else
      label, action, icon = unpack(next)
   end
   awful.util.spawn('notify-send -a my-xrandr -c device  -t 4000  my-xrandr "' .. label .. '"')

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
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.


-- tagsnames={ "📝", "🌐", "📃"
--             ,"4", "💻","🎵"
--             ,"7","📛","🔑"}

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
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
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
vicious.register(datewidget, vicious.widgets.date, "%m-%d(%a)%H:%M:%S", 1)

cputempwidget = wibox.widget.textbox()
cputempwidget:set_font(myfont)

function templateColor(tmp)
   if tmp < 40 then
      return "#aaaaff"
   elseif tmp < 70 then
      return "green"
   else
      return "red"
   end
end

vicious.register(cputempwidget,
                 function(format, warg)
                    local args = vicious.widgets.thermal(format, warg)
                    args['{color}']=templateColor(args[1])
                    return args
                 end,
                 '<span foreground="${color}">$1℃</span>',
                 7, { "hwmon2", "hwmon"})


for _, wdg in ipairs {
   wibox.widget.textbox , wibox.widget.progressbar, wibox.widget.graph
} do
   function wdg:vicious(args)
      local f = unpack or table.unpack -- Lua 5.1 compat
      vicious.register(self, f(args))
   end
end

memwidget = wibox.widget {
   {
      forced_height = 100,
      forced_width  = 20,
      border_width  = 1,
      border_color  = "#AAAAAA",
      color = "#AECF96",
      background_color = "#494B4F",
      vicious = { vicious.widgets.mem,"$1"},
      widget        = wibox.widget.progressbar,
   },
   forced_width = 10,
   direction = 'east',
   widget = wibox.container.rotate,
}


cpuwidget = wibox.widget.graph()

cpuwidget:set_width(50)
cpuwidget:set_background_color("#494B4F")
cpuwidget:set_color("#AECF96")
vicious.register(cpuwidget, vicious.widgets.cpu, "$1",0.3)

traywidget = wibox.widget.systray()
traywidget.opacity = 0
mybattery = wibox.widget.textbox()
mybattery:set_font(myfont)
vicious.register(mybattery,
                 function(format, warg)
                    local args = vicious.widgets.bat(format, warg)
                    args['{color}']=templateColor(100-args[2])
                    if args[1] == '+' then
                       args['{bat}']= "⚡"
                    else
                       args['{bat}']="🚫"
                    end
                    return args
                 end, '<span foreground="${color}">${bat}[$3]$2%</span>', 10, 'BAT0')

local taglist_buttons = awful.util.table.join(
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

local tasklist_buttons = awful.util.table.join(
   awful.button({ }, 1, function (c)
         if c == client.focus then
            c.minimized = true
         else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
               c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
         end
   end),
   awful.button({ }, 3, client_menu_toggle_fn()),
   awful.button({ }, 4, function ()
         awful.client.focus.byidx(1)
   end),
   awful.button({ }, 5, function ()
         awful.client.focus.byidx(-1)
end))

-- Create a wibox for each screen and add it

local function set_wallpaper(s)
   -- Wallpaper
   if beautiful.wallpaper then
      local wallpaper = beautiful.wallpaper
      -- If wallpaper is a function, call it with the screen
      if type(wallpaper) == "function" then
         wallpaper = wallpaper(s)
      end
      gears.wallpaper.maximized(wallpaper, s, true)
   end
end

function map(func, tbl)
   local newtbl = {}
   if (type(elem) == "table") then
      for i,v in pairs(tbl) do
         newtbl[i] = func(v)
      end
      return newtbl
   end
end



local bar_color = "#74aeab"
local mute_color = "#ff0000"
local background_color = "#3a3a3a"
local request_command = 'amixer -D pulse sget Master'
local vol  = wibox.widget {
    max_value = 1,
    thickness = 2,
    start_angle = 4.71238898, -- 2pi*3/4
    forced_height = 17,
    forced_width = 18,
    bg = "#ffffff11",
    paddings = 2,
    widget = wibox.container.arcchart
}

local update_graphic = function(widget, stdout, _, _, _)
    local mute = string.match(stdout, "%[(o%D%D?)%]")
    local volume = string.match(stdout, "(%d?%d?%d)%%")
    if volume == nil then
       widget.colors = {mute_color};
       widget.values = {0.0};
       return
    end
    volume = tonumber(string.format("% 3d", volume))
    widget.values = {volume / 100};
    if mute == "off" then
        widget.colors = {mute_color}
    else
        widget.colors = {bar_color}
    end
end





screen.connect_signal("property::geometry", set_wallpaper)
awful.screen.connect_for_each_screen(function(s)
      set_wallpaper(s)
      awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, awful.layout.layouts[1])
      s.mypromptbox = awful.widget.prompt()    s.mypromptbox = awful.widget.prompt()
      s.mylayoutbox = awful.widget.layoutbox(s)

      local mybutton = {
         [1] = function (c)
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
         end,
         [3]= function ()
            if instance then
               instance:hide()
               instance = nil
            else
               instance = awful.menu.clients({
                     theme = { width = 250 }
               })
            end
         end,
         [4]= function ()
            awful.client.focus.byidx(1)
            if client.focus then client.focus:raise() end
         end,
         [5]= function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
         end
      }
      s.mylayoutbox:buttons(
         awful.util.table.join(
			map(function (fn) return (awful.button({ }, 1, fn))end),
			mybutton))

      s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)
      s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

      s.mywibox = awful.wibar({ position = "top", screen = s , height = theme.menu_height})
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
            traywidget,
            mybattery,
            awful.widget.watch(request_command, 1, update_graphic, vol),
            memwidget,
            cpuwidget,
            cputempwidget,
            datewidget,
            s.mylayoutbox
         },
      }
end)




-- }}}


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

can_move_mouse = true
function move_mouse_in_window_center()
   if not can_move_mouse then
      return
   end
   local c = client.focus
   if c then
      mouse.coords{
         x = c.x + (c.width / 2),
         y = c.y + (c.height / 2),
      }
   end
end

-- {{{ Key bindings
globalkeys = awful.util.table.join(
   awful.key({ modkey,           }, "/",      hotkeys_popup.show_help,
      {description="show help", group="awesome"}),
   awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
      {description = "view previous", group = "tag"}),
   awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
      {description = "view next", group = "tag"}),
   awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
      {description = "go back", group = "tag"}),

   awful.key({ modkey,           }, "j",
      function ()
         awful.client.focus.byidx( 1)
         move_mouse_in_window_center()
      end,
      {description = "focus next by index", group = "client"}
   ),
   awful.key({ modkey,           }, "k",
      function ()
         awful.client.focus.byidx(-1)
         move_mouse_in_window_center()
      end,
      {description = "focus previous by index", group = "client"}
   ),
   awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
      {description = "show main menu", group = "awesome"}),

   -- Layout manipulation
   awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
      {description = "swap with next client by index", group = "client"}),
   awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
      {description = "swap with previous client by index", group = "client"}),
   awful.key({ modkey, "Control" }, "j",
      function ()
         awful.screen.focus_relative(1)
      end,
      {description = "focus the next screen", group = "screen"}),
   awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
      {description = "focus the previous screen", group = "screen"}),
   awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
      {description = "jump to urgent client", group = "client"}),
   awful.key({ modkey,           }, "Tab",
      function ()
         awful.client.focus.history.previous()
         if client.focus then
            client.focus:raise()
         end
      end,
      {description = "go back", group = "client"}),

   awful.key({ modkey, "Shift" }, "Return", function () awful.spawn(terminal) end,
      {description = "open a terminal", group = "launcher"}),
   awful.key({ modkey, "Control" }, "r", awesome.restart,
      {description = "reload awesome", group = "awesome"}),
   awful.key({ modkey, "Shift"   }, "q", awesome.quit,
      {description = "quit awesome", group = "awesome"}),

   awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
      {description = "increase master width factor", group = "layout"}),
   awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
      {description = "decrease master width factor", group = "layout"}),
   awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
      {description = "increase the number of master clients", group = "layout"}),
   awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
      {description = "decrease the number of master clients", group = "layout"}),
   awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
      {description = "increase the number of columns", group = "layout"}),
   awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
      {description = "decrease the number of columns", group = "layout"}),
   awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
      {description = "select next", group = "layout"}),
   awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
      {description = "select previous", group = "layout"}),

   -- Prompt
   awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
      {description = "run prompt", group = "launcher"}),

   awful.key({ modkey }, "x",
      function ()
         awful.prompt.run {
            prompt       = "Run Lua code: ",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval"
         }
      end,
      {description = "lua execute prompt", group = "awesome"}),
   awful.key({ modkey}, "F11", function () awful.spawn("amixer -D pulse sset Master 5%-") end,
      {description = "increase volume", group = "custom"}),
   awful.key({ modkey}, "F12", function () awful.spawn("amixer -D pulse sset Master 5%+") end,
      {description = "decrease volume", group = "custom"}),
   awful.key({ modkey}, "F10", function () awful.spawn("amixer -D pulse set Master +1 toggle") end,
      {description = "mute volume", group = "custom"}),
   -- Menubar
   awful.key({ modkey , "Shift"}, "p", function() menubar.show() end,
      {description = "show the menubar", group = "launcher"}),
   awful.key({ modkey }, "p", function() awful.spawn("rofi -modi combi -combi-modi window,run,drun,ssh -show combi") end,
      {description = "run dmenu menubar", group = "launcher"}),
   awful.key({ modkey}, "e", xrandr,
      {description = "setting xrandr", group = "launcher"}),
   awful.key({ modkey}, "F7",
      function()
         awful.spawn([[emacsclient -n -c -e ' (org-capture) ']])
      end,
      {description = "setting xrandr", group = "launcher"}),
   awful.key({ modkey}, "-", function ()
         can_move_mouse = not(can_move_mouse);
                           end,
      {description = "etc", group = "custom"})


)
function un_minimize()
   local c = awful.client.restore()
   my_notify("notiy",c)
   if c then
      client.focus = c
      c:raise()
      c.minimized = false
   end
end

clientkeys = awful.util.table.join(
   awful.key({ modkey,           }, "f",
      function (c)
         c.fullscreen = not c.fullscreen
         c:raise()
      end,
      {description = "toggle fullscreen", group = "client"}),
   awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
      {description = "close", group = "client"}),
   awful.key({ modkey, "Shift" }, "f",  awful.client.floating.toggle                     ,
      {description = "toggle floating", group = "client"}),
   awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
      {description = "move to master", group = "client"}),
   awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
      {description = "move to screen", group = "client"}),
   awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
      {description = "toggle keep on top", group = "client"}),
   awful.key({ modkey, "Shift"   }, "t",      function (c)  awful.titlebar.toggle(c)        end,
      {description = "toggle titlebar", group = "client"}),
   awful.key({ modkey,           }, "n",
      function (c)
         -- The client currently has the input focus, so it cannot be
         -- minimized, since minimized clients can't have the focus.
         c.minimized = true
      end,
      {description = "minimize", group = "client"}),
   awful.key({ modkey,"Shift"    }, "n",
      un_minimize,
      {description = "un-minimize", group = "client"}),
   awful.key({ modkey,"Control"    }, "n",
      un_minimize,
      {description = "un-minimize", group = "client"}),
   awful.key({ modkey,  }, "@",
      function ()
         if client.focus then
            for i = 1, 9 do
               local tag = client.focus.screen.tags[i]
               if tag then
                  client.focus:toggle_tag(tag)
               end
            end
         end
      end,
      {description = "all share tag",group = "tag"}
   ),
   awful.key({ modkey, "Control", "Shift" }, "y",
      function (c)
         awful.util.spawn('gnome-screensaver-command -l')
      end,
      {description = "lock screen", group = "client"}),
   awful.key({ modkey,           }, "m",
      function (c)
         c.maximized = not c.maximized
         c:raise()
      end,
      {description = "maximize", group = "client"}
   )
)



-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
globalkeys = awful.util.table.join(globalkeys, ror.genkeys(modkey))

for i = 1, 9 do
   globalkeys = awful.util.table.join(globalkeys,
                                      -- View tag only.
                                      awful.key({ modkey }, "#" .. i + 9,
                                         function ()
                                            local screen = awful.screen.focused()
                                            local tag = screen.tags[i]
                                            if tag then
                                               tag:view_only()
                                            end
                                         end,
                                         {description = "view tag #"..i, group = "tag"}),
                                      -- Toggle tag display.
                                      awful.key({ modkey, "Control" }, "#" .. i + 9,
                                         function ()
                                            local screen = awful.screen.focused()
                                            local tag = screen.tags[i]
                                            if tag then
                                               awful.tag.viewtoggle(tag)
                                            end
                                         end,
                                         {description = "toggle tag #" .. i, group = "tag"}),
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
                                         {description = "move focused client to tag #"..i, group = "tag"}),
                                      -- Toggle tag on focused client.
                                      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                                         function ()
                                            if client.focus then
                                               local tag = client.focus.screen.tags[i]
                                               if tag then
                                                  client.focus:toggle_tag(tag)
                                               end
                                            end
                                         end,
                                         {description = "toggle focused client on tag #" .. i, group = "tag"}))
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
                    buttons = clientbuttons,
                    screen = awful.screen.preferred,
                    placement = awful.placement.no_overlap+awful.placement.no_offscreen

   } },
   { rule = { class = "gimp" },
     properties = { floating = true } },
   { rule = { class = "Firefox" },
     properties = { tag = "2" } },
   { rule_any = {
        class = {
           "VirtualBox",
           "Remmina",
           "xfreerdp"
        },
   },
     properties = { tag = "4" } },
   { rule_any = {
        name = {
           "Wicd Network Manager",
           "keepassxc"
        },
   },
     properties = { tag = "8" }},
   { rule_any = {
        name = {
           "Slack"
        },
   },
     properties = { tag = "9" }},
   { rule_any = {
        type = {
           "normal",
           "dialog",
        }
   },
     properties = { titlebars_enabled = true }
   },
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

                         awful.titlebar.hide(c)
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

client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
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


client.connect_signal("mouse::enter", function(c)
                         if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                         and awful.client.focus.filter(c) then
                            client.focus = c
                         end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
