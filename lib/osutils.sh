#!/bin/bash

#    Operating Systems Utils - os utils
#    Copyright (C) 2021  lazypwny751
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

osutil:check() {
    case "${1}" in
        [rR][oO][oO][tT]|--[rR][oO][oO][tT]|-[rR])
            case "${2}" in
                [sS][iI][lL][eE][nN][tT]|--[sS][iI][lL][eE][nN][tT]|-[sS])
                    if [[ ${UID} != 0 ]] ; then
                        return 1
                    fi
                ;;
                *)
                    if [[ "${UID}" != 0 ]] ; then
                        echo -e "\033[0;31mplease run it as root privalages(!)\033[0m"
                        return 1
                    fi
                ;;
            esac
        ;;
        [fF][iI][lL][eE]|--[fF][iI][lL][eE]|-[fF])
            local x="true"
            for i in "${@:2}" ; do
                if ! [[ -f "${i}" ]] ; then
                    echo -e "file ${i} does not exist!"
                    local x="false"
                fi
            done

            if [[ "${x}" = "false" ]] ; then
                return 1
            fi
        ;;
        [tT][rR][iI][gG][gG][eE][rR]|--[tT][rR][iI][gG][gG][eE][rR]|-[tT])
            local x="true"
            for i in "${@:2}" ; do
                if !  command -v "${i}" &> /dev/null ; then
                    echo -e "trigger ${i} not found!"
                    local x="false"
                fi
            done

            if [[ "${x}" = "false" ]] ; then
                return 1
            fi
       
        ;;
        [dD][iI][rR][eE][cC][tT][oO][rR][yY]|--[dD][iI][rR][eE][cC][tT][oO][rR][yY]|-[dD][iI][rR])
            local x="true"
            for i in "${@:2}" ; do
                if ! [[ -d "${i}" ]] ; then
                    echo -e "directory ${i} does not exist!"
                    local x="false"
                fi
            done

            if [[ "${x}" = "false" ]] ; then
                return 1
            fi
        ;;
    esac
}

osutil:define() {
    case "${1}" in
        [bB][aA][sS][eE]|--[bB][aA][sS][eE]|-[bB])
            case "${2}" in
                [sS][iI][lL][eE][nN][tT]|--[sS][iI][lL][eE][nN][tT]|-[sS])
                    if [[ -e /etc/debian_version ]] ; then
                        sysbase="debian"
                    elif [[ -e /etc/arch-release ]] ; then
                        sysbase="arch"
                    elif [[ -e /etc/artix-release ]] ; then
                        sysbase="arch"
                    elif [[ -e /etc/fedora-release ]] ; then
                        sysbase="fedora"
                    elif [[ -e /etc/pisi-release ]] ; then
                        sysbase="pisi"
                    elif [[ -e /etc/zypp/zypper.conf ]] ; then
                        sysbase="opensuse"
                    else
                        sysbase="unknow"
                    fi
                ;;
                *)
                    if [[ -e /etc/debian_version ]] ; then
                        echo "debian"
                    elif [[ -e /etc/arch-release ]] ; then
                        echo "arch"
                    elif [[ -e /etc/artix-release ]] ; then
                        echo "arch"
                    elif [[ -e /etc/fedora-release ]] ; then
                        echo "fedora"
                    elif [[ -e /etc/pisi-release ]] ; then
                        echo "pisi"
                    elif [[ -e /etc/zypp/zypper.conf ]] ; then
                        echo "opensuse"
                    else
                        echo "unknow"
                    fi
                ;;
            esac
        ;;
        [iI][sS]-[aA][rR][cC][hH]|--[iI][sS]-[aA][rR][cC][hH]|-[iI][aA])
            case "${2}" in
                [xX]86)
                    if [[ $(uname -i) = "x86" ]] ; then
                        return 0
                    else
                        return 1
                    fi
                ;;
                [xX]64|[xX]86_[xX]64)
                    if [[ $(uname -i) = "x86_64" ]] ; then
                        return 0
                    else
                        return 1
                    fi
                ;;
                [aA][aA][rR][cC][hH]64)
                    if [[ $(uname -i) = "aarch64" ]] ; then
                        return 0
                    else
                        return 1
                    fi
                ;;
            esac            
        ;;
    esac
}

osutil:update() {
    # just run this function ostutil:update
    osutil:check --root || exit 1
    case "$(osutil:define --base)" in
        debian)
            apt update
        ;;
        arch)
            pacman -Syy
        ;;
        fedora)
            dnf check-update
        ;;
        pisi)
            pisi ur
        ;;
        opensuse)
            zypper refresh
        ;;
        unknow)
            echo "unknow base so there is nothing to do"
            return 1
        ;;
    esac   
}

osutil:install() {
    # osutil:install <package as base> <package as base>..
    osutil:check --root || exit 1
    case "$(osutil:define --base)" in
        debian)
            apt install -y ${1}
        ;;
        arch)
            pacman -Sy --noconfirm ${1}
        ;;
        fedora)
            dnf install -y ${1}
        ;;
        pisi)
            pisi it -y ${1}
        ;;
        opensuse)
            zypper remove --no-confirm ${1}
        ;;
    esac
    
}

osutil:uninstall() {
    # osutil:uninstall <package as base> <package as base>..
    osutil:check --root || exit 1
    case "$(osutil:define --base)" in
        debian)
            apt remove -y ${1}
        ;;
        arch)
            pacman -R --noconfirm ${1}
        ;;
        fedora)
            dnf remove -y ${1}
        ;;
        pisi)
            pisirmt -y ${1}
        ;;
        opensuse)
            zypper remove --no-confirm ${1}
        ;;
    esac
}