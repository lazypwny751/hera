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
btb="${home}/packages.btb"

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

alternative:filename() {
    # Alternatif filename fonksiyonu
    # Eğer filename komutu yüklü değil ise
    # Paket kurmaya gerek kalmadan bu fonksiyon
    # sayesinde alternatif bir ayrıştırıcı elde
    # etmiş oluruz.

    if [[ "${#}" -gt 0 ]] ; then
        if ! command -v filename &> /dev/null ; then
            for y in $(seq 1 ${#}) ; do
                echo ${@:y:1} | tr "/" " " | awk '{print $NF}'
            done
        else
            filename ${@}
        fi
    else
        echo -e "Kullanım şekli 1 parametrelik dosya/dizin yolu giriniz. Örnek\n> dosya-adi /tmp/test/test.sh\n< test.sh"
        return 1
    fi
}
