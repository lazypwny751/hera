#!/bin/bash

#    data storage manager - bash text bank 1.0.0
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

# Define Variables
btb_file_extension="btb"
btb_cwd="${PWD}"
btb_name="$(basename "${BASH_SOURCE[0]}")"

_file-name() {
    # Alternative filename function
    # If the filename command is not installed
    # This function without the need to install packages
    # get an alternative parser with we will.

    if [[ "${#}" -gt 0 ]] ; then
        if ! command -v filename &> /dev/null ; then
            for y in $(seq 1 ${#}) ; do
                echo ${@:y:1} | tr "/" " " | awk '{print $NF}'
            done
        else
            filename ${@}
        fi
    else
        echo -e "Usage: Enter 1 parameter file/directory path. Sample\n> _file-name /tmp/test/test.sh\n< test.sh"
        return 1
    fi
}

_btbui() {
    case "${1}" in
        [fF][aA][tT][aA][lL]|--[fF][aA][tT][aA][lL]|-[fF])
            echo -e "\033[1;31mFatal: ${2}!\033[0m"
            return 1
        ;;
        [eE][rR][rR][oO][rR]|--[eE][rR][rR][oO][rR]|-[eE])
            echo -e "\033[1;31merror\033[0m: ${2}.\033[0m"
            [[ ! -z "${3}" ]] && return "${3}"
        ;;
        [sS][uU][cC][cC][sS][eE][sS][sS]|--[sS][uU][cC][cC][sS][eE][sS][sS]|-[sS])
            echo -e "\033[1;32msuccsess\033[0m: ${2}.\033[0m"
        ;;
        [iI][nN][fF][oO]|--[iI][nN][fF][oO]|-[iI])
            echo -e "\033[1;35minfo\033[0m: ${2}.\033[0m"
        ;;
    esac
}

# Bash Text Bank Tmp Manager
_btbtmpm() {
    case "${1}" in
        [oO][pP][eE][nN]|--[oO][pP][eE][nN]|-[oO])
            if ! [[ -d "/tmp/${btb_name}" ]] ; then
                mkdir -p "/tmp/${btb_name}" || _btbui --fatal "${btb_name} could not creating"
            fi
        ;;
        [cC][lL][oO][sS][eE]|--[cC][lL][oO][sS][eE]|-[cC])
            if [[ -d "/tmp/${btb_name}" ]] ; then
                [[ "${PWD}" = "/tmp/${btb_name}" ]] && cd "${btb_cwd}" || error "Could not closing so may it lose your current path please remove '/tmp/${btb_name}' manually" "1"
                rm -rf "/tmp/${btb_name}" || _btbui --fatal "${btb_name} could not removed"
            fi
        ;;
        [cC][oO][mM][pP][rR][eE][sS][sS]|--[cC][oO][mM][pP][rR][eE][sS][sS]|-[cC][rR])
            if [[ -f "/tmp/${btb_name}/metafile" ]] ; then
                cd "/tmp/${btb_name}" || return 1 # change directory to btb temp dir
                . metafile # source the bank metadata file
                tar -zcf "${btb_cwd}/${btb_bank}.${btb_file_extension}" ./* && _btbui --succsess "${btb_bank} compressed" || _btbui --error "the bank is can not compressing" "1"
                rm -rf "/tmp/${btb_name}" # remove old dir
                cd "${btb_cwd}" || return 1 # change directory to current working directory
            else
                _btbui --error "metafile not found" "1"
            fi
        ;;
        [eE][xX][tT][rR][aA][cC][tT]|--[eE][xX][tT][rR][aA][cC][tT]|-[eE])
            if [[ $(file "${2}" | grep "gzip compressed data") ]] && [[ ! -d "/tmp/${btb_name}" ]] ; then
                mkdir -p "/tmp/${btb_name}" && cp "${2}" "/tmp/${btb_name}" || _btbui --fatal "${btb_name} could not creating"
                cd "/tmp/${btb_name}" || return 1
                tar -xf "$(_file-name "${2}")" # extract old bank
                rm "$(_file-name "${2}")" # remove old bank
                . metafile # source the metadata file of bank
            fi
        ;;
    esac
}

# Define Functions
_req:btb() {
    _btbtmpm --close
    if ! [[ $(command -v gzip) ]] ; then
        echo "gzip not found!"
        return 1
    fi

    if ! [[ $(command -v tar) ]] ; then
        echo "tar not found!"
        return 1
    fi
}

_req:btb

# Generate bank, base, data (null)
btb:generate() {
    case "${1}" in
        [bB][aA][nN][kK]|--[bB][aA][nN][kK]|-[bB])
            [[ -z "${2}" ]] && btb_bank="artemis" || btb_bank="${2}"
            _btbtmpm --open
            echo "btb_bank='${btb_bank}'" > "/tmp/${btb_name}/metafile"
            _btbtmpm --compress
        ;;
        [bB][aA][sS][eE]|--[bB][aA][sS][eE]|-[bB])
            if [[ $(tar -ztf "${2}" | grep -w "metafile") ]] 2> /dev/null && [[ "${#}" -ge 3 ]] ; then
                _btbtmpm --extract "${2}"
                for i in ${@:3} ; do
                    if [[ ! -d ./"${i}" ]] ; then
                        mkdir "${i}" 2> /dev/null && _btbui --succsess "${i} created"
                    else
                        _btbui --info "${i} is already exist"
                    fi
                done
                _btbtmpm --compress
            else
                if [[ "${#}" -lt 3 ]] ; then
                    _btbui --error "wrong argument usage" "1"
                else
                    _btbui --error "the file ${2} isn't bash text bank" "1"
                fi
            fi
        ;;
        [dD][aA][tT][aA]|--[dD][aA][tT][aA]|-[dD])
            if [[ $(tar -ztf "${2}" | grep -w "metafile") ]] 2> /dev/null && [[ "${#}" -ge 4 ]] ; then
                _btbtmpm --extract "${2}"
                if [[ -d ./"${3}" ]] ; then
                    for i in ${@:4} ; do
                        if [[ ! -f ./"${3}/${i}" ]] ; then
                            touch "${3}/${i}" 2> /dev/null && _btbui --succsess "${3}@${i} created"
                        else
                            _btbui --info "${3}@${i} is already exist"
                        fi
                    done
                else
                    _btbui --error "The base ${3} is not exist"
                fi
                _btbtmpm --compress
            else
                if [[ "${#}" -lt 4 ]] ; then
                    _btbui --error "wrong argument usage" "1"
                else
                    _btbui --error "the file ${2} isn't bash text bank" "1"
                fi
            fi
        ;;
        [hH][eE][lL][pP]|--[hH][eE][lL][pP]|-[hH])
            echo "Wiht the function '${FUNCNAME[0]}' you can create 'bank', 'base' and null 'data'

${FUNCNAME[0]} --bank <bank name>:
    creates the main data retention file.

${FUNCNAME[0]} --base <bank file name> <base 1> <base 2> <base 3>..:
    creates tables can be used with multi parameters.

${FUNCNAME[0]} --data <bank file name> <base name> <data 1> <data 2> <data 3>..:
    Creates files to store data inside the tables can be used with multi parameters.
"
        ;;
        *)
            echo "Wrong usage: Type '${FUNCNAME[0]} --help' to learn more information."
            return 1
        ;;
    esac
}

# Generate and write, rewrite or add tail of data 
btb:write() {
    case "${1}" in
        [wW][rR][iI][tT][eE]|--[wW][rR][iI][tT][eE]|-[wW])
            if [[ $(tar -ztf "${2}" | grep -w "metafile") ]] 2> /dev/null && [[ "${#}" -ge 4  ]] ; then
                _btbtmpm --extract "${2}"
                if [[ -d "${3}" ]] ; then
                    if [[ -f "${3}/${4}" ]] ; then
                        if [[ ! -z "${5}" ]] ; then
                            echo "${5}" > "${3}/${4}" && _btbui --succsess "${4}@${3} re-writed" || _btbui --error "could not re-writting in this time" "1"
                        else
                            echo "" > "${3}/${4}" && _btbui --succsess "${4}@${3} re-generated" || _btbui --error "could not re-generating in this time" "1"
                        fi
                    else
                        if [[ ! -z "${5}" ]] ; then
                            echo "${5}" > "${3}/${4}" && _btbui --succsess "${4}@${3} writed" || _btbui --error "could not writting in this time" "1"
                        else
                            echo "" > "${3}/${4}" && _btbui --succsess "${4}@${3} generated" || _btbui --error "could not generating in this time" "1"
                        fi
                    fi
                else
                    _btbui --error "The base ${3} is not exist"
                fi
                _btbtmpm --compress
            else
                if [[ "${#}" -lt 4 ]] ; then
                    _btbui --error "wrong argument usage" "1"
                else
                    _btbui --error "the file ${2} isn't bash text bank" "1"
                fi
            fi
        ;;
        [aA][dD][dD]-[tT][aA][iI][lL]|--[aA][dD][dD]-[tT][aA][iI][lL]|-[aA])
            if [[ $(tar -ztf "${2}" | grep -w "metafile") ]] 2> /dev/null && [[ "${#}" -ge 4 ]] ; then
                _btbtmpm --extract "${2}"
                if [[ -f "${3}/${4}" ]] ; then
                    if [[ ! -z "${5}" ]] ; then
                        echo "${5}" >> "${3}/${4}" && _btbui --succsess "${4}@${3} added to tail" || _btbui --error "could not adding to tail in this time" "1"
                    else
                        _btbui --info "There is nothing to add data"
                    fi
                else
                    _btbui --error "The data ${4} is not exist"
                fi
                _btbtmpm --compress
            else
                if [[ "${#}" -lt 4 ]] ; then
                    _btbui --error "wrong argument usage" "1"
                else
                    _btbui --error "the file ${2} isn't bash text bank" "1"
                fi
            fi
        ;;
        [hH][eE][lL][pP]|--[hH][eE][lL][pP]|-[hH])
            echo "With the fuction ${FUNCNAME[0]} you can use 'write' and 'add-tail':
${FUNCNAME[0]} --write <bashtextbank.btb> <base> <data> 'string value':
    If the string value author is used with a single parameter, 
    it is rewritten that file if it is used more than once in the same file.

${FUNCNAME[0]} --add-tail <bashtextbank.btb> <base> <data> 'string value':
    Prints the string value inside the data, can be used with a single parameter, 
    adding the lakin to the end of the file to the bottom bottom.
"
        ;;
        *)
            echo "Wrong usage: Type '${FUNCNAME[0]} --help' to learn more information."
            return 1
        ;;
    esac
}

# Remove base or data
btb:remove() {
    case "${1}" in
        [bB][aA][sS][eE]|--[bB][aA][sS][eE]|-[bB])
            if [[ $(tar -ztf "${2}" | grep -w "metafile") ]] 2> /dev/null && [[ "${#}" -ge 3 ]] ; then
                _btbtmpm --extract "${2}"
                for i in ${@:3} ; do
                    if [[ -d "${i}" ]] ; then
                        rm -rf "${i}" && _btbui --succsess "${i} removed" || _btbui --error "${i} could not removing in this time" 
                    else
                        _btbui --info "${i} is already removed"
                    fi
                done
                _btbtmpm --compress
            else
                if [[ "${#}" -lt 4 ]] ; then
                    _btbui --error "wrong argument usage" "1"
                else
                    _btbui --error "the file ${2} isn't bash text bank" "1"
                fi
            fi
        ;;
        [dD][aA][tT][aA]|--[dD][aA][tT][aA]|-[dD])
            if [[ $(tar -ztf "${2}" | grep -w "metafile") ]] 2> /dev/null && [[ "${#}" -ge 4 ]] ; then
                _btbtmpm --extract "${2}"
                if [[ -d "${3}" ]] ; then
                    for i in ${@:4} ; do
                        if [[ -f "${3}/${i}" ]] ; then
                            rm "${3}/${i}" && _btbui --succsess "${i} removed in ${3}" || _btbui --error "${i} could not removing in this time"
                        else
                            _btbui --info "The data ${i} is already removed"
                        fi
                    done
                else
                    _btbui --error "The base ${3} isn't exist" "1"
                fi
                _btbtmpm --compress
            else
                if [[ "${#}" -lt 4 ]] ; then
                    _btbui --error "wrong argument usage" "1"
                else
                    _btbui --error "the file ${2} isn't bash text bank" "1"
                fi
            fi
        
        ;;
        [hH][eE][lL][pP]|--[hH][eE][lL][pP]|-[hH])
            echo "With the fuction ${FUNCNAME[0]} you can remove 'base' or 'data':
${FUNCNAME[0]} --base <bashtextbank.btb> <base1> <base2> <base3>..:
    Used to delete tables, it is open to multi-parameter use.

${FUNCNAME[0]} --data <bashtextbank.btb> <base> <data1> <data2> <data3>..:
    Used to delete datas in a particular base, it is open to multiple use.
"
        ;;
        *)
            echo "Wrong usage: Type '${FUNCNAME[0]} --help' to learn more information."
            return 1
        ;;
    esac
}

# Check if exist base or data
btb:check() {
    case "${1}" in
        [bB][aA][sS][eE]|--[bB][aA][sS][eE]|-[bB])
            if [[ $(tar -ztf "${2}" | grep -w "metafile") ]] 2> /dev/null && [[ "${#}" -ge 3 ]] ; then
                _btbtmpm --extract "${2}"
                if [[ -d ./"${3}" ]] ; then
                    return 0
                else
                    _btbtmpm --close
                    return 1
                fi
                _btbtmpm --compress
            else
                if [[ "${#}" -lt 4 ]] ; then
                    _btbui --error "wrong argument usage" "1"
                else
                    _btbui --error "the file ${2} isn't bash text bank" "1"
                fi
            fi
        ;;
        [dD][aA][tT][aA]|--[dD][aA][tT][aA]|-[dD])
            if [[ $(tar -ztf "${2}" | grep -w "metafile") ]] 2> /dev/null && [[ "${#}" -ge 4 ]] ; then
                _btbtmpm --extract "${2}"
                if [[ -f ./"${3}/${4}" ]] ; then
                    return 0
                else
                    _btbtmpm --close
                    return 1
                fi
                _btbtmpm --compress
            else
                if [[ "${#}" -lt 4 ]] ; then
                    _btbui --error "wrong argument usage" "1"
                else
                    _btbui --error "the file ${2} isn't bash text bank" "1"
                fi
            fi
        ;;
        [hH][eE][lL][pP]|--[hH][eE][lL][pP]|-[hH])
            echo "With the fuction ${FUNCNAME[0]} you can check if exist 'base' and 'data':
${FUNCNAME[0]} --base <bashtextbank.btb> <base>:
    checks the presence of a table, the result is sent to stin or sterr at the exit.

${FUNCNAME[0]} --data <bashtextbank.btb> <base> <data>:
    checks for the presence of the data in a table, the result is sent to stin or sterr at the exit.
"
        ;;
        *)
            echo "Wrong usage: Type '${FUNCNAME[0]} --help' to learn more information."
            return 1
        ;;
    esac
}

# Print if exist data
btb:print() {
    case "${1}" in
            [pP][rR][iI][nN][tT]|--[pP][rR][iI][nN][tT]|-[pP])
            if [[ $(tar -ztf "${2}" | grep -w "metafile") ]] 2> /dev/null && [[ "${#}" -ge 4 ]] ; then
                _btbtmpm --extract "${2}"
                if [[ -f ./"${3}/${4}" ]] ; then
                    cat ./"${3}/${4}"
                else
                    _btbtmpm --close
                    return 1
                fi
                _btbtmpm --compress
            else
                if [[ "${#}" -lt 4 ]] ; then
                    _btbui --error "wrong argument usage" "1"
                else
                    _btbui --error "the file ${2} isn't bash text bank" "1"
                fi
            fi
        ;;
        [hH][eE][lL][pP]|--[hH][eE][lL][pP]|-[hH])
            echo "With the fuction ${FUNCNAME[0]} you can use 'print':
${FUNCNAME[0]} --print <bashtextbank.btb> <base> <data>:
    shows the content written in a data.
"
        ;;
        *)
            echo "Wrong usage: Type '${FUNCNAME[0]} --help' to learn more information."
            return 1
        ;;
    esac
}

# Call base number, data number, list base and list data
btb:call_value() {
    case "${1}" in
        [bB][aA][sS][eE]-[nN][uU][mM][bB][eE][rR]|--[bB][aA][sS][eE]-[nN][uU][mM][bB][eE][rR]|-[bB][nN])
            if [[ $(tar -ztf "${2}" | grep -w "metafile") ]] 2> /dev/null && [[ "${#}" -ge 2 ]] ; then
                _btbtmpm --extract "${2}"
                ls -d */ | wc -l
                _btbtmpm --compress
            else
                if [[ "${#}" -lt 3 ]] ; then
                    _btbui --error "wrong argument usage" "1"
                else
                    _btbui --error "the file ${2} isn't bash text bank" "1"
                fi
            fi
        ;;
        [dD][aA][tT][aA]-[nN][uU][mM][bB][eE][rR]|--[bB][aA][sS][eE]-[nN][uU][mM][bB][eE][rR]|-[dD][nN])
            if [[ $(tar -ztf "${2}" | grep -w "metafile") ]] 2> /dev/null && [[ "${#}" -ge 3 ]] ; then
                _btbtmpm --extract "${2}"
                if [[ -d ./"${3}" ]] ; then
                    ls -p "${3}" | grep -v / | wc -l
                else
                    _btbtmpm --close
                    return 1
                fi
                _btbtmpm --compress
            else
                if [[ "${#}" -lt 4 ]] ; then
                    _btbui --error "wrong argument usage" "1"
                else
                    _btbui --error "the file ${2} isn't bash text bank" "1"
                fi
            fi
        ;;
        [bB][aA][sS][eE]-[cC][oO][nN][tT][aA][iI][nN]|--[bB][aA][sS][eE]-[cC][oO][nN][tT][aA][iI][nN]|-[bB][cC])
            if [[ $(tar -ztf "${2}" | grep -w "metafile") ]] 2> /dev/null && [[ "${#}" -ge 2 ]] ; then
                _btbtmpm --extract "${2}"
                ls -d */
                _btbtmpm --compress
            else
                if [[ "${#}" -lt 3 ]] ; then
                    _btbui --error "wrong argument usage" "1"
                else
                    _btbui --error "the file ${2} isn't bash text bank" "1"
                fi
            fi
        ;;
        [dD][aA][tT][aA]-[cC][oO][nN][tT][aA][iI][nN]|-[dD][aA][tT][aA]--[cC][oO][nN][tT][aA][iI][nN]|-[dD][cC])
            if [[ $(tar -ztf "${2}" | grep -w "metafile") ]] 2> /dev/null && [[ "${#}" -ge 3 ]] ; then
                _btbtmpm --extract "${2}"
                if [[ -d ./"${3}" ]] ; then
                    ls -p "${3}" | grep -v /
                else
                    _btbtmpm --close
                    return 1
                fi
                _btbtmpm --compress
            else
                if [[ "${#}" -lt 4 ]] ; then
                    _btbui --error "wrong argument usage" "1"
                else
                    _btbui --error "the file ${2} isn't bash text bank" "1"
                fi
            fi
        ;;
        [hH][eE][lL][pP]|--[hH][eE][lL][pP]|-[hH])
            echo "With the fuction ${FUNCNAME[0]} you can call 'base-number', 'data-number', 'base-contain' and 'data-contain':
${FUNCNAME[0]} --base-number <bashtextbank.btb>:
    shows the number of tables available.

${FUNCNAME[0]} --data-number <bashtextbank.btb> <base>:
    shows the number of data in a table.

${FUNCNAME[0]} --base-contain <bashtextbank.btb>:
    shows the names of the existing tables.

${FUNCNAME[0]} --data-contain <bashtextbank.btb> <base>:
    shows the names of the data in a table drinker.
"
        ;;
        *)
            echo "Wrong usage: Type '${FUNCNAME[0]} --help' to learn more information."
            return 1
        ;;
    esac
}