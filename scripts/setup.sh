#!/bin/bash

    # Variables
SECONDS=0
upgrade="FALSE"
wifi_reset="FALSE"
pwd_length=""

    # echo -e "\e[31m>  \e[32m\e[31m_\e[0m"
    # This script is used to setup the environment for the project.
    # Make sure to run it as root
    # sudo su ./path/to/this/script.sh
    
echo -e "\e[31m>  \e[32mIs an apt upgrade necessary? (\e[36my\e[32m)es/(\e[36mn\e[32m)o\e[31m_\e[0m"
echo -e "\e[31m>  \e[32mIt is reccomended for a first time setup\e[31m_\e[0m"
read upgrade_decision
if [ $upgrade_decision = y ] ; then
    upgrade="TRUE"
else
    echo -e "\e[31m>  \e[32mNo upgrade will be done, just an update of software sources\e[31m_\e[0m"
    sleep 2
fi
    
    # gather necessary information for wifi connection
echo -e "\e[31m>  \e[32mDo you need to add a wifi connection? (\e[36my\e[32m)es/(\e[36mn\e[32m)o\e[31m_\e[0m"
read wifi_add
if [ $wifi_add = y ]; then
    pwd_length=${#password}
    wifi_reset="TRUE"
    while [ $pwd_length -lt 8 ] ;
    do
        echo -e "\e[31m>  \e[32mWhat is the Wifi Network name? (SSID)\e[31m_\e[0m"
        read ssid
        echo -e "\e[31m>  \e[32mWhat is the Wifi Password? (8-23 characters, input text will not show)\e[31m_\e[0m"
        read -s password
        pwd_length=${#password}
        if [ $pwd_length -lt 8 ]; then
            echo -e "\e[31m>  \e[32mIncorrect password length. Please try again\e[31m_\e[0m"
        fi
    done
    sudo sh -c "wpa_passphrase $ssid $password >> /etc/wpa_supplicant/wpa_supplicant.conf"
    echo -e "\e[31m>  \e[32mWPA done\e[31m_\e[0m"
else
    echo -e "\e[31m>  \e[32mNo wifi added, WPA supplicant unchanged and no network restarts planned\e[31m_\e[0m"
    
fi
if [ $wifi_reset = TRUE ]; then
    # makes changes to /etc/network/interfaces to allow the wifi to work
echo -e "\e[31m>  \e[32mAppending wifi details to /etc/network/interfaces\e[31m_\e[0m"
echo -e "# interfaces(5) file used by ifup(8) and ifdown(8)\n# include files from /etc/network/interfaces.d:\nsource /etc/network/interfaces.d/*" > /etc/network/interfaces
echo -e "auto wlan0\nallow-hotplug wlan0\niface wlan0 inet manual\nwpa-conf /etc/wpa_supplicant/wpa_supplicant.conf" >> /etc/network/interfaces

    # restarts the networking. 
    # If you are having issues with connecting to wifi after this, clear the network section(s) of wap_supplicant.conf
echo -e "\e[31m>  \e[32mRestarting networking\e[31m_\e[0m"
sudo systemctl restart networking.service
echo -e "\e[31m>  \e[32mNetworking restarted. Please wait 15 seconds\e[31m_\e[0m"
sleep 15
    
    # Tests connectivity - need to add some checks to this
echo -e "\e[31m>  \e[32mTesting internet connectivity\e[31m_\e[0m"
ping www.google.com -c 4
echo -e "\e[31m>  \e[32mInternet connectivity successful\e[31m_\e[0m"
fi
    # Updates and upgrades OS
echo -e "\e[31m>  \e[32mUpdating software sources\e[31m_\e[0m"
sudo apt update
if [ upgrade="TRUE" ]
then
    echo -e "\e[31m>  \e[32mUpgrading software packages. Please be patient\e[31m_\e[0m"
    sudo apt upgrade -y
    echo -e "\e[31m>  \e[32mUpgrade Complete, YAY :D\e[31m_\e[0m"
else
    echo -e "\e[31m>  \e[32mNo Upgrade done at this time. Now installing software\e[31m_\e[0m"
fi

    # Installing crucial software
echo -e "\e[31m>  \e[32mThe next steps will install TLDR, get VIm and clone the repo\e[31m_\e[0m"
sleep 2
echo -e "\e[31m>  \e[32mInstalling TLDR\e[31m_\e[0m"
sudo apt install tldr -y
echo -e "\e[31m>  \e[32mTLDR installed\e[31m_\e[0m"
mkdir -p /home/$SUDO_USER/.local/share
chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.local/
sleep 2
echo -e "\e[31m>  \e[32mInstalling Vim\e[31m_\e[0m"
sudo apt install vim -y
echo -e "\e[31m>  \e[32mVim Installed\e[31m_\e[0m"
sleep 2
echo -e "\e[31m>  \e[32mNavigating to home Directory\e[31m_\e[0m"
cd ~
echo -e "\e[31m>  \e[32mDownloading Course repo\e[31m_\e[0m"
git clone https://github.com/444B/raspberrypi-course.git

    # Full setup finished
echo ""
echo -e "\e[31m>  \e[36mFull setup complete! Have fun!\e[31m_\e[0m"
echo ""
echo -e "\e[31m>  \e[32mHere are some resources of what can be done next\e[31m_\e[0m"
echo -e "\e[31m>  \e[32m444B Raspberry Pi Course: \e[0mhttps://github.com/444B/raspberrypi-course\e[0m \e[31m_\e[0m"
echo -e "\e[31m>  \e[32mCrash Course Computer Science: \e[0mhttps://www.youtube.com/watch?v=tpIctyqH29Q&list=PL8dPuuaLjXtNlUrzyH5r6jN9ulIgZBpdo\e[0m \e[31m_\e[0m"
echo -e "\e[31m>  \e[32mThe Linux Command Line PDF: \e[0mhttps://sourceforge.net/projects/linuxcommand/files/TLCL/19.01/TLCL-19.01.pdf/download\e[0m \e[31m_\e[0m"
echo ""
echo ""
echo -e "\e[31m>  \e[32mIt is reccommended to run the following commands after running a full setup\e[31m_\e[0m"
echo ""
echo -e "\e[31m>  \e[0mtldr --update \e[32m<--This take a 1 minute to update TLDR pages\e[31m_\e[0m"
echo -e "\e[31m>  \e[0mreboot \e[32m<--This takes 2 minutes to get back to login screen\e[31m_\e[0m"
echo ""
duration=$SECONDS
echo "It took $(($duration / 60)) minutes and $(($duration % 60)) seconds for setup.sh to complete."


