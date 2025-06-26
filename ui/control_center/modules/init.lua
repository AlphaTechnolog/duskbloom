local wibox = require('wibox')
local oop = require('framework.oop')
local utils = require('framework.utils')()
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

local Header = require('ui.control_center.modules.header')
local Footer = require('ui.control_center.modules.footer')

local _content = {}

function _content:_middle_content()
   return wibox.widget({
      widget = wibox.container.margin,
      margins = utils:axis_margins(6, 0),
      {
         widget = wibox.container.background,
         bg = beautiful.colors.background,
         vexpand = true,
         {
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(6),
            {
               widget = wibox.widget.textbox,
               markup = 'chips',
               align = 'left',
               valign = 'center',
            }
         }
      },
   })
end

function _content:render()
   return wibox.widget({
      layout = wibox.layout.align.vertical,
      Header():render(),
      self:_middle_content(),
      Footer():render(),
   })
end

return oop(_content)
