#!/bin/sh

#install pkgs
echo "Install basic pkgs:"
sudo pacman -S --noconfirm cifs-utils cups dosfstools mtools nfs-utils tlp
echo "Install silly pkgs:"
sudo pacman -S --noconfirm cmatrix cowsay figlet lolcat neofetch sl
echo "Install utilities pkgs:"
sudo pacman -S --noconfirm bat ffmpeg ffmpegthumbnailer fzf htop iperf3 ripgrep speedtest-cli tree youtube-dl
echo "Install terminal pkgs:"
sudo pacman -S --noconfirm beets cmus newsboat noto-fonts pulsemixer spotifyd ttf-nerd-fonts-symbols-mono kitty feh sxiv
echo "Install graphical pkgs:"
sudo pacman -S --noconfirm firefox pcmanfm rofi scrot syncthing xorg-server xorg-apps xorg-xinit
echo "Install bspwm pkgs:"
sudo pacman -S --noconfirm arc-gtk-theme arc-icon-theme bspwm lxappearance picom sxhkd

#clone dotfiles
mkdir -p $HOME/.repos/dotfiles
/arch-install/git-clone-dotfiles.sh

#install yay and aur pkgs
mkdir $HOME/.repos/yay
git clone https://aur.archlinux.org/yay.git $HOME/.repos/yay
cd $HOME/.repos/yay
makepkg -si 
yay -S gotop clyrics tmsu-bin boxes zsh-theme-powerlevel10k-git ttf-vista-fonts polybar

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

#add sym links
