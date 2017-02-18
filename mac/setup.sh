#!/usr/bin/env bash

brews=(
  coreutils
  git
  git-extras
  git-lfs
  htop
  httpie
  nmap
  python
  python3
  tmux
  wget
)

casks=(
  docker
  emacs
  google-chrome
  google-drive
  kitematic
  skype
  slack
  spotify
  vlc
  xquartz
)

fonts=(
  font-source-code-pro
)

pips=(
  pip
  glances
  numpy
  scipy
  matplotlib
  pandas
  ipython
  jupyter
  tornado
)

git_configs=(
  "color.ui auto"
  "user.name mohitsharma44"
  "user.email mohitsharma44@gmail.com"
)

############################### Start Installing the above stuff ###############################

set +e

if test ! $(which brew); then
  echo "[$(date +%T)]: Installing Xcode ..."
  xcode-select --install

  echo "[$(date +%T)]: Installing Homebrew ..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "[$(date +%T)]: Updating Homebrew ..."
  brew update
  brew upgrade
fi
brew doctor
brew tap homebrew/dupes

# for all installations that fail
fails=()

function print_red {
  red='\x1B[0;31m'
  NC='\x1B[0m' # no color
  echo -e "${red}$1${NC}"
}

# Installer function
function install {
  cmd=$1
  shift
  for pkg in $@;
  do
    exec="$cmd $pkg"
    echo "[$(date +%T)]: Executing: $exec"
    if $exec ; then
      echo "[$(date +%T)]: Installed $pkg"
    else
      fails+=($pkg)
      print_red "[$(date +%T)]: Failed to execute: $exec"
    fi
  done
}

echo "[$(date +%T)]: Installing Java ..."
brew cask install java

echo "[$(date +%T)]: Installing packages ..."
brew info ${brews[@]}
install 'brew install' ${brews[@]}

echo "[$(date +%T)]: Tapping casks ..."
brew tap caskroom/fonts
brew tap caskroom/versions

echo "[$(date +%T)]: Installing software ..."
brew cask info ${casks[@]}
install 'brew cask install' ${casks[@]}
install 'brew cask install' ${fonts[@]}

echo "[$(date +%T)]: Upgrading bash ..."
brew install bash
sudo bash -c "echo $(brew --prefix)/bin/bash >> /private/etc/shells"

# https://github.com/barryclark/bashstrap
echo "[$(date +%T)]: Installing bashstrap ..."
mv ~/.bash_profile ~/.bash_profile_backup
mv ~/.bashrc ~/.bashrc_backup
mv ~/.gitconfig ~/.gitconfig_backup
cd; curl -#L https://github.com/barryclark/bashstrap/tarball/master | tar -xzv --strip-components 1 --exclude={README.md,screenshot.png}
source ~/.bash_profile

echo "[$(date +%T)]: Setting git defaults ..."
for config in "${git_configs[@]}"
do
  git config --global ${config}
done

echo "[$(date +%T)]: Installing mac CLI ..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/install)"

echo "[$(date +%T)]: Updating Mac..."
mac update

echo "[$(date +%T)]: Installing python packages ..."
pip install --upgrade setuptools
pip install --upgrade pip
install 'pip install --upgrade' ${pips[@]}

echo "[$(date +%T)]: Cleaning up ..."
brew cleanup
brew cask cleanup
brew linkapps

for fail in ${fails[@]}
do
  echo "Failed to install: $fail"
done

echo "Tada!! Done!"
