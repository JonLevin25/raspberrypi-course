#!/bin/bash

# TODO List
# TODO2 - create if statements to catch situations where there is no internet
# echo -e "> \e[32m _\e[32m"
echo -e "> \e[32m  This script will do the following:_\e[32m"
echo -e "> \e[32m  1. Fix the wifi adapter_\e[32m"
echo -e "> \e[32m  2. Save a login credential to a wifi router _\e[32m"
echo -e "> \e[32m  3. Update and upgrade the software_\e[32m"
echo -e "> \e[32m  4. Install TLDR and Vim_\e[32m"
read -p "> Do you want to continue? (y/N)" prompt;
if [ "$prompt" == "y" || "$prompt" == "Y" ]; then
    # gather necessary information for wifi connection
    echo -e "> \e[32m What is the Wifi Network name? (SSID)_\e[32m"
    read ssid
    echo -e "> \e[32m What is the Wifi Password? (8-23 characters, input text will not show)_\e[0m"
    read -s password
    sudo sh -c "wpa_passphrase $ssid $password >> /etc/wpa_supplicant/wpa_supplicant.conf"

    # makes changes to /etc/network/interfaces to allow the wifi to work
    echo -e "> \e[31m Appending necessary changes to /etc/network/interfaces\e[0m"
    echo -e "# interfaces(5) file used by ifup(8) and ifdown(8)\n# include files from /etc/network/interfaces.d:\nsource /etc/network/interfaces.d/*" > /etc/network/interfaces
    echo -e "auto wlan0\nallow-hotplug wlan0\niface wlan0 inet manual\nwpa-conf /etc/wpa_supplicant/wpa_supplicant.conf" >> /etc/network/interfaces

    # restarts the networking. 
    # If you are having issues with connecting to wifi after this, clear the network section(s) of wap_supplicant.conf
    echo -e "> \e[31m Restarting networking_\e[0m"
    sudo systemctl restart networking.service
    echo -e "> \e[31m Networking restarted. Please wait 10 seconds_\e[0m"
    # waits a few seconds 
    sleep 10
    # Tests connectivity
    echo -e "> \e[31m Testing internet connectivity_\e[0m"
    ping www.google.com -c 4
    echo -e "> \e[31m Internet connectivity succesful_\e[0m" # TODO2

    # Updates and upgrades OS
    echo -e "> \e[31m Updating software sources_\e[0m"
    sudo apt update
    echo -e "> \e[31m Upgrading software packages_\e[0m"
    sudo apt upgrade -y

    # Getting critical software
    echo -e "> \e[31m Installing TLDR_\e[0m"
    sudo apt install tldr -y
    echo -e "> \e[31m TLDR installed. Navigate to home directory and run 'tldr --update' before first use_\e[0m"
    echo -e "> \e[31m Navigate to home directory and run 'tldr --update' before first use_\e[0m"
    sleep 5
    echo -e "> \e[31m Installing Vim_\e[0m"
    sudo apt install vim -y
    echo -e "> \e[31m Vim Installed_\e[0m"
    sleep 1
    echo -e "> \e[31m Setup complete_\e[0m"

else
    echo -e "> \e[32m No changes made. Wifi may not work until changes are made_\e[32m"
    exit 0
fi