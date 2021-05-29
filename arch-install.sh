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
