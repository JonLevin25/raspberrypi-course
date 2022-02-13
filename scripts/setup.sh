#!/bin/bash

# TODO List
# TODO1 - fix the systemctl networking restart
# TODO2 - create if statements to catch situations where there is no internet
# TODO3 - wpa-passphrase is not taking input correctly 


# created necessary information for wifi connection
echo -e "> \e[32m What is the Wifi Network name? (SSID)_\e[0m"
read $ssid
echo -e "> \e[32m What is the Wifi Password? (text will not show on screen)_\e[0m"
read -s $password
wpa_passphrase $ssid $password >> /etc/wpa_supplicant/wpa_supplicant.conf # TODO3

# makes changes to /etc/network/interfaces to allow the wifi to work
echo -e "> \e[31m Appending necessary changes to /etc/network/interfaces\e[0m"
echo -e "# interfaces(5) file used by ifup(8) and ifdown(8)\n# include files from /etc/network/interfaces.d:\nsource /etc/network/interfaces.d/*" > /etc/network/interfaces
echo -e "auto wlan0\nallow-hotplug wlan0\niface wlan0 inet manual\nwpa-conf /etc/wpa_supplicant/wpa_supplicant.conf" >> /etc/network/interfaces

# restarts the networking
echo -e "> \e[31m Restarting networking_\e[0m"
sudo systemctl restart networking # TODO1
echo -e "> \e[31m Networking restarted_\e[0m"
# waits a few seconds 
sleep 5
# Tests connectivity
echo -e "> \e[31m Testing internet connectivity_\e[0m"
ping www.google.com -c 4
echo -e "> \e[31m Internet connectivity succesful_\e[0m" # TODO2

# Updates and upgrades OS
echo -e "> \e[31m Updating software packages_\e[0m"
sudo apt update
echo -e "> \e[31m Upgrading software packages_\e[0m"
sudo apt upgrade -y

# Getting critical software
echo -e "> \e[31m Installing TLDR_\e[0m"
sudo apt install tldr -y
echo -e "> \e[31m TLDR installed. Upgrading TLDR_\e[0m"
tldr -u
echo -e "> \e[31m Installing Vim_\e[0m"
sudo apt install vim -y
echo -e "> \e[31m Vim Installed_\e[0m"
sleep 1
echo -e "> \e[31m Setup complete_\e[0m"
