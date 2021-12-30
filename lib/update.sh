#!/bin/bash

update:catalogs() {
    if [[ -f "${home}/${cat}" ]] && [[ -d "${rep}" ]] ; then
        for i in $(yaml:parse2bash:3 "${home}/${cat}" | tr "=" " " | grep repositories_* | awk '{print $2}' | tr -d '"') ; do
            # Current Working Repo Directory
            local cwrd="$(echo "${i}" | tr "|" " " | awk '{print $1}')"
            # Current Working Repo Adress
            local cwra="$(echo "${i}" | tr "|" " " | awk '{print $2}')"
            if [[ -n "${cwrd}" ]] && [[ -n "${cwra}" ]] ; then
                cd "${temp}"
                wget -q "${cwra}/packages.yaml" 2> /dev/null
                if [[ "${?}" = 0 ]] ; then
                        if [[ -d "${rep}/${cwrd}" ]] ; then
                            if [[ "$(sha256sum "${rep}/${cwrd}/packages.yaml" | awk '{print $1}')" != "$(sha256sum ./packages.yaml | awk '{print $1}')" ]] ; then
                                cp ./packages.yaml "${rep}/${cwrd}"
                                tuiutil:notices --succsess "repository ${cwrd} updated"
                            else
                                tuiutil:notices --info "repository ${cwrd} is already up to date"
                            fi
                        else
                            mkdir -p "${rep}/${cwrd}" 2> /dev/null
                            cp ./packages.yaml "${rep}/${cwrd}"
                            tuiutil:notices --succsess "new repository ${cwrd} found"
                        fi
                else
                    tuiutil:notices --error "seems like a ${crwa} is not a hera repository"
                fi
            else
                tuiutil:notices --error "repository name and repository adress must be given"
            fi
        done
    else
        tuiutil:notices --error "${rep} or '${home}/repositories.yaml' not found"
    fi
}