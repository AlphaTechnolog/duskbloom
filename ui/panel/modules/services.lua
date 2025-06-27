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

function _services:constructor(s)
	self.s = s
	self._private.colors = nil
end

function _services:_get_colors()
	if self._private.colors ~= nil then
		return self._private.colors
	end

	local colors = utils:for_scheme({
		normal = beautiful.colors.black,
		hovered = beautiful.colors.hovered_black,
	}, {
		normal = beautiful.colors.background,
		hovered = beautiful.colors.black,
	})

	self._private.colors = colors

	return colors
end

function _services:_get_container()
	local colors = self:_get_colors()

	return wibox.widget({
		widget = wibox.container.background,
		bg = colors.normal,
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
					margins = utils:axis_margins(4, 8),
					{
						id = "separator",
						widget = wibox.container.background,
						vexpand = true,
						forced_width = dpi(1),
						bg = utils:for_scheme(beautiful.colors.light_black_12, beautiful.colors.light_background_12),
					},
				},
				Clock():render(),
			},
		},
	})
end

function _services:render()
	local colors = self:_get_colors()
	local container = hoverable(self:_get_container())
	container:setup_hover({ colors = colors })

	-- lock hover if control center is already opened.
	container:can_hover(function(_)
		local cc = self.s.control_center
		return not cc.panel.visible
	end)

	-- update separator color during hover.
	container:connect_signal("animation:hex-change", function(self, newcolor)
		self.separator.bg = color.shade(newcolor, 12 * 2)
	end)

	container:add_button(abutton({}, 1, function()
		local cc = self.s.control_center
		cc:toggle()
	end))

	-- these are sent from the control center but since we've a
	-- circular dependency with panel and control center, we can't
	-- subscribe to the control center without being in an asynchronous
	-- context, so the hack here is that the control center sends this
	-- global signal, i dont like this at all but whatever ig...
	Awesome.connect_signal("cc:open", function()
		container:use_color(colors.hovered)
	end)

	Awesome.connect_signal("cc:close", function()
		container:use_color(colors.normal)
	end)

	return container
end

return oop(_services)
