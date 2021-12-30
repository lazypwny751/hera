#!/bin/bash

uninstall:package() {
    if btb:check --base "${home}/${btb}" "${1}" 2> /dev/null ; then
        cd "${temp}"
        mkdir "OLDMAKEFILE"
        btb:print --print "${home}/${btb}" "${1}" "makecodec" | base64 -d > "${temp}/OLDMAKEFILE/Makefile"
        cd "${temp}/OLDMAKEFILE"
        make uninstall
        btb:remove --base "${home}/${btb}" "${1}"
    else
        tuiutil:notices --info "${1} is not installed"
    fi
}