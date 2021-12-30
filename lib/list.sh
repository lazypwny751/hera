#!/bin/bash

list:installedpkgs() {
    if [[ $(btb:call_value --base-number "${home}/${btb}") != 0 ]] 2> /dev/null ; then 
        btb:call_value --base-contain "${home}/${btb}" | tr -d "/"
    else
        tuiutil:notices --info "you haven't yet any packages"
    fi
}

list:repopkgs() {
    :
}