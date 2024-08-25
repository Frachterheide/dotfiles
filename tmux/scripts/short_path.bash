#!/bin/bash

path=$1
shortPBase=""
shortPath=""
maxDirs=3

[[ -z "${path}" ]] && echo "" >&1
#remove leading slash
path="$(echo "${path}" | sed -r 's/^\///')"
#create array from directory names
declare -a path_l 
for dir in $(echo "${path}" | tr "/" " ");do path_l+=("$dir"); done
count=${#path_l[@]}
unset dir
unset path
#replace leading dirs with visual prefix (remove from array)
if [[ "${path_l[0]}" == "home" ]]; then
    shortPBase+='~/'
    if [[ $count -le $maxDirs ]]; then
        echo $shortPBase >&1
        exit 0;
    else
        path_l=("${path_l[@]:2}")
    fi
elif [[ "${path_l[0]}" == "." ]]; then
    shortPBase+='./'
else
    shortPBase+='/'
fi
#replace remaining surplus dirs 
count=${#path_l[@]}
if [[ $count -lt $maxDirs ]];then
    maxDirs=$count 
else
    shortPBase+=".../"
fi
#append remaining last maxDirs director
for dir in $(seq "$maxDirs");do
    if [[ $dir != "" ]]; then
        shortPath="${path_l[$((count-dir))]}/${shortPath}"
    fi
done
unset dir
unset count
unset maxDirs
unset path_l    

echo "$shortPBase${shortPath}" >&1

unset shortPath
unset shortPBase
