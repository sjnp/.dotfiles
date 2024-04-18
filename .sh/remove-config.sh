if rm -rf $HOME/.dotfiles
then
	echo "Removing .dotfiles directory... done"
fi

if rm -rf $HOME/.sh
then
	echo "Removing .sh directory... done"
fi

if rm $HOME/.config/nvim/init.lua
then
	echo "Removing neovim config... done"
fi

if rm $HOME/.config/tmux/tmux.conf
then
	echo "Removing tmux config... done"
fi

if rm $HOME/.ideavimrc
then
    echo "Removing ideavim config... done"
fi

if rm $HOME/LICENSE && rm $HOME/README.md
then
	echo "Removing license and readme files... done"
fi

if sed -i.bak "/alias dotfiles=/d" $HOME/.zshrc
then
	echo "Removing dotfiles alias from .zshrc... done"
fi
