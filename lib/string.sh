#!/bin/bash

# Reset
reset='\033[0m'           # Text Reset

# Regular Colors
black='\033[0;30m'        # Black
red='\033[0;31m'          # Red
green='\033[0;32m'        # Green
yellow='\033[0;33m'       # Yellow
blue='\033[0;34m'         # Blue
purple='\033[0;35m'       # Purple
cyan='\033[0;36m'         # Cyan
white='\033[0;37m'        # White

# Bold
Bblack='\033[1;30m'       # Black
Bred='\033[1;31m'         # Red
Bgreen='\033[1;32m'       # Green
Byellow='\033[1;33m'      # Yellow
Bblue='\033[1;34m'        # Blue
Bpurple='\033[1;35m'      # Purple
Bcyan='\033[1;36m'        # Cyan
Bwhite='\033[1;37m'       # White

# Background
BGblack='\033[40m'        # Black
BGred='\033[41m'          # Red
BGgreen='\033[42m'        # Green
BGyellow='\033[43m'       # Yellow
BGblue='\033[44m'         # Blue
BGpurple='\033[45m'       # Purple
BGcyan='\033[46m'         # Cyan
BGwhite='\033[47m'        # White

string:allow() {
    if [[ "${1}" =~ ['\[!@#$ %^&*()+|?{}"=,;/£½'] ]] ; then
        return 1
    elif [[ "${1}" =~ "'" ]] ; then
        return 1
    elif [[ "${1}" = *"]"* ]] ; then
        return 1
    else
        return 0
    fi
}

string:str2int() {
    # translate string format to integer with multipication

    local i="" status="true" multiplier="100" divisive="10" value="0"

    if [[ -n "${1}" ]] ; then
        for i in ${1//./ } ; do
            if [[ "${i}" =~ ^[0-9]+$ ]] ; then
                if [[ "${multiplier}" -ge 1 ]] ; then
                    local value="$(( (multiplier * i) + value ))"
                    local multiplier="$(( multiplier / divisive ))"
                else
                    break
                fi
            else
                local status="false"
            fi
        done

        if [[ "${status}" = "true" ]] ; then
            echo "${value}"
        else
            echo -e "\t${0##*/}: ${FUNCNAME##*:}: parameters contain unsupported characters."
            return 2
        fi
    else
        echo -e "\t${0##*/}: ${FUNCNAME##*:}: insufficient parameter."
        return 1
    fi
}

string:stdoutput() {
    if [[ "${#}" -ge 2 ]] ; then
        case "${1}" in
            --error)
                echo -e "${Bred}${0##*/}${reset}: ${Bred}FAIL${reset}: ${2}!"
                if [[ "${3}" -ge 1 ]] && [[ "${3}" -le 255 ]] ; then
                    return "${3}"
                else
                    return "1"
                fi
            ;;
            --success)
                echo -e "${Bgreen}${0##*/}${reset}: ${Bgreen}SUCCESS${reset}: ${2}."
                return 0
            ;;
            --info)
                echo -e "${Bblue}${0##*/}${reset}: ${Bblue}INFO${reset}: ${2}."
            ;;
        esac
    else
        echo -e "\tinsufficient argument."
        return 1
    fi
}