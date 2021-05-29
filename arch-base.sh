#!/bin/sh

#run this script this after formating and mounting partitions

#install stage

timedatectl set-ntp true
pacman -Syy
reflector --country Brazil --counrty Chile --latest 6 --sort rate --download-timeout 60 --save /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware vim git intel-ucode

#configuration stage

#generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
#chroot
arch-chroot /mnt
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
pacman -S ifebootmgr grub man-db man-pages pacman-contrib xdg-utils xdg-user-dirs zsh zsh-completions zsh-syntax-highlighting
echo "Install network pkgs:"
pacman -S networkmanager network-manager-applet reflector sshfs rsync wpa_supplicant
echo "Install audio pkgs:"
pacman -S alsa-utils pipewire pipewire-alsa pipewire-pulse

#grub
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
#enable system services
systemctl enable NetworkManager
systemctl enable cups
systemctl enable tlp
#systemctl enable reflector.timer
#systemctl enable firewalld
#systemctl enable avahi-daemon

#finish
exit
umount -a
#reboot
