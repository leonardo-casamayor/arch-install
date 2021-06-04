#!/bin/sh

#run this script this after formating and mounting partitions

#####Install stage#####
timedatectl set-ntp true
pacman -Syy
reflector --country Brazil --counrty Chile --latest 6 --sort rate --download-timeout 60 --save /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware vim git intel-ucode efibootmgr grub networkmanager zsh

#####Configuration stage#####
#generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
#copy scripts to use later
mkdir /mnt/arch-install
cp /root/arch-install/* /mnt/arch-install
#enter chroot environment
arch-chroot /mnt ./arch-install/config.sh

#finish
umount -R /mnt
#reboot
