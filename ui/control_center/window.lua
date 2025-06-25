local wibox = require('wibox')
local awful = require('awful')
local oop = require('framework.oop')
local utils = require('framework.utils')()
local animation = require('framework.animation')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

local _window = {}

local WIDTH = dpi(340)
local HEIGHT = dpi(460)

local States = {
   HIDDEN = 0,
   SHOWN = 1,
}

function _window:constructor(s)
   self.s = s
   self.positions = nil
   self.state = States.HIDDEN
   self:_make_popup()
end

function _window:_get_positions()
   local function getter(self)
      if self.positions ~= nil then
         return self.positions
      end
      local s = self.s
      local gap = beautiful.useless_gap * 2
      local base_x = s.geometry.x + s.geometry.width - WIDTH - gap
      local bar_height = dpi(self.s.panel.initial_height)
      self.positions = {
         [States.HIDDEN] = {
            x = base_x,
            y = s.geometry.y + s.geometry.height + gap,
         },
         [States.SHOWN] = {
            x = base_x,
            y = s.geometry.y + s.geometry.height - HEIGHT - bar_height - gap,
         },
      }
      return self.positions
   end

   local pos = getter(self)
   return pos[self.state]
end

function _window:_make_popup()
   local positions = self:_get_positions()

   self.content_container = wibox.widget({
      widget = wibox.container.background,
      bg = beautiful.colors.background,
      {
         widget = wibox.container.margin,
         margins = dpi(12),
         {
            widget = wibox.widget.textbox,
            markup = 'center',
            align = 'center',
            valign = 'center',
         },
      },
   })

   self.panel = wibox({
      type = 'normal',
      ontop = true,
      visible = false,
      width = WIDTH,
      height = HEIGHT,
      x = positions.x,
      y = positions.y,
      shape = utils:srounded(dpi(12)),
      bg = beautiful.colors.transparent,
      widget = self.content_container,
      widget = {
         widget = wibox.container.background,
         bg = beautiful.colors.transparent,
         shape = utils:srounded(dpi(12)),
         self.content_container,
      },
   })

   self.panel.open_animation = animation:new({
      duration = 0.45,
      easing = animation.easing.inOutCubic,
      pos = {
         x = self.panel.x,
         y = self.panel.y,
      },
      update = function(_, pos)
         self.panel.x = pos.x
         self.panel.y = pos.y
      end,
      signals = {
         ['ended'] = function()
            if self.state == States.HIDDEN then
               self.panel.visible = false
            end
         end,
      },
   })
end

function _window:_set_panel_state(new_state)
   self.state = new_state
   self.panel.open_animation:set({
      target = {
         x = self:_get_positions().x,
         y = self:_get_positions().y,
      },
   })
end

function _window:raise()
   self.panel.visible = true
   self:_set_panel_state(States.SHOWN)
end

function _window:hide()
   self:_set_panel_state(States.HIDDEN)
end

function _window:toggle()
   if self.state == States.HIDDEN then
      self:raise()
   else
      self:hide()
   end
end

return oop(_window)
