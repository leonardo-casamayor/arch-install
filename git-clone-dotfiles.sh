#!/bin/sh

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
