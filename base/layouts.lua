local awful = require("awful")
local bling = require("extern.bling")

Tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.spiral.dwindle,
		awful.layout.suit.tile,
		awful.layout.suit.floating,
		awful.layout.suit.max,
		bling.layout.centered,
		bling.layout.mstab,
		bling.layout.equalarea,
		bling.layout.deck,
	})
end)
