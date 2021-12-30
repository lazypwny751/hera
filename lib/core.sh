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
    echo -e "$(alternative:filename ${BASH_SOURCE[-1]}) --build <dir1> <dir2>..:

$(alternative:filename ${BASH_SOURCE[-1]}) --help:
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
    :
}