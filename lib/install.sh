#!/bin/bash

# yamlparser.sh, colorsh, osutils, banners, core and tuiutils libs required must be sourced

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
        local pisi_depends=""
        local opensuse_depends=""

        cp "${1}" "${temp}"
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
                            cd "${temp}"
                            make install || tuiutil:notices --error "Make program failed installation canceled"
                            btb:generate --base "${home}/${btb}" "${package}"
                            btb:write --write "${home}/${btb}" "${package}" "version" "${version}"
                            btb:write --write "${home}/${btb}" "${package}" "makecodec" "$(cat "${temp}/Makefile" | base64)"
                        else
                            tuiutil:notices --info "${package} is already installed with newest version with $(btb:print --print "${home}/${btb}" "${package}" "version")"
                        fi
                    else
                        cd "${temp}"
                        make install || tuiutil:notices --error "Make program failed installation canceled"
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
    if [[ -d "${home}/${rep}" ]] ; then
        if [[ $(ls "${home}/${rep}") != 0 ]] ; then
            for i in ls "${home}/${rep}" ; do
                if [[ -f "${home}/${rep}/${i}/packages.yaml" ]] ; then
                    yaml:parse2bash:3 "${home}/${rep}/${i}/packages.yaml"
                    for x in $(yaml:parse2bash:3 "${home}/${cat}" | tr "=" " " | grep packages_* | awk '{print $1}' | tr -d '"') ; do
                        if [[ "${x}" = "${1}" ]] ; then
                            echo "${x} found in ${i}"
                        fi
                    done
                else
                    tuiutil:notices --error "${i} haven't packages.yaml file try"
                fi
            done
        else
            tuiutil:notices --error "you do not have a saved repository metadata please run '~$ hera --update'"
        fi
    else
        tuiutil:notices --error "${home}/${rep} not found plese run '~# hera --fix'"
    fi
}

install:install() {
    :
}