#!/bin/bash
function parse_git_dirty {
  [[ $(git status --porcelain 2> /dev/null) ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ (\1$(parse_git_dirty))/"
}
# shorten displayed path
export PROMPT_DIRTRIM=3
export PS1="\n\[\033[33m\]\t \\[\033[90m\][\u] \[\033[34m\]\w\\[\033[00m\]\[\033[90m\]\$(parse_git_branch)\[\033[00m\]\n\[\033[95m\]$ "
#enable __git_ps1
#export PS1="\n\t \[\033[32m\]\w\[\033[33m\]\$(GIT_PS1_SHOWUNTRACKEDFILES=1 GIT_PS1_SHOWDIRTYSTATE=1 __git_ps1)\[\033[00m\] $ "
