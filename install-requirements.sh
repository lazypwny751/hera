#!/bin/sh

set -e

if [ -d "pdb" ] ; then
    cd "pdb"
    sh configure.sh
    make install
fi