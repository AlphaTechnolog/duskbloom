local wibox = require("wibox")
local awful = require("awful")
local oop = require("framework.oop")
local utils = require("framework.utils")()
local panel_config = Configuration.UserLikes:get_key("panel")
local wm_config = Configuration.UserLikes:get_key("wm")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local Tasklist = require("ui.panel.modules.tasklist")
local Layoutbox = require("ui.panel.modules.layoutbox")
local Services = require("ui.panel.modules.services")

local _window = {}

local HEIGHT = 45

function _window:constructor(s)
   self.s = s
   self.gaps = nil
   self.initial_height = HEIGHT
   self:make_window()
end

function _window:get_gaps()
   if self.gaps ~= nil then
      return self.gaps
   end

   local gaps = panel_config.gaps or "inherit"
   if gaps == "inherit" then
      gaps = dpi(wm_config.gaps)
   elseif type(gaps) == "number" then
      gaps = dpi(gaps)
   else
      error(
         "Invalid gaps value on the user configuration of type "
         .. type(gaps)
         .. ": "
         .. gaps
      )
   end

   -- lets cache it.
   self.gaps = gaps

   return gaps
end

function _window:get_panel_position()
   local height = dpi(HEIGHT)
   local gaps = self:get_gaps()

   local margin_offset = dpi(120)
   local width = self.s.geometry.width - margin_offset
   local x = self.s.geometry.x + ((self.s.geometry.width - width) / 2)

   local position = {
      x = x,
      y = self.s.geometry.y + self.s.geometry.height - height,
      width = width,
      height = height,
   }

   return position
end

function _window:make_window()
   local position = self:get_panel_position()
   local gaps = self.gaps or error("unreachable")

   self.popup = awful.popup({
      type = "dock",
      visible = false,
      bg = beautiful.colors.transparent,
      fg = beautiful.colors.foreground,
      x = position.x,
      y = position.y,
      minimum_width = position.width,
      maximum_width = position.width,
      minimum_height = position.height,
      maximum_height = position.height,
      widget = wibox.widget({
         widget = wibox.container.background,
         bg = beautiful.colors.transparent, -- antialiasing
         shape = utils:prounded(dpi(12), true, true, false, false),
         {
            widget = wibox.container.background,
            bg = beautiful.colors.background,
            shape = utils:prounded(dpi(12), true, true, false, false),
            {
               layout = wibox.layout.flex.horizontal,
               {
                  widget = wibox.container.margin,
                  left = dpi(12),
                  {
                     layout = wibox.layout.fixed.horizontal,
                     spacing = dpi(4),
                     -- TODO
                  },
               },
               {
                  widget = wibox.container.place,
                  valign = "center",
                  halign = "center",
                  {
                     layout = wibox.layout.fixed.horizontal,
                     spacing = dpi(7),
                     Tasklist(self.s):render(),
                  },
               },
               {
                  widget = wibox.container.place,
                  halign = "right",
                  hexpand = true,
                  {
                     widget = wibox.container.margin,
                     right = dpi(7),
                     {
                        layout = wibox.layout.fixed.horizontal,
                        spacing = dpi(4),
                        Services():render(),
                     },
                  },
               },
            },
			},
		}),
	})

	self.popup:struts({
		bottom = self.is_floating and position.height + gaps * 2
			or position.height,
	})
end

function _window:raise()
	self.popup.visible = true
end

return oop(_window)
