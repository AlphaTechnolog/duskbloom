local wibox = require("wibox")
local gtimer = require("gears.timer")
local oop = require("framework.oop")
local NetworkService = require("framework.services.network")
local beautiful = require("beautiful")

local network = {}

function network:_get_widget()
	return wibox.widget({
		widget = wibox.widget.textbox,
		font = beautiful.fonts:choose("icons", 12),
		markup = beautiful.icons.Wifi.DISCONNECTED,
		valign = "center",
		align = "center",
	})
end

function network:render()
	local w = self:_get_widget()
	w.with_ethernet = false

	local function on_ethernet()
		w.with_ethernet = true
		w:set_markup_silently(beautiful.icons.Wifi.ETHERNET_CONNECTED)
	end

	-- TODO: We could maybe create a little tooltip with the ssid
	-- if we get here, but not for now since i need to build
	-- the tooltip widget first in a suitable fashion.
	local function on_wifi_connected(_)
		w.with_ethernet = false
		w:set_markup_silently(beautiful.icons.Wifi.CONNECTED)
	end

	local function on_disconnected()
		w.with_ethernet = false
		w:set_markup_silently(beautiful.icons.Wifi.DISCONNECTED)
	end

	local function on_ethernet_change(_, state)
		if state then
			on_ethernet()
		else
			on_disconnected()
		end
	end

	local function on_wireless_state_change(_, state)
		if state then
			on_wifi_connected(nil)
		else
			on_disconnected()
		end
	end

	gtimer.delayed_call(function()
		on_wireless_state_change(nil, NetworkService:wireless_state())
		on_ethernet_change(nil, NetworkService:ethernet_state())
		NetworkService:connect_signal("ethernet_state", on_ethernet_change)
		NetworkService:connect_signal("wireless_state", on_wireless_state_change)
		NetworkService:connect_signal("access_point::disconnected", on_disconnected)
		NetworkService:connect_signal("access_point::connected", function(_, ssid)
			on_wifi_connected(ssid)
		end)
	end)

	return w
end

return oop(network)
