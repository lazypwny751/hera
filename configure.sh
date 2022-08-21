#!/bin/sh

# defaults
export CWD="${PWD}"
export tab="$(printf '\t')"
export status="true"
if [ "${PATH}" = *com.termux* ] ; then
    export root="/data/data/com.termux/files"
else
    export root=""
fi
export prefix="/usr"

# parsing the options
while [ "${#}" -gt 0 ] ; do
    case "${1}" in
		--root|-r)
            shift
            [ -n "${1}" ] && {
                export root="${1}" 
                shift
            }
        ;;
        --prefix|-p)
            shift
            [ -n "${1}" ] && {
                export prefix="${1}"
                shift
            }
        ;;
        *)
            shift
        ;;
    esac
done

# check requirements
for i in "cpio" "file" "make" "curl" "bash" "install" "mkdir" "cat" "rm" "find" ; do
    if ! command -v "${i}" > /dev/null ; then
        printf "\tconfigure: command: '${i}' not found..\n"
        export status="false"
    fi
done

if [ ! -f "${root}${prefix}/local/lib/bash5/pdb.sh" ] ; then
    if command -v "git" ; then
            git clone "https://github.com/pnmlinux/pdb.git"
    else
        printf "\tconfigure: command: 'git' not found..\n"
        export status="false"
    fi
fi

if [ "${status}" = "false" ] ; then
    exit 1
fi

# create Makefile
cat - > Makefile <<EOF
PREFIX  = ${root}${prefix}
HOMEDIR = \$(PREFIX)/share/hera
LIBDIR  = \$(HOMEDIR)/lib

install:
${tab}bash install-requirements.sh
${tab}mkdir -p \$(LIBDIR)
${tab}cp ./lib/*.sh \$(LIBDIR)
${tab}cp ./etc/herapkg.conf ${root}/etc/herapkg.conf
${tab}install -m 755 ./src/hera.sh \$(PREFIX)/bin/hera

uninstall:
${tab}rm -rf \$(HOMEDIR) \$(PREFIX)/bin/hera ${root}/etc/herapkg.conf

reinstall:
${tab}rm -rf \$(HOMEDIR) \$(PREFIX)/bin/hera ${root}/etc/herapkg.conf
${tab}bash install-requirements.sh
${tab}mkdir -p \$(LIBDIR)
${tab}cp ./lib/*.sh \$(LIBDIR)
${tab}cp ./etc/herapkg.conf ${root}/etc/herapkg.conf
${tab}install -m 755 ./src/hera.sh \$(PREFIX)/bin/hera
EOF
echo "Makefile has been createed. All good.."