#!/bin/bash

# Define variables
version="1.0.0"
maintainer="ByCh4n-Group"
license="GPLv3"

cwd="${PWD}"
user="${SUDO_USER:-$USER}"
group=$(cat /etc/group | awk -F: '{ print $1}' | grep -w ${user} || echo "users")

home="/usr/share/hera"
temp="/tmp/hera"
lib="${home}/lib"
rep="${home}/repositories"

lock="${temp}/hera.pid"
btb="packages.btb" # in home
cat="repositories.yaml"

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