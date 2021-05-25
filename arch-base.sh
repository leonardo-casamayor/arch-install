#!/bin/sh

#run this script this after formating and mounting partitions

#install stage

timedatectl set-ntp true
reflector --country Brazil --counrty Chile --latest 6 --sort rate --download-timeout 60 --save /etc/pacman.d/mirrorlist
pacman -Syy
pacstrap /mnt base linux linux-firmware vim intel-ucode

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
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1   localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
#initramfs (for encyption only)
#set root passwd
passwd
#pacman
pacman -S --needed --noconfirm < pkglist-base.txt
#grub
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
#enable system services
systemctl enable NetworkManager
systemctl enable cups
systemctl enable tlp
#systemctl enable reflector.timer
#systemctl enable firewalld

#finish
exit
umount -a
#reboot
