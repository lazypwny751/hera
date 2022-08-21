#!/bin/bash

#    simple package manager written in bash - hera
#    Copyright (C) 2022  lazypwny751
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

# TODO:
#   Multi compression comptability for packages.
#   Optimize the code.

# BUGS:
#   No known bugs.

if [[ "${PATH}" = *com.termux* ]] ; then
    export root="/data/data/com.termux/files"
else
    export root=""
fi

export version="2.0.0" 
export DO="nothing" status="true" 
export CWD="${PWD}" SUSER="${SUDO_USER:-$USER}"
export BUILDOPT=() INSTOPT=() UNINSTOPT=() GETOPT=()
export conf="${root}/etc/herapkg.conf" libd="${root}/usr/share/hera/lib"
export librequire=(
    "string"
    "${root}/usr/local/lib/bash5/pdb.sh"
    "opshelper"
)

hera:source() {
    local i="" status="true"
    for i in ${@} ; do
        if [[ -f "${libd}/${i}.sh" ]] ; then
            source "${libd}/${i}.sh" || {
                echo -e "\tFAILURE: ${i##*/}.sh: Problem encountered while sourcing library."
                local status="false"
            }
        elif [[ -f "${libd}/${i}" ]] ; then
            source "${libd}/${i}" || {
                echo -e "\tFAILURE: ${i##*/}: the library could not be sourced."
                local status="false"
            }
        elif [[ -f "${i}" ]] ; then
            source "${i}" || {
                echo -e "\tFAILURE: ${i##*/}: the library could not be sourced."
                local status="false"
            }
        else
            echo -e "\tFAILURE: ${i##*/}: the library could not be sourced."
            local status="false"
        fi
    done

    if [[ "${status}" = "false" ]] ; then
        echo -e "\tFATAL: ${FUNCNAME##*:}: some libraries could not be sourced."
        return 1
    fi
}

# Source libraries
hera:source ${librequire[@]} || exit "${?}"

# Get configuration
if [[ -f "${root}${conf}" ]] ; then
    source "${root}${conf}" || {
        string:stdoutput --error "${conf##*/} could not sourcing"
        exit "${?}"
    }
else
    string:stdoutput --error "${conf##*/} not found"
    exit "${?}"
fi

# Initialize the tool.
export base="$(opshelper:define_base)"

opshelper:check --command "cpio" "rm" "mkdir" || {
    string:stdoutput --error "required program(s) not found"
    exit "${?}"
}

while [[ "${#}" -gt 0 ]] ; do
    case "${1}" in
        --[bB][uU][iI][lL][dD]|-[bB])
            shift
            export DO="build"

            while [[ "${#}" -gt 0 ]] ; do
                case "${1}" in
                    --*|-*)
                        break
                    ;;
                    *)
                        export BUILDOPT+=("$(opshelper:realpath "${1}")")
                        shift
                    ;;
                esac
            done
        ;;
        --[mM][oO][oO]|-[mM])
            shift
            export DO="cow"
        ;;
        --[vV][eE][rR][sS][iI][oO][nN]|-[vV])
            shift
            export DO="version"
        ;;
        *)
            shift
        ;;
    esac
done

case "${DO}" in
    build)
        export SHARED="" COUNTER="1"

        if [[ "${#BUILDOPT[@]}" -ge 1 ]] && opshelper:check --command "cpio" "find" ; then
            hera:source "packing"

            for opt in ${BUILDOPT[@]} ; do
                echo -ne "[${Bwhite}${COUNTER}${reset}] "
                string:stdoutput --info "looking for ${opt##*/}."
                packing:build "${opt}" && { 
                    string:stdoutput --success "the package builded successfully at '${SHARED}'"
                } || {
                    string:stdoutput --error "${opt##*/} could not be built correctly"
                    export status="false"
                }
                export COUNTER="$(( COUNTER + 1 ))"
            done
        elif [[ "${#BUILDOPT[@]}" -lt 1 ]] ; then
            string:stdoutput --error "insufficient argument"
            export status="false"
        else
            export status="false"
        fi
    ;;
    cow)
        echo -e " _____________
< Mo0 moOoo?! >
 -------------
        \   ^__^
         \  (..)\_______
            (__)\       )\/
                ||----w |
                ||     ||"
    ;;
    version)
        echo -e "${version}"
    ;;
    *)
        string:stdoutput --info "nothing will do, type '${0##*/} --help' for information"
        exit 0
    ;;
esac

if [[ "${status}" = "false" ]] ; then
    string:stdoutput --error "some things went wrong, the script did not work correctly"
    exit "${?}"
else
    exit 0
fi