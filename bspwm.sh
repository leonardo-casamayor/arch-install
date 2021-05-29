#!/bin/sh

#install pkgs
echo "Install basic pkgs:"
pacman -S cifs-utils cups dosfstools mtools nfs-utils tlp
echo "Install silly pkgs:"
pacman -S cmatrix cowsay figlet lolcat neofetch sl
echo "Install utilities pkgs:"
pacman -S bat ffmpeg ffmpegthumbnailer fzf htop iperf3 ripgrep speedtest-cli tree youtube-dl
echo "Install terminal pkgs:"
pacman -S beets cmus newsboat noto-fonts pulsemixer spotifyd ttf-nerd-fonts-symbols-mono kitty feh sxiv
echo "Install graphical pkgs:"
pacman -S firefox pcmanfm rofi scrot syncthing xorg-server xorg-apps xorg-xinit
echo "Install bspwm pkgs:"
pacman -S arc-gtk-theme arc-icon-theme bspwm lxappearance picom sxhkd

#clone dotfiles
mkdir -p $HOME/.repos/dotfiles
/arch-install/git-clone-dotfiles.sh

#install yay and aur pkgs
mkdir $HOME/.repos/yay
git clone https://aur.archlinux.org/yay.git /.repos/yay
cd $HOME/.repos/yay
makepkg -si 
yay -S gotop clyrics tmsu-bin boxes zsh-theme-powerlevel10k-git ttf-vista-fonts

#clone wallpapers repo
mkdir $HOME/.repos/wallpapers
git clone https://gitlab.com/leonardo.casamayor/wallpapers.git $HOME/.repos/wallpapers

#enable system services
systemctl enable --now cups
systemctl enable --now tlp
#enable user services
systemctl --user enable --now syncthing

#systemctl enable reflector.timer
#systemctl enable firewalld
#systemctl enable avahi-daemon
