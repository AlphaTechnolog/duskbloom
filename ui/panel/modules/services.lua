local wibox = require("wibox")
local ascreen = require("awful.screen")
local abutton = require("awful.button")
local utils = require("framework.utils")()
local oop = require("framework.oop")
local hoverable = require("ui.guards.hoverable")
local color = require("framework.color")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local Network = require("ui.panel.modules.icons.network")
local Volume = require("ui.panel.modules.icons.volume")
local Clock = require("ui.panel.modules.clock")

local _services = {}

function _services:render()
	local container = hoverable(wibox.widget({
		widget = wibox.container.background,
		bg = beautiful.colors.black,
		shape = utils:srounded(dpi(12)),
		get_separator = function(self)
			return self:get_children_by_id("separator")[1]
		end,
		{
			widget = wibox.container.margin,
			margins = {
				top = dpi(5),
				bottom = dpi(5),
				left = dpi(12),
				right = dpi(12),
			},
			{
				layout = wibox.layout.align.horizontal,
				{
					layout = wibox.layout.fixed.horizontal,
					spacing = dpi(6),
					Network():render(),
					Volume():render(),
				},
				{
					widget = wibox.container.margin,
					margins = {
						left = dpi(8),
						right = dpi(8),
					},
					{
						id = "separator",
						widget = wibox.container.background,
						vexpand = true,
						forced_width = dpi(2),
						bg = beautiful.colors.light_black_7,
					},
				},
				Clock():render(),
			},
		},
	}))

	container:setup_hover({
		colors = {
			normal = beautiful.colors.black,
			hovered = beautiful.colors.hovered_black,
		},
	})

	container:connect_signal("animation:hex-change", function(self, newcolor)
		self.separator.bg = color.lighten(newcolor, 12)
	end)

	container:add_button(abutton({}, 1, function()
		local s = ascreen.focused()
		if not s then
			return
		end
		local cc = s.control_center
		if not cc then
			return
		end
		cc:toggle()
	end))

	return container
end

return oop(_services)
