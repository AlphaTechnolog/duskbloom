local wibox = require("wibox")
local gtimer = require("gears.timer")
local utils = require("framework.utils")()
local oop = require("framework.oop")
local color = require("framework.color")
local animation = require("framework.animation")
local hoverable = require("ui.guards.hoverable")
local inspect = require("extern.inspect")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local network = require("framework.services.network")

local _container = {}

function _container:_create_chip(opts)
	-- TODO: Add button
	local further_configuration_button = wibox.widget({
		visible = opts.really_configurable,
		widget = wibox.widget.textbox,
		markup = "",
		font = beautiful.fonts:choose("icons", 16),
		valign = "center",
		align = "center",
	})

	local States = {
		ACTIVE = 0,
		INACTIVE = 1,
	}

	local colors = {
		[States.ACTIVE] = {
			normal = {
				bg = beautiful.colors.accent,
				fg = beautiful.colors.accent_foreshade,
			},
			hovered = {
				bg = utils:color_adaptive_shade(beautiful.colors.accent, 7),
				fg = beautiful.colors.accent_foreshade,
			},
		},
		[States.INACTIVE] = {
			normal = {
				bg = beautiful.colors.black,
				fg = beautiful.colors.foreground,
			},
			hovered = {
				bg = beautiful.colors.hovered_black,
				fg = beautiful.colors.foreground,
			},
		},
	}

	local INITIAL_STATE = States.INACTIVE

	local base = hoverable(wibox.widget({
		widget = wibox.container.background,
		bg = colors[INITIAL_STATE].normal.bg,
		fg = colors[INITIAL_STATE].normal.fg,
		shape = utils:srounded(dpi(12)),
		get_icon_element = utils:wibox_by_id_getter("icon_element"),
		get_title_element = utils:wibox_by_id_getter("title"),
		get_body_element = utils:wibox_by_id_getter("body"),
		set_icon_markup = function(self, new_markup)
			self.icon_element:set_markup_silently(new_markup)
		end,
		set_title = function(self, new_title)
			self.title_element:set_markup_silently(new_title)
		end,
		set_body = function(self, new_body)
			self.body_element:set_markup_silently(new_body)
		end,
		{
			widget = wibox.container.margin,
			margins = utils:axis_margins(8, 8, 0, 0),
			{
				layout = wibox.layout.align.horizontal,
				{
					widget = wibox.container.margin,
					margins = utils:axis_margins(0, 6),
					{
						widget = wibox.container.place,
						valign = "center",
						halign = "center",
						{
							id = "icon_element",
							widget = wibox.widget.textbox,
							markup = opts.icon,
							font = beautiful.fonts:choose("icons", 14),
							valign = "center",
							align = "center",
						},
					},
				},
				{
					widget = wibox.container.margin,
					margins = utils:axis_margins(0, 2),
					{
						layout = wibox.layout.fixed.vertical,
						valign = "center",
						spacing = dpi(1),
						{
							id = "title",
							widget = wibox.widget.textbox,
							font = beautiful.fonts:choose("normal", 10),
							valign = "center",
							align = "left",
							markup = opts.initial_title,
						},
						{
							id = "body",
							widget = wibox.widget.textbox,
							font = beautiful.fonts:choose("normal", 8),
							valign = "center",
							align = "left",
							markup = opts.initial_body,
						},
					},
				},
				{
					widget = wibox.container.margin,
					margins = utils:axis_margins(0, 6),
					further_configuration_button,
				},
			},
		},
	}))

	base.cur_state = INITIAL_STATE

	base:setup_hover({
		colors = {
			normal = colors[base.cur_state].normal.bg,
			hovered = colors[base.cur_state].hovered.bg,
		},
	})

	base.States = States

	-- OPTIMIZATION: We could instead of using hoverable to create an animation between the backgrounds
	-- create a single animation object with both bg and fg, and then manage to the hover manually
	-- so we can reuse the same animation object for both channels, but rn, it does not have too much
	-- impact on performance with this method and it is easier to write at first, so we'll see at future.
	base.fg_animation = animation:new({
		duration = 0.25,
		easing = animation.easing.inOutQuad,
		pos = color.hex_to_rgba(colors[base.cur_state].normal.fg),
		update = function(_, pos)
			base.fg = color.rgba_to_hex(pos)
		end,
	})

	function base.fg_animation:new_color(value)
		self:set({ target = color.hex_to_rgba(value) })
	end

	function base:switch_state(new_state)
		if new_state ~= self.cur_state then
			self.cur_state = new_state
			self.fg_animation:new_color(colors[self.cur_state].normal.fg)
			self:resetup_hover({
				colors = {
					normal = colors[self.cur_state].normal.bg,
					hovered = colors[self.cur_state].hovered.bg,
				},
			})
		end
	end

	base:add_button(utils:left_click(function()
		base:emit_signal("clicked")
	end))

	return base
end

function _container:_get_wifi()
	local Icons = {
		CONNECTED = "",
		DISCONNECTED = "",
		ETHERNET_CONNECTED = "",
	}

	local wifi = self:_create_chip({
		really_configurable = true,
		icon = Icons.CONNECTED,
		initial_title = "Network",
		initial_body = "Connected",
	})

	wifi.with_ethernet = false

	local function setup_active_ethernet()
		wifi.with_ethernet = true
		wifi:switch_state(wifi.States.ACTIVE)
		wifi:set_icon_markup(Icons.ETHERNET_CONNECTED)
		wifi:set_title("Ethernet")
		wifi:set_body("Connected")
	end

	local function connected(ssid)
		wifi:switch_state(wifi.States.ACTIVE)
		wifi:set_icon_markup(Icons.CONNECTED)
		wifi:set_title(ssid ~= nil and ssid or "Wi-Fi")
		wifi:set_body("Connected")
	end

	local function disconnected()
		wifi.with_ethernet = false
		wifi:switch_state(wifi.States.INACTIVE)
		wifi:set_icon_markup(Icons.DISCONNECTED)
		wifi:set_title("Wi-Fi")
		wifi:set_body("Disconnected")
	end

	local function on_ethernet_change(_, state)
		if state then
			setup_active_ethernet()
		else
			disconnected()
		end
	end

	local function on_wireless_state_change(_, state)
		if state then
			connected(nil)
		else
			disconnected()
		end
	end

	gtimer.delayed_call(function()
		on_wireless_state_change(nil, network:wireless_state())
		on_ethernet_change(nil, network:ethernet_state())
		network:connect_signal("ethernet_state", on_ethernet_change)
		network:connect_signal("wireless_state", on_wireless_state_change)
		network:connect_signal("access_point::disconnected", disconnected)
		network:connect_signal("access_point::connected", function(_, ssid)
			connected(ssid)
		end)
	end)

	wifi:can_hover(function(self)
		return not self.with_ethernet
	end)

	wifi:connect_signal("clicked", function(self)
		if self.with_ethernet then
			return
		end
		network:toggle_wireless_state()
	end)

	return wifi
end

function _container:_get_layout()
	local layout = wibox.widget({
		layout = wibox.layout.grid.vertical,
		homogeneous = true,
		forced_num_cols = 2,
		spacing = dpi(12),
		expand = true,
	})

	layout:add(self:_get_wifi())
	-- layout:add(self:_get_wifi())
	-- layout:add(self:_get_wifi())
	-- layout:add(self:_get_wifi())
	-- layout:add(self:_get_wifi())
	-- layout:add(self:_get_wifi())

	return layout
end

function _container:render()
	local layout = self:_get_layout()

	return wibox.widget({
		widget = wibox.container.margin,
		-- margins = dpi(6),
		layout,
	})
end

return oop(_container)
