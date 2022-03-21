# NOTICE
# This script is meant for auto-run. If you want to learn, please learn BASH script. Thank you.

function xcode_agreement {
	echo "== Setup Xcode Agreement =="
	sudo xcodebuild -license
	echo "[ COMPLETED ]"
}


function install_homebrew {
	echo "== Installing Homebrew =="
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	echo "[ COMPLETED ]"
}

function install_asdf {
	echo "== Installing asdf =="

	brew install asdf

	# Add asdf to zsh so that it loads every time you open a terminal
	echo -n 'adding asdf to zshrc for autoloading... '
	# echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc
	source ~/.zshrc
	echo '[ DONE ]'
	echo ''

	echo "[ COMPLETED ]"
}


function install_ruby {
	echo '== Installing Ruby =='
	# Process name

	asdf plugin add ruby
	# Install Ruby
	echo -n "Processing input for setup... "
	echo -n "Installing ruby"
	asdf install ruby latest
	asdf global ruby $(asdf list ruby | tail -1)
	echo '[ DONE ]'

	echo '[ COMPLETED ]'
}

function setup_ssh {
	echo '== Setting Up SSH =='
	SSH_PATH=~/.ssh

	if [ -a $SSH_PATH ]; then
		mkdir $SSH_PATH
	fi

	ssh-keygen -t rsa -N "" -f $SSH_PATH/id_rsa
	ssh-add $SSH_PATH/id_rsa

	echo '[ COMPLETED ]'
}


function setup_rails {
	echo '== Setup Rails =='
	gem install rails
}


function setup_postgresql {
	echo '== Install Postgresql =='

	echo -n 'Install postgresql software... '
	# Installation
	brew install postgresql
	echo '[ DONE ]'

	# Only applicable for Intel
	echo -n 'Add a launchd to start postgresql at login... '
	# To have launchd start postgresql at login
	ln -sfv $(brew --prefix postgresql)/*plist ~/Library/LaunchAgents
	echo '[ DONE ]'

	echo -n 'Launch the postgresql now... '
	# Then to load postgresql now:
	launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
	echo '[ DONE ]'
	echo ''

	echo '[ COMPLETED ]'
}


################################
# Driver Code
################################
# Welcome Printout
echo "==================================="
echo " Welcome to Rails Automation Tool  "
echo "==================================="
echo ""

# Inquire input
echo "-----------------------------------"
echo "| Inquire Input                   |"
echo "-----------------------------------"
echo ""

echo -n "Your Name For Github Signature (Supply a string with \"\"): "
read user_username
echo -n "Your Email For Github Signature (Supply a string with \"\"): "
read user_email

OPTIONS="YES NO"
echo "Have you install XCode from Apple Store and AGREED TO LICENSE?"
select opt in $OPTIONS; do
	case $opt in
		"YES")
			echo "good."
			break
			;;
		"NO")
			echo "automation will not work without xcode."
			echo "please go to app store and install Xcode now."
			echo "---------------------------------------------"
			echo "Press ENTER after you've installed Xcode successfully."
			read temp
			xcode_agreement
			break
			;;
		*)
			echo "select option: invalid Option."
	esac
done

# Install Brew to ensure it's working
echo "-----------------------------------"
echo "| Setup Interatives softwares     |"
echo "-----------------------------------"
echo ""
# install_homebrew
setup_ssh $user_email

echo "==================================================="
echo "Inquiry completed. Press Enter to begin automation."
echo "==================================================="
read temp

install_asdf
install_ruby
setup_rails
setup_postgresql

# Done
source ~/.zshrc
echo "Setup Completed. You should try generating a rails app to it test out."
