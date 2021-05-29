#!/bin/sh

#create user
echo "Create a new user:"
read user
useradd -m -s /bin/zsh $user
echo "Set user password:"
passwd $user
usermod -aG wheel $user

timedatectl set-ntp true
hwclock --systohc
pacman -Syy
reflector --country Brazil --counrty Chile --latest 6 --sort rate --download-timeout 60 --save /etc/pacman.d/mirrorlist

#sudoers
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#pacman config
sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
#add custom repos

#set environment variable for zsh
echo "export ZDOTDIR=$HOME/.config/zsh" >> /etc/zsh/zshenv

#install pkgs
echo "Install basic pkgs:"
pacman -S cifs-utils cups dosfstools mtools nfs-utils tlp
echo "Install silly pkgs:"
pacman -S cmatrix cowsay figlet lolcat neofetch sl
echo "Install utilities pkgs:"
pacman -S bat ffmpeg ffmpegthumbnailer fzf htop iperf3 ripgrep speedtest-cli tree youtube-dl
echo "Install terminal pkgs:"
pacman -S beets cmus newsboat noto-fonts pulsemixer spotifyd ttf-nerd-fonts-symbols-mono
echo "Install graphical pkgs:"
pacman -S firefox pcmanfm rofi scrot syncthing xorg-server xorg-apps xorg-init
echo "Install bspwm pkgs:"
pacman -S arc-gtk-theme arc-icon-theme bspwm lxappearance picom sxhkd
#install yay and aur pkgs
