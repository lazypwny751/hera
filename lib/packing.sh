#!/bin/bash

# yamlparser.sh, colorsh, osutils, banners, core and tuiutils libs required must be sourced

packing:build() {
    local package=""
    local version=""
    local maintainer=""
    local description=""
    local debian_depends=""
    local arch_depends=""
    local fedora_depends=""
    local pisi_depends=""
    local opensuse_depends=""
    
    if [[ -f "${1}/package.yaml" ]] && [[ -f "${1}/Makefile" ]] ; then
        if cat "${1}/Makefile" | grep "install:" &> /dev/null ; then
            if cat "${1}/Makefile" | grep "uninstall:" &> /dev/null ; then
                if cat "${1}/package.yaml" | grep "package:" &> /dev/null ; then
                    if cat "${1}/package.yaml" | grep "version:" &> /dev/null ; then
                        yaml:parse2bash:3 "${1}/package.yaml" > "${temp}/package.sh"
                        . "${temp}/package.sh"
                        if [[ -n "${package}" ]] && [[ ! "${package}"  =~ ['!@#$%^&*()_+']  ]] && [[ ! "${package}" = *" "* ]] ; then
                            if [[ -n "${version}" ]] && [[ "${version}" =~ ^[0-9]+([.][0-9]+)+([.][0-9]+)?$ ]] ; then
                                if [[ -n "${is_arch}" ]] ; then
                                    tuiutil:notices --info "this package support ${is_arch} architecture machines"
                                fi

                                if [[ -n "${debian_depends_1}" ]] ; then
                                    tuiutil:notices --info "debian dependencities found"
                                fi

                                if [[ -n "${arch_depends_1}" ]] ; then
                                    tuiutil:notices --info "arch dependencities found"
                                fi

                                if [[ -n "${fedora_depends_1}" ]] ; then
                                    tuiutil:notices --info "fedora dependencities found"
                                fi

                                if [[ -n "${pisi_depends_1}" ]] ; then
                                    tuiutil:notices --info "pisi dependencities found"
                                fi

                                if [[ -n "${opensuse_depends_1}" ]] ; then
                                    tuiutil:notices --info "openSUSE dependencities found"
                                fi
                                
                                if [[ -n "${python3_1}" ]] ; then
                                    tuiutil:notices --info "python3 dependencities found"
                                fi

                                if [[ -n "${ruby_1}" ]] ; then
                                    tuiutil:notices --info "ruby dependencities found"
                                fi

                                cd "${1}"
                                tar -zcf "${cwd}/${package}-${version}.hera" ./* && tuiutil:notices --succsess "${package} builded as ${cwd}/${package}-${version}.hera"
                            else
                                tuiutil:notices --error "version content must be like a '1.0.0'" || return 1
                            fi
                        else
                            tuiutil:notices --error "package content cannot contain special characters and spaces" || return 1
                        fi
                    else
                        tuiutil:notices --error "package.yaml found but 'version' content not found" || return 1
                    fi
                else
                    tuiutil:notices --error "package.yaml found but the 'package' content not found" || return 1
                fi        
            else
                tuiutil:notices --error "Makefile found but the 'uninstall' content not defined" || return 1
            fi
        else
            tuiutil:notices --error "Makefile found but the 'install' content not defined" || return 1
        fi
    else
        tuiutil:notices --error "package.yaml or Makefile not found" || return 1
    fi
}