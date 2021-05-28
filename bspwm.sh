#!/bin/sh

#create user
useradd -m -s /bin/zsh leonardo
echo "set user password (you only get one shot):"
read pass
echo leonardo:$pass | chpasswd
usermod -aG wheel leonardo

timedatectl set-ntp true
hwclock --systohc
reflector --country Brazil --counrty Chile --latest 6 --sort rate --download-timeout 60 --save /etc/pacman.d/mirrorlist
pacman -Syy

#sudoers
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#pacman config
sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
#add custom repos

#set environment variable for zsh
echo "export ZDOTDIR=$HOME/.config/zsh" >> /etc/zsh/zshenv

#install pkgs
pacman -S --needes --noconfirm < pkglist-silly.txt
pacman -S --needes --noconfirm < pkglist-utilities.txt
pacman -S --needes --noconfirm < pkglist-terminal.txt
pacman -S --needes --noconfirm < pkglist-graphical.txt
pacman -S --needes --noconfirm < pkglist-bspwm.txt
#install yay and aur pkgs
