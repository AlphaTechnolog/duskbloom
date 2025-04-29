local wibox = require("wibox")
local gfs = require("gears.filesystem")
local awful = require("awful")
local utils = require("framework.utils")()
local wallpaper = Configuration.UserLikes:get_key("wallpaper")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local function validate_config()
	local valid_types = { "color", "file" }
	for _, vtype in ipairs(valid_types) do
		if wallpaper.type == vtype then
			return nil
		end
	end
	return "Invalid given wallpaper type '" .. wallpaper.type .. "'"
end

local function image_wallpaper(shape)
	-- remove the file:// prefix
	local filename = string.sub(
		wallpaper.value
			or (
				"file://"
				.. gfs.get_configuration_dir()
				.. "/assets/wallpaper.png"
			),
		8
	)

	return wibox.widget({
		widget = wibox.widget.imagebox,
		valign = "center",
		halign = "center",
		resize = true,
		horizontal_fit_policy = true,
		vertical_fit_policy = true,
		clip_shape = shape,
		image = filename,
	})
end

local function color_wallpaper(shape)
	local scheme_prefix = "scheme://"
	local hex_prefix = "hex://"
	local color = nil

	-- scheme://<color> will allow you to choose a color from the palette itself.
	if string.sub(wallpaper.value, 1, #scheme_prefix) == scheme_prefix then
		color = beautiful.colors[string.sub(wallpaper.value, #scheme_prefix + 1)]
	elseif string.sub(wallpaper.value, 1, #hex_prefix) == hex_prefix then
		color = string.sub(wallpaper.value, #hex_prefix + 1)
	end

	return wibox.widget({
		widget = wibox.container.background,
		shape = shape,
		bg = color,
	})
end

local function wallpaper_for_screen(s)
	local errmsg = validate_config()

	-- TODO: Improve error throwing.
	-- go moment
	if errmsg ~= nil then
		error(errmsg)
	end

	local shape = wallpaper.disable_borders and utils:srounded(0)
		or utils:prounded(
			wallpaper.rounded_corners.roundness,
			wallpaper.rounded_corners.top_left,
			wallpaper.rounded_corners.top_right,
			wallpaper.rounded_corners.bottom_right,
			wallpaper.rounded_corners.bottom_left
		)

	-- TODO: Implement tiled too.
	local raw_widget = wallpaper.type == "color" and color_wallpaper(shape)
		or image_wallpaper(shape)

	awful.wallpaper({
		screen = s,
		widget = {
			widget = wibox.container.background,
			bg = beautiful.colors.background,
			valign = "center",
			halign = "center",
			{
				widget = wibox.container.background,
				shape = shape,
				raw_widget,
			},
		},
	})
end

Screen.connect_signal("request::wallpaper", wallpaper_for_screen)
