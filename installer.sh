#!/bin/bash

#    install and uninstall script for hera - hera package manager 1.0.0
#    Copyright (C) 2021  ByCh4n-Group
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

user="${SUDO_USER:-$USER}"
group=$(cat /etc/group | awk -F: '{ print $1}' | grep -w ${user} || echo "users")

case "${1}" in
    [iI][nN][sS][tT][aA][lL][lL]|--[iI][nN][sS][tT][aA][lL][lL]|-[iI])
        mkdir -p /usr/share/hera/lib /usr/share/hera/repositories /usr/share/licenses/hera /usr/share/doc/hera
        install -m 755 ./lib/*.sh /usr/share/hera/lib
        cp ./repositories.yaml /usr/share/hera
        install -m 755 ./init.sh /usr/share/hera
        install -m 755 ./hera.sh /usr/bin/hera
        cd "/usr/share/hera"
        . ./lib/btb.sh
        btb:generate --bank "packages"
        chown "${user}:${group}" /usr/share/hera/*
        chown "${user}:${group}" /usr/bin/hera
        echo "installation completed"
    ;;
    [uU][nN][iI][nN][sS][tT][aA][lL][lL]|--[uU][nN][iI][nN][sS][tT][aA][lL][lL]|-[uU])
        rm -rf /usr/share/hera /usr/share/licenses/hera /usr/share/doc/hera /usr/bin/hera
        echo "uninstallation completed"
    ;;
    [rR][eE][iI][nN][sS][tT][aA][lL][lL]|--[rR][eE][iI][nN][sS][tT][aA][lL][lL]|-[rR])
        rm -rf /usr/share/hera /usr/share/licenses/hera /usr/share/doc/hera /usr/bin/hera
        mkdir -p /usr/share/hera/lib /usr/share/hera/repositories /usr/share/licenses/hera /usr/share/doc/hera
        install -m 755 ./lib/*.sh /usr/share/hera/lib
        cp ./repositories.yaml /usr/share/hera
        install -m 755 ./init.sh /usr/share/hera
        install -m 755 ./hera.sh /usr/bin/hera
        cd "/usr/share/hera"
        . ./lib/btb.sh
        btb:generate --bank "packages"
        chown "${user}:${group}" /usr/share/hera/*
        chown "${user}:${group}" /usr/bin/hera
        echo "reinstallation completed"
    ;;
esac