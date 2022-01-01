#!/bin/bash

list:installedpkgs() {
    if [[ $(btb:call_value --base-number "${home}/${btb}") != 0 ]] 2> /dev/null ; then 
        btb:call_value --base-contain "${home}/${btb}" | tr -d "/"
    else
        tuiutil:notices --info "you haven't yet any packages"
    fi
}

list:repopkgs() {
    local nothing=""
    if [[ -d "${rep}" ]] ; then
        if [[ $(ls "${rep}" | wc -l) != 0 ]] ; then
            for Y in $(ls "${rep}") ; do
                echo "${Y}:"
                if [[ -f "${rep}/${Y}/packages.yaml" ]] ; then
                    for x in $(yaml:parse2bash:3 "${rep}/${Y}/packages.yaml" | tr "=" " " | tr "|" " " | grep packages_* | awk '{print $2}' | tr -d '"') ; do
                            echo -e "\t${x}${reset}"
                            local nothing="false"
                    done
                else
                    tuiutil:notices --error "${rep}/${Y} haven't packages.yaml file try '~$ hera --update'"
                fi
            done
        fi
    else
        tuiutil:notices --error "${home}/${rep} not found plese run '~# hera --fix'"
    fi

    if [[ -z "${nothing}" ]] ; then
        tuiutil:notices --info "you haven't yet update the catalogs type '~$ hera --update'"
    fi
}