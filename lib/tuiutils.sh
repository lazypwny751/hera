#!/bin/bash

#    text based user interface utils - tui utils 1.0.0
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

tuiutil:yesno() {
    read -r -p "are you sure you want to continue? [Y/n] " tuiutil_response
    case "${response}" in
        [nN]) 
            return 1    
        ;;
        *)
            return 0
        ;;
    esac

}

tuiutil:pressanykey() {
    case "${1}" in
        [tT][iI][mM][eE]|--[tT][iI][mM][eE]|-[tT])
            [[ -z "${2}" ]] && local second="3" || local second="${2}"
            echo -n "pls wait (${second}sec)..." ; read -t "${second}" -n 1 -r -s -p $'Or Press Any Key To Continue\n'
        ;;
        *)
            read -n 1 -r -s -p $'Press Any Key To Continue...\n'
        ;;
    esac
}

tuiutil:spinner() {
    case "${1}" in
        [oO][nN][eE]|--[oO][nN][eE]|1)
            local count=0
            local total="34"
            local pstr="[=======================================================================]"
            
            [[ -z "${2}" ]] && local sleep="0.5" || local sleep="${2}"

            while [ $count -lt $total ] ; do
                local count=$(( $count + 2 ))
                local pd=$(( $count * 73 / $total ))
                printf "\r%3d.%1d%% %.${pd}s" $(( $count * 100 / $total )) $(( ($count * 1000 / $total) % 100 )) "${pstr}"
                sleep "${sleep}"
            done
        ;;
    esac
}

tuiutil:text() {
    case "${1}" in
        [cC][eE][nN][tT][eE][rR]-[pP][aA][dD][dD][iI][nN][gG]|--[cC][eE][nN][tT][eE][rR]|-[cC][pP])
            local terminalwidth="$(tput cols)"
            [[ -z ${2} ]] && local text="*" || local text="${2}"
            [[ -z ${3} ]] && local setchar="=" || local setchar="${3}"
            
            local padding="$(printf '%0.1s' "${setchar}"{1..500})"
            printf '%*.*s %s %*.*s\n' 0 "$(((terminalwidth-2-${#text})/2))" "$padding" "$text" 0 "$(((terminalwidth-1-${#text})/2))" "$padding"
        ;;
        [cC][eE][nN][tT][eE][rR]|--[cC][eE][nN][tT][eE][rR]|-[cC])
            local column=$(tput cols)
            [[ -z "${2}" ]] && local title="${FUNCNAME[0]}" || local title="${2}"
            printf "%*s\n" $(((${#title}+$column)/2)) "$title"
        ;;
    esac
}

tuiutil:simulate() {
    case "${1}" in
        [tT][eE][xX][tT]|--[tT][eE][xX][tT]|-[tT])
            [[ -z "${2}" ]] && local text="${FUNCNAME[0]}" || local text="${2}"
            [[ -z "${3}" ]] && local sleep="0.075" || local sleep="${3}"
            
            for ((i=0; i<${#text}; i++)) ; do  
                sleep "${sleep}"
                printf "${text:$i:1}"
            done
        ;;
    esac
}

tuiutil:notices() {
    case "${1}" in
        [eE][rR][rR][oO][rR]|--[eE][rR][rR][oO][rR]|-[eE])
            [[ -z "${2}" ]] && local text="${FUNCNAME[0]}" || local text="${2}"
            echo -e "\033[0;31merror\033[0m:   ${text}."
            return 1
        ;;
        [sS][uU][cC][cC][sS][eE][sS][sS]|--[sS][uU][cC][cC][sS][eE][sS][sS]|-[sS])
            [[ -z "${2}" ]] && local text="${FUNCNAME[0]}" || local text="${2}"
            echo -e "\033[0;32msuccess\033[0m: ${text}."
        ;;
        [wW][aA][rR][nN]|--[wW][aA][rR][nN]|-[wW])
            [[ -z "${2}" ]] && local text="${FUNCNAME[0]}" || local text="${2}"
            echo -e "\033[0;33mwarning\033[0m: ${text}!"
        ;;
        [iI][nN][fF][oO]|--[iI][nN][fF][oO]|-[iI])
            [[ -z "${2}" ]] && local text="${FUNCNAME[0]}" || local text="${2}"
            echo -e "\033[0;34minfo\033[0m:    ${text}."
        ;;
    esac
}