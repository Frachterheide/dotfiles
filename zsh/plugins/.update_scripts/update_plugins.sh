#!/bin/sh

declare -a git_dirs
declare -a plugin_dirs 

# init git repo dirs & plugin dirs 
git_dirs[0]="$ZDOTDIR/plugins/.zsh-marks"
plugin_dirs[0]=${git_dirs[0]}

git_dirs[1]="$ZDOTDIR/plugins/.ohmyzsh"
plugin_dirs[1]="${git_dirs[1]}/plugins"

# update git repos
for git_dir in "${git_dirs[@]}"; do 
    cd $git_dir
    result=$(git status)
    if [[ "$result" == *"is up to date"* ]]; then
        unset $plugin_dirs[@]
    else
        git pull
    fi
done
unset git_dir
unset result

# link plugin
for dir in "${plugin_dirs[@]}"; do
    if [[ "$dir" != "" ]]; then
        for file in $(find $dir -maxdepth 1 -type f -name "*.plugin.zsh"); do
            ln -sf $file $ZDOTDIR/plugins/
        done
        echo "Updated ZSH plugins sourced from: {$dir}"
    fi
done
unset file
unset dir
unset plugin_dirs
unset git_dirs
