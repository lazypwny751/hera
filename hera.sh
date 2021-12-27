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

init:loadlibrary "colorsh" "tuiutils" "osutils" "banners"


case "${1}" in
    [bB][uU][iI][lL][dD]|--[bB][uU][iI][lL][dD]|-[bB])
        init:loadlibrary "packing"
        for i in $(seq 2 ${#}) ; do
            packing:build "${@:i:1}" && tuiutil:notices --succsess "${@:i:1} is packaged" || tuiutil:notices --error "${@:i:1} isn't packaged"
        done
    ;;
    *)
        banners:hera graffiti rainbow
        echo -e "${blue}$(alternative:filename ${BASH_SOURCE[0]})${reset}/${Bwhite}v${version}${reset}-${Bgreen}${maintainer}${reset}\nUse the 'help' argument for information about how can use hera."
    ;;
esac