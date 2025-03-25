# AwesomeWM Shell - fancy

> [!NOTE]
> I'm looking for a better codename ok.

![banner](./assets/banner.png)

## Installation

You'll need these dependencies assuming you're on an arch-based system, but it should be pretty
easy to get them all on systems like gentoo or nixos, systems that i've already confirmed this
works.

1. Install build deps.

```sh
# git ofc
sudo pacman -S git base-devel

# aur?
mkdir -pv ~/repo
cd !$
git clone https://aur.archlinux.org/yay-bin.git --depth=1 yay
cd !$
makepkg -si

# go back.
cd ~
```

2. Install awesomewm (git version)

First you'll have to install xorg, use your package manager of the distro
or build it yourself if using LFS lmao.

```sh
sudo pacman -S xorg --noconfirm
```

#### AwesomeWM git

This thing requires the git version of AwesomeWM in order
to work, you can get it with the arch user repository, but in
other distros, you might have to build it completely yourself.

In gentoo you can unmask `x11-wm/awesome:9999` by using:

```sh
echo 'x11-wm/awesome **' | sudo tee /etc/portage/package.accept_keywords/awesome
```

In arch you can use aur.

```sh
yay -S awesome-git
```

3. Install xinit

You'll need the `xorg-xinit` package on arch, and then set it up.

```sh
# xorg and xorg-xinit (iirc that's the package name).
sudo pacman -S xorg-xinit
echo 'exec awesome' > .xinitrc
```

> [!TIP]
> You may need to use `exec dbus-run-session awesome` in some non systemd distros.

4. Clone the configuration

```sh
git clone https://github.com/alphatechnolog/duskbloom.git -b fancy \
    --recurse-submodules \
    ~/.config/awesome

# create some common folders
mkdir -pv \
    ~/.config/fancy \
    ~/.cache/fancy
```

> The config will create them anyways but just to make sure, i wouldn't trust this codebase.

5. Install more packages because this thing needs the whole world to work.

This thing will require more packages because we aim to have something full of bloat why not?
Also i may have forgotten something, so report if you think anything is missing here.

```sh
sudo pacman -S \
    bluez blueman pulseaudio pavucontrol \
    playerctl networkmanager alacritty \
    thunar upower

# Networkmanager will be required because else how will i show you the network icon bro?
sudo systemctl enable --now NetworkManager

# Same applies to bluetooth lol, also upower and playerctl, they all need to be installed.
sudo systemctl enable --now bluetooth
```

> Note that you may also require to install picom (check if you need fork, but im using vanilla)
> In gentoo you can use `x11-misc/picom:9999` without issues and with my config.
> You can find my picom config [here](../extras/picom/picom.conf)

Now you have to install some fonts.

- [Roboto](https://fonts.google.com/specimen/Roboto)
- [Material Symbols](https://downgit.evecalm.com/#/home?url=https://github.com/google/material-design-icons/tree/1ea21d5429750938f4a8e694e75a54fc0f02dae1/variablefont)

> Note that material symbols has a [specifically tested commit](https://github.com/google/material-design-icons/tree/eaf90d6b1d40c25a388cbb30fbb5466197570bf4/variablefont), which is the one i use, keep in mind that updating it may end with awesomewm displaying weird symbols. Download the variablefont folder contents and put the ttf files on ~/.local/share/fonts

```sh
# assumming fonts are in ~/Downloads

cd ~/Downloads

sudo pacman -S unzip --noconfirm # ofc

unzip variablefont.zip
unzip Roboto.zip

mkdir -pv ~/.local/share/fonts

mv -v ./*.ttf ~/.local/share/fonts
mv -v ./variablefont/*.{ttf,woff2} ~/.local/share/fonts

fc-cache -vf
```

6. Run awesomewm

You may wanna use something like lightdm, or sddm, that's your choice.
Here, we're assumming you'd wanna use something like `startx` instead,
that's why we did install xorg-xinit before. So you can do

```sh
startx
```

And you should start seeing awesomewm running.

## What's next?

Welp, documentation is still not ready nor done whatsoever, so
you may have to explore through configuration files if you want!

Anyways check out:

- `~/.config/fancy/user-likes.json`
- `~/.config/fancy/general-behavior.json`
- `~/.config/fancy/autostart.json`

> Those are the actual configuration files of aether shell

Generated cache will be saved at `~/.cache/fancy`, nothing
to mess with there...

> Keep in mind that configuration files structure may change with the time though.
