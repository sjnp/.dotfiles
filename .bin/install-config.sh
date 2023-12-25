git clone --bare git@github.com:sjnp/.dotfiles.git $HOME/.dotfiles

gitConfig () {
	/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

if gitConfig checkout
then
	echo "Getting configs... done"
fi

if gitConfig config status.showUntrackedFiles no
then
	echo "Setting untracked files... done"
fi

# Update .zshrc
if echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc
then
    source $HOME/.zshrc
    echo "Seting dotfiles alias... done"
fi

