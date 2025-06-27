local aspawn = require("awful.spawn")
local gtimer = require("gears.timer")
local oop = require("framework.oop")
local NetworkService = require("framework.services.network")

local _radio = {}
local instance = nil

function _radio:constructor()
	self._private.enabled = false
	self:_check_state()
end

function _radio:toggle()
	if self._private.enabled == false or self._private.enabled == nil then
		self:turn_on()
	else
		self:turn_off()
	end
end

function _radio:turn_on()
	aspawn("rfkill block all", false)
	self._private.enabled = true
	self:emit_signal("state", true)
end

function _radio:turn_off()
	aspawn("rfkill unblock all", false)
	self._private.enabled = false
	self:emit_signal("state", false)
end

local function on_wireless_state_change(self, state)
	if self._private.enabled and state == true then
		self:turn_off()
	end
end

function _radio:_check_state()
	NetworkService:connect_signal("wireless_state", function(_, state)
		on_wireless_state_change(self, state)
	end)

	gtimer.delayed_call(function()
		-- TODO: Determine default state value from cache.
		if self._private.enabled then
			self:turn_on()
		else
			self:turn_off()
		end

		on_wireless_state_change(self, NetworkService:wireless_state())
	end)
end

-- singleton
if not instance then
	instance = oop(_radio)()
end
return instance
