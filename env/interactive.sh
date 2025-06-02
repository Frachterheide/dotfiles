if [[ -n $SSH_CONNECTION ]]; then
 export EDITOR='vim'
else
 export EDITOR='nvim'
fi

export WINIT_UNIX_BACKEND=wayland
export INPUTRC=${XDG_CONFIG_HOME}/input/config
export SDIRS=${XDG_DATA_HOME}/sdirs
export MARKPATH=${XDG_DATA_HOME}/marks

export WGETRC="${XDG_CONFIG_HOME}"/wgetrc
export MAVEN_OPTS=-Dmaven.repo.local="${XDG_DATA_HOME}/maven/repository"
export GRADLE_HOME="${XDG_DATA_HOME}"/gradle
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="${XDG_CONFIG_HOME}"/java
export PATH="$PATH:${XDG_DATA_HOME}/cargo/bin"
export RUSTUP_HOME="${XDG_DATA_HOME}"/rustup
export CARGO_HOME="${XDG_DATA_HOME}"/cargo
export GOPATH="${XDG_DATA_HOME}"/go
export CCACHE_DIR="${XDG_CONFIG_HOME}"/ccache

export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}"/npm/npmrc
export NVM_DIR="${XDG_DATA_HOME}"/nvm

source /usr/share/nvm/nvm.sh
source /usr/share/nvm/install-nvm-exec
