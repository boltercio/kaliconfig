#!/usr/bin/bash

# Author: Juan Antonio de Tena (aka Boltercio)

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Global variables
dir=$(pwd)
fdir="$HOME/.local/share/fonts"
user=$(whoami)

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n\n${redColour}[!] Exiting...\n${endColour}"
	exit 1
}

if [ "$user" == "root" ]; then
	echo -e "\n\n${redColour}[!] You should not run the script as the root user!\n${endColour}"
    	exit 1
else
	sleep 1
	echo -e "\n\n${blueColour}[*] Installing necessary packages for the environment...\n${endColour}"
	sleep 2
	sudo apt install -y curl kitty htop tty-clock fzf lsd bat
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${redColour}[-] Failed to install some packages!\n${endColour}"
		exit 1
	else
		echo -e "\n${greenColour}[+] Done\n${endColour}"
		sleep 1.5
	fi

	echo -e "\n${blueColour}[*] Starting installation of the tools...\n${endColour}"
	sleep 0.5
	mkdir ~/tools && cd ~/tools

	echo -e "\n${purpleColour}[*] Installing Oh My Zsh and Powerlevel10k for user $user...\n${endColour}"
	sleep 2
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${redColour}[-] Failed to install Oh My Zsh and Powerlevel10k for user $user!\n${endColour}"
		exit 1
	else
		echo -e "\n${greenColour}[+] Done\n${endColour}"
		sleep 1.5
	fi

	echo -e "\n${purpleColour}[*] Installing Oh My Zsh and Powerlevel10k for user root...\n${endColour}"
	sleep 2
	sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k
	if [ $? != 0 ] && [ $? != 130 ]; then
		echo -e "\n${redColour}[-] Failed to install Oh My Zsh and Powerlevel10k for user root!\n${endColour}"
		exit 1
	else
		echo -e "\n${greenColour}[+] Done\n${endColour}"
		sleep 1.5
	fi

	echo -e "\n${blueColour}[*] Starting configuration of fonts, wallpaper, configuration files, .zshrc, .p10k.zsh, and scripts...\n${endColour}"
	sleep 0.5

	echo -e "\n${purpleColour}[*] Configuring fonts...\n${endColour}"
	sleep 2
	if [[ -d "$fdir" ]]; then
		cp -rv $dir/fonts/* $fdir
	else
		mkdir -p $fdir
		cp -rv $dir/fonts/* $fdir
	fi
	echo -e "\n${greenColour}[+] Done\n${endColour}"
	sleep 1.5

	echo -e "\n${purpleColour}[*] Configuring configuration files...\n${endColour}"
	sleep 2
	cp -rv $dir/config/* ~/.config/
	echo -e "\n${greenColour}[+] Done\n${endColour}"
	sleep 1.5

	echo -e "\n${purpleColour}[*] Configuring the .zshrc and .p10k.zsh files...\n${endColour}"
	sleep 2
	cp -v $dir/zshrc ~/.zshrc
	sudo ln -sfv ~/.zshrc /root/.zshrc
	cp -v $dir/.p10k.zsh ~/.p10k.zsh
	sudo ln -sfv ~/p10k.zsh /root/.p10k.zsh
	echo -e "\n${greenColour}[+] Done\n${endColour}"
	sleep 1.5

	echo -e "\n${purpleColour}[+] Changing wallpaper...\n${endColour}"
	sleep 2
	cp -v $dir/walpaper/wallpaper.jpg ~/Imágenes/wallpaper.jpg
	gsettings set org.gnome.desktop.background picture-uri "file://~/Imágenes/wallpaper.jpg"
	echo -e "\n${purpleColour}[+] Done\n${endColour}"
	sleep 1.5

	echo -e "\n${purpleColour}[*] Removing tools directory...\n${endColour}"
	sleep 2
	rm -rfv ~/tools
	11echo -e "\n${greenColour}[+] Done\n${endColour}"
	sleep 1.5

	echo -e "\n${greenColour}[+] Environment configured :D\n${endColour}"
	sleep 1.5

	while true; do
		echo -en "\n${yellowColour}[?] It's necessary to restart the system. Do you want to restart the system now? ([y]/n) ${endColour}"
		read -r
		REPLY=${REPLY:-"y"}
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			echo -e "\n\n${greenColour}[+] Restarting the system...\n${endColor}"
			sleep 1
			sudo reboot
		elif [[ $REPLY =~ ^[Nn]$ ]]; then
			exit 0
		else
			echo -e "\n${redColour}[!] Invalid response, please try again\n${endColour}"
		fi
	done
fi
