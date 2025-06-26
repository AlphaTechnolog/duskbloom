local ascreen = require('awful.screen')

local Window = require(... .. '.window')

ascreen.connect_for_each_screen(function (s)
   s.layoutlist = Window(s)
   s.layoutlist:install()
end)
