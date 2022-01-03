#!/bin/bash

# lib init requred must be sourced

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

version:isgreater() {
    local argv1="$(echo "${1}" | tr -d ".")"
    local argv2="$(echo "${2}" | tr -d ".")"
    if [[ "${argv1}" -gt "${argv2}" ]] ; then
        return 0
    else
        return 1
    fi
}

hera:help() {
    echo -e "~$ $(alternative:filename ${BASH_SOURCE[-1]}) --build <dir1> <dir2>..:
    generate hera packages.

~$ $(alternative:filename ${BASH_SOURCE[-1]}) --help:
    show this text.

~# $(alternative:filename ${BASH_SOURCE[-1]}) --install <package1> <package2>..:
    Install packages from repositories or on your system.

~# $(alternative:filename ${BASH_SOURCE[-1]}) --uninstall <package1> <package2>..:
    remove installed hera packages.

~$ $(alternative:filename ${BASH_SOURCE[-1]}) --update:
    update catalogs.

~$ $(alternative:filename ${BASH_SOURCE[-1]}) --list -p/-r:
    View packages installed with -p argument in repositories with -r.

~# $(alternative:filename ${BASH_SOURCE[-1]}) --fix:
    If hera constantly makes mistakes, use this argument.
\033[0m"
}

hera:managers() {
    case "${1}" in
        [tT][eE][mM][pP]|--[tT][eE][mM][pP]|-[tT])
            case "${2}" in
                [cC][hH][eE][cC][kK]|--[cC][hH][eE][cC][kK]|-[cC])
                ;;
                [sS][tT][aA][rR][tT]|--[sS][tT][aA][rR][tT]|-[sS][tT])
                    if [[ ! -d "${temp}" ]] ; then
                        mkdir -p "${temp}" &> /dev/null
                    fi
                ;;
                [sS][tT][oO][pP]|--[sS][tT][oO][pP]|-[sS][pP])
                    if [[ -d "${temp}" ]] ; then
                        rm -rf "${temp}" &> /dev/null
                    fi    
                ;;
            esac
        ;;
        [pP][iI][dD]|--[pP][iI][dD]|-[pP])
            if [[ $(ps -ax | grep "${SHELL} ${BASH_SOURCE[-1]}" | awk 'NR==1{print $1}') = "$$" ]] &> /dev/null ; then
                return 0
            else
                echo -e "\033[0;31mhera is already working on pid\033[0m '\033[1;37m$(ps -ax | grep "${BASH_SOURCE[-1]}" | awk 'NR==1{print $1}')\033[0m'"
                exit 1
            fi
        ;;
    esac
}

hera:fix() {
    if [[ "${UID}" != 0 ]] ; then
        echo "please run it with root privilages"
        exit 1
    fi

    if [[ -d "${temp}" ]] ; then
        rm -rf "${temp}"
    fi

    # btb dosyası var mı?
    if [[ ! -f ""${home}/${btb}"" ]] ; then
        cd "${home}"
        . ./lib/btb.sh
        btb:generate --bank "packages"
    fi

    if [[ ! -f "${home}/${cat}" ]] ; then
        echo -e "repositories:
  - pisagor|https://raw.githubusercontent.com/ByCh4n-Group/pisagor/main
" > "${home}/${cat}"
    fi

    if [[ -d "${rep}" ]] ; then
        mkdir -p "${rep}"
    fi

    if [[ -d "${lib}" ]] ; then
        mkdir -p "${lib}"
    fi

    chown "${user}:${group}" "${home}" "${home}"/* "${home}"/*/*
    chmod +x "${lib}"/*
}