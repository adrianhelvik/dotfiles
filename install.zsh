#!/bin/zsh

dotfiles_dir=$(dirname $(zsh -c 'echo ${0:A}' $0))

# Brew
######
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

# Firefox
#########
brew install --cask firefox
(
	cd "$HOME/Library/Application Support/Firefox/Profiles"

	for f in *
	do
		if ![ -d "$f" ]; then
			continue
		fi

		mkdir -p "$f/chrome"
		cp "$dotfiles_dir/userChrome.css" "$f/chrome"
	done
)

# Neovim
########
brew install neovim

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

(
	mkdir -p "$HOME/.config"
	ln -s $dotfiles_dir/nvim ~/.config/nvim
)
