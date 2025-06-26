local wibox = require('wibox')
local awful = require('awful')
local gmath =require('gears.math')
local gtable = require('gears.table')
local gcolor = require('gears.color')
local beautiful = require('beautiful')
local oop = require('framework.oop')
local utils = require('framework.utils')()
local dpi = beautiful.xresources.apply_dpi

local modkey = Configuration.UserLikes:get_key('modkey')

local _layoutlist = {}

function _layoutlist:constructor(s)
   self.s = s
end

function _layoutlist:install()
   local layoutlist = awful.widget.layoutlist({
      source = awful.widget.layoutlist.source.default_layouts,
      spacing = dpi(24),
      base_layout = wibox.widget({
         spacing = dpi(24),
         forced_num_cols = 4,
         layout = wibox.layout.grid.vertical,
      }),
      widget_template = {
         widget = wibox.container.background,
         id = 'background_role',
         forced_width = dpi(68),
         forced_height = dpi(68),
         {
            widget = wibox.container.margin,
            margins = dpi(24),
            {
               widget = wibox.widget.imagebox,
               id = 'icon_role',
               forced_width = dpi(68),
               forced_height = dpi(68),
            },
         },
      },
   })

   local layout_popup = awful.popup({
      placement = awful.placement.centered,
      screen = self.s,
      type = 'normal',
      visible = false,
      ontop = true,
      widget = wibox.widget({
         widget = wibox.container.background,
         bg = beautiful.colors.transparent,
         {
            widget = wibox.container.background,
            bg = beautiful.colors.background,
            shape = utils:srounded(dpi(12)),
            {
               widget = wibox.container.margin,
               margins = dpi(7),
               layoutlist,
            }
         },
      })
   })

   function gtable.iterate_value(t, value, step_size, filter, start_at)
      local k = gtable.hasitem(t, value, true, start_at)
      if not k then
         return
      end

      step_size = step_size or 1
      local new_key = gmath.cycle(#t, k + step_size)

      if filter and not filter(t[new_key]) then
         for i = 1, #t do
            local k2 = gmath.cycle(#t, new_key + i)
            if filter(t[k2]) then
               return t[k2], k2
            end
         end
         return
      end

      return t[new_key], new_key
   end

   local function rotate(step)
      return function ()
         awful.layout.set(gtable.iterate_value(layoutlist.layouts, layoutlist.current_layout, 1 * step), nil)
      end
   end

   awful.keygrabber({
      start_callback = function ()
         layout_popup.visible = true
      end,
      stop_callback = function ()
         layout_popup.visible = false
      end,
      export_keybindings = true,
      stop_event = 'release',
      stop_key = { 'Escape', 'Super_L', 'Super_R', 'Mod4', modkey },
      keybindings = {
         {
            { modkey, 'Shift' },
            ' ',
            rotate(-1),
         },
         {
            { modkey },
            ' ',
            rotate(1),
         },
      },
   })
end

return oop(_layoutlist)
