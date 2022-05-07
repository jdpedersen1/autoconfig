# autoconfig
Script that will automatically install and configure versions of my system setup with different window managers. Contains all basic necessary programs to get system up and working.
There are a few dependencies, but the script will check if they are installed, if they are, great!, if they are not on your system, it will install them for
you. This was designed to do all the work for you, all you have to do is make a couple of selections, sit back, watch, and input password when prompted.

# Distros included
As of right now, this script is available for use on Void linux glibc (have not tried musl), and on Arch based distros. In the future it will be extended to include Debian as well.

# Window Managers
This script only includes two window managers at this time, Herbstluftwm and BerryWM. In the future I plan to add more so keep an eye out.

# Important Keybindings
#### Mod Key
the mod key is the alt key
#### Launch a teminal
mod + shift + return Launch Kitty (script installs kitty and call it from config, will need to edit config if you wish to call different terminal)
#### Launch Program Launcher
mod + shift + d (this launches my fzf program launcher if installing Herbstluftwm, and launches Dmenu if installing BerryWM)
#### Launch Logout Menu
mod + shift + c 
#### Close Active Window
mod + shift + q

# Clean up notes

### This will install Kitty terminal emulator, dmenu, devour, xdotool, polybar, sxhkd, xwallpaper, nitrogen, fzf, and font-awesome. If you do not want those installed, then you can comment out the programs_install function in the select statement of the script but this will break the config and you will have to edit heavily to get to work on your system which defeats the purpose of the script so i advise against it, if you do not want those programs installed, maybe this script is not for you.
### If you decide to run this script multiple times and you successfully installed dmenu via the script the first time, you have to decline dmenu on any future installs because the script will fail due to dmenu already present in the location that the script is attempting to install it. 
After intsall plesase reboot system, I have run into a few issues with display resolution looking funky if not rebooing before logging into new window
manager. Also I attempted to take into account every scenario that I possibly could, however; I can not account for every individuals system or setup, so I
cannot guarantee this will work on your system. I tested on multiple VMs and on hardware on ArcoLinux, Artix linux, and Void glibc, not musl, and aside from
the aformentioned resolution issues, everything worked as it should. 

#### Polybar config
You will most likely need to edit the polybar config modules to suit your system, I have incluede a package update module in the config that I have verified 
works correctly on Void and Arch, however; audio, wifi, and ethernet may be ok or they may not read at all until you correct the module for your system.
