#!/bin/bash

# Define variables
export version="1.0.0"
export maintainer="ByCh4n-Group"
export license="GPLv3"

export cwd="${PWD}"
export user="${SUDO_USER:-$USER}"
export group=$(cat /etc/group | awk -F: '{ print $1}' | grep -w ${user} || echo "users")

export home="/usr/share/hera"
export temp="/tmp/hera"
export lib="${home}/lib"
export rep="${home}/repositories"

export btb="packages.btb" # in home
export cat="repositories.yaml"

# Functions
init:loadlibrary() {
    if [[ -d "${lib}" ]] ; then
        for x in $(seq 1 ${#}) ; do
            if [[ -e "${lib}/${@:x:1}".sh ]] ; then
                source "${lib}/${@:x:1}".sh
            elif [[ -e "${lib}/${@:x:1}" ]] ; then
                source "${lib}/${@:x:1}"
            else
                echo -e "\033[0;31mFatal: Library ${@:x:1}.sh Couldn't Sourced!\033[0m"
                exit 1
            fi
        done
    else
        echo -e "\033[0;31mThe Library Directory Doesn't Exist! Please Reinstall the Tool.\033[0m"
        exit 1
    fi
}