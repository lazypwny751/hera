#!/bin/bash

#    simple and lighweight bash package manager - hera package manager 1.0.0
#    Copyright (C) 2021  ByCh4n-Group
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

. /usr/share/hera/init.sh || { echo -e "\033[0;31mFatal: Could not initalizing in this time!\033[0m" ; exit 1 ; }

init:loadlibrary "colorsh" "tuiutils" "osutils" "core" "banners"

hera:managers --temp "stop"

case "${1}" in
    [bB][uU][iI][lL][dD]|--[bB][uU][iI][lL][dD]|-[bB])
        osutil:check --trigger "tar" || exit 1
        init:loadlibrary "yamlparser" "packing"
        for X in $(seq 2 ${#}) ; do
            cd "${cwd}" || tuiutil:notices --error "could not changing directory"
            tuiutil:text --center "$(echo -ne "${BIyellow}")Checking for$(echo -ne "${reset}") '${@:X:1}'"
            hera:managers --temp "start"
            packing:build "${@:X:1}" && tuiutil:notices --succsess "${@:X:1} packed" || tuiutil:notices --error "${@:X:1} could not be packed"
            hera:managers --temp "stop"
            tuiutil:text --center "$(echo -ne "${BIyellow}")Finished$(echo -ne "${reset}") '${@:X:1}'"
            printf "\n"
        done
        banners:anime --saitama
    ;;
    [iI][nN][sS][tT][aA][lL][lL]|--[iI][nN][sS][tT][aA][lL][lL]|-[iI][nN])
        hera:managers --pid
        osutil:check --root || exit 1
        osutil:check --trigger "base64" "wget" "tar" "make" || exit 1
        osutil:check --file "${home}/${btb}"
        init:loadlibrary "yamlparser" "btb" "install" #depresolv
        banners:anime --pika
        for X in $(seq 2 ${#}) ; do
            cd "${cwd}" || tuiutil:notices --error "could not changing directory"
            tuiutil:text --center "$(echo -ne "${BIblue}")Preparing for$(echo -ne "${reset}") '${@:X:1}'"
            hera:managers --temp "start"
            ## install:package "${@:X:1}"
            ## install:getpackage "${@:X:1}"
            install:install "${@:X:1}"
            hera:managers --temp "stop"
            tuiutil:text --center "$(echo -ne "${BIblue}")Finished$(echo -ne "${reset}") '${@:X:1}'"
            printf "\n"
        done
    ;;
    [uU][nN][iI][nN][sS][tT][aA][lL][lL]|--[uU][nN][iI][nN][sS][tT][aA][lL][lL]|-[uU][nN])
        banners:rabbit "1"
        hera:managers --pid
        osutil:check --root || exit 1
        osutil:check --trigger "base64" "tar" "make" || exit 1
        osutil:check --file "${home}/${btb}"
        init:loadlibrary "btb" "uninstall"
        for X in $(seq 2 ${#}) ; do
            cd "${cwd}" || tuiutil:notices --error "could not changing directory"
            tuiutil:text --center "$(echo -ne "${BIpurple}")Preparing for$(echo -ne "${reset}") '${@:X:1}'"
            hera:managers --temp "start"
            uninstall:package "${@:X:1}"
            hera:managers --temp "stop"
            tuiutil:text --center "$(echo -ne "${BIpurple}")Finished$(echo -ne "${reset}") '${@:X:1}'"
            printf "\n"
        done
    ;;
    [uU][pP][dD][aA][tT][eE]|--[uU][pP][dD][aA][tT][eE]|-[uU][pP])
        osutil:check --trigger "wget" "sha256sum"
        init:loadlibrary "update" "yamlparser"
        hera:managers --temp "start"
        update:catalogs
        hera:managers --temp "stop"
    ;;
    [lL][iI][sS][tT]|--[lL][iI][sS][tT]|-[lL])
        init:loadlibrary "btb" "list" "yamlparser"
        case "${2}" in
            [pP][aA][cC][kK][aA][gG][eE][sS]|--[pP][aA][cC][kK][aA][gG][eE][sS]|-[pP])
                list:installedpkgs
            ;;
            [rR][eE][pP][oO][sS][iI][tT][oO][rR][iI][eE][sS]|--[rR][eE][pP][oO][sS][iI][tT][oO][rR][iI][eE][sS]|-[rR])
                list:repopkgs
            ;;
            *)
                echo -e "there are 2 flags 'packages', 'repositories':

$(alternative:filename ${BASH_SOURCE[-1]}) --packages:
    shows installed packages with ${BASH_SOURCE[-1]} in your system.

$(alternative:filename ${BASH_SOURCE[-1]}) --repositories:
    shows that packages in repositories.
${reset}"
            ;;
        esac
    ;;
    [fF][iI][xX]|--[fF][iI][xX]|-[fF])
        hera:fix
    ;;
    [hH][eE][lL][pP]|--[hH][eE][lL][pP]|-[hH])
        hera:help
    ;;
    *)
        banners:hera graffiti rainbow
        echo -e "${blue}$(alternative:filename ${BASH_SOURCE[0]})${reset}/${Bwhite}v${version}${reset}-${Bgreen}${maintainer}${reset} Low level package manager.\nUse the 'help' argument for information about how can use hera."
    ;;
esac