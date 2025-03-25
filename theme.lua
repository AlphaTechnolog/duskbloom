--    ___                                         _
-- |_ _|_ __    _ __    ___ _ _| |_ ___
--    | || '    \| '_ \/ _ \ '_|    _(_-<
-- |___|_|_|_| .__/\___/_|    \__/__/
--                     |_|

local xresources = require("beautiful.xresources")
local gfs = require("gears.filesystem")
local gcolor = require("gears.color")
local color = require("framework.color")
local palette = require("framework.palette")()
local dpi = xresources.apply_dpi

local themes_path = gfs.get_themes_dir()
local conf_dir = gfs.get_configuration_dir()
local assets_path = conf_dir .. "assets/"
local icons_path = assets_path .. "icons/"

local theme = {}

-- distro icon
theme.distro = icons_path
  .. io.popen("sh -c '. /etc/os-release; echo $ID'"):read("*l")
  .. ".svg"

theme.default_distro = icons_path .. "awesome.svg"

-- generic for non supported (atm) distro.
if gfs.file_readable(theme.distro) ~= true then
  theme.distro = theme.default_distro
end

function theme:is_distro_icon_supported()
  return theme.distro ~= theme.default_distro
end

--    ___                _
-- | __|__ _ _| |_ ___
-- | _/ _ \ ' \    _(_-<
-- |_|\___/_||_\__/__/

theme.fonts = {
  normal = "Roboto ",
  icons = "Material Symbols Rounded ",
  nerdfonts = "Iosevka Nerd Font ",
}

function theme.fonts:choose(family, size)
  return self[family] .. tostring(size)
end

theme.font = theme.fonts:choose("normal", 9)

--    ___         _
-- / __|___| |___ _ _ ___
-- | (__/ _ \ / _ \ '_(_-<
-- \___\___/_\___/_| /__/

local user_likes = Configuration.UserLikes or {}

theme.scheme = user_likes.theme.scheme

theme.colors =
  palette:generate_shades(user_likes.theme.scheme, user_likes.theme.colors)

-- transparent bg
theme.colors.transparent = theme.colors.background .. "00"

-- accent color
function theme.colors:apply_shade(key)
  return {
    regular = self[key] .. "1A",
    bright = self[key] .. "33",
  }
end

theme.colors.accent = theme.colors[user_likes.theme.accents.primary]
theme.colors.secondary_accent = theme.colors[user_likes.theme.accents.secondary]

local accent_shade = theme.colors:apply_shade("accent")

theme.colors.accent_shade = accent_shade.regular
theme.colors.light_accent_shade = accent_shade.bright

-- contrast acceptable background/foreground shade over accent
theme.colors.accent_foreshade = color.is_contrast_acceptable(
  theme.colors.background,
  theme.colors.accent
) and theme.colors.foreground or theme.colors.background

theme.bg_normal = theme.colors.background
theme.fg_normal = theme.colors.foreground

theme.bg_systray = theme.bg_normal
theme.fg_systray = theme.fg_normal

--    ___                                             _
-- / __|___ _ _    ___ _ _ __ _| |
-- | (_ / -_) ' \/ -_) '_/ _` | |
-- \___\___|_||_\___|_| \__,_|_|

local DEFAULT_GAPS = 4
local wmconfig = user_likes.wm or {}
theme.useless_gap = dpi(wmconfig.gaps or DEFAULT_GAPS)
theme.border_width = dpi(user_likes.theme.scheme == "light" and 0 or 1)
theme.border_color_normal = theme.colors.light_black_8
theme.border_color_active = theme.colors.hovered_black
theme.border_color_marked = theme.colors.light_black_8
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)
theme.icon_theme = "Papirus-Dark"

--    _                                             _
-- | |     __ _ _    _ ___ _    _| |_
-- | |__/ _` | || / _ \ || |    _|
-- |____\__,_|\_, \___/\_,_|\__|
--                        |__/

theme.layout_fairh = gcolor.recolor_image(themes_path .. "default/layouts/fairhw.png", theme.colors.foreground)
theme.layout_fairv = gcolor.recolor_image(themes_path .. "default/layouts/fairvw.png", theme.colors.foreground)
theme.layout_floating = gcolor.recolor_image(themes_path .. "default/layouts/floatingw.png", theme.colors.foreground)
theme.layout_magnifier = gcolor.recolor_image(themes_path .. "default/layouts/magnifierw.png", theme.colors.foreground)
theme.layout_max = gcolor.recolor_image(themes_path .. "default/layouts/maxw.png", theme.colors.foreground)
theme.layout_fullscreen = gcolor.recolor_image(themes_path .. "default/layouts/fullscreenw.png", theme.colors.foreground)
theme.layout_tilebottom = gcolor.recolor_image(themes_path .. "default/layouts/tilebottomw.png", theme.colors.foreground)
theme.layout_tileleft = gcolor.recolor_image(themes_path .. "default/layouts/tileleftw.png", theme.colors.foreground)
theme.layout_tile = gcolor.recolor_image(themes_path .. "default/layouts/tilew.png", theme.colors.foreground)
theme.layout_tiletop = gcolor.recolor_image(themes_path .. "default/layouts/tiletopw.png", theme.colors.foreground)
theme.layout_spiral = gcolor.recolor_image(themes_path .. "default/layouts/spiralw.png", theme.colors.foreground)
theme.layout_dwindle = gcolor.recolor_image(themes_path .. "default/layouts/dwindlew.png", theme.colors.foreground)
theme.layout_cornernw = gcolor.recolor_image(themes_path .. "default/layouts/cornernww.png", theme.colors.foreground)
theme.layout_cornerne = gcolor.recolor_image(themes_path .. "default/layouts/cornernew.png", theme.colors.foreground)
theme.layout_cornersw = gcolor.recolor_image(themes_path .. "default/layouts/cornersww.png", theme.colors.foreground)
theme.layout_cornerse = gcolor.recolor_image(themes_path .. "default/layouts/cornersew.png", theme.colors.foreground)

return theme
