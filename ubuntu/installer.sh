# Install tools
sudo apt-get install -y git python-dev python-pip python-numpy python-matplotlib ipython jupyter emacs

# Git prompt
cd ~
git clone https://github.com/magicmonty/bash-git-prompt.git .bash-git-prompt --depth=1
echo "GIT_PROMPT_ONLY_IN_REPO=1" >> ~/.bashrc
echo "source ~/.bash-git-prompt/gitprompt.sh"

# Install Terminal theme
wget -O xt https://git.io/vKOB6 && chmod +x xt && ./xt && rm xt
#(select Hemisu Dark)

