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

#copy scripts to use later and then chroot to finish installation
mkdir /mnt/arch-install
cp /arch-install/* /mnt/arch-install
arch-chroot /mnt ./arch-install/config.sh

#finish
umount -R /mnt
#reboot
