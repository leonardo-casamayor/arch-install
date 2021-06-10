#!/bin/sh

#run this script this after formating and mounting partitions

#####Define variables#####
user="leonardo"
userpass=""
rootpass=""
hostname="azb-ext"
timezone="America/Argentina/Buenos_Aires"
locale="en_US.UTF-8 UTF-8"
lang="en_US.UTF-8"
vconsolekeymap="us"
usershell="zsh"
pkglistURL="https://gitlab.com/leonardo.casamayor/dotfiles/-/raw/master/.config/pkglists/pkgs.txt"
aurpkglistURL="https://gitlab.com/leonardo.casamayor/dotfiles/-/raw/master/.config/pkglists/aur.txt"
#repos
aurhelper="yay"
aurhelperURL="https://aur.archlinux.org/yay.git"
dotfiles="https://gitlab.com/leonardo.casamayor/dotfiles.git"
wallpapers="https://gitlab.com/leonardo.casamayor/wallpapers.git"
#systemctl service to enable
userservices=(syncthing)
services=(NetworkManager cups tlp)

#####Copy variables to files#####
#copy config variables
configFile="/mnt/config.sh"
echo "#!/bin/sh" > $configFile
echo "user=\"$user\"" >> $configFile
echo "userpass=\"$userpass\"" >> $configFile
echo "rootpass=\"$rootpass\"" >> $configFile
echo "hostname=\"$hostname\"" >> $configFile
echo "timezone=\"$timezone\"" >> $configFile
echo "locale=\"$locale\"" >> $configFile
echo "lang=\"$lang\"" >> $configFile
echo "vconsolekeymap=\"$vconsolekeymap\"" >> $configFile
echo "usershell=\"$usershell\"" >> $configFile
echo "pkglistURL=\"$pkglistURL\"" >> $configFile
echo "services=(${services[@]})" >> $configFile
chmod +x $configFile
#copy post install variables
userFile="/mnt/userFile.sh"
echo "#!/bin/sh" > $userFile
echo "dotfiles=\"$dotfiles\"" >> $userFile
echo "aurhelper=\"$aurhelper\"" >> $userFile
echo "aurhelperURL=\"$aurhelperURL\"" >> $userFile
echo "wallpapers=\"$wallpapers\"" >> $userFile
echo "aurpkglistURL=\"$aurpkglistURL\"" >> $userFile
echo "userservices=(${userservices[@]})" >> $userFile
chmod +x $userFile

#####Install stage#####
timedatectl set-ntp true
pacman -Syy
reflector --country Brazil --counrty Chile --latest 6 --sort rate --download-timeout 60 --save /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware vim git intel-ucode efibootmgr grub networkmanager

#####Configuration stage#####
#generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
#enter chroot environment
arch-chroot /mnt sh - << 'EOCHROOT'

	#source variables
	source /config.sh
	#remove file
	rm /config.sh
	
	#####Installation config#####
	#set timezone
	ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
	#sync hardware clock
	hwclock --systohc
	#set locale
	echo "#Locale enabled by arch install script" >> /etc/locale.gen
	echo "$locale" >> /etc/locale.gen
	locale-gen
	echo "LANG=$lang" >> /etc/locale.conf
	#network
	echo "$hostname" >> /etc/hostname
	echo "127.0.0.1 localhost" >> /etc/hosts
	echo "::1   localhost" >> /etc/hosts
	echo "127.0.1.1 $hostname.localdomain $hostname" >> /etc/hosts
	#initramfs (for encyption only)
	#grub
	grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
	grub-mkconfig -o /boot/grub/grub.cfg
	
	#####Install extra packages#####
	pkgFile="/pkglist.txt"
	#download pkglist
	curl -L -o $pkgFile $pkglistURL
	#remove comments
	sed -i '/^#.*/d' $pkgFile
	#install pkgs with pacman
	while read pkg
	    do
	        pacman --needed --noconfirm -S $pkg
	    done < $pkgFile
	
	rm $pkgFile
	
	#####Basic config#####
	#set ntp
	timedatectl set-ntp true
	#virtual console keymap
	localectl set-keymap --no-convert $vconsolekeymap
	#pacman config
	reflector --country Brazil --counrty Chile --latest 6 --sort rate --download-timeout 60 --save /etc/pa
	pacman -Syy
	sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
	sed -i "s/^#Color$/Color/" /etc/pacman.conf
	#add pacman custom repos
	#sudoers
	echo "Defaults insults" >> /etc/sudoers.d/01-Insults
	echo "$user $hostname=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/02-Nopasswd
	#zsh setup
	if [ $usershell = "zsh" ]; then
	#install zsh
	    pacman --noconfirm --needed -S zsh zsh-completions zsh-syntax-highlighting
	#set environment variable for zsh
	    echo "export ZDOTDIR=\$HOME/.config/zsh" >> /etc/zsh/zshenv
	fi;
	
	#####Create user#####
	useradd -m -s /bin/$usershell $user
	echo "$user:$userpass" | chpasswd
	usermod -aG wheel $user
	echo "root:$rootpass" | chpasswd
	
	#make the user the owner of the post install variables file
	chown $user:$user /userFile.sh
	
	#####Enable systemd services#####
	for service in "${services[@]}"
	    do
	        systemctl enable $service
	    done
	
	#####Run script as created user####
	su $user sh -c '
	
	#source variables
	user="$(whoami)"
	source /userFile.sh
	#remove file
	sudo rm /userFile.sh
	
	#####Clone repos#####
	#dotfiles
	mkdir -p $HOME/.repos/dotfiles
	git clone --bare $dotfiles $HOME/.repos/dotfiles
	function gdf (){
	   /usr/bin/git --git-dir=$HOME/.repos/dotfiles --work-tree=$HOME $@
	}
	gdf checkout
	gdf config status.showUntrackedFiles no
	#clone wallpapers repo
	mkdir $HOME/.repos/wallpapers
	git clone $wallpapers $HOME/.repos/wallpapers
	#install yay
	mkdir $HOME/.repos/$aurhelper
	git clone $aurhelperURL $HOME/.repos/$aurhelper
	cd $HOME/.repos/$aurhelper
	makepkg -si --noconfirm
	
	#####Install aur packages#####
	aurFile="$HOME/aurlist.txt"
	#download pkglist
	curl -L -o $aurFile $aurpkglistURL
	#remove comments
	sed -i '/^#.*/d' $aurFile
	#install pkgs with aur helper
	while read pkg
	    do
	        $aurhelper --needed --noconfirm -S $pkg
	    done < $aurFile
	
	rm $aurFile
	
	#####Enable user services#####
	for service in "${userservices[@]}"
	    do
	        systemctl --user enable $service
	    done

'

EOCHROOT

#finish
umount -R /mnt
reboot
