
function zsh_presetup {
  echo "Installing antigen"
  brew install antigen
  echo "Change shell to zsh"
  chsh -s $(which zsh)

  if [[ $(uname -p) == 'arm' ]]
  then
    source /opt/homebrew/share/antigen/antigen.zsh
  else
    source /usr/local/share/antigen/antigen.zsh
  fi
}


zsh_presetup
echo -n "Please enter your personal access token instead of password... "
cd ~ && git clone https://github.com/samkahchiin/zsh.git
mv zsh .zsh.d
~/.zsh.d/init
source ~/.zshrc
