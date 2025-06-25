local awful = require('awful')
local gtimer = require('gears.timer')
local Window = require('ui.control_center.window')

gtimer.delayed_call(function()
   awful.screen.connect_for_each_screen(function(s)
      s.control_center = Window(s)
   end)
end)
