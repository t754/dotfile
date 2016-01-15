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
naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
-- MPD
local awesompd = require("awesompd/awesompd")
-- revelation
local revelation = require("revelation")
-- Run or raise
local ror = require("aweror")
local keydoc = require("keydoc")
local inspect = require("inspect")

naughty.config.presets.normal.opacity = 0.7
naughty.config.presets.low.opacity = 0.7
naughty.config.presets.critical.opacity = 0.7

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
-- beautiful.init("/usr/share/awesome/themes/sky/theme.lua")
beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")
revelation.init()
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
menubar.show_categories = true
-- menubar.app_folders = {  os.getenv("HOME") .. "/.local/share/applicarions/"}
menubar.geometry = {
   height = 32,
   -- width = 200,
   -- x = 0,
   -- y = 0
}


-- This is used later as the default terminal and editor to run.
terminal = "st -f 'Inconsolata:size=16'"
-- editor = os.getenv("EDITOR") or "nano"
editor = "emacsclient -c"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts = {
   awful.layout.suit.tile.bottom,
   awful.layout.suit.tile,   -- 左半分 main
   -- awful.layout.suit.spiral.dwindle, -- zigzag
   -- awful.layout.suit.spiral, -- 螺旋
   -- awful.layout.suit.floating,  -- 羽 :: 多くなると角に浮かせて設置

   -- awful.layout.suit.tile.left,

   -- awful.layout.suit.tile.top,
   -- awful.layout.suit.fair,
   -- awful.layout.suit.fair.horizontal,
   -- awful.layout.suit.magnifier ,
   -- awful.layout.suit.max.fullscreen,
   awful.layout.suit.max,
}
-- }}}
-- dubug
function dbg(vars)
    local text = inspect(vars)
    -- for i=1, #vars do text = text .. vars[i] .. " | " end
    naughty.notify({ text = text, timeout = 10 })
end

-- {{{ randam wallpaper
-- Get the list of files from a directory. Must be all images or folders and non-empty.
function scanDir(directory)
   local i,fileList,popen = 0, {}, io.popen
   for filename in popen( [[ find "]] ..directory.. [[" -type f ]] ):lines() do
      i = i + 1
      fileList[i] = filename
   end
   return fileList
end

function listshuffle(array)
   local n,random,j = #array, math.random
   for i=1, n do
      j,k = random(n), random(n)
      array[j],array[k] = array[k],array[j]
   end
   return array
end
wallpaperList = listshuffle(scanDir( os.getenv("HOME").."/.wallpaper/OK/"))

-- Apply a random wallpaper on startup.
gears.wallpaper.maximized(wallpaperList[math.random(1, #wallpaperList)], s, true)

-- Apply a random wallpaper every changeTime seconds.
local changeTime = 59
local listIte = 0
wallpaperTimer = timer { timeout = changeTime }
wallpaperTimer:connect_signal("timeout",
                              function()
                                 listIte = listIte + 1
                                 if listIte > #wallpaperList then
                                    listIte = 1
                                    wallpaperList = listshuffle(wallpaperList)
                                 end
                                 for s = 1, screen.count() do
                                    gears.wallpaper.maximized(wallpaperList[listIte], s, true)
                                 end
                                 -- gears.wallpaper.maximized(wallpaperList[listIte], s, true)
                                 -- stop the timer (we don't need multiple instances running at the same time)
                                 wallpaperTimer:stop()
                                 --restart the timer
                                 wallpaperTimer.timeout = changeTime
                                 wallpaperTimer:start()
end)

--- initial start when rc.lua is first run
wallpaperTimer:start()


--- }}}



-- {{{ Wallpaper
-- if beautiful.wallpaper then
--    for s = 1, screen.count() do
-- 	  gears.wallpaper.maximized(beautiful.wallpaper, s, true)
--    end
-- end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
tagsnames={ "📝", "🌐", "📃","🔑", "💻","🎵"}
for s = 1, screen.count() do
   -- Each screen has its own tag table.
   tags[s] = awful.tag(tagsnames, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
xdg_menu = require("archmenu")
-- myawesomemenu = {
--    { "manual", terminal .. " -e man awesome" },
--    { "edit config", editor_cmd .. " " .. awesome.conffile },
--    { "restart", awesome.restart },
--    { "quit", awesome.quit }
-- }
-- myEtcMenu   = {
--    {"fontView", "gtk2fontsel"},
--    {"redshift", "redshift"}
-- }


mymainmenu = awful.menu(
   { items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "Applications", xdgmenu },
        { "open terminal", terminal }
   }
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox


-- -------- --
-- 追加項目 --
-- -------- --
-- Initialize widget
datewidget = wibox.widget.textbox()

datewidget:set_font("Ricty bold 24")
-- <Ricty Discord4Powerline> 32"

cputempwidget = wibox.widget.textbox()
cputempwidget:set_font("Ricty 16")
-- ##################################

-- Register widget
vicious.register(datewidget, vicious.widgets.date, "%Y-%m-%d(%a)%H:%M", 29)
-- 場所 /sys/devices/platform/coretemp.0/hwmon/hwmon0
vicious.register(cputempwidget, vicious.widgets.thermal, "$1℃", 7, { "coretemp.0/hwmon/hwmon0/", "core"})

-- Memory use graph
-- Progressbar properties
memwidget = awful.widget.progressbar()

memwidget:set_width(8)
memwidget:set_height(10)
memwidget:set_vertical(true)
memwidget:set_background_color("#494B4F")
memwidget:set_border_color(nil)
memwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 10,0 }, stops = { {0, "#AECF96"}, {0.5, "#88A175"},{1, "#FF5656"}}})
-- Memory use graph

-- Register widget
vicious.register(memwidget, vicious.widgets.mem, "$1", 13)


---- Initialize widget
-- Graph properties
cpuwidget = awful.widget.graph()

cpuwidget:set_width(50)
--
cpuwidget:set_background_color("#494B4F")
cpuwidget:set_color("#AECF96")
-- { type = "linear", from = { 0, 0 }, to = { 10,0 },
--                    stops = { {0, "#FF5656"}, {0.5, "#88A175"},{1, "#AECF96" }}})
-- -- Register widget
vicious.register(cpuwidget, vicious.widgets.cpu, "$1",0.3)

-- local thermalwidget  = wibox.widget.textbox()

-- -- Register widget
-- vicious.register(thermalwidget, vicious.widgets.thermal, " - $1°C", 20, { "coretemp.0", "core"} )

-- Register widget

-- dio = wibox.widget.textbox()
-- ({ type = "textbox" })
-- vicious.register(dio, vicious.widgets.dio, "R:${read_kb}KB W:${write_kb}KB", 1, "sda")
-- vicious.register(dio, vicious.widgets.dio,"${sda total_s}",2)
-- volume widget
local alsawidget = {
   channel = "Master",
   step = "1%",
   colors =
      {
         unmute = "#AECF96",
         mute = "#FF5656"
      },
   mixer = terminal .. " -e alsamixer", -- or whatever your preferred sound mixer is
   notifications =
      {
         icons =
            {
               -- the first item is the 'muted' icon
               "/usr/share/icons/gnome/48x48/status/audio-volume-muted.png",
               -- the rest of the items correspond to intermediate volume levels - you can have as many as you want (but must be >= 1)
               "/usr/share/icons/gnome/48x48/status/audio-volume-low.png",
               "/usr/share/icons/gnome/48x48/status/audio-volume-medium.png",
               "/usr/share/icons/gnome/48x48/status/audio-volume-high.png"
            },
         font = "Monospace 11", -- must be a monospace font for the bar to be sized consistently
         icon_size = 48,
         bar_size = 20 -- adjust to fit your font if the bar doesn't fit
      }
}

-- widget
alsawidget.bar = awful.widget.progressbar ()
alsawidget.bar:set_width (8)
alsawidget.bar:set_vertical (true)
alsawidget.bar:set_background_color ("#494B4F")
alsawidget.bar:set_color (alsawidget.colors.unmute)
alsawidget.bar:buttons (awful.util.table.join (
                           awful.button ({}, 1, function()
                                 awful.util.spawn (alsawidget.mixer)
                           end),
                           awful.button ({}, 3, function()
                                 awful.util.spawn ("amixer sset " .. alsawidget.channel .. " toggle")
                                 vicious.force ({ alsawidget.bar })
                           end),
                           awful.button ({}, 4, function()
                                 awful.util.spawn ("amixer sset " .. alsawidget.channel .. " " .. alsawidget.step .. "+")
                                 vicious.force ({ alsawidget.bar })
                           end),
                           awful.button ({}, 5, function()
                                 awful.util.spawn ("amixer sset " .. alsawidget.channel .. " " .. alsawidget.step .. "-")
                                 vicious.force ({ alsawidget.bar })
                           end)
))
-- tooltip
alsawidget.tooltip = awful.tooltip ({ objects = { alsawidget.bar } })
-- naughty notifications
alsawidget._current_level = 0
alsawidget._muted = false
function alsawidget:notify ()
   local preset =  {
      height = 75,
      width = 300,
      font = alsawidget.notifications.font
   }
   local i = 1;
   while alsawidget.notifications.icons[i + 1] ~= nil
   do
      i = i + 1
   end
   if i >= 2
   then
      preset.icon_size = alsawidget.notifications.icon_size
      if alsawidget._muted or alsawidget._current_level == 0
      then
         preset.icon = alsawidget.notifications.icons[1]
      elseif alsawidget._current_level == 100
      then
         preset.icon = alsawidget.notifications.icons[i]
      else
         local int = math.modf (alsawidget._current_level / 100 * (i - 1))
         preset.icon = alsawidget.notifications.icons[int + 2]
      end
   end
   if alsawidget._muted
   then
      preset.title = alsawidget.channel .. " - Muted"
   elseif alsawidget._current_level == 0 then
      preset.title = alsawidget.channel .. " - 0% (muted)"
      preset.text = "[" .. string.rep (" ", alsawidget.notifications.bar_size) .. "]"
   elseif alsawidget._current_level == 100 then
      preset.title = alsawidget.channel .. " - 100% (max)"
      preset.text = "[" .. string.rep ("|", alsawidget.notifications.bar_size) .. "]"
   else
      local int = math.modf (alsawidget._current_level / 100 * alsawidget.notifications.bar_size)
      preset.title = alsawidget.channel .. " - " .. alsawidget._current_level .. "%"
      preset.text = "[" .. string.rep ("|", int) .. string.rep (" ", alsawidget.notifications.bar_size - int) .. "]"
   end
   if alsawidget._notify ~= nil
   then

      alsawidget._notify = naughty.notify (
         {
			replaces_id = alsawidget._notify.id,
			preset = preset
      })
   else
      alsawidget._notify = naughty.notify ({ preset = preset })
   end
end
-- register the widget through vicious
vicious.register (alsawidget.bar, vicious.widgets.volume, function (widget, args)
                     alsawidget._current_level = args[1]
                     if args[2] == "♩"
                     then
                        alsawidget._muted = true
                        alsawidget.tooltip:set_text (" [Muted] ")
                        widget:set_color (alsawidget.colors.mute)
                        return 100
                     end
                     alsawidget._muted = false
                     alsawidget.tooltip:set_text (" " .. alsawidget.channel .. ": " .. args[1] .. "% ")
                     widget:set_color (alsawidget.colors.unmute)
                     return args[1]
                                                          end, 5, alsawidget.channel) -- relatively high update time, use of keys/mouse will force update

globalkeys = awful.util.table.join(
   keydoc.group("Audio"),
   globalkeys,
   awful.key({ }, "XF86AudioRaiseVolume",
      function()
         awful.util.spawn("amixer sset " .. alsawidget.channel .. " " .. alsawidget.step .. "+")
         vicious.force({ alsawidget.bar })
         alsawidget.notify()
      end,"audio raise volume"),
   awful.key({ }, "XF86AudioLowerVolume",
      function()
         awful.util.spawn("amixer sset " .. alsawidget.channel .. " " .. alsawidget.step .. "-")
         vicious.force({ alsawidget.bar })
         alsawidget.notify()
      end,"audio lower volume"),
   awful.key({ }, "XF86AudioMute",
      function()
         awful.util.spawn("amixer sset " .. alsawidget.channel .. " toggle")
         -- The 2 following lines were needed at least on my configuration, otherwise it would get stuck muted
         --alsa keybind
         awful.util.spawn("amixer sset " .. "Speaker" .. " unmute")
         awful.util.spawn("amixer sset " .. "Headphone" .. " unmute")
         vicious.force({ alsawidget.bar })
         alsawidget.notify()
      end,"audio Mute"))

-- volumewidget = wibox.widget.textbox()
--   vicious.register(volumewidget, vicious.widgets.volume,
--     function(widget, args)
--       local label = { ["♫"] = "O", ["♩"] = "M" }
--       return "Volume: " .. args[1] .. "%\n State: " .. label[args[2]]
--     end, 2, "PCM")
spacer=wibox.widget.textbox()
separator=wibox.widget.textbox()
spacer:set_font("Ricty Discord4Powerline 16")
separator:set_font("Ricty Discord4Powerline 16")
spacer:set_text(" ")
separator:set_text("|")
-- ---------- --
-- 追加終わり --
-- ---------- --

-- Create a textclock widget
-- mytextclock = awful.widget.textclock()

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
   mywibox[s] = awful.wibox({ position = "top", screen = s ,height = 40})

   local left_layout = wibox.layout.fixed.horizontal()
   left_layout:add(mylauncher)
   left_layout:add(mytaglist[s])
   left_layout:add(mypromptbox[s])
   -- Widgets that are aligned to the right
   local right_layout = wibox.layout.fixed.horizontal()
   if s == 1 then right_layout:add(wibox.widget.systray()) end
   ---------- right_layout:add(mytextclock)
   ---- right_layout:add(musicwidget.widget)
   right_layout:add(memwidget)
   right_layout:add(separator)
   right_layout:add(cpuwidget)
   -- right_layout:add(thermalwidget)


   -- right_layout:add(dio)
   right_layout:add(separator)
   -- right_layout:add(spacer)
   right_layout:add(alsawidget.bar)
   right_layout:add(separator)
   -- right_layout:add(spacer)
   right_layout:add(cputempwidget)
   right_layout:add(datewidget)
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
   globalkeys,
   keydoc.group("etc"),
   awful.key({ modkey,           }, "e",      revelation ,"revelation"),
   awful.key({                   }, "Print", function () awful.util.spawn("scrot -e    'mv $f ~/Pictures/screenshot/  2>/dev/null'") end,"screenshot all ~/Pictures/screenshot/"),
   awful.key({ modkey            }, "Print", function () awful.util.spawn("scrot -u -e 'mv $f ~/Pictures/screenshot/  2>/dev/null'") end,"screenshot select ~/Pictures/screenshot/"),
   keydoc.group("move"),
   awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ,"tag move prev"),
   awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ,"tag move next"),
   awful.key({ modkey,           }, "Escape", awful.tag.history.restore,"tag move old"),
   awful.key({ modkey,           }, "j",
      function ()
         awful.client.focus.byidx( 1)
         if client.focus then client.focus:raise() end
   end,"move next window"),
   awful.key({ modkey,           }, "k",
      function ()
         awful.client.focus.byidx(-1)
         if client.focus then client.focus:raise() end
   end,"move prev window"),
   -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

   -- Layout manipulation
   awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,"swap current&next window"),
   awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,"swap current&prev window"),
   awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,"next screen"),
   awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,"prev screen"),
   awful.key({ modkey,           }, "u", awful.client.urgent.jumpto, "first screen"),
   awful.key({ modkey,           }, "Tab",
      function ()
         awful.client.focus.history.previous()
         if client.focus then
            client.focus:raise()
         end
   end,"window move old"),

   -- Standard program
   awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(terminal) end,"run terminal"),
   awful.key({ modkey, "Control" }, "r", awesome.restart,"restart"),
   awful.key({ modkey, "Shift","Control"  }, "q", awesome.quit,"quit"),

   awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end,"inc master window width"),
   awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end,"dec master window width"),
   awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end,"inc master windows num"),
   awful.key({ modkey,           }, ",",     function () awful.tag.incnmaster( 1)      end,"inc master windows num"),
   awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end,"dec master windows num"),
   awful.key({ modkey,           }, ".",     function () awful.tag.incnmaster(-1)      end,"dec master windows num"),
   awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end,"inc column windows num"),
   awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end,"dec column windows num"),
   awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end,"next layout"),
   awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end,"prev layout"),
   awful.key({ modkey, "Control" }, "n", awful.client.restore,"unminimize window"),

   -- Prompt
   awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end,"run one line shell"),

   awful.key({ modkey }, "x",
      function ()
         awful.prompt.run({ prompt = "Run Lua code: " },
            mypromptbox[mouse.screen].widget,
            awful.util.eval, nil,
            awful.util.getdir("cache") .. "/history_eval")
   end,"run lua code"),
   -- Menubar

   awful.key({ modkey }, "p", function() menubar.show() end,"show menu bar")
)

clientkeys = awful.util.table.join(
   keydoc.group("change window"),
   awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end,"fullscreen"),
   awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,"kill"),
   awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,"float"),
   awful.key({ modkey,           }, "t",      awful.client.floating.toggle                     ,"float"),
   awful.key({ modkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end,"swap current&master window"),
   awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ,"move next screen"),
   awful.key({ modkey, "Control" }, "t",      function (c) c.ontop = not c.ontop            end,"toggel top/untop"),
   awful.key({ modkey,           }, "n",      function (c) c.minimized = true               end,"minimize window"),
   awful.key({ modkey,           }, "m",
      function (c)
         c.maximized_horizontal = not c.maximized_horizontal
         c.maximized_vertical   = not c.maximized_vertical
   end,"maxmize window"),
   awful.key({ modkey,  }, "i",
      function ()

         awful.prompt.run({ prompt = "variable name: " },
            mypromptbox[mouse.screen].widget,
            function (var) awful.util.eval("dbg(".. var ..")") end,
			nil,
			awful.util.getdir("cache") .. "/history_eval")
   end,"debug dump"),
   ror.genkeys(modkey),          -- ROR
   awful.key({ modkey, }, "F1", keydoc.display)
)


-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
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
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end, "focus window by mouse"),
   awful.button({ modkey }, 1, awful.mouse.client.move,               "move window by mouse"),
   awful.button({ modkey }, 3, awful.mouse.client.resize,             "resize window by mouse"))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
   -- All clients will match this rule.
   { rule = { },
	 properties = { border_width = beautiful.border_width * 2,
                    border_color =  beautiful.border_normal,
					focus = awful.client.focus.filter,
					keys = clientkeys,
					buttons = clientbuttons } },
   { rule = { instance = "plugin-container" },
     properties = { floating = true } },
   { rule = { class = "gimp" },
   	 properties = { floating = true } },
   { rule = { instance = "pavucontrol" },
   	 properties = { floating = true } },
   { rule = { instance = "fiji-Main" },
   	 properties = { floating = true } },
   -- Set Firefox to always map on tags number 2 of screen 1.
   { rule = { class = "Firefox" },
	 properties = { tag = tags[1][2] } },
   { rule = { class = "Spotify" },
	 properties = { tag = tags[1][6] } },
   { rule = { class = "Keepassx" },
	 properties = { tag = tags[1][4] } },
   { rule = { class = "VirtualBox" },
     except = { name = "Oracle VM VirtualBox Manager" },
     properties = { tag = tags[1][5] } },
   { rule = { class = "Skype" },
	 properties = { tag = tags[1][6] } },
}

-- }}}

-- {{{ Signals
-- Signal functionto execute when a new client appears.
client.connect_signal("manage", function (c, startup)
						 ---- Enable sloppy focus マウス移動でfocus
						 -- c:connect_signal("mouse::enter", function(c)
						 --    				 if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
						 --    				 and awful.client.focus.filter(c) then
						 --    					client.focus = c
						 --    				 end
						 -- end)

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
                         ---- ↓ミニmenubar
						 -- local titlebars_enabled = false
						 -- if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
						 --    -- buttons for the titlebar
						 --    local buttons = awful.util.table.join(
						 --       awful.button({ }, 1, function()
                         --             client.focus = c
                         --             c:raise()
                         --             awful.mouse.client.move(c)
						 --       end),
						 --       awful.button({ }, 3, function()
                         --             client.focus = c
                         --             c:raise()
                         --             awful.mouse.client.resize(c)
						 --       end)
						 --    )

						 --    -- Widgets that are aligned to the left
						 --    local left_layout = wibox.layout.fixed.horizontal()
						 --    left_layout:add(awful.titlebar.widget.iconwidget(c))
						 --    left_layout:buttons(buttons)

						 --    -- Widgets that are aligned to the right
						 --    local right_layout = wibox.layout.fixed.horizontal()
						 --    right_layout:add(awful.titlebar.widget.floatingbutton(c))
						 --    right_layout:add(awful.titlebar.widget.maximizedbutton(c))
						 --    right_layout:add(awful.titlebar.widget.stickybutton(c))
						 --    right_layout:add(awful.titlebar.widget.ontopbutton(c))

                         --    right_layout:add(awful.titlebar.widget.closebutton(c))


						 --    -- The title goes in the middle
						 --    local middle_layout = wibox.layout.flex.horizontal()
						 --    local title = awful.titlebar.widget.titlewidget(c)
						 --    title:set_align("center")
						 --    middle_layout:add(title)
						 --    middle_layout:buttons(buttons)

						 --    -- Now bring it all together
						 --    local layout = wibox.layout.align.horizontal()
						 --    layout:set_left(left_layout)
						 --    layout:set_right(right_layout)
						 --    layout:set_middle(middle_layout)

						 --    awful.titlebar(c):set_widget(layout)
						 -- end
end)


-- }}}

-- os.execute("firefox &")
-- os.execute("emacs &")
-- os.execute("mlterm &")
-- os.execute("redshift &")
function exeChange(programName)
   if "redshift" == programName then
	  return "gtk-redshift"
   elseif "emacs" == programName then
	  return "emacs --daemon"
   end
   return programName
end
function run_once(prg)
   local prg2 = exeChange(prg)
   awful.util.spawn_with_shell("pgrep -u $USER -x " .. prg .. " || (" .. prg2 .. ")")
end

do
   local cmds ={
      -- "firefox",
      -- "mpd",
      -- "emacs",
      -- terminal,
      -- "dropbox.py start",
      "keepassx",
      -- "emacsclient -c"
      -- "redshift",
      -- "clipit",
   }

   for _,i in pairs(cmds) do
	  run_once(i)
   end
end

client.connect_signal("focus",
                      function(c)
                         c.border_color = "#daa520"
                         c.opacity = 1
                      end)
client.connect_signal("unfocus",
                      function(c)
                         c.border_color = beautiful.border_normal
                         c.opacity = 0.7
                      end)
