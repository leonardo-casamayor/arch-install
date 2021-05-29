#!/bin/sh

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
echo "KEYMAP=us" >> /ect/vconsole.conf
#network
echo "Set your host name:"
read host
echo "$host" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1   localhost" >> /etc/hosts
echo "127.0.1.1 $host.localdomain $host" >> /etc/hosts
#initramfs (for encyption only)
#set root passwd
echo "Set your root password:"
passwd
#pacman
echo "Install basic pkgs:"
pacman -S efibootmgr grub man-db man-pages pacman-contrib xdg-utils xdg-user-dirs zsh zsh-completions zsh-syntax-highlighting
echo "Install network pkgs:"
pacman -S networkmanager network-manager-applet reflector sshfs rsync wpa_supplicant
echo "Install audio pkgs:"
pacman -S alsa-utils pipewire pipewire-alsa pipewire-pulse

#grub
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

#create user
echo "Create a new user:"
read user
useradd -m -s /bin/zsh $user
echo "Set user password:"
passwd $user
usermod -aG wheel $user

#set ntp
timedatectl set-ntp true
#pacman config
reflector --country Brazil --counrty Chile --latest 6 --sort rate --download-timeout 60 --save /etc/pa
pacman -Syy
sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
#add custom repos

#sudoers
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#set environment variable for zsh
echo "export ZDOTDIR=\$HOME/.config/zsh" >> /etc/zsh/zshenv

#enable NetworkManager
systemctl enable NetworkManager

#finish
exit
umount -R /mnt
#reboot
