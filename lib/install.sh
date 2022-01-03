#!/bin/bash

# yamlparser.sh, colorsh, osutils, banners, core and tuiutils libs required must be sourced

install:resolvosdep() {
    if yaml:parse2bash:3 "/${temp}/package.yaml" | grep "$(osutil:define --base)" &> /dev/null ; then    
        osutil:install "$(yaml:parse2bash:3 "/${temp}/package.yaml" | grep "$(osutil:define --base)" | tr "=" " " | tr -d '"' | awk '{print $2}')" || return 1
    fi

    if yaml:parse2bash:3 "/${temp}/package.yaml" | grep "python3_depends" &> /dev/null ; then    
        osutil:pip3 "$(yaml:parse2bash:3 "/${temp}/package.yaml" | grep "python3_depends" | tr "=" " " | tr -d '"' | awk '{print $2}')" || return 1
    fi

    if yaml:parse2bash:3 "/${temp}/package.yaml" | grep "ruby_depends" &> /dev/null ; then    
        osutil:gem "$(yaml:parse2bash:3 "/${temp}/package.yaml" | grep "ruby_depends" | tr "=" " " | tr -d '"' | awk '{print $2}')" || return 1
    fi
    return 0
}

install:package() {
    # ++++++++++[>+>+++>+++++++>++++++++++<<<<-]>>>>++++++++++++++++.------------.+.++++++++++.<<++.>>----------------.++++++++++++.-----------.+.<<.>>++++.++++++++++.<<.>>---.-.++++++++.------------------.+++++++++++++.-------------.-.<<.>>--.+++++++++++++++++++++++.<<.>>-----------------------.++++++++++++++++.-----------------.++++++++.+++++.--------.+++++++++++++++.------------------.++++++++.
    
    if [[ $(tar -ztf "${1}" | grep -w "package.yaml\|Makefile" | wc -l) = 2 ]] &> /dev/null ; then
        local package=""
        local version=""
        local maintainer=""
        local description=""
        local debian_depends=""
        local arch_depends=""
        local fedora_depends=""
        local opensuse_depends=""

        cp "${1}" "${temp}" 2> /dev/null
        cd "${temp}"
        tar -xf "${1}" ./
        yaml:parse2bash:3 "package.yaml" > package.sh
        . package.sh

        if [[ -n "${package}" ]] && [[ ! "${package}"  =~ ['!@#$%^&*()_+']  ]] && [[ ! "${package}" = *" "* ]] ; then
            if [[ -n "${version}" ]] && [[ "${version}" =~ ^[0-9]+([.][0-9]+)+([.][0-9]+)?$ ]] ; then
                if [[ -f "${home}/${btb}" ]] ; then
                    if btb:check --base "${home}/${btb}" "${package}" ; then
                        if version:isgreater "${version}" "$(btb:print --print "${home}/${btb}" "${package}" "version")" ; then
                            cd "${temp}"
                            mkdir "OLDMAKEFILE"
                            btb:print --print "${home}/${btb}" "${package}" "makecodec" | base64 -d > "${temp}/OLDMAKEFILE/Makefile"
                            cd "${temp}/OLDMAKEFILE"
                            make uninstall
                            btb:remove --base "${home}/${btb}" "${package}"
                            install:resolvosdep || { tuiutil:notices --error "some os dependcies found but could not installed" || return 1 ; }
                            cd "${temp}"
                            make install || { tuiutil:notices --error "Make program failed installation canceled" || return ; }
                            btb:generate --base "${home}/${btb}" "${package}"
                            btb:write --write "${home}/${btb}" "${package}" "version" "${version}"
                            btb:write --write "${home}/${btb}" "${package}" "makecodec" "$(cat "${temp}/Makefile" | base64)"
                        else
                            tuiutil:notices --info "${package} is already installed with newest version with $(btb:print --print "${home}/${btb}" "${package}" "version")"
                        fi
                    else
                        install:resolvosdep || { tuiutil:notices --error "some os dependcies found but could not installed" || return 1 ; }
                        cd "${temp}"
                        make install || { tuiutil:notices --error "Make program failed installation canceled" || return 1 ; }
                        btb:generate --base "${home}/${btb}" "${package}"
                        btb:write --write "${home}/${btb}" "${package}" "version" "${version}"
                        btb:write --write "${home}/${btb}" "${package}" "makecodec" "$(cat "${temp}/Makefile" | base64)"
                    fi
                else
                    tuiutil:notices --error "${btb} not found! please run '~# hera --fix'"
                fi
            else
                tuiutil:notices --error "package.yaml found but 'version' content not found" || return 1
            fi
        else
            tuiutil:notices --error "package content cannot contain special characters and spaces" || return 1
        fi
    else
        tuiutil:notices --error "${1} is not a hera package"
    fi
}

install:getpackage() {
    local nothingfound="false"
    export packagepath=""
    if [[ -d "${rep}" ]] ; then
        if [[ $(ls "${rep}" | wc -l) != 0 ]] ; then
            for Y in $(ls "${rep}") ; do
                if [[ -f "${rep}/${Y}/packages.yaml" ]] ; then
                    for x in $(yaml:parse2bash:3 "${rep}/${Y}/packages.yaml" | tr "=" " " | tr "|" " " | grep packages_* | awk '{print $2}' | tr -d '"') ; do
                        if [[ "${x}" = "${1}" ]] ; then
                            tuiutil:notices --info "${x} found in ${Y} downloading package.."
                            cd "${temp}"
                            wget -q "$(cat "${home}/${cat}" | grep -w "${Y}" | tr "|" " " | awk '{print $3}')$(yaml:parse2bash:3 "${rep}/${Y}/packages.yaml" | tr "=" " " | tr "|" " " | grep packages_* | grep -w "${x}" | awk '{print $4}' | tr -d '"')"
                            if [[ $? = 0 ]] ; then
                                export packagepath="${temp}$(yaml:parse2bash:3 "${rep}/${Y}/packages.yaml" | tr "=" " " | tr "|" " " | grep packages_* | grep -w "${x}" | awk '{print $4}' | tr -d '"')"
                            else
                                export packagepath=""
                            fi
                        fi
                    done
                else
                    tuiutil:notices --error "${rep}/${Y} haven't packages.yaml file try '~$ hera --update'"
                fi
            done
        else
            tuiutil:notices --error "you do not have a saved repository metadata please run '~$ hera --update'"
        fi
    else
        tuiutil:notices --error "${home}/${rep} not found plese run '~# hera --fix'"
    fi

    if [[ -z "${packagepath}" ]] ; then
        tuiutil:notices --error "no match found for ${1} in repositories or can not getting the package in this time"
    fi
}

install:install() {
    if [[ "${#}" -eq 1 ]] ; then
        if [[ $(file ${1} | grep "gzip compressed data") ]] ; then
            install:package "${1}"
        else
            install:getpackage "${1}"
            if [[ -n "${packagepath}" ]] ; then
                install:package "${packagepath}" || return 1
            fi
        fi 
    fi
}   