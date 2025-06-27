local wibox = require("wibox")
local gshape = require("gears.shape")
local abutton = require("awful.button")
local oop = require("framework.oop")
local hoverable = require("ui.guards.hoverable")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local _button = {}

function _button:widget(icon)
	local el = hoverable(wibox.widget({
		widget = wibox.container.background,
		shape = gshape.circle,
		bg = beautiful.colors.black,
		{
			widget = wibox.container.margin,
			margins = dpi(8),
			{
				widget = wibox.widget.textbox,
				markup = icon,
				font = beautiful.fonts:choose("icons", 14),
				valign = "center",
				align = "center",
			},
		},
	}))

	el:setup_hover({
		colors = {
			normal = beautiful.colors.black,
			hovered = beautiful.colors.hovered_black,
		},
	})

	el:add_button(abutton({}, 1, function()
		el:emit_signal("clicked")
	end))

	return el
end

return oop(_button)
