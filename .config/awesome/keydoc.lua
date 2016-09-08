-- Document key bindings
local awful     = require("awful")
local table     = table
local ipairs    = ipairs
local pairs     = pairs
local math      = math
local string    = string
local type      = type
local beautiful = require("beautiful")
local naughty   = require("naughty")
local capi      = {
   root = root,
   client = client
}
local ansicolors = require ("ansicolors")
-- local keydoc
-- module("keydoc")
keydoc ={}

local doc = { }
currentgroup = "Misc"
orig = awful.key.new

-- Replacement for awful.key.new
local function new(mod, key, press, release, docstring)
   -- Usually, there is no use of release, let's just use it for doc
   -- if it's a string.
   if press and release and not docstring and type(release) == "string" then
      docstring = release
      release = nil
   end
   local k = orig(mod, key, press, release)
   -- Remember documentation for this key (we take the first one)
   if k and #k > 0 and docstring then
      doc[k[1]] = { help = docstring,
                    group = currentgroup }
   end

   return k
end

awful.key.new = new		-- monkey patch

-- Turn a key to a string
local function key2str(key)
   local sym = key.key or key.keysym
   local translate = {
      ["#14"] = "#",
      [" "] = "Space",
   }
   sym = translate[sym] or sym
   if not key.modifiers or #key.modifiers == 0 then return sym end
   local result = ""
   local translate = {
      [modkey] = "M",
      Shift    = "S",
      Control  = "C",
   }
   for _, mod in pairs(key.modifiers) do
      mod = translate[mod] or mod
      result = result .. mod .. "-"
   end
   return result .. sym
end

-- Unicode "aware" length function (well, UTF8 aware)
-- See: http://lua-users.org/wiki/LuaUnicode
local function unilen(str)
   local _, count = string.gsub(str, "[^\128-\193]", "")
   return count
end

-- Start a new group
function keydoc.group(name)
   currentgroup = name
   return {}
end
local longest = 0
function keydoc.markup(keys)
   local FFF = ""
   local result = {}
   -- Compute longest key combination
   for _, key in ipairs(keys) do
      if doc[key] then
         FFF = FFF .. "_".. unilen(key2str(key))
		 longest = math.max(longest, unilen(key2str(key)))
      end
   end

   local curgroup = nil
   for _, key in ipairs(keys) do
      if doc[key] then
         local help, group = doc[key].help, doc[key].group
         local skey =  key2str(key)
         result[group] = (result[group] or "") ..
            string.format("%" .. longest - unilen(skey) .. "s  ", "") ..
             -- "<span color=\"#FF00FF\">" .. skey  .. "</span> <span color=\"#FF0000\">" .. help .. "</span>\n"
            ansicolors.magenta .. skey .. ansicolors.reset .. " " .. help .. "\n"
      end
   end

   return  result
end

-- Display help in a naughty notification
local nid = nil

function keydoc.display() --myfunc
   local keytable = awful.util.table.join(
      keydoc.markup(capi.root.keys()),
      capi.client.focus and keydoc.markup(capi.client.focus:keys()) or {}
   )
   local result = ''
   for group, res in pairs(keytable) do
      result = result .. ansicolors.red .. group ..  ansicolors.reset .."\n" .. res .. "\n"
   end
   -- for group, res in pairs(keytable) do
   --    -- if #result > 0 then result = result .. "\n" end
   --    result = result ..
   --       -- .. beautiful.fg_widget_value_important ..
   --   "<span color=\"#00FF00\">" ..
   --   group .. "</span>\n" .. res
   -- end
   local tp = os.tmpname() -- open temporary file
   local f = io.open(tp, "w")
   f:write (result)  -- write to it
   f:close ()  -- close file
   -- keydoc.path=tp
   -- nid = naughty.notify({
   --       title = "keydoc",
   --       text = result,
   --                         replaces_id = nid,
   --                         timeout = 30 }).id
   -- awful.util.spawn_with_shell("less " .. tp)
   return tp
end
-- function keydoc.display()
--    local keytable = awful.util.table.join(
--       keydoc.markup(capi.root.keys()),
--       capi.client.focus and keydoc.markup(capi.client.focus:keys()) or {}
--    )

--    -- local strings = markup(awful.util.table.join(
--    --    capi.root.keys(),
--    --    capi.client.focus and capi.client.focus:keys() or {}))

--    local result = ""
--    for group, res in pairs(keytable) do
--       if #result > 0 then result = result .. "\n" end
--       result = result ..
-- 	 '<span weight="bold" color="' .. beautiful.fg_widget_value_important .. '">' ..
-- 	 group .. "</span>\n" .. res
--    end
--    nid = naughty.notifyl({ text = result,
-- 			  replaces_id = nid,
-- 			  hover_timeout = 0.1,
-- 			  timeout = 30 }).id
-- end

return keydoc
