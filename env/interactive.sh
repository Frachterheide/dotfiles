if [[ -n $SSH_CONNECTION ]]; then
 export EDITOR='vim'
else
 export EDITOR='nvim'
fi

export GTK_USE_PORTAL=0
export WGETRC="$XDG_CONFIG_HOME"/wgetrc
export MAVEN_OPTS=-Dmaven.repo.local="$XDG_DATA_HOME/maven/repository"

[ -z "$NVM_DIR" ] && export NVM_DIR="$XDG_DATA_DIR"/nvm
source /usr/share/nvm/nvm.sh
source /usr/share/nvm/install-nvm-exec
