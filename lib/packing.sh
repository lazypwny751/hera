#!/bin/bash

# opshelper.sh and stringçsh must be sourced.

packing:build() {
    local i="" list="" metafile="package.sh" status="true"
    # Required variables
    local package="" version="" maintainer="" entity=() processor=() distro=()

    # Optional variables
    local description="" require_debian="" require_arch="" require_opensuse="" require=""

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
                    echo -e "\t${Bgreen}==>${reset} this package can be installed on those that support '${processor[@]}' machines."
                fi

                if [[ -n "${distro[@]}" ]] ; then
                    echo -e "\t${Bgreen}==>${reset} this package can be installed on the following distributions '${distro[@]}'."
                fi

                if [[ -n "${require_termux[@]}" ]] ; then
                    echo -e "\t${Bgreen}==>${reset} there is '${#require_termux[@]}' Termux(pkg/apt) packages."
                fi

                if [[ -n "${require_debian[@]}" ]] ; then
                    echo -e "\t${Bgreen}==>${reset} there is '${#require_debian[@]}' Debian(dpkg) packages."
                fi

                if [[ -n "${require_arch[@]}" ]] ; then
                    echo -e "\t${Bgreen}==>${reset} there is '${#require_arch[@]}' Arch(abs/pacman) packages."
                fi

                if [[ -n "${require_opensuse[@]}" ]] ; then
                    echo -e "\t${Bgreen}==>${reset} there is '${#require_opensuse[@]}' OpenSUSE(rpm/zypper) packages."
                fi

                # beforeinst&afterinst
                for list in "termux" "debian" "arch" "opensuse" ; do
                    if [[ -f "${1}/beforeinst-${list}.sh" ]] ; then
                        echo -e ""
                    elif [[ ]]
                    fi
                done

                # Building binary
                if [[ "${status}" = "true" ]] ; then
                    (
                        cd "${1}" || return 1
                        

                    ) 2> /dev/null || {
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