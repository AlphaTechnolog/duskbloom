local wibox = require("wibox")
local aspawn = require("awful.spawn")
local abutton = require("awful.button")
local gshape = require("gears.shape")
local gtimer = require("gears.timer")
local oop = require("framework.oop")
local utils = require("framework.utils")()
local hoverable = require("ui.guards.hoverable")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local FaceService = require("framework.services.face")

local _header = {}

function _header:_get_clock()
	local clock = wibox.widget({
		widget = wibox.widget.textbox,
		font = beautiful.fonts:choose("normal", 26),
		markup = "",
		align = "left",
		valign = "center",
	})

	gtimer({
		timeout = 30,
		call_now = true,
		autostart = true,
		callback = function()
			aspawn.easy_async_with_shell('date "+%H:%M"', function(stdout)
				clock:set_markup_silently(string.gsub(stdout, "\n", ""))
			end)
		end,
	})

	return clock
end

function _header:_get_date()
	local day = wibox.widget({
		widget = wibox.widget.textbox,
		font = beautiful.fonts:choose("normal", 10),
		markup = "",
		align = "left",
		valign = "center",
	})

	local weekday = wibox.widget({
		widget = wibox.widget.textbox,
		font = beautiful.fonts:choose("normal", 10),
		markup = "",
		align = "left",
		valign = "center",
	})

	gtimer({
		timeout = 24 * 60 * 60, -- 1 day.
		call_now = true,
		autostart = true,
		callback = function()
			aspawn.easy_async_with_shell('date "+%d %b %y"', function(stdout)
				day:set_markup_silently(string.gsub(stdout, "\n", ""))
			end)
			aspawn.easy_async_with_shell('date "+%A"', function(stdout)
				weekday:set_markup_silently(string.gsub(stdout, "\n", ""))
			end)
		end,
	})

	return wibox.widget({
		widget = wibox.container.place,
		valign = "center",
		{
			layout = wibox.layout.fixed.vertical,
			day,
			weekday,
		},
	})
end

function _header:_get_pfp()
	local face_service = FaceService()

	local image = wibox.widget({
		widget = wibox.widget.imagebox,
		image = face_service:fetch(),
		valign = "center",
		halign = "center",
		forced_width = dpi(34),
		forced_height = dpi(34),
		clip_shape = gshape.circle,
	})

	local ring_colors = utils:for_scheme({
		normal = beautiful.colors.black,
		hovered = beautiful.colors.hovered_black,
	}, {
		normal = beautiful.colors.background,
		hovered = beautiful.colors.black,
	})

	local container = hoverable(wibox.widget({
		widget = wibox.container.background,
		bg = ring_colors.normal,
		shape = gshape.circle,
		{
			widget = wibox.container.margin,
			margins = dpi(1), -- ring width
			image,
		},
	}))

	container:setup_hover({ colors = ring_colors })

	container:add_button(abutton({}, 1, function()
		utils:todo()
	end))

	return container
end

function _header:render()
	return wibox.widget({
		layout = wibox.layout.align.horizontal,
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(10),
			self:_get_clock(),
			self:_get_date(),
		},
		nil,
		self:_get_pfp(),
	})
end

return oop(_header)
