#!/bin/bash

# opshelper.sh and string.sh must be sourced.

packing:build() {
    # package.sh -> here: check if that options are met -> cpio archive

    local i="" list="" metafile="package.sh" status="true"

    # Required variables
    local package="" version="" maintainer="" entity=() processor=() distro=()

    # Optional variables
    local require_debian="" require_arch="" require_opensuse="" require=""

    ## !LOOK HERE!
    # burada paket hazırlayan kişinin girdiği verileri dosyalar şeklinde ayırmalı mıyım?
    # eğer öyleyse neden öyle yapmalıyım yine de aynı kapıya çıkmayacak mı?, hem diğer türlü
    # kullanıcıyı kısıtlamış bulunmaz mıyım.
    if [[ -d "${1}" ]] ; then
        if [[ -f "${1}/${metafile}" ]] ; then
            source "${1}/${metafile}" && {
                # Requirements
                if [[ ! -n "${package}" ]] || ! string:allow "${package}" ; then
                    echo -e "${green}${BASH_SOURCE[0]##*/}${reset}: ${red}${FUNCNAME##*:}${reset}: 'package: ${package}' contains unsupported characters."
                    local status="false"
                fi

                if ! [[ "$(string:str2int "${version}")" -gt "0" ]] &> /dev/null ; then
                    echo -e "${green}${BASH_SOURCE[0]##*/}${reset}: ${red}${FUNCNAME##*:}${reset}: 'version: ${version}' contains unsupported characters."
                    local status="false"
                fi

                if [[ -z "${entity[@]}" ]] ; then
                    echo -e "${green}${BASH_SOURCE[0]##*/}${reset}: ${red}${FUNCNAME##*:}${reset}: entities aren't defined."
                    local status="false"
                fi

                if [[ "$(type -t build)" != "function" ]] &> /dev/null ; then
                    echo -e "${green}${BASH_SOURCE[0]##*/}${reset}: ${red}${FUNCNAME##*:}${reset}: function 'build' not found."
                    local status="false"
                fi

                # Optionals
                # dependencies
                if [[ -n "${processor[@]}" ]] ; then
                    echo -e "\t${blue}==>${reset} this package can be installed on those that support '${processor[@]}' machines."
                fi

                if [[ -n "${distro[@]}" ]] ; then
                    echo -e "\t${blue}==>${reset} this package can be installed on the following distributions '${distro[@]}'."
                fi

                if [[ -n "${require}" ]] ; then
                    echo -e "\t${blue}==>${reset} there is '${#require[@]}' Hera(self) packages."
                fi

                if [[ -n "${require_termux[@]}" ]] ; then
                    echo -e "\t${blue}==>${reset} there is '${#require_termux[@]}' Termux(pkg/apt) packages."
                fi

                if [[ -n "${require_debian[@]}" ]] ; then
                    echo -e "\t${blue}==>${reset} there is '${#require_debian[@]}' Debian(dpkg) packages."
                fi

                if [[ -n "${require_arch[@]}" ]] ; then
                    echo -e "\t${blue}==>${reset} there is '${#require_arch[@]}' Arch(abs/pacman) packages."
                fi

                if [[ -n "${require_opensuse[@]}" ]] ; then
                    echo -e "\t${blue}==>${reset} there is '${#require_opensuse[@]}' OpenSUSE(rpm/zypper) packages."
                fi

                # beforeinst&afterinst
                for list in "termux" "debian" "arch" "opensuse" ; do
                    if [[ -f "${1}/beforeinst-${list}.sh" ]] ; then
                        echo -e "\t${blue}==>${reset} beforeinst-${list}.sh found.."
                    fi

                    if [[ -f "${1}/afterinst-${list}.sh" ]] ; then
                        echo -e "\t${blue}==>${reset} afterinst-${list}.sh found.."
                    fi
                done

                # Building binary
                if [[ "${status}" = "true" ]] ; then
                    (
                        echo -e "\t${Bblue}==>${reset} files are being archived.."
                        cd "${1}" || return 1
                        find . | cpio -o > "${CWD}/${package}-${version}.cpio" || return 2
                    ) 2> /dev/null && {
                        export SHARED="${CWD}/${package}-${version}.cpio"
                        echo -e "\t${Bgreen}==>${reset} files have been successfully archived."
                    } || {
                        echo -e "\t${Bred}==>${reset} Error encountered while processing files."
                        local status="false"
                    }
                fi

                if [[ "${status}" = "false" ]] ; then
                    return 1
                else
                    return 0
                fi
            } || {
                echo -e "${green}${BASH_SOURCE[0]##*/}${reset}: ${red}${FUNCNAME##*:}${reset}: metafile not configured correctly!"
                return 3
            }
        else
            echo -e "${green}${BASH_SOURCE[0]##*/}${reset}: ${red}${FUNCNAME##*:}${reset}: '${metafile}' not found in ${1##*/}."
            return 2
        fi
    else
        echo -e "${green}${BASH_SOURCE[0]##*/}${reset}: ${red}${FUNCNAME##*:}${reset}: package directory not found."
        return 1
    fi
}

packing:install() {
    # cpio archive -> hera: check if the options are met -> system -> etities are goes hera's key value storage archives 

    local i="" list="" metafile="package.sh" status="true"

    # Required variables
    local package="" version="" maintainer="" entity=() processor=() distro=()

    # Optional variables
    local require_debian="" require_arch="" require_opensuse="" require=""

    if file "${1}" | grep grep -w "cpio archive" &> /dev/null ; then
        # set up temp dir
        # copy the archive
        # open the archive
        # source the package.sh
        # check requiremets
        # get optional dependencies and run beforeinst files
        # run the build function
        # save  the meta daata from key value based store
        # remove temp dir
        # NOT: during this process generate lock file and do not allow run this function multiple
        :
    else
        echo -e ""
        return 1
    fi
}