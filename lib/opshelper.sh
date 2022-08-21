#!/bin/bash

opshelper:is_root() {
    if [[ "${UID}" = 0 ]] ; then
        return 0
    else
        return 1
    fi
}

opshelper:is_arch() {
    local i="" status="false"

    if [[ "${#}" -ge "1" ]] ; then
        if command -v "uname" &> /dev/null ;  then
            for i in ${@} ; do
                if [[ "${i}" = "$(umane -m)" ]] ; then
                    local status="true"
                fi
            done

            if [[ "${status}" = "true" ]] ; then
                return 0
            else
                return 3
            fi
        else
            echo -e "\t${0##*/}: ERROR: ${FUNCNAME##*:}: 'uname' is required but not found."
            return 2
        fi
    else
        echo -e "\t${0##*/}: ERROR: ${FUNCNAME##*:}: insufficient parameters."
        1
    fi
}

opshelper:define_base() {
    if [[ "${PATH}" = *com.termux* ]] ; then
        echo "termux"
    elif [[ -f "${root}/etc/debian_version" ]] ; then
        echo "debian"
    elif [[ -f "${root}/etc/arch-release" ]] ; then
        echo "arch"
    elif [[ -f "${root}/etc/zypp/zypp.conf" ]] ; then
        echo "opensuse"
    else
        echo "unknown"
    fi
}

opshelper:native_pm() {
    local DO="" status="true"

    if [[ "${PATH}" = *com.termux* ]] ; then
        local base="termux"
    elif [[ -f "${root}/etc/debian_version" ]] ; then
        local base="debian"
    elif [[ -f "${root}/etc/arch-release" ]] ; then
        local base="arch"
    elif [[ -f "${root}/etc/zypp/zypp.conf" ]] ; then
        local base="opensuse"
    else
        local base="unknown"
    fi

    while [[ "${#}" -gt 0 ]] ; do
        case "${1}" in
            --install|-in)
                # install packages
                shift
                local DO="install"
                while [[ "${#}" -gt 0 ]] ; do
                    case "${1}" in
                        --*|-*)
                            break
                        ;;
                        *)
                            local INSTOPT+=("${1}")
                            shift
                        ;;
                    esac
                done
            ;;
            --uninstall|-un)
                # uninstall packages
                shift
                local DO="uninstall"
                while [[ "${#}" -gt 0 ]] ; do
                    case "${1}" in
                        --*|-*)
                            break
                        ;;
                        *)
                            local UNINSTOPT+=("${1}")
                            shift
                        ;;
                    esac
                done
            ;;
            --update|-up)
                # update catalogs
                shift
                local DO="update"
            ;;
            --base|-ba)
                # set default base
                shift
                if [[ -n "${1}" ]] ; then
                    local base="${1}"
                    shift
                fi
            ;;
            *)
                shift
            ;;
        esac
    done

    # there is a bloat code but the concept need it:
    # it can be fixed untill new wersion, can anybody make that code
    # functionalized ->

    case "${base}" in
        termux)
            case "${DO}" in
                install)
                    echo -e "\t\033[1;37m==>\033[0m \033[0;34minstalling\033[0m ${#INSTOPT[@]} packages for ${base}..."
                    apt install -y ${INSTOPT[@]} &> /dev/null && {
                        echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m installed that ${#INSTOPT[@]} package for ${base}."
                        return 0
                    } || {
                        echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to install that packages of ${base}."
                        return 1
                    }                    
                ;;
                uninstall)
                    echo -e "\t\033[1;37m==>\033[0m \033[0;34mremoving\033[0m ${#INSTOPT[@]} packages in ${base}..."
                    apt remove -y ${INSTOPT[@]} &> /dev/null && {
                        echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m removed that ${#INSTOPT[@]} package in ${base}."
                        return 0
                    } || {
                        echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to remove that packages of ${base}."
                        return 1
                    }
                ;;
                update)
                    echo -e "\t\033[1;37m==>\033[0m started to \033[0;34mupdate\033[0m catalogs for ${base}..."
                    apt update &> /dev/null && {
                        echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m updated ${base}."
                        return 0   
                    } || {
                        echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to update ${base}."
                        return 1
                    }
                ;;
            esac
        ;;
        debian)
            case "${DO}" in
                install)
                    if [[ "${UID}" = 0 ]] ; then
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34minstalling\033[0m ${#INSTOPT[@]} packages for ${base}..."
                        apt install -y ${INSTOPT[@]} &> /dev/null && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m installed that ${#INSTOPT[@]} package for ${base}."
                            return 0
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to remove that packages of ${base}."
                            return 1
                        }
                    elif command -v "sudo" &> /dev/null ; then   
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34minstalling\033[0m ${#INSTOPT[@]} packages for ${base}..."
                        sudo apt install -y ${INSTOPT[@]} && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m installed that ${#INSTOPT[@]} package for ${base}."
                            return 0
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to remove that packages of ${base}."
                            return 1
                        }
                    elif command -v "doas" &> /dev/null ; then
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34minstalling\033[0m ${#INSTOPT[@]} packages for ${base}..."
                        doas apt install -y ${INSTOPT[@]} && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m installed that ${#INSTOPT[@]} package for ${base}."
                            return 0
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to remove that packages of ${base}."
                            return 1
                        }
                    else
                        echo -e "\t\033[1;37m==>\033[0m ${FUNCNAME##*:} \033[0;31mneeds to have\033[0m root privalages, please run it as root."
                        return 2
                    fi
                ;;
                uninstall)
                    if [[ "${UID}" = 0 ]] ; then
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34mremoving\033[0m ${#UNINSTOPT[@]} packages from ${base}..."
                        apt remove -y ${UNINSTOPT[@]} &> /dev/null && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m removed that ${#UNINSTOPT[@]} package in ${base}."
                            return 0   
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to install that packages of ${base}."
                            return 1
                        }
                    elif command -v "sudo" &> /dev/null ; then   
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34mremoving\033[0m ${#UNINSTOPT[@]} packages from ${base}..."
                        sudo apt remove -y ${UNINSTOPT[@]} && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m removed that ${#UNINSTOPT[@]} package in ${base}."
                            return 0   
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to install that packages of ${base}."
                            return 1
                        }
                    elif command -v "doas" &> /dev/null ; then
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34mremoving\033[0m ${#UNINSTOPT[@]} packages in ${base}..."
                        doas apt remove -y ${UNINSTOPT[@]} && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m removed that ${#UNINSTOPT[@]} package in ${base}."
                            return 0
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to install that packages of ${base}."
                            return 1
                        }
                    else
                        echo -e "\t\033[1;37m==>\033[0m ${FUNCNAME##*:} \033[0;31mneeds to have\033[0m root privalages, please run it as root."
                        return 2
                    fi
                ;;
                update)
                    if [[ "${UID}" = 0 ]] ; then
                        echo -e "\t\033[1;37m==>\033[0m started to \033[0;34mupdate\033[0m catalogs for ${base}..."
                        apt update &> /dev/null && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m updated ${base}."
                            return 0   
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to update ${base}."
                            return 1
                        }
                    elif command -v "sudo" &> /dev/null ; then   
                        echo -e "\t\033[1;37m==>\033[0m started to \033[0;34mupdate\033[0m catalogs for ${base}..."
                        sudo apt update && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m updated ${base}."
                            return 0   
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to update ${base}."
                            return 1
                        }
                    elif command -v "doas" &> /dev/null ; then
                        echo -e "\t\033[1;37m==>\033[0m started to \033[0;34mupdate\033[0m catalogs for ${base}..."
                        doas apt update && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m updated ${base}."
                            return 0
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to update ${base}."
                            return 1
                        }
                    else
                        echo -e "\t\033[1;37m==>\033[0m ${FUNCNAME##*:} \033[0;31mneeds to have\033[0m root privalages, please run it as root."
                        return 2
                    fi
                ;;
            esac
        ;;
        arch)
            case "${DO}" in
                install)
                    if [[ "${UID}" = 0 ]] ; then
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34minstalling\033[0m ${#INSTOPT[@]} packages for ${base}..."
                        pacman -S --noconfirm ${INSTOPT[@]} &> /dev/null && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m installed that ${#INSTOPT[@]} package for ${base}."
                            return 0
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to remove that packages of ${base}."
                            return 1
                        }
                    elif command -v "sudo" &> /dev/null ; then   
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34minstalling\033[0m ${#INSTOPT[@]} packages for ${base}..."
                        sudo pacman -S --noconfirm ${INSTOPT[@]} && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m installed that ${#INSTOPT[@]} package for ${base}."
                            return 0
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to remove that packages of ${base}."
                            return 1
                        }
                    elif command -v "doas" &> /dev/null ; then
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34minstalling\033[0m ${#INSTOPT[@]} packages for ${base}..."
                        doas pacman -S --noconfirm ${INSTOPT[@]} && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m installed that ${#INSTOPT[@]} package for ${base}."
                            return 0
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to remove that packages of ${base}."
                            return 1
                        }
                    else
                        echo -e "\t\033[1;37m==>\033[0m ${FUNCNAME##*:} \033[0;31mneeds to have\033[0m root privalages, please run it as root."
                        return 2
                    fi
                ;;
                uninstall)
                    if [[ "${UID}" = 0 ]] ; then
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34mremoving\033[0m ${#UNINSTOPT[@]} packages from ${base}..."
                        pacman -R --noconfirm ${UNINSTOPT[@]} &> /dev/null && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m removed that ${#UNINSTOPT[@]} package in ${base}."
                            return 0   
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to install that packages of ${base}."
                            return 1
                        }
                    elif command -v "sudo" &> /dev/null ; then   
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34mremoving\033[0m ${#UNINSTOPT[@]} packages from ${base}..."
                        sudo pacman -R --noconfirm ${UNINSTOPT[@]} && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m removed that ${#UNINSTOPT[@]} package in ${base}."
                            return 0   
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to install that packages of ${base}."
                            return 1
                        }
                    elif command -v "doas" &> /dev/null ; then
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34mremoving\033[0m ${#UNINSTOPT[@]} packages in ${base}..."
                        doas pacman -R --noconfirm ${UNINSTOPT[@]} && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m removed that ${#UNINSTOPT[@]} package in ${base}."
                            return 0
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to install that packages of ${base}."
                            return 1
                        }
                    else
                        echo -e "\t\033[1;37m==>\033[0m ${FUNCNAME##*:} \033[0;31mneeds to have\033[0m root privalages, please run it as root."
                        return 2
                    fi
                ;;
                update)
                    if [[ "${UID}" = 0 ]] ; then
                        echo -e "\t\033[1;37m==>\033[0m started to \033[0;34mupdate\033[0m catalogs for ${base}..."
                        pacman -Syy &> /dev/null && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m updated ${base}."
                            return 0   
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to update ${base}."
                            return 1
                        }
                    elif command -v "sudo" &> /dev/null ; then   
                        echo -e "\t\033[1;37m==>\033[0m started to \033[0;34mupdate\033[0m catalogs for ${base}..."
                        sudo pacman -Syy && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m updated ${base}."
                            return 0   
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to update ${base}."
                            return 1
                        }
                    elif command -v "doas" &> /dev/null ; then
                        echo -e "\t\033[1;37m==>\033[0m started to \033[0;34mupdate\033[0m catalogs for ${base}..."
                        doas pacman -Syy && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m updated ${base}."
                            return 0
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to update ${base}."
                            return 1
                        }
                    else
                        echo -e "\t\033[1;37m==>\033[0m ${FUNCNAME##*:} \033[0;31mneeds to have\033[0m root privalages, please run it as root."
                        return 2
                    fi
                ;;
            esac
        ;;
        opensuse)
            case "${DO}" in
                install)
                    if [[ "${UID}" = 0 ]] ; then
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34minstalling\033[0m ${#INSTOPT[@]} packages for ${base}..."
                        zypper --non-interactive install ${INSTOPT[@]} &> /dev/null && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m installed that ${#INSTOPT[@]} package for ${base}."
                            return 0
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to remove that packages of ${base}."
                            return 1
                        }
                    elif command -v "sudo" &> /dev/null ; then   
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34minstalling\033[0m ${#INSTOPT[@]} packages for ${base}..."
                        sudo zypper --non-interactive install ${INSTOPT[@]} && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m installed that ${#INSTOPT[@]} package for ${base}."
                            return 0
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to remove that packages of ${base}."
                            return 1
                        }
                    elif command -v "doas" &> /dev/null ; then
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34minstalling\033[0m ${#INSTOPT[@]} packages for ${base}..."
                        doas zypper --non-interactive install ${INSTOPT[@]} && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m installed that ${#INSTOPT[@]} package for ${base}."
                            return 0
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to remove that packages of ${base}."
                            return 1
                        }
                    else
                        echo -e "\t\033[1;37m==>\033[0m ${FUNCNAME##*:} \033[0;31mneeds to have\033[0m root privalages, please run it as root."
                        return 2
                    fi
                ;;
                uninstall)
                    if [[ "${UID}" = 0 ]] ; then
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34mremoving\033[0m ${#UNINSTOPT[@]} packages from ${base}..."
                        zypper --non-interactive remove ${UNINSTOPT[@]} &> /dev/null && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m removed that ${#UNINSTOPT[@]} package in ${base}."
                            return 0   
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to install that packages of ${base}."
                            return 1
                        }
                    elif command -v "sudo" &> /dev/null ; then   
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34mremoving\033[0m ${#UNINSTOPT[@]} packages from ${base}..."
                        sudo zypper --non-interactive remove ${UNINSTOPT[@]} && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m removed that ${#UNINSTOPT[@]} package in ${base}."
                            return 0   
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to install that packages of ${base}."
                            return 1
                        }
                    elif command -v "doas" &> /dev/null ; then
                        echo -e "\t\033[1;37m==>\033[0m \033[0;34mremoving\033[0m ${#UNINSTOPT[@]} packages in ${base}..."
                        doas zypper --non-interactive remove ${UNINSTOPT[@]} && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m removed that ${#UNINSTOPT[@]} package in ${base}."
                            return 0
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to install that packages of ${base}."
                            return 1
                        }
                    else
                        echo -e "\t\033[1;37m==>\033[0m ${FUNCNAME##*:} \033[0;31mneeds to have\033[0m root privalages, please run it as root."
                        return 2
                    fi
                ;;
                update)
                    if [[ "${UID}" = 0 ]] ; then
                        echo -e "\t\033[1;37m==>\033[0m started to \033[0;34mupdate\033[0m catalogs for ${base}..."
                        zypper --non-interactive update &> /dev/null && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m updated ${base}."
                            return 0   
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to update ${base}."
                            return 1
                        }
                    elif command -v "sudo" &> /dev/null ; then   
                        echo -e "\t\033[1;37m==>\033[0m started to \033[0;34mupdate\033[0m catalogs for ${base}..."
                        sudo zypper --non-interactive update && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m updated ${base}."
                            return 0   
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to update ${base}."
                            return 1
                        }
                    elif command -v "doas" &> /dev/null ; then
                        echo -e "\t\033[1;37m==>\033[0m started to \033[0;34mupdate\033[0m catalogs for ${base}..."
                        doas zypper --non-interactive update && {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;32msuccessfully\033[0m updated ${base}."
                            return 0
                        } || {
                            echo -e "\t\033[1;37m==>\033[0m \033[0;31mfailed\033[0m to update ${base}."
                            return 1
                        }
                    else
                        echo -e "\t\033[1;37m==>\033[0m ${FUNCNAME##*:} \033[0;31mneeds to have\033[0m root privalages, please run it as root."
                        return 2
                    fi
                ;;
            esac        ;;
        unknown)
            echo -e "\t\033[1;37m==>\033[0m \033[0;31munknown\033[0m operating system base."
            return 3
        ;;
    esac
}

opshelper:realpath() {
    # source: https://gist.github.com/lazypwny751/cb3715cd5cff388b8e172f958598c304
    # emulate real path, this function can't show real path only theory.
    if [[ -n "${1}" ]] ; then
        if [[ "${1:0:1}" = "/" ]] ; then
            local CWD=""
        else
            local CWD="${PWD//\// }"
        fi

        local realpath="${1//\// }"
        local i="" markertoken="/"

        for i in ${CWD} ${realpath} ; do
            if [[ "${i}" = "." ]] ; then
                setpath="${setpath}"
            elif [[ "${i}" = ".." ]] ; then
                setpath="${setpath%/*}"
            else
                case "${i}" in
                    ""|" ")
                        :
                    ;;
                    *)
                        setpath+="${markertoken}${i}"
                    ;;
                esac
            fi
        done

        if [[ -z "${setpath}" ]] ; then
            setpath="${markertoken}"
        fi

        echo "${setpath}"
    else
        echo -e "\t${FUNCNAME##*:}: insufficient parameter."
        return 1
    fi
}

opshelper:temp() {
    local DO="file"

    if [[ "${PATH}" = *com.termux* ]] ; then
        local root="/data/data/com.termux/files"
    else
        local root=""
    fi

    while [[ "${#}" -gt 0 ]] ; do
        case "${1}" in
            -[dD]|--[dD][iI][rR][eE][cC][tT][oO][rR][yY])
                shift
            ;;
            -[fF]|--[fF][iI][lL][eE])
                shift
            ;;
            *)
                shift
            ;;
        esac
    done

    case "${DO}" in
        file)
            :
        ;;
        directory)
            :
        ;;
    esac
}

opshelper:check() {
    local status="true"
    while [[ "${#}" -gt 0 ]] ; do
        case "${1}" in
            --command)
                shift
                while [[ "${#}" -gt 0 ]] ; do
                    if ! command -v "${1}" &> /dev/null ; then
                        echo -e "\t${0##*/}: \033[0;31mFATAL\033[0m: ${FUNCNAME##*:}: '${1}' is required, but not found."
                        local status="false"
                    fi
                    shift 
                done
            ;;
            --entity)
                shift
                while [[ "${#}" -ge 0 ]] ; do
                    if [[ -e "${1}" ]] ; then
                        echo -e "\t${0##*/}: \033[0;31mFATAL\033[0m: ${FUNCNAME##*:}: '${1}' doesn't exist."
                        local status="false"
                    fi
                    shift
                done
            ;;
            *)
                shift
            ;;
        esac
    done

    if [[ "${status}" = "false" ]] ; then
        return 1
    fi
}