#!/usr/bin/env bash

#test#
#-------------------------#
### WINDOW MANAGER LIST ###
#-------------------------#
wms=("Herbstluftwm" "BerryWM")


#---------------------------------------------------------#
### FUNCTIONS TO DRAW DIFFERENT STYLE BOXES AROUND TEXT ###
#---------------------------------------------------------#
box() {
    title=" $1 "
    edge=$(echo "$title" | sed 's/./*/g')
    echo "$edge"
    echo -e "\e[1;31m$title\e[0m"
    echo "$edge"
}


box1() {
    title=" $1 "
    edge=$(echo "$title" | sed 's/./*/g')
    echo "$edge"
    echo -e "\e[1;31m$title\e[0m"
}


box2() {
    title=" $1 "
    echo -e "\e[1;31m$title\e[0m"
}


box3() {
    title=" $1 "
    edge=$(echo "$title" | sed 's/./*/g')
    echo -e "\e[1;31m$title\e[0m"
    echo "$edge"
}


#------------------------------------------------#
### CHECK THAT MAIN DEPENDENCIES ARE INSTALLED ###
#------------------------------------------------#
needed_programs() {
    if command -v git &> /dev/null && command -v wget &> /dev/null && command -v make &> /dev/null && command -v gcc &> /dev/null
    then
        box "dependencies found! Lets GO!"
    else
        for pkmgr in xbps-install pacman; do
            type -P "$pkmgr" &> /dev/null || continue
            case $pkmgr in
                xbps-install)
                    sudo xbps-install -S wget git make gcc
                    ;;
                pacman)
                    sudo pacman -S wget git make gcc
                    ;;
            esac
            return
        done 
    fi
}


#-----------------------------#
### SOURCE PKG REPO INSTALL ###
#-----------------------------#
src_pkg_repo_install() {
    box1 "Void does not have the aur, but it does use void-src repo  "
    box3 "Would you like to install and set up void-src pkg repo? Y/N"
    read -r answer
    if [[ "$answer" == [Y/y] ]]; 
    then
        box1 "Great! installing now                         "
        box3 "Please be patient while this may take a minute"
        sleep 3
        sudo xbps-install -S util-linux tar coreutils binutils
        mkdir $HOME/.local/pkgs && cd $HOME/.local/pkgs || exit
        git clone https://github.com/void-linux/void-packages.git
        cd void-packages || exit
        ./xbps-src binary-bootstrap;
    else
        box1 "No worries you can always do it later"
        box3 "Continuing with install script       "
    fi
}


#-----------------------------#
### FUNCTION TO INSTALL YAY ###
#-----------------------------#
yay_install() {
    if command -v yay &> /dev/null;
    then
        box "yay found, you are good to go"
    else
        box "To continue this script, yay will be installed into your $HOME/.local dir"
        box "Would you like to continue? Y/n"
        read -r answer2
        if [[ "$answer2" == [Y/y] ]];
        then
            sudo pacman -S base-devel
            cd $HOME/.local || exit
            sudo git clone https://aur.archlinux.org/yay-git.git
            sudo chown -R $USER/$USER ./yay-git
            cd yay-git || exit
            makepkg -si
            break
        else
            box "This script will not work without yay, sorry, exiting now"
            exit
        fi
    fi
}


#--------------------------#
### CHECK FOR .local DIR ###
#--------------------------#
dir_check() {
    box "Checking for required dir"
    if [ -d $HOME/.local ]; then
        box "Dir found, lets begin"
    else
        box "dir not found, creating now"
        mkdir $HOME/.local
    fi
}


#----------------------------------#
### FUNCTION TO INSTALL PROGRAMS ###
#----------------------------------#
programs_install() {
    for pkg in xbps-install pacman; do
        type -P "$pkg" &> /dev/null || continue
        case $pkg in
            xbps-install)
		        box "installing dependencies"
		        sudo xbps-install -S base-devel libX11-devel libXft-devel libXinerama-devel freetype-devel fontconfig-devel
                src_pkg_repo_install
                sudo xbps-install -S dmenu kitty xdotool polybar sxhkd nitrogen xwallpaper fzf font-awesome;
                cd $HOME/.local/
                git clone https://github.com/salman-abedin/devour.git && cd devour && sudo make install && cd $HOME/.local
 		        box1 "for dmenu to work correctly you need to have my config installed"
                box "HOWEVER IF YOU HAVE ALREADY RUN THIS SCRIPT AND INSTALLED MY DMENU; DO NOT TRY TO INSTALL AGAIN, THE SCRIPT WILL FAIL"
		        box2 "do you want to install my dmenu config? Y/N           "
		        read -r choice
		        if [[ "$choice" == [Y/y] ]]; then
			        git clone https://github.com/jdpedersen1/dmenu.git
       			    cd dmenu && sudo make clean install
		        else
			        box " you will need to edit all dmenu keybindings in config and scripts to match your dmenu config"
                    box "UNLESS YOU HAVE RUN THIS SCRIPT AND INSTALLED DMENU ONCE ALREADY, IF SO YOU ARE GOOD"
		        fi
                ;;
            pacman)
                yay_install
                yay -S dmenu kitty nitrogen xwallpaper xdotool polybar sxhkd ttf-font-awesome fzf devour;
 		        box1 "for dmenu to work correctly you need to have my config installed"
                box "HOWEVER IF YOU HAVE ALREADY RUN THIS SCRIPT AND INSTALLED MY DMENU; DO NOT TRY TO INSTALL AGAIN, THE SCRIPT WILL FAIL"
		        box2 "do you want to install my dmenu config? Y/N           "
		        read -r choice
		        if [[ "$choice" == [Y/y] ]]; then
			        git clone https://github.com/jdpedersen1/dmenu.git
       			    cd dmenu && sudo make clean install
		        else
			        box " you will need to edit all dmenu keybindings in config and scripts to match your dmenu config"
                    box "UNLESS YOU HAVE RUN THIS SCRIPT AND INSTALLED DMENU ONCE ALREADY, IF SO YOU ARE GOOD"
		        fi
                ;;
        esac
        return  
    done
}


#--------------------------------------#
### FUNCTION TO INSTALL HERBSTLUFTWM ###
#--------------------------------------#
install_herbst() {
    if [ -d $HOME/.config/herbstluftwm ]; then
        box "It seems Herbstluftwm is already installed, please verify and try again"
        exit
    else
        box "Installing Herbstluftwm, Hold on to your neckbeard cause HERE WE GOOOOOOOOO!!!"
        for pkg_mgr in xbps-install pacman; do
            type -P "$pkg_mgr" &> /dev/null || continue
            case $pkg_mgr in
                xbps-install)
                    sudo xbps-install -S herbstluftwm
                    ;;
                pacman)
                    sudo pacman -S herbstluftwm
                    ;;
            esac
            return
        done
    fi
} 


#---------------------------------#
### FUNCTION TO INSTALL BERRYWM ###
#---------------------------------#
install_berry() {
    if [ -d $HOME/.config/berry ]; then
        box "It seems BerryWm may already be installed, please verify and try again"
        exit
    else
        box "Installing BerryWM, Hold on to your neckbeard cause HERE WE GOOOOOOOO!!!"
        for pkg_mgr in xbps-install pacman; do
            type -P "$pkg_mgr" &> /dev/null || continue
            case $pkg_mgr in
                xbps-install)
                    sudo xbps-install -S berry
                    ;;
                pacman)
                    yay -S berry-git
                    ;;
            esac
            return
        done
    fi
}      


#-----------------------------------------------#
### FUNCTION TO FETCH CONFIG FILES FOR HERBST ###
#-----------------------------------------------#
herbst_file_fetch() {
    for pkg_mgr in xbps-install pacman; do 
        type -P "$pkg_mgr" &> /dev/null || continue
        case $pkg_mgr in
            xbps-install)
                cd $HOME/.config/
                git clone https://github.com/jdpedersen1/herbstluftwm.git
                cd $HOME/.config/herbstluftwm
                mv polybar_void_config $HOME/.config/herbstluftwm/polybar_config && rm polybar_arch_config
                chmod -R +x $HOME/.config/herbstluftwm/
                sudo mv herbst-logout.sh launch.sh scratch scratch2 scratchpad vsp2 /usr/local/bin/
                ;;
            pacman)
                cd $HOME/.config/
                git clone https://github.com/jdpedersen1/herbstluftwm.git
                cd $HOME/.config/herbstluftwm
                mv polybar_arch_config $HOME/.config/herbstluftwm/polybar_config && rm polybar_void_config
                chmod -R +x $HOME/.config/herbstluftwm/
                rm $HOME/.config/herbstluftwm/vsp2
                sudo mv herbst-logout.sh launch.sh scratch scratch2 scratchpad /usr/local/bin
                ;;
        esac
    done
}


#----------------------------------------------#
### FUNCTION TO FETCH CONFIG FILES FOR BERRY ###
#----------------------------------------------#
berry_file_fetch() {
    for pkg_mgr in xbps-install pacman; do 
        type -P "$pkg_mgr" &> /dev/null || continue
        case $pkg_mgr in
            xbps-install)
                cd $HOME/.config/
                git clone https://gitlab.com/jped/berry.git
                cd $HOME/.config/berry
                mv polybar_void_config $HOME/.config/berry/polybar_config && rm polybar_arch_config
                chmod -R +x $HOME/.config/berry/
                sudo mv berry-logout.sh vsp3 /usr/local/bin/
                ;;
            pacman)
                cd $HOME/.config/
                git clone https://gitlab.com/jped/berry.git
                cd $HOME/.config/berry
                mv polybar_arch_config $HOME/.config/berry/polybar_config && rm polybar_void_config
                chmod -R +x $HOME/.config/berry/
                sudo mv berry-logout.sh /usr/local/bin/
                rm vsp3
                ;;
        esac
    done
}


#----------------------------------------------------#
### FUNCTION TO CREATE BERRY .DESKTOP ENTRY FOR DM ###
#----------------------------------------------------#
desktop_file() {
    sudo bash -c 'cat > /usr/share/xsessions/berry.desktop << EOF
[Desktop Entry]
Encoding=UTF-8
Name=berry
Comment=berry - a small window manager
Exec=berry
Type=XSession

EOF'
}


#------------------------------------#
### FUNCTION TO PERFORM SYS UPDATE ###
#------------------------------------#
update() {
    box "Please wait while your syetem is updated"
    for pkg_mgr in xbps-install pacman; do
        type -P "$pkg_mgr" &> /dev/null || continue
        case $pkg_mgr in
            xbps-install)
                sudo xbps-install -Su
                ;;
            pacman)
                sudo pacman -Syyu
                ;;
        esac
        return
    done
}


#-----------------------#
### OPENING STATEMENT ###
#-----------------------#
opening() {
    box "                            !!!!  IMPORTANT  !!!!                                   "
    sleep 2
    box " THIS SCRIPT UTILIZES THE /home/user/.local DIR and /usr/local/bin, it will make a .local dir if not found"
    box1 " Please make sure to review the README file to see a list of the programs that     "
    box2 " this script will install on your system. Also note that it will create directories"
    box2 " if they are not present and will move files into your /usr/local/bin directory.   "
    box2 " Have you read the README and do you still want to continue?                       "
    box3 " Select Y to continue or N to exit                                                 "  
    read -r accept
    if [[ "$accept" == [Y/y] ]];
    then
        box " YAY!! Lets get started!"
    else
        box "Thats ok, thanks for checking out this script"
        exit
    fi
}

#-----------------------#
### CLOSING STATEMENT ###
#-----------------------#
closing() {
    box "                 !!!!--!!!  PLEASE READ BEFORE CONTINUING  !!!--!!!!                       "
    sleep 3
    box "                        CONGRATULATIONS ON YOUR NEW SETUP!!                                "
    box " ---IMPORTANT KEYBINDINGS!!---  "
    box1 "mod key is the alt key"
    box2 "mod+shift+return -- launch kitty"
    box2 "mod+shift+d -- run launcher"
    box2 "mod+shift+q -- close window"
    box3 "mod+shift+c -- logout menu"
    sleep 2
    box1 "I attempted to make sure to cover all scenarios, the one thing I cannot take into account "
    box2 "is each and every persons system specs or setup. While this script has been thoroughly    "
    box2 "tested on VMs and on my personal machines, you still may need to edit or tweak some of the"
    box3 "files, or keybindings to verify proper operation on your system                           " 
    sleep 3
    box1 "PLEASE REBOOT SYSTEM WHEN SCRIPT IS FINISHED, DO NOT JUST LOG OUT; I FOUND SOME INSTANCES OF"
    box2 "ISSUES ON LOWER RESOLUTION (SMALLER SCREENS) UNTIL REBOOT, SO MAKE SURE TO REBOOT BEFORE YOU"
    box3 "LOG INTO NEW WINDOW MANAGER                                                                 "
    exit
}

#-----------------------------#
### VERIFY USER IS NOT ROOT ###
#-----------------------------#
not_root() {
    if [ "$EUID" = 0 ]; then
        box "Please run script as normal user, not root"
        sleep 3
        exit
    fi
}


#--------------------------------------#
### EXIT IF ANY PART OF SCRIPT FAILS ###
#--------------------------------------#
set -eo pipefail


#---------------------#
### OPENING WARNING ###
#---------------------#
opening
dir_check
needed_programs


#-----------------------------------------------------------#
### SELECT STATEMENT TO CHOOSE AND INSTALL WINDOW MANAGER ###
#-----------------------------------------------------------#
select wm in "${wms[@]}"; do
    case "$wm" in 
        "Herbstluftwm")
            not_root
            update
            programs_install
            install_herbst
            herbst_file_fetch
            box1 "Herbst automatically creates an xsession entry"
            box2 "however; if you use startx, you need to edit  "
            box3 "your .xinitrc file on your own                "
            closing
            ;;
        "BerryWM")
            not_root
            update
            programs_install
            install_berry
            berry_file_fetch
            box1 "If you use a display manager this script is able to create an xsession entry "
            box2 "however if you use startx, you will be responsible for editing yout .xinitrc "
            box3 "Do you use a display manager? Y/N                                            "
            read -r dm
            if [[ "$dm" == [Y/y] ]]; then
                desktop_file
            fi
            closing
            ;;
    esac
done

