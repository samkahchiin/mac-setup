#!/usr/bin/env bash

# Reference:
# https://gist.github.com/codeinthehole/26b37efa67041e1307db

echo "Start Installing ...."

if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update homebrew recipes
brew update

PACKAGES=(
    # infra
    terraform

    # terminal
    tree
    ripgrep
    hub
    antigen
    z

    #  language
    yarn
    redis

    #  database
    postgresql

    #  Others
    cocoapods
    wget
    ffmpeg

    #  Git
    emojify

    #  secure
    gnupg
    pinentry-mac

    coreutils
    curl
    asdf
    git
    openssl
    readline
)

echo "Installing packages"
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

echo "Installing cask..."
brew tap homebrew/cask

CASKS=(
    fliqlo
    google-chrome
    iterm2
    notion
    postman
    skype
    rectangle
    tableplus
    visual-studio-code
    zoom

    # mac security tools
    oversight
    reikey
    knockknock
    netiquette
    lulu
)

echo "Installing cask apps..."
brew install ${CASKS[@]}

echo "Installing docker desktop on mac"
brew install --cask docker

# Set key repeat speed
defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

# To disable the Apple press and hold for VSCode
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false


function install_git {
	echo '== Installing GIT =='

	# Installation Notice
	brew install git

	# Process name
	echo -n "Processing input for setup... "
	local username=$1
	local email=$2
	echo "[ DONE ]"

	# Setup Git
	echo -n "Setting up Global Settings... "
	git config --global color.ui true
	git config --global user.name $username
	git config --global user.email $email
	git config --global push.default matching
	git config --global gpg.program "$(which gpg)"

	echo "[ DONE ]"

	echo '[ COMPLETED ]'
}

install_git $user_username $user_email
