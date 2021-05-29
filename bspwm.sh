#!/bin/sh

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
mkdir -p .repos/dotfiles

#enable system services
systemctl enable NetworkManager
systemctl enable cups
systemctl enable tlp
#systemctl enable reflector.timer
#systemctl enable firewalld
#systemctl enable avahi-daemon
