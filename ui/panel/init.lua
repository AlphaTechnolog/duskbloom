local awful = require("awful")
local Window = require("ui.panel.window")
local gtimer = require("gears.timer")

gtimer.delayed_call(function()
	awful.screen.connect_for_each_screen(function(s)
		local window = Window(s)
		s.panel = window
		s.panel:raise()
	end)
end)
