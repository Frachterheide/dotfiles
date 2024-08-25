# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable subsequent settings only in interactive sessions 
[[ $- != *i* ]] && return
[[ ! -f "${XDG_CACHE_HOME}/zsh_history" ]] && touch $XDG_CACHE_HOME/zsh_history
HISTFILE=${XDG_CACHE_HOME}/zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -v
# The following lines were added by compinstall
zstyle :compinstall filename "${XDG_CONFIG_HOME}/zsh/.zshrc"
autoload -Uz compinit
compinit
# End of lines added by compinstall
ZSH_THEME="powerlevel10k/powerlevel10k"
# DISABLE_AUTO_TITLE="true"
# does not mark untracked files -> faster in large repos
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# time stamps for history
# HIST_STAMPS="mm/dd/yyyy"
# User configuration
# You may need to manually set your language environment
# export LANG=en_US.UTF-8
# Load interactive environment
[[ -f "$XDG_CONFIG_HOME"/env/interactive.sh ]] && source "$XDG_CONFIG_HOME"/env/interactive.sh
# Source aliases
[[ -f "$XDG_CONFIG_HOME"/env/aliases.sh ]] && source "$XDG_CONFIG_HOME"/env/aliases.sh

for file in $(find $ZDOTDIR/plugins/ -maxdepth 1 -name "*plugin.zsh"); do
  if [[ -f "${file}" ]]; then
  source "${file}";
else 
  echo "Missing plugin ${file}"
done
unset file;

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
source ~/.config/zsh/plugins/.powerlevel10k/powerlevel10k.zsh-theme

[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
