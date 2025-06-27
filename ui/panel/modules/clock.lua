local wibox = require("wibox")
local gtimer = require("gears.timer")
local aspawn = require("awful.spawn")
local oop = require("framework.oop")

-- seconds iirc
local CLOCK_TIMER = 30

local _clock = {}

function _clock:constructor()
	self._label = wibox.widget({
		widget = wibox.widget.textbox,
		align = "center",
		valign = "center",
		markup = "ello",
	})
	self:_create_timer()
end

function _clock:_create_timer()
	self._clock_timer = gtimer({
		timeout = CLOCK_TIMER,
		call_now = true,
		autostart = true,
		callback = function()
			aspawn.easy_async_with_shell("date '+%I:%M %p'", function(stdout)
				self._label:set_markup_silently(string.gsub(stdout, "\n", ""))
			end)
		end,
	})
end

function _clock:render()
	return self._label
end

return oop(_clock)
