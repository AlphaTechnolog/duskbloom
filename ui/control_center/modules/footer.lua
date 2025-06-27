local wibox = require("wibox")
local gshape = require("gears.shape")
local oop = require("framework.oop")
local utils = require("framework.utils")()
local color = require("framework.color")
local hoverable = require("ui.guards.hoverable")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local ActionButton = require("ui.control_center.modules.action_button")

local _footer = {}

function _footer:_signout_button()
	local button = hoverable(wibox.widget({
		widget = wibox.container.background,
		bg = beautiful.colors.black,
		shape = gshape.rounded_bar,
		get_separator = function(self)
			return self:get_children_by_id("separator")[1]
		end,
		{
			widget = wibox.container.margin,
			margins = utils:axis_margins(4, 12),
			{
				layout = wibox.layout.align.horizontal,
				{
					widget = wibox.widget.textbox,
					font = beautiful.fonts:choose("icons", 14),
					markup = "",
					align = "center",
					valign = "center",
				},
				{
					widget = wibox.container.margin,
					margins = utils:xmargins(4, 4, 6, 8),
					{
						id = "separator",
						widget = wibox.container.background,
						forced_width = dpi(1),
						vexpand = true,
						bg = beautiful.colors.light_black_12,
					},
				},
				{
					widget = wibox.widget.textbox,
					markup = "Sign out",
					align = "center",
					valign = "center",
				},
			},
		},
	}))

	button:setup_hover({
		colors = {
			normal = beautiful.colors.black,
			hovered = beautiful.colors.hovered_black,
		},
	})

	button:connect_signal("animation:hex-change", function(self, hex)
		self.separator.bg = color.shade(hex, 12 * 2) -- 12 * 2 becuase palette:generate_shades() uses the step.
	end)

	return button
end

function _footer:_power_button()
	local btn = ActionButton():widget("")

	btn:connect_signal("clicked", function(_)
		utils:todo()
	end)

	return btn
end

function _footer:_settings_button()
	local btn = ActionButton():widget("")

	btn:connect_signal("clicked", function(_)
		utils:todo()
	end)

	return btn
end

function _footer:_action_buttons()
	local layout = wibox.layout.fixed.horizontal()
	layout.spacing = dpi(8)

	layout:add(self:_power_button())
	layout:add(self:_settings_button())

	return layout
end

function _footer:render()
	return wibox.widget({
		layout = wibox.layout.align.horizontal,
		{
			widget = wibox.container.place,
			valign = "center",
			halign = "left",
			{
				layout = wibox.layout.fixed.horizontal,
				self:_signout_button(),
			},
		},
		nil,
		self:_action_buttons(),
	})
end

return oop(_footer)
