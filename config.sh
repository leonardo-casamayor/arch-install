#!/bin/sh

#####Installation config#####
#set timezone
ln -sf /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime
#sync hardware clock
hwclock --systohc
#set locale
echo "#Locale enabled by arch install script" >> /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
#virtual console keyboard layout
localectl set-keymap --no-convert us
#set X keymap
localectl set-x11-keymap us
#network
echo "Set your host name:"
read host
echo "$host" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1   localhost" >> /etc/hosts
echo "127.0.1.1 $host.localdomain $host" >> /etc/hosts
#initramfs (for encyption only)
#grub
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg


#####Install extra packages#####
echo "Install basic pkgs:"
pacman -S --noconfirm man-db man-pages pacman-contrib polkit polkit-gnome xdg-utils zsh-completions zsh-syntax-highlighting cifs-utils cups hplip dosfstools mtools nfs-utils tlp
echo "Install network pkgs:"
pacman -S --noconfirm network-manager-applet reflector sshfs rsync wpa_supplicant
echo "Install audio pkgs:"
pacman -S --noconfirm alsa-utils pipewire pipewire-alsa pipewire-pulse
echo "Install silly pkgs:"
sudo pacman -S --noconfirm cmatrix cowsay figlet lolcat neofetch sl
echo "Install utilities pkgs:"
sudo pacman -S --noconfirm bat ffmpeg ffmpegthumbnailer fzf htop iperf3 ripgrep speedtest-cli tree youtube-dl
echo "Install terminal pkgs:"
sudo pacman -S --noconfirm beets cmus newsboat noto-fonts pulsemixer spotifyd ttf-nerd-fonts-symbols-mono kitty feh sxiv
echo "Install graphical pkgs:"
sudo pacman -S --noconfirm firefox pcmanfm rofi scrot syncthing xorg-server xorg-apps xorg-xinit
echo "Install bspwm pkgs:"
sudo pacman -S --noconfirm arc-gtk-theme arc-icon-theme bspwm lxappearance picom sxhkd
#echo "Install gnome pkgs:"
#sudo pacman -S --noconfirm gnome gnome-tweaks gnome-shell-extension-appindicator
#echo "Install fonts pkgs:"
#meslo hack source-code-pro



#####Create user#####
echo "Create a new user:"
read user
useradd -m -s /bin/zsh $user
echo "Set user password:"
passwd $user
usermod -aG wheel $user
echo "Set your root password:"
passwd

#make the user the owner of the destop environment install scripts
chmod $user:$user /arch-install/bspwm.sh

#####Basic config#####
#set ntp
timedatectl set-ntp true
#pacman config
reflector --country Brazil --counrty Chile --latest 6 --sort rate --download-timeout 60 --save /etc/pa
pacman -Syy
sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
sed -i "s/^#Color$/Color/" /etc/pacman.conf
#add pacman custom repos
#sudoers
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
#set environment variable for zsh
echo "export ZDOTDIR=\$HOME/.config/zsh" >> /etc/zsh/zshenv

#####Enable systemd services#####
systemctl enable NetworkManager
systemctl enable cups
systemctl enable tlp
