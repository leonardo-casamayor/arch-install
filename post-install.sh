#!/bin/sh

#####Clone repos#####
#dotfiles
mkdir -p $HOME/.repos/dotfiles
git clone --bare https://gitlab.com/leonardo.casamayor/dotfiles.git $HOME/.repos/dotfiles
function gdf (){
   /usr/bin/git --git-dir=$HOME/.repos/dotfiles --work-tree=$HOME $@
}
gdf checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    mkdir $HOME/config-backup
    echo "Backing up pre-existing dot files.";
    gdf checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $HOME/config-backup/{}
fi;
gdf checkout
gdf config status.showUntrackedFiles no
#clone wallpapers repo
mkdir $HOME/.repos/wallpapers
git clone https://gitlab.com/leonardo.casamayor/wallpapers.git $HOME/.repos/wallpapers
#install yay and aur pkgs
mkdir $HOME/.repos/yay
git clone https://aur.archlinux.org/yay.git $HOME/.repos/yay
cd $HOME/.repos/yay
makepkg -si 
yay -S zsh-theme-powerlevel10k-git polybar
#yay -S gotop clyrics tmsu-bin boxes ttf-vista-fonts
#gnome extensions
#yay gnome-shell-extension-arch-update gnome-shell-extension-pop-shell gnome-shell-extension-sound-output-device-chooser gnome-shell-extensionespresso-git 

#####Enable user services#####
#user services
systemctl --user enable --now syncthing

#systemctl enable reflector.timer
#systemctl enable firewalld
#systemctl enable avahi-daemon

#add sym links
