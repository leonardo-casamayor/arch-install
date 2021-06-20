#!/bin/sh

#source variables
user="$(whoami)"
source /userFile.sh
#remove file
sudo rm /userFile.sh

#####Config#####
#set ntp
sudo timedatectl set-ntp true
#virtual console keymap
sudo localectl set-keymap --no-convert $vconsolekeymap

#####Clone repos#####
#dotfiles
mkdir -p $HOME/.repos/dotfiles
git clone --bare $dotfiles $HOME/.repos/dotfiles
function gdf (){
   /usr/bin/git --git-dir=$HOME/.repos/dotfiles --work-tree=$HOME $@
}
gdf checkout
gdf config status.showUntrackedFiles no
#clone wallpapers repo
mkdir $HOME/.repos/wallpapers
git clone $wallpapers $HOME/.repos/wallpapers
#install yay
mkdir $HOME/.repos/$aurhelper
git clone $aurhelperURL $HOME/.repos/$aurhelper
cd $HOME/.repos/$aurhelper
makepkg -si --noconfirm

#####Install aur packages#####
aurFile="$HOME/aurlist.txt"
#download pkglist
curl -L -o $aurFile $aurpkglistURL
#remove comments
sed -i '/^#.*/d' $aurFile
#install pkgs with aur helper
while read pkg
    do
        $aurhelper --needed --noconfirm -S $pkg
    done < $aurFile

rm $aurFile

#####Enable user services#####
for service in "${userservices[@]}"
    do
        systemctl --user enable --now $service
    done
